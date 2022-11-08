		.org $A000

	.macro drawSprite id,x,y
		ldx #x
		ldy #y
		lda #id
		jsr spritelib.drawSprite
	.end

LA000      	jmp start

drawSpriteBis 	sty yPos
		tay
		lda spritelib.spriteLo-1,y
		sta $1c
		lda spritelib.spriteHi-1,y
		sta $1d
		ldy #$00
		sty spritelib.LB3F7
		lda ($1c),y
		sta spritelib.dsWidth
		sta spritelib.dsWidthInit
		iny
		lda ($1c),y
		sta spritelib.dsHeight
		stx Ypos
		bpl !+

		inc spritelib.LB3F7
		and #$7f
		sta spritelib.dsHeight
		lda spritelib.LB200,x
		asl
		clc
		adc #$02
		tay
		lda ($1c),y
		sta pixels
		iny
		lda ($1c),y
		sta pixels+1
		jmp La05a

!	     	lda spritelib.LAF00,x
		asl
		clc
		adc #$02
		tay
		lda ($1c),y
		sta pixels
		iny
		lda ($1c),y
		sta pixels+1

La05a       	ldy yPos
		lda spritelib.hgrLo,y
		sta $1c
		lda spritelib.hgrHi,y
		sta $1d
		ldx Ypos
		ldy spritelib.LB3F7
		beq !+

		lda spritelib.LB000,x
		tay
		jmp La07a

!	      	lda spritelib.LB100,x
		tay

La07a       	cpy #40
		bcs !+

pixels=*+1
		lda $ffff
		sta ($1c),y
!	   	inc pixels
		bne !+

		inc pixels+1
!	      	iny
		cpy #74
		bne !+

		ldy #$00
!               dec spritelib.dsWidth
		bne La07a

		ldx spritelib.dsWidthInit
		stx spritelib.dsWidth
		dec spritelib.dsHeight
		beq !+
		inc yPos
		jmp La05a

!		rts

; title screen / conan jumping over spring / hi-score
start               bit sys.KBDSTRB
                    jsr Sa379

La0af               jsr animConanJump
                    jsr exitOnEvent
                    jsr drawHiScore

                    ldx #$30
                    jsr checkUserInput

                    jsr drawHiScore
                    jsr animConanJump
                    jsr exitOnEvent
                    jsr drawHiScore

                    ldx #$30
                    jsr checkUserInput

                    jsr displayHelp
                    jsr exitOnEvent
                    jmp La0af

La0d7               rts

; A0D8
drawTitleBitmap     ldx #$00
                    stx $1c
                    stx Xpos
                    stx Ypos
                    ldx #$a6 ; LA600 -> ($1C)
                    stx $1d

La0e6               jsr readPakVal
                    cmp #$fe ; packed ?
                    beq La140

                    jsr Sa102
                    jmp La0e6

readPakVal          ldy #$00
                    lda ($1c),y
                    jsr Sa0fb
                    rts

Sa0fb               inc $1c
                    bne La101
                    inc $1d
La101               rts

Sa102               sta L0369
                    jsr getPixelAddr
                    lda L0369
                    ldy #$00
                    sta ($1a),y
                    jmp La124

getPixelAddr        ldx Ypos
                    lda spritelib.hgrHi,x
                    sta $1b
                    lda spritelib.hgrLo,x
                    clc
                    adc Xpos
                    sta $1a
                    rts

La124               inc Ypos
                    ldx Ypos
                    cpx #183
                    bne La13f
                    ldx #$00
                    stx Ypos
                    inc Xpos
                    ldx Xpos
                    cpx #40
                    bne La13f
                    pla
                    pla
La13f               rts

La140               jsr readPakVal ; value
                    sta L0367
                    jsr readPakVal ; count
                    sta L0368

La14c               lda L0367
                    jsr Sa102
                    dec L0368
                    bne La14c
                    jmp La0e6

