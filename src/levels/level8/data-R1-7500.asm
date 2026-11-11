;
; level 8 shape headers, shapes $41-$49, disk chunk c1 ($7500-$75FF)
; 16 bytes each: width in bytes, height (bit 7: use the LB000/LB200 tables),
; 7 pointers (one per pre-shifted copy) into the bitmaps of data-R3-7A00.asm.
; The ending's text, drawn by drawBonusText: $41-$46 "BONUS!",
; $47 "2", $48 "0", $49 "x" (for "20000x").
; $7590-$75FF: leftover bytes, not read.
;

		placeAt $7500

	.hex
	02 87 00 7A 0E 7A 1C 7A 2A 7A 38 7A 46 7A 54 7A
	02 87 62 7A 70 7A 7E 7A 8C 7A 9A 7A A8 7A B6 7A
	02 87 C4 7A D2 7A E0 7A EE 7A FC 7A 0A 7B 18 7B
	02 87 26 7B 34 7B 42 7B 50 7B 5E 7B 6C 7B 7A 7B
	02 87 88 7B 96 7B A4 7B B2 7B C0 7B CE 7B DC 7B
	01 87 EA 7B F1 7B F8 7B FF 7B 06 7C 0D 7C 14 7C
	02 85 1B 7C 25 7C 2F 7C 39 7C 43 7C 4D 7C 57 7C
	02 85 61 7C 6B 7C 75 7C 7F 7C 89 7C 93 7C 9D 7C
	02 85 A7 7C B1 7C BB 7C C5 7C CF 7C D9 7C E3 7C
	16 16 C0 FA 16 50 C0 FA 16 50 C0 FA 16 50 C0 00
	00 00 00 00 00 00 00 00 00 00 80 D5 00 00 00 D4
	82 00 00 00 00 00 00 00 00 00 00 D4 8A 00 00 00
	00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.end
