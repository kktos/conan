;
; disk 5000-5FFF into $1000:1FFF
;

		.namespace game1

; highscoreses
startLevel 	=	$A000
LAC00 		=	$AC00
LAC20 		=	$AC20
LAC40 		=	$AC40
LAC60 		=	$AC60
LAC80 		=	$AC80
LACA0 		=	$ACA0
LACC0 		=	$ACC0
LACF0 		=	$ACF0

LAD20		=	$AD20
LAD30		=	$AD30
LAD40		=	$AD40

LAD84 		=	$AD84
LAD85 		=	$AD85
LAD86 		=	$AD86
LAD87 		=	$AD87
LAD88 		=	$AD88

L0A00		=	$0A00
L0A2D		=	$0A2D
L0A50		=	$0A50
L0AD7		= 	$0AD7

drawSpriteM	=	$B300
drawSprite	=	$AE00

L0900		=	$0900
L0980		=	$0980

hgrHi		=	$B500
hgrLo		=	$B400

		.org $1000
L1001=*+1
L1002=*+2
L1000		jmp L108c

L1004=*+1
L1003		lda $c000
		bpl L1003
		jmp L102d

L100b		bit $c010
		stx $1c
		ldx #$3e
		stx $1d
		ldy #$00
		sta ($1c),y
		lda ($22),y
		dex
		bne L1003
		dec $1b
		inc $1b
		ldx $1d
		cpx #$3d
		bne L1003
		bit $c030
		bit $c030
L102d		jmp L108c

L1030		jsr drawScore
		rts

L1034		jsr S1dbe
		rts

S1038		jsr S1ddb
		rts

L103c		jsr S1df8
		rts

L1040		jsr L1030
		jsr L1030
		jsr L1030
		jsr L1030
		jsr L1030
		rts

L1050		jsr L1034
		jsr L1034
		jsr L1040
		rts

L105a		jsr L1034
		jsr L1034
		jsr L1034
		jsr L1034
		jsr L1034
		rts

L106a		jsr L105a
		jsr L1050
		rts

L1071		jsr S1038
		jsr S1038
		jsr L105a
		rts

S107b		txa
L107c		ldx L0380
		pha
		lda $c020,x
		pla
L1084		tax
L1085		dex
		bne L1085
		dey
		bne L107c
		rts

L108c		jsr L1a00

L108f		ldx #$00
		; sprites 	$7500:78FF
		; data 		$7900:78FF
		; data 		$7A00:9BFF
		; code 		$A000:ABFF
		; data 		$AC00:ADFF
		jsr loadLevel

		; anim conan jump / high score
		jsr startLevel

L1097		jsr S1d40
		jsr S1a11
		jsr S18ab

L10a0		jsr startLevel
		ldx #$00
		stx L0383
		jsr S1d7f
		jsr S179e
		jsr S1891

		jsr readUserInput

		jsr S1160
		jsr S141e
		jsr S1593
		jsr S1e5c
		jsr S18fa
		jsr S193a
		jsr S1b63
		jsr S1cb0
		jsr S1d88

		jsr S1e41

		jmp L10a0

readUserInput	lda $c000
		sta keypressed

		cmp L038B ; D3/53/S
		beq L1154

		cmp keyPause ; 9B/1B/esc
		beq onKeyPause ; pause

		cmp keyRestart ; 8D/0D/return
		beq onKeyRestart ; restart level

		cmp keyJoystick
		beq L1142 ; joystick only

		cmp keyKeyboard
		beq L114b ; keyboard only

		cmp keyLeft ; 88/08/left arrow
		bne L10fc

		bit $c010

L10fc		cmp keyRight ;95/15/right arrow
		bne L1104

		bit $c010
L1104		jsr readJoystick
		rts

; 1108
onKeyRestart	jsr S1e23
		bit $c010
		jmp L1097

