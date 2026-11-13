		.if	loadLevel
			.out	"loadLevel : ",.hex(loadLevel)
		.end

loadLevel:
		stx	globals::L0381
; 		lda #$00
; L1a3c		dex
; 		bmi init2

; 		clc
; 		adc #$06
; 		jmp L1a3c

; load welcome screen
; 1A45
;init2
		txa
		clc
		adc	#$30
		sta	fbkgnd+2
		sta	fdata+2
		sta	fcode+2
		sta	fbitmap+2

		dosLoadFile	fbkgnd

		; unpack & display
		; jsr unpackToHgr
		lda	#$00
		ldx	#$75
		ldy	#183
		jsr	unpack::run

		dosLoadFile	fdata
		dosLoadFile	fcode

		; only level 0 has a bitmap
		lda	globals::L0381
		bne	:+
		dosLoadFile	fbitmap
:
		rts

fbkgnd		.pstr	"L0/BKGD"
fdata		.pstr	"L0/DATA"
fcode		.pstr	"L0/CODE"
fbitmap		.pstr	"L0/BMP"
