; disk $E000:EFFF into $9000:9FFF

		.namespace setup_dlg

KS_CHAR		.equ	$1000
KS_LINE		.equ	$1001
KS_BLINK	.equ	$1002
KS_KBD		.equ	$1003
KS_IDX		.equ	$1004
KS_KEYS		.equ	$1084

		; .org $9000

		; .include "data.asm"

;
; called during intro screen if key R is pressed
; dialog to setup keys
;

run
		jsr KS_RUN
L9703		rts

; clear screen lines $BF..0
KS_CLEAR:
		ldx #$c0
L9706	dex
		cpx #$ff
		beq L9703
		; lda hgrAddrLo,x
		lda utils::hgrLow,x
		sta $1a
		; lda hgrAddrHi,x
		lda utils::hgrHigh,x
		sta $1b
		ldy #$28
L9717		dey
		bmi L9706
		lda #$00
		sta ($1a),y
		jmp L9717

KS_RUN		
		jsr KS_CLEAR
		lda #$00
		sta KS_INVERSE
		jsr KS_LABELS
		jsr KS_SHOW_KEYS
		jsr KS_EDIT
		rts

; draw the 16 labels: glyph KS_LBL_GLYPH at (KS_LBL_X, KS_LBL_Y)
KS_LABELS               
		ldy #$10
L9735               dey
		bmi L9750
		sty KS_IDX
		lda KS_LBL_GLYPH,y
		pha
		ldx KS_LBL_X,y
		lda KS_LBL_Y,y
		tay
		pla
		jsr DrawGlyph
		ldy KS_IDX
		jmp L9735

L9750               rts

; show the 11 values (10 keys + the EXIT answer) at column $19, lines KS_ROWS
KS_SHOW_KEYS               
		ldy #$0b
L9753               dey
		bmi L976b
		sty KS_IDX
		lda KS_ROWS,y
		sta KS_LINE
		lda KS_KEYS,y
		jsr KS_PUT_CHAR
		ldy KS_IDX
		jmp L9753

L976b               rts

; edit the 10 keys in turn: each key pressed replaces the entry (ESC keeps it)
KS_EDIT:
		ldy #$00
L976e               sty KS_IDX
		lda KS_KEYS,y
		pha
		lda KS_ROWS,y
		tay
		pla
		jsr KS_GET_KEY
		ldy KS_IDX
		sta KS_KEYS,y
		iny
		cpy #$0a
		bne L976e

; EXIT (Y/N): 'Y' leaves, 'N' or ESC restarts the edit at LEFT
KS_ASK_EXIT:
		ldy #$0a
		lda KS_ROWS,y
		tay
		lda #$ce
		jsr KS_GET_KEY
		cmp #$d9
		beq L97a2
		cmp #$9b
		beq KS_EDIT
		cmp #$ce
		bne KS_ASK_EXIT
		jmp KS_EDIT

L97a2:
		jmp KS_DONE

; A = current value, Y = line: blinking cursor until a key, shows it
; returns the key (or the old value on ESC)
KS_GET_KEY:
		sta KS_CHAR
		sty KS_LINE
		lda #$20
		sta KS_BLINK
		lda sys::KBDSTRB
L97b3               lda sys::KBD
		sta KS_KBD
		jsr KS_CURSOR
		lda KS_KBD
		bpl L97b3
		cmp #$9b
		beq L97cb
		jsr KS_PUT_CHAR
		jmp L97cb

L97cb               lda KS_CHAR
		jsr KS_PUT_CHAR
		lda KS_CHAR
		rts

KS_DONE:
		pla				; drop KS_ASK_EXIT's return: back to TITLE_EXIT | <- $97A2
		pla
		rts

; draw character A at column $19, line KS_LINE: $A0-$DF -> glyph A-$A0,
; control codes $80-$9F -> glyph A-$60 underlined (KS_INVERSE), others -> glyph $40
KS_PUT_CHAR
		ldy #$00
		sty KS_INVERSE
		sta KS_CHAR
		cmp #$a0
		bcs L97f6
		cmp #$80
		bcc L97fa
		ldy #$01
		sty KS_INVERSE
		lda KS_CHAR
		sec
		sbc #$60
		jmp L980a

L97f6               cmp #$e0
		bcc L9804
