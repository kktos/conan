;
; level 7 code, disk chunk c4 ($A000-$ABFF)
; La000, at $A000, is called once per frame by the game's main loop.
;
; the hall: a figure at the top left (Volta?) is handed gems from off the
; screen and throws them as shots, along 8 routes; a cage with a prisoner,
; a bridge in the middle with a pit under it, a bridge at the left that
; comes and goes, a catapult at the right, a door at the bottom right that
; lets bats out.
; - a shot is a fireball (it kills on touch; the axe sends it back) or
;   carries a gem: hit with the axe it drops the gem, which falls onto a
;   ledge; take it (+2000) and give it to the figure, at its feet (+500);
; - the shots on route 7 go to the door and let the next bat out: it flies
;   one of 4 routes and kills on touch; the axe kills it (+1505);
; - the pit under the bridge and the bottom left corner kill (a splash);
; - walking to the right end of the floor $7B arms the lever, then walking
;   back to X $7A throws the player up to the ledge $49;
; - falling off the screen goes back to level 6 (checkFellOff).
; the third gem given starts the final animation, L7/FINAL (final.asm),
; which puts the player on the exit: level 8.
;

RNDL		.equ	$4E
RNDH		.equ	$4F

; inventory items, shape SHAPE_ITEMS + item: globals::assetGemCnt
SHAPE_ITEMS	.equ	$26
ITEM_GEM	.equ	2
SHAPE_GEM	.equ	SHAPE_ITEMS + ITEM_GEM
SHAPE_DEAD	.equ	$19			; player killed

SHAPE_BAT	.equ	$42			; flying $42-$45 (EOR 1), waiting at the door $42 / $43
SHAPE_SHOT	.equ	$46			; + shotKind: fireball $46 / $47, carrying a gem $49 / $4A (EOR 3)
SHAPE_DOOR	.equ	$48
SHAPE_VOLTA	.equ	$4B			; the figure throwing, $4B-$4E
SHAPE_ORB	.equ	$4F			; the orbs and the dot
SHAPE_FLAME1	.equ	$50			; + flameFrame
SHAPE_FLAME2	.equ	$51			; + flameFrame
SHAPE_BRIDGE	.equ	$54			; $54 / $55 (EOR 1)
SHAPE_PRISONER	.equ	$5A			; + prisonerFrame
SHAPE_SPARK	.equ	$5C
SHAPE_CAGE_OPEN	.equ	$5D
SHAPE_FLAG	.equ	$5E			; + flag1Frame / flag2Frame
SHAPE_SPLASH	.equ	$62			; $62-$65, splashShapes
SHAPE_BAT_DIE	.equ	$66			; $66 / $67, batDieShapes
SHAPE_LEVER	.equ	$68

; the bridge at the left is ledge 7 of geometry.yaml, written 'off'
BRIDGE_LEDGE	.equ	7
BRIDGE_TOP	.equ	$7B

La000		jmp	levelTick

;
; once per frame (the WAIT halfway sets the pace)
;
levelTick	jsr	updateSparks
		jsr	updateShots
		jsr	flapBat
		jsr	updateOrbs
		jsr	updateFlags
		jsr	updateDot
		jsr	flipToggle
		jsr	updateFlame
		jsr	updateGemPath
		jsr	drawLever
		jsr	checkLever
		jsr	checkCatapult
		jsr	catapultRise
		jsr	checkCatapultTop
		jsr	updateSplash
		jsr	checkPits
		jsr	setBridgeLedge
		jsr	updateBridge
		jsr	flickerBridge
		jsr	updatePrisoner
		jsr	updateFlame
		jsr	walkNextBat
		jsr	flapNextBat
		lda	#$40
		jsr	utils::wait
		jsr	updateShots
		jsr	updateThrow
		jsr	updateBat
		jsr	checkTakeGem
		jsr	checkAxeHitBat
		jsr	updateDoor
		jsr	updateFlame
		jsr	checkGiveGem
		jsr	holdDeath
		jsr	checkShotHit
		jsr	checkBatHit
		jsr	checkFellOff
		rts

; the 4 sparks (shape $5C) run along sparkX/Y, 53 steps, on the bridge
; in the middle: EOR at the old step, then at the new one
updateSparks	ldx	#$03
		stx	idx
La11f		ldx	idx
		jsr	drawSpark
		ldx	idx
		inc	sparkPos,x
		lda	sparkPos,x
		cmp	#$35
		bne	La137
		lda	#$00
		sta	sparkPos,x
La137		jsr	drawSpark
		dec	idx
		bpl	La11f
		rts
drawSpark	lda	sparkPos,x
		tax
		lda	sparkY,x
		tay
		lda	sparkX,x
		tax
		lda	#SHAPE_SPARK
		jsr	spritelib::drawSprite
		rts

; the 2 orbs (shape $4F) under the bridge hop through orbX/Y, 16 steps
updateOrbs	ldx	#$01
		stx	idx
