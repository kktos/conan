/*
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

:		bit $C0FF
		bpl :-
	.end

; 	.macro dosLoadFile(filename) {
; 		; WDM disk_read_file
; 		.db $42, $11
; 		.dw filename

; :		bit $C0FF
; 		bpl :-
; 	}

	.macro log(fmt, parm1) {
		.db $42,$FF
		.cstr fmt
		.db 1
		.dw parm1
	}
*/
	.macro dosLoadFile(filename) {
		ldx #<filename
		ldy #>filename
		jsr tinyDOS::LoadFile
	}

	.macro dosLoadFromFile(params) {
		ldx #<params
		ldy #>params
		jsr tinyDOS::LoadFromFile
	}

	.macro addMemRegion(filename, addr, len, bank) {
		BRK $03
		.dw addr
		.dw len
		.dw filename
		.dw bank
	}

	.macro delRegions(...list) {
		brk
		.db $04
		.db .len(list)

		.for name of list as idx {
			.dw .label("region" + .str(idx))
		}

		bra :+

		.for name of list as idx {
			.let "region" + .str(idx) = *
			.cstr name
		}

:
	}