L1111		bit $c010
		bit $c050
		bit $c052
		bit $c057
		bit $c054
		jmp L108f

; 1123
onKeyPause	bit $c010
L1126		lda $c000
		sta keypressed
		bmi L1139
		ldx inputMode ; 01:kbd ff:joystick
		bpl L1126 ; if kbd

		lda $c061
		bpl L1126
		rts

L1139		cmp keyPause ; 9B/1B/esc
		bne onKeyPause
		bit $c010
		rts

L1142		ldx #$ff ; input = joystick
		stx inputMode
		bit $c010
		rts

L114b		ldx #$01 ; input = keyboard
		stx inputMode
		bit $c010
		rts

L1154		bit $c010
		lda L0380
		eor #$10
		sta L0380
		rts

S1160		ldx playerDeadAnimIdx
		beq L1168
		jmp L198f

L1168		ldx L0314
		beq L1170
		jmp L15ab

L1170		ldx L0315
		beq L1178
		jmp S1381

L1178		ldx L031F
		beq L1180
		jmp L13e5

L1180		ldx L0309
		beq L1188
		jmp L1553

L1188		ldx playerAxeState ; 00:off / FF: on / 01:back to player
		bpl L1190
		jmp L1702

L1190		jsr S11a3
		jsr S134e
		jsr S135d
		jsr S1233
		jsr S129c
		jsr drawNewSprite
		rts

S11a3		ldx L0378
		bne L11fd
		ldx keypressed
		bpl L11fd
		cpx keyPause
		beq L11fd
		cpx keyLeft
		bne L11bd
		bit $c010
		jmp L11fe

L11bd		cpx keyRight
		bne L11c8
		bit $c010
		jmp L1204

L11c8		cpx keyUp
		bne L11d0
		jmp onKeyUp

L11d0		cpx keyDown
		bne L11d8
		jmp onKeyDown

L11d8		nop
		cpx keyAxe
		bne L11e4
		bit $c010
		jmp onKeyAxe

L11e4		cpx keyJump
		bne L11ef
		bit $c010
		jmp onKeyJump

L11ef		ldx #$00
		stx L0306
		stx L0307
		stx keypressed
		bit $c010
L11fd		rts

L11fe		jsr S120a
		bcc L121d
		rts

L1204		jsr S120a
		bcc L1228
		rts

S120a		ldx L031F
		bne L121b
		ldx L0309
		bne L121b
		ldx L0314
		bne L121b
		clc
		rts

L121b		sec
		rts

L121d		dec L0306
		ldx L0306
		cpx #$fd
		beq L1228
		rts

L1228		inc L0306
		ldx L0306
		cpx #$03
		beq L121d
		rts

S1233		ldx L0309
		beq L123f
		ldx L0333
		stx spriteIDNew
		rts

L123f		ldx L031F
		bne L128b
		lda L0306
		beq L1275
		ror a
		bcs L1256
		lda L030A
		cmp #$03
		bne L1256
		dec L030A
L1256		lda L030A
		cmp #$01
		bne L1262
		ldx #$04
		stx L030A
L1262		lda L030A
		ldy L0308
		bmi L126d
		clc
		adc #$04
L126d		tax
		lda keypressed,x
		sta spriteIDNew
		rts

L1275		ldx #$04
		stx L030A
		ldy L0308
		bmi L1285
		ldx #$0c
		stx spriteIDNew
		rts

L1285		ldx #$0b
		stx spriteIDNew
		rts

L128b		ldx L0308
		bmi L1296
		ldx #$10
		stx spriteIDNew
		rts

L1296		ldx #$0e
		stx spriteIDNew
		rts

S129c		lda spriteX
		clc
		adc L0306
		sta spriteXNew
		lda spriteY
		clc
		adc L0307
		sta spriteYNew
		jsr S1681
		rts

