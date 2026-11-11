;
; level 3 code, disk chunk c4 ($A000-$AAFF)
; levelTick, at $A000, is called once per frame by the game's main loop.
;
; the room: a water pool at the bottom left (the player sinks in it), a lift
; that crosses it, a gem to bring from ($79,$33) to its socket ($39,$6D) to
; start the lift, a portal that links the bottom and the top of the shaft,
; 3 walking monsters and a flying bonus that gives an extra life.
; exit: falling through the floor at the bottom left (exit at $00,$C0).
;

RNDL		.equ	$4E
RNDH		.equ	$4F

; inventory item: the gem, globals::assetGemCnt
ITEM_GEM	.equ	2
SHAPE_GEM	.equ	$26 + ITEM_GEM

SHAPE_LIFT	.equ	$41		; going up
SHAPE_LIFT_TOP	.equ	$42		; arrived, then SHAPE_LIFT_GONE
SHAPE_LIFT_GONE	.equ	$43
SHAPE_DEAD	.equ	$19		; player hit by a monster

La000		jmp levelTick

;
; once per frame
;
levelTick	jsr updatePortal
		jsr updateMonsters
		jsr updateBubbles
		jsr updateBonus
		jsr checkPickGem
		jsr checkPlaceGem
		jsr updateLift
		jsr checkSink
		jsr updateSink
		jsr checkBoardLift
		jsr rideLift
		jsr checkExitHole
		jsr checkMonsterHit
		jsr checkNoBounceZone
		jsr checkBonus
		lda #$80
		jsr utils::wait
		rts

;
; portal: closed for portalOff frames, then open for portalOn frames
; at a random side
;
updatePortal	ldx portalOn
		bne portalIsOpen
		dec portalOff
		beq openPortal
		rts

openPortal	jsr utils::random
		and #$3f
		adc #$10
		sta portalOn
		jsr utils::random
		sta portalSide
		jsr drawPortal
		rts

portalIsOpen	jsr drawPortal
		dec portalOn
		beq closePortal
		jsr togglePortalShape
		jsr drawPortal
		jsr portalTransport
		ldx portalOn
		ldy #$10
		jsr game1::tone
		rts

closePortal	jsr utils::random
		and #$1f
		adc #$08
		sta portalOff
		lda RNDH
		adc globals::rndSeed2
		sta globals::rndSeed2
		asl globals::rndSeed2
		ldx #$00
		stx portalOn
		rts

togglePortalShape
		lda portalShape
		eor #$01
		sta portalShape
		rts

drawPortal	ldx portalSide
		bpl :+
		ldx #$5e
		lda portalShape
		ldy #$9c
		jsr spritelib::drawSpriteM
		rts

:		ldx #$56
		lda portalShape
		ldy #$1b
		jsr spritelib::drawSpriteM
		rts

;
; monsters 3 to 1: walk monsterDX, turn around at the ends of their range,
; at random (2 chances in 256), and monsters 2 and 3 when they walk into
; monster 1 going the same way
;
updateMonsters	ldx #$03
		stx globals::L0322
La15b		ldx globals::L0322
		jsr drawMonster
		ldx globals::L0322
		lda monsterRange-1,x
		tay
		lda monsterX-1,x
		clc
		adc monsterDX-1,x
		sta monsterX-1,x
		cmp rangeLo-1,y
		beq La1b3
		cmp rangeHi-1,y
		beq La1b3
		jsr utils::random
		cmp #$02
		bcc La1b3
		cpx #$01
		beq La1aa
		lda monsterY-1,x
		cmp monsterY
		bne La1aa
		lda monsterDX-1,x
		cmp monsterDX
		bne La1aa
		; turn around if X-2 < monster 1's X <= X+2
		lda monsterX-1,x
		sec
		sbc #$02
		cmp monsterX
		bcs La1aa
		clc
		adc #$04
		cmp monsterX
		bcs La1b3
La1aa		jsr drawMonster
		dec globals::L0322
		bne La15b
		rts

La1b3		jsr turnMonster
		jmp La1aa

turnMonster	lda monsterDX-1,x
		eor #$ff
		clc
		adc #$01
		sta monsterDX-1,x
		lda monsterShape-1,x
		eor #$01
		sta monsterShape-1,x
		rts

; monster globals::L0322
drawMonster	ldx globals::L0322
		lda monsterY-1,x
		tay
		lda monsterX-1,x
		sta globals::L033B
		lda monsterShape-1,x
		ldx globals::L033B
		jsr spritelib::drawSpriteM
		rts

