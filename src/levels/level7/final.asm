;
; level 7's final animation, loaded at $9F00-$A9FF by loadFinal (code.asm)
; once the third gem is given, over the end of c3 and the level code
; (loadFinal, past $A9FF, is not). The original read it from disk 2
; T22 S0-SA with RWTS.
; $E8 frames of 3 actors, each with X / Y / shape tables by finalFrame: the
; prisoner (A), the figure (B), both EORed with spritelib::drawPlain, and the
; player (C), with DRAW_SHAPE. Then the player and the exit go to
; ($E0,$E0) and it returns from levelTick's caller: CHECK_EXIT, level 8.
;

; c2 is the level's: the finalFrame counter takes its first byte
finalFrame	.equ	$7900


final		jmp	finalBegin

; frames 0..$E7, with a tone from $30 to $3F
finalBegin	ldx	#$00
		stx	finalFrame
finalLoop	jsr	updateActorA
		jsr	updateActorB
		jsr	updateActorC
		inc	finalFrame
		ldx	finalFrame
		cpx	#$30
		bcc	L9fcc
		cpx	#$40
		bcs	L9fcc
		ldy	#$10
		jsr	game1::tone
L9fcc		lda	#$78
		jsr	utils::wait
		ldx	finalFrame
		cpx	#$e8
		bne	finalLoop
		bit	sys::KBDSTRB
		ldx	#$00
		stx	globals::playerXspeed
		stx	globals::playerYspeed
		ldx	#$e0
		stx	globals::spriteX
		stx	globals::spriteXnew
		stx	LAD87
		stx	globals::spriteY
		stx	globals::spriteYNew
		stx	LAD88
		ldx	#$30
		stx	globals::soundSwitch
		pla
		pla
		rts

; an actor is redrawn when it moves or changes shape (EOR the old, then the
; new); the prisoner's shapes $57 / $59 make a sound
updateActorA	ldx	finalFrame
		lda	actorAY,x
		cmp	actorAY+1,x
		bne	La01b
		lda	actorAShape,x
		cmp	actorAShape+1,x
		bne	La01b
		lda	actorAX,x
		cmp	actorAX+1,x
		bne	La01b
		rts
La01b		jsr	drawActorA
		ldx	finalFrame
		inx
		jsr	drawActorA
		ldx	finalFrame
		lda	actorAShape,x
		cmp	#$57
		beq	La034
		cmp	#$59
		beq	La034
		rts
La034		ldy	#$10
		jsr	soundlib::L0ae6
		rts
drawActorA	lda	actorAY,x
		tay
		lda	actorAShape,x
		pha
		lda	actorAX,x
		tax
		pla
		jsr	spritelib::drawPlain
		rts

updateActorB	ldx	finalFrame
		lda	actorBY,x
		cmp	actorBY+1,x
		bne	La067
		lda	actorBShape,x
		cmp	actorBShape+1,x
		bne	La067
		lda	actorBX,x
		cmp	actorBX+1,x
		bne	La067
		rts
La067		jsr	drawActorB
		ldx	finalFrame
		inx
drawActorB	lda	actorBY,x
		tay
		lda	actorBShape,x
		pha
		lda	actorBX,x
		tax
		pla
		jsr	spritelib::drawPlain
		rts

updateActorC	ldx	finalFrame
		lda	actorCY,x
		cmp	actorCY+1,x
		bne	La09b
		lda	actorCShape,x
		cmp	actorCShape+1,x
		bne	La09b
		lda	actorCX,x
		cmp	actorCX+1,x
		bne	La09b
		rts
La09b		jsr	drawActorC
		ldx	finalFrame
		inx
drawActorC	lda	actorCY,x
		tay
		lda	actorCShape,x
		pha
		lda	actorCX,x
		tax
		pla
		jsr	spritelib::drawSpriteM
		rts

; $A0B3-$A0FF: slack (leftover bytes)

		placeAt $A100