; A15A
displayHelp         jsr clearScreen
                    jsr Sa1f1

                    ldx L7907
                    jsr checkUserInput

                    jsr Sa1f1
                    ldx #$40
                    stx L7907
                    jsr Sa1fb
                    jsr Sa205
                    jsr Sa23c

                    ldx #$10
                    jsr checkUserInput

                    jsr Sa246
                    jsr Sa272

                    ldx #$10
                    jsr checkUserInput

                    jsr Sa27c
                    jsr Sa2b9

                    ldx #$20
                    jsr checkUserInput

                    jsr Sa230
                    jsr Sa2ad
                    jsr Sa264
                    jsr Sa2b9
                    jsr Sa272
                    jsr Sa23c
                    jsr Sa1fb
                    jsr Sa2c3

                    ldx #$ff
                    stx L7906
                    jsr displayHelpObj

                    ldx #$20
                    jsr checkUserInput

                    ldx #$01
                    stx L7906
                    jsr displayHelpObj

                    jsr drawTitleBitmap
                    rts
; A1C3
clearScreen         ldx #$00
                    stx L7900
La1c8               jsr Sa1d6
                    inc L7900
                    ldx L7900
                    cpx #$b7
                    bne La1c8
                    rts

Sa1d6               ldx L7900
                    jsr Sa1e6
                    ldy #$27
                    lda #$00
La1e0               sta ($1c),y
                    dey
                    bpl La1e0
                    rts

Sa1e6               lda spritelib.hgrLo,x
                    sta $1c
                    lda spritelib.hgrHi,x
                    sta $1d
                    rts

Sa1f1
		    drawSprite $4f,25,16
                    rts

Sa1fb
		    drawSprite $50,48,16
                    rts

Sa205               ldx #$0c
                    stx L7902
                    ldx #$f1
                    stx L7901
La20f               jsr Sa230
                    lda L7902
                    eor #$1c
                    sta L7902
                    inc L7901
                    inc L7901
                    jsr Sa230
                    ldx #$40
                    jsr La361
                    ldx L7901
                    cpx #$19
                    bne La20f
                    rts

Sa230               ldx L7901
                    lda L7902
                    ldy #$32
                    jsr spritelib.drawSprite
                    rts

Sa23c
                    drawSprite $51,20,42
                    rts

Sa246               ldx #$00
                    stx L7903
                    jsr Sa264
La24e               jsr Sa264
                    inc L7903
                    jsr Sa264
                    ldx #$12
                    jsr La361
                    ldx L7903
                    cpx #$1f
                    bne La24e
                    rts

Sa264               ldx L7903
                    lda animSpriteIDs,x
                    ldx #$62
                    ldy #$31
                    jsr spritelib.drawSprite
                    rts

Sa272               ldx #$5a
                    ldy #$29
                    lda #$52
                    jsr spritelib.drawSprite
                    rts

Sa27c               ldx #$f0
                    stx L7904
                    ldx #$47
                    stx L7905
La286               jsr Sa2ad
                    inc L7904
                    inc L7904
                    jsr Sa2ad
                    ldx L7904
                    cpx #$40
                    beq La2a1
                    ldx #$40
                    jsr La361
                    jmp La286

La2a1      	jsr Sa2ad
		ldx #$48
		stx L7905
		jsr Sa2ad
		rts

Sa2ad       	lda L7905
		ldx L7904
		ldy #$60
		jsr spritelib.drawSprite
		rts

Sa2b9
		drawSprite $53,$3a,$54
		rts

Sa2c3
		drawSprite $54,$2e,$10
		rts

	.define spritesTable
	- { id: 0, x: 0, y: 0}
	- { id: 0, x: 0, y: 0}
	.end

	; .repeat len(spritesTable) spriteIdx

	; 	sprite= spritesTable[spriteIdx]
	; 	drawSprite sprite[0] sprite[1] sprite[2]
	; 	jsr Sa35e

	; .end

