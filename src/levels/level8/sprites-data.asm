;
; level 8 sprite bitmaps (disk chunk c3, at $7A00), for the headers
; $41-$49 of sprites-definition.asm.
; A sprite is width x height bytes, rows top to bottom (7 pixels per byte,
; bit 0 first), one row per line below. defsprite sprites have 7 copies, one
; per X mod 7 shift; defpicture ones a single copy.
;

; $41 - "B" of "BONUS!" (drawBonusText)
; 2x7 bytes, 7 pre-shifted copies of 14 bytes ($0E)
spriteLetterB
		; shift 0
		.hex
			95 00
			c1 00
			c1 00
			95 00
			c1 00
			c1 00
			95 00
		.end
		; shift 1
		.hex
			aa 00
			82 81
			82 81
			aa 00
			82 81
			82 81
			aa 00
		.end
		; shift 2
		.hex
			d4 00
			84 82
			84 82
			d4 00
			84 82
			84 82
			d4 00
		.end
		; shift 3
		.hex
			a8 81
			88 84
			88 84
			a8 81
			88 84
			88 84
			a8 81
		.end
		; shift 4
		.hex
			d0 82
			90 88
			90 88
			d0 82
			90 88
			90 88
			d0 82
		.end
		; shift 5
		.hex
			a0 85
			a0 90
			a0 90
			a0 85
			a0 90
			a0 90
			a0 85
		.end
		; shift 6
		.hex
			c0 8a
			c0 a0
			c0 a0
			c0 8a
			c0 a0
			c0 a0
			c0 8a
		.end

; $42 - "O"
; 2x7 bytes, 7 pre-shifted copies of 14 bytes ($0E)
spriteLetterO
		; shift 0
		.hex
			94 00
			c1 00
			c1 00
			c1 00
			c1 00
			c1 00
			94 00
		.end
		; shift 1
		.hex
			a8 00
			82 81
			82 81
			82 81
			82 81
			82 81
			a8 00
		.end
		; shift 2
		.hex
			d0 00
			84 82
			84 82
			84 82
			84 82
			84 82
			d0 00
		.end
		; shift 3
		.hex
			a0 81
			88 84
			88 84
			88 84
			88 84
			88 84
			a0 81
		.end
		; shift 4
		.hex
			c0 82
			90 88
			90 88
			90 88
			90 88
			90 88
			c0 82
		.end
		; shift 5
		.hex
			00 85
			a0 90
			a0 90
			a0 90
			a0 90
			a0 90
			00 85
		.end
		; shift 6
		.hex
			00 8a
			c0 a0
			c0 a0
			c0 a0
			c0 a0
			c0 a0
			00 8a
		.end

; $43 - "N"
; 2x7 bytes, 7 pre-shifted copies of 14 bytes ($0E)
spriteLetterN
		; shift 0
		.hex
			c1 00
			c5 00
			c5 00
			d1 00
			d1 00
			c1 00
			c1 00
		.end
		; shift 1
		.hex
			82 81
			8a 81
			8a 81
			a2 81
			a2 81
			82 81
			82 81
		.end
		; shift 2
		.hex
			84 82
			94 82
			94 82
			c4 82
			c4 82
			84 82
			84 82
		.end
		; shift 3
		.hex
			88 84
			a8 84
			a8 84
			88 85
			88 85
			88 84
			88 84
		.end
		; shift 4
		.hex
			90 88
			d0 88
			d0 88
			90 8a
			90 8a
			90 88
			90 88
		.end
		; shift 5
		.hex
			a0 90
			a0 91
			a0 91
			a0 94
			a0 94
			a0 90
			a0 90
		.end
		; shift 6
		.hex
			c0 a0
			c0 a2
			c0 a2
			c0 a8
			c0 a8
			c0 a0
			c0 a0
		.end

; $44 - "U"
; 2x7 bytes, 7 pre-shifted copies of 14 bytes ($0E)
spriteLetterU
		; shift 0
		.hex
			c1 00
			c1 00
			c1 00
			c1 00
			c1 00
			c1 00
			94 00
		.end
		; shift 1
		.hex
			82 81
			82 81
			82 81
			82 81
			82 81
			82 81
			a8 00
		.end
		; shift 2
		.hex
			84 82
			84 82
			84 82
			84 82
			84 82
			84 82
			d0 00
		.end
		; shift 3
		.hex
			88 84
			88 84
			88 84
			88 84
			88 84
			88 84
			a0 81
		.end
		; shift 4
		.hex
			90 88
			90 88
			90 88
			90 88
			90 88
			90 88
			c0 82
		.end
		; shift 5
		.hex
			a0 90
			a0 90
			a0 90
			a0 90
			a0 90
			a0 90
			00 85
		.end
		; shift 6
		.hex
			c0 a0
			c0 a0
			c0 a0
			c0 a0
			c0 a0
			c0 a0
			00 8a
		.end