L97fa               ldy #$00
		sty KS_INVERSE
		lda #$40
		jmp L980a

L9804               lda KS_CHAR
		sec
		sbc #$a0
L980a               ldy KS_LINE
		ldx #$19
		jsr DrawGlyph
		rts

; cursor blink: blank at KS_BLINK=0 (reload $20), character back at $12
KS_CURSOR
		dec KS_BLINK
		lda KS_BLINK
		beq L9820
		cmp #$12
		beq L982b
		rts

L9820               lda #$20
		jsr L980a
		lda #$20
		sta KS_BLINK
		rts

L982b               lda KS_CHAR
		jsr KS_PUT_CHAR
		rts

		    		.db $60

; label columns
KS_LBL_X            
					.hex { 0d 0b 13 12 16 13 13 12 0e 0f 0f 11 10 12 0e 0c }
; label lines
KS_LBL_Y            
					.hex { 00 14 1e 26 2e 36 3e 46 5a 64 6c 74 7c 84 96 ae }
; label glyphs ($41-$50: KEY MODIFICATION, CONAN CONTROLS, LEFT ... <ESC> MOVE CURSOR)
KS_LBL_GLYPH        
					.hex { 42 43 45 46 47 48 49 4a 44 4b 4d 4e 4f 50 4c 41 }
; screen line of each entry: LEFT RIGHT UP DOWN JUMP THROW RE-START SOUND JOY KEYS, EXIT
KS_ROWS              
					.hex { 1e 26 2e 36 3e 46 64 6c 74 7c 97 97 00 }
                    .hex { 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 }
                    .hex { 00 00 00 e0 ff ff 00 00 00 00 00 00 00 00 00 00 }
                    .hex { 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 }
                    .hex { 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 }
                    .hex { 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 }
                    .hex { 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 }
                    .hex { 0a 55 2a 55 2a 55 2a 5e 7a 55 2a 55 02 55 20 55 }
                    .hex { 2a 41 22 55 2a 15 2a 51 2a 55 2a 15 00 00 00 00 }
					.fill 16, $00

; draw glyph A at column X, line Y: width $9A00,A, height $9A80,A, data ($9B00/$9B80),A;
; plain STA (no EOR); with KS_INVERSE the last row is $3F (underline)
DrawGlyph           
					sty KS_GLYPH_Y
                    stx KS_GLYPH_X
                    tay
                    lda KS_GLYPH_WIDTH,y
                    sta KS_GLYPH_W
                    lda KS_GLYPH_HEIGHT,y
                    sta KS_H_LEFT
                    lda KS_GLYPH_PTR_LO,y
                    sta $1c
                    lda KS_GLYPH_PTR_HI,y
                    sta $1d
                    ldx #$00
L991f               ldy KS_GLYPH_Y
                ;     lda hgrAddrLo,y
                    lda utils::hgrLow,y
                    sta $1a
                ;     lda hgrAddrHi,y
                    lda utils::hgrHigh,y
                    sta $1b
                    lda KS_GLYPH_W
                    sta KS_W_LEFT
                    lda KS_GLYPH_X
                    sta KS_COL
L9938               dec KS_W_LEFT
                    bmi L995b
                    ldy KS_COL
                    cpy #$28
                    bcs L994f
                    lda ($1c,x)
                    pha
                    lda KS_INVERSE
                    bne L9967
                    pla
L994d               sta ($1a),y
L994f               inc KS_COL
                    inc $1c
                    bne L9938
                    inc $1d
                    jmp L9938

L995b               dec KS_H_LEFT
                    beq L9966
                    inc KS_GLYPH_Y
                    jmp L991f

L9966               rts

L9967               lda KS_H_LEFT
                    cmp #$01
                    bne L9974
                    pla
                    lda #$3f
                    jmp L994d

L9974               pla
                    jmp L994d

					.hex { 00 00 00 00 00 00 00 00 }
					.hex { 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 }
					.hex { 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 }
					.hex { 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 }
					.hex { 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 }
					.hex { 00 00 00 00 00 00 00 00 d5 a2 d4 8b 00 00 00 00 }
					.hex { 2a 35 0a 25 28 08 30 45 00 28 15 20 05 28 0a 00 }
					.hex { 50 00 50 20 2a 54 46 20 01 28 01 02 00 00 00 00 }

