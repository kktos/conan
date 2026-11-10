.include "direntry.macro.asm"

VOLUME_BLOCKS		= 280		# 140K
DIR_FIRST_BLOCK		= 2		# the volume directory is blocks 2 to 5
DIR_LAST_BLOCK		= 5
ENTRIES_PER_BLOCK	= 13
BITMAP_BLOCK		= 6
FIRST_FREE_BLOCK	= 7		# the subdirectories, then the files
# the volume header takes the key block's first entry
MAX_FILES		= (DIR_LAST_BLOCK - DIR_FIRST_BLOCK + 1) * ENTRIES_PER_BLOCK - 1
# tiny-dos only reads the low byte of an index block's entries
MAX_FILE_BLOCK		= 255

.OUTPUT "dist/new_conan.po" FIXED VOLUME_BLOCKS * 512

##
## BOOTLOADER
##

.log "WRITING BOOTLOADER"
.WRITE MODULE("BOOT")

.IF .PC > DIR_FIRST_BLOCK * 512
	.ERROR "The bootloader is " + .hex(.PC) + " bytes: it overwrites the directory, at block " + .str(DIR_FIRST_BLOCK) + "."
.END
.FILL DIR_FIRST_BLOCK * 512 - .PC

##
## LAYOUT
## a module "NAME" is a file of the volume directory, a module "DIR/NAME" the file NAME of its subdirectory DIR
## the subdirectories' blocks, then each file: its index block, then each segment from a block boundary,
## so LoadFromFile can load one
##

# each subdirectory's name, and its entry's index in the volume directory
dirNames = []
dirRootIdx = []
# each file: [name, subdirectory index or -1, data blocks, segments, size]
fileList = []
# the volume directory's entries: [1, subdirectory index] or [0, file index]
rootEntries = []

.FOR module OF .UNWRITTEN_MODULES
	parts = .SPLIT(module.name, "/")
	.IF .LEN(parts) > 2
		.ERROR "'" + module.name + "': tiny-dos' linker only makes one level of subdirectory, DIR/NAME."
	.END

	dirIdx = -1
	.IF .LEN(parts) == 2
		checkProdosName parts[0]
		.FOR d OF dirNames AS i
			.IF d == parts[0]
				dirIdx = i
			.END
		.END
		.IF dirIdx < 0
			dirIdx = .LEN(dirNames)
			dirNames = .PUSH(dirNames, parts[0])
			dirRootIdx = .PUSH(dirRootIdx, .LEN(rootEntries))
			rootEntries = .PUSH(rootEntries, [1, dirIdx])
		.END
	.END
	fileName = parts[.LEN(parts) - 1]
	checkProdosName fileName

	dataBlocks = 0
	.FOR seg OF module.segments
		dataBlocks = dataBlocks + .CEIL(seg.size / 512)
	.END

	.IF dirIdx < 0
		rootEntries = .PUSH(rootEntries, [0, .LEN(fileList)])
	.END
	fileList = .PUSH(fileList, [fileName, dirIdx, dataBlocks, module.segments, module.size])
.END

.IF .LEN(rootEntries) > MAX_FILES
	.ERROR .str(.LEN(rootEntries)) + " files and directories: the volume directory holds " + .str(MAX_FILES) + "."
.END

# subdirectories: [name, key block, blocks, entries ([0, file index]), parent block, parent entry number]
nextBlock = FIRST_FREE_BLOCK
dirs = []
.FOR dirName OF dirNames AS d
	entries = []
	.FOR file OF fileList AS f
		.IF file[1] == d
			entries = .PUSH(entries, [0, f])
		.END
	.END
	# the header takes the key block's first entry
	dirBlocks = .CEIL((.LEN(entries) + 1) / ENTRIES_PER_BLOCK)
	# its entry in the volume directory, numbered from 1 in its block, the volume header being the key block's 1
	slot = dirRootIdx[d] + 1
	dirs = .PUSH(dirs, [dirName, nextBlock, dirBlocks, entries, DIR_FIRST_BLOCK + .FLOOR(slot / ENTRIES_PER_BLOCK), slot % ENTRIES_PER_BLOCK + 1])
	nextBlock = nextBlock + dirBlocks
.END

# files: [name, index block, data blocks, segments, size, its directory's key block]
files = []
.FOR file OF fileList
	dirKeyBlock = DIR_FIRST_BLOCK
	.IF file[1] >= 0
		dirKeyBlock = dirs[file[1]][1]
	.END
	files = .PUSH(files, [file[0], nextBlock, file[2], file[3], file[4], dirKeyBlock])
	nextBlock = nextBlock + 1 + file[2]
.END

.IF nextBlock - 1 > MAX_FILE_BLOCK
	.ERROR "The files end at block " + .hex(nextBlock - 1) + ": tiny-dos only reads blocks up to " + .hex(MAX_FILE_BLOCK) + "."
.END

##
## DIRECTORY
##

.log "WRITING DIRECTORY"
.log .pad("#",-4) + .pad("Block",-7) + .pad("Offset",-9) + .pad("Size",-7) + .pad("BlkLen",7) + "  Name"

writeVolumeEntry "CONAN", .LEN(rootEntries), VOLUME_BLOCKS
writeDirEntries rootEntries, DIR_FIRST_BLOCK, DIR_LAST_BLOCK - DIR_FIRST_BLOCK + 1, ""

##
## BITMAP
##

.IF .PC != BITMAP_BLOCK * 512
	.ERROR "The bitmap is at " + .hex(.PC) + ", not at block " + .str(BITMAP_BLOCK) + "."
.END
.FILL 512

##
## SUBDIRECTORIES
##

.FOR dir OF dirs
	.IF .PC != dir[1] * 512
		.ERROR "Directory '" + dir[0] + "' is at " + .hex(.PC) + ", its directory entry says block " + .hex(dir[1]) + "."
	.END
	writeSubdirHeader dir[0], .LEN(dir[3]), dir[2], dir[4], dir[5]
	writeDirEntries dir[3], dir[1], dir[2], dir[0] + "/"
.END

##
## FILES
##

.log "\nWRITING FILES"
.FOR file OF files
	name = file[0]
	block = file[1]
	dataBlocks = file[2]
	segments = file[3]

	.log "--FILE", name, block, dataBlocks
	.IF .PC != block * 512
		.ERROR "File '" + name + "' is at " + .hex(.PC) + ", its directory entry says block " + .hex(block) + "."
	.END

	# index block: its data blocks follow it
	.REPEAT dataBlocks AS idx
		.BYTE block + idx
	.END
	.ALIGN 512

	.FOR seg OF segments
		.log "  " + seg.name, .hex(seg.size,4)
		.WRITE SEGMENT(seg.name)
		.ALIGN 512
	.END
.END
