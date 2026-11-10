/*
 source: https://prodos8.com/docs/techref/file-organization/
 ProDOS is little-endian: the script must not set .ENDIAN BIG.
*/

# A ProDOS file name: 1 to 15 characters, a letter first, then letters, digits or periods.
.macro checkProdosName name
	.IF .len(name) < 1 || .len(name) > 15
		.ERROR "'" + name + "' isn't a ProDOS file name: it has 1 to 15 characters."
	.END
	.FOR c OF .split(name, "") AS i
		.IF !((c >= "A" && c <= "Z") || (i > 0 && ((c >= "0" && c <= "9") || c == ".")))
			.ERROR "'" + name + "' isn't a ProDOS file name: a letter first, then letters, digits or periods."
		.END
	.END
.end

.macro writeVolumeEntry name, fileCount, totalBlocks
	.WORD 0 	# previous dir block
	.WORD 3 	# next dir block

	.BYTE $F0 + .len(name)
	.STRING name
	.FILL 15-.len(name)

	.FILL 8

	# creation date
	.BYTE $9D,$2F
	# creation time
	.BYTE $07, $13

	# version, min version
	.BYTE $00, $00

	# access flags
	.BYTE $C3

	# dir entry length
	.BYTE $27

	# dir entry count per block
	.BYTE $0D

	# file count
	.WORD fileCount

	# bitmap pointer
	.WORD $0006

	# total blocks
	.WORD totalBlocks
.end

# A sapling file: its index block at `block`, then `dataBlocks` data blocks.
.macro writeFileEntry name, block, dataBlocks, fileType, fileAuxType, length, headerPtr
	.BYTE $20 + .len(name)
	.STRING name
	.FILL 15-.len(name)

	# file type
	.BYTE fileType

	# key ptr
	.WORD block

	# blocks used: the index block and the data blocks
	.WORD dataBlocks + 1

	# EOF
	.BYTE length & 0xFF, length >> 8 & 0xFF, length >> 16 & 0xFF

	# creation date
	.BYTE $9D,$2F
	# creation time
	.BYTE $07, $13

	# version, min version
	.BYTE $00, $00

	# access flags Destroy/Rename/Backup/000/Write/Read
	.BYTE %0_0_0_000_0_1

	# aux type: the load address
	.WORD fileAuxType

	# modification date
	.BYTE $21,(26<<1) & $FF
	# modification time
	.BYTE $07, $13

	# header pointer: the directory's key block
	.WORD headerPtr
.end

# A subdirectory's entry in its parent: its key block at `block`, `blocks` blocks long.
.macro writeSubdirEntry name, block, blocks, headerPtr
	.BYTE $D0 + .len(name)
	.STRING name
	.FILL 15-.len(name)

	# file type: directory
	.BYTE $0F

	# key ptr
	.WORD block

	# blocks used
	.WORD blocks

	# EOF
	.BYTE 0, (blocks * 512) >> 8 & 0xFF, (blocks * 512) >> 16 & 0xFF

	# creation date
	.BYTE $9D,$2F
	# creation time
	.BYTE $07, $13

	# version, min version
	.BYTE $00, $00

	# access flags
	.BYTE $C3

	# aux type
	.WORD 0

	# modification date
	.BYTE $21,(26<<1) & $FF
	# modification time
	.BYTE $07, $13

	# header pointer: the parent directory's key block
	.WORD headerPtr
.end

# A subdirectory's key block start: its links, then its header, at a block boundary.
# Its entry in its parent is entry number `parentEntry` (from 1) of block `parentBlock`.
.macro writeSubdirHeader name, fileCount, blocks, parentBlock, parentEntry
	.WORD 0 	# previous dir block
	.WORD .IIF(blocks > 1, .PC / 512 + 1, 0)	# next dir block

	.BYTE $E0 + .len(name)
	.STRING name
	.FILL 15-.len(name)

	# reserved: $75 for ProDOS
	.BYTE $75
	.FILL 7

	# creation date
	.BYTE $9D,$2F
	# creation time
	.BYTE $07, $13

	# version, min version
	.BYTE $00, $00

	# access flags
	.BYTE $C3

	# dir entry length
	.BYTE $27

	# dir entry count per block
	.BYTE $0D

	# file count
	.WORD fileCount

	# parent pointer, parent entry number, parent entry length
	.WORD parentBlock
	.BYTE parentEntry
	.BYTE $27
.end

# A directory's entries, after its header: `entries` are [1, subdirectory index in `dirs`] or [0, file index in `files`].
# The directory is `blockCount` blocks from `keyBlock`, linked to their neighbours.
.macro writeDirEntries entries, keyBlock, blockCount, prefix
	# a variable: an argument is evaluated where it's used, in writeFileEntry it would be unknown
	_wdeKeyBlock = keyBlock
	_wdeBlock = keyBlock
	_wdeSlot = 1
	.FOR _wdeEntry OF entries
		# a full block: start the next one
		.IF _wdeSlot == ENTRIES_PER_BLOCK
			.ALIGN 512
			_wdeBlock = _wdeBlock + 1
			.WORD _wdeBlock - 1
			.WORD .IIF(_wdeBlock < keyBlock + blockCount - 1, _wdeBlock + 1, 0)
			_wdeSlot = 0
		.END

		.IF _wdeEntry[0]
			_wdeDir = dirs[_wdeEntry[1]]
			.log .pad("",-4) + .pad(.hex(_wdeDir[1],4),-7) + .pad(.hex(_wdeDir[1]*512,6),-9) + .pad("DIR",-7) + .pad(_wdeDir[2],7) + "  " + prefix + _wdeDir[0] + "/"
			writeSubdirEntry _wdeDir[0], _wdeDir[1], _wdeDir[2], _wdeKeyBlock
		.ELSE
			_wdeFile = files[_wdeEntry[1]]
			.log .pad(.hex(_wdeEntry[1]+1),-4) + .pad(.hex(_wdeFile[1],4),-7) + .pad(.hex(_wdeFile[1]*512,6),-9) + .pad(.hex(_wdeFile[4],4),-7) + .pad(_wdeFile[2] + 1,7) + "  " + prefix + _wdeFile[0]
			writeFileEntry _wdeFile[0], _wdeFile[1], _wdeFile[2], $06, _wdeFile[3][0].start, _wdeFile[4], _wdeKeyBlock
		.END
		_wdeSlot = _wdeSlot + 1
	.END
	.ALIGN 512

	# the directory's unused blocks
	.REPEAT keyBlock + blockCount - 1 - _wdeBlock
		_wdeBlock = _wdeBlock + 1
		.WORD _wdeBlock - 1
		.WORD .IIF(_wdeBlock < keyBlock + blockCount - 1, _wdeBlock + 1, 0)
		.ALIGN 512
	.END
.end