; $A2CD
displayHelpObj	ldx #$0d
		ldy #$30
		lda #$55 ; text key
		jsr spritelib.drawSprite

		jsr Sa35e

		; img key
		drawSprite $27,15,60

		jsr Sa35e

		ldx #$31
		ldy #$27
		lda #$57 ; text locked door
		jsr spritelib.drawSprite

		jsr Sa35e

		ldx #$3a
		ldy #$3c
		lda #$5c ; img locked door
		jsr spritelib.drawSprite

		jsr Sa35e

		ldx #$59
		ldy #$27
		lda #$58 ; text unlocked door
		jsr spritelib.drawSprite

		jsr Sa35e

		ldx #$67
		ldy #$3c
		lda #$5d ; img unlocked door
		jsr spritelib.drawSprite

		jsr Sa35e

		ldx #$25
		ldy #$64
		lda #$59 ; text gem
		jsr spritelib.drawSprite

		jsr Sa35e

		ldx #$28
		ldy #$6e
		lda #$28 ; img gem
		jsr spritelib.drawSprite

		jsr Sa35e

		ldx #$53
		ldy #$5b
		lda #$5a ; text gem holder
		jsr spritelib.drawSprite

		jsr Sa35e

		ldx #$5b
		ldy #$6d
		lda #$56 ; img gem holder
		jsr spritelib.drawSprite

		jsr Sa35e

		ldx #$2e
		ldy #$88
		lda #$5b ; text extra sword
		jsr spritelib.drawSprite

		jsr Sa35e

		ldx #$40
		ldy #$9b
		lda #$1e; img extra sword
		jsr spritelib.drawSprite

		jsr Sa35e
		rts

Sa35e     	ldx L7906
La361       	lda #$18
		jsr sys.WAIT
		jsr exitOnEvent2
		dex
		bne La361
		rts

checkUserInput	lda #$ff
		jsr sys.WAIT
		jsr exitOnEvent2
		dex
		bne checkUserInput
		rts

Sa379               ldx #$00
La37b               lda highScore,x
                    cmp playerScore,x
                    bcc La38b
                    bne La38a
                    inx
                    cpx #$05
                    bne La37b
La38a               rts

La38b               ldx #$04
La38d               lda playerScore,x
                    sta highScore,x
                    dex
                    bpl La38d
                    rts

; A397
animConanJump       jsr Sa3ad

                    ldx #$00
                    stx L7930
La39f               jsr Sa3cb

                    jsr Sa3fe
                    ldx #$30
                    jsr La361
                    jmp La39f

Sa3ad               ldx #$6b
                    ldy #$9c
                    lda #$0b ; conan-stand-left
                    jsr spritelib.drawSpriteM
                    rts

Sa3b7               ldx L7930
                    lda spriteYtabl,x
                    tay
                    lda spriteIDtabl,x
                    pha
                    lda spriteXtabl,x
                    tax
                    pla
                    jsr spritelib.drawSpriteM
                    rts

Sa3cb               ldx L7930
                    lda spriteYtabl,x
                    cmp spriteYtabl+1,x
                    bne La3f1
                    lda spriteIDtabl,x
                    cmp spriteIDtabl+1,x
                    bne La3f1
                    lda spriteXtabl,x
                    cmp spriteXtabl+1,x
                    bne La3f1
                    inc L7930
                    ldx L7930
                    cpx #$50
                    beq La3fb
                    rts

La3f1               jsr Sa3b7
                    inc L7930
                    jsr Sa3b7
                    rts

La3fb               pla
                    pla
                    rts

Sa3fe               ldx L7932
                    bne La421
                    ldx L7930
                    cpx #$1a
                    beq La40b
                    rts

La40b               inc L7932
                    ldx #$fb
                    stx L7931
                    ldx #$99
                    stx L7933
                    ldx #$49
                    stx L7934
                    jsr Sa451
                    rts

La421               lda L7933
                    clc
                    adc L7931
                    sta L7933
                    jsr Sa451
                    inc L7931
                    ldx L7931
                    cpx #$06
                    beq eraseSpring
                    rts

; draw black blocks over spring
eraseSpring	ldx #$00
		stx L7932
		ldx #$45
		ldy #$a3
		lda #$4e
		jsr drawSpriteBis
		ldx #$45
		ldy #$9e
		lda #$4e
		jsr drawSpriteBis
		rts

Sa451 		ldx #$45
		lda L7934
		ldy L7933
		jsr drawSpriteBis
		lda L7934
		eor #$03
		sta L7934
		rts

; draw highscore
drawHiScore         ldx #$28
                    ldy #$8c
                    lda #$4c ; hi-sc
                    jsr spritelib.drawSprite
                    ldx #$3b
                    ldy #$8c
                    lda #$4d ; ore :
                    jsr spritelib.drawSprite
                    jsr drawHSvalue
                    rts

