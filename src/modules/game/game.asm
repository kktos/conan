;
; disk 5000-5FFF into $1000:1FFF
;

		.namespace game1

		.export tone

.macro assertGameStruct
	labels = .array("LAC00","LAC20","LAC40","LAC60","LAC80","LACA0","LACC0","LACF0")
	assertDefinedLabels labels, "Missing game interface fields"
.end

; highscoreses
startLevel 	=	level0::levelEntrypoint ; $A000

; collision rects
; left
LAC00 		=	$AC00
; right
LAC20 		=	$AC20
; top
LAC40 		=	$AC40

; ladder y top
LAC60 		=	$AC60
; ladder y bottom
LAC80 		=	$AC80
; ladder X pos
LACA0 		=	$ACA0

; player boundaries
; player X pos
LACC0 		=	$ACC0
; player Y pos
LACF0 		=	$ACF0

LAD20		=	$AD20
LAD30		=	$AD30
LAD40		=	$AD40

; initial player pos, sprite, globals::currentXspeed
; x
LAD80 		=	$AD80
; y
LAD81 		=	$AD81
; globals::spriteID
LAD82 		=	$AD82
; currentXSpeed
LAD83 		=	$AD83

; Level Exit Arrow
; sprite X
LAD84 		=	$AD84
; sprite Y
LAD85 		=	$AD85
; sprite ID
LAD86 		=	$AD86

; player pos to win
; x
LAD87 		=	$AD87
; y
LAD88 		=	$AD88

L1001=*+1
L1002=*+2
gameStart	jmp L108c

;L1004=*+1
:		lda sys::KBD
		bpl :-

		jmp L102d

L100b		bit sys::KBDSTRB
		stx $1c
		ldx #$3e
		stx $1d
		ldy #$00
		sta ($1c),y
		lda ($22),y
		dex
		bne :-
		dec $1b
		inc $1b
		ldx $1d
		cpx #$3d
		bne :-
		bit sys::SPKR
		bit sys::SPKR

L102d		jmp L108c

;1030
scoreAdd1	jsr drawScore
		rts

;1034
scoreAdd10	jsr drawScore10
		rts

;1038
scoreAdd100	jsr drawScore100
		rts

;103C
scoreAdd1000	jsr drawScore1000
		rts

;1040
scoreAdd5	jsr scoreAdd1
		jsr scoreAdd1
		jsr scoreAdd1
		jsr scoreAdd1
		jsr scoreAdd1
		rts

;1050
scoreAdd25	jsr scoreAdd10
		jsr scoreAdd10
		jsr scoreAdd5
		rts

;105A
scoreAdd50	jsr scoreAdd10
		jsr scoreAdd10
		jsr scoreAdd10
		jsr scoreAdd10
		jsr scoreAdd10
		rts

;106A
scoreAdd75	jsr scoreAdd50
		jsr scoreAdd25
		rts

;1071
scoreAdd250	jsr scoreAdd100
		jsr scoreAdd100
		jsr scoreAdd50
		rts

;107B
tone		txa
L107c		ldx globals::soundSwitch
		pha
		lda sys::SPKR-$10,x
		pla
L1084		tax
L1085		dex
		bne L1085
		dey
		bne L107c
		rts

L108c		jsr L1a00

restart		ldx #$00
		; sprites 	$7500:78FF
		; data 		$7900:78FF
		; data 		$7A00:9BFF
		; code 		$A000:ABFF
		; data 		$AC00:ADFF
		jsr loadLevel

		; anim conan jump / high score
		jsr startLevel

levelLoop	jsr resetVars
		jsr resetVars2
		jsr loadInitLevel

:		jsr startLevel
		stz globals::L0383
		jsr readJoyX
		jsr S179e
		jsr S1891

		jsr readUserInput

		jsr S1160
		jsr S141e
		jsr S1593
		jsr S1e5c
		jsr S18fa
		jsr drawExitArrow
		jsr S1b63
		jsr S1cb0
		jsr readJoyY

		jsr resetIfLastLevel

		jmp :-

onKeyNext
		bit sys::KBDSTRB
		inc globals::level
		jmp L18e6

readUserInput	lda sys::KBD
		sta globals::keypressed

		cmp globals::keySoundSwitch ; D3/53/S
		beq L1154

		cmp globals::keyPause ; 9B/1B/esc
		beq onKeyPause ; pause

		cmp globals::keyRestart ; 8D/0D/return
		beq onKeyRestart ; restart globals::level

		cmp #$EE ; n : next
		beq onKeyNext ; next globals::level

		cmp globals::keyJoystick
		beq L1142 ; joystick only

		cmp globals::keyKeyboard
		beq L114b ; keyboard only

		cmp globals::keyLeft ; 88/08/left arrow
		bne L10fc

		bit sys::KBDSTRB

L10fc		cmp globals::keyRight ;95/15/right arrow
		bne L1104

		bit sys::KBDSTRB
L1104		jsr readJoystick
		rts

; 1108
onKeyRestart	jsr updateHiScore
		bit sys::KBDSTRB
		jmp levelLoop

resetGame
		bit sys::KBDSTRB
		bit sys::TEXTOFF
		bit sys::MIXEDOFF
		bit sys::HIRESON
		bit sys::PAGE2OFF
		jmp restart

; 1123
onKeyPause		bit sys::KBDSTRB
L1126			lda sys::KBD
			sta globals::keypressed
			bmi L1139
			ldx globals::inputMode ; 01:kbd ff:joystick
			bpl L1126 ; if kbd

			lda sys::BUTNO
			bpl L1126
			rts

L1139			cmp globals::keyPause ; 9B/1B/esc
			bne onKeyPause
			bit sys::KBDSTRB
			rts

L1142			ldx #$ff ; input = joystick
			stx globals::inputMode
			bit sys::KBDSTRB
			rts

L114b			ldx #$01 ; input = keyboard
			stx globals::inputMode
			bit sys::KBDSTRB
			rts

L1154			bit sys::KBDSTRB
			lda globals::soundSwitch
			eor #$10
			sta globals::soundSwitch
			rts