La157		ldx	idx
		jsr	drawOrb
		ldx	idx
		inc	orbPos,x
		lda	orbPos,x
		cmp	#$10
		bne	La16f
		lda	#$00
		sta	orbPos,x
La16f		jsr	drawOrb
		dec	idx
		bpl	La157
		rts
drawOrb		lda	orbPos,x
		tax
		lda	orbY,x
		tay
		lda	orbX,x
		tax
		lda	#SHAPE_ORB
		jsr	spritelib::drawPlain
		rts

; the two flags at the top left, 4 frames each (shapes $5E-$61)
updateFlags	jsr	drawFlag1
		inc	flag1Frame
		ldx	flag1Frame
		cpx	#$04
		bne	La19c
		ldx	#$00
		stx	flag1Frame
La19c		jsr	drawFlag1
		jsr	drawFlag2
		inc	flag2Frame
		ldx	flag2Frame
		cpx	#$04
		bne	La1b1
		ldx	#$00
		stx	flag2Frame
La1b1		jsr	drawFlag2
		rts
drawFlag1	lda	#SHAPE_FLAG
		clc
		adc	flag1Frame
		ldx	#$00
		ldy	#$0a
		jsr	spritelib::drawSprite
		rts
drawFlag2	lda	#SHAPE_FLAG
		clc
		adc	flag2Frame
		ldx	#$0a
		ldy	#$0f
		jsr	spritelib::drawSprite
		rts

; the dot (shape $4F) at Y $2E, top left, goes from X 7 down to 3
updateDot	jsr	drawDot
		dec	dotX
		ldx	dotX
		cpx	#$02
		bne	La1e3
		ldx	#$07
		stx	dotX
La1e3		jsr	drawDot
		rts
drawDot		ldx	dotX
		ldy	#$2e
		lda	#SHAPE_ORB
		jsr	spritelib::drawSprite
		rts

; toggle is flipped every frame and never read
flipToggle	lda	toggle
		eor	#$01
		sta	toggle
		rts

; the flame at ($08,$32), two halves $50 / $51 (+ flameFrame): flickers
; (both halves EORed in turn) when flameTimer goes under 6, changes frame
; when it runs out
updateFlame	dec	flameTimer
		beq	flameNext
		ldx	flameTimer
		cpx	#$06
		beq	La20a
		bcc	flameFlicker
		rts
La20a		jsr	drawFlame1
		rts
flameNext	jsr	drawFlame2
		jsr	random
		and	#$07
		adc	#$08
		sta	flameTimer
		lda	flameFrame
		eor	#$02
		sta	flameFrame
		rts
flameFlicker	txa
		ror
		bcc	La22f
		jsr	drawFlame1
		jsr	drawFlame2
		rts
La22f		jsr	drawFlame2
		jsr	drawFlame1
		rts
drawFlame1	ldx	#$08
		ldy	#$32
		lda	#SHAPE_FLAME1
		clc
		adc	flameFrame
		jsr	spritelib::drawSprite
		rts
drawFlame2	ldx	#$08
		ldy	#$32
		lda	#SHAPE_FLAME2
		clc
		adc	flameFrame
		jsr	spritelib::drawSprite
		rts

; the lever (shape $68 at $83,$83, blinking): walking to the right end of
; the floor $7B (X >= $80) sets it
checkLever	ldx	globals::spriteY
		cpx	#$7c
		bne	La265
		ldx	globals::spriteX
		cpx	#$80
		bcc	La265
		ldx	#$01
		stx	leverOn
La265		rts

; then standing at X $7A-$7B on that floor throws the player up
; (playerYspeed -9), to Y $47 (checkCatapultTop)
checkCatapult	ldx	leverOn
		beq	La265
		ldx	globals::spriteY
		cpx	#$7c
		bne	La265
		ldx	globals::spriteX
		cpx	#$7a
		bcc	La265
		cpx	#$7c
		bcs	La265
		jsr	drawPlayer
		ldx	#$7b
		stx	globals::spriteX
		jsr	drawPlayer
		ldx	#$f7
		stx	globals::playerYspeed
		ldx	#$00
		stx	globals::playerXspeed
		jsr	soundlib::L0b3f
		rts

; a gem (shape $28) comes from the top left, off the screen, along
; gemPathX/Y into the figure's hand; then the figure throws (throwStep)
; and the next gem waits gemWait frames, 6 fewer each time (down to $0E).
; gemStep < 0: waiting, counted up to 0 while the player is alive and
; fewer than 4 gems / shots are in play (inPlay)
updateGemPath	ldx	gemStep
		bmi	gemPathWait
		jsr	drawPathGem
		inc	gemStep
		jsr	drawPathGem
		ldx	gemStep
		cpx	#$17
		beq	La2ac
		rts
La2ac		lda	gemWait
		sta	gemStep
		lda	gemWait
		clc
		adc	#$06
		cmp	#$f8
		bne	La2bf
		sec
		sbc	#$06
