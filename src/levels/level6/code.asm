;
; level 6 code, disk chunk c4 ($A000-$ABFF)
; levelTick, at $A000, is called once per frame by the game's main loop.
;
; the room: 4 floors (Y $2A, $52, $7C, $A0) linked by ladders, a ledge at
; the top left (Y $02), a centre machine (X $39-$45, Y $3B-$5E) that kills
; on touch, with a gate, a riser, lamps and blinkers that run on the clock,
; and a chandelier hanging above it.
; - monsters (up to 6) fly out of the machine to the left or right of the
;   floor $2A, then walk and take the ladders at random; they kill on touch,
;   except while the player rides the lower platform;
; - two bars move left and right: one under the floor $52 (Y $69), the
;   other a moving piece of the floor $7C (Y $8B); when they line up, a
;   lightning bolt strikes between them. The lower one carries the player
;   (ledge 0 follows it) and kills the monsters it runs into;
; - the mover flies in from below the screen along one of 8 scripts and
;   kills on touch; shot with the axe, it gives 400 points and adds a rung
;   to the ladder at X $23, the 6th completes it from the floor $2A up to
;   the top left ledge;
; - the flame at ($84,$2C) guards the exit at the top right;
; - an axe bonus shows at random at the bottom.
; the axe thrown at the chandelier's chain (X >= $41, Y < $0B) from the
; top left ledge drops it on the machine: the monsters die, everything
; stops, and walking to the top right (Y $2B, X >= $83) leaves the level
; (checkLeave puts the player on the c5 exit, $C0,$C0).
;

SHAPE_AXE	.equ	$1E			; axe bonus
SHAPE_DEAD	.equ	$19			; player killed
SHAPE_LEAVE	.equ	$5F			; player leaving, EOR $4F: core shape $10

SHAPE_MOVER_HIT	.equ	$43			; first frame of moverHitShapes
SHAPE_BLINK1	.equ	$47
SHAPE_BLINK2	.equ	$48
SHAPE_LAMP	.equ	$49
SHAPE_RUNG	.equ	$4A
SHAPE_GATE1	.equ	$4B			; + gateFrame
SHAPE_GATE2	.equ	$4D			; + gateFrame
SHAPE_LOWER_PLAT	.equ	$4F
SHAPE_UPPER_PLAT	.equ	$50
SHAPE_BOLT	.equ	$55			; + boltFrame
SHAPE_MONSTER	.equ	$57			; walking $57 / $58, dying $59 / $5A
SHAPE_MONSTER2	.equ	$58
SHAPE_FLAME1	.equ	$5B			; + flameFrame
SHAPE_FLAME2	.equ	$5C			; + flameFrame

AXES_HI		.equ	globals::playerAxeCountHi - globals::playerData
AXES_LO		.equ	globals::playerAxeCountLo - globals::playerData

;
; once per frame; the more monsters are out, the shorter the wait
;
levelTick	jsr	updateFlame
		jsr	updateMonsters
		jsr	updateBolt
		jsr	updateDecor
		jsr	tickClock
		jsr	updateBlinkers
		jsr	updateLamps
		jsr	toggleGate
		jsr	animateGate
		jsr	maybeStartMover
		jsr	updateMover
		jsr	updateFlame
		jsr	updateBolt
		jsr	updatePlatforms
		jsr	endBolt
		jsr	lowerPlatform
		jsr	maybeSpawn
		jsr	checkLeave
		jsr	checkAxeHitMover
		jsr	checkPlatformHit
		jsr	checkMoverHit
		jsr	checkExitFlame
		jsr	checkMachine
		jsr	updateMonsters
		jsr	checkAxeHitChain
		jsr	updateFlame
		jsr	checkBonus
		jsr	checkTakeBonus
		jsr	checkBoltHit
		jsr	checkMonsterHit
		ldx	levelDone
		bne	La073
		ldx	#$00
		ldy	#$05
La063		lda	monsterState,y
		beq	La069
		inx
La069		dey
		bpl	La063
		lda	waitByMonsters,x
		jsr	utils::wait
		rts

La073		lda	#$90
		jsr	utils::wait
		rts

tickClock	inc	clock
		ldx	clock
		cpx	#$10
		bne	La088
		ldx	#$00
		stx	clock
La088		rts

; the blinkers under the machine: one at clock 3 / 11, the other at 7 / 15
updateBlinkers	ldx	levelDone
		bne	La088
		ldx	clock
		cpx	#$03
		beq	drawBlinker1
		cpx	#$0b
		beq	drawBlinker1
		cpx	#$07
		beq	drawBlinker2
		cpx	#$0f
		beq	drawBlinker2
		rts

