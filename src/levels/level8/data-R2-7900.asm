;
; level 8 variables, disk chunk c2 ($7900-$79FF)
; private RAM of the level code, initial values from the disk.
;

		placeAt $7900

; the 12 characters of "BONUS!" / "20000x", drawn by drawBonusText (11..0)
textX		.db $30, $35, $3A, $40, $45, $4A	; B O N U S !
		.db $2C, $30, $34, $38, $3C, $42	; 2 0 0 0 0 x, then the life icons from X $48
; $790C-$790F: not referenced, leftover memory from an align
		.align $10
textY		.db $94, $94, $94, $94, $94, $94
		.db $A0, $A0, $A0, $A0, $A0, $A0
; $791C-$791F: not referenced, leftover memory from an align
		.align $10
textShape	.db $41, $42, $43, $44, $45, $46	; shapes of data-R1-7500.asm
		.db $47, $48, $48, $48, $48, $49
; $792C-$792F: not referenced, leftover memory from an align
		.align $10
textIdx		.db $00			; drawBonusText's loop index, $0B..0
tonePeriod	.db $00			; sweepTone's period: 1, then $FF down to $A3 by 2
iconN		.db $01			; the next life icon: n-th, at X $48 + 6 * (n - 1), Y $9E
