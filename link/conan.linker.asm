.include "direntry.macro.asm"

.OUTPUT "dist/new_conan.po" FIXED 140 * 1024

.ENDIAN BIG

##
## BOOTLOADER
##

.log "WRITING BOOTLOADER"
.WRITE MODULE("BOOT")

.ALIGN 512

##
## DIRECTORY
##

.log "WRITING DIRECTORY"

entryCount = 0
block = 2

# BLOCK 2

writeVolumeEntry "CONAN", .LEN(.UNWRITTEN_MODULES)
entryCount = entryCount + 1

freeBlock= $07
files= []

.log "#","  Block", "Offset", "Size", "BlkLen", "Name"
.FOR module OF .UNWRITTEN_MODULES as idx
	entryCount = entryCount + 1

	.log .hex(entryCount), "  "+.hex(freeBlock,4), .hex(freeBlock*512,6), .hex(module.size,4), .ceil(module.size/512+1), module.name

	writeFileEntry module.name, freeBlock, $06, module.segments[0].start, module.size

	files = .PUSH(files, [module.name, freeBlock, .CEIL(module.size / 512), module.segments])
	freeBlock = freeBlock + .CEIL(module.size / 512) + 1

	.if entryCount == $0d
		entryCount = -1
		.ALIGN 512
		.WORD block
		.WORD block + 2
		block = block + 1
	.end
.END

.ALIGN 512

.if block<6
	.repeat 5-block
		.WORD block
		.WORD .IIF(block<4, block + 2, 0)
		.ALIGN 512
		block = block + 1
	.end
.end

# BLOCK 6
.FILL 512


freeBlock= $07

##
## FILES
##

.log "\nWRITING FILES"
.FOR file OF files as idx
	name= file[0]
	block= file[1]
	blockLen= file[2]
	segments= file[3]

	.log "--FILE", name, block, blockLen

	blocks= ""
	.REPEAT blockLen as idx
		.BYTE block + idx
		blocks=blocks+", "+.hex((block + idx) * 512)
	.END
	#.log blocks
	.ALIGN 512

	.FOR seg OF segments as idx
		.log "  " + seg.name, .hex(seg.size,4)
		.WRITE SEGMENT(seg.name)
		.ALIGN 512
	.END
.END