;
; bubbles rising in the pool, one column after the other
;
updateBubbles	ldx bubbleFrame
		beq nextBubble
		jsr drawBubble
		inc bubbleFrame
		ldx bubbleFrame
		cpx #$09
		beq La212
		jsr drawBubble
		rts

nextBubble	inc bubbleColumn
		ldx bubbleColumn
		cpx #$04
		bne :+
		ldx #$00
		stx bubbleColumn
:		ldx #$01
		stx bubbleFrame
		jsr drawBubble
		rts

La212		ldx #$00
		stx bubbleFrame
		rts

drawBubble	lda bubbleFrame
		ldx bubbleColumn
:		beq :+
		clc
		adc #$10
		dex
		jmp :-

:		tax
		lda bubblePath+7,x
		tay
		lda bubblePath-1,x
		sta globals::L033B
		ldx bubbleFrame
		lda bubbleShapes-1,x
		ldx globals::L033B
		jsr spritelib::drawSprite
La23e		rts

;
; flying bonus, one step on its path per frame;
; once taken, it flies to the end of its path, then stops
;
updateBonus	ldx bonusTaken
		bmi La23e
		ldx bonusStep
		lda bonusPathX,x
		cmp bonusPathX+1,x
		bne La263
		lda bonusPathY,x
		cmp bonusPathY+1,x
		bne La263
		lda bonusPathShape,x
		cmp bonusPathShape+1,x
		bne La263
		inc bonusStep
		rts

La263		jsr drawBonus
		inc bonusStep
		jsr drawBonus
		ldx bonusTaken
		beq La23e
		ldx bonusStep
		bne La23e
		ldx #$ff
		stx bonusTaken
		rts

drawBonus	ldx bonusStep
		lda bonusPathY,x
		tay
		lda bonusPathX,x
		sta globals::L033B
		lda bonusPathShape,x
		ldx globals::L033B
		jsr spritelib::drawSpriteM
		rts

;
; portal open: moves the player, then monster 1 or 3, to the other side
;
portalTransport	jsr transportPlayer
		jsr transportMonster
La299		rts

transportPlayer	ldx globals::playerDeadAnimIdx
		bne La299
		ldx portalSide
		bpl La2dd
		; bottom portal: player at X $5E-$61, Y $A2 -> ($58, $21)
		ldx globals::spriteX
		cpx #$60
		beq La2b8
		cpx #$61
		beq La2b8
		cpx #$5f
		beq La2b8
		cpx #$5e
		beq La2b8
		rts

La2b8		ldx globals::spriteY
		cpx #$a2
		beq :+
		rts

:		ldx globals::spriteX
		ldy globals::spriteY
		lda globals::spriteID
		jsr spritelib::drawSpriteM
		ldx #$58
		stx globals::spriteX
		ldy #$21
		sty globals::spriteY
		lda globals::spriteID
		jsr spritelib::drawSpriteM
		rts

		; top portal: player at X $57-$5A, Y $21 -> ($60, $A2)
La2dd		ldx globals::spriteX
		cpx #$58
		beq La2f1
		cpx #$59
		beq La2f1
		cpx #$57
		beq La2f1
		cpx #$5a
		beq La2f1
		rts

La2f1		ldx globals::spriteY
		cpx #$21
		beq :+
		rts

:		ldx globals::spriteX
		ldy globals::spriteY
		lda globals::spriteID
		jsr spritelib::drawSpriteM
		ldx #$60
		stx globals::spriteX
		ldy #$a2
		sty globals::spriteY
		lda globals::spriteID
		jsr spritelib::drawSpriteM
		rts

La316		jmp transportDown

		; bottom portal: monster at X $60/$61, Y $AB -> ($58, $2A), range 3
transportMonster
		ldx portalSide
		bpl La316
		ldx monsterY
		cpx #$ab
		bne La355
		ldx monsterX
		cpx #$60
		beq :+
		cpx #$61
		beq :+
		jmp La355

:		ldx #$03
		stx monsterRange
		ldx monsterX
		ldy monsterY
		lda monsterShape
		jsr spritelib::drawSpriteM
		ldx #$58
		stx monsterX
		ldy #$2a
		sty monsterY
		lda monsterShape
		jsr spritelib::drawSpriteM
		rts

La355		ldx monsterY+2
		cpx #$ab
		bne La38b
		ldx monsterX+2
		cpx #$60
		beq :+
		cpx #$61
		beq :+
		jmp La38b

:		ldx #$03
		stx monsterRange+2
		ldx monsterX+2
		ldy monsterY+2
		lda monsterShape+2
		jsr spritelib::drawSpriteM
		ldx #$58
		stx monsterX+2
		ldy #$2a
		sty monsterY+2
		lda monsterShape+2
		jsr spritelib::drawSpriteM
