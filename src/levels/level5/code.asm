;
; level 5 code, disk chunk c4 ($A000-$ABFF)
; levelTick, at $A000, is called once per frame by the game's main loop.
;
; the room: 3 floors linked by 2 pairs of portals (blinking bars, shape $52)
; that take the player and the walkers from one side to the other, a pile of
; 6 gems at the bottom left that turn into walkers one by one (each walker
; shoots), a burrower along the bottom that goes into the ground at its
; holes, water at the bottom right (X >= $42) the player falls in, a fire at
; the top left in front of the key, put out by leaving a gem at ($6D,$27),
; and an axe bonus at the bottom.
; once the 6 gems are taken or their walkers killed (itemsDone), the door at
; ($58,$17) opens; getting to the top then lets the player past X $53, and
; the key opens the door at the top right.
; exit: walking out at the top right (exit at $8A,$23).
;
; spritelib::drawPlain EORs the shape without the priority / collision
; tests. Before and after drawing the burrower with it, the code EORs the
; player and the axe off and back on when they're close
; (togglePlayerNearBurrower, toggleAxeNearBurrower).
;

; inventory items, shape SHAPE_ITEMS + item: globals::assetKeyCnt / assetGemCnt
SHAPE_ITEMS	.equ	$26
ITEM_KEY	.equ	1
ITEM_GEM	.equ	2
SHAPE_KEY	.equ	SHAPE_ITEMS + ITEM_KEY
SHAPE_GEM	.equ	SHAPE_ITEMS + ITEM_GEM
SHAPE_AXE	.equ	$1E			; axe bonus
SHAPE_DOOR	.equ	$2A			; EORed over a door to open it
SHAPE_DEAD	.equ	$19			; player killed

SHAPE_WALKER_L	.equ	$41			; going left, $41 / $42 (EOR 3)
SHAPE_WALKER_R	.equ	$43			; going right, $43 / $44 (EOR 7)
SHAPE_WALKER_DIE_L	.equ	$45		; dying, going left
SHAPE_WALKER_DIE_R	.equ	$46		; dying, going right
SHAPE_SHOT_L	.equ	$47
SHAPE_SHOT_R	.equ	$48
SHAPE_BURROWER	.equ	$49			; walking $49 / $4A (EOR 3), going into the ground $4B-$4D
SHAPE_BURROWER_IN	.equ	$4D		; deepest in the ground
SHAPE_BURROWER_END	.equ	$4E		; one past it: it comes out of another hole
SHAPE_FIRE	.equ	$4E			; 2 halves, $4E / $4F (+ fireFrame)
SHAPE_BAR	.equ	$52			; portal bar

AXES_HI		.equ	globals::playerAxeCountHi - globals::playerData
AXES_LO		.equ	globals::playerAxeCountLo - globals::playerData

La000		jmp	levelTick

;
; once per frame; the more gems are gone from the pile and the more are
; done with, the shorter the wait
;
levelTick	jsr	updateFire
		jsr	updatePortalBars
		jsr	checkPortals
		jsr	updateRelease
		jsr	checkTakeGem
		jsr	checkAxeHitWalker
		jsr	updateWalkers
		jsr	checkAxeHitWalker
		jsr	updateBurrower
		jsr	checkWalkerHit
		jsr	checkBurrowerHit
		jsr	removeOffShots
		jsr	updateFire
		jsr	checkOpenTop
		jsr	updateGuard
		jsr	checkRetakeGem
		jsr	checkPassage
		jsr	checkOfferGem
		jsr	updateSplash
		jsr	checkSplash
		jsr	checkFire
		jsr	updateFire
		jsr	checkTakeKey
		jsr	checkBonus
		jsr	checkTakeBonus
		jsr	checkDoor
		jsr	checkOpenDoor
		jsr	checkShots
		lda	#$06
		sec
		sbc	itemsLeft
		sec
		sbc	itemsDone
		tay
		bpl	:+
		iny
:		lda	speed,y
		jsr	utils::wait
		rts

;
; the portal bars blink (EORed each frame); the top one stays on once the
; player got to the top (topOpen)
;
updatePortalBars
		ldx	topOpen
		bne	La12a
		ldx	#$25
		ldy	#$17
		lda	#SHAPE_BAR
		jsr	spritelib::drawSprite
		lda	topBarOn
		eor	#$01
		sta	topBarOn
La12a		ldx	#$05
		ldy	#$3f
		lda	#SHAPE_BAR
		jsr	spritelib::drawSprite
		ldx	#$84
		ldy	#$3f
		lda	#SHAPE_BAR
		jsr	spritelib::drawSprite
		ldx	#$84
		ldy	#$5d
		lda	#SHAPE_BAR
		jsr	spritelib::drawSprite
La145		rts

