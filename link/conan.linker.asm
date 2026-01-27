.include "direntry.macro.asm"

.OUTPUT "dist/game.po" FIXED 140 * 1024

.ENDIAN BIG

##
## BOOTLOADER
##

.log "WRITING BOOTLOADER"
.WRITE MODULE("BOOT")

##
## DIRECTORY
##

.log "WRITING DIRECTORY"

# BLOCK 2

writeVolumeEntry "CONAN", .LEN(.UNWRITTEN_MODULES)

freeBlock= $07
files= []

.FOR module OF .UNWRITTEN_MODULES as idx
	.log "  " + module.name, .hex(freeBlock)

	writeFileEntry module.name, freeBlock, $06, module.segments[0].start, module.size

	files = .PUSH(files, [module.name, freeBlock, module.size / 512, module.segments])
	freeBlock = freeBlock + (module.size / 512) + 1
.END

.ALIGN 512

# BLOCK 3
.WORD 2
.WORD 4
.ALIGN 512

# BLOCK 4
.WORD 3
.WORD 5
.ALIGN 512

# BLOCK 5
.WORD 4
.WORD 0
.ALIGN 512

# BLOCK 6
.FILL 512


freeBlock= $07

##
## FILES
##

.log "WRITING FILES"
.FOR file OF files as idx
	name= file[0]
	block= file[1]
	blockLen= file[2]
	segments= file[3]

	.log "--FILE", name, .hex(block), .hex(block*512), blockLen

	blocks= ""
	.REPEAT blockLen as idx
		.BYTE block + idx
		blocks=blocks+", "+.hex((block + idx) * 512)
	.END
	.log blocks
	.ALIGN 512

	.FOR seg OF segments as idx
		.log seg.name
		.WRITE SEGMENT(seg.name)
	.END
.END



#segOffsets = []

#.log ""
#.log "Offset   ", "Name"

# Emit in declaration order
#.FOR seg OF .UNWRITTEN_SEGMENTS as idx
#	segOffsets = .PUSH(segOffsets,.PC)
#
#	.log .hex(.pc,8), seg.name
#
#	.WRITE SEGMENT(seg.name)
#.END

# directoryStart = .PC


#
# Build the directory
#

# .SEGMENT directory AT .IMAGE_END
#
# .WORD .LEN(segments)
#
# .FOR seg OF segments AS idx
#     .PSTRING seg.name
#     .LONG segOffsets[idx]
#     .LONG seg.size
#     .LONG seg.start
# .END
#
# .LONG directoryStart
# .STRING "DISK"
