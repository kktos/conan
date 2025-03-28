;
; disk 5000-5FFF into $1000:1FFF
;

		.segment GAME_CODE
		.namespace game1

		.export tone

.macro assertGameStruct
	labels = .array("LAC00","LAC20","LAC40","LAC60","LAC80","LACA0","LACC0","LACF0")
	assertDefinedLabels labels, "Missing game interface fields"
.end

; highscoreses
startLevel 	=	$A000

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

; initial player pos, sprite, currentXspeed
; x
LAD80 		=	$AD80
; y
LAD81 		=	$AD81
; spriteID
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
!		lda sys.KBD
		bpl !-

		jmp L102d

L100b		bit sys.KBDSTRB
		stx $1c
		ldx #$3e
		stx $1d
		ldy #$00
		sta ($1c),y
		lda ($22),y
		dex
		bne !-
		dec $1b
		inc $1b
		ldx $1d
		cpx #$3d
		bne !-
		bit sys.SPKR
		bit sys.SPKR

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
L107c		ldx soundSwitch
		pha
		lda sys.SPKR-$10,x
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
		stz L0383
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
		bit sys.KBDSTRB
		inc level
		jmp L18e6

readUserInput	lda sys.KBD
		sta keypressed

		cmp keySoundSwitch ; D3/53/S
		beq L1154

		cmp keyPause ; 9B/1B/esc
		beq onKeyPause ; pause

		cmp keyRestart ; 8D/0D/return
		beq onKeyRestart ; restart level

		cmp #$EE ; n : next
		beq onKeyNext ; next level

		cmp keyJoystick
		beq L1142 ; joystick only

		cmp keyKeyboard
		beq L114b ; keyboard only

		cmp keyLeft ; 88/08/left arrow
		bne L10fc

		bit sys.KBDSTRB

L10fc		cmp keyRight ;95/15/right arrow
		bne L1104

		bit sys.KBDSTRB
L1104		jsr readJoystick
		rts

; 1108
onKeyRestart	jsr updateHiScore
		bit sys.KBDSTRB
		jmp levelLoop

resetGame
		bit sys.KBDSTRB
		bit sys.TEXTOFF
		bit sys.MIXEDOFF
		bit sys.HIRESON
		bit sys.PAGE2OFF
		jmp restart

; 1123
onKeyPause		bit sys.KBDSTRB
L1126			lda sys.KBD
			sta keypressed
			bmi L1139
			ldx inputMode ; 01:kbd ff:joystick
			bpl L1126 ; if kbd

			lda sys.BUTNO
			bpl L1126
			rts

L1139			cmp keyPause ; 9B/1B/esc
			bne onKeyPause
			bit sys.KBDSTRB
			rts

L1142			ldx #$ff ; input = joystick
			stx inputMode
			bit sys.KBDSTRB
			rts

L114b			ldx #$01 ; input = keyboard
			stx inputMode
			bit sys.KBDSTRB
			rts

L1154			bit sys.KBDSTRB
			lda soundSwitch
			eor #$10
			sta soundSwitch
			rts

S1160			ldx playerDeadAnimIdx
			beq L1168
			jmp L198f

L1168			ldx L0314
			beq L1170
			jmp L15ab

L1170			ldx L0315
			beq L1178
			jmp S1381

L1178			ldx globals.isPlayerJumping
			beq L1180
			jmp L13e5

L1180			ldx L0309
			beq L1188
			jmp L1553

L1188			ldx playerAxeState ; 00:off / FF: on / 01:back to player
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
			ldx L0378
			bne L11fd

			ldx keypressed
			bpl L11fd

			; jsr logKey

			cpx keyPause
			beq L11fd

			cpx keyLeft
			bne L11bd
			bit sys.KBDSTRB
			jmp onKeyLeft

L11bd			cpx keyRight
			bne L11c8
			bit sys.KBDSTRB
			jmp onKeyRight

L11c8			cpx keyUp
			bne L11d0
			jmp onKeyUp

L11d0			cpx keyDown
			bne L11d8
			jmp onKeyDown

L11d8
			cpx keyAxe
			bne L11e4
			bit sys.KBDSTRB
			jmp onKeyAxe

L11e4			cpx keyJump
			bne L11ef
			bit sys.KBDSTRB
			jmp onKeyJump

L11ef
			stz playerXspeed
			stz playerYspeed
			stz keypressed
			bit sys.KBDSTRB
L11fd			rts


onKeyLeft		jsr S120a
			bcc L121d
			rts

onKeyRight		jsr S120a
			bcc L1228
			rts

S120a			ldx globals.isPlayerJumping
			bne L121b
			ldx L0309
			bne L121b
			ldx L0314
			bne L121b
			clc
			rts

L121b			sec
			rts