La2bf		sta	gemWait
		inc	throwStep
		ldx	#$01
		stx	throwDelay
		dex
		stx	handEmpty
		rts
gemPathWait	ldx	globals::playerDeadAnimIdx
		bne	La2e4
		ldx	inPlay
		cpx	#$04
		bne	La2dc
		rts
La2dc		inc	gemStep
		bne	La2e4
		inc	inPlay
La2e4		rts
drawPathGem	ldx	gemStep
		lda	gemPathY,x
		tay
		lda	gemPathX,x
		tax
		lda	#SHAPE_GEM
		jsr	spritelib::drawPlain
		rts

; lever armed: EOR it every frame (it blinks), leverDrawn follows it
drawLever	ldx	leverOn
		beq	La30c
		ldx	#$83
		ldy	#$83
		lda	#SHAPE_LEVER
		jsr	spritelib::drawSprite
		lda	leverDrawn
		eor	#$01
		sta	leverDrawn
La30c		rts

; the catapult's top: at Y $47 the lever is reset and the player goes on
; to the left
checkCatapultTop
		ldx	leverOn
		beq	La30c
		ldx	globals::spriteY
		cpx	#$47
		bne	La30c
		ldx	leverDrawn
		beq	La321
		jsr	drawLever
La321		ldx	#$00
		stx	leverOn
		ldx	#$ff
		stx	globals::playerXspeed
		ldx	#$ff
		stx	globals::currentXspeed
		rts

; EOR the player (DRAW_SHAPE: with the priority test)
drawPlayer	ldx	globals::spriteX
		ldy	globals::spriteY
		lda	globals::spriteID
		jsr	spritelib::drawSpriteM
		rts

; falling into the pit under the bridge, or off the bottom left corner:
; the player is erased and a splash plays where he fell
checkPits	ldx	globals::playerDeadAnimIdx
		bne	La349
		jsr	checkMiddlePit
		jsr	checkCornerPit
La349		rts
checkMiddlePit	ldx	globals::spriteY
		cpx	#$57
		bcc	La349
		cpx	#$5e
		bcs	La349
		ldx	globals::spriteX
		cpx	#$59
		bcs	La349
		cpx	#$24
		bcc	La349
		jsr	drawPlayer
		ldx	#$08
		stx	globals::playerDeadAnimIdx
		ldx	globals::spriteX
		stx	splashX
		inc	splashFrame
		ldx	#$4f
		stx	splashY
		jsr	drawSplash
La379		rts
checkCornerPit	ldx	globals::spriteY
		cpx	#$a7
		bcc	La379
		ldx	globals::spriteX
		cpx	#$0d
		bcs	La379
		jsr	drawPlayer
		ldx	#$08
		stx	globals::playerDeadAnimIdx
		ldx	globals::spriteX
		stx	splashX
		inc	splashFrame
		ldx	#$a1
		stx	splashY
		jsr	drawSplash
		rts

; the splash, shapes splashShapes, frame 1..8
updateSplash	ldx	splashFrame
		beq	La379
		jsr	drawSplash
		inc	splashFrame
		ldx	splashFrame
		cpx	#$09
		beq	La3b8
		jsr	drawSplash
		rts
La3b8		ldx	#$00
		stx	splashFrame
		rts
drawSplash	ldx	splashFrame
		lda	splashShapes-1,x
		ldy	splashY
		ldx	splashX
		jsr	spritelib::drawPlain
		rts

; the bridge at the left (shape $54 / $55 at $02,$8C) comes and goes:
; ledge BRIDGE_LEDGE gets its top while it's there, 0 (end of the list)
; while it's not
setBridgeLedge	ldx	bridgeOn
		bne	La3d9
		ldx	#$00
		stx	LAC40+BRIDGE_LEDGE
		rts
La3d9		ldx	#BRIDGE_TOP
		stx	LAC40+BRIDGE_LEDGE
		rts

; it toggles when bridgeTimer runs out (then random 0..$7F)
updateBridge	dec	bridgeTimer
		beq	La3e5
		rts
La3e5		jsr	random
		and	#$7f
		sta	bridgeTimer
		lda	bridgeOn
		eor	#$01
		sta	bridgeOn
		jsr	drawBridge
		jsr	setBridgeLedge
		rts

; EOR the bridge, with a tone
drawBridge	ldx	#$02
		ldy	#$8c
		lda	bridgeShape
		jsr	spritelib::drawPlain
		jsr	bridgeTone
		rts

; while it's there it flickers between its two shapes
flickerBridge	ldx	bridgeOn
		beq	La41d
		jsr	drawBridge
		lda	bridgeShape
		eor	#$01
		sta	bridgeShape
		jsr	drawBridge
La41d		rts

; going up fast (playerYspeed < -7, i.e. thrown by the catapult): no
; horizontal move
catapultRise	ldx	globals::playerYspeed
		bpl	La42c
		cpx	#$f9
		bcs	La42c
		ldx	#$00
		stx	globals::playerXspeed