;
; the fire flickers every 8..15 frames (fireFrame); 6 frames before, it
; burns: it hums and its 2 halves swap
;
updateFire	ldx	fireOn
		beq	La145
		dec	fireTimer
		beq	fireFlicker
		ldx	fireTimer
		cpx	#$06
		beq	La15a
		bcc	fireBurns
		rts

La15a		jsr	drawFireA
		rts

fireFlicker	jsr	drawFireB
		jsr	utils::random
		and	#$07
		adc	#$08
		sta	fireTimer
		lda	fireFrame
		eor	#$02
		sta	fireFrame
		rts

fireBurns	ldy	#$02
		jsr	soundlib::L0ae6
		ldx	fireTimer
		txa
		ror
		bcc	:+
		jsr	drawFireA
		jsr	drawFireB
		rts

:		jsr	drawFireB
		jsr	drawFireA
		rts

drawFireA	ldx	#$14
		ldy	#$14
		lda	#SHAPE_FIRE
		clc
		adc	fireFrame
		jsr	spritelib::drawSprite
		rts

drawFireB	ldx	#$14
		ldy	#$14
		lda	#SHAPE_FIRE + 1
		clc
		adc	fireFrame
		jsr	spritelib::drawSprite
		rts

;
; portals, until the player got to the top (topOpen):
; right of the middle floor <-> top, left of the middle floor <-> right of
; the lower one
;
checkPortals	ldx	topOpen
		bne	La1b2
		jsr	portalPlayer
La1b2		rts

portalPlayer	jsr	topPortals
		jsr	lowPortals
		rts

topPortals	jsr	portalMiddleToTop
		jsr	portalTopToMiddle
		rts

lowPortals	jsr	portalMiddleToLow
		jsr	portalLowToMiddle
		rts

portalMiddleToTop
		ldy	globals::spriteY
		cpy	#$41
		bne	La1e6
		ldx	globals::spriteX
		cpx	#$83
		bcc	La1e6
		jsr	drawPlayer
		ldx	#$19
		stx	globals::spriteY
		ldx	#$25
		stx	globals::spriteX
		jsr	drawPlayer
La1e6		rts

portalTopToMiddle
		ldy	globals::spriteY
		cpy	#$19
		bne	La1e6
		ldx	globals::spriteX
		cpx	#$24
		bcs	La1e6
		jsr	drawPlayer
		ldx	#$41
		stx	globals::spriteY
		ldx	#$82
		stx	globals::spriteX
		jsr	drawPlayer
		rts

portalMiddleToLow
		ldy	globals::spriteY
		cpy	#$41
		bne	La224
		ldx	globals::spriteX
		cpx	#$06
		bcs	La224
		jsr	drawPlayer
		ldx	#$5f
		stx	globals::spriteY
		ldx	#$82
		stx	globals::spriteX
		jsr	drawPlayer
La224		rts

portalLowToMiddle
		ldy	globals::spriteY
		cpy	#$5f
		bne	La224
		ldx	globals::spriteX
		cpx	#$83
		bcc	La224
		jsr	drawPlayer
		ldx	#$41
		stx	globals::spriteY
		ldx	#$07
		stx	globals::spriteX
		jsr	drawPlayer
		rts

drawPlayer	ldx	globals::spriteX
		ldy	globals::spriteY
		lda	globals::spriteID
		jsr	spritelib::drawSpriteM
		rts

;
; every releaseWait frames, the gem on top of the pile turns into a walker
;
updateRelease	ldx	itemsLeft
		beq	La25b
		dec	releaseWait
		beq	releaseWalker
La25b		rts

releaseWalker	ldx	itemsLeft
		dex
		lda	releaseDelays,x
		sta	releaseWait
		jsr	drawTopGem
		jsr	newWalker
		dec	itemsLeft
		rts

; EOR the gem on top of the pile
drawTopGem	ldx	itemsLeft
		lda	itemY-1,x
		tay
		lda	itemX-1,x
		tax
		lda	#SHAPE_GEM
		jsr	spritelib::drawSprite
		rts

;
; the player takes the gem on top of the pile (bottom left), if not
; carrying one already
;
checkTakeGem	ldx	globals::assetGemCnt
		bne	La25b
		ldx	itemsLeft
		beq	La25b
		ldx	globals::spriteY
		cpx	#$90
		bcc	La25b
		cpx	#$c0
		bcs	La25b
		ldx	globals::spriteX
		cpx	#$10
		bcs	La25b
		jsr	drawTopGem
		dec	itemsLeft
		ldx	#ITEM_GEM
		jsr	drawInventoryItem
		inc	globals::assetGemCnt
		inc	itemsDone
		jsr	game1::scoreAdd100
		jsr	game1::scoreAdd100
		jsr	soundlib::L0ab6
		lda	itemsDone
		cmp	#$06
		bne	La2c1
		jsr	openTopDoor