drawNewSprite	lda L0306
		bne L12d0
		lda L0307
		bne L12d0
		lda L0309
		bne L12cf
		lda spriteID
		cmp #$0d
		bcs L12d0
		cmp spriteIDNew
		bne L12d0
L12cf		rts

L12d0		lda spriteID ; clear current sprite
		ldx spriteX
		ldy spriteY
		jsr drawSpriteM

		ldx #$00
		stx $b3f6
		lda spriteIDNew ; get new sprite info
		sta spriteID
		ldx spriteXNew
		stx spriteX
		ldy spriteYNew
		sty spriteY
		jsr drawSpriteM
		rts

S12f7		ldx L037E
		beq L1312
		stx spriteX
		stx spriteXNew
		ldy #$00
		sty L037E
		ldy #$e0
		sty spriteY
		sty spriteYNew
		jmp L1324

L1312		ldx $ad80
		stx spriteX
		stx spriteXNew
		ldy $ad81
		sty spriteY
		sty spriteYNew

L1324		lda $ad83
		sta L0308
		lda $ad82
		sta spriteID
		sta spriteIDNew
		jsr drawSpriteM

		ldx #$00
		stx L0306
		stx L0307
		stx L0309
		stx L031F
		stx L031E
		stx L0314
		stx L0315
		rts

S134e		ldx L0306
		cpx #$01
		beq L1359
		cpx #$ff
		bne L135c
L1359		stx L0308
L135c		rts
S135d		dec L030A
		bne L1367
		ldx #$04
		stx L030A
L1367		lda L030A
		asl a
		asl a
		tax
		lda L0306
		beq L1377
		ldy #$10
		jsr S107b
L1377		rts
L1378		sty L0377
		lda #$90
		jsr $fca8
		rts
S1381		jsr S129c
		ldx L0314
		beq L13a3
		jsr S15ca
		bcs L13a3
		ldx L0308
		bmi L139b
		ldx #$10
		stx spriteIDNew
		jmp L13b5
L139b		ldx #$0e
		stx spriteIDNew
		jmp L13b5
L13a3		lda L0316
		ldx L0308
		bmi L13ae
		clc
		adc #$08
L13ae		tax
		lda L0322,x
		sta spriteIDNew
L13b5		jsr drawNewSprite
		jsr S15fe
		jsr S1953
		bcc L13c5
		dec L0316
		bne L13cf
L13c5		ldx #$00
		stx L0315
		ldx #$08
		stx L0316
L13cf		rts

; 13D0
onKeyJump	inc L031F
		lda L0307
		sec
		sbc #$05
		sta L0307
		ldx #$01
		stx L0321
		stx L0383
		rts
L13e5		jsr S129c
		jsr S1233
		ldx L0321
		bmi L13fc
		inc L0315
		dec L0321
		dec L0321
		jmp L1414
L13fc		ldx #$00
		stx L031F
		ldx #$04
		stx L030A
		jsr S1953
		bcc L1414
		inc L0314
		inc L0315
		jmp S1381
L1414		jsr S1953
		jsr drawNewSprite
		jsr S15fe
		rts
S141e		ldx L0309
		bne L1440
		ldx L0314
		bne L1433
		ldx L0315
		bne L1433
		ldx L031F
		bne L1433
		rts
L1433		inc L0307
		ldx L0307
		cpx #$06
		bne L1440
		dec L0307
L1440		rts
S1441		ldx L0307
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
		sbc L0307
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
		stx L0307
		rts

; 1492
onKeyDown	ldx L0309
		beq L14b3
		ldx #$02
		stx L0307
		rts
L149d		jsr S14ca
		bcc L14b2
		ldx L0317
		bpl L14b2
		ldx #$fe
		stx L0307
		inc L0309
		jmp L1553
L14b2		rts
L14b3		jsr S14ca
		bcc L14b2
		ldx L0317
		bmi L14b2
		beq L14b2
		ldx #$02
		stx L0307
		inc L0309
		jmp L1553
