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


/*
		.if 0
		sta globals::rangeIdx
		tay
		;
		; R0 : background image
		;
		; L0:12 T00S1-8 / M7500-7CFF
		; L1:	T03SE-T04S5 / M7500-7CFF
		; L2:	T05SB-T06S4 / M7500-
		; L3:	T07SF-T08S5 / M7500-
		; L4:	T0BS1-T0BS5 / M7500-
		; L5:	T0ES7-T0FS5 / M7500-
		; L6:	T12S0-T12S5 / M7500-
		; L7:	T15S7-T16S5 / M7500-
		; L8:	T19SC-T1AS5 / M7500-
		; L9:	T1ASF-T00S0 / M7500-
		ldx #$75
		stx rwts_buf+1
		jsr loadRange

		; unpack & display
		jsr unpackToHgr

		; lda #$00
		; ldx #$75
		; jsr unpack.run

		inc globals::rangeIdx
		ldy globals::rangeIdx

		;
		; R1 : data (anim?, sprites)
		;
		; L0:13 T0S9-C / M7500-78FF
		; L1:	T4S6 / M7500-75FF
		; L2:	T6S5 / M7500-75FF
		ldx #$75
		stx rwts_buf+1
		jsr loadRange

		inc globals::rangeIdx
		ldy globals::rangeIdx

		;
		; R2 : data
		;
		; L0:14 T0SD/ M7900-79FF
		; L1:	T4S7/ M7900-79FF
		; L2:	T6S6/ M7900-79FF
		ldx #$79
		stx rwts_buf+1
		jsr loadRange

		inc globals::rangeIdx
		ldy globals::rangeIdx

		;
		; R3 : data
		;
		; L0:15 T0SE-T2SF / M7A00-9BFF
		; L1:	T4S8-T4SF / M7A00-81FF
		; L2:	T6S7-T7S6 / M7A00-89FF
		ldx #$7A
		stx rwts_buf+1
		jsr loadRange

		inc globals::rangeIdx
		ldy globals::rangeIdx

		;
		; R4 : code
		;
		; L0:16 T3S0-T3SB / MA000-ABFF
		; L1:	T5S0-T5S8 / MA000-A7FF
		; L2:	T7S7-T7SC / MA000-A5FF
		ldx #$A0
		stx rwts_buf+1
		jsr loadRange

		inc globals::rangeIdx
		ldy globals::rangeIdx

		;
		; R5 : data
		;
		; L0: T3SC-T3SD / MAC00-ADFF
		; L1: T5S9-T5SA / MAC00-ADFF
		; L2: T7SD-T7SE / MAC00-ADFF
		ldx #$AC
		stx rwts_buf+1
		jsr loadRange
		rts


; 1B1D
readSector	ldx globals::track
		stx rwts_trk
		ldx globals::sector
		stx rwts_sec
		ldx #$00
		stx rwts_vol
		stx $48
		ldy #$e8
		lda #$b7
		jsr rwts
		rts

		.end
*/
