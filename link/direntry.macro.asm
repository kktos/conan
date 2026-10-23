/*
 source: https://prodos8.com/docs/techref/file-organization/
*/

.macro writeVolumeEntry name, fileCount
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

	# total blocks 140K
	.WORD 140 * 2
.end

.macro writeFileEntry name, block, fileType, fileAuxType, length
	.BYTE $20 + .len(name)
	.STRING name
	.FILL 15-.len(name)

	# file type
	.BYTE fileType

	# key ptr
	.WORD block

	# blocks used (file length/block size)
	.WORD .ceil(length/512)+1

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

	# dir entry length
	.WORD fileAuxType

	# modification date
	.BYTE $21,(26<<1) & $FF
	# modification time
	.BYTE $07, $13

	# dir block
	.WORD 2
.end