S14ca		ldx #$ff
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
		jsr drawNewSprite
		ldx #$00
		stx L0317
		stx L0306
		sec
		rts
L1527		ldx #$01
		stx L0317
		dex
		stx L0306
		stx L0307
		sec
		rts
L1535		ldx #$ff
		stx L0317
		inx
		stx L0306
		stx L0307
		sec
		rts

L1543		clc
		ldx #$00
		stx L0309
		rts

S154a		lda L0333
		eor #$01
		sta L0333
		rts

L1553		jsr S1575
		jsr S1233
		jsr S129c
		jsr drawNewSprite
		jsr S14ca
		ldx L0307
		beq L156a
		jsr S154a
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
		stx L0306
		stx L0307
L1592		rts

S1593		jsr S1441
		bcc L15aa
		ldx L031F
		bne L15aa
		ldx L0309
		bne L15aa
		ldx playerAxeState ; 00:off / FF: on / 01:back to player
		bmi L15aa
		inc L0314
L15aa		rts

L15ab		ldx L0315
		bne L15b3
		inc L0315
L15b3		jsr S1381
		jsr S1441
		bcs L15c9
		ldx #$00
		stx L0315
		stx L0314
		stx L031F
		jsr drawNewSprite
L15c9		rts

S15ca		ldx #$ff
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
S15fe		ldx $b3f6
		beq L1637
		ldx L031E
		bne L1637
		ldx $0373
		bne L1637
		jsr S164d
		bcs L1637
		jsr S1638
		lda spriteXNew
		sec
		sbc L0306
		sta spriteXNew
		ldx spriteID
		stx spriteIDNew
		jsr drawNewSprite
		ldx #$01
		stx L0314
		dex
		stx L0307
		stx L0306
		inc L031E
L1637		rts
S1638		lda spriteX
		sec
		sbc L0306
		sta spriteXNew
		lda spriteY
		sec
		sbc L0307
		sta spriteYNew
		rts
S164d		ldx #$ff
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
S1681		ldx #$ff
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
		ldx L0308
		bmi L16ba
		dec spriteXNew
		jmp L16bd
L16ba		inc spriteXNew
L16bd		ldx #$00
		stx L0306
		stx L0307
		jsr S1233
		ldx spriteY
		stx spriteYNew
		jsr drawNewSprite
L16d1		rts

; 16D2
onKeyAxe	ldx L0309
		bne L1701

		ldx L0314
		bne L1701

		ldx L0315
		bne L1701

		ldx L031F
		bne L1701

		ldx playerAxeState ; 00:off / FF: on / 01:back to player
		bne L1701

		ldx L034D
		bne L16f5

		ldx playerAxeCount
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
		ldy L0308
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

		ldy L0308
		bpl L1729
		sec
		sbc #$02

L1729		sta spriteXNew
		ldy spriteY
		sty spriteYNew
		jsr drawNewSprite

		inc playerAxeAnim ; 00: normal / 01: axe behind / 02: axe forward
		rts

L1739		ldx #$01
		stx playerAxeState ; 00:off / FF: on / 01:back to player
		lda spriteX
		ldy L0308
		bmi L1754
		ldx #$03
		stx L033A
		clc
		adc #$07
		sta L031A
		jmp L175f

L1754		sec
		sbc #$03
		sta L031A
		ldx #$fd
		stx L033A
L175f		lda spriteY
		clc
		adc #$02
		sta L031B
		lda #$1e
		sta L031C
		jsr S1807
		ldx L0308
		stx L031D
		ldx #$08
		stx L0338
		ldx #$01
		stx L0339
		stx playerAxeState ; 00:off / FF: on / 01:back to player
		jsr S1233
		lda spriteX
		ldy L0308
		bpl L1791
		clc
		adc #$02
L1791		sta spriteXNew
		ldx spriteY
		stx spriteYNew
		jsr drawNewSprite
		rts