S1160			ldx globals::playerDeadAnimIdx
			beq L1168
			jmp L198f

L1168			ldx globals::L0314
			beq L1170
			jmp L15ab

L1170			ldx globals::L0315
			beq L1178
			jmp S1381

L1178			ldx globals::isPlayerJumping
			beq L1180
			jmp L13e5

L1180			ldx globals::L0309
			beq L1188
			jmp L1553

L1188			ldx globals::playerAxeState ; 00:off / FF: on / 01:back to player
			bpl L1190
			jmp L1702

L1190			jsr readKeyboard
			jsr S134e
			jsr S135d
			jsr updatePlayerSprite
			jsr movePlayer
			jsr drawPlayer
			rts

readKeyboard:
			ldx globals::L0378
			bne L11fd

			ldx globals::keypressed
			bpl L11fd

			; jsr logKey

			cpx globals::keyPause
			beq L11fd

			cpx globals::keyLeft
			bne L11bd
			bit sys::KBDSTRB
			jmp onKeyLeft

L11bd			cpx globals::keyRight
			bne L11c8
			bit sys::KBDSTRB
			jmp onKeyRight

L11c8			cpx globals::keyUp
			bne L11d0
			jmp onKeyUp

L11d0			cpx globals::keyDown
			bne L11d8
			jmp onKeyDown

L11d8
			cpx globals::keyAxe
			bne L11e4
			bit sys::KBDSTRB
			jmp onKeyAxe

L11e4			cpx globals::keyJump
			bne L11ef
			bit sys::KBDSTRB
			jmp onKeyJump

L11ef
			stz globals::playerXspeed
			stz globals::playerYspeed
			stz globals::keypressed
			bit sys::KBDSTRB
L11fd			rts


onKeyLeft		jsr S120a
			bcc L121d
			rts

onKeyRight		jsr S120a
			bcc L1228
			rts

S120a			ldx globals::isPlayerJumping
			bne L121b
			ldx globals::L0309
			bne L121b
			ldx globals::L0314
			bne L121b
			clc
			rts

L121b			sec
			rts

L121d			dec globals::playerXspeed
			ldx globals::playerXspeed
			cpx #$fd
			beq L1228
			rts

L1228			inc globals::playerXspeed
			ldx globals::playerXspeed
			cpx #$03
			beq L121d
			rts

updatePlayerSprite:
			ldx globals::L0309
			beq L123f

			ldx globals::L0333
			stx globals::spriteIDNew
			rts

L123f			ldx globals::isPlayerJumping
			bne L128b

			lda globals::playerXspeed
			beq L1275

			ror
			bcs L1256

			lda globals::L030A
			cmp #$03
			bne L1256

			dec globals::L030A
L1256			lda globals::L030A
			cmp #$01
			bne L1262

			ldx #$04
			stx globals::L030A
L1262			lda globals::L030A
			ldy globals::currentXspeed
			bmi L126d

			clc
			adc #$04
L126d			tax
			lda globals::playerAnimIDs,x
			sta globals::spriteIDNew
			rts

L1275			ldx #$04
			stx globals::L030A
			ldy globals::currentXspeed
			bmi L1285
			ldx #$0C
			stx globals::spriteIDNew
			rts

L1285			ldx #$0B
			stx globals::spriteIDNew
			rts

L128b			ldx globals::currentXspeed
			bmi L1296
			ldx #$10
			stx globals::spriteIDNew
			rts

L1296			ldx #$0E
			stx globals::spriteIDNew
			rts

movePlayer:
			lda globals::spriteX
			clc
			adc globals::playerXspeed
			sta globals::spriteXnew
			lda globals::spriteY
			clc
			adc globals::playerYspeed
			sta globals::spriteYNew
			jsr checkBoundsDrawPlayer
			rts

drawPlayer:
			lda globals::playerXspeed
			bne L12d0

			lda globals::playerYspeed
			bne L12d0

			lda globals::L0309
			bne L12cf

			lda globals::spriteID
			cmp #$0d
			bcs L12d0

			cmp globals::spriteIDNew
			bne L12d0
L12cf			rts

L12d0			lda globals::spriteID ; clear current sprite
			ldx globals::spriteX
			ldy globals::spriteY
			jsr spritelib::drawSpriteM

			ldx #$00
			stx spritelib::isCollision
			lda globals::spriteIDNew ; get new sprite info
			sta globals::spriteID
			ldx globals::spriteXnew
			stx globals::spriteX
			ldy globals::spriteYNew
			sty globals::spriteY
			jsr spritelib::drawSpriteM
			rts

S12f7			ldx globals::L037E
			beq L1312

			stx globals::spriteX
			stx globals::spriteXnew
			ldy #$00
			sty globals::L037E
			ldy #$e0
			sty globals::spriteY
			sty globals::spriteYNew
			jmp L1324

L1312			ldx LAD80
			stx globals::spriteX
			stx globals::spriteXnew
			ldy LAD81
			sty globals::spriteY
			sty globals::spriteYNew

L1324			lda LAD83
			sta globals::currentXspeed
			lda LAD82
			sta globals::spriteID
			sta globals::spriteIDNew
			jsr spritelib::drawSpriteM

			ldx #$00
			stx globals::playerXspeed
			stx globals::playerYspeed
			stx globals::L0309
			stx globals::isPlayerJumping
			stx globals::L031E
			stx globals::L0314
			stx globals::L0315
			rts

S134e		ldx globals::playerXspeed
		cpx #$01
		beq L1359
		cpx #$ff
		bne L135c
L1359		stx globals::currentXspeed
L135c		rts

S135d		dec globals::L030A
		bne L1367
		ldx #$04
		stx globals::L030A
L1367		lda globals::L030A
		asl
		asl
		tax
		lda globals::playerXspeed
		beq L1377

		ldy #$10
		jsr tone
L1377		rts

; dead code ?!?
L1378		sty globals::L0377
		lda #$90
		jsr utils::wait
		rts

