;
; level 4 code, disk chunk c4 ($A000-$ABFF)
; levelTick, at $A000, is called once per frame by the game's main loop.
;
; the room: water at the bottom (the player sinks in it), a geyser in a hole
; at X $3C-$4A (falling in kills), a boulder that falls from the top left,
; breaks on the ground, then rides the geyser up as a ledge, a pool of up to
; 8 creatures (killed by the axe or the water), water drops falling from the
; top right, a random bonus (a gem or an axe), two gem slots that release the
; key, and a door at X $71 (Y $50-$64) that only the key opens.
; exit: walking out at the top right (exit at $8B,$28).
;
; spritelib::drawStore and spritelib::drawPlain draw without the priority /
; collision tests: drawStore writes the shape (no EOR, the geyser leaves a
; column behind it), drawPlain EORs it. Before and after drawing over
; sprites, the code EORs those sprites off and back on (toggleNearGeyser,
; toggleBottomLeft).
;

RNDL		.equ	$4E
RNDH		.equ	$4F

; inventory items, shape SHAPE_ITEMS + item: globals::assetKeyCnt / assetGemCnt
SHAPE_ITEMS	.equ	$26
ITEM_KEY	.equ	1
ITEM_GEM	.equ	2
SHAPE_KEY	.equ	SHAPE_ITEMS + ITEM_KEY
SHAPE_GEM	.equ	SHAPE_ITEMS + ITEM_GEM
SHAPE_AXE	.equ	$1E		; axe bonus
SHAPE_DOOR	.equ	$2A		; EORed over the door to open it
SHAPE_DEAD	.equ	$19		; player killed

SHAPE_CREATURE	.equ	$41		; walking
SHAPE_CREATURE_FALL .equ $42		; falling; $42-$44 jumping (jumpShapes)
SHAPE_CREATURE_POP .equ	$45		; $45-$48: appearing ($48 down to $45), dying ($45 up to $48)
SHAPE_CREATURE_GONE .equ $48
SHAPE_GEYSER	.equ	$51		; $51-$53, cycling
SHAPE_BOULDER	.equ	$54
SHAPE_SLOT	.equ	$58		; slot 2's blinking marker
SHAPE_DROP	.equ	$59
SHAPE_BLANK	.equ	$5D		; 2 bytes x 8 lines of 0: eraser, with drawStore

AXES_HI		.equ	globals::playerAxeCountHi - globals::playerData
AXES_LO		.equ	globals::playerAxeCountLo - globals::playerData

La000		jmp levelTick

;
; once per frame
;
levelTick	jsr updateBreak
		jsr updateBoulder
		jsr updateGeyser
		jsr updateBoulderLedge
		jsr carryPlayer
		jsr updateCreatures
		jsr checkAxeHit
		jsr checkSink
		jsr doNothing
		jsr updateSink
		jsr updateBonus
		jsr checkBonus
		jsr checkPlaceGem
		jsr updateDrops
		jsr blinkSlot
		jsr updateKey
		jsr checkDoor
		jsr updateBonusTime
		jsr checkCreatureHit
		lda #$40
		jsr utils::wait
		rts

;
; boulder: waits boulderWait frames at ($08,$2F), then falls, faster and
; faster (1 to 3 lines a frame), with a tone, down to the ground ($A4)
;
updateBoulder	ldx boulderState
		bne boulderMoves
		dec boulderWait
		bne La19f
		ldx #$01
		stx boulderState
La19f		rts

boulderMoves	bmi boulderBreaking
		jsr drawBoulder
		lda boulderY
		clc
		adc boulderState
		sta boulderY
		cmp #$a4
		bcs boulderHitsGround
		jsr drawBoulder
		ldx boulderY
		ldy #$10
		jsr game1::tone
		ldx boulderState
		cpx #$03
		beq La1c8
		inc boulderState
La1c8		rts

drawBoulder	ldx boulderX
		ldy boulderY
		lda #SHAPE_BOULDER
		jmp spritelib::drawSprite

; on the ground: breaks up, and $20 frames later (boulderBreaking) it's
; back, on the geyser's hole, and the geyser leaps $10 frames later
boulderHitsGround
		ldx #$e0
		stx boulderState
		jmp startBreak

boulderBreaking	inc boulderState
		bne La1f3
		ldx #$3c
		stx boulderX
		ldx #$8c
		stx boulderY
		jsr drawBoulder
		ldx #$10
		stx geyserWait
