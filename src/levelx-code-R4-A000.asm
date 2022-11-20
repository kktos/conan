
		.org $A000

La000               jmp start

drawSpriteBis	sty spritelib.yPos
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
		stx spritelib.dsHeightInit
		bpl La047

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

La047               lda spritelib.LAF00,x
                    asl
                    clc
                    adc #$02
                    tay
                    lda ($1c),y
                    sta pixels
                    iny
                    lda ($1c),y
                    sta pixels+1
La05a               ldy spritelib.yPos
                    lda spritelib.hgrLo,y
                    sta $1c
                    lda spritelib.hgrHi,y
                    sta $1d
                    ldx spritelib.dsHeightInit
                    ldy spritelib.LB3F7
                    beq La076
                    lda spritelib.LB000,x
                    tay
                    jmp La07a

La076               lda spritelib.LB100,x
                    tay
La07a               cpy #$28
                    bcs La093
                    lda ($1c),y
                    tax
pixels=*+1
                    lda $ffff
                    cmp ($1c),y
                    beq La08f
                    cpx #$00
                    beq La08f
                    jmp La093

La08f               eor ($1c),y
                    sta ($1c),y
La093               inc pixels
                    bne La09b
                    inc pixels+1
La09b               iny
                    cpy #$4a
                    bne La0a2
                    ldy #$00
La0a2               dec spritelib.dsWidth
                    bne La07a
                    ldx spritelib.dsWidthInit
                    stx spritelib.dsWidth
                    dec spritelib.dsHeight
                    beq La0b8

                    inc spritelib.yPos
                    jmp La05a

La0b8               rts

start               ldx playerDeadAnimIdx
                    bne La0c1

                    jsr Sa155
La0c1               jsr Sa0d9
                    jsr Sa2b2
                    jsr Sa111
                    jsr Sa1af
                    jsr Sa1f3
                    jsr Sa215
                    lda #$80
                    jsr $fca8
                    rts

Sa0d9               ldx L7900
                    bne La110

                    ldx spriteX
                    cpx #$82
                    bcc La110

                    cpx #$d0
                    bcs La110

                    ldx spriteY
                    cpx #$98
                    bcc La110

                    cpx #$c0
                    bcs La110

                    ldx assetKeyCnt
                    bne La110

                    inc assetKeyCnt
                    ldx #$01
                    jsr Sa145
                    ldx #$85
                    ldy #$9f
                    lda #$27
                    jsr spritelib.drawSprite
                    jsr scoreAdd100
                    jsr soundlib.L0a6e
La110               rts

Sa111               ldx assetKeyCnt
                    beq La110

                    ldx spriteX
                    cpx #$2e
                    bcs La144

                    ldx spriteY
                    cpx #$7b
                    bcc La144

                    cpx #$8c
                    bcs La144

                    ldx #$01
                    stx L7900
                    jsr Sa145
                    ldx #$00
                    stx assetKeyCnt
                    ldx #$27
                    ldy #$7b
                    lda #$2a
                    jsr spritelib.drawSprite
                    jsr scoreAdd250
                    jsr soundlib.L0a7d
La144               rts

Sa145               txa
                    tay
                    lda assetXpos-1,y
                    tax
                    tya
                    clc
                    adc #$26
                    ldy #$b9
                    jsr spritelib.drawSprite
                    rts

Sa155         	ldx playerDeadAnimIdx
		bne La165

		; spriteY >= 168
		; spriteY < 240
		ldx spriteY
		cpx #168
		bcc La165

		cpx #240
		bcc La166

La165          	rts

		; spriteX >= 80
La166 		ldx spriteX
		cpx #80
		bcc La192

		ldx #$08
		stx playerDeadAnimIdx
		ldx spriteX
		stx L7902
		ldy spriteY
		lda spriteID
		jsr spritelib.drawSpriteM
		inc L7901
		ldx #$01
		stx L7903
		ldx #$41
		stx L7904
		jsr Sa1e7
		rts

La192          	ldx #$01
		stx playerDeadAnimIdx
		ldx spriteX
		ldy spriteY
		lda spriteID
		jsr spritelib.drawSpriteM
		ldx spriteX
		ldy spriteY
		lda #$19
		jsr spritelib.drawSpriteM
		rts

