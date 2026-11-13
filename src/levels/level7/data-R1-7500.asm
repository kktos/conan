;
; level 7 sprite headers, shapes $41-$68 (disk chunk c1, at $7500)
; defsprite w, h, label: 7 pre-shifted copies; defpicture w, h, label: one copy
; (defsprite.macro.asm). h bit 7: draw with the LB000/LB200 tables.
; The bitmaps are in data-R3-7A00.asm.
;

		placeAt	$7500

		; $41 - ? not drawn by the level or the final animation
		defsprite	$03, $90, spriteUnused41
		; $42 - bat, $42-$45 flying (EOR 1), waiting at the door $42 / $43 (SHAPE_BAT)
		defsprite	$03, $0E, spriteBat1
		; $43 - bat
		defsprite	$03, $08, spriteBat2
		; $44 - bat
		defsprite	$03, $8E, spriteBat3
		; $45 - bat
		defsprite	$03, $88, spriteBat4
		; $46 - fireball, $46 / $47 (SHAPE_SHOT + shotKind, EOR 3)
		defsprite	$03, $0D, spriteFireball1
		; $47 - fireball
		defsprite	$03, $0C, spriteFireball2
		; $48 - the door (SHAPE_DOOR)
		defsprite	$02, $0E, spriteDoor
		; $49 - shot carrying a gem, $49 / $4A: same bitmaps as $46 / $47
		defsprite	$03, $8D, spriteShotGem1
		; $4A - shot carrying a gem
		defsprite	$03, $0C, spriteShotGem2
		; $4B - the figure throwing, $4B-$4E (SHAPE_VOLTA): same bitmap as level 0's $45
		defsprite	$03, $93, spriteVolta1
		; $4C - the figure throwing
		defsprite	$03, $93, spriteVolta2
		; $4D - the figure throwing
		defsprite	$03, $93, spriteVolta3
		; $4E - the figure throwing
		defsprite	$03, $12, spriteVolta4
		; $4F - the orbs and the dot (SHAPE_ORB)
		defsprite	$01, $01, spriteOrb
		; $50 - flame, first half (SHAPE_FLAME1 + flameFrame)
		defsprite	$02, $07, spriteFlame1A
		; $51 - flame, second half (SHAPE_FLAME2 + flameFrame)
		defsprite	$02, $07, spriteFlame2A
		; $52 - flame, first half, flameFrame 2
		defsprite	$02, $07, spriteFlame1B
		; $53 - flame, second half, flameFrame 2
		defsprite	$02, $07, spriteFlame2B
		; $54 - the bridge at the left, $54 / $55 flickering (SHAPE_BRIDGE)
		defsprite	$05, $82, spriteBridge1
		; $55 - the bridge
		defsprite	$05, $02, spriteBridge2
		; $56 - the prisoner in the final animation (actorAShape), $56-$59
		defsprite	$04, $8D, spritePrisonerFree1
		; $57 - the prisoner, final animation (makes a sound)
		defsprite	$04, $8B, spritePrisonerFree2
		; $58 - the prisoner, final animation: same bitmap as level 2's $47
		defsprite	$04, $8D, spritePrisonerFree3
		; $59 - the prisoner, final animation (makes a sound)
		defsprite	$04, $8B, spritePrisonerFree4
		; $5A - the prisoner, $5A / $5B (SHAPE_PRISONER + prisonerFrame)
		defsprite	$04, $8B, spritePrisoner1
		; $5B - the prisoner
		defsprite	$04, $8B, spritePrisoner2
		; $5C - spark running on the bridge (SHAPE_SPARK)
		defsprite	$01, $81, spriteSpark
		; $5D - EORed on the cage at the end (SHAPE_CAGE_OPEN)
		defsprite	$01, $0D, spriteCageOpen
		; $5E - flag, $5E-$61 (SHAPE_FLAG + flag1Frame / flag2Frame)
		defsprite	$02, $03, spriteFlag1
		; $5F - flag
		defsprite	$02, $03, spriteFlag2
		; $60 - flag
		defsprite	$02, $03, spriteFlag3
		; $61 - flag
		defsprite	$02, $03, spriteFlag4
		; $62 - splash, $62-$65 (splashShapes)
		defsprite	$03, $8F, spriteSplash1
		; $63 - splash
		defsprite	$03, $8F, spriteSplash2
		; $64 - splash
		defsprite	$03, $8F, spriteSplash3
		; $65 - splash
		defsprite	$04, $8F, spriteSplash4
		; $66 - bat dying, $66 / $67 (batDieShapes)
		defsprite	$03, $8F, spriteBatDie1
		; $67 - bat dying
		defsprite	$03, $8E, spriteBatDie2
		; $68 - lever (SHAPE_LEVER)
		defsprite	$02, $04, spriteLever

; $7780-$77FF: leftover bytes, not headers

; the bats' routes, read by nextBatStep: 4 routes of 32 steps, by
; batRoute * 32 + batStep; a step of batRouteTime frames moving by
; batRouteDX / DY (data-R3-7A00.asm) with batRouteShape ($42 / $44, EOR 1
; every frame), a 0 shape ends the route
		placeAt	$7800

batRouteTime	.db	$40, $09, $13, $0B, $08, $17, $09, $06, $11, $05, $05, $05, $08, $04, $07, $14
		.db	$07, $05, $20, $06, $13, $04, $11, $11, $0F, $02, $07, $08, $00, $00, $00, $00
		.db	$20, $08, $12, $09, $07, $21, $08, $0B, $0E, $06, $07, $07, $11, $05, $07, $04
		.db	$19, $08, $0B, $0C, $29, $0C, $09, $0A, $05, $03, $0C, $1B, $19, $00, $00, $00
		.db	$06, $2B, $09, $05, $04, $1B, $08, $0A, $26, $05, $06, $05, $0A, $14, $09, $11
		.db	$06, $0D, $04, $03, $13, $05, $14, $12, $00, $00, $00, $00, $00, $00, $00, $00
		.db	$26, $05, $0F, $0B, $11, $07, $0C, $0B, $05, $0D, $16, $05, $03, $02, $0B, $03
		.db	$03, $05, $09, $0A, $0F, $2A, $04, $05, $06, $03, $07, $12, $07, $11, $00, $00
batRouteShape	.db	$42, $44, $44, $44, $44, $44, $42, $44, $42, $42, $42, $44, $44, $44, $44, $44
		.db	$42, $44, $42, $42, $42, $44, $44, $42, $42, $44, $44, $44, $00, $00, $00, $00
		.db	$42, $42, $44, $42, $42, $42, $44, $44, $42, $42, $44, $44, $44, $44, $42, $42
		.db	$42, $44, $44, $44, $44, $42, $42, $44, $44, $44, $42, $42, $44, $00, $00, $00
		.db	$42, $42, $44, $44, $44, $44, $42, $44, $44, $42, $42, $44, $42, $42, $44, $44
		.db	$42, $42, $44, $44, $44, $42, $42, $42, $00, $00, $00, $00, $00, $00, $00, $00
		.db	$42, $42, $42, $44, $44, $44, $44, $44, $42, $44, $42, $42, $42, $42, $42, $44
		.db	$42, $42, $44, $42, $42, $42, $44, $44, $44, $42, $44, $44, $42, $42, $00, $00