La1f3		rts

;
; geyser: leaps out of its hole ($42,$98) 3 lines a frame, slows down above
; Y=$20 and when it stops the boulder bursts and it goes back down
;
updateGeyser	ldx geyserState
		bne geyserMoves
		dec geyserWait
		bne La1f3
		ldx #$01
		stx geyserState
		ldx #$98
		stx geyserY
		ldx #$42
		stx geyserX
		ldx #$fd
		stx geyserDY
		ldx #SHAPE_GEYSER
		stx geyserShape
		rts

geyserMoves	jsr liftOrBurst
		lda geyserY
		clc
		adc geyserDY
		sta geyserY
		cmp #$98
		beq geyserDone
		jsr moveGeyser
		jsr geyserSlowDown
		jmp animGeyser

; back in its hole: erase it, the boulder waits at the top left again
geyserDone	jsr toggleNearGeyser
		jsr eraseGeyserHole
		jsr toggleNearGeyser
		ldx #$00
		stx boulderState
		stx geyserState
		stx geyserWait
		stx burstFrame
		jsr random
		and #$3f
		adc #$10
		sta boulderWait
		ldx #$08
		stx boulderX
		ldx #$2f
		stx boulderY
		jmp drawBoulder

geyserSlowDown	ldx geyserY
		cpx #$20
		bcs La276
		inc geyserDY
		bne La276
		ldx #$ff
		stx geyserState
		inx
		inx
		stx burstFrame
La276		rts

; going up: draw the geyser over its last position (drawStore), which
; leaves the column under it
moveGeyser	jsr toggleNearGeyser
		ldx geyserState
		bmi geyserFalls
		jsr drawGeyser
		jmp toggleNearGeyser

drawGeyser	ldx geyserX
		ldy geyserY
		lda geyserShape
		jsr spritelib::drawStore
		rts

animGeyser	inc geyserShape
		ldx geyserShape
		cpx #SHAPE_GEYSER+3
		bne La2a1
		ldx #SHAPE_GEYSER
		stx geyserShape
La2a1		rts

; going down: erase the top of the column
geyserFalls	ldx geyserX
		ldy geyserY
		dey
		dey
		dey
		lda #SHAPE_BLANK
		jsr spritelib::drawStore
		jsr drawGeyser
		jmp toggleNearGeyser

;
; the boulder rides the geyser, or bursts (burstFrame 1..4) once at the top
;
liftOrBurst	ldx burstFrame
		beq boulderRides
		bmi La276
		jsr drawBurst
		inc burstFrame
		ldx burstFrame
		cpx #$05
		bne drawBurst
		ldx #$ff
		stx burstFrame
		rts

boulderRides	jsr drawBoulder
		lda boulderY
		clc
		adc geyserDY
		sta boulderY
		jsr drawBoulder
		ldx boulderY
		ldy #$10
		jmp game1::tone

;
; boulder breaking on the ground (breakFrame 1..8), at Y=$A3
;
startBreak	ldx #$01
		stx breakFrame
		jmp drawBreak

updateBreak	ldx breakFrame
		beq La307
		jsr drawBreak
		inc breakFrame
		ldx breakFrame
		cpx #$09
		bne drawBreak
		ldx #$00
		stx breakFrame
La307		rts

drawBreak	jsr toggleBottomLeft
		ldx breakFrame
		lda breakShapes-1,x
		ldx boulderX
		ldy #$a3
		jsr spritelib::drawPlain
		jmp toggleBottomLeft

drawBurst	ldx burstFrame
		lda burstShapes-1,x
		ldx boulderX
		ldy boulderY
		jmp spritelib::drawSprite

;
; erase Y $95-$A3 at the geyser's X
;
eraseGeyserHole	ldx geyserX
		ldy #$95
		lda #SHAPE_BLANK
		jsr spritelib::drawStore
		ldx geyserX
		ldy #$9c
		lda #SHAPE_BLANK
		jsr spritelib::drawStore
		ldx geyserX
		ldy #$99
		lda #SHAPE_BLANK
		jmp spritelib::drawStore

;
; the boulder is ledge $0E while it's solid, from X-4 to X+$0D at Y-$11;
; a top of 0 ends the list otherwise
;
updateBoulderLedge
		jsr isBoulderSolid
		bcc La354
		ldx #$00
		stx LAC40+$0e
		rts