S179e		ldx playerAxeState ; 00:off / FF: on / 01:back to player
		dex
		bpl L17a5
		rts

L17a5		jsr S184d
		dec L0338
		beq L17cd
L17ad		lda L031A
		clc
		adc L033A
		sta L031A
		inc L031C
		ldx L031C
		cpx #$21
		bne L17c6
		ldx #$1e
		stx L031C
L17c6		jsr S1807
		jsr S182b
		rts

L17cd		inc L0338
		ldx L0339
		bpl L17db
		inc L031B
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

S1807		ldx L031A
		ldy #$00
		sty $b3f6
		ldy L031B
		lda L031C
		jsr drawSpriteM
		rts

L1819		jsr S184d
		ldx #$00
		stx playerAxeState ; 00:off / FF: on / 01:back to player
		stx playerAxeAnim ; 00: normal / 01: axe behind / 02: axe forward
		stx L031A
		stx L031B
		rts

S182b		jsr S1f2d
		ldx $b3f6
		beq L1841
		jsr S1b93
		jsr S185a
		bcs L1841
		jsr L0A50
L183e		jmp L1819

L1841		ldx L031A
		cpx #$f0
		bcs L184c
		cpx #$9d
		bcs L183e
L184c		rts

S184d		ldx L031A
		ldy L031B
		lda L031C
		jsr drawSpriteM
		rts

S185a		ldx #$ff
		stx L0322
L185f		inc L0322
		ldx L0322
		lda LAC60,x
		beq L188f
		lda L031B
		cmp LAC60,x
		bcc L185f
		sec
		sbc #$10
		cmp LAC80,x
		bcs L185f
		lda LACA0,x
		sec
		sbc #$08
		cmp L031A
		bcs L185f
		clc
		adc #$13
		cmp L031A
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

L18a8		jsr L0A00
S18ab		ldx L037E
		bne L18c1
		ldx level
		stx L037F
L18b6		dec L037F
		bmi L18c1
		jsr S1038
		jmp L18b6

L18c1		ldx L037E
		beq L18d9
		ldx #$07
		stx level
		jsr drawDigit
		dec level
		ldx #$07
		jsr drawDigit
		jmp L18e6

L18d9		ldx #$07
		jsr drawDigit
		inc level
		ldx #$07
		jsr drawDigit

L18e6		ldx level
		jsr loadLevel

		ldx #$00
		stx playerAxeState ; 00:off / FF: on / 01:back to player
		stx keypressed
		bit $c010
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
		jsr drawSprite
		rts

;
S193a		inc L033C
		lda L033C
		ror a
		bcs L1952
		ror a
		bcs L1952
		ldx LAD84
		ldy LAD85
		lda LAD86
		jsr drawSprite
L1952		rts

S1953		jsr S1441
		bcs L1979
		lda LAC40,x
		sta spriteYNew
		inc spriteYNew
		lda spriteX
		clc
		adc L0306
		sta spriteXNew
		jsr S1233
		jsr drawNewSprite
		ldx #$00
		stx L0307
		stx L031E
L1979		rts

drawDigit	lda L0345,x
		tay
		lda L033C,x
		tax
		tya
		ldy #$b9
		cmp #$00
		bne L198b
		lda #$0a
L198b		jsr drawSprite
		rts

L198f		jsr L0A2D
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
		jsr drawSpriteM
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
		bpl L19db
		stx playerAxeState ; 00:off / FF: on / 01:back to player
L19db		bit $c010
		rts

updLifeCount	ldx #$06
		jsr drawDigit
		dec playerLifeCount ; cheat
		bmi L19ef
		ldx #$06
		jsr drawDigit
		rts

L19ef		inc playerLifeCount
		ldx #$06
		jsr drawDigit
		jsr S1e23
		jsr S1c6b
		jmp L108f

L1a00		ldx #$09
		stx L0322
