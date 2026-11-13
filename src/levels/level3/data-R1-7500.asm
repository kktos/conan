;
; level 3 sprite headers, shapes $41-$58 (disk chunk c1, at $7500)
; defprite w, h, label: 7 pre-shifted copies; defpicture w, h, label: one copy
; (defsprite.macro.asm). h bit 7: draw with the LB000/LB200 tables.
; The bitmaps are in data-R3-7A00.asm.
;

		placeAt	$7500

		; $41 - lift going up (SHAPE_LIFT)
		defprite	$05, $15, spriteLift
		; $42 - lift arrived (SHAPE_LIFT_TOP)
		defprite	$05, $15, spriteLiftTop
		; $43 - lift breaking up (SHAPE_LIFT_GONE)
		defprite	$05, $18, spriteLiftGone
		; $44 - monster, $44 / $45 (EOR 1 when turning around)
		defprite	$04, $08, spriteMonster1
		; $45 - monster
		defprite	$04, $08, spriteMonster2
		; $46 - monster, $46 / $47
		defprite	$03, $07, spriteMonster3
		; $47 - monster
		defprite	$03, $07, spriteMonster4
		; $48 - portal, $48 / $49 toggled each frame
		defprite	$03, $16, spritePortal1
		; $49 - portal
		defprite	$03, $16, spritePortal2
		; $4A - bird flying: same bitmap as level 0's $47
		defprite	$04, $8D, spriteBirdFlying
		; $4B - bird landed: same bitmap as level 0's $48
		defprite	$04, $91, spriteBirdLanded
		; $4C - bubble rising (bubbleShapes)
		defprite	$02, $83, spriteBubble1
		; $4D - bubble
		defprite	$02, $83, spriteBubble2
		; $4E - bubble bursting
		defprite	$02, $82, spriteBubble3
		; $4F - player sinking in the pool, $4F-$52 (sinkShapes)
		defprite	$03, $8F, spriteSplash1
		; $50 - splash
		defprite	$03, $8F, spriteSplash2
		; $51 - splash
		defprite	$03, $8F, spriteSplash3
		; $52 - splash
		defprite	$04, $8F, spriteSplash4
		; $53 - unused: points past $9300, the end of c3
		; defprite	$04, $8C, $9295
		; $54 - unused: points past $9300, the end of c3
		; defprite	$04, $8B, $93E5
		; $55 - unused: points past $9300, the end of c3
		; defprite	$03, $8B, $9519
		; $56 - unused: points inside $4A / $4B
		; defprite	$05, $90, $8A76
		; $57 - unused: points inside $4B-$4F
		; defprite	$04, $10, $8CA6
		; $58 - unused: points inside $4F-$51
		; defprite	$05, $10, $8E66

; $7680-$76FF: sector slack