La42c		rts

bridgeTone	ldy	#$05
		ldx	bridgeTimer
		jsr	game1::tone
		rts

; the prisoner in the cage (shape $5A / $5B at $1A,$24) changes frame
; at random times (prisonerTimer 0..$1F)
updatePrisoner	dec	prisonerTimer
		beq	La43c
		rts
La43c		jsr	drawPrisoner
		lda	prisonerFrame
		eor	#$01
		sta	prisonerFrame
		jsr	drawPrisoner
		jsr	random
		and	#$1f
		sta	prisonerTimer
		rts
drawPrisoner	lda	#SHAPE_PRISONER
		clc
		adc	prisonerFrame
		ldx	#$1a
		ldy	#$24
		jsr	spritelib::drawSprite
		rts

; the figure at the top left (Volta? shapes $4B-$4E at $0E-$0A,$29)
; throws: throwStep 1..$0C, every other frame. In its hand (handX/Y/
; Shape, drawn while handEmpty is 0) the gem, steps 1-7, then a fireball;
; at step $0B the shot leaves (throwShot), drawn over that fireball
updateThrow	ldx	throwStep
		beq	La48e
		dec	throwDelay
		bne	La48e
		ldx	#$02
		stx	throwDelay
		jsr	drawThrow
		inc	throwStep
		jsr	drawThrow
		ldx	throwStep
		cpx	#$0b
		bne	La483
		inc	handEmpty
La483		cpx	#$0c
		beq	endThrow
		cpx	#$0b
		bne	La48e
		jsr	throwShot
La48e		rts
endThrow	ldx	#$00
		stx	throwStep
		rts

; EOR step throwStep: the figure, then what it holds
drawThrow	ldx	throwStep
		lda	throwY-1,x
		tay
		lda	throwShape-1,x
		pha
		lda	throwX-1,x
		tax
		pla
		jsr	spritelib::drawPlain
		ldx	handEmpty
		bne	La4c0
		ldx	throwStep
		lda	handY-1,x
		tay
		lda	handShape-1,x
		pha
		lda	handX-1,x
		tax
		pla
		jsr	spritelib::drawPlain
La4c0		rts

; a new shot in a free slot (none free: BRK), from ($13,$20), route:
; - 7, to the door at the bottom right (it lets the next bat out), if
;   no bat flies, no other shot is on route 7 and 3 chances in 8;
; - else 0..6 at random, or globals::L0379 when it's < 7, 11 chances in 16.
; kind 4 (it carries a gem) 1 chance in 2, if no other shot carries or
; drops one; else 1 (a fireball)
throwShot	ldx	#$03
La4c3		lda	shotKind,x
		beq	La4cc
		dex
		bpl	La4c3
		brk
La4cc		lda	#$13
		sta	shotX,x
		lda	#$20
		sta	shotY,x
		lda	batShape
		bne	La4f6
		ldy	#$03
La4dd		lda	shotRoute,y
		cmp	#$07
		beq	La4f6
		dey
		bpl	La4dd
		jsr	random
		cmp	#$60
		bcs	La4f6
		lda	#$07
		sta	shotRoute,x
		jmp	La511
La4f6		jsr	random
		cmp	#$50
		bcc	La504
		lda	globals::L0379
		cmp	#$07
		bcc	La50e
La504		jsr	random
		and	#$07
		tay
		dey
		bmi	La504
		tya
La50e		sta	shotRoute,x
La511		ldy	#$03
La513		lda	shotKind,y
		bmi	La526
		cmp	#$04
		beq	La526
		dey
		bpl	La513
		jsr	random
		cmp	#$80
		bcc	La52e
La526		lda	#$01
		sta	shotKind,x
		jmp	La533
La52e		lda	#$04
		sta	shotKind,x
La533		lda	#$00
		sta	shotSeg,x
		stx	shot
		lda	#SHAPE_SHOT
		sta	shotShape,x
		jsr	nextShotSegment
La543		rts

; a gem dropped by a shot falls (shotDY 2) until it lands on a ledge
moveFallingGem	jsr	drawShot
		ldx	shot
		lda	shotY,x
		clc
		adc	shotDY,x
		sta	shotY,x
		jsr	drawShot
		jsr	gemFall
		jmp	nextShot

;
; the 4 shots, slots 3..0: kind (shotKind) 0 free, 1 fireball, 4 carries a
; gem, $FF a gem falling. Shape shotShape (flips $45 / $46) + kind.
; A shot follows its route (shotRoute, 8 routes): segments of shotTime
; frames moving by shotDX / shotDY, from shotRouteTime / DX / DY (c3).
;
updateShots	ldx	#$04
		stx	shot
