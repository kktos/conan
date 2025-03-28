; disk $E000:EFFF into $9000:9FFF

		.namespace setup_dlg

L1000		=	$1000
L1001		=	$1001
L1002		=	$1002
L1003		=	$1003
L1004		=	$1004
L1084		=	$1084

		; .org $9000

		; .include "data.asm"

;
; called during intro screen if key R is pressed
; dialog to setup keys
;

run
		jsr S9721
L9703		rts

S9704		ldx #$c0
L9706		dex
		cpx #$ff
		beq L9703
		; lda hgrAddrLo,x
		lda utils.hgrLow,x
		sta $1a
		; lda hgrAddrHi,x
		lda utils.hgrHigh,x
		sta $1b
		ldy #$28
L9717		dey
		bmi L9706
		lda #$00
		sta ($1a),y
		jmp L9717

S9721		jsr S9704
		lda #$00
		sta L99ff
		jsr S9733
		jsr S9751
		jsr S976c
		rts

S9733               ldy #$10
L9735               dey
		bmi L9750
		sty L1004
		lda L9853,y
		pha
		ldx L9833,y
		lda L9843,y
		tay
		pla
		jsr S9900
		ldy L1004
		jmp L9735

L9750               rts

S9751               ldy #$0b
L9753               dey
		bmi L976b
		sty L1004
		lda L9863,y
		sta L1001
		lda L1084,y
		jsr S97d8
		ldy L1004
		jmp L9753

L976b               rts

S976c               ldy #$00
L976e               sty L1004
		lda L1084,y
		pha
		lda L9863,y
		tay
		pla
		jsr S97a5
		ldy L1004
		sta L1084,y
		iny
		cpy #$0a
		bne L976e
L9788               ldy #$0a
		lda L9863,y
		tay
		lda #$ce
		jsr S97a5
		cmp #$d9
		beq L97a2
		cmp #$9b
		beq S976c
		cmp #$ce
		bne L9788
		jmp S976c

L97a2               jmp L97d5

S97a5               sta L1000
		sty L1001
		lda #$20
		sta L1002
		lda sys.KBDSTRB
L97b3               lda sys.KBD
		sta L1003
		jsr S9813
		lda L1003
		bpl L97b3
		cmp #$9b
		beq L97cb
		jsr S97d8
		jmp L97cb

L97cb               lda L1000
		jsr S97d8
		lda L1000
		rts

L97d5               pla
		pla
		rts

S97d8               ldy #$00
		sty L99ff
		sta L1000
		cmp #$a0
		bcs L97f6
		cmp #$80
		bcc L97fa
		ldy #$01
		sty L99ff
		lda L1000
		sec
		sbc #$60
		jmp L980a

L97f6               cmp #$e0
		bcc L9804
L97fa               ldy #$00
		sty L99ff
		lda #$40
		jmp L980a

L9804               lda L1000
		sec
		sbc #$a0
L980a               ldy L1001
		ldx #$19
		jsr S9900
		rts

S9813               dec L1002
		lda L1002
		beq L9820
		cmp #$12
		beq L982b
		rts

L9820               lda #$20
		jsr L980a
		lda #$20
		sta L1002
		rts

L982b               lda L1000
		jsr S97d8
		rts

L9832               rts

L9833               .hex 0d 0b 13 12 16 13 13 12 0e 0f 0f 11 10 12 0e 0c
L9843               .hex 00 14 1e 26 2e 36 3e 46 5a 64 6c 74 7c 84 96 ae
L9853               .hex 42 43 45 46 47 48 49 4a 44 4b 4d 4e 4f 50 4c 41
L9863               .hex 1e 26 2e 36 3e 46 64 6c 74 7c 97 97 00
                    .hex 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    .hex 00 00 00 e0 ff ff 00 00 00 00 00 00 00 00 00 00
                    .hex 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    .hex 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    .hex 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    .hex 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    .hex 0a 55 2a 55 2a 55 2a 5e 7a 55 2a 55 02 55 20 55
                    .hex 2a 41 22 55 2a 15 2a 51 2a 55 2a 15 00 00 00 00
                    .hex 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

S9900               sty L99f0
                    stx L99f1
                    tay
                    lda L9a00,y
                    sta L99f2
                    lda L9a80,y
                    sta L99f5
                    lda L9b00,y
                    sta $1c
                    lda L9b80,y
                    sta $1d
                    ldx #$00
L991f               ldy L99f0
                ;     lda hgrAddrLo,y
                    lda utils.hgrLow,y
                    sta $1a
                ;     lda hgrAddrHi,y
                    lda utils.hgrHigh,y
                    sta $1b
                    lda L99f2
                    sta L99f4
                    lda L99f1
                    sta L99f3
L9938               dec L99f4
                    bmi L995b
                    ldy L99f3
                    cpy #$28
                    bcs L994f
                    lda ($1c,x)
                    pha
                    lda L99ff
                    bne L9967
                    pla
L994d               sta ($1a),y
L994f               inc L99f3
                    inc $1c
                    bne L9938
                    inc $1d
                    jmp L9938

L995b               dec L99f5
                    beq L9966
                    inc L99f0
                    jmp L991f

L9966               rts

L9967               lda L99f5
                    cmp #$01
                    bne L9974
                    pla
                    lda #$3f
                    jmp L994d

L9974               pla
                    jmp L994d

		.hex 00 00 00 00 00 00 00 00
                    .hex 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    .hex 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    .hex 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    .hex 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    .hex 00 00 00 00 00 00 00 00 d5 a2 d4 8b 00 00 00 00
                    .hex 2a 35 0a 25 28 08 30 45 00 28 15 20 05 28 0a 00
                    .hex 50 00 50 20 2a 54 46 20 01 28 01 02 00 00 00 00
L99f0               .hex 00
L99f1               .hex 00
L99f2               .hex 00
L99f3               .hex 00
L99f4               .hex 00
L99f5               .hex 00 00 00 00 00 00 00 00 00 00
L99ff               .hex 00

L9a00		.hex
		01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01
		01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01
		01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01
		01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01
		01 12 12 10 0d 06 07 03 06 06 07 0a 0b 0a 08 09
		0d 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		.end

L9a80		.hex
		06 06 06 06 06 06 06 06 06 06 06 06 06 06 06 06
		06 06 06 06 06 06 06 06 06 06 06 06 06 06 06 06
		06 06 06 06 06 06 06 06 06 06 06 06 06 06 06 06
		06 06 06 06 06 06 06 06 06 06 06 06 06 06 06 06
		06 05 07 07 07 05 05 05 05 05 05 05 07 06 06 06
		05 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		.end

L9b00		.hex
		00 06 0c 12 18 1e 24 2a 30 36 3c 42 48 4e 54 5a
		60 66 6c 72 78 7e 84 8a 90 96 9c a2 a8 ae b4 ba
		c0 c6 cc d2 d8 de e4 ea f0 f6 fc 02 08 0e 14 1a
		20 26 2c 32 38 3e 44 4a 50 56 5c 62 68 6e 74 7a
		80 86 e0 5e ce 29 47 6a 79 97 b5 d8 0a 57 93 c3
		f9 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		.end

L9b80		.hex
		90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90
		90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90
		90 90 90 90 90 90 90 90 90 90 90 91 91 91 91 91
		91 91 91 91 91 91 91 91 91 91 91 91 91 91 91 91
		91 91 91 92 92 93 93 93 93 93 93 93 94 94 94 94
		94 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		.end

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

		.end namespace