drawBlinker1	lda	#SHAPE_BLINK1
		ldx	#$3b
		ldy	#$5f
		jsr	spritelib::drawSprite
		rts

drawBlinker2	lda	#SHAPE_BLINK2
		ldx	#$42
		ldy	#$5f
		jsr	spritelib::drawSprite
		rts

; the riser goes up the machine with the clock: EOR the previous step off
; and this one on (clock 0: only step 0, 13: only step 12)
updateDecor	ldx	levelDone
		bne	La0d2
		ldx	clock
		beq	La0d3
		cpx	#$0e
		bcs	La0d2
		dex
		jsr	drawDecor
		ldx	clock
		cpx	#$0d
		beq	La0d2
		jsr	drawDecor
La0d2		rts

La0d3		ldx	#$00
		jsr	drawDecor
		rts

; step X of the riser
drawDecor	lda	decorShape,x
		pha
		lda	decorY,x
		tay
		lda	decorX,x
		tax
		pla
		jsr	spritelib::drawSprite
		rts

; the next of the 4 lamps lights up
updateLamps	ldx	levelDone
		bne	La107
		ldx	lamp
		jsr	drawLamp
		inc	lamp
		ldx	lamp
		cpx	#$05
		bne	La104
		ldx	#$01
		stx	lamp
La104		jsr	drawLamp
La107		rts

; lamp X (1..4) at X $3A + 4 * (X-1)
drawLamp	lda	#$3a
La10a		dex
		beq	La113
		clc
		adc	#$04
		jmp	La10a

La113		tax
		lda	#SHAPE_LAMP
		ldy	#$4e
		jsr	spritelib::drawSprite
		rts

;
; the flame at ($84,$2C), in front of the exit: 2 shapes, EORed in turn
; while flameTimer < 6 (flickering), then both for a random 8..15 frames
;
updateFlame	ldx	levelDone
		bne	La12f
		dec	flameTimer
		beq	La134
		ldx	flameTimer
		cpx	#$06
		beq	La130
		bcc	La14a
La12f		rts

La130		jsr	drawFlame1
		rts

La134		jsr	drawFlame2
		jsr	utils::random
		and	#$07
		adc	#$08
		sta	flameTimer
		lda	flameFrame
		eor	#$02
		sta	flameFrame
		rts

La14a		txa
		ror
		bcc	La155
		jsr	drawFlame1
		jsr	drawFlame2
		rts

La155		jsr	drawFlame2
		jsr	drawFlame1
		rts

drawFlame1	ldx	#$84
		ldy	#$2c
		lda	#SHAPE_FLAME1
		clc
		adc	flameFrame
		jsr	spritelib::drawSprite
		rts

drawFlame2	ldx	#$84
		ldy	#$2c
		lda	#SHAPE_FLAME2
		clc
		adc	flameFrame
		jsr	spritelib::drawSprite
		rts

;
; the gate of the machine: drawn from clock 9 to 13, flickers (2 frames)
;
animateGate	ldx	levelDone
		bne	La1a0
		ldx	gateOn
		beq	La1a0
		jsr	drawGate1
		jsr	drawGate2
		jsr	drawGate3
		jsr	flipGateFrame
		jsr	drawGate1
		jsr	drawGate2
		jsr	drawGate3
		rts

flipGateFrame	lda	gateFrame
		eor	#$01
		sta	gateFrame
La1a0		rts

drawGate1	lda	#SHAPE_GATE1
		clc
		adc	gateFrame
		ldx	#$47
		ldy	#$47
		jsr	spritelib::drawSprite
		rts

drawGate2	lda	#SHAPE_GATE2
		clc
		adc	gateFrame
		ldx	#$37
		ldy	#$47
		jsr	spritelib::drawSprite
		rts

drawGate3	lda	#SHAPE_GATE1
		clc
		adc	gateFrame
		ldx	#$37
		ldy	#$5a
		jsr	spritelib::drawSprite
La1ca		rts

; draw the gate at clock 9, EOR it off at clock 13
toggleGate	ldx	levelDone
		bne	La1ca
		ldy	clock
		ldx	gateOn
		bne	La1dd
		cpy	#$09
		beq	La1e2
		rts

La1dd		cpy	#$0d
		beq	La1f4
		rts

La1e2		inc	gateOn
		ldx	#$00
		stx	gateFrame
		jsr	drawGate1
		jsr	drawGate2
		jsr	drawGate3
		rts

La1f4		dec	gateOn
		jsr	drawGate1
		jsr	drawGate2
		jsr	drawGate3
		rts

;
; the mover
;

; hit: shrinks in place (moverHitShapes), then is erased and a rung is added
moverShrink	cpx	#$05
		beq	moverGone
		lda	moverHitShapes-1,x
		sta	moverNewShape
		ldx	moverX
		stx	moverNewX
		ldx	moverY
		stx	moverNewY
		jsr	redrawMover
		inc	moverHit
		rts