drawHSvalue         ldx #$4b ; Ypos
                    stx L7908
                    ldy #$8c ; y pos
                    sty L7909
                    ldx #$00
                    stx L790A ; digits count
La48a               ldx L790A
                    jsr Sa4a0
                    inc L790A
                    ldx L790A
                    cpx #$05 ; 5 digits
                    bne La48a
                    lda #$0a
                    jsr Sa4a9
                    rts

Sa4a0               lda highScore,x
                    cmp #$00
                    bne Sa4a9
                    lda #$0a
Sa4a9               ldx L7908 ; x pos
                    ldy L7909 ; y pos
                    jsr spritelib.drawSprite ; draw sprite
                    lda L7908 ; x pos
                    clc
                    adc #$04 ; add char sprte width
                    sta L7908 ; x pos
                    rts

; A4BC
exitOnEvent         jsr Sa4c4
                    bcc La4c3
                    pla
                    pla
La4c3               rts

Sa4c4               lda sys.KBD
                    bmi La4da
                    ldy sys.BUTNO
                    bpl La4e0
                    ldy sys.BUTN1
                    bmi La4e0
                    ldy #$ff
                    sty inputMode
                    lda #$00
La4da               cmp #$9e
                    beq La4ec
                    sec
                    rts

La4e0               clc
                    rts

; A4E2
exitOnEvent2        jsr Sa4c4
                    bcc La4c3
                    pla
                    pla
                    pla
                    pla
                    rts

La4ec               jsr clearScreen
                    ldx #$12
                    ldy #$10
                    lda #$5e ; special thanks
                    jsr spritelib.drawSprite

                    bit sys.KBDSTRB
                    ldx #$40
La4fd               lda #$ff
                    jsr sys.WAIT
                    dex
                    bne La4fd

                    jsr drawTitleBitmap

                    ldx #$00
                    stx L7932
                    jmp La0af

La510
		.hex
		aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa
		aa aa aa aa aa aa aa aa aa 8d aa 20 20 20 20 20
		20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20
		20 20 20 20 20 20 20 20 20 aa 8d aa 20 20 20 20
		20 20 20 20 c4 c5 cd cf 20 d2 cf d5 d4 c9 ce c5
		20 20 20 20 20 20 20 20 20 20 aa 8d aa 20 20 20
		20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20
		20 20 20 20 20 20 20 20 20 20 20 aa 8d aa aa aa
		aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa
		aa aa aa aa aa aa aa aa aa aa aa aa aa 8d a0 cf
		d2 c7 a0 a4 c1 b0 b0 b0 8d a0 ca cd d0 a0 c2 c5
		c7 c9 ce 8d aa 8d aa 20 d3 d0 c5 c3 c9 c1 cc 20
		c4 d2 c1 d7 20 d2 cf d5 d4 c9 ce c5 bb 20 d3 d4
		cf d2 c5 20 20 aa 8d aa 20 d4 cf 20 d3 c3 d2 c5
		c5 ce ae 20 20 d5 d3 c5 c4 20 c6 cf d2 20 c7 c5
		.end
La600
		.hex
		fe 00 40 fe 80 06 40 80 70 7c 0f fe 40 05 00 fe
		40 04 00 fe 40 06 00 fe 40 04 15 55 55 55 54 fe
		55 04 54 fe 55 41 6a 6a 6a fe 2a 08 fe 00 41 60
		60 78 1e 66 1f 66 19 7f 78 fe 2a 16 0a 2a 2a 2a
		28 fe 2a 04 28 fe 2a 09 7a 6a 7a 2a 7a 6a 7a 2a
		7a 6a 7a 2a 3a 3e 1e 0a 2a 6a 7a 2a 7a 6a 7a 2a
		7a 6a 7a 2a 7a 6a 7a 2a 7a 6a 7a 2a 7a 6a 7a 2a
		7a 6a 7a 2a 7a 6a 7a 2a 7a 6a 7a 2a 2a 7a 2e 7f
		fe 55 0b fe 00 3e 3c 7f 73 4c 33 4c 7f 4c 33 7f
		33 4c 7f 7f fe 55 04 51 fe 40 07 77 77 fe 55 07
		15 fe 55 08 51 55 55 55 15 05 01 fe 00 0d 03 0d
		05 05 81 84 90 c0 fe 00 21 7d 5f 5f 5f 7f 2e 2e
		fe 2a 09 fe 00 3f 01 01 07 06 1f 7f 19 7e 19 66
		79 1f 2b 2a 2a 2a 0a fe 2a 04 0a fe 2a 06 0a fe
		2a 06 0a fe 2a 04 0a 0a 0a 02 02 fe 00 1a 82 88
		a0 fe 80 04 fe 00 1a fe 2a 04 00 fe 55 0b fe 00
		.end