La2c1		rts

;
; EOR item X's icon on the status line
;
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

;
; walker itemsLeft-1 appears on the middle floor (Y $3D), at a random X
; away from the others, going a random way
;
newWalker	jsr	randomWalkerX
		ldx	itemsLeft
		dex
		sta	walkerX,x
		lda	#$3d
		sta	walkerY,x
		jsr	utils::random
		bmi	La2f3
		lda	#SHAPE_WALKER_R
		sta	walkerShape,x
		lda	#$02
		sta	walkerDX,x
		jmp	La2fd

La2f3		lda	#SHAPE_WALKER_L
		sta	walkerShape,x
		lda	#$fe
		sta	walkerDX,x
La2fd		stx	walker
		jsr	drawWalker
		rts

drawWalker	ldx	walker
		lda	walkerY,x
		tay
		lda	walkerX,x
		sta	globals::L033B
		lda	walkerShape,x
		ldx	globals::L033B
		jsr	spritelib::drawSpriteM
		rts

;
; walkers 5 to 0: step, go through the portals, turn around, shoot
;
updateWalkers	ldx	#$06
		stx	walker
nextWalker	dec	walker
		bmi	La378
		ldx	walker
		lda	walkerDX,x
		beq	nextWalker
		lda	walkerState,x
		bmi	La352
		jsr	drawWalker
		ldx	walker
		lda	walkerX,x
		clc
		adc	walkerDX,x
		sta	walkerX,x
		lda	walkerDX,x
		bmi	La355
		lda	walkerShape,x
		eor	#$07
		sta	walkerShape,x
		jmp	La35d

La352		jmp	walkerDying

La355		lda	walkerShape,x
		eor	#$03
		sta	walkerShape,x
La35d		jsr	walkerPortals
		jsr	walkerTurn
		jsr	drawWalker
		jsr	updateShot
		jmp	nextWalker

; walker X takes the portals like the player (on Y $15 / $3D / $5B)
walkerPortals	jsr	walkerTopToMiddle
		jsr	walkerMiddleToTop
		jsr	walkerMiddleToLow
		jsr	walkerLowToMiddle
La378		rts

walkerTopToMiddle
		lda	walkerY,x
		cmp	#$15
		bne	La391
		lda	walkerX,x
		cmp	#$28
		bcs	La391
		lda	#$78
		sta	walkerX,x
		lda	#$3d
		sta	walkerY,x
La391		rts

walkerMiddleToTop
		lda	walkerY,x
		cmp	#$3d
		bne	La391
		lda	walkerX,x
		cmp	#$79
		bcc	La391
		lda	#$29
		sta	walkerX,x
		lda	#$15
		sta	walkerY,x
		rts

walkerMiddleToLow
		lda	walkerY,x
		cmp	#$3d
		bne	La391
		lda	walkerX,x
		cmp	#$08
		bcs	La391
		lda	#$78
		sta	walkerX,x
		lda	#$5b
		sta	walkerY,x
		rts

walkerLowToMiddle
		lda	walkerY,x
		cmp	#$5b
		bne	La391
		lda	walkerX,x
		cmp	#$79
		bcc	La391
		lda	#$09
		sta	walkerX,x
		lda	#$3d
		sta	walkerY,x
		rts

;
; walker X turns around: at random (4 chances in 256), when it walks into a
; lower walker going the same way on the same floor, and at the ends of the
; top floor (X >= $40) and of the lower one (X < $30).
; walker 0 compares itself with walkerDX+$FF.. (Y = $FF): as in the original
;
walkerTurn	jsr	utils::random
		cmp	#$04
		bcc	turnWalker
		txa
		tay
		dey
La3e7		lda	walkerDX,x
		cmp	walkerDX,y
		bne	La40a
		lda	walkerY,x
		cmp	walkerY,y
		bne	La40a
		lda	walkerX,x
		sec
		sbc	#$03
		cmp	walkerX,y
		bcs	La40a
		clc
		adc	#$06
		cmp	walkerX,y
		bcs	turnWalker
La40a		dey
		bpl	La3e7
		lda	walkerY,x
		cmp	#$15
		beq	La419
		cmp	#$5b
		beq	La421
		rts

La419		lda	walkerX,x
		cmp	#$40
		bcs	turnWalker
		rts

La421		lda	walkerX,x
		cmp	#$30
		bcc	turnWalker
		rts

turnWalker	lda	walkerDX,x
		bmi	La436
		lda	#SHAPE_WALKER_L
		sta	walkerShape,x
		jmp	La43b

La436		lda	#SHAPE_WALKER_R
		sta	walkerShape,x
La43b		lda	walkerDX,x
		eor	#$ff
		clc
		adc	#$01
		sta	walkerDX,x
		rts