moverGone	jsr	drawMover
		jsr	addRung
		ldx	#$00
		stx	moverOn
		stx	moverHit
		rts

updateMover	ldx	moverOn
		beq	La259
		ldx	moverHit
		bne	moverShrink
		dec	moverTime
		beq	moverNextStep
		ldx	moverShape
		stx	moverNewShape
moverMove	lda	moverX
		clc
		adc	moverDX
		sta	moverNewX
		lda	moverY
		clc
		adc	moverDY
		sta	moverNewY
		jsr	redrawMover
La259		rts

moverNextStep	inc	moverStep
		ldx	moverStep
		lda	moverScriptShape,x
		beq	La27d
		sta	moverNewShape
		lda	moverScriptDX,x
		sta	moverDX
		lda	moverScriptDY,x
		sta	moverDY
		lda	moverScriptTime,x
		sta	moverTime
		jmp	moverMove

; end of the script: gone
La27d		jsr	drawMover
		ldx	#$00
		stx	moverOn
		rts

; EOR the mover off, and on at moverNewX / Y / Shape
redrawMover	jsr	drawMover
		ldx	moverNewX
		stx	moverX
		ldy	moverNewY
		sty	moverY
		lda	moverNewShape
		sta	moverShape
		jsr	spritelib::drawSpriteM
		rts

; while the ladder isn't complete, a new mover half of the frames
maybeStartMover	ldx	moverOn
		bne	La2b2
		ldx	rung
		beq	La2b2
		jsr	utils::random
		ror
		bcs	La2b2
		jsr	startMover
La2b2		rts

; one of the 8 scripts at random, from ($64,$F6), below the screen
startMover	jsr	utils::random
		and	#$07
		tax
		lda	#$ff
La2bb		dex
		bmi	La2c4
		clc
		adc	#$20
		jmp	La2bb

La2c4		sta	moverStep
		ldx	#$64
		stx	moverX
		ldy	#$f6
		sty	moverY
		inc	moverOn
		jmp	moverNextStep

drawMover	ldx	moverX
		ldy	moverY
		lda	moverShape
		jsr	spritelib::drawSpriteM
		rts

;
; the two bars: the upper one (Y $69), the lower one (Y $8B, floor $7C)
;
updatePlatforms	ldx	levelDone
		bne	La2f2
		jsr	moveUpperPlat
		jsr	moveLowerPlat
		jsr	checkBoltStart
La2f2		rts

moveUpperPlat	jsr	drawUpperPlat
		lda	upperPlatX
		clc
		adc	upperPlatDX
		sta	upperPlatX
		jsr	drawUpperPlat
		ldx	upperPlatX
		cpx	#$1a
		beq	La30f
		cpx	#$7a
		beq	La30f
		rts

La30f		lda	upperPlatDX
		eor	#$ff
		clc
		adc	#$01
		sta	upperPlatDX
		rts

moveLowerPlat	jsr	drawLowerPlat
		lda	lowerPlatX
		clc
		adc	lowerPlatDX
		sta	lowerPlatX
		jsr	drawLowerPlat
		ldx	lowerPlatX
		cpx	#$14
		beq	La337
		cpx	#$7a
		beq	La337
		rts

La337		lda	lowerPlatDX
		eor	#$ff
		clc
		adc	#$01
		sta	lowerPlatDX
		rts

drawUpperPlat	lda	#SHAPE_UPPER_PLAT
		ldx	upperPlatX
		ldy	#$69
		jsr	spritelib::drawSpriteM
		rts

drawLowerPlat	lda	#SHAPE_LOWER_PLAT
		ldx	lowerPlatX
		ldy	#$8b
		jsr	spritelib::drawSpriteM
La358		rts

;
; the lightning bolt between the platforms: flickers, with a sound
;
updateBolt	ldx	levelDone
		bne	La358
		ldx	boltTimer
		beq	La358
		jsr	drawBolt
		lda	boltFrame
		eor	#$01
		sta	boltFrame
		jsr	drawBolt
		ldy	#$09
		jsr	soundlib::L0ae6
		rts

drawBolt	ldx	boltX
		inx
		ldy	#$6b
		lda	#SHAPE_BOLT
		clc
		adc	boltFrame
		jsr	spritelib::drawSpriteM
		rts

; the platforms line up (lowerPlatX - 2 < upperPlatX <= lowerPlatX + 2)
checkBoltStart	ldx	boltTimer
		bne	La3a2
		lda	lowerPlatX
		clc
		adc	#$02
		cmp	upperPlatX
		bcc	La3a2
		sec
		sbc	#$04
		cmp	upperPlatX
		bcs	La3a2
		jsr	startBolt