L1a05		ldx L0322
		jsr drawDigit
		dec L0322
		bne L1a05
		rts

S1a11		jsr L1a00
		ldx #$00
		stx L0346
		stx L0347
		stx L0348
		stx L0349
		stx L034A
		stx playerAxeCount
		stx level
		inx
		stx L034D
		inx
		stx playerLifeCount
		jsr L1a00
		rts

loadLevel	stx L0381
		lda #$00
L1a3c		dex
		bmi init2
		clc
		adc #$06
		jmp L1a3c

; load welcome screen
; 1A45
init2		sta rangeIdx
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
		ldx #$7a
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
		ldx #$a0
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
		ldx #$ac
		stx rwts_buf+1
		jsr loadRange
		rts

; L1A9B
unpackToHgr	ldx #$00
		stx $1c
		stx Xpos
		stx Ypos
		ldx #$75 ; packed img at $7500
		stx $1d

L1aa9		jsr S1ab6
		cmp #$fe
		beq L1b03
		jsr S1ac5
		jmp L1aa9

S1ab6		ldy #$00
		lda ($1c),y
		jsr S1abe
		rts

S1abe		inc $1c
		bne L1ac4
		inc $1d
L1ac4		rts

S1ac5		sta L0369
		jsr S1ad5
		lda L0369
		ldy #$00
		sta ($1a),y
		jmp L1ae7

S1ad5		ldx Ypos
		lda hgrHi,x
		sta $1b
		lda hgrLo,x
		clc
		adc Xpos
		sta $1a
		rts

L1ae7		inc Ypos
		ldx Ypos
		cpx #$b7
		bne L1b02
		ldx #$00
		stx Ypos
		inc Xpos
		ldx Xpos
		cpx #$28
		bne L1b02
		pla
		pla
L1b02		rts

L1b03		jsr S1ab6
		sta L0367
		jsr S1ab6
		sta L0368
L1b0f		lda L0367
		jsr S1ac5
		dec L0368
		bne L1b0f
		jmp L1aa9

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

updAxeCount	ldx #$09
		jsr drawDigit
		dec playerAxeCount ; cheat
		bmi L1b48
		ldx #$09
		jsr drawDigit
		rts

L1b48		ldx #$09
		stx playerAxeCount
		jsr drawDigit
		ldx L034D
		beq L1b62
		ldx #$08
		jsr drawDigit
		dec L034D
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
		jsr drawNewSprite
		ldx #$00
		stx L0306
		stx L0307
L1b92		rts

S1b93		ldx playerDeadAnimIdx
		bne L1b92
		lda spriteX
		sec
		sbc #$05
		cmp L031A
		bcs L1b92
		clc
		adc #$0c
		cmp L031A
		bcc L1b92
		lda spriteY
		sec
		sbc #$03
		cmp L031B
		bcs L1b92
		clc
		adc #$11
		cmp L031B
		bcc L1b92
		jsr S1bca
		jsr L1819
		jsr L0AD7
		pla
		pla
		rts

S1bca		ldx #$09
		jsr drawDigit
		inc playerAxeCount
		ldx playerAxeCount
		cpx #$0a
		beq L1bdf
		ldx #$09
		jsr drawDigit
		rts

L1bdf		ldx #$00
		stx playerAxeCount
		ldx #$09
		jsr drawDigit
		ldx #$08
		jsr drawDigit
		inc L034D
		ldx #$08
		jsr drawDigit
		rts

S1bf7		jsr S1bfe
		jsr S1c20
		rts

S1bfe		ldx #$3b
		stx L0374
L1c03		jsr S1c11
		inc L0374
		ldx L0374
		cpx #$7e
		bne L1c03
		rts

S1c11		jsr S1c5d
		ldy #$0c
		lda #$00
L1c18		sta ($1a),y
		iny
		cpy #$1c
		bne L1c18
		rts

