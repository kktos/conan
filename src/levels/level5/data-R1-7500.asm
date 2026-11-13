;
; level 5 sprite headers, shapes $41-$56 (disk chunk c1, at $7500)
; defsprite w, h, label: 7 pre-shifted copies; defpicture w, h, label: one copy
; (defsprite.macro.asm). h bit 7: draw with the LB000/LB200 tables.
; The bitmaps are in data-R3-7A00.asm.
;

		placeAt	$7500

		; $41 - walker going left, $41 / $42 (SHAPE_WALKER_L, EOR 3)
		defsprite	$05, $8E, spriteWalkerL1
		; $42 - walker going left
		defsprite	$05, $93, spriteWalkerL2
		; $43 - walker going right, $43 / $44 (SHAPE_WALKER_R, EOR 7)
		defsprite	$05, $0E, spriteWalkerR1
		; $44 - walker going right
		defsprite	$05, $13, spriteWalkerR2
		; $45 - walker dying, going left (SHAPE_WALKER_DIE_L)
		defsprite	$05, $8E, spriteWalkerDieL
		; $46 - walker dying, going right (SHAPE_WALKER_DIE_R)
		defsprite	$05, $0E, spriteWalkerDieR
		; $47 - walker's shot going left (SHAPE_SHOT_L)
		defsprite	$03, $84, spriteShotL
		; $48 - walker's shot going right (SHAPE_SHOT_R)
		defsprite	$03, $84, spriteShotR
		; $49 - burrower walking, $49 / $4A (SHAPE_BURROWER, EOR 3)
		defsprite	$03, $8C, spriteBurrower1
		; $4A - burrower walking
		defsprite	$03, $8E, spriteBurrower2
		; $4B - burrower going into the ground, $4B-$4D
		defsprite	$03, $89, spriteBurrowerIn1
		; $4C - burrower going into the ground
		defsprite	$03, $84, spriteBurrowerIn2
		; $4D - burrower deepest in the ground (SHAPE_BURROWER_IN)
		defsprite	$03, $83, spriteBurrowerIn3
		; $4E - fire, frame 0, first half (SHAPE_FIRE + fireFrame)
		defsprite	$03, $14, spriteFire1A
		; $4F - fire, frame 0, second half
		defsprite	$03, $14, spriteFire1B
		; $50 - fire, frame 1, first half
		defsprite	$03, $14, spriteFire2A
		; $51 - fire, frame 1, second half
		defsprite	$03, $14, spriteFire2B
		; $52 - portal bar (SHAPE_BAR)
		defsprite	$02, $8F, spriteBar
		; $53 - splash, $53-$56 (splashShapes)
		defsprite	$03, $8F, spriteSplash1
		; $54 - splash
		defsprite	$03, $8F, spriteSplash2
		; $55 - splash
		defsprite	$03, $8F, spriteSplash3
		; $56 - splash
		defsprite	$04, $8F, spriteSplash4

; $7660-$76FF: sector slack (DOS BLOAD text)