L121d			dec playerXspeed
			ldx playerXspeed
			cpx #$fd
			beq L1228
			rts

L1228			inc playerXspeed
			ldx playerXspeed
			cpx #$03
			beq L121d
			rts

updatePlayerSprite:
			ldx L0309
			beq L123f

			ldx L0333
			stx spriteIDNew
			rts

L123f			ldx globals.isPlayerJumping
			bne L128b

			lda playerXspeed
			beq L1275

			ror
			bcs L1256

			lda L030A
			cmp #$03
			bne L1256

			dec L030A
L1256			lda L030A
			cmp #$01
			bne L1262

			ldx #$04
			stx L030A
L1262			lda L030A
			ldy currentXspeed
			bmi L126d

			clc
			adc #$04
L126d			tax
			lda globals.playerAnimIDs,x
			sta spriteIDNew
			rts

L1275			ldx #$04
			stx L030A
			ldy currentXspeed
			bmi L1285
			ldx #$0C
			stx spriteIDNew
			rts

L1285			ldx #$0B
			stx spriteIDNew
			rts

L128b			ldx currentXspeed
			bmi L1296
			ldx #$10
			stx spriteIDNew
			rts

L1296			ldx #$0E
			stx spriteIDNew
			rts

movePlayer:
			lda spriteX
			clc
			adc playerXspeed
			sta spriteXNew
			lda spriteY
			clc
			adc playerYspeed
			sta spriteYNew
			jsr checkBoundsDrawPlayer
			rts

drawPlayer:
			lda playerXspeed
			bne L12d0

			lda playerYspeed
			bne L12d0

			lda L0309
			bne L12cf

			lda spriteID
			cmp #$0d
			bcs L12d0

			cmp spriteIDNew
			bne L12d0
L12cf			rts

L12d0			lda spriteID ; clear current sprite
			ldx spriteX
			ldy spriteY
			jsr spritelib.drawSpriteM

			ldx #$00
			stx spritelib.isCollision
			lda spriteIDNew ; get new sprite info
			sta spriteID
			ldx spriteXNew
			stx spriteX
			ldy spriteYNew
			sty spriteY
			jsr spritelib.drawSpriteM
			rts

S12f7			ldx L037E
			beq L1312

			stx spriteX
			stx spriteXNew
			ldy #$00
			sty L037E
			ldy #$e0
			sty spriteY
			sty spriteYNew
			jmp L1324

L1312			ldx LAD80
			stx spriteX
			stx spriteXNew
			ldy LAD81
			sty spriteY
			sty spriteYNew

L1324			lda LAD83
			sta currentXspeed
			lda LAD82
			sta spriteID
			sta spriteIDNew
			jsr spritelib.drawSpriteM

			ldx #$00
			stx playerXspeed
			stx playerYspeed
			stx L0309
			stx globals.isPlayerJumping
			stx L031E
			stx L0314
			stx L0315
			rts

S134e		ldx playerXspeed
		cpx #$01
		beq L1359
		cpx #$ff
		bne L135c
L1359		stx currentXspeed
L135c		rts

S135d		dec L030A
		bne L1367
		ldx #$04
		stx L030A
L1367		lda L030A
		asl
		asl
		tax
		lda playerXspeed
		beq L1377

		ldy #$10
		jsr tone
L1377		rts

; dead code ?!?
L1378		sty L0377
		lda #$90
		jsr utils.wait
		rts

S1381		jsr movePlayer

		ldx L0314
		beq L13a3

		jsr isSpriteInRect ; c=1 if true
		bcs L13a3

		ldx currentXspeed
		bmi L139b

		ldx #$10
		stx spriteIDNew
		jmp L13b5

L139b		ldx #$0E
		stx spriteIDNew
		jmp L13b5

L13a3		lda globals.jumpAnimIdx
		ldx currentXspeed
		bmi L13ae
		clc
		adc #$08
L13ae		tax
		lda globals.jumpAnimIDs,x
		sta spriteIDNew
L13b5		jsr drawPlayer
		jsr S15fe
		jsr S1953
		bcc L13c5

		dec globals.jumpAnimIdx
		bne L13cf

L13c5		ldx #$00
		stx L0315
		ldx #$08
		stx globals.jumpAnimIdx
L13cf		rts

; 13D0
onKeyJump	inc globals.isPlayerJumping
		lda playerYspeed
		sec
		sbc #$05
		sta playerYspeed
		ldx #$01
		stx L0321
		stx L0383
		rts


L13e5		jsr movePlayer
		jsr updatePlayerSprite
		ldx L0321
		bmi L13fc

		inc L0315
		dec L0321
		dec L0321
		jmp L1414

L13fc		ldx #$00
		stx globals.isPlayerJumping
		ldx #$04
		stx L030A
		jsr S1953
		bcc L1414

		inc L0314
		inc L0315
		jmp S1381