; $45 - "S"
; 2x7 bytes, 7 pre-shifted copies of 14 bytes ($0E)
spriteLetterS
		; shift 0
		.hex
			94 00
			c1 00
			81 00
			94 00
			c0 00
			c1 00
			94 00
		.end
		; shift 1
		.hex
			a8 00
			82 81
			82 00
			a8 00
			00 81
			82 81
			a8 00
		.end
		; shift 2
		.hex
			d0 00
			84 82
			84 00
			d0 00
			00 82
			84 82
			d0 00
		.end
		; shift 3
		.hex
			a0 81
			88 84
			88 00
			a0 81
			00 84
			88 84
			a0 81
		.end
		; shift 4
		.hex
			c0 82
			90 88
			90 00
			c0 82
			00 88
			90 88
			c0 82
		.end
		; shift 5
		.hex
			00 85
			a0 90
			a0 00
			00 85
			00 90
			a0 90
			00 85
		.end
		; shift 6
		.hex
			00 8a
			c0 a0
			c0 00
			00 8a
			00 a0
			c0 a0
			00 8a
		.end

; $46 - "!"
; 1x7 bytes, 7 pre-shifted copies of 7 bytes ($07)
spriteLetterExcl
		; shift 0
		.hex
			81
			81
			81
			81
			81
			00
			81
		.end
		; shift 1
		.hex
			82
			82
			82
			82
			82
			00
			82
		.end
		; shift 2
		.hex
			84
			84
			84
			84
			84
			00
			84
		.end
		; shift 3
		.hex
			88
			88
			88
			88
			88
			00
			88
		.end
		; shift 4
		.hex
			90
			90
			90
			90
			90
			00
			90
		.end
		; shift 5
		.hex
			a0
			a0
			a0
			a0
			a0
			00
			a0
		.end
		; shift 6
		.hex
			c0
			c0
			c0
			c0
			c0
			00
			c0
		.end

; $47 - "2" of "20000x"
; 2x5 bytes, 7 pre-shifted copies of 10 bytes ($0A)
spriteDigit2
		; shift 0
		.hex
			15 00
			10 00
			15 00
			01 00
			15 00
		.end
		; shift 1
		.hex
			2a 00
			20 00
			2a 00
			02 00
			2a 00
		.end
		; shift 2
		.hex
			54 00
			40 00
			54 00
			04 00
			54 00
		.end
		; shift 3
		.hex
			28 01
			00 01
			28 01
			08 00
			28 01
		.end
		; shift 4
		.hex
			50 02
			00 02
			50 02
			10 00
			50 02
		.end
		; shift 5
		.hex
			20 05
			00 04
			20 05
			20 00
			20 05
		.end
		; shift 6
		.hex
			40 0a
			00 08
			40 0a
			40 00
			40 0a
		.end

; $48 - "0"
; 2x5 bytes, 7 pre-shifted copies of 10 bytes ($0A)
spriteDigit0
		; shift 0
		.hex
			15 00
			11 00
			11 00
			11 00
			15 00
		.end
		; shift 1
		.hex
			2a 00
			22 00
			22 00
			22 00
			2a 00
		.end
		; shift 2
		.hex
			54 00
			44 00
			44 00
			44 00
			54 00
		.end
		; shift 3
		.hex
			28 01
			08 01
			08 01
			08 01
			28 01
		.end
		; shift 4
		.hex
			50 02
			10 02
			10 02
			10 02
			50 02
		.end
		; shift 5
		.hex
			20 05
			20 04
			20 04
			20 04
			20 05
		.end
		; shift 6
		.hex
			40 0a
			40 08
			40 08
			40 08
			40 0a
		.end

; $49 - "x"
; 2x5 bytes, 7 pre-shifted copies of 10 bytes ($0A)
spriteLetterX
		; shift 0
		.hex
			11 00
			11 00
			04 00
			11 00
			11 00
		.end
		; shift 1
		.hex
			22 00
			22 00
			08 00
			22 00
			22 00
		.end
		; shift 2
		.hex
			44 00
			44 00
			10 00
			44 00
			44 00
		.end
		; shift 3
		.hex
			08 01
			08 01
			20 00
			08 01
			08 01
		.end
		; shift 4
		.hex
			10 02
			10 02
			40 00
			10 02
			10 02
		.end
		; shift 5
		.hex
			20 04
			20 04
			00 01
			20 04
			20 04
		.end
		; shift 6
		.hex
			40 08
			40 08
			00 02
			40 08
			40 08
		.end

; $7CED-$7CFF: leftover bytes, not read (dropped)