S1381		jsr movePlayer

		ldx globals::L0314
		beq L13a3

		jsr isSpriteInRect ; c=1 if true
		bcs L13a3

		ldx globals::currentXspeed
		bmi L139b

		ldx #$10
		stx globals::spriteIDNew
		jmp L13b5

L139b		ldx #$0E
		stx globals::spriteIDNew
		jmp L13b5

L13a3		lda globals::jumpAnimIdx
		ldx globals::currentXspeed
		bmi L13ae
		clc
		adc #$08
L13ae		tax
		lda globals::jumpAnimIDs,x
		sta globals::spriteIDNew
L13b5		jsr drawPlayer
		jsr S15fe
		jsr S1953
		bcc L13c5

		dec globals::jumpAnimIdx
		bne L13cf

L13c5		ldx #$00
		stx globals::L0315
		ldx #$08
		stx globals::jumpAnimIdx
L13cf		rts

; 13D0
onKeyJump	inc globals::isPlayerJumping
		lda globals::playerYspeed
		sec
		sbc #$05
		sta globals::playerYspeed
		ldx #$01
		stx globals::L0321
		stx globals::L0383
		rts


L13e5		jsr movePlayer
		jsr updatePlayerSprite
		ldx globals::L0321
		bmi L13fc

		inc globals::L0315
		dec globals::L0321
		dec globals::L0321
		jmp L1414

L13fc		ldx #$00
		stx globals::isPlayerJumping
		ldx #$04
		stx globals::L030A
		jsr S1953
		bcc L1414

		inc globals::L0314
		inc globals::L0315
		jmp S1381

L1414		jsr S1953
		jsr drawPlayer
		jsr S15fe
		rts

S141e		ldx globals::L0309
		bne L1440

		ldx globals::L0314
		bne L1433

		ldx globals::L0315
		bne L1433

		ldx globals::isPlayerJumping
		bne L1433

		rts

L1433		inc globals::playerYspeed
		ldx globals::playerYspeed
		cpx #$06
		bne L1440

		dec globals::playerYspeed
L1440		rts

S1441:
		ldx globals::playerYspeed
		bmi L1485

		ldx #$ff
		stx globals::L0322

L144b		inc globals::L0322
		ldx globals::L0322
		lda LAC40,x
		beq L1485

		lda globals::spriteXnew
		cmp LAC00,x
		bcc L144b

		cmp LAC20,x
		beq L1465

		bcs L144b

L1465		lda LAC40,x
		clc
		adc #$03
		cmp globals::spriteYNew
		bcc L144b

		sec
		sbc globals::playerYspeed
		sec
		sbc #$03
		cmp #$f8
		bcs L1480

		cmp globals::spriteYNew
		bcs L144b

L1480		stx globals::L0379
		clc
		rts
L1485		sec
		rts

; 1487
onKeyUp 	ldx globals::L0309
		beq L149d
		ldx #$fe
		stx globals::playerYspeed
		rts

; 1492
onKeyDown	ldx globals::L0309
		beq L14b3
		ldx #$02
		stx globals::playerYspeed
		rts

L149d		jsr isPlayerOnLadder
		bcc L14b2
		ldx globals::L0317
		bpl L14b2
		ldx #$fe
		stx globals::playerYspeed
		inc globals::L0309
		jmp L1553
L14b2		rts

L14b3		jsr isPlayerOnLadder
		bcc L14b2
		ldx globals::L0317
		bmi L14b2
		beq L14b2
		ldx #$02
		stx globals::playerYspeed
		inc globals::L0309
		jmp L1553

isPlayerOnLadder:
		ldx #$ff
		stx globals::L0322
L14cf		inc globals::L0322
		ldx globals::L0322
		lda LAC60,x
		beq L1543

		lda LACA0,x
		tay
		dey
		dey
		cpy globals::spriteX
		beq L14f4

		iny
		cpy globals::spriteX
		beq L14f4

		iny
		cpy globals::spriteX
		beq L14f4

		jmp L14cf

L14f4		lda LAC60,x
		cmp globals::spriteY
		beq L1527
		bcs L14cf

		lda LAC80,x
		cmp globals::spriteY
		beq L1535
		bcc L14cf

		lda LACA0,x
		sta globals::spriteXnew
		ldx globals::spriteY
		stx globals::spriteYNew
		ldx globals::spriteID
		stx globals::spriteIDNew
		jsr drawPlayer
		ldx #$00
		stx globals::L0317
		stx globals::playerXspeed
		sec
		rts

L1527		ldx #$01
		stx globals::L0317
		dex
		stx globals::playerXspeed
		stx globals::playerYspeed
		sec
		rts

L1535		ldx #$ff
		stx globals::L0317
		inx
		stx globals::playerXspeed
		stx globals::playerYspeed
		sec
		rts

L1543		clc
		ldx #$00
		stx globals::L0309
		rts

toggleSpriteID:
		lda globals::L0333
		eor #$01
		sta globals::L0333
		rts

L1553		jsr S1575
		jsr updatePlayerSprite
		jsr movePlayer
		jsr drawPlayer
		jsr isPlayerOnLadder
		ldx globals::playerYspeed
		beq L156a

		jsr toggleSpriteID
L156a		ldx globals::L0317
		beq L1574

		ldx #$00
		stx globals::L0309
L1574		rts

S1575		ldx globals::keypressed
		bpl L1592

		cpx globals::keyUp
		bne L1582
		jmp onKeyUp

L1582		cpx globals::keyDown
		bne L158a
		jmp onKeyDown

L158a		ldx #$00
		stx globals::playerXspeed
		stx globals::playerYspeed
L1592		rts

S1593		jsr S1441
		bcc L15aa
		ldx globals::isPlayerJumping
		bne L15aa
		ldx globals::L0309
		bne L15aa
		ldx globals::playerAxeState ; 00:off / FF: on / 01:back to player
		bmi L15aa
		inc globals::L0314
L15aa		rts

L15ab:
		ldx globals::L0315
		bne :+

		inc globals::L0315
:		jsr S1381
		jsr S1441
		bcs :+

		ldx #$00
		stx globals::L0315
		stx globals::L0314
		stx globals::isPlayerJumping
		jsr drawPlayer