La3a2		rts

startBolt	ldx	#$02
		stx	boltTimer
		ldx	upperPlatX
		stx	boltX
		ldx	#$00
		stx	boltFrame
		jsr	drawBolt
		rts

endBolt		ldx	levelDone
		bne	La3c9
		ldx	boltTimer
		beq	La3c9
		dec	boltTimer
		bne	La3c9
		jsr	drawBolt
La3c9		rts

; ledge 0 follows the lower platform, which carries the player
lowerPlatform	ldx	levelDone
		bne	La3c9
		jsr	moveLedge
		jsr	ridePlatform
		rts

moveLedge	lda	lowerPlatX
		sec
		sbc	#$03
		sta	LAC00
		clc
		adc	#$09
		sta	LAC20
		rts

; the player on the platform (Y $7B, or $7D: lifted onto it) moves with it,
; unless climbing, jumping or dying
ridePlatform	ldx	globals::isClimbing
		bne	La439
		ldx	globals::L0314
		bne	La439
		ldx	globals::L0315
		bne	La439
		ldx	globals::isPlayerJumping
		bne	La439
		ldx	globals::playerDeadAnimIdx
		bne	La439
		ldx	globals::spriteY
		cpx	#$7b
		beq	La423
		cpx	#$7d
		bne	La439
		ldx	globals::spriteX
		cpx	LAC00
		bcc	La439
		cpx	LAC20
		bcs	La439
		jsr	drawPlayer
		dec	globals::spriteY
		dec	globals::spriteY
		jsr	drawPlayer
La423		jsr	drawPlayer
		lda	globals::spriteX
		clc
		adc	lowerPlatDX
		sta	globals::spriteX
		jsr	drawPlayer
		ldx	#$ff
		stx	onPlatform
		rts

La439		ldx	#$00
		stx	onPlatform
		rts

drawPlayer	ldx	globals::spriteX
		ldy	globals::spriteY
		lda	globals::spriteID
		jsr	spritelib::drawSpriteM
		rts

;
; the monsters
;

; a new monster at random (8 in 256), if none is flying out and a slot is
; free: to the left if the player is on the right (X >= $40), and
; the other way round, but a quarter of the time at random
maybeSpawn	ldx	levelDone
		bne	La463
		ldx	spawnStep
		bne	La463
		jsr	utils::random
		cmp	#$08
		bcs	La463
		jsr	takeFreeSlot
		jsr	startSpawn
La463		rts

startSpawn	ldx	spawnStep
		inx
		jsr	utils::random
		cmp	#$40
		bcs	La479
		ldy	globals::spriteX
		cpy	#$40
		bcs	La481
		jmp	La47c

La479		ror
		bcs	La481
La47c		txa
		clc
		adc	#$10
		tax
La481		stx	spawnStep
		jsr	drawSpawn
		rts

drawSpawn	ldx	spawnStep
		lda	spawnShape-1,x
		pha
		lda	spawnY-1,x
		tay
		lda	spawnX-1,x
		tax
		pla
		jsr	spritelib::drawSpriteM
		rts

updateMonsters	ldx	#$01
		stx	monster
La4a1		ldx	monster
		jsr	updateMonster
		inc	monster
		ldx	monster
		cpx	#$07
		bne	La4a1
		rts

; monster X (1..6)
updateMonster	lda	monsterState-1,x
		beq	La463
		bpl	monsterAlive
		jsr	drawSpawn
		inc	spawnStep
		ldx	spawnStep
		cpx	#$11
		beq	landLeft
		cpx	#$21
		beq	landRight
		jsr	drawSpawn
		rts

; out of the machine: walks from the end of the arc
landLeft	ldx	monster
		lda	#$ff
		sta	monsterDX-1,x
		lda	#$00
		sta	spawnStep
		sta	monsterDY-1,x
		sta	monsterClimb-1,x
		lda	#SHAPE_MONSTER
		sta	monsterState-1,x
		lda	#$25
		sta	monsterX-1,x
		lda	#$2f
		sta	monsterY-1,x
		jsr	drawMonster
		rts

landRight	ldx	monster
		lda	#$01
		sta	monsterDX-1,x
		lda	#$00
		sta	spawnStep
		sta	monsterDY-1,x
		sta	monsterClimb-1,x
		lda	#SHAPE_MONSTER
		sta	monsterState-1,x
		lda	#$59
		sta	monsterX-1,x
		lda	#$2f
		sta	monsterY-1,x
		jsr	drawMonster
		rts

monsterAlive	lda	monsterHit-1,x
		bne	monsterDying
		jsr	moveMonster
		jsr	checkTurns
		jsr	turnAtRandom
		jsr	checkLadders
		rts