La38b		rts

		; top portal: monster at X $58/$59, Y $2A -> ($60, $AB), range 1
transportDown	ldx monsterY
		cpx #$2a
		bne La3c3
		ldx monsterX
		cpx #$58
		beq :+
		cpx #$59
		beq :+
		jmp La3c3

:		ldx #$01
		stx monsterRange
		ldx monsterX
		ldy monsterY
		lda monsterShape
		jsr spritelib::drawSpriteM
		ldx #$60
		stx monsterX
		ldy #$ab
		sty monsterY
		lda monsterShape
		jsr spritelib::drawSpriteM
		rts

La3c3		ldx monsterY+2
		cpx #$2a
		bne La3f9
		ldx monsterX+2
		cpx #$58
		beq :+
		cpx #$59
		beq :+
		jmp La3f9

:		ldx #$01
		stx monsterRange+2
		ldx monsterX+2
		ldy monsterY+2
		lda monsterShape+2
		jsr spritelib::drawSpriteM
		ldx #$60
		stx monsterX+2
		ldy #$ab
		sty monsterY+2
		lda monsterShape+2
		jsr spritelib::drawSpriteM
La3f9		rts

;
; inventory icon X (shape $26+X) on the status line
;
drawItemIcon	txa
		tay
		lda globals::assetData,y
		tax
		tya
		clc
		adc #$26
		ldy #$b9
		jsr spritelib::drawSprite
		rts

;
; gem: taken at ($75-$76, $2C), +200
;
checkPickGem	ldx globals::assetGemCnt
		bne La421
		ldx globals::spriteY
		cpx #$2c
		bne La421
		ldx globals::spriteX
		cpx #$75
		beq :+
		cpx #$76
		beq :+
La421		rts

:		ldx #ITEM_GEM
		jsr drawItemIcon
		ldx #$01
		stx globals::assetGemCnt
		ldx #$79
		ldy #$33
		lda #SHAPE_GEM
		jsr spritelib::drawSprite
		jsr game1::scoreAdd100
		jsr game1::scoreAdd100
		jsr soundlib::L0ab6
		rts

;
; gem: put in its socket at ($39-$3A or $4B, $69), +500, starts the lift
;
checkPlaceGem	ldx globals::assetGemCnt
		beq La421
		ldx globals::spriteY
		cpx #$69
		bne La45a
		ldx globals::spriteX
		cpx #$39
		beq :+
		cpx #$3a
		beq :+
		cpx #$4b
		beq :+
La45a		rts

:		ldx #ITEM_GEM
		jsr drawItemIcon
		ldx #$00
		stx globals::assetGemCnt
		ldy #$6d
		ldx #$39
		lda #SHAPE_GEM
		jsr spritelib::drawSprite
		jsr startLift
		jsr game1::scoreAdd250
		jsr game1::scoreAdd250
		jsr soundlib::L0ac5
		rts

startLift	inc liftState
		ldx #$2a
		stx liftX
		ldy #$8e
		sty liftY
		lda #SHAPE_LIFT
		jsr spritelib::drawSpriteM
		rts

;
; lift: goes up to Y=$1B, shows SHAPE_LIFT_TOP then SHAPE_LIFT_GONE,
; then the gem goes back to where it was taken
;
updateLift	ldx liftState
		beq La4ad
		bmi liftAtTop
		jsr drawLift
		dec liftY
		ldx liftY
		cpx #$1b
		beq liftArrived
		jsr drawLift
		ldx liftY
		ldy #$10
		jsr game1::tone
La4ad		rts

drawLift	ldx liftX
		ldy liftY
		lda #SHAPE_LIFT
		jsr spritelib::drawSpriteM
		rts

liftArrived	ldx liftX
		ldy liftY
		lda #SHAPE_LIFT_TOP
		jsr spritelib::drawSpriteM
		ldx #$ff
		stx liftState
		ldx #$00
		stx LAC40+8
		stx onLift
		rts

liftAtTop	cpx #$fe
		beq resetGem
		ldx liftX
		ldy liftY
		lda #SHAPE_LIFT_TOP
		jsr spritelib::drawSpriteM
		ldx liftX
		ldy liftY
		lda #SHAPE_LIFT_GONE
		jsr spritelib::drawSpriteM
		dec liftState
		rts

resetGem	ldx liftX
		ldy liftY
		lda #SHAPE_LIFT_GONE
		jsr spritelib::drawSpriteM
		ldx #$00
		stx liftState
		ldx #$79
		ldy #$33
		lda #SHAPE_GEM
		jsr spritelib::drawSprite
		ldy #$6d
		ldx #$39
		lda #SHAPE_GEM
		jsr spritelib::drawSprite
		rts