La354		lda boulderY
		sec
		sbc #$11
		sta LAC40+$0e
		lda boulderX
		sec
		sbc #$04
		sta LAC00+$0e
		clc
		adc #$11
		sta LAC20+$0e
		rts

;
; player landing on the solid boulder (not while going up): stands on it,
; at boulderY-$10
;
carryPlayer	jsr isBoulderSolid
		bcs La3c4
		ldx globals::playerDeadAnimIdx
		bne La3c4
		ldx globals::playerYspeed
		bmi La3c4
		lda boulderX
		sec
		sbc #$06
		cmp globals::spriteX
		bcs La3c4
		clc
		adc #$10
		cmp globals::spriteX
		bcc La3c4
		lda boulderY
		sec
		sbc #$14
		cmp globals::spriteY
		bcs La3c4
		clc
		adc #$08
		adc globals::playerYspeed
		cmp globals::spriteY
		bcc La3c4
		jsr drawPlayer
		lda boulderY
		sec
		sbc #$10
		sta globals::spriteY
		jsr drawPlayer
		ldx globals::L0383
		cpx #$01
		bne La3c4
		lda globals::playerYspeed
		sec
		sbc #$05
		sta globals::playerYspeed
La3c4		rts

;
; EOR the player (off or on)
;
drawPlayer	ldx globals::spriteX
		ldy globals::spriteY
		lda globals::spriteID
		jmp spritelib::drawSpriteM

;
; carry clear while the boulder can be stood on: falling, waiting, or on the
; geyser before it bursts. Set while it breaks or once it burst
;
isBoulderSolid	ldx boulderState
		beq La3da
		bmi La3df
La3d8		clc
		rts

La3da		ldx geyserState
		bpl La3d8
La3df		sec
		rts

;
; creatures move every other frame; on the other ones, they only follow
; the boulder
;
updateCreatures	lda halfFrame
		eor #$01
		sta halfFrame
		beq La3fc
		jsr spawnCreature
		ldx #$07
		stx creature
La3f3		jsr moveCreature
		dec creature
		bpl La3f3
La3fb		rts

La3fc		ldx #$07
		stx creature
La401		ldx creature
		lda creatureActive,x
		beq La40c
		jsr checkCreatureOnBoulder
La40c		dec creature
		bpl La401
		rts

;
; one creature: appearing, alive (walking, jumping, falling) or dying
;
moveCreature	ldx creature
		lda creatureActive,x
		beq La3fb
		lda creatureState,x
		bmi creatureAppears
		beq creatureWalks
		jsr drawCreature
		lda creatureShape,x
		cmp #SHAPE_CREATURE_GONE
		beq La431
		inc creatureShape,x
		jmp drawCreature

La431		lda #$00
		sta creatureActive,x
		rts

; falling, moving on X too, until it lands on a ledge
creatureFalls	jsr drawCreature
		lda creatureDX,x
		bmi La445
		inc creatureX,x
		jmp La448

La445		dec creatureX,x
La448		lda creatureY,x
		clc
		adc creatureDY,x
		sta creatureY,x
		lda #SHAPE_CREATURE_FALL
		sta creatureShape,x
		jsr drawCreature
		inc creatureDY,x
		lda creatureDY,x
		cmp #$06
		bne La467
		dec creatureDY,x
La467		jsr creatureBounces
		jsr checkCreatureFall
		jsr checkCreatureOnBoulder
		rts

; appearing: shapes $48 down to $45, then walks in a random direction
creatureAppears	jsr drawCreature
		lda creatureShape,x
		cmp #SHAPE_CREATURE_POP
		beq La481
		dec creatureShape,x
		jmp drawCreature

La481		lda #$00
		sta creatureState,x
		sta creatureJump,x
		lda #SHAPE_CREATURE
		sta creatureShape,x
		jsr random
		sta creatureDX,x
		and #$0f
		sta creatureTimer,x
		jmp drawCreature

; walking: turns around when it leaves X $08-$5D, jumps when its timer
; runs out, falls off the end of its ledge
creatureWalks	jsr checkCreatureSinks
		lda creatureJump,x
		bne creatureJumps
		lda creatureFalling,x
		bne creatureFalls
		dec creatureTimer,x
		beq creatureStartsJump
		lda creatureX,x
		cmp #$08
		bcc creatureTurns
		cmp #$5e
		bcs creatureTurns
		jmp La4c7

