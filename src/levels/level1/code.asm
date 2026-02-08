;code-R4-A000

startLevel
		jsr updateBat
		lda #$80
		jsr utils::wait

		ldx batState
		bne La016

		jsr Sa0e6

		jsr Sa09b
		jsr checkForExtraLife
La016		rts

updateBat:
		ldx batState
		bne La05c

		ldx batPathIndex
		lda batXposTbl,x
		cmp batXposTbl+1,x
		bne redrawBat

		lda batYposTbl,x
		cmp batYposTbl+1,x
		bne redrawBat

		lda batSpriteTbl,x
		cmp batSpriteTbl+1,x
		bne redrawBat

		inc batPathIndex
		rts

redrawBat	jsr drawBat
		inc batPathIndex
		jsr drawBat
		rts

drawBat		ldx batPathIndex
		lda batYposTbl,x
		tay
		lda batXposTbl,x
		sta batTempX
		lda batSpriteTbl,x
		ldx batTempX
		jsr spritelib::drawSpriteM
		rts

La05c		bmi La016		; bat dead already ?

		ldx splashActive	; is Exploding
		bne La079

		jsr Sa13a
		inc effectY
		inc effectY
		inc effectY
		jsr Sa14c
		jsr Sa13a
		jsr drawBatExplosion
		rts

La079		dec splashTimer
		bmi La07f

		rts

La07f		jsr Sa13a
		ldx #$06
		stx splashTimer
		inc effectSpriteID
		ldx effectSpriteID
		cpx #$4a
		beq La095

		jsr Sa13a
		rts

La095		ldx #$ff
		stx batState
		rts

Sa09b		ldx batPathIndex
		lda globals::spriteX
		sec
		sbc #$06
		cmp batXposTbl,x
		bcs La0e5

		clc
		adc #$0c
		cmp batXposTbl,x
		bcc La0e5

		lda globals::spriteY
		sec
		sbc #$08
		cmp batYposTbl,x
		bcs La0e5

		clc
		adc #$13
		cmp batYposTbl,x
		bcc La0e5

		ldx globals::playerDeadAnimIdx
		bne La0e5

		ldx #$01
		stx globals::playerDeadAnimIdx
		ldx globals::spriteX
		ldy globals::spriteY
		lda globals::spriteID
		jsr spritelib::drawSpriteM ; clear player current sprite

		ldx globals::spriteX
		ldy globals::spriteY
		lda #$19
		jsr spritelib::drawSpriteM ; player death sprite 1st frame

La0e5		    rts

Sa0e6		    ldx globals::playerAxeState
		    beq La0e5
		    ldx batPathIndex
		    lda globals::axeXpos
		    sec
		    sbc #$0c
		    cmp batXposTbl,x
		    bcs La139
		    clc
		    adc #$10
		    cmp batXposTbl,x
		    bcc La139
		    lda globals::axeYpos
		    sec
		    sbc #$0d
		    cmp batYposTbl,x
		    bcs La139
		    clc
		    adc #$13
		    cmp batYposTbl,x
		    bcc La139

		    ldx #$01
		    stx batState
		    ldx batPathIndex
		    lda batXposTbl,x
		    sta effectX
		    lda batYposTbl,x
		    sta effectY
		    lda batSpriteTbl,x
		    sta effectSpriteID
		    ldx #$01
		    stx effectAnimFrameIdx
		    jsr game1::scoreAdd75 ;L106A

		    jsr soundlib::L0a58

La139		    rts

Sa13a		    ldx #$00
		    stx spritelib::isCollision
		    ldx effectX
		    ldy effectY
		    lda effectSpriteID
		    jsr spritelib::drawSpriteM
		    rts

Sa14c		    ldx effectAnimFrameIdx
		    lda effectSpriteID,x
		    sta effectSpriteID
		    inc effectAnimFrameIdx
		    ldx effectAnimFrameIdx
		    cpx #$04
		    bne La164
		    ldx #$01
		    stx effectAnimFrameIdx
La164		    rts

; $A165
drawBatExplosion:
		    ldx #$ff
La167		    inx
		; check top
		    lda LAC40,x
		    beq La1af
		    clc
		    adc #$08
		    cmp effectY
		    bcs La167

		    clc
		    adc #$08
		    cmp effectY
		    bcc La167

		; check left
		    lda LAC00,x
		    cmp effectX
		    bcs La167

		; check right
		    lda LAC20,x
		    cmp effectX
		    bcc La167

		    stx splashRectIdx
		    jsr Sa13a
		    ldx #$08
		    stx splashActive
		    stx splashTimer
		    ldx splashRectIdx
		    lda LAC40,x
		    clc
		    adc #$0d
		    sta effectY
		    ldx #$47
		    stx effectSpriteID
		    jsr Sa13a
La1af		    rts

;SA1B0
checkForExtraLife:
		    ldx globals::spriteX
		    cpx #122	; $7a
		    bcc La1d1
		    ldx globals::isClimbing
		    beq La1d1

		    ldx #globals::playerLifeCount-globals::playerData
		    jsr game1::drawDigit

		    inc globals::playerLifeCount

		    ldx #globals::playerLifeCount-globals::playerData
		    jsr game1::drawDigit

		    ldx #$60
		    stx checkForExtraLife
		    jsr soundlib::L0b23
La1d1		    rts