:		rts

isSpriteInRect:
		ldx #$ff
		stx globals::L0322
L15cf		inc globals::L0322
		ldx globals::L0322
		lda LAC40,x
		beq L15fc

		lda globals::spriteXnew
		cmp LAC00,x
		bcc L15cf

		cmp LAC20,x
		bcs L15cf

		lda LAC40,x
		clc
		adc #$06
		cmp globals::spriteYNew
		bcc L15cf

		sec
		sbc #$10
		cmp globals::spriteYNew
		bcs L15cf

		clc
		rts

L15fc		sec
		rts

S15fe:
		ldx spritelib::isCollision
		beq L1637

		ldx globals::L031E
		bne L1637

		ldx globals::L0373
		bne L1637

		jsr S164d
		bcs L1637

		jsr S1638
		lda globals::spriteXnew
		sec
		sbc globals::playerXspeed
		sta globals::spriteXnew
		ldx globals::spriteID
		stx globals::spriteIDNew
		jsr drawPlayer
		ldx #$01
		stx globals::L0314
		dex
		stx globals::playerYspeed
		stx globals::playerXspeed
		inc globals::L031E
L1637		rts

S1638		lda globals::spriteX
		sec
		sbc globals::playerXspeed
		sta globals::spriteXnew
		lda globals::spriteY
		sec
		sbc globals::playerYspeed
		sta globals::spriteYNew
		rts

S164d:
		ldx #$ff
		stx globals::L0322
L1652		inc globals::L0322
		ldx globals::L0322
		lda LAC60,x
		beq L167f

		cmp globals::spriteY
		bcs L1652

		lda LAC80,x
		cmp globals::spriteY
		bcc L1652

		lda LACA0,x
		sec
		sbc #$08
		cmp globals::spriteX
		bcs L1652

		clc
		adc #$0b
		cmp globals::spriteX
		bcc L1652

		sec
		rts

L167f		clc
		rts

checkBoundsDrawPlayer:
		ldx #$ff
		stx globals::L0322

L1686		inc globals::L0322
		ldx globals::L0322
		lda LACF0,x
		beq L16d1

		lda globals::spriteXnew
		cmp LACC0,x
		beq L16a1
		tay
		iny
		tya
		cmp LACC0,x
		bne L1686

L16a1		lda LACF0,x
		cmp globals::spriteYNew
		bne L1686

		lda LACC0,x
		sta globals::spriteXnew

		ldx globals::currentXspeed
		bmi L16ba

		dec globals::spriteXnew
		jmp L16bd

L16ba		inc globals::spriteXnew
L16bd		ldx #$00
		stx globals::playerXspeed
		stx globals::playerYspeed
		jsr updatePlayerSprite

		ldx globals::spriteY
		stx globals::spriteYNew
		jsr drawPlayer
L16d1		rts


; 16D2
onKeyAxe	ldx globals::L0309
		bne L1701

		ldx globals::L0314
		bne L1701

		ldx globals::L0315
		bne L1701

		ldx globals::isPlayerJumping
		bne L1701

		ldx globals::playerAxeState ; 00:off / FF: on / 01:back to player
		bne L1701

		ldx globals::playerAxeCountHi
		bne L16f5

		ldx globals::playerAxeCountLo
		beq L1701

L16f5		ldx #$ff
		stx globals::playerAxeState ; 00:off / FF: on / 01:back to player
		inx
		stx globals::playerAxeAnim ; 00: normal / 01: axe behind / 02: axe forward
		jsr updAxeCount
L1701		rts

L1702		lda globals::playerAxeAnim ; 00: normal / 01: axe behind / 02: axe forward
		cmp #$02
		beq L1739
		ldy globals::currentXspeed
		bmi L1711
		clc
		adc #$02
L1711		tay
		lda globals::axeAnimIDs,y
		sta globals::spriteIDNew
		lda globals::spriteX
		ldx globals::playerAxeAnim ; 00: normal / 01: axe behind / 02: axe forward
		dex
		bne L1729

		ldy globals::currentXspeed
		bpl L1729
		sec
		sbc #$02

L1729		sta globals::spriteXnew
		ldy globals::spriteY
		sty globals::spriteYNew
		jsr drawPlayer

		inc globals::playerAxeAnim ; 00: normal / 01: axe behind / 02: axe forward
		rts

L1739		ldx #$01
		stx globals::playerAxeState ; 00:off / FF: on / 01:back to player
		lda globals::spriteX
		ldy globals::currentXspeed
		bmi L1754
		ldx #$03
		stx globals::L033A
		clc
		adc #$07
		sta globals::axeXpos
		jmp L175f

L1754		sec
		sbc #$03
		sta globals::axeXpos
		ldx #$fd
		stx globals::L033A
L175f		lda globals::spriteY
		clc
		adc #$02
		sta globals::axeYpos
		lda #$1e
		sta globals::axeSpriteID
		jsr drawAxe
		ldx globals::currentXspeed
		stx globals::L031D
		ldx #$08
		stx globals::L0338
		ldx #$01
		stx globals::L0339
		stx globals::playerAxeState ; 00:off / FF: on / 01:back to player
		jsr updatePlayerSprite
		lda globals::spriteX
		ldy globals::currentXspeed
		bpl L1791
		clc
		adc #$02
L1791		sta globals::spriteXnew
		ldx globals::spriteY
		stx globals::spriteYNew
		jsr drawPlayer
		rts

S179e		ldx globals::playerAxeState ; 00:off / FF: on / 01:back to player
		dex
		bpl L17a5
		rts

L17a5		jsr eraseAxe
		dec globals::L0338
		beq L17cd
L17ad		lda globals::axeXpos
		clc
		adc globals::L033A
		sta globals::axeXpos
		inc globals::axeSpriteID
		ldx globals::axeSpriteID
		cpx #$21
		bne L17c6
		ldx #$1e
		stx globals::axeSpriteID
L17c6		jsr drawAxe
		jsr S182b
		rts