L1414		jsr S1953
		jsr drawPlayer
		jsr S15fe
		rts

S141e		ldx L0309
		bne L1440

		ldx L0314
		bne L1433

		ldx L0315
		bne L1433

		ldx globals.isPlayerJumping
		bne L1433

		rts

L1433		inc playerYspeed
		ldx playerYspeed
		cpx #$06
		bne L1440

		dec playerYspeed
L1440		rts

S1441:
		ldx playerYspeed
		bmi L1485

		ldx #$ff
		stx L0322

L144b		inc L0322
		ldx L0322
		lda LAC40,x
		beq L1485

		lda spriteXNew
		cmp LAC00,x
		bcc L144b

		cmp LAC20,x
		beq L1465

		bcs L144b

L1465		lda LAC40,x
		clc
		adc #$03
		cmp spriteYNew
		bcc L144b

		sec
		sbc playerYspeed
		sec
		sbc #$03
		cmp #$f8
		bcs L1480

		cmp spriteYNew
		bcs L144b

L1480		stx L0379
		clc
		rts
L1485		sec
		rts

; 1487
onKeyUp 	ldx L0309
		beq L149d
		ldx #$fe
		stx playerYspeed
		rts

; 1492
onKeyDown	ldx L0309
		beq L14b3
		ldx #$02
		stx playerYspeed
		rts

L149d		jsr isPlayerOnLadder
		bcc L14b2
		ldx L0317
		bpl L14b2
		ldx #$fe
		stx playerYspeed
		inc L0309
		jmp L1553
L14b2		rts

L14b3		jsr isPlayerOnLadder
		bcc L14b2
		ldx L0317
		bmi L14b2
		beq L14b2
		ldx #$02
		stx playerYspeed
		inc L0309
		jmp L1553

isPlayerOnLadder:
		ldx #$ff
		stx L0322
L14cf		inc L0322
		ldx L0322
		lda LAC60,x
		beq L1543

		lda LACA0,x
		tay
		dey
		dey
		cpy spriteX
		beq L14f4

		iny
		cpy spriteX
		beq L14f4

		iny
		cpy spriteX
		beq L14f4

		jmp L14cf

L14f4		lda LAC60,x
		cmp spriteY
		beq L1527
		bcs L14cf

		lda LAC80,x
		cmp spriteY
		beq L1535
		bcc L14cf

		lda LACA0,x
		sta spriteXNew
		ldx spriteY
		stx spriteYNew
		ldx spriteID
		stx spriteIDNew
		jsr drawPlayer
		ldx #$00
		stx L0317
		stx playerXspeed
		sec
		rts

L1527		ldx #$01
		stx L0317
		dex
		stx playerXspeed
		stx playerYspeed
		sec
		rts

L1535		ldx #$ff
		stx L0317
		inx
		stx playerXspeed
		stx playerYspeed
		sec
		rts

L1543		clc
		ldx #$00
		stx L0309
		rts

toggleSpriteID:
		lda L0333
		eor #$01
		sta L0333
		rts

L1553		jsr S1575
		jsr updatePlayerSprite
		jsr movePlayer
		jsr drawPlayer
		jsr isPlayerOnLadder
		ldx playerYspeed
		beq L156a

		jsr toggleSpriteID
L156a		ldx L0317
		beq L1574

		ldx #$00
		stx L0309
L1574		rts

S1575		ldx keypressed
		bpl L1592

		cpx keyUp
		bne L1582
		jmp onKeyUp

L1582		cpx keyDown
		bne L158a
		jmp onKeyDown

L158a		ldx #$00
		stx playerXspeed
		stx playerYspeed
L1592		rts

S1593		jsr S1441
		bcc L15aa
		ldx globals.isPlayerJumping
		bne L15aa
		ldx L0309
		bne L15aa
		ldx playerAxeState ; 00:off / FF: on / 01:back to player
		bmi L15aa
		inc L0314
L15aa		rts

L15ab:
		ldx L0315
		bne !+

		inc L0315
!		jsr S1381
		jsr S1441
		bcs !+

		ldx #$00
		stx L0315
		stx L0314
		stx globals.isPlayerJumping
		jsr drawPlayer
!		rts

isSpriteInRect:
		ldx #$ff
		stx L0322
L15cf		inc L0322
		ldx L0322
		lda LAC40,x
		beq L15fc

		lda spriteXNew
		cmp LAC00,x
		bcc L15cf

		cmp LAC20,x
		bcs L15cf

		lda LAC40,x
		clc
		adc #$06
		cmp spriteYNew
		bcc L15cf

		sec
		sbc #$10
		cmp spriteYNew
		bcs L15cf

		clc
		rts

