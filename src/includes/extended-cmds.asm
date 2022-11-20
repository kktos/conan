
	.macro MVPw src, dst, len
		; WDM MVP.w
		.db $42, $44
		; SRC
		.dw src
		; DST
		.dw dst
		; LEN
		.dw len
	.end

	.macro read_diskw trk_sec, dst, len
		; WDM disk_read
		.db $42, $01
		; TRK_SEC
		.dw trk_sec
		; DST_MEM
		.dw dst
		; LEN
		.dw len

!		bit $C0FF
		bpl !-
	.end

	.macro read_file filename
		; WDM disk_read_file
		.db $42, $11
		.dw filename

!		bit $C0FF
		bpl !-
	.end

	.macro log fmt, parm1
		.db $42,$FF
		.db fmt
		.db 1
		.dw parm1
	.end