L17cd		inc globals::L0338
		ldx globals::L0339
		bpl L17db
		inc globals::axeYpos
		jmp L17ad

L17db		ldx globals::L031D
		bmi L17ed
		dec globals::L033A
		ldx globals::L033A
		cpx #$fd
		beq L17fa
		jmp L17ad

L17ed		inc globals::L033A
		ldx globals::L033A
		cpx #$03
		beq L17fa
		jmp L17ad

L17fa		ldx #$08
		stx globals::L0338
		ldx #$ff
		stx globals::L0339
		jmp L17ad

drawAxe:
		stz spritelib::isCollision
		ldx globals::axeXpos
		ldy globals::axeYpos
		lda globals::axeSpriteID
		jmp spritelib::drawSpriteM

holsterAxe
		jsr eraseAxe
		ldx #$00
		stx globals::playerAxeState ; 00:off / FF: on / 01:back to player
		stx globals::playerAxeAnim ; 00: normal / 01: axe behind / 02: axe forward
		stx globals::axeXpos
		stx globals::axeYpos
		rts

S182b		jsr testIncAxeCount
		ldx spritelib::isCollision
		beq L1841

		jsr S1b93
		jsr S185a
		bcs L1841
		jsr soundlib::L0A50
L183e		bra holsterAxe

L1841		ldx globals::axeXpos
		cpx #$f0
		bcs L184c
		cpx #$9d
		bcs L183e
L184c		rts

eraseAxe
		ldx globals::axeXpos
		ldy globals::axeYpos
		lda globals::axeSpriteID
		jmp spritelib::drawSpriteM

S185a		ldx #$ff
		stx globals::L0322
L185f		inc globals::L0322
		ldx globals::L0322
		lda LAC60,x
		beq L188f
		lda globals::axeYpos
		cmp LAC60,x
		bcc L185f
		sec
		sbc #$10
		cmp LAC80,x
		bcs L185f
		lda LACA0,x
		sec
		sbc #$08
		cmp globals::axeXpos
		bcs L185f
		clc
		adc #$13
		cmp globals::axeXpos
		bcc L185f
		sec
		rts

L188f		clc
		rts

S1891		ldx globals::spriteY
		cpx LAD88
		bne L18a7
		ldx globals::spriteX
		cpx LAD87
		beq L18a8
		dex
		cpx LAD87
		beq L18a8
L18a7		rts

L18a8		jsr soundlib::L0A00

loadInitLevel
		ldx globals::L037E
		bne :+

		ldx globals::level
		stx globals::levelCnt
L18b6		dec globals::levelCnt
		bmi :+
		jsr scoreAdd100
		jmp L18b6

		.echo "HOOK",.hex(*)

:		ldx globals::L037E
		beq L18d9

		ldx #globals::level-globals::playerData
		stx globals::level
		jsr drawDigit
		dec globals::level
		ldx #globals::level-globals::playerData
		jsr drawDigit
		jmp L18e6

L18d9		ldx #globals::level-globals::playerData
		jsr drawDigit
		inc globals::level
		ldx #globals::level-globals::playerData
		jsr drawDigit

L18e6		ldx globals::level
		jsr loadLevel

		ldx #$00
		stx globals::playerAxeState ; 00:off / FF: on / 01:back to player
		stx globals::keypressed
		bit sys::KBDSTRB
		jmp S12f7

;
S18fa		ldx #$ff
		stx globals::L0322
L18ff		inc globals::L0322
		ldx globals::L0322
		lda LAD30,x
		beq L1925

		jsr S1926

		ldx globals::L0322
		inc LAD40,x
		lda LAD40,x
		cmp #$24
		bne L191f
		lda #$21
		sta LAD40,x
L191f		jsr S1926

		jmp L18ff

L1925		rts

S1926		lda LAD30,x
		tay
		lda LAD20,x
		sta globals::L033B
		lda LAD40,x
		ldx globals::L033B
		jsr spritelib::drawSprite
		rts

;
drawExitArrow:
		inc globals::L033C
		lda globals::L033C
		ror
		bcs L1952

		ror
		bcs L1952

		ldx LAD84
		ldy LAD85
		lda LAD86
		jsr spritelib::drawSprite
L1952		rts

S1953:
		jsr S1441
		bcs :+
		lda LAC40,x
		sta globals::spriteYNew
		inc globals::spriteYNew
		lda globals::spriteX
		clc
		adc globals::playerXspeed
		sta globals::spriteXnew
		jsr updatePlayerSprite
		jsr drawPlayer
		ldx #$00
		stx globals::playerYspeed
		stx globals::L031E
:		rts

drawDigit	lda globals::playerData,x
		tay
		lda globals::L033C,x
		tax
		tya
		ldy #$b9
		cmp #$00
		bne L198b
		lda #$0a
L198b		jsr spritelib::drawSprite
		rts

L198f		jsr soundlib::L0A2D
		ldx globals::playerDeadAnimIdx
		cpx #$08
		bcs L19bd
		jsr S19aa
		inc globals::playerDeadAnimIdx
		ldx globals::playerDeadAnimIdx
		cpx #$08 ; anim player dying: 7 frames
		beq L19a9
		jsr S19aa
L19a9		rts

S19aa		ldx globals::playerDeadAnimIdx
		lda globals::playerDeadAnimIdx,x
		sta globals::spriteID
		ldx globals::spriteX
		ldy globals::spriteY
		jsr spritelib::drawSpriteM
		rts

L19bd		inc globals::playerDeadAnimIdx
		ldx globals::playerDeadAnimIdx
		cpx #$18
		beq L19c8
		rts

L19c8		jsr updLifeCount
		jsr S12f7
		ldx #$00
		stx globals::playerDeadAnimIdx
		ldy globals::playerAxeState ; 00:off / FF: on / 01:back to player
		bpl :+

		stx globals::playerAxeState ; 00:off / FF: on / 01:back to player
:		bit sys::KBDSTRB
		rts

updLifeCount	ldx #globals::playerLifeCount-globals::playerData ; #$06
		jsr drawDigit
		dec globals::playerLifeCount ; cheat
		bmi :+

		ldx #globals::playerLifeCount-globals::playerData ; #$06
		jsr drawDigit
		rts