creatureTurns	lda creatureDX,x
		eor #$ff
		sta creatureDX,x
		inc creatureDX,x
La4c7		jsr drawCreature
		lda creatureDX,x
		bmi La4d5
		inc creatureX,x
		jmp La4d8

La4d5		dec creatureX,x
La4d8		jsr drawCreature
		jsr checkCreatureLedge
		jmp checkCreatureOnBoulder

creatureStartsJump
		lda #$01
		sta creatureJump,x
		lda #$fb
		sta creatureDY,x
		rts

; jumping: up, then down (creatureDY $FB to 5), shape by speed
creatureJumps	jsr drawCreature
		inc creatureDY,x
		lda creatureDY,x
		cmp #$06
		bne La4ff
		dec creatureDY,x
		lda creatureDY,x
La4ff		clc
		adc #$04
		tay
		lda jumpShapes,y
		sta creatureShape,x
		lda creatureDX,x
		bmi La514
		inc creatureX,x
		jmp La517

La514		dec creatureX,x
La517		lda creatureY,x
		clc
		adc creatureDY,x
		sta creatureY,x
		jsr drawCreature
		jsr checkCreatureLanding
		jsr checkCreatureOnBoulder
		rts

;
; EOR creature `creature` (off or on), collision in spritelib::isCollision
; returns X = creature
;
drawCreature	ldx creature
		ldy #$00
		sty spritelib::isCollision
		lda creatureY,x
		tay
		lda creatureX,x
		sta globals::L033B
		lda creatureShape,x
		ldx globals::L033B
		jsr spritelib::drawSpriteM
		ldx creature
		rts

;
; a new creature at one of the 16 spawn points, every spawnWait frames,
; when a slot is free: they come faster and faster (spawnMask)
;
spawnCreature	dec spawnWait
		bmi La550
		rts

La550		ldx #$00
La552		lda creatureActive,x
		beq spawnInSlot
		inx
		cpx #$08
		bne La552
		jsr random
		and #$1f
		sta spawnWait
		rts

spawnInSlot	stx creature
		jsr random
		and spawnMask
		sta spawnWait
		jsr random
		and #$0f
		tay
		ldx creature
		lda spawnX,y
		sta creatureX,x
		lda spawnY,y
		sta creatureY,x
		lda #$ff
		sta creatureState,x
		sta creatureActive,x
		lda #SHAPE_CREATURE_GONE
		sta creatureShape,x
		jsr random
		and #$0f
		sta creatureTimer,x
		lda #$00
		sta creatureJump,x
		sta creatureDY,x
		lda #$01
		sta creatureFalling,x
		jsr drawCreature
		lda spawnMask
		sec
		sbc #$03
		bcc La5b7
		sta spawnMask
		rts

La5b7		lda #$04
		sta spawnMask
		rts

;
; walking: still on a ledge? (then on its top) or start falling
;
checkCreatureLedge
		jsr findLedge
		bcc creatureOnLedge
		ldx creature
		lda #$01
		sta creatureFalling,x
		sta creatureDY,x
		rts

creatureOnLedge	txa
		ldx creature
		lda creatureJump,x
		bne La5fb
		tax
		lda LAC40,x
		clc
		adc #$09
		ldx creature
		cmp creatureY,x
		beq La5fb
		jsr drawCreature
		ldx ledge
		lda LAC40,x
		clc
		adc #$09
		ldx creature
		sta creatureY,x
		jsr drawCreature
La5fb		rts

;
; jumping, coming down (creatureDY >= 4): lands on a ledge or falls
;
checkCreatureLanding
		lda creatureDY,x
		bmi creatureOnLedge
		cmp #$04
		bcc creatureOnLedge
		jsr findLedge
		bcc creatureLands
		lda #$01
		ldx creature
		sta creatureFalling,x
		lda #$00
		sta creatureJump,x
		rts

;
; falling: lands on a ledge?
;
checkCreatureFall
		jsr findLedge
		bcc creatureLands
		rts

creatureLands	jsr drawCreature
		lda #$00
		sta creatureFalling,x
		sta creatureDY,x
		sta creatureJump,x
		jsr random
		and #$0f
		sta creatureTimer,x
		lda #SHAPE_CREATURE
		sta creatureShape,x
		ldy ledge
		lda LAC40,y
		clc
		adc #$09
		sta creatureY,x
		jsr drawCreature
		rts

