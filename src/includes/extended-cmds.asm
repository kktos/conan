
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
		; WDM MVP.w
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