;
; the walker's shot: shotTime counts down to the shot, then the shot flies
; for 18 frames ($FF down to $ED), then a new countdown (2..33)
;
updateShot	ldx	walker
		lda	shotTime,x
		bmi	moveShot
		dec	shotTime,x
		bmi	fireShot
		rts

fireShot	lda	walkerDX,x
		bmi	La470
		lda	walkerX,x
		clc
		adc	#$0a
		sta	shotX,x
		lda	#SHAPE_SHOT_R
		sta	shotShape,x
		lda	#$03
		sta	shotDX,x
		jmp	La483

La470		lda	walkerX,x
		sec
		sbc	#$06
		sta	shotX,x
		lda	#SHAPE_SHOT_L
		sta	shotShape,x
		lda	#$fd
		sta	shotDX,x
La483		lda	walkerY,x
		clc
		adc	#$06
		sta	shotY,x
		jsr	drawShot
		jsr	soundlib::L0af8
		ldx	walker
		rts

drawShot	ldx	walker
		lda	shotY,x
		tay
		lda	shotX,x
		sta	globals::L033B
		lda	shotShape,x
		ldx	globals::L033B
		jsr	spritelib::drawSpriteM
		rts

moveShot	jsr	drawShot
		ldx	walker
		lda	shotX,x
		clc
		adc	shotDX,x
		sta	shotX,x
		dec	shotTime,x
		lda	shotTime,x
		cmp	#$ed
		beq	La4cb
		jsr	drawShot
		rts

La4cb		jsr	utils::random
		and	#$1f
		clc
		adc	#$02
		sta	shotTime,x
		rts

;
; burrower: walks between X $32 and $81; at a hole ($46 / $61 / $79) it goes
; into the ground ($49 up to $4D), comes out of a random hole ($4D down to
; $49) going a random way
;
updateBurrower	ldy	burrowerState
		beq	walkBurrower
		bpl	comeOut
		jsr	drawBurrower
		jsr	animBurrower
		ldy	burrowerShape
		cpy	#SHAPE_BURROWER_END
		bne	La4ef
		jsr	moveToHole
		rts

La4ef		jsr	drawBurrower
		rts

comeOut		jsr	drawBurrower
		jsr	animBurrower
		jsr	drawBurrower
		lda	burrowerShape
		cmp	#SHAPE_BURROWER
		bne	La508
		ldy	#$00
		sty	burrowerState
La508		rts

walkBurrower	jsr	drawBurrower
		lda	burrowerX
		clc
		adc	burrowerDX
		sta	burrowerX
		jsr	burrowerStep
		jsr	drawBurrower
		jsr	burrowerBounce
		ldy	burrowerX
		cpy	#$79
		beq	La52f
		cpy	#$61
		beq	La52f
		cpy	#$46
		beq	La52f
		rts

La52f		ldx	#$ff
		stx	burrowerState
		ldx	#$01
		stx	burrowerAnim
		rts

drawBurrower	jsr	toggleAxeNearBurrower
		jsr	togglePlayerNearBurrower
		ldx	burrowerShape
		lda	burrowerY
		clc
		adc	burrowerYOfs - SHAPE_BURROWER,x
		tay
		txa
		ldx	burrowerX
		jsr	spritelib::drawPlain
		jsr	togglePlayerNearBurrower
		jsr	toggleAxeNearBurrower
		rts

animBurrower	ldx	burrowerAnim
		bpl	La562
		dec	burrowerShape
La561		rts

La562		inc	burrowerShape
		ldx	burrowerShape
		cpx	#SHAPE_BURROWER_END + 1
		bne	La561
		ldx	#$ff
		stx	burrowerAnim
		jmp	animBurrower

moveToHole	ldx	#$01
		stx	burrowerState
		ldx	#$ff
		stx	burrowerAnim
		jsr	utils::random
		cmp	#$00
		bpl	La58d
		ldx	#$ff
		stx	burrowerDX
		jmp	La592

La58d		ldx	#$01
		stx	burrowerDX
La592		ldx	#SHAPE_BURROWER_IN
		stx	burrowerShape
		jsr	randomHole
		jsr	drawBurrower
		rts

burrowerStep	lda	burrowerShape
		eor	#$03
		sta	burrowerShape
		rts

burrowerBounce	ldx	burrowerX
		cpx	#$81
		beq	La5b3
		cpx	#$32
		beq	La5b3
		rts

La5b3		lda	burrowerDX
		eor	#$ff
		clc
		adc	#$01
		sta	burrowerDX
		rts

randomHole	jsr	utils::random
		and	#$03
		tax
		beq	La5d0
		dex
		beq	La5d6
		ldx	#$61
		stx	burrowerX
		rts

La5d0		ldx	#$46
		stx	burrowerX
		rts

La5d6		ldx	#$79
		stx	burrowerX
		rts