nextShot	dec	shot
		bmi	La543
		ldx	shot
		lda	shotKind,x
		beq	nextShot
		bmi	moveFallingGem
		jsr	drawShot
		ldx	shot
		jsr	flipShotShape
		lda	shotX,x
		clc
		adc	shotDX,x
		sta	shotX,x
		lda	shotY,x
		clc
		adc	shotDY,x
		sta	shotY,x
		jsr	drawShot
		ldx	shot
		jsr	checkAxeHitShot
		ldx	shot
		dec	shotTime,x
		bne	nextShot
		jsr	nextShotSegment
		jmp	nextShot

; EOR the shot (DRAW_SHAPE: with the priority test)
drawShot	ldx	shot
		lda	shotY,x
		tay
		lda	shotShape,x
		clc
		adc	shotKind,x
		pha
		lda	shotX,x
		tax
		pla
		jsr	spritelib::drawSpriteM
		rts
flipShotShape	lda	shotShape,x
		eor	#$03
		sta	shotShape,x
		rts

; next segment of the shot's route; a 0 time ends it (the shot is freed),
; a DY of $32 (route 7, at the door) lets the next bat out
nextShotSegment	jsr	shotRouteIndex
		lda	shotRouteTime,y
		beq	freeShot
		sta	shotTime,x
		inc	shotSeg,x
		lda	shotRouteDX,y
		sta	shotDX,x
		lda	shotRouteDY,y
		sta	shotDY,x
		cmp	#$32
		beq	releaseBat
		rts

freeShot	lda	#$00
		sta	shotKind,x
		dec	inPlay
		rts

; the next bat leaves the door: it flies from ($84,$98) along one of 4
; routes at random (batRoute*); another one walks in to wait at the door,
; and the door shows for $10 frames
releaseBat	ldx	#$84
		stx	batX
		ldy	#$98
		sty	batY
		ldx	#$00
		stx	batStep
		jsr	random
		and	#$03
		sta	batRoute
		jsr	drawWaitingBat
		jsr	nextBatStep
		jsr	drawBat
		jsr	sendNextBat
		jsr	drawDoor
		jsr	soundlib::L0b3f
		ldx	#$10
		stx	doorTimer
		rts

; RND, the core's generator: $4E/$4F and globals::sountCnt2 / soundCnt3 / soundCnt1
random		rol	RNDL
		rol	globals::soundCnt1
		rol	globals::sountCnt2
		lda	RNDL
		asl
		eor	RNDH
		eor	globals::sountCnt2
		rol
		rol
		rol
		rol
		rol
		pha
		rol	RNDH
		lda	RNDH
		eor	globals::soundCnt1
		sta	RNDL
		pla
		sta	globals::sountCnt2
		adc	RNDL
		adc	globals::soundCnt1
		sta	globals::soundCnt3
		rts

; the axe hits the shot: +75 points; a shot carrying a gem drops it,
; another one goes back the way it came
checkAxeHitShot	lda	globals::playerAxeState
		beq	La67d
		lda	shotX,x
		sec
		sbc	#$05
		cmp	globals::axeXpos
		bcs	La67d
		clc
		adc	#$0b
		cmp	globals::axeXpos
		bcc	La67d
		lda	shotY,x
		sec
		sbc	#$06
		cmp	globals::axeYpos
		bcs	La67d
		clc
		adc	#$15
		cmp	globals::axeYpos
		bcc	La67d
		jsr	shotHit
		jsr	soundlib::L0a58
		jsr	game1::scoreAdd75
La67d		rts
shotHit		lda	shotKind,x
		cmp	#$04
		beq	dropGem
		jsr	shotRouteIndex
		dey
		lda	shotRouteTime,y
		cmp	shotTime,x
		beq	La6cb
		lda	shotDX,x
		eor	#$ff
		sta	shotDX,x
		inc	shotDX,x
		lda	shotDY,x
		eor	#$ff
		sta	shotDY,x
		inc	shotDY,x
		dec	shotSeg,x
		lda	shotRouteTime,y
		sec
		sbc	shotTime,x
		sta	shotTime,x
		inc	shotTime,x
		inc	shotTime,x
		jsr	drawAxe
		ldx	#$00
		stx	globals::playerAxeState
		stx	globals::playerAxeAnim
		stx	globals::axeXpos
		stx	globals::axeYpos
La6cb		rts

; the shot turns into a gem falling straight down (kind $FF, shape $28)
dropGem		jsr	drawShot
		ldx	shot
		lda	#$ff
		sta	shotKind,x
		lda	#$00
		sta	shotDX,x
		lda	#$02
		sta	shotDY,x
		lda	#SHAPE_GEM+1		; + shotKind $FF: SHAPE_GEM
		sta	shotShape,x
		jsr	drawShot
		rts

gemFall		jsr	checkGemLands
		jsr	checkGemLost
		rts

; a falling gem goes off the bottom, or into the pit under the bridge
checkGemLost	ldx	shot
		lda	shotY,x
		cmp	#$b3
		bcs	La711
		lda	shotX,x
		cmp	#$38
		bcc	La71a
		cmp	#$66
		bcs	La71a
		lda	shotY,x
		cmp	#$59
		bcc	La71a
		cmp	#$5e
		bcs	La71a
