		.function animConanJump

		; ldx #$6b
		; ldy #$9c
		; lda #$0b ; conan-stand-left
		; jsr spritelib.drawSpriteM

		stz animFrameIdx
		jsr renderAnimFrame
loop
		jsr renderNextFrame
		jsr processSpringAnim
		ldx #$30
		jsr waitAndExitOnEvent2
		bra loop

renderAnimFrame
		ldx animFrameIdx
		lda spriteYtabl,x
		tay
		lda spriteIDtabl,x
		pha
		lda spriteXtabl,x
		tax
		pla
		jsr spritelib.drawSpriteM
		rts

renderNextFrame
		ldx animFrameIdx
		lda spriteYtabl,x
		cmp spriteYtabl+1,x
		bne La3f1
		lda spriteIDtabl,x
		cmp spriteIDtabl+1,x
		bne La3f1
		lda spriteXtabl,x
		cmp spriteXtabl+1,x
		bne La3f1
		inc animFrameIdx
		ldx animFrameIdx
		cpx #$50
		beq La3fb
		rts

La3f1
		jsr renderAnimFrame	; remove previous sprite
		inc animFrameIdx
		jsr renderAnimFrame	; draw current sprite
		rts

La3fb
		pla
		pla
		rts

processSpringAnim
		ldx isSpringRunning
		bne La421
		ldx animFrameIdx
		cpx #$1a
		beq La40b
		rts

La40b
		inc isSpringRunning
		ldx #$fb
		stx L7931
		ldx #$99
		stx springCurYpos
		ldx #$49
		stx springCurId
		jsr renderSpring
		rts

La421
		lda springCurYpos
		clc
		adc L7931
		sta springCurYpos
		jsr renderSpring
		inc L7931
		ldx L7931
		cpx #$06
		beq eraseSpring
		rts

; draw black blocks over spring
eraseSpring
		stz isSpringRunning
		ldx #$45
		ldy #$a3
		lda #$4e
		jsr drawSpriteBis
		ldx #$45
		ldy #$9e
		lda #$4e
		jsr drawSpriteBis
		rts

renderSpring
		ldx #$45
		lda springCurId
		ldy springCurYpos
		jsr drawSpriteBis
		lda springCurId
		eor #$03
		sta springCurId
		rts

		.end