; dying: shapes $59 / $5A for 9 frames, with a sound, then the slot is free
monsterDying	jsr	drawMonster
		jsr	animMonster
		inc	monsterState-1,x
		inc	monsterState-1,x
		lda	monsterHit-1,x
		cmp	#$0a
		beq	La54b
		inc	monsterHit-1,x
		jsr	drawMonster
		ldy	#$04
		jsr	soundlib::L0ae6
		rts

La54b		lda	#$00
		sta	monsterState-1,x
		sta	monsterHit-1,x
		rts

moveMonster	ldx	monster
		jsr	drawMonster
		lda	monsterX-1,x
		clc
		adc	monsterDX-1,x
		sta	monsterX-1,x
		lda	monsterY-1,x
		clc
		adc	monsterDY-1,x
		sta	monsterY-1,x
		jsr	animMonster
		jsr	drawMonster
		rts

; out: X = monster
drawMonster	lda	monsterState-1,x
		pha
		lda	monsterY-1,x
		tay
		lda	monsterX-1,x
		tax
		pla
		jsr	spritelib::drawSpriteM
		ldx	monster
		rts

; shape $57 or $58 at random
animMonster	rol	globals::rndSeed1
		jsr	utils::random
		ror
		bcc	La598
		lda	#SHAPE_MONSTER2
		sta	monsterState-1,x
		rts

La598		lda	#SHAPE_MONSTER
		sta	monsterState-1,x
La59d		rts

; off a ladder, 8 times in 256: stops, or walks left or right
turnAtRandom	lda	monsterClimb-1,x
		bne	La59d
		jsr	utils::random
		cmp	#$08
		bcs	La59d
		jsr	utils::random
		cmp	#$40
		bcc	La5c1
		cmp	#$a0
		bcc	La5bb
		lda	#$01
		sta	monsterDX-1,x
		rts

La5bb		lda	#$ff
		sta	monsterDX-1,x
		rts

La5c1		lda	#$00
		sta	monsterDX-1,x
La5c6		rts

; at the top of a ladder: climbs down, or walks left or right; at its
; bottom: climbs up, or walks left or right
checkLadders	ldy	#$00
La5c9		lda	monsterX-1,x
		sta	tmpX
		lda	LAC60,y
		beq	La5c6
		lda	LACA0,y
		cmp	tmpX
		bne	La5f8
		lda	monsterY-1,x
		sta	tmpX
		lda	LAC60,y
		clc
		adc	#$04
		cmp	tmpX
		beq	La5fc
		lda	LAC80,y
		clc
		adc	#$04
		cmp	tmpX
		beq	La634
La5f8		iny
		jmp	La5c9

La5fc		jsr	utils::random
		cmp	#$80
		bcc	La60a
		cmp	#$c0
		bcc	La618
		jmp	La626

La60a		lda	#$01
		sta	monsterClimb-1,x
		sta	monsterDY-1,x
		lda	#$00
		sta	monsterDX-1,x
		rts

La618		lda	#$00
		sta	monsterClimb-1,x
		sta	monsterDY-1,x
		lda	#$ff
		sta	monsterDX-1,x
		rts

La626		lda	#$00
		sta	monsterClimb-1,x
		sta	monsterDY-1,x
		lda	#$01
		sta	monsterDX-1,x
		rts

La634		jsr	utils::random
		cmp	#$40
		bcc	La642
		cmp	#$a0
		bcc	La618
		jmp	La626

La642		lda	#$ff
		sta	monsterClimb-1,x
		sta	monsterDY-1,x
		lda	#$00
		sta	monsterDX-1,x
La64f		rts

; at a turn point (turnX / turnY), turns back
checkTurns	ldy	#$00
La652		lda	turnY,y
		beq	La64f
		cmp	monsterY-1,x
		bne	La66a
		lda	monsterX-1,x
		sta	tmpX
		lda	turnX,y
		cmp	tmpX
		beq	La66e
La66a		iny
		jmp	La652

La66e		lda	monsterDX-1,x
		eor	#$ff
		sta	monsterDX-1,x
		inc	monsterDX-1,x
		jsr	moveMonster
		rts

;
; the ladder at X $23: the next rung, the bottom of ladder 9 goes down by 6;
; with the 6th, ladder 9 goes from Y 3 to $2B: from the floor $2A up to the
; top left ledge
;
addRung		ldx	rung
		lda	rungY-1,x
		tay
		lda	rungX-1,x
		tax
		lda	#SHAPE_RUNG
		jsr	spritelib::drawSprite
		lda	LAC80+9
		clc
		adc	#$06
		sta	LAC80+9
		inc	rung
		ldx	rung
		cpx	#$07
		beq	La6a1
		rts

