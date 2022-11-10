		.namespace boot3

		.export BOOT3
		.export enterwts
		.export rwts_buf
		.export rwts_slot
		.export rwts_vol
		.export rwts_trk
		.export rwts_sec

LA000		= $A000

		.org $B700

;
; load T1S0-T1S1 -> $0200:03FF
;

BOOT3:
		ldx #$02
		stx rwts_buf+1
		ldx #$01
		stx rwts_trk
		stx rwts_cmd
		dex
		stx rwts_sec
		stx $48
		stx rwts_vol
		ldy #<rwts_iob
		lda #>rwts_iob
		jsr enterwts

		inc rwts_sec
		inc rwts_buf+1
		ldx #$00
		stx $48
		ldy #<rwts_iob
		lda #>rwts_iob
		jsr enterwts

		jmp welcome.main



Lb731		lda #$00
		sta rwts_cmd
		lda #$10
		sta rwts_trk
		ldy #<rwts_iob
		lda #>rwts_iob
		jsr enterwts

		lda $c089,x
		lda #$01
		sta rwts_cmd
		ldy #$ff
		sty Lb7ab
Lb74f		inc Lb7ab
		lda #$00
		sta $3e
		sta $3f
		sta $48
Lb75a		ldy #$04
		dec $3e
		bne Lb764
		dec $3f
		beq Lb794
Lb764		lda $c08c,x
		nop
		bpl Lb764
		cmp Lb7a5,y
		bne Lb75a
		dey
		bpl Lb764
		ldy #$08
Lb774		lda $c08c,x
		sta $2c
		bpl Lb774
		dey
		bne Lb774
		jsr Sb7ac
		ldy Lb7ab
		bne Lb78b
		sta Lb7aa
		beq Lb74f
Lb78b		cmp Lb7aa
		bne Lb79f
		cpy #$18
		bne Lb74f
Lb794		tsx
		lda #$be
		sta $0102,x
		lda #$ae
		jmp $bfc8

Lb79f		ldy $c088,x
		jmp LA000

Lb7a5
		.DB $ad
		.DB $bd
		.DB $ba
		.DB $b7
		.DB $d5
Lb7aa
		.DB $00
Lb7ab
		.DB $00

Sb7ac		lda $c08c,x
		nop
		bpl Sb7ac
		rts

		.DB $df, $60

enterwts	php
		sei
		jsr rwts
		bcs Lb7bf
		plp
		clc
		rts

Lb7bf		plp
		sec
		rts

Lb7c2		lda $b5bc
		sta rwts_buf+1
		lda #$00
		sta rwts_buf
		lda $b5f9
		eor #$ff
		sta rwts_vol
		rts

Lb7d6		lda #$00
		tay
Lb7d9		sta ($42),y
		iny
		bne Lb7d9
		rts

		.DB $00, $1b, $02, $0a, $1b, $e8, $b7, $00, $b6

;01:$B7E9: SLOT
;02:$B7EA: DRIVE NUMBER TO USE
;03:$B7EB: VOLUME NUMBER ($OO=ANYTHING)
;04:$B7EC: TRACK NUMBER TO READ
;05:$B7ED: SECTOR NUMBER TO READ
;08:$B7FO: LO-BYTE OF BUFFER TO READ/WRITE
;09:$B7F1: HI-BYTE OF BUFFER TO READ/WRITE
;0A:$B7F2:
;0B:$B7F3: PARTIAL SECI'OR READ(O=WHOLE SCT)
;0C:$B7F4: COMMAND CODE (O=SEEK, l=RD, 2=WRr)
;0D:$B7F5: ERROR CODE (VALID IF CARRY SET)

rwts_iob:
		.DB $01
rwts_slot 	.DB $60
rwts_drv       	.DB $01
rwts_vol       	.DB $fe
rwts_trk       	.DB $00
rwts_sec       	.DB $01

rwts_dtab    	.dw LB7FB
rwts_buf     	.dw $B700

		.DB $00
		.DB $00
rwts_cmd       	.DB $02
rwts_err       	.DB $03
rwts_lstvol    	.DB $fe
rwts_lstslot   	.DB $60
rwts_lstdrv    	.DB $01
; $B7F9
		.DB $00, $00
; $B7FB
LB7FB		.DB $00, $01
; $B7FD
		.dw $D8EF
		.db $00



