;
; level 8 code, disk chunk c4 ($A000-$A0FF)
; levelTick, at $A000, is called by the game's main loop, once: it plays
; the whole ending and only returns on a key press.
;
; the ending: "Thus, Volta was destroyed and Conan continued in search of
; high adventure." The player is not on the screen (c5 start at $D0,$D0).
; - one more life, then "BONUS!" / "20000x" and a falling tone;
; - each life left is cashed in: a life icon is drawn after "20000x",
;   the life count goes down by one, +2000 points and a jingle;
; - with no life left, it waits for a key and moves on to level 9:
;   the game's main loop (resetIfLastLevel) then restarts the game.
;
; No DRAW_PLAIN: levelTick is at $A000.
;

SHAPE_LIFE	.equ	$0C			; the core's life icon

LIFE_DIGIT	.equ	globals::playerLifeCount - globals::playerData	; for game1::drawDigit

levelTick	ldx	#LIFE_DIGIT		; one more life
		jsr	game1::drawDigit
		inc	globals::playerLifeCount
		ldx	#LIFE_DIGIT
		jsr	game1::drawDigit
		ldx	#$60
		jsr	pause
		ldx	#$10			; sound on
		stx	globals::soundSwitch
		jsr	drawBonusText
		jsr	sweepTone
		ldx	#$50
		jsr	pause
:		jsr	cashLife
		jsr	game1::scoreAdd1000
		jsr	game1::scoreAdd1000
		jsr	jingle
		ldx	#$20
		jsr	pause
		ldx	globals::playerLifeCount
		beq	:+
		jmp	:-

:		bit	sys::KBDSTRB
:		lda	sys::KBD
		bpl	:-
		inc	globals::level		; 9: the main loop restarts the game
		rts

;
; drawBonusText: "BONUS!" / "20000x", the 12 shapes of textX / textY / textShape
;
drawBonusText	ldx	#$0B
		stx	textIdx
:		jsr	drawTextChar
		dec	textIdx
		bpl	:-
		rts

;
; pause: X times utils::wait $80
;
pause		lda	#$80
		jsr	utils::wait
		dex
		bne	pause
		rts

drawTextChar	ldx	textIdx
		lda	textY,x
		tay
		lda	textShape,x
		pha
		lda	textX,x
		tax
		pla
		jsr	spritelib::drawSprite
		rts

;
; sweepTone: a falling tone, periods 1, then $FF down to $A3 by 2
;
sweepTone	ldx	#$01
		stx	tonePeriod
; named, not ':': tsasm resolves ':-' by address across all the segments,
; and another level's code has a ':' at $A083, between here and the bne
sweepLoop	ldx	tonePeriod
		ldy	#$05
		jsr	game1::tone
		dec	tonePeriod
		dec	tonePeriod
		ldx	tonePeriod
		cpx	#$A1
		bne	sweepLoop
		rts

jingle		ldx	#$30
		ldy	#$FF
		jsr	game1::tone
		ldx	#$28
		ldy	#$FF
		jsr	game1::tone
		ldx	#$20
		ldy	#$FF
		jsr	game1::tone
		rts

;
; cashLife: draw the next life icon after "20000x" (X $48 + 6 * (iconN - 1),
; Y $9E) and take one life off
;
cashLife	ldx	iconN
		inc	iconN
		lda	#$48
:		dex
		beq	:+
		clc
		adc	#$06
		jmp	:-

:		tax
		ldy	#$9E
		lda	#SHAPE_LIFE
		jsr	spritelib::drawSprite
		ldx	#LIFE_DIGIT
		jsr	game1::drawDigit
		dec	globals::playerLifeCount
		ldx	#LIFE_DIGIT
		jsr	game1::drawDigit
		rts

; $A0CA-$A0FF: the original's local copy of DRAW_DIGIT ($A0CA-$A0DD,
; replaced by game1::drawDigit), then leftover bytes
