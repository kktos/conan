		.org $A000

La000		jsr Sa017
		lda #$80
		jsr $fca8

		ldx L7902
		bne La016

		jsr Sa0e6

		jsr Sa09b
		jsr Sa1b0
La016		rts

Sa017		ldx L7902
		bne La05c

		ldx L7900
		lda batXposTbl,x
		cmp batXposTbl+1,x
		bne redrawBat

		lda batYposTbl,x
		cmp batYposTbl+1,x
		bne redrawBat

		lda batSpriteTbl,x
		cmp batSpriteTbl+1,x
		bne redrawBat

		inc L7900
		rts

redrawBat	jsr drawBat
		inc L7900
		jsr drawBat
		rts

drawBat		ldx L7900
		lda batYposTbl,x
		tay
		lda batXposTbl,x
		sta L7901
		lda batSpriteTbl,x
		ldx L7901
		jsr drawSpriteM
		rts

La05c		bmi La016

		ldx L790A
		bne La079

		jsr Sa13a
		inc L7904
		inc L7904
		inc L7904
		jsr Sa14c
		jsr Sa13a
		jsr Sa165
		rts

La079		dec L790B
		bmi La07f

		rts

La07f		jsr Sa13a
		ldx #$06
		stx L790B
		inc L7905
		ldx L7905
		cpx #$4a
		beq La095

		jsr Sa13a
		rts

La095		ldx #$ff
		stx L7902
		rts

Sa09b		ldx L7900
		lda spriteX
		sec
		sbc #$06
		cmp batXposTbl,x
		bcs La0e5

		clc
		adc #$0c
		cmp batXposTbl,x
		bcc La0e5

		lda spriteY
		sec
		sbc #$08
		cmp batYposTbl,x
		bcs La0e5

		clc
		adc #$13
		cmp batYposTbl,x
		bcc La0e5

		ldx playerDeadAnimIdx
		bne La0e5

		ldx #$01
		stx playerDeadAnimIdx
		ldx spriteX
		ldy spriteY
		lda spriteID
		jsr drawSpriteM ; clear player current sprite

		ldx spriteX
		ldy spriteY
		lda #$19
		jsr drawSpriteM ; player death sprite 1st frame

La0e5		    rts

Sa0e6		    ldx playerAxeState
		    beq La0e5
		    ldx L7900
		    lda L031A
		    sec
		    sbc #$0c
		    cmp batXposTbl,x
		    bcs La139
		    clc
		    adc #$10
		    cmp batXposTbl,x
		    bcc La139
		    lda L031B
		    sec
		    sbc #$0d
		    cmp batYposTbl,x
		    bcs La139
		    clc
		    adc #$13
		    cmp batYposTbl,x
		    bcc La139

		    ldx #$01
		    stx L7902
		    ldx L7900
		    lda batXposTbl,x
		    sta L7903
		    lda batYposTbl,x
		    sta L7904
		    lda batSpriteTbl,x
		    sta L7905
		    ldx #$01
		    stx L7909
		    jsr L106A

		    jsr $0a58

La139		    rts

Sa13a		    ldx #$00
		    stx LB3F6
		    ldx L7903
		    ldy L7904
		    lda L7905
		    jsr drawSpriteM
		    rts

Sa14c		    ldx L7909
		    lda L7905,x
		    sta L7905
		    inc L7909
		    ldx L7909
		    cpx #$04
		    bne La164
		    ldx #$01
		    stx L7909
La164		    rts

Sa165		    ldx #$ff
La167		    inx
		    lda LAC40,x
		    beq La1af
		    clc
		    adc #$08
		    cmp L7904
		    bcs La167

		    clc
		    adc #$08
		    cmp L7904
		    bcc La167

		    lda LAC00,x
		    cmp L7903
		    bcs La167

		    lda LAC20,x
		    cmp L7903
		    bcc La167

		    stx L790C
		    jsr Sa13a
		    ldx #$08
		    stx L790A
		    stx L790B
		    ldx L790C
		    lda LAC40,x
		    clc
		    adc #$0d
		    sta L7904
		    ldx #$47
		    stx L7905
		    jsr Sa13a
La1af		    rts

Sa1b0		    ldx spriteX
		    cpx #$7a
		    bcc La1d1
		    ldx L0309
		    beq La1d1
		    ldx #$06
		    jsr drawDigit
		    inc playerLifeCount
		    ldx #$06
		    jsr drawDigit
		    ldx #$60
		    stx Sa1b0
		    jsr $0b23
La1d1		    rts

drawDigit	    lda playerData,x
		    tay
		    lda L033C,x
		    tax
		    tya
		    ldy #$b9
		    cmp #$00
		    bne La1e3
		    lda #$0a
La1e3		    jsr drawSprite
		    rts