;
; ledge under the current creature: carry clear and ledge = its index when
; LAC00 < X <= LAC20-2 and LAC40 < Y <= LAC40+$0C; carry set if none
; (returns X = ledge)
;
findLedge	ldx creature
		lda creatureX,x
		sta testX
		lda creatureY,x
		sta testY
		ldx #$ff
		stx ledge
La65d		inc ledge
		ldx ledge
		lda LAC40,x
		beq La68d
		lda LAC00,x
		cmp testX
		bcs La65d
		lda LAC20,x
		sec
		sbc #$02
		cmp testX
		bcc La65d
		lda LAC40,x
		cmp testY
		bcs La65d
		clc
		adc #$0c
		cmp testY
		bcc La65d
		clc
		rts

La68d		sec
		rts

;
; ran into something (isCollision): step back 2 and turn around
;
creatureBounces	ldx spritelib::isCollision
		beq La6bc
		jsr drawCreature
		ldx creature
		lda creatureDX,x
		bmi La6a8
		dec creatureX,x
		dec creatureX,x
		jmp La6ae

La6a8		inc creatureX,x
		inc creatureX,x
La6ae		jsr drawCreature
		lda creatureDX,x
		eor #$ff
		sta creatureDX,x
		inc creatureDX,x
La6bc		rts

;
; in the water (Y >= $AA): dies, and doesn't return to its caller
;
checkCreatureSinks
		ldx creature
		lda creatureY,x
		cmp #$aa
		bcc La6d9
; pops its caller's return address: returns to the caller's caller
killCreature	jsr drawCreature
		lda #SHAPE_CREATURE_POP
		sta creatureShape,x
		jsr drawCreature
		lda #$01
		sta creatureState,x
		pla
		pla
La6d9		rts

;
; creature next to the solid boulder: stands on it
;
checkCreatureOnBoulder
		jsr isBoulderSolid
		bcs La6d9
		ldx creature
		lda boulderX
		sec
		sbc #$03
		cmp creatureX,x
		bcs La71f
		clc
		adc #$0e
		cmp creatureX,x
		bcc La71f
		lda boulderY
		sec
		sbc #$0d
		cmp creatureY,x
		bcs La71f
		clc
		adc #$16
		cmp creatureY,x
		bcc La71f
		jsr drawCreature
		lda boulderY
		sec
		sbc #$08
		sta creatureY,x
		jsr drawCreature
		lda #$00
		sta creatureJump,x
		sta creatureFalling,x
La71f		rts

;
; the axe kills the alive creatures it touches: +75
;
checkAxeHit	ldx globals::playerAxeState
		beq La71f
		ldx #$07
		stx creature
La72a		ldx creature
		lda creatureActive,x
		beq La766
		lda creatureState,x
		bne La766
		lda creatureX,x
		sec
		sbc #$07
		cmp globals::axeXpos
		bcs La766
		clc
		adc #$0f
		cmp globals::axeXpos
		bcc La766
		lda creatureY,x
		sec
		sbc #$04
		cmp globals::axeYpos
		bcs La766
		clc
		adc #$0e
		cmp globals::axeYpos
		bcc La766
		jsr axeKillsCreature
		jsr game1::scoreAdd75
		jsr soundlib::L0a58
La766		dec creature
		bpl La72a
La76b		rts

; killCreature pops this routine's return address: it never goes on
; into checkSink
axeKillsCreature
		jsr killCreature

;
; player in the water (Y $A8-$BF): sinks, or dies falling into the geyser's
; hole (X $3C-$4A)
;
checkSink	ldx globals::playerDeadAnimIdx
		bne La76b
		ldx globals::spriteY
		cpx #$a8
		bcc La76b
		cpx #$c0
		bcs La76b
		ldx globals::spriteX
		cpx #$3c
		bcc startSink
		cpx #$4b
		bcs startSink
		jmp killPlayer

startSink	jsr drawPlayer
		ldx #$08
		stx globals::playerDeadAnimIdx
		ldx #$00
		stx sinkFrame
		ldx globals::spriteX
		stx sinkX
		cpx #$40
		bcs La7ad
		ldx #$01
		stx sinkDir
		jsr drawSink
		rts

La7ad		ldx #$ff
		stx sinkDir
		jsr drawSink
		rts