; the prisoner, by finalFrame 0..$E8; past it, leftover bytes
actorAX
	.hex
	1A 18 17 16 15 13 12 10 0E 0E 0D 0D 0D 0D 0D 0E
	0F 0F 10 10 11 11 12 13 15 17 19 1B 1D 1F 21 23
	25 28 2A 2C 2E 30 32 34 36 38 3A 3C 3E 40 41 42
	43 44 45 46 47 49 4B 4D 4F 51 53 55 58 5B 5E 61
	63 64 64 64 64 64 64 64 64 64 64 64 64 64 64 64
	64 64 62 60 5E 5C 5A 58 56 54 52 50 4E 4C 4A 48
	46 44 42 40 3E 3C 3A 38 36 34 32 30 2E 2C 2A 28
	26 24 22 1F 1D 1B 19 17 15 13 12 11 10 0F 0E 0E
	0E 0F 10 10 11 13 14 15 16 16 16 16 16 16 16 16
	16 16 15 15 15 15 15 15 15 15 15 14 13 12 11 11
	11 10 10 10 10 10 11 11 13 14 16 18 1A 1C 1E 20
	22 24 26 28 2A 2C 2E 30 32 34 36 38 3A 3C 3E 40
	42 44 46 48 4A 4C 4E 50 52 54 56 58 5A 5C 5E 60
	62 64 66 68 6A 6A 6A 6A 6A 6A 6A 6A 6A 6A 6A 6A
	6A 6A 6A 6A 6A 6A 6A 6A 6A 6A 6A 6A 6A 6A 6A 6A
	6A 6A 6A 6A 6A 6A 6A 6A 6A 6A 6A 6A 6A 6A 6A 00
	.end
actorAY
	.hex
	24 24 23 22 21 20 1E 1D 1D 1E 1F 1F 1F 1E 1C 19
	16 11 0C 07 02 FD F8 F4 F1 EE EC EB EB EB EB EB
	EC EC EB EA E9 E9 E9 EB EE F2 F7 FB 00 05 0A 0F
	14 19 1D 22 25 27 28 29 29 28 25 21 1C 17 14 12
	11 12 13 13 13 13 13 13 13 13 13 13 13 13 13 13
	11 11 0E 0B 07 03 00 FE FD FD FD FD FD FD FD FD
	FD FF 00 00 00 00 00 FF FE FD FD FE FF FF FF FF
	FF FF FF FF 00 00 01 02 04 07 0A 0E 12 15 19 1C
	20 24 28 2C 2F 30 32 35 39 3D 41 44 47 49 4A 4A
	4A 4A 4A 4A 49 46 42 3E 3A 36 33 30 2E 2A 25 20
	1B 16 12 0E 0E 0A 05 00 FE FC F9 F6 F3 F1 F0 F0
	F0 F0 EF EF EF EF EF EF EF F1 F4 F8 FC 00 03 05
	06 06 07 08 09 09 09 08 08 07 06 05 05 03 02 00
	FE FB F8 F6 F4 F1 EE EE EE EE EE EE EE EE EE EE
	EE EE EE EE EE EE EE EE EE EE EE EE EE EE EE EE
	EE EE EE EE EE EE EE EE EE EE EE EE EE EE EE 00
	.end
actorAShape
	.hex
	5A 5A 5A 56 57 56 57 56 57 5A 5A 5B 5B 58 59 58
	59 58 59 58 59 58 59 58 59 58 59 58 59 58 59 58
	59 58 59 58 59 58 59 58 59 58 59 58 59 58 59 58
	59 58 59 58 59 58 59 58 59 58 59 58 59 58 59 58
	59 5B 5B 5B 5A 5A 5A 5A 5A 5A 5A 5A 5A 5A 5A 5A
	5A 56 57 56 57 56 57 56 57 56 57 56 57 56 57 56
	57 56 57 56 57 56 57 56 57 56 57 56 57 56 57 56
	57 56 57 56 57 56 57 56 57 56 57 56 57 56 57 58
	59 58 59 58 59 58 59 58 59 58 59 58 59 58 5B 5B
	5B 5A 5A 5A 57 56 57 56 57 56 57 56 57 56 57 56
	57 56 57 56 59 58 59 58 59 58 59 58 59 58 59 58
	59 58 59 58 59 58 59 58 59 58 59 58 59 58 59 58
	59 58 59 58 59 58 59 58 59 58 59 58 59 58 59 58
	59 58 59 58 59 58 59 58 59 58 59 58 59 58 59 58
	59 58 59 58 59 58 59 58 59 58 59 58 59 58 59 58
	59 58 59 58 59 58 59 58 59 58 59 58 59 58 59 00
	.end