L15fc		sec
		rts

S15fe:
		ldx spritelib.isCollision
		beq L1637

		ldx L031E
		bne L1637

		ldx L0373
		bne L1637

		jsr S164d
		bcs L1637

		jsr S1638
		lda spriteXNew
		sec
		sbc playerXspeed
		sta spriteXNew
		ldx spriteID
		stx spriteIDNew
		jsr drawPlayer
		ldx #$01
		stx L0314
		dex
		stx playerYspeed
		stx playerXspeed
		inc L031E
L1637		rts

S1638		lda spriteX
		sec
		sbc playerXspeed
		sta spriteXNew
		lda spriteY
		sec
		sbc playerYspeed
		sta spriteYNew
		rts

S164d:
		ldx #$ff
		stx L0322
L1652		inc L0322
		ldx L0322
		lda LAC60,x
		beq L167f

		cmp spriteY
		bcs L1652

		lda LAC80,x
		cmp spriteY
		bcc L1652

		lda LACA0,x
		sec
		sbc #$08
		cmp spriteX
		bcs L1652

		clc
		adc #$0b
		cmp spriteX
		bcc L1652

		sec
		rts

L167f		clc
		rts

checkBoundsDrawPlayer:
		ldx #$ff
		stx L0322

L1686		inc L0322
		ldx L0322
		lda LACF0,x
		beq L16d1

		lda spriteXNew
		cmp LACC0,x
		beq L16a1
		tay
		iny
		tya
		cmp LACC0,x
		bne L1686

L16a1		lda LACF0,x
		cmp spriteYNew
		bne L1686

		lda LACC0,x
		sta spriteXNew

		ldx currentXspeed
		bmi L16ba

		dec spriteXNew
		jmp L16bd

L16ba		inc spriteXNew
L16bd		ldx #$00
		stx playerXspeed
		stx playerYspeed
		jsr updatePlayerSprite

		ldx spriteY
		stx spriteYNew
		jsr drawPlayer
L16d1		rts


; 16D2
onKeyAxe	ldx L0309
		bne L1701

		ldx L0314
		bne L1701

		ldx L0315
		bne L1701

		ldx globals.isPlayerJumping
		bne L1701

		ldx playerAxeState ; 00:off / FF: on / 01:back to player
		bne L1701

		ldx playerAxeCountHi
		bne L16f5

		ldx playerAxeCountLo
		beq L1701

L16f5		ldx #$ff
		stx playerAxeState ; 00:off / FF: on / 01:back to player
		inx
		stx playerAxeAnim ; 00: normal / 01: axe behind / 02: axe forward
		jsr updAxeCount
L1701		rts

L1702		lda playerAxeAnim ; 00: normal / 01: axe behind / 02: axe forward
		cmp #$02
		beq L1739
		ldy currentXspeed
		bmi L1711
		clc
		adc #$02
L1711		tay
		lda axeAnimIDs,y
		sta spriteIDNew
		lda spriteX
		ldx playerAxeAnim ; 00: normal / 01: axe behind / 02: axe forward
		dex
		bne L1729

		ldy currentXspeed
		bpl L1729
		sec
		sbc #$02

L1729		sta spriteXNew
		ldy spriteY
		sty spriteYNew
		jsr drawPlayer

		inc playerAxeAnim ; 00: normal / 01: axe behind / 02: axe forward
		rts

L1739		ldx #$01
		stx playerAxeState ; 00:off / FF: on / 01:back to player
		lda spriteX
		ldy currentXspeed
		bmi L1754
		ldx #$03
		stx L033A
		clc
		adc #$07
		sta axeXpos
		jmp L175f

L1754		sec
		sbc #$03
		sta axeXpos
		ldx #$fd
		stx L033A
L175f		lda spriteY
		clc
		adc #$02
		sta axeYpos
		lda #$1e
		sta axeSpriteID
		jsr drawAxe
		ldx currentXspeed
		stx L031D
		ldx #$08
		stx L0338
		ldx #$01
		stx L0339
		stx playerAxeState ; 00:off / FF: on / 01:back to player
		jsr updatePlayerSprite
		lda spriteX
		ldy currentXspeed
		bpl L1791
		clc
		adc #$02
L1791		sta spriteXNew
		ldx spriteY
		stx spriteYNew
		jsr drawPlayer
		rts

S179e		ldx playerAxeState ; 00:off / FF: on / 01:back to player
		dex
		bpl L17a5
		rts

L17a5		jsr eraseAxe
		dec L0338
		beq L17cd
L17ad		lda axeXpos
		clc
		adc L033A
		sta axeXpos
		inc axeSpriteID
		ldx axeSpriteID
		cpx #$21
		bne L17c6
		ldx #$1e
		stx axeSpriteID