; EOR the player's sinking shape (sinkFrame, sinkDir) at (sinkX, $9C)
drawSink	jsr toggleBottomLeft
		lda sinkFrame
		ldx sinkDir
		bpl La7c4
		clc
		adc #$08
La7c4		tax
		lda sinkShapes,x
		ldx sinkX
		ldy #$9c
		jsr spritelib::drawPlain
		jsr toggleBottomLeft
		rts

;
; player sinking, 8 frames
;
updateSink	lda sinkDir
		beq La7e9
		jsr drawSink
		inc sinkFrame
		ldx sinkFrame
		cpx #$08
		beq La7ea
		jsr drawSink
La7e9		rts

La7ea		ldx #$00
		stx sinkDir
		rts

;
; called by levelTick, does nothing
;
doNothing	rts

;
; while the geyser goes down: EOR the axe (when it comes back), the player
; and the creatures near the geyser, off before drawing it, on after
;
toggleNearGeyser	ldx geyserState
		bpl La7e9
		ldx globals::playerAxeState
		dex
		bmi La808
		ldx globals::axeXpos
		ldy globals::axeYpos
		lda globals::axeSpriteID
		jsr spritelib::drawSpriteM
La808		lda geyserX
		sec
		sbc #$0a
		cmp globals::spriteX
		bcs La838
		clc
		adc #$0d
		cmp globals::spriteX
		bcc La838
		lda geyserY
		sec
		sbc #$13
		cmp globals::spriteY
		bcs La838
		clc
		adc #$1b
		cmp globals::spriteY
		bcc La838
		ldx globals::playerDeadAnimIdx
		cpx #$09
		beq La838
		jsr drawPlayer
La838		ldx #$00
		stx creature
La83d		ldx creature
		lda creatureActive,x
		beq La86e
		lda geyserX
		sec
		sbc #$0b
		cmp creatureX,x
		bcs La86e
		clc
		adc #$1b
		cmp creatureX,x
		bcc La86e
		lda geyserY
		sec
		sbc #$0f
		cmp creatureY,x
		bcs La86e
		clc
		adc #$1a
		cmp creatureY,x
		bcc La86e
		jsr drawCreature
La86e		inc creature
		ldx creature
		cpx #$08
		bne La83d
La878		rts

;
; every bonusWait frames, when there's none, a bonus appears for $40-$BF
; frames, 24 lines under a spawn point: a gem (1 in 4) or an axe
;
updateBonus	ldx bonusTime
		bne La878
		dec bonusWait
		bne La878
		jsr random
		cmp #$40
		bcc La892
		ldx #$ff
		stx bonusKind
		jmp La897

La892		ldx #$01
		stx bonusKind
La897		jsr random
		and #$0f
		tay
		lda spawnX,y
		sta globals::L033B
		sta bonusX
		lda spawnY,y
		clc
		adc #$18
		tay
		sty bonusY
		lda #SHAPE_GEM
		ldx bonusKind
		bpl La8b9
		lda #SHAPE_AXE
La8b9		ldx globals::L033B
		jsr spritelib::drawPlain
		jsr random
		and #$1f
		sta bonusWait
		jsr random
		and #$7f
		clc
		adc #$40
		sta bonusTime
		rts

;
; bonus taken: the gem when the player has none (+200), the axe (+50)
;
checkBonus	ldx bonusTime
		beq La922
		lda bonusX
		sec
		sbc #$08
		cmp globals::spriteX
		bcs La922
		clc
		adc #$0d
		cmp globals::spriteX
		bcc La922
		lda bonusY
		sec
		sbc #$0a
		cmp globals::spriteY
		bcs La922
		clc
		adc #$0d
		cmp globals::spriteY
		bcc La922
		ldx bonusKind
		bmi takeAxeBonus
		ldx globals::assetGemCnt
		bne La922
		ldx #$01
		stx globals::assetGemCnt
		dex
		stx bonusTime
		jsr eraseGemBonus
		ldx #ITEM_GEM
		jsr drawInventoryItem
		jsr game1::scoreAdd100
		jsr game1::scoreAdd100
		jsr soundlib::L0ab6
La922		rts

takeAxeBonus	jsr addAxe
		jsr game1::scoreAdd50
		jsr soundlib::L0ad7
eraseAxeBonus	ldx bonusX
		ldy bonusY
		lda #SHAPE_AXE
		jsr spritelib::drawPlain
		ldx #$00
		stx bonusTime
		rts

