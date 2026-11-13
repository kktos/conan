;
; level 4 sprite headers, shapes $41-$5D (disk chunk c1, at $7500)
; defsprite w, h, label: 7 pre-shifted copies; defpicture w, h, label: one copy
; (defsprite.macro.asm). h bit 7: draw with the LB000/LB200 tables.
; The bitmaps are in data-R3-7A00.asm.
;

		placeAt	$7500

		; $41 - creature walking (SHAPE_CREATURE)
		defsprite	$03, $88, spriteCreatureWalk
		; $42 - creature falling (SHAPE_CREATURE_FALL); $42-$44 jumping (jumpShapes)
		defsprite	$03, $08, spriteCreatureJump1
		; $43 - creature jumping
		defsprite	$03, $89, spriteCreatureJump2
		; $44 - creature jumping
		defsprite	$03, $89, spriteCreatureJump3
		; $45 - creature appearing ($48 down to $45) / dying ($45 up to $48)
		defsprite	$03, $08, spriteCreaturePop1
		; $46 - creature appearing / dying
		defsprite	$03, $08, spriteCreaturePop2
		; $47 - creature appearing / dying
		defsprite	$03, $08, spriteCreaturePop3
		; $48 - creature gone (SHAPE_CREATURE_GONE)
		defsprite	$03, $08, spriteCreaturePop4
		; $49 - player sinking, $49-$4C (sinkShapes)
		defsprite	$03, $8F, spriteSplash1
		; $4A - splash
		defsprite	$03, $8F, spriteSplash2
		; $4B - splash
		defsprite	$03, $8F, spriteSplash3
		; $4C - splash
		defsprite	$04, $8F, spriteSplash4
		; $4D - player sinking, the other sinkDir: $4D-$50 (sinkShapes+8), same bitmaps as $49-$4C
		defsprite	$03, $0F, spriteSplash1b
		; $4E - splash
		defsprite	$03, $0F, spriteSplash2b
		; $4F - splash
		defsprite	$03, $0F, spriteSplash3b
		; $50 - splash
		defsprite	$04, $0F, spriteSplash4b
		; $51 - geyser, $51-$53 cycling (SHAPE_GEYSER)
		defsprite	$02, $0F, spriteGeyser1
		; $52 - geyser
		defsprite	$02, $0F, spriteGeyser2
		; $53 - geyser
		defsprite	$02, $0F, spriteGeyser3
		; $54 - boulder (SHAPE_BOULDER)
		defsprite	$05, $85, spriteBoulder
		; $55 - boulder bursting, $54-$57 (burstShapes)
		defsprite	$05, $84, spriteBoulderBurst1
		; $56 - boulder bursting
		defsprite	$05, $84, spriteBoulderBurst2
		; $57 - boulder bursting
		defsprite	$05, $84, spriteBoulderBurst3
		; $58 - empty slot, slot 2's blinking marker (SHAPE_SLOT)
		defsprite	$03, $84, spriteSlot
		; $59 - water drop (SHAPE_DROP)
		defsprite	$02, $81, spriteDrop
		; $5A - boulder breaking, $5A-$5C (breakShapes)
		defsprite	$04, $88, spriteBoulderBreak1
		; $5B - boulder breaking
		defsprite	$05, $88, spriteBoulderBreak2
		; $5C - boulder breaking
		defsprite	$05, $88, spriteBoulderBreak3
		; $5D - blank 2x8 block, eraser drawn with drawStore (SHAPE_BLANK)
		defpicture	$02, $08, spriteBlank

; $75D0-$76FF: sector slack