La700
		.hex
		46 03 03 0f 3f 70 fe 00 3e 81 84 90 c0 fe 80 04
		fe 00 16 55 55 55 01 5c 76 76 56 6a 7a 6a fe 2a
		05 fe 00 4a 01 fe 00 42 82 88 a0 00 80 80 80 fe
		00 13 2a 2a 2a 00 07 02 80 aa ab ab bf 75 7d 55
		55 55 fe 00 90 81 84 90 c0 fe 80 04 fe 00 0e 55
		55 55 fe 00 05 fe d5 06 d7 2e 2a fe 00 40 fe 80
		08 fe 00 4c 82 88 a0 00 80 80 80 fe 00 0a 20 2a
		2a 0a fe 00 05 fe aa 07 7d 55 fe 00 97 81 84 90
		c0 fe 80 04 fe 00 06 55 55 55 fe 00 06 fe d5 08
		2a fe 00 9b 82 88 a0 00 80 80 80 00 00 00 2a 2a
		2a fe 00 06 fe aa 08 55 fe 00 9e 81 84 90 c0 80
		00 55 55 55 fe 00 07 fe d5 07 2b 2a fe 00 25 ff
		fa e8 e0 e0 f8 ff ea fe 00 75 82 98 3a 2a 2a fe
		00 05 40 60 ea fa da 56 5f fe 55 04 fe 00 25 80
		8e d6 e6 d6 d6 86 80 fe 00 2c 2a 02 0a 02 2a fe
		00 17 f8 d8 d8 f8 f8 d8 d8 f8 f8 d8 d8 f8 fe 00
		.end
La800
		.hex
		23 05 05 05 fe 00 04 37 1d 1d 16 fe 2a 08 fe 00
		26 80 aa dd aa bb 80 fe 00 1f 54 04 14 04 54 fe
		00 09 54 44 54 14 44 fe 00 17 ff aa aa ff ff aa
		aa bf bf aa aa ff fe 00 2b fe 55 0b fe 00 20 80
		80 80 c0 c0 a0 f0 f1 f7 f5 f3 f0 a0 c0 c0 c0 fe
		80 04 fe 00 17 28 08 28 28 08 fe 00 09 28 20 20
		20 28 fe 00 17 ff dd dd ff ff fe dd 06 ff fe 00
		2b fe 2a 0b fe 00 20 80 f8 ff bf af 97 9f f9 df
		9f b9 9f 97 8d af ff ff fa a8 80 fe 00 17 51 41
		41 40 51 fe 00 09 51 10 10 10 51 fe 00 17 ff aa
		aa ff ff aa aa ff ff aa aa ff fe 00 2b fe 55 0b
		fe 00 20 ff ff b5 b5 d0 c0 f0 ff aa d5 d5 00 f0
		e0 c0 f0 b1 f7 ff d5 fe 00 17 22 20 20 20 22 fe
		00 09 02 00 00 00 02 fe 00 17 8f 8d 8d 8f 8f 8d
		8d 8f 8f 8d 8d 8f fe 00 2b fe 2a 0b fe 00 20 9f
		87 80 ff af 8b 81 ff d5 aa aa 00 89 87 ff aa 80
		.end