;
; walker hit by the axe: blinks between its dying and walking shapes while
; walkerState counts up from $F8, then its slot is freed
;
walkerDying	jsr	drawWalker
		ldx	walker
		lda	walkerState,x
		lsr
		bcs	La5fd
		lda	walkerDX,x
		bmi	La5f5
		lda	#SHAPE_WALKER_DIE_R
		sta	walkerShape,x
		jmp	La60f

La5f5		lda	#SHAPE_WALKER_DIE_L
		sta	walkerShape,x
		jmp	La60f

La5fd		lda	walkerDX,x
		bmi	La60a
		lda	#SHAPE_WALKER_R
		sta	walkerShape,x
		jmp	La60f

La60a		lda	#SHAPE_WALKER_L
		sta	walkerShape,x
La60f		jsr	drawWalker
		ldx	walker
		inc	walkerState,x
		beq	La61d
		jmp	nextWalker

La61d		lda	#$00
		sta	walkerDX,x
		sta	walkerState,x
		jsr	drawWalker
		jmp	nextWalker

;
; the axe (flying) hits a walker: it dies, its shot goes, one more done
;
La62b		rts

checkAxeHitWalker
		ldx	globals::playerAxeState
		beq	La62b
		bmi	La62b
		ldx	#$06
La635		dex
		bmi	La62b
		lda	walkerDX,x
		beq	La635
		lda	walkerState,x
		bmi	La635
		lda	walkerX,x
		sec
		sbc	#$08
		cmp	globals::axeXpos
		bcs	La635
		clc
		adc	#$16
		cmp	globals::axeXpos
		bcc	La635
		lda	walkerY,x
		cmp	globals::axeYpos
		bcs	La635
		clc
		adc	#$10
		cmp	globals::axeYpos
		bcc	La635
		lda	#$f8
		sta	walkerState,x
		jsr	removeShot
		jsr	game1::scoreAdd250
		jsr	soundlib::L0b06
		inc	itemsDone
		lda	itemsDone
		cmp	#$06
		bne	La680
		jsr	openTopDoor
La680		jmp	La635

drawAxe		ldx	globals::axeXpos
		ldy	globals::axeYpos
		lda	globals::axeSpriteID
		jsr	spritelib::drawSpriteM
		rts

; shot X, if flying: erase it, new countdown (2..33)
removeShot	stx	shot
		lda	shotTime,x
		bpl	La6ba
		lda	shotY,x
		tay
		lda	shotShape,x
		sta	globals::L033B
		lda	shotX,x
		tax
		lda	globals::L033B
		jsr	spritelib::drawSpriteM
		ldx	shot
		jsr	utils::random
		and	#$1f
		clc
		adc	#$02
		sta	shotTime,x
La6ba		rts

; shots end at the screen's sides and at the top floor's walls (X $30-$4F)
removeOffShots	ldx	#$06
La6bd		dex
		bmi	La6ba
		lda	shotTime,x
		bpl	La6bd
		lda	shotX,x
		cmp	#$06
		bcc	La6e2
		cmp	#$80
		bcs	La6e2
		lda	shotY,x
		cmp	#$20
		bcs	La6bd
		lda	shotX,x
		cmp	#$30
		bcc	La6e2
		cmp	#$50
		bcc	La6bd
La6e2		jsr	removeShot
		jmp	La6bd

;
; a walker (alive) touching the player kills the player
;
checkWalkerHit	ldx	globals::playerDeadAnimIdx
		bne	La72d
		ldx	#$06
		stx	walker
La6f2		dec	walker
		bmi	La72d
		ldx	walker
		lda	walkerDX,x
		beq	La6f2
		lda	walkerState,x
		bmi	La6f2
		lda	walkerX,x
		sec
		sbc	#$05
		cmp	globals::spriteX
		bcs	La6f2
		clc
		adc	#$0f
		cmp	globals::spriteX
		bcc	La6f2
		lda	walkerY,x
		sec
		sbc	#$10
		cmp	globals::spriteY
		bcs	La6f2
		clc
		adc	#$1e
		cmp	globals::spriteY
		bcc	La6f2
		jsr	killPlayer
La72d		rts

killPlayer	ldx	globals::playerDeadAnimIdx
		bne	La72d
		ldx	#$01
		stx	globals::playerDeadAnimIdx
		jsr	drawPlayer
		ldx	#SHAPE_DEAD
		stx	globals::spriteID
		jsr	drawPlayer
		rts

;
; the burrower kills the player on touch, and takes the top back
;
checkBurrowerHit
		ldx	globals::playerDeadAnimIdx
		bne	La72d
		jsr	isOnBurrower
		bcc	La759
		jsr	killPlayer
		ldx	topOpen
		beq	La759
		jsr	closeTop
La759		rts

