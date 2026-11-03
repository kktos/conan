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
.macro writeFileEntry name, block, dataBlocks, fileType, fileAuxType, length
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
	.WORD 2
.end
