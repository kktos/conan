.include "direntry.macro.asm"

VOLUME_BLOCKS		= 280		# 140K
DIR_FIRST_BLOCK		= 2		# the volume directory is blocks 2 to 5
DIR_LAST_BLOCK		= 5
ENTRIES_PER_BLOCK	= 13
BITMAP_BLOCK		= 6
FIRST_FILE_BLOCK	= 7
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
## each file: [name, index block, data blocks, segments, size]
## its index block, then each segment from a block boundary, so LoadFromFile can load one
##

files = []
nextBlock = FIRST_FILE_BLOCK
.FOR module OF .UNWRITTEN_MODULES
	checkProdosName module.name

	dataBlocks = 0
	.FOR seg OF module.segments
		dataBlocks = dataBlocks + .CEIL(seg.size / 512)
	.END

	files = .PUSH(files, [module.name, nextBlock, dataBlocks, module.segments, module.size])
	nextBlock = nextBlock + 1 + dataBlocks
.END

.IF .LEN(files) > MAX_FILES
	.ERROR .str(.LEN(files)) + " files: the volume directory holds " + .str(MAX_FILES) + "."
.END
.IF nextBlock - 1 > MAX_FILE_BLOCK
	.ERROR "The files end at block " + .hex(nextBlock - 1) + ": tiny-dos only reads blocks up to " + .hex(MAX_FILE_BLOCK) + "."
.END

##
## DIRECTORY
##

.log "WRITING DIRECTORY"

writeVolumeEntry "CONAN", .LEN(files), VOLUME_BLOCKS

dirBlock = DIR_FIRST_BLOCK
entry = 1

.log .pad("#",-4) + .pad("Block",-7) + .pad("Offset",-9) + .pad("Size",-7) + .pad("BlkLen",7) + "  Name"
.FOR file OF files AS idx FROM 1
	# a full block: start the next one, linked to its neighbours
	.IF entry == ENTRIES_PER_BLOCK
		.ALIGN 512
		dirBlock = dirBlock + 1
		.WORD dirBlock - 1
		.WORD .IIF(dirBlock < DIR_LAST_BLOCK, dirBlock + 1, 0)
		entry = 0
	.END

	.log .pad(.hex(idx),-4) + .pad(.hex(file[1],4),-7) + .pad(.hex(file[1]*512,6),-9) + .pad(.hex(file[4],4),-7) + .pad(file[2] + 1,7) + "  " + file[0]

	writeFileEntry file[0], file[1], file[2], $06, file[3][0].start, file[4]
	entry = entry + 1
.END

.ALIGN 512

# the directory's unused blocks
.REPEAT DIR_LAST_BLOCK - dirBlock
	dirBlock = dirBlock + 1
	.WORD dirBlock - 1
	.WORD .IIF(dirBlock < DIR_LAST_BLOCK, dirBlock + 1, 0)
	.ALIGN 512
.END

##
## BITMAP
##

.IF .PC != BITMAP_BLOCK * 512
	.ERROR "The bitmap is at " + .hex(.PC) + ", not at block " + .str(BITMAP_BLOCK) + "."
.END
.FILL 512

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