; carry set: the player is close to the burrower (drawn over it)
isNearBurrower	lda	burrowerX
		sec
		sbc	#$08
		cmp	globals::spriteX
		bcs	La77f
		clc
		adc	#$13
		cmp	globals::spriteX
		bcc	La77f
		lda	burrowerY
		sec
		sbc	#$14
		cmp	globals::spriteY
		bcs	La77f
		clc
		adc	#$2a
		cmp	globals::spriteY
		rts

La77f		clc
La780		rts

; A = a random X ($05-$84) away from the walkers above itemsLeft-1 that are
; on the middle floor (it goes into the RND state too)
randomWalkerX	jsr	utils::random
		and	#$7f
		adc	#$05
		sta	globals::rndSeed2
		ldx	itemsLeft
		dex
La78f		cpx	#$05
		beq	La780
		inx
		jsr	isNearWalker
		bcs	randomWalkerX
		jmp	La78f

; carry set: walker X is on the middle floor, at less than 12 from X = A
isNearWalker	sta	globals::L033B
		lda	walkerY,x
		cmp	#$3d
		bne	La7b9
		lda	walkerX,x
		sec
		sbc	#$0c
		cmp	globals::L033B
		bcs	La7b9
		clc
		adc	#$18
		cmp	globals::L033B
		bcs	La7be
La7b9		clc
		lda	globals::L033B
		rts

La7be		sec
		lda	globals::L033B
		rts

;
; the 6 done, the player gets to the top (Y < $20): the top portal stops
; (its bar stays on), the passage at X $53 opens and the guard shows
;
checkOpenTop	ldx	itemsDone
		cpx	#$06
		bne	La7de
		ldx	topOpen
		bne	La7de
		ldx	globals::playerDeadAnimIdx
		bne	La7de
		ldx	globals::spriteY
		cpx	#$20
		bcs	La7de
		jsr	openTop
La7de		rts

openTop		inc	topOpen
		ldx	topBarOn
		bne	La7f0
		ldx	#$25
		ldy	#$17
		lda	#SHAPE_BAR
		jsr	spritelib::drawSprite
La7f0		lda	#SHAPE_BURROWER
		sta	guardShape
		jsr	drawGuard
		rts

;
; while topOpen: the guard (burrower shapes) moves at ($4A,$58), going back
; down (Y >= $40) kills the player and closes the top
;
updateGuard	ldx	topOpen
		beq	La7de
		jsr	animGuard
		jsr	checkLeaveTop
		rts

animGuard	jsr	drawGuard
		lda	guardShape
		eor	#$03
		sta	guardShape
		jsr	drawGuard
		rts

drawGuard	ldx	#$4a
		ldy	#$58
		lda	guardShape
		jsr	spritelib::drawPlain
		rts

checkLeaveTop	ldx	globals::spriteY
		cpx	#$40
		bcc	La82c
		jsr	killPlayer
		jsr	closeTop
La82c		rts

; also called by checkFire when the top isn't open: the guard is drawn then
closeTop	jsr	drawGuard
		ldx	#$00
		stx	topOpen
		ldx	gemReturned
		bne	La82c
		jsr	drawPileGem
		inc	gemReturned
		ldx	#$01
		stx	topBarOn
		rts

;
; the gem put back on the pile by closeTop can be taken again
;
checkRetakeGem	ldx	gemReturned
		beq	La879
		ldx	globals::assetGemCnt
		bne	La879
		ldx	globals::spriteY
		cpx	#$90
		bcc	La879
		cpx	#$c0
		bcs	La879
		ldx	globals::spriteX
		cpx	#$10
		bcs	La879
		jsr	drawPileGem
		ldx	#ITEM_GEM
		jsr	drawInventoryItem
		inc	globals::assetGemCnt
		dec	gemReturned
		jsr	game1::scoreAdd100
		jsr	game1::scoreAdd100
		jsr	soundlib::L0ab6
La879		rts

; EOR the gem at the bottom of the pile
drawPileGem	ldx	#$01
		stx	itemsLeft
		jsr	drawTopGem
		dec	itemsLeft
		rts

;
; until the top is open, the player can't go past X $52 on the top floor
;
checkPassage	ldx	topOpen
		bne	La8ac
		ldx	globals::spriteX
		cpx	#$53
		bcc	La8ac
		ldx	globals::spriteY
		cpx	#$20
		bcs	La8ac
		ldx	#$00
		stx	globals::playerXspeed
		stx	globals::playerYspeed
		jsr	drawPlayer
		ldx	#$52
		stx	globals::spriteX
		jsr	drawPlayer
La8ac		rts