S1c20		ldx #$00
		stx $1c
		ldx #$75
		stx $1d
		ldx #$41
		stx L0374
L1c2d		jsr S1c3b
		inc L0374
		ldx L0374
		cpx #$79
		bne L1c2d
		rts

S1c3b		jsr S1c5d
		ldy #$0d
		sty L0375
L1c43		ldy #$00
		lda ($1c),y
		ldy L0375
		sta ($1a),y
		inc $1c
		bne L1c52
		inc $1d
L1c52		inc L0375
		ldy L0375
		cpy #$1c
		bne L1c43
		rts

S1c5d		ldx L0374
		lda hgrLo,x
		sta $1a
		lda hgrHi,x
		sta $1b
		rts

S1c6b		jsr S1e97
		and #$03
		asl a
		asl a
		sta rwts_sec
		lda level
		clc
		adc #$1a
		sta rwts_trk
		ldx #$75
		stx rwts_buf+1
		ldx #$00
		stx rwts_buf
		jsr S1f0d
		jsr S1bf7
		bit $c010
		ldy #$60
L1c93		lda #$ff
		jsr $fca8
		lda $c000
		bmi L1ca5
		jsr S1e4e
		bcs L1ca5
		dey
		bne L1c93
L1ca5		bit $c010
		cpy #$00
		beq L1caf
		jmp L1097

L1caf		rts

S1cb0		inc L037A
		lda L037A
		adc $7900
		adc L0349
		sta L037A
L1cbf		rts

readJoystick	ldx inputMode ; 01:kbd ff:joystick
		bpl L1cbf ; if kdb

		ldx L0309
		beq L1ccf
		ldx #$00
		jmp L1d01

L1ccf		ldx $c061
		bmi L1d16
		ldx playerAxeState ; 00:off / FF: on / 01:back to player
		bne L1cde
		ldx $c062
		bmi L1d1d
L1cde		ldx #$fe
		lda L037C
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
L1cf7		cpx L0306
		beq L1d01
		bmi L1d32
		jmp L1d39

L1d01		ldy L037D
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

S1d40		bit $c010
		ldx #$00
		stx playerDeadAnimIdx
		stx L031E
		stx L031F
		stx playerAxeState ; 00:off / FF: on / 01:back to player
		stx L0314
		stx L0315
		stx L0309
		stx L0306
		stx L0307
		ldx L036E
		beq L1d6f
		ldx #$01
		jsr S1d91
		ldx #$00
		stx L036E
L1d6f		ldx L036F
		beq L1d7e
		ldx #$02
		jsr S1d91
		ldx #$00
		stx L036F
L1d7e		rts

S1d7f		ldx #$00
		jsr $fb1e
		sty L037C
		rts

S1d88		ldx #$01
		jsr $fb1e
		sty L037D
		rts

S1d91		txa
		tay
		lda L036A,y
		tax
		tya
		clc
		adc #$26
		ldy #$b9
		jsr drawSprite
		rts

drawScore	ldx #$05
		jsr drawDigit
		ldx #$05
		inc L034A
		ldy L034A
		cpy #$0a
		beq L1db6
		jsr drawDigit
		rts

L1db6		lda #$00
		sta L034A
		jsr drawDigit
S1dbe		ldx #$04
		jsr drawDigit
		ldx #$04
		inc L0349
		ldy L0349
		cpy #$0a
		beq L1dd3
		jsr drawDigit
		rts

L1dd3		lda #$00
		sta L0349
		jsr drawDigit
S1ddb		ldx #$03
		jsr drawDigit
		ldx #$03
		inc L0348
		ldy L0348
		cpy #$0a
		beq L1df0
		jsr drawDigit
		rts

L1df0		lda #$00
		sta L0348
		jsr drawDigit
S1df8		ldx #$02
		jsr drawDigit
		ldx #$02
		inc L0347
		ldy L0347
		cpy #$0a
		beq L1e0d
		jsr drawDigit
		rts

