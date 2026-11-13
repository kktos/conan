;
; level 8 sprite headers, shapes $41-$49 (disk chunk c1, at $7500)
; defprite w, h, label: 7 pre-shifted copies; defpicture w, h, label: one copy
; (defsprite.macro.asm). h bit 7: draw with the LB000/LB200 tables.
; The bitmaps are in data-R3-7A00.asm.
;

		placeAt	$7500

		; $41 - "B" of "BONUS!" (drawBonusText)
		defprite	$02, $87, spriteLetterB
		; $42 - "O"
		defprite	$02, $87, spriteLetterO
		; $43 - "N"
		defprite	$02, $87, spriteLetterN
		; $44 - "U"
		defprite	$02, $87, spriteLetterU
		; $45 - "S"
		defprite	$02, $87, spriteLetterS
		; $46 - "!"
		defprite	$01, $87, spriteLetterExcl
		; $47 - "2" of "20000x"
		defprite	$02, $85, spriteDigit2
		; $48 - "0"
		defprite	$02, $85, spriteDigit0
		; $49 - "x"
		defprite	$02, $85, spriteLetterX

; $7590-$75FF: leftover bytes, not headers