;
; the player leaves the gem at ($6D,$27), top right: the fire goes out
;
checkOfferGem	ldx	fireOn
		beq	La8ac
		ldx	globals::assetGemCnt
		beq	La8ac
		ldx	globals::spriteX
		cpx	#$6a
		bcc	La8ac
		cpx	#$70
		bcs	La8ac
		ldx	globals::spriteY
		cpx	#$2a
		bcs	La8ac
		cpx	#$20
		bcc	La8ac
		ldx	#ITEM_GEM
		jsr	drawInventoryItem
		jsr	drawOfferedGem
		jsr	game1::scoreAdd250
		jsr	game1::scoreAdd250
		jsr	soundlib::L0ac5
		ldx	#$00
		stx	globals::assetGemCnt
		dec	fireOn
		ldx	fireTimer
		cpx	#$07
		bcs	La8ac
		lda	fireTimer
		ror
		bcc	La8f7
		jsr	drawFireB
		rts

La8f7		jsr	drawFireA
		rts

drawOfferedGem	ldx	#$6d
		ldy	#$27
		lda	#SHAPE_GEM
		jsr	spritelib::drawSpriteM
		rts

;
; the player falls in the water (X >= $42, Y >= $A0): a splash, 8 frames
;
checkSplash	ldx	globals::playerDeadAnimIdx
		bne	La930
		ldx	globals::spriteX
		cpx	#$42
		bcc	La930
		ldy	globals::spriteY
		cpy	#$a0
		bcc	La930
		stx	splashX
		ldy	#$97
		sty	splashY
		jsr	drawPlayer
		ldx	#$01
		stx	splashFrame
		jsr	drawSplash
		ldx	#$08
		stx	globals::playerDeadAnimIdx
La930		rts

drawSplash	ldx	splashFrame
		lda	splashShapes-1,x
		ldx	splashX
		ldy	splashY
		jsr	spritelib::drawPlain
		rts

updateSplash	ldx	splashFrame
		beq	La930
		jsr	drawSplash
		inc	splashFrame
		ldx	splashFrame
		cpx	#$09
		beq	La957
		jsr	drawSplash
		rts

La957		ldx	#$00
		stx	splashFrame
		rts

;
; the fire burns the player (X $12-$16, Y < $28) while fireTimer < 7
;
checkFire	ldx	globals::playerDeadAnimIdx
		bne	La930
		ldx	fireTimer
		cpx	#$07
		bcs	La930
		ldx	fireOn
		beq	La930
		ldx	globals::spriteX
		cpx	#$12
		bcc	La930
		cpx	#$17
		bcs	La930
		ldy	globals::spriteY
		cpy	#$28
		bcs	La930
		jsr	killPlayer
		jsr	closeTop
		rts

;
; the key, behind the fire at ($05,$1F)
;
checkTakeKey	ldx	globals::assetKeyCnt
		bne	La9b1
		ldy	globals::spriteY
		cpy	#$20
		bcs	La9b1
		ldx	globals::spriteX
		cpx	#$08
		bcs	La9b1
		inc	globals::assetKeyCnt
		ldx	#ITEM_KEY
		jsr	drawInventoryItem
		ldx	#$05
		ldy	#$1f
		lda	#SHAPE_KEY
		jsr	spritelib::drawSprite
		jsr	game1::scoreAdd100
		jsr	soundlib::L0a6e
La9b1		rts

;
; same as game1::drawDigit: EOR digit X of playerData on the status line
;
drawDigit	lda	globals::playerData,x
		tay
		lda	globals::L033C,x
		tax
		tya
		ldy	#$b9
		cmp	#$00
		bne	La9c3
		lda	#$0a
La9c3		jsr	spritelib::drawSprite
		rts

;
; one more axe, on the status line too (2 decimal digits)
;
addAxe		ldx	#AXES_LO
		jsr	drawDigit
		inc	globals::playerAxeCountLo
		ldx	globals::playerAxeCountLo
		cpx	#$0a
		beq	La9dc
		ldx	#AXES_LO
		jsr	drawDigit
		rts

La9dc		ldx	#$00
		stx	globals::playerAxeCountLo
		ldx	#AXES_LO
		jsr	drawDigit
		ldx	#AXES_HI
		jsr	drawDigit
		inc	globals::playerAxeCountHi
		ldx	#AXES_HI
		jsr	drawDigit
		rts

;
; the axe bonus at ($54,$9C) shows at random (8 chances in 256) while the
; player has fewer than 10 axes
;
checkBonus	ldx	bonusOn
		bne	Laa0b
		ldx	globals::playerAxeCountHi
		bne	Laa0b
		jsr	utils::random
		cmp	#$08
		bcs	Laa0b
		inc	bonusOn
		jsr	drawBonus
Laa0b		rts

checkTakeBonus	ldx	bonusOn
		beq	Laa0b
		lda	globals::spriteX
		sec
		sbc	#$04
		cmp	#$54
		bcs	Laa0b
		clc
		adc	#$0b
		cmp	#$54
		bcc	Laa0b
		lda	globals::spriteY
		cmp	#$84
		bcc	Laa0b
		dec	bonusOn
		jsr	addAxe
		jsr	game1::scoreAdd50
		jsr	soundlib::L0ad7