L1e0d		lda #$00
		sta L0347
		jsr drawDigit
		ldx #$01
		jsr drawDigit
		inc L0346
		ldx #$01
		jsr drawDigit
		rts

S1e23		ldx #$00
L1e25		lda highScore,x
		cmp L0346,x
		bcc L1e35
		bne L1e34
		inx
		cpx #$05
		bne L1e25
	L1e34	rts

L1e35		ldx #$04
L1e37		lda L0346,x
		sta highScore,x
		dex
		bpl L1e37
L1e40		rts

S1e41		ldx level
		cpx #$09
		bne L1e40
		dec level
		jmp L1111

S1e4e		lda inputMode ; 01:kbd ff:joystick
		bpl L1e5a ; if kbd

		lda $c061
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
L1e73		asl a
		asl a
		sta L0382
L1e78		lda #$02
L1e7a		ldy L0382
		ldx L0380
L1e80		cmp $c020,x
		dey
		bne L1e80
		sec
		sbc #$01
		bne L1e7a
		lda L0382
		sec
		sbc #$01
		sta L0382
		bne L1e78
		rts

S1e97		rol $4e
		rol L037A
		rol L0371
		lda $4e
		asl a
		eor $4f
		eor L0371
		rol a
		rol a
		rol a
		rol a
		rol a
		pha
		rol $4f
		lda $4f
		eor L037A
		sta $4e
		pla
		sta L0371
		adc $4e
		adc L037A
		sta L0372
		rts
; 1EC3
loadRange	lda L0900,y
		sta track
		lda L0980,y
		sta sector
		iny
		lda L0900,y
		sta trackend
		lda L0980,y
		sta sectorend
		ldx #$00
		stx rwts_buf
		; check if ptrs =. exit of true
L1ee1		ldx sector
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
		bne L1ee1
		ldx #$00
		stx sector
		inc track
		jmp L1ee1

S1f0d		jsr S1f1e
		inc rwts_buf+1
		inc rwts_sec
		ldx rwts_sec
		cpx #$10
		bne S1f0d
		rts

S1f1e		ldx #$00
		stx rwts_vol
		stx $48
		ldy #$e8
		lda #$b7
		jsr rwts
L1f2c		rts

S1f2d		ldx playerDeadAnimIdx
		bne L1f2c
		lda spriteX
		sec
		sbc #$02
		cmp L031A
		bcs L1f2c
		clc
		adc #$04
		cmp L031A
		bcc L1f2c
		lda spriteY
		sec
		sbc #$03
		cmp L031B
		bcs L1f2c
		clc
		adc #$11
		cmp L031B
		bcc L1f2c
		jsr S1bca
		jsr L1819
		jsr L0AD7
		pla
		pla
		rts
;L1f64
	.hex
	c2 ce c5 a0 ce cf d7 c9 ce 8d a0 cc
	c4 d8 a0 a4 b3 b0 b0 8d a0 c3 d0 d8 a0 a4 c1 c4
	b8 b7 8d a0 c2 c5 d1 a0 d7 c9 ce cc c5 d6 8d a0
	c4 c5 d8 8d a0 c3 d0 d8 a0 a4 c1 c4 b8 b7 8d a0
	c2 c5 d1 a0 d7 c9 ce cc c5 d6 8d ce cf d7 c9 ce
	a0 d2 d4 d3 8d d7 c9 ce cc c5 d6 a0 ca d3 d2 a0
	d7 c9 ce d3 cf d5 8d cc c5 d6 c5 cc a0 cc c4 d8
	a0 a4 b3 b7 c5 8d a0 c2 ce c5 a0 c5 ce c4 c2 cf
	ce d5 d3 8d a0 cc c4 d8 a0 a4 b3 b4 c3 8d a0 d3
	d4 d8 a0 a4 b3 b7 c6 8d c2 cf ce d5 d3 cc cf a0
	.end