L17c6		jsr drawAxe
		jsr S182b
		rts

L17cd		inc L0338
		ldx L0339
		bpl L17db
		inc axeYpos
		jmp L17ad

L17db		ldx L031D
		bmi L17ed
		dec L033A
		ldx L033A
		cpx #$fd
		beq L17fa
		jmp L17ad

L17ed		inc L033A
		ldx L033A
		cpx #$03
		beq L17fa
		jmp L17ad

L17fa		ldx #$08
		stx L0338
		ldx #$ff
		stx L0339
		jmp L17ad

drawAxe:
		stz spritelib.isCollision
		ldx axeXpos
		ldy axeYpos
		lda axeSpriteID
		jmp spritelib.drawSpriteM

holsterAxe
		jsr eraseAxe
		ldx #$00
		stx playerAxeState ; 00:off / FF: on / 01:back to player
		stx playerAxeAnim ; 00: normal / 01: axe behind / 02: axe forward
		stx axeXpos
		stx axeYpos
		rts

S182b		jsr testIncAxeCount
		ldx spritelib.isCollision
		beq L1841

		jsr S1b93
		jsr S185a
		bcs L1841
		jsr soundlib.L0A50
L183e		bra holsterAxe

L1841		ldx axeXpos
		cpx #$f0
		bcs L184c
		cpx #$9d
		bcs L183e
L184c		rts

eraseAxe
		ldx axeXpos
		ldy axeYpos
		lda axeSpriteID
		jmp spritelib.drawSpriteM

S185a		ldx #$ff
		stx L0322
L185f		inc L0322
		ldx L0322
		lda LAC60,x
		beq L188f
		lda axeYpos
		cmp LAC60,x
		bcc L185f
		sec
		sbc #$10
		cmp LAC80,x
		bcs L185f
		lda LACA0,x
		sec
		sbc #$08
		cmp axeXpos
		bcs L185f
		clc
		adc #$13
		cmp axeXpos
		bcc L185f
		sec
		rts

L188f		clc
		rts

S1891		ldx spriteY
		cpx LAD88
		bne L18a7
		ldx spriteX
		cpx LAD87
		beq L18a8
		dex
		cpx LAD87
		beq L18a8
L18a7		rts

L18a8		jsr soundlib.L0A00

loadInitLevel
		ldx L037E
		bne !+

		ldx level
		stx levelCnt
L18b6		dec levelCnt
		bmi !+
		jsr scoreAdd100
		jmp L18b6

!		ldx L037E
		beq L18d9

		ldx #level-playerData
		stx level
		jsr drawDigit
		dec level
		ldx #level-playerData
		jsr drawDigit
		jmp L18e6

L18d9		ldx #level-playerData
		jsr drawDigit
		inc level
		ldx #level-playerData
		jsr drawDigit

L18e6		ldx level
		jsr loadLevel

		ldx #$00
		stx playerAxeState ; 00:off / FF: on / 01:back to player
		stx keypressed
		bit sys.KBDSTRB
		jmp S12f7

;
S18fa		ldx #$ff
		stx L0322
L18ff		inc L0322
		ldx L0322
		lda LAD30,x
		beq L1925

		jsr S1926

		ldx L0322
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
		sta L033B
		lda LAD40,x
		ldx L033B
		jsr spritelib.drawSprite
		rts

;
drawExitArrow:
		inc L033C
		lda L033C
		ror
		bcs L1952

		ror
		bcs L1952

		ldx LAD84
		ldy LAD85
		lda LAD86
		jsr spritelib.drawSprite
L1952		rts

S1953:
		jsr S1441
		bcs !+
		lda LAC40,x
		sta spriteYNew
		inc spriteYNew
		lda spriteX
		clc
		adc playerXspeed
		sta spriteXNew
		jsr updatePlayerSprite
		jsr drawPlayer
		ldx #$00
		stx playerYspeed
		stx L031E
!		rts

drawDigit	lda playerData,x
		tay
		lda L033C,x
		tax
		tya
		ldy #$b9
		cmp #$00
		bne L198b
		lda #$0a
L198b		jsr spritelib.drawSprite
		rts

L198f		jsr soundlib.L0A2D
		ldx playerDeadAnimIdx
		cpx #$08
		bcs L19bd
		jsr S19aa
		inc playerDeadAnimIdx
		ldx playerDeadAnimIdx
		cpx #$08 ; anim player dying: 7 frames
		beq L19a9
		jsr S19aa
L19a9		rts

S19aa		ldx playerDeadAnimIdx
		lda playerDeadAnimIdx,x
		sta spriteID
		ldx spriteX
		ldy spriteY
		jsr spritelib.drawSpriteM
		rts

L19bd		inc playerDeadAnimIdx
		ldx playerDeadAnimIdx
		cpx #$18
		beq L19c8
		rts

