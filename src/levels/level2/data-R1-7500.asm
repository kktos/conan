;
; level 2 sprite headers, shapes $41-$4A (disk chunk c1, at $7500)
; defprite w, h, label: 7 pre-shifted copies; defpicture w, h, label: one copy
; (defsprite.macro.asm). h bit 7: draw with the LB000/LB200 tables.
; The bitmaps are in data-R3-7A00.asm.
;

		placeAt	$7500

		; $41 - splash when the player falls in the water, $41-$44
		defprite	$03, $0F, spriteSplash1
		; $42 - splash
		defprite	$03, $0F, spriteSplash2
		; $43 - splash
		defprite	$03, $0F, spriteSplash3
		; $44 - splash
		defprite	$04, $0F, spriteSplash4
		; $45 - cloud (top, Y=$01)
		defprite	$06, $0A, spriteCloud1
		; $46 - cloud (Y=$1A)
		defprite	$06, $0B, spriteCloud2
		; $47 - bird (the avian ally), 13 lines: same bitmap as level 7's $58
		defprite	$04, $8D, spriteBird1
		; $48 - bird, 13 lines
		defprite	$04, $8D, spriteBird2
		; $49 - bird, 17 lines: same bitmap as level 0's $48 (bird landed)
		defprite	$04, $91, spriteBird3
		; $4A - bird, 17 lines
		defprite	$04, $91, spriteBird4

; $75A0-$75FF: leftover bytes (code), not headers