; the figure, by finalFrame 0..$E8; past it, leftover bytes
actorBX
	.hex
	0E 0E 0E 0E 0E 0E 0E 0E 0E 0E 0E 0E 0E 0E 0E 0F
	10 10 11 11 12 12 13 14 16 18 1A 1C 1E 20 22 24
	26 29 2B 2D 2F 31 33 35 37 39 3B 3D 3F 41 42 43
	44 45 46 47 48 4A 4B 4C 4D 4E 4E 4E 4E 4E 4E 4E
	4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E
	4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E
	4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E
	4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E
	4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E
	4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E
	4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E
	4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E
	4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E
	4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E
	4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E
	4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 4E 00
	.end
actorBY
	.hex
	29 29 29 29 29 29 29 29 29 29 29 29 29 28 26 23
	20 1B 16 11 0C 07 02 FE FB F8 F6 F5 F5 F5 F5 F5
	F6 F6 F5 F4 F3 F3 F3 F5 F8 FC 01 05 0A 0F 14 19
	1E 23 27 2C 30 34 38 3D 42 47 4B 4E 4E 4F 4F 4F
	4F 4F 4F 4F 4F E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1
	E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1
	E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1
	E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1
	E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1
	E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1
	E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1
	E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1
	E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1
	E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1
	E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1
	E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 E1 00
	.end
actorBShape
	.hex
	4B 4B 4B 4B 4B 4B 4B 4B 4B 4B 4B 4B 4B 4B 4B 4B
	4B 4B 4B 4B 4B 4B 4B 4B 4B 4B 4B 4B 4B 4B 4B 4B
	4B 4B 4B 4B 4B 4B 4B 4B 4B 4B 4B 4B 4B 4B 4B 4B
	4B 4B 4B 4B 4B 4B 4B 4B 4B 4B 4B 4B 4B 62 63 64
	65 65 64 63 62 02 02 02 02 02 02 02 02 02 02 02
	02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
	02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
	02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
	02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
	02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
	02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
	02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
	02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
	02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
	02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
	02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 4B
	.end
; the player, by finalFrame 0..$E8; past it, leftover bytes
actorCX
	.hex
	17 17 17 17 17 17 17 17 17 17 17 17 17 17 17 17
	17 17 17 17 17 17 17 17 17 17 17 17 17 17 17 17
	17 17 17 17 17 17 17 17 17 17 17 17 17 17 17 17
	17 17 17 17 17 17 17 17 17 17 17 17 17 17 17 17
	17 17 17 17 17 17 17 17 17 17 17 17 17 17 17 17
	17 17 17 17 17 17 17 17 17 17 17 17 17 17 17 17
	17 17 17 17 17 17 17 17 17 17 17 17 17 17 17 17
	17 17 17 17 17 17 17 17 17 17 17 17 17 17 17 17
	17 17 17 17 17 17 17 17 17 17 17 17 17 17 17 17
	17 17 17 17 17 17 17 17 17 17 17 16 15 15 14 13
	13 12 12 12 12 12 13 13 15 16 18 1A 1C 1E 20 22
	24 26 28 2A 2C 2E 30 32 34 36 38 3A 3C 3E 40 42
	44 46 48 4A 4C 4E 50 52 54 56 58 5A 5C 5E 60 62
	64 66 68 6A 6C 6E 70 72 74 76 78 7A 7C 7E 80 82
	84 86 88 8A 8C 8E 90 92 93 94 95 96 97 98 99 9A
	9B 9C 9D 9E 9F 9F 9F 9F 9F 9F 9F 9F 9F 9F 9F 00
	.end
actorCY
	.hex
	54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54
	54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54
	54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54
	54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54
	54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54
	54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54
	54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54
	54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54
	54 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54
	54 54 54 54 53 50 4C 48 44 40 3D 3A 38 34 2F 2A
	25 20 1C 18 18 14 0F 0A 08 06 03 00 FD FB FA FA
	FA FA F9 F9 F9 F9 F9 F9 F9 FB FE 02 06 0A 0D 0F
	10 10 11 12 13 13 13 12 12 11 10 0F 0F 0D 0C 0A
	08 05 02 00 FF 00 01 02 03 03 03 03 03 03 03 03
	03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03
	03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 00
	.end
actorCShape
	.hex
	0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C
	0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C
	0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C
	0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C
	0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C
	0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C
	0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C
	0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C
	0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C
	0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C
	0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C
	0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C
	0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C
	0C 0C 0C 0C 0C 0C 0C 0C 10 0C 10 0C 10 0C 10 0C
	10 0C 10 0C 10 0C 10 0C 10 0C 10 0C 10 0C 10 0C
	10 0C 10 0C 10 0C 10 0C 10 0C 10 0C 10 0C 10 0C
	.end