Sa1af               ldx L7900
                    bne La1bb
                    ldx spriteX
                    cpx #$2c
                    bcc La1bc
La1bb               rts

La1bc               ldx spriteX
                    ldy spriteY
                    lda spriteID
                    jsr spritelib.drawSpriteM
                    lda spriteX
                    sec
                    sbc L0306
                    sta spriteX
                    ldx #$00
                    stx L0306
                    stx L0307
                    ldx spriteX
                    ldy spriteY
                    lda spriteID
                    jsr spritelib.drawSpriteM
La1e6               rts

Sa1e7               ldx L7902
                    ldy #$a2
                    lda L7904
                    jsr drawSpriteBis
                    rts

Sa1f3               ldx L7901
                    beq La1e6

                    jsr Sa1e7
                    ldx L7903
                    cpx #$09
                    beq La20f

                    lda L7908-1,x
                    sta L7904
                    jsr Sa1e7
                    inc L7903
                    rts

La20f               ldx #$00
                    stx L7901
                    rts

Sa215               jsr Sa264
                    ldx L7907
                    beq La220

                    jsr Sa257
La220               ldx L7905
                    ldy #$01
                    lda #$45
                    jsr drawSpriteBis
                    inc L7905
                    ldx L7905
                    ldy #$01
                    lda #$45
                    jsr drawSpriteBis
                    ldx L7906
                    ldy #$1a
                    lda #$46
                    jsr drawSpriteBis
                    inc L7906
                    ldx L7906
                    ldy #$1a
                    lda #$46
                    jsr drawSpriteBis

                    ldx L7907
                    beq La256

                    jsr Sa257
La256               rts

Sa257               ldx spriteX
                    ldy spriteY
                    lda spriteID
                    jsr spritelib.drawSpriteM
                    rts

		; spriteY >= 239
		; spriteY < 26
Sa264         	ldx spriteY
		cpx #239
		bcs La272

		cpx #26
		bcc La272

		jmp La288

La272    	lda L7905
		sec
		sbc #$0a
		cmp spriteX
		bcs La288
		clc
		adc #$22
		cmp spriteX
		bcc La288
		jmp La2a6

		; spriteY >= 43
		; spriteY < 14
La288   	lda spriteY
		cmp #43
		bcs La2ac

		cmp #14
		bcc La2ac

		lda L7906
		sec
		sbc #9
		cmp spriteX
		bcs La2ac

		clc
		adc #30
		cmp spriteX
		bcc La2ac

La2a6         	ldx #$04
		stx L7907
		rts

La2ac    	ldx #$00
		stx L7907
		rts

Sa2b2       	ldx animFrameIdx
		lda spriteYtabl,x
		cmp spriteYtabl+1,x
		bne La2d1

		lda spriteIDtabl,x
		cmp spriteIDtabl+1,x
		bne La2d1

		lda spriteXtabl,x
		cmp spriteXtabl+1,x
		bne La2d1

		inc animFrameIdx
		rts

La2d1    	jsr renderAnimFrame
		inc animFrameIdx
		jsr renderAnimFrame
		rts

renderAnimFrame	ldx animFrameIdx
		lda spriteYtabl,x
		tay
		lda spriteIDtabl,x
		pha
		lda spriteXtabl,x
		tax
		pla
		jsr spritelib.drawSprite
		rts

		; .hex 00
		; .hex 00 00 00 00 40 00 00 00 20 71 07 00 10 79 1a 00

		.align $100