;
; player in the pool (X $12-$3F, Y >= $8E), not on the lift: sinks
; (globals::playerDeadAnimIdx = 8, the dying animation's last frame)
;
checkSink	ldx globals::playerDeadAnimIdx
		bne La544
		ldx onLift
		bne La544
		ldx globals::spriteX
		cpx #$12
		bcc La544
		cpx #$40
		bcs La544
		ldx globals::spriteY
		cpx #$8e
		bcc La544
		jsr startSink
		ldx #$08
		stx globals::playerDeadAnimIdx
		ldx globals::spriteX
		ldy globals::spriteY
		lda globals::spriteID
		jsr spritelib::drawSpriteM
La544		rts

startSink	inc sinkFrame
		ldx globals::spriteX
		stx sinkX
		jsr drawSink
		rts

updateSink	ldx sinkFrame
		beq La544
		jsr drawSink
		inc sinkFrame
		ldx sinkFrame
		cpx #$09
		beq :+
		jsr drawSink
		rts

:		ldx #$00
		stx sinkFrame
		rts

drawSink	ldx sinkFrame
		lda sinkShapes-1,x
		ldx sinkX
		ldy #$7f
		jsr spritelib::drawPlain
		rts

;
; lift: the player gets on it when near it while it goes up,
; it carries him (+1 per frame) until he leaves it
;
; LAC40+8 is set to the lift's top while ridden, but this ledge comes
; after the end of the ledge list (LAC40+7 = 0): the core never sees it.
;
checkBoardLift	ldx onLift
		bne La5b4
		ldx liftState
		beq leaveLift
		bmi leaveLift
		jsr isNearLift
		bcc leaveLift
		jsr drawPlayer
		lda liftX
		sta globals::spriteX
		inc globals::spriteX
		jsr drawPlayer
		ldx #$01
		stx onLift
		dex
		stx globals::playerXspeed
		stx globals::L0314
		stx globals::L0315
		stx globals::isPlayerJumping
		ldx #$fd
		stx globals::playerYspeed
La5b4		rts

leaveLift	ldx #$00
		stx LAC40+8
		stx onLift
		stx globals::L0373
		rts

rideLift	ldx onLift
		beq leaveLift
		jsr game1::scoreAdd1
		lda liftY
		sta LAC40+8
		inc LAC40+8
		jsr drawPlayer
		ldx globals::isPlayerJumping
		beq :+
		ldx globals::playerYspeed
		cpx #$02
		bne La5f8
:		lda liftY
		sta globals::spriteY
		inc globals::spriteY
		ldx #$00
		stx globals::L0315
		stx globals::L0314
		stx globals::playerYspeed
		stx globals::isPlayerJumping
La5f8		jsr drawPlayer
		jsr isNearLift
		bcc fellOffLift
		ldx #$01
		stx globals::L0373
		dex
		stx globals::L0314
		rts

drawPlayer	ldx globals::spriteX
		ldy globals::spriteY
		lda globals::spriteID
		jsr spritelib::drawSpriteM
		rts

fellOffLift	jsr leaveLift
		ldx #$01
		stx globals::L0314
		dex
		stx globals::L0315
		stx globals::isPlayerJumping
		stx globals::L031E
		rts

; C=1 if liftX-6 < player X <= liftX+11 and liftY-16 < player Y <= liftY+20
isNearLift	lda liftX
		clc
		adc #$0b
		cmp globals::spriteX
		bcc :+
		sec
		sbc #$11
		cmp globals::spriteX
		bcs :+
		lda liftY
		sec
		sbc #$10
		cmp globals::spriteY
		bcs :+
		clc
		adc #$24
		cmp globals::spriteY
		bcc :+
		sec
		rts

:		clc
		rts

;
; fell through the floor (Y >= $C0): stop on the exit ($00, $C0)
;
checkExitHole	ldx globals::spriteY
		cpx #$c0
		bcc La66b
		ldx #$00
		stx globals::playerXspeed
		stx globals::playerYspeed
		stx globals::spriteX
		ldx #$c0
		stx globals::spriteY
La66b		rts

;
; monster 1..3 hit: X-4 < player X <= X+4 and Y-12 < player Y <= Y-5
;
checkMonsterHit	ldx globals::playerDeadAnimIdx
		bne La66b
		ldx #$ff
		stx globals::L0322
La676		inc globals::L0322
		ldx globals::L0322
		cpx #$03
		beq La66b
		lda monsterX,x
		sec
		sbc #$04
		cmp globals::spriteX
		bcs La676
		clc
		adc #$08
		cmp globals::spriteX
		bcc La676
		lda monsterY,x
		sec
		sbc #$0c
		cmp globals::spriteY
		bcs La676
		clc
		adc #$07
		cmp globals::spriteY
		bcc La676
		ldx #$01
		stx globals::playerDeadAnimIdx
		jsr drawPlayer
		ldx globals::spriteX
		ldy globals::spriteY
		lda #SHAPE_DEAD
		jsr spritelib::drawSpriteM
		rts

;
; X $08-$3F, Y < $80: the core doesn't bounce the player off walls
; (globals::L0373); done after rideLift, so it overrides it
;
checkNoBounceZone
		ldx globals::spriteX
		cpx #$08
		bcc :+
		cpx #$40
		bcs :+
		ldx globals::spriteY
		cpx #$80
		bcs :+
		ldx #$01
		stx globals::L0373
		rts

:		ldx #$00
		stx globals::L0373
		rts

;
; flying bonus taken: X-7 < player X <= X+13, Y-16 < player Y <= Y+12
; (not while it's above the screen): extra life
;
checkBonus	ldx bonusTaken
		bne La747
		ldx bonusStep
		lda bonusPathX,x
		sec
		sbc #$07
		cmp globals::spriteX
		bcs La747
		clc
		adc #$14
		cmp globals::spriteX
		bcc La747
		lda bonusPathY,x
		sec
		sbc #$10
		bmi La747
		cmp globals::spriteY
		bcs La747
		clc
		adc #$1c
		cmp globals::spriteY
		bcc La747
		ldx #globals::playerLifeCount-globals::playerData
		jsr game1::drawDigit
		inc globals::playerLifeCount
		ldx #globals::playerLifeCount-globals::playerData
		jsr game1::drawDigit
		inc bonusTaken
		jsr soundlib::L0b23
La747		rts

;
; flying bonus' path: X, Y, shape per step (256 steps, bonusStep wraps)
; bonusPathShape+1,x reads one byte past the table at step $FF: no matter,
; X differs there
;
		placeAt $A800
bonusPathX
	.hex
	36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36
	36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36
	36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36
	36 36 36 36 36 36 36 36 36 36 36 36 36 36 36 36
	36 36 36 36 36 36 38 3A 3C 3C 3C 3E 40 42 44 46
	48 4A 4C 4E 50 52 54 56 58 5A 5C 5E 60 62 64 66
	68 6A 6C 6E 70 72 74 76 78 7A 7A 7A 7A 7A 7A 7A
	7A 7A 7A 7A 7A 7A 7A 7A 7A 7A 7A 7A 7A 7A 7A 7A
	7A 7A 7A 7A 7A 7A 7A 7A 7A 7A 7A 7A 7A 7C 7E 80
	82 84 86 88 88 88 88 88 88 88 88 88 88 88 88 88
	88 88 88 88 88 88 88 88 88 88 88 88 88 88 88 88
	88 88 88 88 88 88 88 88 88 88 88 88 88 88 88 88
	88 88 88 88 88 88 88 88 88 88 88 88 88 88 88 88
	88 88 88 88 88 88 88 88 88 88 88 88 88 88 88 88
	88 88 88 88 88 88 88 88 88 88 88 88 88 88 88 88
	88 88 88 88 88 88 88 88 88 88 88 88 88 88 88 88
	.end
bonusPathY
	.hex
	F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0
	F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0
	F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0
	F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0
	F0 F0 F0 F0 F0 F0 F3 F7 FB FF 02 03 05 07 09 0B
	0C 0B 09 06 05 05 06 06 06 06 06 07 09 0B 0D 0E
	10 13 16 18 19 17 14 12 0F 0D 11 11 11 11 11 11
	11 11 11 11 11 11 11 11 11 11 11 11 11 11 11 11
	11 11 11 11 11 11 11 11 11 11 11 0F 0D 0A 06 03
	01 FE FA F5 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0
	F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0
	F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0
	F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0
	F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0
	F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0
	F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0 F0
	.end
bonusPathShape
	.hex
	4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A
	4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A
	4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A
	4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A
	4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A
	4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A
	4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4B 4B 4B 4B 4B 4B
	4B 4B 4B 4B 4B 4B 4B 4B 4B 4B 4B 4B 4B 4B 4B 4B
	4B 4B 4B 4B 4B 4B 4B 4B 4B 4B 4B 4B 4A 4A 4A 4A
	4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A
	4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A
	4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A
	4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A
	4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A
	4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A
	4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A 4A
	.end