La6a1		ldx	#$00
		stx	rung
		ldx	#$03
		stx	LAC60+9
		ldx	#$2b
		stx	LAC80+9
		ldx	#$23
		stx	LACA0+9
		rts

; the axe (thrown) hits the mover: 400 points, it shrinks away
checkAxeHitMover
		ldx	moverOn
		beq	La6fe
		ldx	moverHit
		bne	La6fe
		ldx	globals::playerAxeState
		bmi	La6fe
		beq	La6fe
		lda	globals::axeXpos
		clc
		adc	#$07
		cmp	moverX
		bcc	La6fe
		sec
		sbc	#$10
		cmp	moverX
		bcs	La6fe
		lda	globals::axeYpos
		clc
		adc	#$06
		cmp	moverY
		bcc	La6fe
		sec
		sbc	#$0e
		cmp	moverY
		bcs	La6fe
		ldx	#$01
		stx	moverHit
		jsr	game1::scoreAdd250
		jsr	game1::scoreAdd75
		jsr	game1::scoreAdd75
		jsr	soundlib::L0a58
La6fe		rts

; a free slot (0..5) is marked flying out ($FF); none: returns from the caller
takeFreeSlot	ldx	#$05
La701		lda	monsterState,x
		beq	La70d
		dex
		bpl	La701
		pla
		pla
		rts

		.db	$60			; not reached

La70d		dec	monsterState,x
		rts

; a monster on the floor $7C (Y $81) the lower platform runs into dies
checkPlatformHit
		ldx	#$00
La713		lda	monsterState,x
		beq	La73e
		bmi	La73e
		lda	monsterY,x
		cmp	#$81
		bne	La73e
		lda	monsterX,x
		clc
		adc	#$06
		cmp	lowerPlatX
		bcc	La73e
		sec
		sbc	#$0f
		cmp	lowerPlatX
		bcs	La73e
		lda	monsterHit,x
		bne	La73e
		lda	#$01
		sta	monsterHit,x
La73e		inx
		cpx	#$08
		bne	La713
		rts

; the flame burns the player at the exit until the chandelier fell
checkExitFlame	ldx	levelDone
		bne	La75f
		ldx	globals::playerDeadAnimIdx
		bne	La75f
		ldy	globals::spriteY
		cpy	#$2b
		bne	La75f
		ldx	globals::spriteX
		cpx	#$83
		bcc	La75f
		jsr	killPlayer
La75f		rts

; the bolt strikes the player (Y $66-$8E, X near the lower platform)
checkBoltHit	ldx	globals::playerDeadAnimIdx
		bne	La75f
		ldx	boltTimer
		beq	La75f
		lda	globals::spriteY
		clc
		adc	#$03
		cmp	#$69
		bcc	La7ca
		sec
		sbc	#$04
		cmp	#$8b
		bcs	La7ca
		lda	globals::spriteX
		clc
		adc	#$04
		cmp	lowerPlatX
		bcc	La7ca
		sec
		sbc	#$09
		cmp	lowerPlatX
		bcs	La7ca
		jsr	killPlayer
		rts

; the mover touches the player
checkMoverHit	ldx	globals::playerDeadAnimIdx
		bne	La75f
		ldx	moverOn
		beq	La75f
		ldx	moverHit
		bne	La75f
		lda	globals::spriteX
		clc
		adc	#$05
		cmp	moverX
		bcc	La7ca
		sec
		sbc	#$0a
		cmp	moverX
		bcs	La7ca
		lda	globals::spriteY
		clc
		adc	#$0e
		cmp	moverY
		bcc	La7ca
		sec
		sbc	#$14
		cmp	moverY
		bcs	La7ca
		jsr	killPlayer
La7ca		rts

; the player dies; so do the monsters, and the mover goes
killPlayer	jsr	drawPlayer
		ldx	#SHAPE_DEAD
		stx	globals::spriteID
		jsr	drawPlayer
		ldx	#$01
		stx	globals::playerDeadAnimIdx
		jsr	killMonsters
		rts

killMonsters	ldx	#$07
La7e1		lda	monsterState,x
		beq	La7eb
		lda	#$01
		sta	monsterHit,x
La7eb		dex
		bpl	La7e1
		jsr	eraseMover
		rts

; the player walks into the machine
checkMachine	ldx	levelDone
		bne	La815
		ldx	globals::playerDeadAnimIdx
		bne	La815
		ldx	globals::spriteX
		cpx	#$39
		bcc	La815
		cpx	#$46
		bcs	La815
		ldy	globals::spriteY
		cpy	#$3b
		bcc	La815
		cpy	#$5f
		bcs	La815
		jsr	killPlayer
La815		rts