La711		jsr	drawShot
		ldx	shot
		jsr	freeShot
La71a		rts

; a falling gem lands on a ledge: it stops 12 lines under its top
checkGemLands	ldx	shot
		ldy	#$ff
La720		iny
		lda	LAC40,y
		beq	La71a
		lda	shotX,x
		cmp	LAC00,y
		bcc	La720
		cmp	LAC20,y
		bcs	La720
		lda	LAC40,y
		clc
		adc	#$04
		cmp	shotY,x
		bcs	La720
		clc
		adc	#$04
		cmp	shotY,x
		bcc	La720
		clc
		adc	#$04
		sta	landY
		lda	#$00
		sta	shotDY,x
		jsr	drawShot
		ldx	shot
		lda	landY
		sta	shotY,x
		jsr	drawShot
		rts

; EOR the axe (the throw ends)
drawAxe		ldx	globals::axeXpos
		ldy	globals::axeYpos
		lda	globals::axeSpriteID
		jsr	spritelib::drawSpriteM
		rts

; the next bat (shapes $42 / $43) walks in from the right at Y $98, X $A0
; down to $84; there it waits (nextBatWaitX = $84), flapping
walkNextBat	ldx	nextBatX
		beq	La786
		jsr	drawWalkingBat
		dec	nextBatX
		jsr	flipNextBat
		jsr	drawWalkingBat
		ldx	nextBatX
		cpx	#$84
		beq	nextBatArrived
La786		rts
nextBatArrived	stx	nextBatWaitX
		ldx	#$00
		stx	nextBatX
		rts
drawWalkingBat	ldx	nextBatX
		lda	nextBatShape
		ldy	#$98
		jsr	spritelib::drawSpriteM
		rts
flapNextBat	ldx	nextBatWaitX
		beq	La786
		jsr	drawWaitingBat
		jsr	flipNextBat
		jsr	drawWaitingBat
		rts
flipNextBat	lda	nextBatShape
		eor	#$01
		sta	nextBatShape
		rts
drawWaitingBat	ldx	nextBatWaitX
		lda	nextBatShape
		ldy	#$98
		jsr	spritelib::drawSpriteM
		rts

; Y = shotRoute * 16 + shotSeg, for the route tables
shotRouteIndex	ldx	shot
		lda	shotRoute,x
		asl
		asl
		asl
		asl
		clc
		adc	shotSeg,x
		tay
		rts

; a 0 shape ends the bat's route: the bat is gone, and its caller
; (updateBat) returns too
batRouteEnd	lda	#$00
		sta	batShape
		pla
		pla
		rts
batDieEnd	lda	#$00
		sta	batShape
		rts

; the bat's next step: Y = batRoute * 32 + batStep in the route tables
; (batRouteShape / Time in c1, batRouteDX / DY in c3)
nextBatStep	lda	batRoute
		asl
		asl
		asl
		asl
		asl
		clc
		adc	batStep
		tay
		lda	batRouteShape,y
		beq	batRouteEnd
		sta	batShape
		lda	batRouteDY,y
		sta	batDY
		inc	batStep
		lda	batRouteDX,y
		sta	batDX
		lda	batRouteTime,y
		sta	batTime
		rts

; hit, the bat falls, 3 frames (batDieShapes), then it's gone
batDying	jsr	drawDyingBat
		inc	batY
		inc	batDieFrame
		ldx	batDieFrame
		cpx	#$03
		beq	batDieEnd
		jsr	drawDyingBat
		ldy	#$03
		jsr	soundlib::L0ae6
		rts
drawBat		ldx	batX
		ldy	batY
		lda	batShape
		jsr	spritelib::drawSpriteM
La82e		rts