:		inc globals::playerLifeCount
		ldx #globals::playerLifeCount-globals::playerData
		jsr drawDigit
		jsr updateHiScore
		jsr S1c6b
		jmp restart

L1a00		ldx #globals::playerAxeCountLo-globals::playerData
		stx globals::L0322
:		ldx globals::L0322
		jsr drawDigit
		dec globals::L0322
		bne :-
		rts

resetVars2
		jsr L1a00
		ldx #$00
		stx globals::playerScore
		stx globals::playerScore+1
		stx globals::playerScore+2
		stx globals::playerScore+3
		stx globals::playerScore+4
		stx globals::playerAxeCountLo
		stx globals::level
		inx
		stx globals::playerAxeCountHi
		inx
		stx globals::playerLifeCount
		jsr L1a00
		rts

fbkgnd		.pstr "L0.BKGD"
fdata		.pstr "L0.DATA"
fcode		.pstr "L0.CODE"
fbitmap		.pstr "L0.BMP"

		.if loadLevel
		.out "loadLevel : ",.hex(loadLevel)
		.end

loadLevel	stx globals::L0381
; 		lda #$00
; L1a3c		dex
; 		bmi init2

; 		clc
; 		adc #$06
; 		jmp L1a3c

; load welcome screen
; 1A45
;init2
		txa
		clc
		adc #$30
		sta fbkgnd+2
		sta fdata+2
		sta fcode+2
		sta fbitmap+2

		read_file fbkgnd

		; unpack & display
		; jsr unpackToHgr
		lda #$00
		ldx #$75
		ldy #183
		jsr unpack::run

		read_file fdata
		read_file fcode
		read_file fbitmap

		rts

		.if 0
		sta globals::rangeIdx
		tay
		;
		; R0 : background image
		;
		; L0:12 T00S1-8 / M7500-7CFF
		; L1:	T03SE-T04S5 / M7500-7CFF
		; L2:	T05SB-T06S4 / M7500-
		; L3:	T07SF-T08S5 / M7500-
		; L4:	T0BS1-T0BS5 / M7500-
		; L5:	T0ES7-T0FS5 / M7500-
		; L6:	T12S0-T12S5 / M7500-
		; L7:	T15S7-T16S5 / M7500-
		; L8:	T19SC-T1AS5 / M7500-
		; L9:	T1ASF-T00S0 / M7500-
		ldx #$75
		stx rwts_buf+1
		jsr loadRange

		; unpack & display
		jsr unpackToHgr

		; lda #$00
		; ldx #$75
		; jsr unpack.run

		inc globals::rangeIdx
		ldy globals::rangeIdx

		;
		; R1 : data (anim?, sprites)
		;
		; L0:13 T0S9-C / M7500-78FF
		; L1:	T4S6 / M7500-75FF
		; L2:	T6S5 / M7500-75FF
		ldx #$75
		stx rwts_buf+1
		jsr loadRange

		inc globals::rangeIdx
		ldy globals::rangeIdx

		;
		; R2 : data
		;
		; L0:14 T0SD/ M7900-79FF
		; L1:	T4S7/ M7900-79FF
		; L2:	T6S6/ M7900-79FF
		ldx #$79
		stx rwts_buf+1
		jsr loadRange

		inc globals::rangeIdx
		ldy globals::rangeIdx

		;
		; R3 : data
		;
		; L0:15 T0SE-T2SF / M7A00-9BFF
		; L1:	T4S8-T4SF / M7A00-81FF
		; L2:	T6S7-T7S6 / M7A00-89FF
		ldx #$7A
		stx rwts_buf+1
		jsr loadRange

		inc globals::rangeIdx
		ldy globals::rangeIdx

		;
		; R4 : code
		;
		; L0:16 T3S0-T3SB / MA000-ABFF
		; L1:	T5S0-T5S8 / MA000-A7FF
		; L2:	T7S7-T7SC / MA000-A5FF
		ldx #$A0
		stx rwts_buf+1
		jsr loadRange

		inc globals::rangeIdx
		ldy globals::rangeIdx

		;
		; R5 : data
		;
		; L0: T3SC-T3SD / MAC00-ADFF
		; L1: T5S9-T5SA / MAC00-ADFF
		; L2: T7SD-T7SE / MAC00-ADFF
		ldx #$AC
		stx rwts_buf+1
		jsr loadRange
		rts


; 1B1D
readSector	ldx globals::track
		stx rwts_trk
		ldx globals::sector
		stx rwts_sec
		ldx #$00
		stx rwts_vol
		stx $48
		ldy #$e8
		lda #$b7
		jsr rwts
		rts

		.end

updAxeCount	ldx #globals::playerAxeCountLo-globals::playerData
		jsr drawDigit
		dec globals::playerAxeCountLo ; cheat
		bmi L1b48

		ldx #globals::playerAxeCountLo-globals::playerData
		jsr drawDigit
		rts

L1b48		ldx #globals::playerAxeCountLo-globals::playerData
		stx globals::playerAxeCountLo
		jsr drawDigit

		ldx globals::playerAxeCountHi
		beq L1b62

		ldx #$08
		jsr drawDigit
		dec globals::playerAxeCountHi
		ldx #$08
		jsr drawDigit
L1b62		rts

S1b63		jsr S1441
		bcs L1b69
		rts

L1b69		ldx globals::spriteX
		cpx #$f0
		bcs L1b7c
		cpx #$89
		bcc L1b92
		ldx #$88
		stx globals::spriteXnew
		jmp L1b81

L1b7c		ldx #$00
		stx globals::spriteXnew
L1b81		ldx globals::spriteID
		stx globals::spriteIDNew
		jsr drawPlayer
		ldx #$00
		stx globals::playerXspeed
		stx globals::playerYspeed
L1b92		rts