;
; the chandelier
;

; crash frame X (1..6) on lines $41-$59, column $10
drawCrashFrame	jsr	setFramePtr
		ldy	#$41
		sty	drawLine
La81e		jsr	setLinePtr
		ldy	#$00
La823		lda	($1a),y
		sta	($1c),y
		iny
		cpy	#$05
		bne	La823
La82c		inc	$1a
		dey
		bne	La82c
		inc	drawLine
		ldy	drawLine
		cpy	#$5a
		bne	La81e
		rts

; $1C/$1D: line Y, column $10
setLinePtr	lda	utils::hgrLow,y
		clc
		adc	#$10
		sta	$1c
		lda	utils::hgrHigh,y
		sta	$1d
		rts

; $1A/$1B: crash frame X (1..6), crashFrames + (X-1) * $80
setFramePtr	dex
		txa
		lsr
		clc
		adc	#>crashFrames
		sta	$1b
		inx
		txa
		lsr
		bcc	La85c
		lda	#$00
		sta	$1a
		rts

La85c		lda	#$80
		sta	$1a
		rts

; falls 2 lines a frame, faster and faster, the rest of the room still
; running, then crashes on the machine: the monsters die, 1000 points
dropChandelier	inc	chandelierY
		inc	chandelierY
		ldx	chandelierY
		cpx	#$31
		beq	La883
		jsr	updateFlame
		jsr	drawChandelier
		jsr	fallWait
		jsr	animateTorches
		jsr	updateMonsters
		jsr	updateFlame
		jmp	dropChandelier

La883		jsr	killMonsters
		jsr	eraseEffects
		jsr	eraseChandelier
		ldx	#$01
La88e		jsr	drawCrashFrame
		lda	#$00
		jsr	utils::wait
		txa
		pha
		jsr	animateTorches
		jsr	updateMonsters
		pla
		tax
		inx
		cpx	#$07
		bne	La88e
		inc	levelDone
		jsr	game1::scoreAdd1000
		rts

; 18 lines from chandelierY, column $11 (stored, the top lines blank)
drawChandelier	ldy	chandelierY
		sty	drawLine
		ldx	#$00
La8b4		ldy	drawLine
		jsr	setLinePtr
		inc	$1c
		ldy	#$00
La8be		lda	chandelier,x
		sta	($1c),y
		inx
		iny
		cpy	#$05
		bne	La8be
		inc	drawLine
		lda	drawLine
		sec
		sbc	#$12
		cmp	chandelierY
		bne	La8b4
		rts

eraseChandelier	ldy	chandelierY
		sty	drawLine
		ldx	#$00
La8e0		ldy	drawLine
		jsr	setLinePtr
		inc	$1c
		ldy	#$00
La8ea		lda	#$00
		sta	($1c),y
		inx
		iny
		cpy	#$05
		bne	La8ea
		inc	drawLine
		lda	drawLine
		sec
		sbc	#$12
		cmp	chandelierY
		bne	La8e0
		rts

fallWait	lda	fallDelay
		sec
		sbc	#$08
		sta	fallDelay
		jsr	utils::wait
		rts

; the axe thrown at the chain (X >= $41, Y < $0B): it stops there, the
; chandelier's flames (torches 8..11) stop, and the chandelier falls
checkAxeHitChain
		ldx	levelDone
		bne	La949
		ldx	globals::playerAxeState
		beq	La949
		ldx	globals::axeXpos
		cpx	#$41
		bcc	La949
		ldx	globals::axeYpos
		cpx	#$0b
		bcs	La949
		ldx	globals::axeXpos
		ldy	globals::axeYpos
		lda	globals::axeSpriteID
		jsr	spritelib::drawSpriteM
		ldx	#$00
		stx	globals::playerAxeState
		stx	LAD30+8
		ldx	#$e0
		stx	globals::axeYpos
		ldx	#$10
		stx	globals::axeXpos
		jsr	dropChandelier
La949		rts

eraseMover	ldx	moverOn
		beq	La960
		ldx	moverX
		ldy	moverY
		lda	moverShape
		jsr	spritelib::drawSpriteM
		ldx	#$00
		stx	moverOn
La960		rts

; the chandelier crashed: EOR off what is on screen of the flame, the bolt,
; the riser, the gate and a monster flying out
eraseEffects	ldx	flameTimer
		cpx	#$07
		bcs	La975
		txa
		ror
		bcs	La972
		jsr	drawFlame1
		jmp	La975

La972		jsr	drawFlame2
La975		ldx	boltTimer
		beq	La97d
		jsr	drawBolt
La97d		ldx	#$00
		stx	boltTimer
		ldx	clock
		cpx	#$0e
		bcs	La98d
		dex
		jsr	drawDecor
