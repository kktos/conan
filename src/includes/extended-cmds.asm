
	.macro MVPw src,dst,len
		; WDM MVP.w
		.db $42, $44
		; SRC
		.dw src
		; DST
		.dw dst
		; LEN
		.dw len
	.end