L19c8		jsr updLifeCount
		jsr S12f7
		ldx #$00
		stx playerDeadAnimIdx
		ldy playerAxeState ; 00:off / FF: on / 01:back to player
		bpl !+

		stx playerAxeState ; 00:off / FF: on / 01:back to player
!		bit sys.KBDSTRB
		rts

updLifeCount	ldx #playerLifeCount-playerData ; #$06
		jsr drawDigit
		dec playerLifeCount ; cheat
		bmi !+

		ldx #playerLifeCount-playerData ; #$06
		jsr drawDigit
		rts

!		inc playerLifeCount
		ldx #playerLifeCount-playerData
		jsr drawDigit
		jsr updateHiScore
		jsr S1c6b
		jmp restart

L1a00		ldx #playerAxeCountLo-playerData
		stx L0322
!		ldx L0322
		jsr drawDigit
		dec L0322
		bne !-
		rts

resetVars2
		jsr L1a00
		ldx #$00
		stx playerScore
		stx playerScore+1
		stx playerScore+2
		stx playerScore+3
		stx playerScore+4
		stx playerAxeCountLo
		stx level
		inx
		stx playerAxeCountHi
		inx
		stx playerLifeCount
		jsr L1a00
		rts

fbkgnd		.cstr "L0_BKGD"
fdata		.cstr "L0_DATA"
fcode		.cstr "L0_CODE"

		.if loadLevel
		.out "loadLevel : ",.hex(loadLevel)
		.end

loadLevel	stx L0381
; 		lda #$00
; L1a3c		dex
; 		bmi init2

; 		clc
; 		adc #$06
; 		jmp L1a3c

; load welcome screen
; 1A45
init2		txa
		clc
		adc #$30
		sta fbkgnd+1
		sta fdata+1
		sta fcode+1

		read_file fbkgnd

		; unpack & display
		; jsr unpackToHgr
		lda #$00
		ldx #$75
		ldy #183
		jsr unpack.run

;		.call unpack($00 $75 183)

		read_file fdata
		read_file fcode

		rts

		.if 0
		sta rangeIdx
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

		inc rangeIdx
		ldy rangeIdx

		;
		; R1 : data (anim?, sprites)
		;
		; L0:13 T0S9-C / M7500-78FF
		; L1:	T4S6 / M7500-75FF
		; L2:	T6S5 / M7500-75FF
		ldx #$75
		stx rwts_buf+1
		jsr loadRange

		inc rangeIdx
		ldy rangeIdx

		;
		; R2 : data
		;
		; L0:14 T0SD/ M7900-79FF
		; L1:	T4S7/ M7900-79FF
		; L2:	T6S6/ M7900-79FF
		ldx #$79
		stx rwts_buf+1
		jsr loadRange

		inc rangeIdx
		ldy rangeIdx

		;
		; R3 : data
		;
		; L0:15 T0SE-T2SF / M7A00-9BFF
		; L1:	T4S8-T4SF / M7A00-81FF
		; L2:	T6S7-T7S6 / M7A00-89FF
		ldx #$7A
		stx rwts_buf+1
		jsr loadRange

		inc rangeIdx
		ldy rangeIdx

		;
		; R4 : code
		;
		; L0:16 T3S0-T3SB / MA000-ABFF
		; L1:	T5S0-T5S8 / MA000-A7FF
		; L2:	T7S7-T7SC / MA000-A5FF
		ldx #$A0
		stx rwts_buf+1
		jsr loadRange

		inc rangeIdx
		ldy rangeIdx

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

		.end

; 1B1D
readSector	ldx track
		stx rwts_trk
		ldx sector
		stx rwts_sec
		ldx #$00
		stx rwts_vol
		stx $48
		ldy #$e8
		lda #$b7
		jsr rwts
		rts

updAxeCount	ldx #playerAxeCountLo-playerData
		jsr drawDigit
		dec playerAxeCountLo ; cheat
		bmi L1b48

		ldx #playerAxeCountLo-playerData
		jsr drawDigit
		rts

L1b48		ldx #playerAxeCountLo-playerData
		stx playerAxeCountLo
		jsr drawDigit

		ldx playerAxeCountHi
		beq L1b62

		ldx #$08
		jsr drawDigit
		dec playerAxeCountHi
		ldx #$08
		jsr drawDigit
L1b62		rts

S1b63		jsr S1441
		bcs L1b69
		rts

L1b69		ldx spriteX
		cpx #$f0
		bcs L1b7c
		cpx #$89
		bcc L1b92
		ldx #$88
		stx spriteXNew
		jmp L1b81

L1b7c		ldx #$00
		stx spriteXNew
