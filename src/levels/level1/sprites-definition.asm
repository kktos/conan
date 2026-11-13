;
; level 1 sprite headers, shapes $41-$49 (disk chunk c1, at $7500)
; defprite w, h, label: 7 pre-shifted copies; defpicture w, h, label: one copy
; (defsprite.macro.asm). h bit 7: draw with the LB000/LB200 tables.
; The bitmaps are in sprites.data.asm.
;

		placeAt	$7500

		; $41 - bat, frames by batSpriteTbl (data-R4-A200.asm)
		defprite	$03, $0A, spriteBat1
		; $42 - bat
		defprite	$03, $10, spriteBat2
		; $43 - bat
		defprite	$03, $10, spriteBat3
		; $44 - bat exploding, falling: $44 -> $46 -> $45 (animExplosionSeq)
		defprite	$04, $0B, spriteBatExplode1
		; $45 - bat exploding, last frame
		defprite	$04, $0C, spriteBatExplode3
		; $46 - bat exploding, second frame
		defprite	$03, $09, spriteBatExplode2
		; $47 - dust when it hits a ledge: $47 -> $49 (effectSpriteID)
		defprite	$03, $04, spriteDust1
		; $48 - dust
		defprite	$03, $04, spriteDust2
		; $49 - dust
		defprite	$03, $04, spriteDust3

; $7590-$75FF: leftover bytes (code), not headers