eraseGemBonus	ldx bonusX
		ldy bonusY
		lda #SHAPE_GEM
		jsr spritelib::drawPlain
		rts

;
; EOR item X's icon on the status line
;
drawInventoryItem
		txa
		tay
		lda globals::assetData,y
		tax
		tya
		clc
		adc #SHAPE_ITEMS
		ldy #$b9
		jsr spritelib::drawSprite
		rts

;
; same as game1::drawDigit: EOR digit X of playerData on the status line
;
drawDigit	lda globals::playerData,x
		tay
		lda globals::L033C,x
		tax
		tya
		ldy #$b9
		cmp #$00
		bne La96a
		lda #$0a
La96a		jsr spritelib::drawSprite
		rts

;
; one more axe, on the status line too (2 decimal digits)
;
addAxe		ldx #AXES_LO
		jsr drawDigit
		inc globals::playerAxeCountLo
		ldx globals::playerAxeCountLo
		cpx #$0a
		beq La983
		ldx #AXES_LO
		jsr drawDigit
		rts

La983		ldx #$00
		stx globals::playerAxeCountLo
		ldx #AXES_LO
		jsr drawDigit
		ldx #AXES_HI
		jsr drawDigit
		inc globals::playerAxeCountHi
		ldx #AXES_HI
		jsr drawDigit
		rts

;
; water drops 1..$1F, one step further on dropPathX/Y each frame
; (ledge used as the loop counter)
;
updateDrops	ldx #$1f
		stx ledge
La9a0		jsr moveDrop
		dec ledge
		bne La9a0
		rts

moveDrop	ldx ledge
		jsr drawDrop
		ldx ledge
		inc dropStep,x
		jsr drawDrop
		rts

drawDrop	lda dropStep,x
		tax
		lda dropPathY,x
		tay
		lda dropPathX,x
		tax
		lda #SHAPE_DROP
		jsr spritelib::drawSprite
		rts

;
; player with a gem at the slots (X $78-$80, Y $9B-$A5): +500, the gem goes
; into slot 1, then slot 2, which releases the key
;
checkPlaceGem	ldx globals::assetGemCnt
		beq La9fe
		ldx keyState
		bne La9fe
		ldx globals::spriteX
		cpx #$78
		bcc La9fe
		cpx #$81
		bcs La9fe
		ldx globals::spriteY
		cpx #$a6
		bcs La9fe
		cpx #$9b
		bcc La9fe
		jsr game1::scoreAdd250
		jsr game1::scoreAdd250
		jsr soundlib::L0ac5
		ldx slot1Full
		beq fillSlot1
		ldx slot2Full
		beq fillSlot2
La9fe		rts

dropGem		ldx #ITEM_GEM
		jsr drawInventoryItem
		ldx #$00
		stx globals::assetGemCnt
		rts

fillSlot1	jsr dropGem
		ldx #$80
		jsr drawSlotGem
		ldx #$01
		stx slot1Full
		rts

fillSlot2	jsr dropGem
		ldx #$7a
		jsr drawSlotGem
		ldx #$01
		stx keyState
		ldx slotBlink
		bmi Laa33
		ldx #$76
		ldy #$95
		lda #SHAPE_SLOT
		jsr spritelib::drawPlain
Laa33		rts

drawSlotGem	ldy #$a6
		lda #SHAPE_GEM
		jsr spritelib::drawSprite
		rts

;
; slot 2's marker blinks until it's filled
;
blinkSlot	ldx keyState
		bne Laa52
		ldx #$76
		ldy #$95
		lda #SHAPE_SLOT
		jsr spritelib::drawPlain
		lda slotBlink
		eor #$fe
		sta slotBlink
Laa52		rts

;
; the key: falls to Y=$A3, then can be taken
;
updateKey	ldx keyState
		beq Laa52
		bpl keyFalls
		bmi checkTakeKey
		rts			; never reached

keyFalls	jsr drawKey
		inc keyY
		jsr drawKey
		ldx keyY
		cpx #$a3
		bne Laa72
		ldx #$ff
		stx keyState
Laa72		rts

drawKey		ldx keyX
		ldy keyY
		lda #SHAPE_KEY
		jsr spritelib::drawPlain
		rts