L1b81		ldx spriteID
		stx spriteIDNew
		jsr drawPlayer
		ldx #$00
		stx playerXspeed
		stx playerYspeed
L1b92		rts

S1b93		ldx playerDeadAnimIdx
		bne L1b92
		lda spriteX
		sec
		sbc #$05
		cmp axeXpos
		bcs L1b92
		clc
		adc #$0c
		cmp axeXpos
		bcc L1b92
		lda spriteY
		sec
		sbc #$03
		cmp axeYpos
		bcs L1b92
		clc
		adc #$11
		cmp axeYpos
		bcc L1b92
		jsr incAxeCount
		jsr holsterAxe
		jsr soundlib.L0AD7
		pla
		pla
		rts

incAxeCount:
		ldx #$09
		jsr drawDigit
		inc playerAxeCountLo
		ldx playerAxeCountLo
		cpx #$0a
		beq L1bdf
		ldx #$09
		jsr drawDigit
		rts

L1bdf		ldx #$00
		stx playerAxeCountLo
		ldx #$09
		jsr drawDigit
		ldx #$08
		jsr drawDigit
		inc playerAxeCountHi
		ldx #$08
		jsr drawDigit
		rts

S1bf7		jsr S1bfe
		jsr S1c20
		rts

S1bfe		ldx #$3b
		stx unknown_yPos
L1c03		jsr S1c11
		inc unknown_yPos
		ldx unknown_yPos
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
		stx unknown_yPos
L1c2d		jsr S1c3b
		inc unknown_yPos
		ldx unknown_yPos
		cpx #$79
		bne L1c2d
		rts

S1c3b		jsr getHGRLineAddr
		ldy #$0d
		sty unknown_xPos
L1c43		ldy #$00
		lda ($1c),y
		ldy unknown_xPos
		sta ($1a),y
		inc $1c
		bne L1c52
		inc $1d
L1c52		inc unknown_xPos
		ldy unknown_xPos
		cpy #$1c
		bne L1c43
		rts

getHGRLineAddr
		ldx unknown_yPos
		lda utils.hgrLow,x
		sta $1a
		lda utils.hgrHigh,x
		sta $1b
		rts

S1c6b		jsr S1e97
		and #$03
		asl
		asl
		sta rwts_sec
		lda level
		clc
		adc #$1a
		sta rwts_trk
		ldx #$75
		stx rwts_buf+1
		ldx #$00
		stx rwts_buf
		jsr readTrack
		jsr S1bf7

		bit sys.KBDSTRB
		ldy #$60

L1c93		lda #$ff
		jsr utils.wait

		lda sys.KBD
		bmi L1ca5

		jsr readJoyBtn0
		bcs L1ca5

		dey
		bne L1c93

L1ca5		bit sys.KBDSTRB
		cpy #$00
		beq L1caf
		jmp levelLoop

L1caf		rts

S1cb0		inc globals.soundCnt1
		lda globals.soundCnt1
		adc $7900
		adc playerScore+3
		sta globals.soundCnt1
L1cbf		rts

readJoystick:
		ldx inputMode ; 01:kbd ff:joystick
		bpl L1cbf ; if kdb

		ldx L0309
		beq L1ccf
		ldx #$00
		jmp L1d01

L1ccf		ldx sys.BUTNO
		bmi L1d16

		ldx playerAxeState ; 00:off / FF: on / 01:back to player
		bne L1cde

		ldx sys.BUTN1
		bmi L1d1d

L1cde		ldx #$fe
		lda joyX
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
L1cf7		cpx playerXspeed
		beq L1d01
		bmi L1d32
		jmp L1d39

L1d01		ldy joyY
		cpy #$30
		bcc L1d24
		cpy #$d0
		bcs L1d2b
		cpx #$00
		bne L1d15
		ldx #$ff
		stx keypressed
L1d15		rts

L1d16		ldx keyJump
		stx keypressed
		rts

L1d1d		ldx keyAxe
		stx keypressed
		rts

L1d24		ldx keyUp
		stx keypressed
		rts

L1d2b		ldx keyDown
		stx keypressed
		rts

L1d32		ldx keyLeft
		stx keypressed
		rts

L1d39		ldx keyRight
		stx keypressed
		rts

resetVars	bit sys.KBDSTRB
		stz playerDeadAnimIdx
		stz L031E
		stz globals.isPlayerJumping
		stz playerAxeState ; 00:off / FF: on / 01:back to player
		stz L0314
		stz L0315
		stz L0309
		stz playerXspeed
		stz playerYspeed

		ldx assetKeyCnt
		beq L1d6f

		ldx #assetKey
		jsr drawAsset
		stz assetKeyCnt

L1d6f		ldx assetGemCnt
		beq L1d7e

		ldx #assetGem
		jsr drawAsset
		stz assetGemCnt