S1b93		ldx globals::playerDeadAnimIdx
		bne L1b92
		lda globals::spriteX
		sec
		sbc #$05
		cmp globals::axeXpos
		bcs L1b92
		clc
		adc #$0c
		cmp globals::axeXpos
		bcc L1b92
		lda globals::spriteY
		sec
		sbc #$03
		cmp globals::axeYpos
		bcs L1b92
		clc
		adc #$11
		cmp globals::axeYpos
		bcc L1b92
		jsr incAxeCount
		jsr holsterAxe
		jsr soundlib::L0AD7
		pla
		pla
		rts

incAxeCount:
		ldx #$09
		jsr drawDigit
		inc globals::playerAxeCountLo
		ldx globals::playerAxeCountLo
		cpx #$0a
		beq L1bdf
		ldx #$09
		jsr drawDigit
		rts

L1bdf		ldx #$00
		stx globals::playerAxeCountLo
		ldx #$09
		jsr drawDigit
		ldx #$08
		jsr drawDigit
		inc globals::playerAxeCountHi
		ldx #$08
		jsr drawDigit
		rts

S1bf7		jsr S1bfe
		jsr S1c20
		rts

S1bfe		ldx #$3b
		stx globals::unknown_yPos
L1c03		jsr S1c11
		inc globals::unknown_yPos
		ldx globals::unknown_yPos
		cpx #$7e
		bne L1c03
		rts

S1c11		jsr getHGRLineAddr
		ldy #$0c
		lda #$00
L1c18		sta ($1a),y
		iny
		cpy #28
		bne L1c18
		rts

S1c20		ldx #$00
		stx $1c
		ldx #$75
		stx $1d
		ldx #$41
		stx globals::unknown_yPos
L1c2d		jsr S1c3b
		inc globals::unknown_yPos
		ldx globals::unknown_yPos
		cpx #$79
		bne L1c2d
		rts

S1c3b		jsr getHGRLineAddr
		ldy #$0d
		sty globals::unknown_xPos
L1c43		ldy #$00
		lda ($1c),y
		ldy globals::unknown_xPos
		sta ($1a),y
		inc $1c
		bne L1c52
		inc $1d
L1c52		inc globals::unknown_xPos
		ldy globals::unknown_xPos
		cpy #$1c
		bne L1c43
		rts

getHGRLineAddr
		ldx globals::unknown_yPos
		lda utils::hgrLow,x
		sta $1a
		lda utils::hgrHigh,x
		sta $1b
		rts

S1c6b		jsr S1e97
		and #$03
		asl
		asl
		sta rwts_sec
		lda globals::level
		clc
		adc #$1a
		sta rwts_trk
		ldx #$75
		stx rwts_buf+1
		ldx #$00
		stx rwts_buf
		;jsr readTrack
		brk
		brk
		brk
		jsr S1bf7

		bit sys::KBDSTRB
		ldy #$60

L1c93		lda #$ff
		jsr utils::wait

		lda sys::KBD
		bmi L1ca5

		jsr readJoyBtn0
		bcs L1ca5

		dey
		bne L1c93

L1ca5		bit sys::KBDSTRB
		cpy #$00
		beq L1caf
		jmp levelLoop

L1caf		rts

S1cb0		inc globals::soundCnt1
		lda globals::soundCnt1
		adc $7900
		adc globals::playerScore+3
		sta globals::soundCnt1
L1cbf		rts

readJoystick:
		ldx globals::inputMode ; 01:kbd ff:joystick
		bpl L1cbf ; if kdb

		ldx globals::L0309
		beq L1ccf
		ldx #$00
		jmp L1d01

L1ccf		ldx sys::BUTNO
		bmi L1d16

		ldx globals::playerAxeState ; 00:off / FF: on / 01:back to player
		bne L1cde

		ldx sys::BUTN1
		bmi L1d1d

L1cde		ldx #$fe
		lda globals::joyX
		cmp #$10
		bcc L1cf7
		inx
		cmp #$40
		bcc L1cf7
		inx
		cmp #$c0
		bcc L1cf7
		inx
		cmp #$f0
		bcc L1cf7
		inx
L1cf7		cpx globals::playerXspeed
		beq L1d01
		bmi L1d32
		jmp L1d39

L1d01		ldy globals::joyY
		cpy #$30
		bcc L1d24
		cpy #$d0
		bcs L1d2b
		cpx #$00
		bne L1d15
		ldx #$ff
		stx globals::keypressed
L1d15		rts

L1d16		ldx globals::keyJump
		stx globals::keypressed
		rts

L1d1d		ldx globals::keyAxe
		stx globals::keypressed
		rts

L1d24		ldx globals::keyUp
		stx globals::keypressed
		rts

L1d2b		ldx globals::keyDown
		stx globals::keypressed
		rts

L1d32		ldx globals::keyLeft
		stx globals::keypressed
		rts

L1d39		ldx globals::keyRight
		stx globals::keypressed
		rts

resetVars	bit sys::KBDSTRB
		stz globals::playerDeadAnimIdx
		stz globals::L031E
		stz globals::isPlayerJumping
		stz globals::playerAxeState ; 00:off / FF: on / 01:back to player
		stz globals::L0314
		stz globals::L0315
		stz globals::L0309
		stz globals::playerXspeed
		stz globals::playerYspeed

		ldx globals::assetKeyCnt
		beq L1d6f

		ldx #globals::assetKey
		jsr drawAsset
		stz globals::assetKeyCnt

L1d6f		ldx globals::assetGemCnt
		beq L1d7e

		ldx #globals::assetGem
		jsr drawAsset
		stz globals::assetGemCnt
L1d7e		rts

readJoyX	ldx #$00
		jsr utils::PREAD
		sty globals::joyX
		rts

readJoyY	ldx #$01
		jsr utils::PREAD
		sty globals::joyY
		rts

drawAsset	txa
		tay
		lda globals::assetXpos-1,y
		tax
		tya
		clc
		adc #$26
		ldy #185
		jsr spritelib::drawSprite
		rts

;
; DRAWSCORE
;

drawScore	ldx #$05
		jsr drawDigit
		ldx #$05
		inc globals::playerScore+4
		ldy globals::playerScore+4
		cpy #$0a
		beq :+
		jsr drawDigit
		rts

