;
; level 6 sprite headers, shapes $41-$70 (disk chunk c1, at $7500)
; defprite w, h, label: 7 pre-shifted copies; defpicture w, h, label: one copy
; (defsprite.macro.asm). h bit 7: draw with the LB000/LB200 tables.
; The bitmaps are in data-R3-7A00.asm.
;

		placeAt	$7500

		; $41 - mover flying, $41-$43 (moverScriptShape); shot with the axe to build the ladder
		defprite	$03, $07, spriteMover1
		; $42 - mover
		defprite	$03, $07, spriteMover2
		; $43 - mover, also the first frame of moverHitShapes (SHAPE_MOVER_HIT)
		defprite	$03, $87, spriteMover3
		; $44 - the riser in the centre machine, $44-$46 (decorShape)
		defprite	$02, $01, spriteRiser1
		; $45 - riser
		defprite	$02, $02, spriteRiser2
		; $46 - riser
		defprite	$02, $02, spriteRiser3
		; $47 - blinker under the machine (SHAPE_BLINK1)
		defprite	$02, $03, spriteBlink1
		; $48 - blinker (SHAPE_BLINK2)
		defprite	$02, $03, spriteBlink2
		; $49 - lamp (SHAPE_LAMP)
		defprite	$01, $05, spriteLamp
		; $4A - ladder rung (SHAPE_RUNG)
		defprite	$02, $86, spriteRung
		; $4B - gate, first piece, frame 0 (SHAPE_GATE1 + gateFrame)
		defprite	$02, $02, spriteGate1A
		; $4C - gate, first piece, frame 1
		defprite	$02, $02, spriteGate1B
		; $4D - gate, second piece, frame 0 (SHAPE_GATE2 + gateFrame)
		defprite	$02, $02, spriteGate2A
		; $4E - gate, second piece, frame 1
		defprite	$02, $02, spriteGate2B
		; $4F - lower platform (SHAPE_LOWER_PLAT)
		defprite	$04, $82, spriteLowerPlat
		; $50 - upper platform (SHAPE_UPPER_PLAT)
		defprite	$04, $82, spriteUpperPlat
		; $51 - monster flying out, right arc, $51 / $52 (spawnShape)
		defprite	$03, $03, spriteSpawnR1
		; $52 - monster flying out, right arc
		defprite	$03, $03, spriteSpawnR2
		; $53 - monster flying out, left arc, $53 / $54
		defprite	$03, $03, spriteSpawnL1
		; $54 - monster flying out, left arc
		defprite	$03, $03, spriteSpawnL2
		; $55 - lightning bolt (SHAPE_BOLT + boltFrame)
		defprite	$03, $20, spriteBolt1
		; $56 - lightning bolt
		defprite	$03, $20, spriteBolt2
		; $57 - monster walking, $57 / $58 (SHAPE_MONSTER)
		defprite	$03, $09, spriteMonster1
		; $58 - monster walking (SHAPE_MONSTER2)
		defprite	$03, $0A, spriteMonster2
		; $59 - monster landing (end of the arc) / dying, $59 / $5A
		defprite	$03, $05, spriteMonsterLand1
		; $5A - monster landing / dying
		defprite	$03, $05, spriteMonsterLand2
		; $5B - flame guarding the exit, first half (SHAPE_FLAME1 + flameFrame)
		defprite	$02, $0E, spriteFlame1A
		; $5C - flame, second half (SHAPE_FLAME2 + flameFrame)
		defprite	$02, $0E, spriteFlame2A
		; $5D - flame, first half, flameFrame 2
		defprite	$02, $0E, spriteFlame1B
		; $5E - flame, second half, flameFrame 2
		defprite	$02, $0E, spriteFlame2B
		; $5F - player leaving (SHAPE_LEAVE)
		defprite	$03, $10, spriteLeave
		; $60 - mover hit, shrinking, $60-$62 (moverHitShapes)
		defprite	$03, $86, spriteMoverHit1
		; $61 - mover hit
		defprite	$03, $85, spriteMoverHit2
		; $62 - mover hit
		defprite	$03, $84, spriteMoverHit3

		; $7720-$773F (shapes $63 / $64): leftover bytes, not headers
		placeAt	$7500 + ($65 - $41) * 16

		; $65-$70: pointers into the core's shape bitmaps ($5E14-$6712), not used by the level
		defprite	$02, $85, $5E14
		defprite	$02, $88, $5E5A
		defprite	$03, $83, $5ECA
		defprite	$02, $85, $5F09
		defprite	$02, $84, $5F4F
		defprite	$03, $12, $5F87
		defprite	$03, $8D, $6101
		defprite	$03, $0C, $6212
		defprite	$03, $0D, $630E
		defprite	$03, $8C, $641F
		defprite	$03, $0C, $651B
		defprite	$03, $8C, $6617