L1d7e		rts

readJoyX	ldx #$00
		jsr utils.PREAD
		sty joyX
		rts

readJoyY	ldx #$01
		jsr utils.PREAD
		sty joyY
		rts

drawAsset	txa
		tay
		lda assetXpos-1,y
		tax
		tya
		clc
		adc #$26
		ldy #185
		jsr spritelib.drawSprite
		rts

;
; DRAWSCORE
;

drawScore	ldx #$05
		jsr drawDigit
		ldx #$05
		inc playerScore+4
		ldy playerScore+4
		cpy #$0a
		beq !+
		jsr drawDigit
		rts

!		lda #$00
		sta playerScore+4
		jsr drawDigit

drawScore10	ldx #$04
		jsr drawDigit
		ldx #$04
		inc playerScore+3
		ldy playerScore+3
		cpy #$0a
		beq !+
		jsr drawDigit
		rts

!		lda #$00
		sta playerScore+3
		jsr drawDigit

drawScore100	ldx #$03
		jsr drawDigit
		ldx #$03
		inc playerScore+2
		ldy playerScore+2
		cpy #$0a
		beq !+
		jsr drawDigit
		rts

!		lda #$00
		sta playerScore+2
		jsr drawDigit

drawScore1000	ldx #$02
		jsr drawDigit
		ldx #$02
		inc playerScore+1
		ldy playerScore+1
		cpy #$0a
		beq !+
		jsr drawDigit
		rts

!		lda #$00
		sta playerScore+1
		jsr drawDigit
		ldx #$01
		jsr drawDigit
		inc playerScore
		ldx #$01
		jsr drawDigit
		rts

updateHiScore
		ldx #$00
L1e25		lda highScore,x
		cmp playerScore,x
		bcc L1e35
		bne L1e34
		inx
		cpx #$05
		bne L1e25
L1e34		rts

L1e35		ldx #$04
L1e37		lda playerScore,x
		sta highScore,x
		dex
		bpl L1e37
L1e40		rts

resetIfLastLevel
		ldx level
		cpx #$09
		bne L1e40
		dec level
		jmp resetGame

readJoyBtn0	lda inputMode ; 01:kbd ff:joystick
		bpl L1e5a ; if kbd

		lda sys.BUTNO
		bpl L1e5a
		sec
		rts

L1e5a		clc
L1e5b		rts

S1e5c		ldx playerAxeState ; 00:off / FF: on / 01:back to player
		dex
		bmi L1e5b

		lda L0339
		bpl L1e70

		lda #$09
		sec
		sbc L0338
		jmp L1e73

L1e70		lda L0338
L1e73		asl
		asl
		sta axeSndCnt1
L1e78		lda #$02
L1e7a		ldy axeSndCnt1
		ldx soundSwitch
L1e80		cmp sys.SPKR-$10,x
		dey
		bne L1e80
		sec
		sbc #$01
		bne L1e7a
		lda axeSndCnt1
		sec
		sbc #$01
		sta axeSndCnt1
		bne L1e78
		rts

S1e97		rol $4e
		rol globals.soundCnt1
		rol globals.sountCnt2
		lda $4e
		asl
		eor $4f
		eor globals.sountCnt2
		rol
		rol
		rol
		rol
		rol
		pha
		rol $4f
		lda $4f
		eor globals.soundCnt1
		sta $4e
		pla
		sta globals.sountCnt2
		adc $4e
		adc globals.soundCnt1
		sta globals.soundCnt3
		rts
;
; LOADRANGE Y:range idx
;
; 1EC3
loadRange	lda levels.rangeTracks,y
		sta track
		lda levels.rangeSectors,y
		sta sector
		iny
		lda levels.rangeTracks,y
		sta trackend
		lda levels.rangeSectors,y
		sta sectorend
		ldx #$00
		stx rwts_buf

		; check if ptrs =. exit of true
!		ldx sector
		cpx sectorend
		bne L1ef2
		ldx track
		cpx trackend
		bne L1ef2
		rts

L1ef2		jsr readSector
		inc rwts_buf+1
		inc sector
		ldx sector
		cpx #$10
		bne !-
		ldx #$00
		stx sector
		inc track
		jmp !-


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
L1f2c		rts

testIncAxeCount:
		ldx playerDeadAnimIdx
		bne L1f2c

		lda spriteX
		sec
		sbc #$02
		cmp axeXpos
		bcs L1f2c

		clc
		adc #$04
		cmp axeXpos
		bcc L1f2c

		lda spriteY
		sec
		sbc #$03
		cmp axeYpos
		bcs L1f2c

		clc
		adc #$11
		cmp axeYpos
		bcc L1f2c

		jsr incAxeCount
		jsr holsterAxe
		jsr soundlib.L0AD7
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