drawBonus	ldx	#$54
		ldy	#$9c
		lda	#SHAPE_AXE
		jsr	spritelib::drawPlain
		rts

;
; the door at the top right: the player can't go past X $7D until the key
; opened it
;
checkDoor	ldx	doorOpen
		bne	Laa65
		ldx	globals::spriteX
		cpx	#$7e
		bcc	Laa65
		ldx	globals::spriteY
		cpx	#$2a
		bcs	Laa65
		ldx	#$00
		stx	globals::playerXspeed
		stx	globals::playerYspeed
		jsr	drawPlayer
		ldx	#$7d
		stx	globals::spriteX
		jsr	drawPlayer
Laa65		rts

checkOpenDoor	ldx	globals::assetKeyCnt
		beq	Laa65
		ldx	globals::spriteX
		cpx	#$7d
		bcc	Laa65
		ldx	globals::spriteY
		cpx	#$2a
		bcs	Laa65
		ldx	#$00
		stx	globals::assetKeyCnt
		inx
		jsr	drawInventoryItem
		ldx	#$83
		ldy	#$21
		lda	#SHAPE_DOOR
		jsr	spritelib::drawSprite
		inc	doorOpen
		jsr	game1::scoreAdd250
		jsr	soundlib::L0a7d
		rts

; the 6 done: the door at ($58,$17), top middle, opens
openTopDoor	ldx	#$58
		ldy	#$17
		lda	#SHAPE_DOOR
		jsr	spritelib::drawSprite
		jsr	soundlib::L0a7d
		rts

; EOR the axe off / on if it's close to the burrower (drawn over it)
toggleAxeNearBurrower
		lda	burrowerX
		sec
		sbc	#$07
		cmp	globals::axeXpos
		bcs	Laaf7
		clc
		adc	#$10
		cmp	globals::axeXpos
		bcc	Laaf7
		lda	burrowerY
		sec
		sbc	#$14
		cmp	globals::axeYpos
		bcs	Laaf7
		clc
		adc	#$24
		cmp	globals::axeYpos
		bcc	Laaf7
		jsr	drawAxe
Laaf7		rts

;
; shots 5 to 0 against the axe and the player
;
checkShots	ldx	#$06
		stx	walker
Laafd		dec	walker
		bmi	Laaf7
		ldx	walker
		jsr	checkAxeHitShot
		jsr	checkShotHit
		jmp	Laafd

; the flying axe stops a shot: both go
checkAxeHitShot	lda	shotTime,x
		bpl	Laaf7
		ldy	globals::playerAxeState
		dey
		bmi	Laaf7
		lda	shotX,x
		sec
		sbc	#$07
		cmp	globals::axeXpos
		bcs	Laaf7
		clc
		adc	#$14
		cmp	globals::axeXpos
		bcc	Laaf7
		lda	shotY,x
		sec
		sbc	#$06
		cmp	globals::axeYpos
		bcs	Laaf7
		clc
		adc	#$0b
		cmp	globals::axeYpos
		bcc	Laaf7
		jsr	removeShot
		jsr	drawAxe
		ldx	#$00
		stx	globals::playerAxeState
		stx	globals::playerAxeAnim
		stx	globals::axeXpos
		stx	globals::axeYpos
Lab53		rts

; a shot kills the player
checkShotHit	lda	shotTime,x
		bpl	Lab53
		ldy	globals::playerDeadAnimIdx
		bne	Lab53
		lda	shotX,x
		sec
		sbc	#$06
		cmp	globals::spriteX
		bcs	Lab53
		clc
		adc	#$0a
		cmp	globals::spriteX
		bcc	Lab53
		lda	shotY,x
		sec
		sbc	#$0f
		cmp	globals::spriteY
		bcs	Lab53
		clc
		adc	#$16
		cmp	globals::spriteY
		bcc	Lab53
		jsr	removeShot
		jsr	killPlayer
		rts

; carry set: the player touches the burrower
isOnBurrower	lda	burrowerX
		sec
		sbc	#$03
		cmp	globals::spriteX
		bcs	Labb0
		clc
		adc	#$06
		cmp	globals::spriteX
		bcc	Labb0
		lda	burrowerY
		sec
		sbc	#$08
		cmp	globals::spriteY
		bcs	Labb0
		clc
		adc	#$14
		cmp	globals::spriteY
		rts

Labb0		clc
		rts

; EOR the player off / on if close to the burrower, unless sinking / splashing
togglePlayerNearBurrower
		ldx	globals::playerDeadAnimIdx
		cpx	#$08
		bcs	Labc1
		jsr	isNearBurrower
		bcc	Labc1
		jsr	drawPlayer
Labc1		rts

; $ABC2-$ABFF: slack