spriteXtabl	.hex
		f0 f0 f0 f0 f0 f0 f0 f0 f0 f0 f0 f0 f0 f0 f0 f0
		f0 f0 f0 f0 f0 f0 f0 f0 f0 f0 f0 f0 f0 f0 f0 f0
		f0 f0 f0 f0 f0 f0 f0 f0 f0 f0 f0 f0 f0 f0 f0 f0
		f0 f0 f0 f0 f0 f0 f0 f0 f0 f0 f0 f0 f0 f0 f0 f0
		f0 f0 f0 f0 f0 f0 f0 f0 f0 f0 f2 f4 f6 f8 fa fa
		fc fe 00 02 04 06 08 0a 0c 0e 10 12 12 12 12 12
		12 12 12 12 12 12 12 12 12 12 12 12 12 12 12 12
		12 12 12 12 12 12 12 12 12 12 12 12 12 12 12 12
		12 12 12 12 12 12 12 12 12 12 12 12 12 14 16 18
		1a 1a 1a 1a 1a 1a 1a 1a 1a 1a 1a 1a 1a 1a 1a 1a
		1a 1a 1a 1a 1a 1a 1a 1a 1a 1a 1a 1a 1a 18 16 14
		12 10 0e 0c 0a 08 06 04 02 00 fe fc fa f8 f6 f6
		f6 f6 f6 f6 f6 f6 f6 f6 f6 f6 f6 f6 f6 f6 f6 f6
		f6 f6 f6 f6 f6 f6 f6 f6 f6 f6 f6 f6 f6 f6 f6 f6
		f6 f6 f6 f6 f6 f6 f6 f6 f6 f6 f6 f6 f6 f6 f6 f6
		f6 f6 f6 f6 f6 f6 f6 f6 f6 f6 f6 f6 f6 f6 f6 f6
		.end

spriteYtabl	.hex
		4e 4e 4e 4e 4e 4e 4e 4e 4e 4e 4e 4e 4e 4e 4e 4e
		4e 4e 4e 4e 4e 4e 4e 4e 4e 4e 4e 4e 4e 4e 4e 4e
		4e 4e 4e 4e 4e 4e 4e 4e 4e 4e 4e 4e 4e 4e 4e 4e
		4e 4e 4e 4e 4e 4e 4e 4e 4e 4e 4e 4e 4e 4e 4e 4e
		4e 4e 4e 4e 4e 4e 4e 4e 4e 4e 4e 4e 4e 4e 4e 4f
		51 53 55 58 5c 60 63 65 66 64 61 62 63 63 63 63
		63 63 63 63 63 63 63 63 63 63 63 63 63 63 63 63
		63 63 63 63 63 63 63 63 63 63 63 63 63 63 63 63
		63 63 63 63 63 63 63 63 63 63 62 60 5d 58 54 52
		53 53 53 53 53 53 53 53 53 53 53 53 53 53 53 53
		53 53 53 53 53 53 53 53 53 53 53 53 51 51 53 56
		5a 5f 64 68 6b 6e 70 71 70 6e 6b 67 64 63 62 62
		62 62 62 62 62 62 62 62 62 62 62 62 62 62 62 62
		62 62 62 62 62 62 62 62 62 62 62 62 62 62 62 62
		62 62 62 62 62 62 62 62 62 62 62 62 62 62 62 62
		62 62 62 62 62 62 62 62 62 62 62 62 62 62 62 62
		.end

spriteIDtabl	.hex
		47 47 47 47 47 47 47 47 47 47 47 47 47 47 47 47
		47 47 47 47 47 47 47 47 47 47 47 47 47 47 47 47
		47 47 47 47 47 47 47 47 47 47 47 47 47 47 47 47
		47 47 47 47 47 47 47 47 47 47 47 47 47 47 47 47
		47 47 47 47 47 47 47 47 47 47 47 47 47 47 47 47
		47 47 47 47 47 47 47 47 47 47 47 47 49 49 49 49
		49 49 49 49 49 49 49 49 49 49 49 49 49 4a 4a 4a
		4a 4a 4a 4a 4a 4a 4a 4a 4a 4a 4a 4a 4a 4a 4a 4a
		4a 4a 4a 4a 4a 4a 4a 4a 49 49 49 47 47 47 47 47
		49 49 49 49 49 49 4a 4a 4a 4a 4a 4a 4a 4a 4a 4a
		4a 4a 4a 4a 4a 4a 4a 4a 4a 4a 4a 4a 4a 48 48 48
		48 48 48 48 48 48 48 48 48 48 48 48 48 48 48 48
		48 48 48 48 48 48 48 48 48 48 48 48 48 48 48 48
		48 48 48 48 48 48 48 48 48 48 48 48 48 48 48 48
		48 48 48 48 48 48 48 48 48 48 48 48 48 48 48 48
		48 48 48 48 48 48 48 48 48 48 48 48 48 48 48 48
		.end