La98d		ldx	gateOn
		beq	La99b
		jsr	drawGate1
		jsr	drawGate2
		jsr	drawGate3
La99b		ldx	spawnStep
		beq	La9a3
		jsr	drawSpawn
La9a3		rts

;
; same as the core's ANIMATE_DECOR: the torches' flames ($AD20-$AD4F)
;
animateTorches	ldx	#$ff
		stx	globals::L0322
La9a9		inc	globals::L0322
		ldx	globals::L0322
		lda	LAD30,x
		beq	La9cf
		jsr	drawTorch
		ldx	globals::L0322
		inc	LAD40,x
		lda	LAD40,x
		cmp	#$24
		bne	La9c9
		lda	#$21
		sta	LAD40,x
La9c9		jsr	drawTorch
		jmp	La9a9

La9cf		rts

drawTorch	lda	LAD30,x
		tay
		lda	LAD40,x
		pha
		lda	LAD20,x
		tax
		pla
		jsr	spritelib::drawSprite
		rts

;
; the axe bonus at ($45,$A6) shows at random (8 chances in 256) while the
; player has fewer than 10 axes
;
checkBonus	ldx	bonusOn
		bne	La9f8
		ldx	globals::playerAxeCountHi
		bne	La9f8
		jsr	utils::random
		cmp	#$08
		bcs	La9f8
		inc	bonusOn
		jsr	drawBonus
La9f8		rts

checkTakeBonus	ldx	bonusOn
		beq	La9f8
		lda	globals::spriteX
		sec
		sbc	#$04
		cmp	#$45
		bcs	La9f8
		clc
		adc	#$0b
		cmp	#$45
		bcc	La9f8
		lda	globals::spriteY
		cmp	#$8c
		bcc	La9f8
		dec	bonusOn
		jsr	addAxe
		jsr	game1::scoreAdd50
		jsr	soundlib::L0ad7
drawBonus	ldx	#$45
		ldy	#$a6
		lda	#SHAPE_AXE
		jsr	spritelib::drawSprite
		rts

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
		bne	Laa3d
		lda	#$0a
Laa3d		jsr	spritelib::drawSprite
		rts

;
; one more axe, on the status line too (2 decimal digits)
;
addAxe		ldx	#AXES_LO
		jsr	drawDigit
		inc	globals::playerAxeCountLo
		ldx	globals::playerAxeCountLo
		cpx	#$0a
		beq	Laa56
		ldx	#AXES_LO
		jsr	drawDigit
		rts

Laa56		ldx	#$00
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
; the chandelier fell and the player is at the top right (Y $2B, X >= $83):
; he blinks out with a falling tone and is moved onto the c5 exit ($C0,$C0)
;
checkLeave	ldx	levelDone
		beq	Laab0
		ldy	globals::spriteY
		cpy	#$2b
		bne	Laab0
		ldx	globals::spriteX
		cpx	#$83
		bcc	Laab0
		jsr	leave
Laab0		rts

leave		jsr	drawPlayer
		lda	#SHAPE_LEAVE
		sta	globals::spriteID
		jsr	drawPlayer
		ldx	#$30
		stx	globals::L033B
Laac1		jsr	flipPlayer
		jsr	leaveTone
		jsr	utils::wait
		jsr	animateTorches
		dec	globals::L033B
		bne	Laac1
		jsr	drawPlayer
		ldx	#$c0
		stx	globals::spriteX
		stx	globals::spriteY
		ldx	#$00
		stx	globals::playerXspeed
		stx	globals::playerYspeed
		rts

flipPlayer	jsr	drawPlayer
		lda	globals::spriteID
		eor	#$4f
		sta	globals::spriteID
		jsr	drawPlayer
		rts

leaveTone	ldy	#$08
		ldx	globals::L033B
		jsr	game1::tone
Laafd		rts

; a monster touches the player, unless he rides the lower platform
checkMonsterHit	ldx	globals::playerDeadAnimIdx
		bne	Laafd
		ldx	onPlatform
		bne	Laafd
		ldx	#$08
Lab0a		dex
		bmi	Laafd
		lda	monsterState,x
		beq	Lab0a
		bmi	Lab0a
		lda	monsterX,x
		sec
		sbc	#$03
		cmp	globals::spriteX
		bcs	Lab0a
		clc
		adc	#$07
		cmp	globals::spriteX
		bcc	Lab0a
		lda	monsterY,x
		sec
		sbc	#$0a
		cmp	globals::spriteY
		bcs	Lab0a
		clc
		adc	#$10
		cmp	globals::spriteY
		bcc	Lab0a
		jmp	killPlayer

; $AB3D-$ABFF: slack (leftover code of level 5's checkShotHit, then $FF)