KS_GLYPH_Y               .db $00
KS_GLYPH_X               .db $00
KS_GLYPH_W               .db $00
KS_COL               .db $00
KS_W_LEFT               .db $00
KS_H_LEFT               .hex { 00 00 00 00 00 00 00 00 00 00 }
KS_INVERSE               .db $00 ; 1 = underline the glyph (control-key display)

KS_GLYPH_WIDTH		.hex
		01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01
		01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01
		01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01
		01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01
		01 12 12 10 0d 06 07 03 06 06 07 0a 0b 0a 08 09
		0d 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		.end

KS_GLYPH_HEIGHT		.hex
		06 06 06 06 06 06 06 06 06 06 06 06 06 06 06 06
		06 06 06 06 06 06 06 06 06 06 06 06 06 06 06 06
		06 06 06 06 06 06 06 06 06 06 06 06 06 06 06 06
		06 06 06 06 06 06 06 06 06 06 06 06 06 06 06 06
		06 05 07 07 07 05 05 05 05 05 05 05 07 06 06 06
		05 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		.end

KS_GLYPH_PTR_LO		.hex
		00 06 0c 12 18 1e 24 2a 30 36 3c 42 48 4e 54 5a
		60 66 6c 72 78 7e 84 8a 90 96 9c a2 a8 ae b4 ba
		c0 c6 cc d2 d8 de e4 ea f0 f6 fc 02 08 0e 14 1a
		20 26 2c 32 38 3e 44 4a 50 56 5c 62 68 6e 74 7a
		80 86 e0 5e ce 29 47 6a 79 97 b5 d8 0a 57 93 c3
		f9 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		.end

KS_GLYPH_PTR_HI		.hex
		90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90
		90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90
		90 90 90 90 90 90 90 90 90 90 90 91 91 91 91 91
		91 91 91 91 91 91 91 91 91 91 91 91 91 91 91 91
		91 91 91 92 92 93 93 93 93 93 93 93 94 94 94 94
		94 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		.end
/*
L9c00		.hex
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		2a 55 2a 55 2a 45 2a 55 2c 09 2a 01 2a 55 2a 14
		2a 55 2a 55 2a 55 2a 55 2a 55 0a 01 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 f0 ff ff 81 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		2a 55 2a 45 2a 55 0a 56 16 55 26 55 0a 44 0a 55
		2a 54 2a 55 2a 55 2a 55 2a 55 2a 05 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		.end

L9d00		.hex
		00 00 00 f0 ff ff 81 00 00 00 00 00 00 00 00 d4
		a8 d1 a2 c5 8a 95 aa d4 80 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 a8 81 00 00 00 00 00
		02 05 2a 54 0a 15 3c 53 69 54 5a 54 0a 4d 0a 55
		2a 45 2a 45 2a 51 0a 55 2a 55 49 14 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 97 aa c5 8a 00 00 00 00
		2a 4d 1a 0a 14 08 00 11 00 38 05 28 01 20 29 01
		50 00 50 20 14 55 45 20 01 08 04 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		.end

L9e00		.hex
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 54 2a 55 2a 55 2a 55
		2a 55 4a 50 2a 45 22 45 22 11 22 14 2a 54 6a 00
		50 02 00 00 00 00 00 60 6a 62 55 02 00 00 00 00
		00 00 00 00 00 00 00 00 00 60 43 79 3c 78 70 63
		73 7f 41 73 01 0f 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		20 55 2a 55 2a 55 2a 55 2a 55 2a 55 2a 55 2a 55
		2a 09 00 00 08 00 02 00 20 40 00 10 00 50 00 40
		00 00 00 00 00 00 00 00 00 20 55 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 40 43 03
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		.end

L9f00		.hex
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 2a 55 2a 55 2a 55
		2a 55 2a 55 2a 15 2a 55 2a 55 2a 55 2a 55 2a 55
		2a 04 00 00 00 01 00 00 00 04 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 20 55 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 40 20 00 22
		45 0a 10 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 2a 55 2a 55 2a 55 2a 55
		22 55 2a 51 2a 51 2a 55 2a 55 2a 55 2a 55 2a 45
		2a 55 2a 00 00 00 00 00 00 00 00 00 00 00 00 00
		04 00 00 00 00 44 08 05 00 2a 44 0a 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		.end
*/
		.end namespace