; the bat flies (batStep = $FF: it's dying)
updateBat	ldx	batShape
		beq	La82e
		ldx	batStep
		inx
		beq	batDying
		jsr	drawBat
		lda	batX
		clc
		adc	batDX
		sta	batX
		lda	batY
		clc
		adc	batDY
		sta	batY
		lda	batShape
		eor	#$01
		sta	batShape
		dec	batTime
		bne	La861
		jsr	nextBatStep
La861		jsr	drawBat
		rts

sendNextBat	ldx	#$a0
		stx	nextBatX
		ldx	#$00
		stx	nextBatWaitX
		rts

; X = item: EOR its icon on the bottom line
drawInventoryItem
		txa
		tay
		lda	globals::assetData,y
		tax
		tya
		clc
		adc	#SHAPE_ITEMS
		ldy	#$b9
		jsr	spritelib::drawSprite
		rts

; the player takes a falling gem (gem + 1, +2000 points); one gem at a
; time
checkTakeGem	ldx	globals::assetGemCnt
		bne	La88f
		ldx	#$03
La887		lda	shotKind,x
		bmi	takeGemHit
		dex
		bpl	La887
La88f		rts
takeGemHit	lda	shotX,x
		clc
		adc	#$04
		cmp	globals::spriteX
		bcc	La88f
		sec
		sbc	#$0c
		cmp	globals::spriteX
		bcs	La88f
		lda	shotY,x
		clc
		adc	#$04
		cmp	globals::spriteY
		bcc	La88f
		sec
		sbc	#$15
		cmp	globals::spriteY
		bcs	La88f
		jsr	freeShot
		stx	shot
		jsr	drawShotGem
		inc	globals::assetGemCnt
		ldx	#ITEM_GEM
		jsr	drawInventoryItem
		jsr	game1::scoreAdd1000
		jsr	game1::scoreAdd1000
		jsr	soundlib::L0ab6
		rts

drawShotGem	ldx	shot
		lda	shotY,x
		tay
		lda	shotX,x
		tax
		lda	#SHAPE_GEM
		jsr	spritelib::drawSpriteM
		rts

flapBat		ldx	batShape
		beq	La8fb
		ldx	batStep
		inx
		beq	La8fb
		jsr	drawBat
		lda	batShape
		eor	#$01
		sta	batShape
		jsr	drawBat
La8fb		rts

; the axe hits the bat: +1505 points (250 + 250 + 1000 + 5) and it falls
; (batStep $FF)
checkAxeHitBat	ldx	batShape
		beq	La950
		ldx	batStep
		inx
		beq	La950
		ldx	globals::playerAxeState
		beq	La950
		lda	globals::axeXpos
		sec
		sbc	#$0b
		cmp	batX
		bcs	La950
		clc
		adc	#$12
		cmp	batX
		bcc	La950
		lda	globals::axeYpos
		sec
		sbc	#$0d
		cmp	batY
		bcs	La950
		clc
		adc	#$11
		cmp	batY
		bcc	La950
		ldx	#$00
		stx	batDieFrame
		dex
		stx	batStep
		jsr	drawBat
		jsr	drawDyingBat
		jsr	game1::scoreAdd250
		jsr	game1::scoreAdd250
		jsr	game1::scoreAdd1000
		jsr	game1::scoreAdd5
		jsr	soundlib::L0b06
La950		rts
drawDyingBat	ldx	batDieFrame
		lda	batDieShapes,x
		ldx	batX
		ldy	batY
		jsr	spritelib::drawSpriteM
		rts

; the door shows for doorTimer frames when a bat leaves
updateDoor	ldx	doorTimer
		beq	La96e
		dec	doorTimer
		bne	La96e
		jsr	drawDoor
La96e		rts
drawDoor	ldx	#$7f
		ldy	#$98
		lda	#SHAPE_DOOR
		jsr	spritelib::drawSprite
La978		rts

; the player brings a gem to the figure (X $0F-$19 on the ledge $53):
; +500 points, the gem goes at its feet (gemsGiven); with the third,
; the final animation
checkGiveGem	ldx	globals::assetGemCnt
		beq	La978
		ldx	globals::spriteY
		cpx	#$54
		bne	La978
		ldx	globals::assetGemCnt
		beq	La978
		ldx	globals::spriteX
		cpx	#$0f
		bcc	La978
		cpx	#$1a
		bcs	La978
		dec	globals::assetGemCnt
		inc	gemsGiven
		ldx	#ITEM_GEM
		jsr	drawInventoryItem
		jsr	drawGivenGem
		jsr	game1::scoreAdd250
		jsr	game1::scoreAdd250
		jsr	soundlib::L0ac5
		ldx	gemsGiven
		cpx	#$03
		bne	La9b6
		jmp	startFinal
La9b6		rts

; gem n (gemsGiven) at X $10 + 5 * (n - 1), Y $59
drawGivenGem	ldx	gemsGiven
		lda	#$10
La9bc		dex
		beq	La9c5
		clc
		adc	#$05
		jmp	La9bc
La9c5		tax
		ldy	#$59
		lda	#SHAPE_GEM
		jsr	spritelib::drawSprite
		rts

; the player is dead: hold the death animation at its step $0F while a
; fireball or a gem-carrying shot flies
holdDeath	ldx	globals::playerDeadAnimIdx
		cpx	#$0f
		bne	La9e5
		ldy	#$03
La9d7		lda	shotKind,y
		bmi	La9e2
		beq	La9e2
		dec	globals::playerDeadAnimIdx
		rts
La9e2		dey
		bpl	La9d7
La9e5		rts

killPlayer	jsr	drawPlayer
		ldx	#SHAPE_DEAD
		stx	globals::spriteID
		jsr	drawPlayer
		ldx	#$01
		stx	globals::playerDeadAnimIdx
		rts

; a fireball, or a shot carrying a gem, touches the player
checkShotHit	ldx	globals::playerDeadAnimIdx
		bne	Laa31
		ldx	#$04
La9fe		dex
		bmi	Laa31
		lda	shotKind,x
		beq	La9fe
		bmi	La9fe
		lda	shotX,x
		sec
		sbc	#$04
		cmp	globals::spriteX
		bcs	La9fe
		clc
		adc	#$09
		cmp	globals::spriteX
		bcc	La9fe
		lda	shotY,x
		sec
		sbc	#$0d
		cmp	globals::spriteY
		bcs	La9fe
		clc
		adc	#$15
		cmp	globals::spriteY
		bcc	La9fe
		jsr	killPlayer
Laa31		rts

; the bat touches the player
checkBatHit	ldx	globals::playerDeadAnimIdx
		bne	Laa31
		ldx	batShape
		beq	Laa31
		lda	batX
		clc
		adc	#$06
		cmp	globals::spriteX
		bcc	Laa31
		sec
		sbc	#$0a
		cmp	globals::spriteX
		bcs	Laa31
		lda	batY
		sec
		sbc	#$0c
		cmp	globals::spriteY
		bcs	Laa31
		clc
		adc	#$15
		cmp	globals::spriteY
		bcc	Laa31
		jmp	killPlayer

; falling below the screen (Y >= $E0) goes back to level 6: the exit
; on the player (globals::L037E set: loadInitLevel goes one level down)
checkFellOff	ldx	globals::spriteY
		cpx	#$e0
		bcc	Laa8e
		ldx	#$30
		stx	globals::L037E
		ldx	#$00
		stx	globals::playerXspeed
		stx	globals::playerYspeed
		inx
		stx	globals::L0314
		ldx	#$05
		stx	globals::level
		ldx	globals::spriteX
		stx	LAD87
		ldx	globals::spriteY
		stx	LAD88
Laa8e		rts

; the third gem given: the player at the figure's feet ($17,$54), the
; prisoner on frame 0, shape $5D EORed on the cage, the figure back to
; its standing shape; then the final animation, L7/FINAL (final.asm), in place of
; disk 2 T22 S0-SA that the original read with RWTS into $9F00-$A9FF.
; It returns from levelTick's caller, the player on the exit.
; tinyDOS loads whole blocks: the file, $9F00-$A9FF, fills $9F00-$AAFF,
; so the code that loads it is at $AB6C, after the shot tables.
startFinal	jsr	drawPlayer
		ldx	#$17
		stx	globals::spriteX
		ldy	#$54
		sty	globals::spriteY
		jsr	drawPlayer
		ldx	prisonerFrame
		beq	Laaaf
		jsr	drawPrisoner
		ldx	#$00
		stx	prisonerFrame
		jsr	drawPrisoner
Laaaf		ldx	#$1a
		ldy	#$22
		lda	#SHAPE_CAGE_OPEN
		jsr	spritelib::drawSprite
		ldx	throwStep
		beq	loadFinal
		jsr	drawThrow
		ldx	#$0e
		ldy	#$29
		lda	#SHAPE_VOLTA
		jsr	spritelib::drawPlain
loadFinal	jmp	loadFinalFile		; past what the file overwrites


; $AAxx-$AAFF: slack (the original's RWTS calls took it)

; Volta's throw, by throwStep 1..$0C (as table-1,x): the figure, then what
; it holds (the gem, then a fireball)
		placeAt $AB00

throwX		.db $0E, $0E, $0E, $0E, $0E, $0A, $0A, $0A, $0E, $0E, $0E, $0E
throwY		.db $29, $29, $29, $29, $29, $2A, $2A, $2A, $29, $29, $29, $29
throwShape	.db $4B, $4D, $4C, $4D, $4D, $4E, $4E, $4E, $4D, $4C, $4D, $4B
handX		.db $12, $12, $13, $13, $13, $08, $08, $08, $13, $13, $13, $13
handY		.db $20, $24, $26, $2F, $2F, $32, $32, $30, $2D, $24, $20, $20
handShape	.db $28, $28, $28, $28, $28, $28, $28, $47, $47, $47, $47, $47

; the 4 shots (updateShots)
shotX		.db $13, $13, $13, $13
shotY		.db $20, $20, $20, $20
shotKind	.db $00, $00, $00, $00	; 0 free, 1 fireball, 4 carries a gem, $FF a gem falling
shotSeg		.db $00, $00, $00, $00	; segment of its route
shotTime	.db $10, $10, $10, $10	; frames left in the segment
shotDX		.db $00, $00, $00, $00
shotDY		.db $00, $00, $00, $00
shotRoute	.db $01, $01, $01, $01	; 0..7
shotShape	.db $45, $45, $45, $45	; $45 / $46, + shotKind

; loadFinal's tinyDOS call: L7/FINAL, from $9F00, is loaded by whole
; blocks of 512 bytes, up to $AAFF
		.assert * >= $9F00 + .ceil(($A9FF + 1 - $9F00) / 512) * 512, "loadFinalFile is overwritten by L7/FINAL"
loadFinalFile	dosLoadFile	fFinal
		jmp	final

fFinal		.pstr	"L7/FINAL"

; then slack (the original has leftover code: a copy of DRAW_PLAIN and a
; level tick)