:		lda #$00
		sta globals::playerScore+4
		jsr drawDigit

drawScore10	ldx #$04
		jsr drawDigit
		ldx #$04
		inc globals::playerScore+3
		ldy globals::playerScore+3
		cpy #$0a
		beq :+
		jsr drawDigit
		rts

:		lda #$00
		sta globals::playerScore+3
		jsr drawDigit

drawScore100	ldx #$03
		jsr drawDigit
		ldx #$03
		inc globals::playerScore+2
		ldy globals::playerScore+2
		cpy #$0a
		beq :+
		jsr drawDigit
		rts

:		lda #$00
		sta globals::playerScore+2
		jsr drawDigit

drawScore1000	ldx #$02
		jsr drawDigit
		ldx #$02
		inc globals::playerScore+1
		ldy globals::playerScore+1
		cpy #$0a
		beq :+
		jsr drawDigit
		rts

:		lda #$00
		sta globals::playerScore+1
		jsr drawDigit
		ldx #$01
		jsr drawDigit
		inc globals::playerScore
		ldx #$01
		jsr drawDigit
		rts

updateHiScore
		ldx #$00
L1e25		lda globals::highScore,x
		cmp globals::playerScore,x
		bcc L1e35
		bne L1e34
		inx
		cpx #$05
		bne L1e25
L1e34		rts

L1e35		ldx #$04
L1e37		lda globals::playerScore,x
		sta globals::highScore,x
		dex
		bpl L1e37
L1e40		rts

resetIfLastLevel
		ldx globals::level
		cpx #$09
		bne L1e40
		dec globals::level
		jmp resetGame

readJoyBtn0	lda globals::inputMode ; 01:kbd ff:joystick
		bpl L1e5a ; if kbd

		lda sys::BUTNO
		bpl L1e5a
		sec
		rts

L1e5a		clc
L1e5b		rts

S1e5c		ldx globals::playerAxeState ; 00:off / FF: on / 01:back to player
		dex
		bmi L1e5b

		lda globals::L0339
		bpl L1e70

		lda #$09
		sec
		sbc globals::L0338
		jmp L1e73

L1e70		lda globals::L0338
L1e73		asl
		asl
		sta globals::axeSndCnt1
L1e78		lda #$02
L1e7a		ldy globals::axeSndCnt1
		ldx globals::soundSwitch
L1e80		cmp sys::SPKR-$10,x
		dey
		bne L1e80
		sec
		sbc #$01
		bne L1e7a
		lda globals::axeSndCnt1
		sec
		sbc #$01
		sta globals::axeSndCnt1
		bne L1e78
		rts

S1e97		rol $4e
		rol globals::soundCnt1
		rol globals::sountCnt2
		lda $4e
		asl
		eor $4f
		eor globals::sountCnt2
		rol
		rol
		rol
		rol
		rol
		pha
		rol $4f
		lda $4f
		eor globals::soundCnt1
		sta $4e
		pla
		sta globals::sountCnt2
		adc $4e
		adc globals::soundCnt1
		sta globals::soundCnt3
		rts

		.if 0
;
; LOADRANGE Y:range idx
;
; 1EC3
loadRange	lda levels::rangeTracks,y
		sta globals::track
		lda levels::rangeSectors,y
		sta globals::sector
		iny
		lda levels::rangeTracks,y
		sta globals::trackend
		lda levels::rangeSectors,y
		sta globals::sectorend
		ldx #$00
		stx rwts_buf

		; check if ptrs =. exit of true
:		ldx globals::sector
		cpx globals::sectorend
		bne L1ef2
		ldx globals::track
		cpx globals::trackend
		bne L1ef2
		rts

L1ef2		jsr readSector
		inc rwts_buf+1
		inc globals::sector
		ldx globals::sector
		cpx #$10
		bne :-
		ldx #$00
		stx globals::sector
		inc globals::track
		jmp :-


readTrack	jsr S1f1e
		inc rwts_buf+1
		inc rwts_sec
		ldx rwts_sec
		cpx #$10
		bne readTrack
		rts

S1f1e		ldx #$00
		stx rwts_vol
		stx $48
		ldy #$e8
		lda #$b7
		jsr rwts

		.end

L1f2c		rts

testIncAxeCount:
		ldx globals::playerDeadAnimIdx
		bne L1f2c

		lda globals::spriteX
		sec
		sbc #$02
		cmp globals::axeXpos
		bcs L1f2c

		clc
		adc #$04
		cmp globals::axeXpos
		bcc L1f2c

		lda globals::spriteY
		sec
		sbc #$03
		cmp globals::axeYpos
		bcs L1f2c

		clc
		adc #$11
		cmp globals::axeYpos
		bcc L1f2c

		jsr incAxeCount
		jsr holsterAxe
		jsr soundlib::L0AD7
		pla
		pla
		rts
;L1f64
		.align $100

	; .hex
	; c2 ce c5 a0 ce cf d7 c9 ce 8d a0 cc
	; c4 d8 a0 a4 b3 b0 b0 8d a0 c3 d0 d8 a0 a4 c1 c4
	; b8 b7 8d a0 c2 c5 d1 a0 d7 c9 ce cc c5 d6 8d a0
	; c4 c5 d8 8d a0 c3 d0 d8 a0 a4 c1 c4 b8 b7 8d a0
	; c2 c5 d1 a0 d7 c9 ce cc c5 d6 8d ce cf d7 c9 ce
	; a0 d2 d4 d3 8d d7 c9 ce cc c5 d6 a0 ca d3 d2 a0
	; d7 c9 ce d3 cf d5 8d cc c5 d6 c5 cc a0 cc c4 d8
	; a0 a4 b3 b7 c5 8d a0 c2 ce c5 a0 c5 ce c4 c2 cf
	; ce d5 d3 8d a0 cc c4 d8 a0 a4 b3 b4 c3 8d a0 d3
	; d4 d8 a0 a4 b3 b7 c6 8d c2 cf ce d5 d3 cc cf a0
	; .end

		.end namespace