La900
		.hex
		81 87 9e fe 00 17 05 00 00 00 05 00 00 fe 40 05
		00 00 fe 40 05 fe 00 1e 50 10 50 00 50 fe 00 2b
		fe 55 0b fe 00 20 80 80 f0 e3 ef ed ec fc bc b0
		b8 f4 dc df cf f3 d0 80 80 80 fe 00 10 0a 22 0a
		22 0a fe 00 09 0a 08 0a 08 08 00 00 0a 08 0a 02
		08 fe 00 1e 22 20 22 22 22 fe 00 2b 6a 2a 2a 2a
		fe 6a 04 3a 6a 2a fe 00 20 80 80 e7 83 87 8f 9f
		9b bb f3 f3 e3 83 83 83 e7 a2 80 80 80 fe 00 10
		44 44 10 10 10 00 00 15 11 15 01 01 00 00 15 fe
		11 04 00 00 15 11 11 11 15 fe 00 1e 45 44 44 44
		45 fe 00 27 08 08 38 2e 2a 2b 2d 5f d1 d1 d5 d1
		d6 d5 d6 fe 00 20 c0 80 bf 8b cb cb cb eb eb fb
		fb bb bb 9b 8f af bd b4 80 80 fe 00 17 2a 22 2a
		22 22 00 00 0a 22 22 22 0a 00 00 0a 22 0a 22 0a
		fe 00 1e 0a 00 02 fe 00 29 0c 0d 0d 35 35 77 55
		ba 1b 2b bc ba 82 72 2a fe 00 20 85 9f 86 97 97
		.end
Laa00
		.hex
		9f d9 fb d5 aa aa ef e0 e0 e0 f0 a8 80 80 80 fe
		00 17 54 44 54 14 44 fe 00 09 54 10 10 10 54 fe
		00 1e 15 fe 04 04 fe 00 2c 01 0f 35 2d 4d fe 55
		05 fe 00 20 80 80 bf 9e be be ff ff ed cc 8d 8a
		82 86 87 8f 8f 80 80 80 fe 00 17 08 08 28 08 08
		fe 00 09 28 fe 08 04 fe 00 1e 22 22 2a 2a 2a fe
		00 2c 40 3c 2a 25 fe 2a 06 fe 00 20 80 80 ff d8
		d8 d9 d8 dd db df de de dc d8 d8 f8 fa e8 e0 80
		fe 00 17 51 11 50 11 51 fe 00 09 51 11 51 01 51
		fe 00 1e 54 44 54 44 44 fe 00 2b 54 fe 55 0a fe
		00 20 80 80 83 fe 80 04 f7 aa d5 d5 fe 80 04 82
		82 82 81 83 fe 00 17 22 20 20 20 22 fe 00 09 22
		20 22 22 22 fe 00 1e 28 08 28 28 08 fe 00 2b fe
		2a 0b fe 00 27 fd d5 aa aa fe 00 20 05 04 05 01
		04 fe 00 09 45 44 44 44 45 fe 00 1e 51 11 51 10
		51 fe 00 2b fe 55 0b fe 00 27 f7 aa d5 f5 fe 00
		.end
Lab00
		.hex
		2e 0a fe 08 04 fe 00 1e 02 00 00 00 02 fe 00 2b
		fe 2a 0b fe 00 28 01 02 fe 00 82 fe 55 0b fe 00
		ac fe 2a 0b fe 00 6e 40 40 fe 00 16 10 44 35 54
		40 50 20 50 40 fe 00 1d fe 55 0b fe 00 60 20 28
		20 28 20 28 28 20 20 20 00 00 08 22 1a 68 28 02
		08 08 5a 00 68 20 28 00 20 fe 00 0b 22 0a 06 14
		5a 06 02 2a 02 22 28 fe 00 1b fe 2a 0b fe 00 5b
		40 50 50 54 55 54 fe 55 04 4b 2d 55 51 40 41 14
		15 44 08 2a 20 21 00 01 04 01 34 03 13 45 05 fe
		00 0b 10 40 50 28 0a 28 11 25 35 2b 25 14 41 10
		fe 00 18 fe 55 0b fe 00 56 20 00 28 20 28 2a 2a
		6a fe 2a 0b 6a 2a 2a 2a 0a 2a 08 00 01 01 15 50
		55 01 fe 00 0e 02 0a 02 09 0a 00 05 45 55 00 0a
		02 02 fe 00 18 40 54 fe 2a 0b fe 00 54 04 fe 55
		07 15 54 55 4d 2d 35 fe 55 06 56 32 2b 35 55 55
		54 51 30 50 00 00 00 0a 2a 28 20 20 fe 00 11 20
		.end