; player at the key (X $72-$79, Y $9C-$A3): takes it, +100
checkTakeKey	ldx globals::assetKeyCnt
		bne Laab5
		ldx globals::spriteX
		cpx #$72
		bcc Laab5
		cpx #$7a
		bcs Laab5
		ldx globals::spriteY
		cpx #$9c
		bcc Laab5
		cpx #$a4
		bcs Laab5
		ldx #ITEM_KEY
		jsr drawInventoryItem
		ldx #$01
		stx globals::assetKeyCnt
		ldx keyX
		ldy keyY
		lda #SHAPE_KEY
		jsr spritelib::drawPlain
		jsr game1::scoreAdd100
		jsr soundlib::L0a6e
Laab5		rts

;
; door at X=$71, Y $50-$64: the key opens it (+250), without it the
; player is stopped there
;
checkDoor	ldx globals::spriteX
		cpx #$71
		bcc Laae8
		ldx globals::spriteY
		cpx #$50
		bcc Laae8
		cpx #$65
		bcs Laae8
		ldx globals::assetKeyCnt
		beq doorBlocks
		ldx #$00
		stx globals::assetKeyCnt
		inx
		stx doorOpen
		jsr drawInventoryItem	; X = ITEM_KEY
		ldx #$78
		ldy #$52
		lda #SHAPE_DOOR
		jsr spritelib::drawSprite
		jsr game1::scoreAdd250
		jsr soundlib::L0a7d
Laae8		rts

doorBlocks	ldx doorOpen
		bne Laae8
		ldx #$00
		stx globals::playerXspeed
		stx globals::playerYspeed
		jsr drawPlayer
		ldx #$71
		stx globals::spriteX
		jsr drawPlayer
		rts

;
; random number in A, globals::soundCnt3 (same as the core's)
;
random		rol RNDL
		rol globals::soundCnt1
		rol globals::sountCnt2
		lda RNDL
		asl
		eor RNDH
		eor globals::sountCnt2
		rol
		rol
		rol
		rol
		rol
		pha
		rol RNDH
		lda RNDH
		eor globals::soundCnt1
		sta RNDL
		pla
		sta globals::sountCnt2
		adc RNDL
		adc globals::soundCnt1
		sta globals::soundCnt3
		rts

;
; the bonus goes away when bonusTime runs out
;
updateBonusTime	ldx bonusTime
		beq Lab40
		dec bonusTime
		bne Lab40
		ldx bonusKind
		bmi Lab41
		jsr eraseGemBonus
Lab40		rts

Lab41		jsr eraseAxeBonus
		rts

;
; EOR the player and the falling creatures in the bottom left
; (X < $30, Y $90-$AB): off before drawing there, on after
;
toggleBottomLeft	ldy globals::playerDeadAnimIdx
		bne Lab5f
		ldx globals::spriteX
		cpx #$30
		bcs Lab5f
		ldx globals::spriteY
		cpx #$90
		bcc Lab5f
		cpx #$ac
		bcs Lab5f
		jsr drawPlayer
Lab5f		ldx #$07
		stx creature
Lab64		ldx creature
		lda creatureActive,x
		beq Lab86
		lda creatureFalling,x
		beq Lab86
		lda creatureX,x
		cmp #$30
		bcs Lab86
		lda creatureY,x
		cmp #$90
		bcc Lab86
		cmp #$ac
		bcs Lab86
		jsr drawCreature
Lab86		dec creature
		bmi Lab40
		jmp Lab64

;
; player killed: shape SHAPE_DEAD, death animation
;
killPlayer	jsr drawPlayer
		ldx #SHAPE_DEAD
		stx globals::spriteID
		jsr drawPlayer
		ldx #$01
		stx globals::playerDeadAnimIdx
Lab9e		rts

;
; an alive creature (not appearing or dying) touching the player kills the player
;
checkCreatureHit
		ldx globals::playerDeadAnimIdx
		bne Lab9e
		ldx #$08
Laba6		dex
		bmi Lab9e
		lda creatureActive,x
		beq Laba6
		lda creatureState,x
		bne Laba6
		lda creatureX,x
		sec
		sbc #$03
		cmp globals::spriteX
		bcs Laba6
		clc
		adc #$07
		cmp globals::spriteX
		bcc Laba6
		lda creatureY,x
		sec
		sbc #$0b
		cmp globals::spriteY
		bcs Laba6
		clc
		adc #$10
		cmp globals::spriteY
		bcc Laba6
		jmp killPlayer

