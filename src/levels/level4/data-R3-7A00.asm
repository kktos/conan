;
; level 4 sprite bitmaps (disk chunk c3, at $7A00), for the headers
; $41-$5D of data-R1-7500.asm.
; A sprite is width x height bytes, rows top to bottom (7 pixels per byte,
; bit 0 first), one row per line below. defprite sprites have 7 copies, one
; per X mod 7 shift; defpicture ones a single copy.
; Then the water drops' paths and the key's state, read and written by the
; level code.
;

		placeAt	$7A00

; $41 - creature walking (SHAPE_CREATURE)
; 3x8 bytes, 7 pre-shifted copies of 24 bytes ($18)
spriteCreatureWalk
		; shift 0
		.hex
			00 00 00
			00 00 00
			00 03 00
			60 0f 00
			78 3f 00
			1c 71 00
			20 04 00
			0a 50 00
		.end
		; shift 1
		.hex
			00 00 00
			00 06 00
			40 1f 00
			70 7f 00
			38 62 01
			40 08 00
			10 20 00
			14 20 01
		.end
		; shift 2
		.hex
			00 00 00
			00 0c 00
			00 3f 00
			60 7f 01
			70 44 03
			00 11 00
			20 40 00
			28 40 02
		.end
		; shift 3
		.hex
			00 00 00
			00 18 00
			00 7e 00
			40 7f 03
			60 09 07
			00 22 00
			40 00 01
			50 00 05
		.end
		; shift 4
		.hex
			00 30 00
			00 7c 01
			00 7f 07
			40 13 0e
			00 44 00
			00 44 00
			00 44 00
			00 45 02
		.end
		; shift 5
		.hex
			00 00 00
			00 00 00
			00 60 00
			00 78 03
			00 7e 0f
			00 27 1c
			00 08 01
			40 02 14
		.end
		; shift 6
		.hex
			00 40 01
			00 70 07
			00 7c 1f
			00 4e 38
			00 10 02
			00 10 02
			00 10 02
			00 14 0a
		.end

; $42 - creature falling (SHAPE_CREATURE_FALL); $42-$44 jumping (jumpShapes)
; 3x8 bytes, 7 pre-shifted copies of 24 bytes ($18)
spriteCreatureJump1
		; shift 0
		.hex
			40 01 00
			70 07 00
			7c 1f 00
			4e 38 00
			10 02 00
			04 08 00
			04 08 00
			01 20 00
		.end
		; shift 1
		.hex
			00 03 00
			60 0f 00
			78 3f 00
			1c 71 00
			20 04 00
			08 10 00
			08 10 00
			02 40 00
		.end
		; shift 2
		.hex
			00 06 00
			40 1f 00
			70 7f 00
			38 62 01
			40 08 00
			10 20 00
			10 20 00
			04 00 01
		.end
		; shift 3
		.hex
			00 0c 00
			00 3f 00
			60 7f 01
			70 44 03
			00 11 00
			20 40 00
			20 40 00
			08 00 02
		.end
		; shift 4
		.hex
			00 18 00
			00 7e 00
			40 7f 03
			60 09 07
			00 22 00
			40 00 01
			40 00 01
			10 00 04
		.end
		; shift 5
		.hex
			00 30 00
			00 7c 01
			00 7f 07
			40 13 0e
			00 44 00
			00 01 02
			00 01 02
			20 00 08
		.end
		; shift 6
		.hex
			00 60 00
			00 78 03
			00 7e 0f
			00 27 1c
			00 08 01
			00 02 04
			00 02 04
			40 00 10
		.end

; $43 - creature jumping
; 3x9 bytes, 7 pre-shifted copies of 27 bytes ($1B)
spriteCreatureJump2
		; shift 0
		.hex
			60 00 00
			78 03 00
			7e 0f 00
			27 1c 00
			08 01 00
			08 01 00
			08 01 00
			08 01 00
			02 04 00
		.end
		; shift 1
		.hex
			40 01 00
			70 07 00
			7c 1f 00
			4e 38 00
			10 02 00
			10 02 00
			10 02 00
			10 02 00
			04 08 00
		.end
		; shift 2
		.hex
			00 03 00
			60 0f 00
			78 3f 00
			1c 71 00
			20 04 00
			20 04 00
			20 04 00
			20 04 00
			08 10 00
		.end
		; shift 3
		.hex
			00 06 00
			40 1f 00
			70 7f 00
			38 62 01
			40 08 00
			40 08 00
			40 08 00
			40 08 00
			10 20 00
		.end
		; shift 4
		.hex
			00 0c 00
			00 3f 00
			60 7f 01
			70 44 03
			00 11 00
			00 11 00
			00 11 00
			00 11 00
			20 40 00
		.end
		; shift 5
		.hex
			00 18 00
			00 7e 00
			40 7f 03
			60 09 07
			00 22 00
			00 22 00
			00 22 00
			00 22 00
			40 00 01
		.end
		; shift 6
		.hex
			00 30 00
			00 7c 01
			00 7f 07
			40 13 0e
			00 44 00
			00 44 00
			00 44 00
			00 44 00
			00 01 02
		.end

; $44 - creature jumping
; 3x9 bytes, 7 pre-shifted copies of 27 bytes ($1B)
spriteCreatureJump3
		; shift 0
		.hex
			60 00 00
			78 03 00
			7e 0f 00
			27 1c 00
			08 01 00
			08 01 00
			08 01 00
			08 01 00
			20 00 00
		.end
		; shift 1
		.hex
			40 01 00
			70 07 00
			7c 1f 00
			4e 38 00
			10 02 00
			10 02 00
			10 02 00
			10 02 00
			40 00 00
		.end
		; shift 2
		.hex
			00 03 00
			60 0f 00
			78 3f 00
			1c 71 00
			20 04 00
			20 04 00
			20 04 00
			20 04 00
			00 01 00
		.end
		; shift 3
		.hex
			00 06 00
			40 1f 00
			70 7f 00
			38 62 01
			40 08 00
			40 08 00
			40 08 00
			40 08 00
			00 02 00
		.end
		; shift 4
		.hex
			00 0c 00
			00 3f 00
			60 7f 01
			70 44 03
			00 11 00
			00 11 00
			00 11 00
			00 11 00
			00 04 00
		.end
		; shift 5
		.hex
			00 18 00
			00 7e 00
			40 7f 03
			60 09 07
			00 22 00
			00 22 00
			00 22 00
			00 22 00
			00 08 00
		.end
		; shift 6
		.hex
			00 30 00
			00 7c 01
			00 7f 07
			40 13 0e
			00 44 00
			00 44 00
			00 44 00
			00 44 00
			00 10 00
		.end

; $45 - creature appearing ($48 down to $45) / dying ($45 up to $48)
; 3x8 bytes, 7 pre-shifted copies of 24 bytes ($18)
spriteCreaturePop1
		; shift 0
		.hex
			00 00 00
			00 00 00
			40 00 00
			60 07 00
			6c 16 00
			46 38 00
			10 02 00
			01 28 00
		.end
		; shift 1
		.hex
			00 00 00
			00 00 00
			00 01 00
			40 0f 00
			58 2d 00
			0c 71 00
			20 04 00
			02 50 00
		.end
		; shift 2
		.hex
			00 00 00
			00 00 00
			00 02 00
			00 1f 00
			30 5b 00
			18 62 01
			40 08 00
			04 20 01
		.end
		; shift 3
		.hex
			00 00 00
			00 00 00
			00 04 00
			00 3e 00
			60 36 01
			30 44 03
			00 11 00
			08 40 02
		.end
		; shift 4
		.hex
			00 00 00
			00 00 00
			00 08 00
			00 7c 00
			40 6d 02
			60 08 07
			00 22 00
			10 00 05
		.end
		; shift 5
		.hex
			00 00 00
			00 00 00
			00 10 00
			00 78 01
			00 5b 05
			40 11 0e
			00 44 00
			20 00 0a
		.end
		; shift 6
		.hex
			00 00 00
			00 00 00
			00 20 00
			00 70 03
			00 36 0b
			00 23 1c
			00 08 01
			40 00 14
		.end

; $46 - creature appearing / dying
; 3x8 bytes, 7 pre-shifted copies of 24 bytes ($18)
spriteCreaturePop2
		; shift 0
		.hex
			00 00 00
			00 00 00
			40 00 00
			60 02 00
			28 14 00
			42 28 00
			10 02 00
			01 08 00
		.end
		; shift 1
		.hex
			00 00 00
			00 00 00
			00 01 00
			40 05 00
			50 28 00
			04 51 00
			20 04 00
			02 10 00
		.end
		; shift 2
		.hex
			00 00 00
			00 00 00
			00 02 00
			00 0b 00
			20 51 00
			08 22 01
			40 08 00
			04 20 00
		.end
		; shift 3
		.hex
			00 00 00
			00 00 00
			00 04 00
			00 16 00
			40 22 01
			10 44 02
			00 11 00
			08 40 00
		.end
		; shift 4
		.hex
			00 00 00
			00 00 00
			00 08 00
			00 2c 00
			00 45 02
			20 08 05
			00 22 00
			10 00 01
		.end
		; shift 5
		.hex
			00 00 00
			00 00 00
			00 10 00
			00 58 00
			00 0a 05
			40 10 0a
			00 44 00
			20 00 02
		.end
		; shift 6
		.hex
			00 00 00
			00 00 00
			00 20 00
			00 30 01
			00 14 0a
			00 21 14
			00 08 01
			40 00 04
		.end

; $47 - creature appearing / dying
; 3x8 bytes, 7 pre-shifted copies of 24 bytes ($18)
spriteCreaturePop3
		; shift 0
		.hex
			00 00 00
			00 00 00
			40 00 00
			00 02 00
			28 10 00
			00 08 00
			00 02 00
			01 08 00
		.end
		; shift 1
		.hex
			00 00 00
			00 00 00
			00 01 00
			00 04 00
			50 20 00
			00 10 00
			00 04 00
			02 10 00
		.end
		; shift 2
		.hex
			00 00 00
			00 00 00
			00 02 00
			00 08 00
			20 41 00
			00 20 00
			00 08 00
			04 20 00
		.end
		; shift 3
		.hex
			00 00 00
			00 00 00
			00 04 00
			00 10 00
			40 02 01
			00 40 00
			00 10 00
			08 40 00
		.end
		; shift 4
		.hex
			00 00 00
			00 00 00
			00 08 00
			00 20 00
			00 05 02
			00 00 01
			00 20 00
			10 00 01
		.end
		; shift 5
		.hex
			00 00 00
			00 00 00
			00 10 00
			00 40 00
			00 0a 04
			00 00 02
			00 40 00
			20 00 02
		.end
		; shift 6
		.hex
			00 00 00
			00 00 00
			00 20 00
			00 00 01
			00 14 08
			00 00 04
			00 00 01
			40 00 04
		.end

; $48 - creature gone (SHAPE_CREATURE_GONE)
; 3x8 bytes, 7 pre-shifted copies of 24 bytes ($18)
spriteCreaturePop4
		; shift 0
		.hex
			00 00 00
			00 00 00
			40 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			01 08 00
		.end
		; shift 1
		.hex
			00 00 00
			00 00 00
			00 01 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			02 10 00
		.end
		; shift 2
		.hex
			00 00 00
			00 00 00
			00 02 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			04 20 00
		.end
		; shift 3
		.hex
			00 00 00
			00 00 00
			00 04 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			08 40 00
		.end
		; shift 4
		.hex
			00 00 00
			00 00 00
			00 08 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			10 00 01
		.end
		; shift 5
		.hex
			00 00 00
			00 00 00
			00 10 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			20 00 02
		.end
		; shift 6
		.hex
			00 00 00
			00 00 00
			00 20 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			40 00 04
		.end

; $49 - player sinking, $49-$4C (sinkShapes)
; 3x15 bytes, 7 pre-shifted copies of 45 bytes ($2D)
spriteSplash1
		; shift 0
		.hex
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 a2 00
			00 ae 00
			c0 8a 81
		.end
		; shift 1
		.hex
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 c4 00
			00 dc 00
			00 95 82
		.end
		; shift 2
		.hex
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 88 81
			00 b8 81
			00 aa 84
		.end
		; shift 3
		.hex
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 90 82
			00 f0 82
			00 d4 88
		.end
		; shift 4
		.hex
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 a0 84
			00 e0 85
			00 a8 91
		.end
		; shift 5
		.hex
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 c0 88
			00 c0 8b
			00 d0 a2
		.end
		; shift 6
		.hex
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 91
			00 00 97
			00 a0 c5
		.end

; $4A - splash
; 3x15 bytes, 7 pre-shifted copies of 45 bytes ($2D)
spriteSplash2
		; shift 0
		.hex
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 82 00
			00 a0 00
			00 a2 00
			c0 ba 00
			c0 ae 00
			d0 88 81
		.end
		; shift 1
		.hex
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 84 00
			00 c0 00
			00 c4 00
			00 f5 00
			00 dd 00
			a0 91 82
		.end
		; shift 2
		.hex
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 88 00
			00 00 81
			00 88 81
			00 ea 81
			00 ba 81
			c0 a2 84
		.end
		; shift 3
		.hex
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 90 00
			00 00 82
			00 90 82
			00 d4 83
			00 f4 82
			00 c5 88
		.end
		; shift 4
		.hex
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 a0 00
			00 00 84
			00 a0 84
			00 a8 87
			00 e8 85
			00 8a 91
		.end
		; shift 5
		.hex
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 c0 00
			00 00 88
			00 c0 88
			00 d0 8e
			00 d0 8b
			00 94 a2
		.end
		; shift 6
		.hex
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 81
			00 00 90
			00 00 91
			00 a0 9d
			00 a0 97
			00 a8 c4
		.end

; $4B - splash
; 3x15 bytes, 7 pre-shifted copies of 45 bytes ($2D)
spriteSplash3
		; shift 0
		.hex
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			c0 00 00
			00 00 00
			00 a0 00
			c4 86 00
			d0 8b 00
			dc b2 00
			c4 a6 00
			c0 82 00
			c0 83 00
			c0 9a 00
			d0 a8 00
		.end
		; shift 1
		.hex
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 81 00
			00 00 00
			00 c0 00
			88 8d 00
			a0 97 00
			b8 e5 00
			88 cd 00
			00 85 00
			00 87 00
			00 b5 00
			a0 d1 00
		.end
		; shift 2
		.hex
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 82 00
			00 00 00
			00 00 81
			90 9a 00
			c0 ae 00
			f0 ca 81
			90 9a 81
			00 8a 00
			00 8e 00
			00 ea 00
			c0 a2 81
		.end
		; shift 3
		.hex
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 84 00
			00 00 00
			00 00 82
			a0 b4 00
			00 dd 00
			e0 95 83
			a0 b4 82
			00 94 00
			00 9c 00
			00 d4 81
			00 c5 82
		.end
		; shift 4
		.hex
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 88 00
			00 00 00
			00 00 84
			c0 e8 00
			00 ba 81
			c0 ab 86
			c0 e8 84
			00 a8 00
			00 b8 00
			00 a8 83
			00 8a 85
		.end
		; shift 5
		.hex
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 90 00
			00 00 00
			00 00 88
			00 d1 81
			00 f4 82
			00 d7 8c
			00 d1 89
			00 d0 00
			00 f0 00
			00 d0 86
			00 94 8a
		.end
		; shift 6
		.hex
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 a0 00
			00 00 00
			00 00 90
			00 a2 83
			00 e8 85
			00 ae 99
			00 a2 93
			00 a0 81
			00 e0 81
			00 a0 8d
			00 a8 94
		.end

; $4C - splash
; 4x15 bytes, 7 pre-shifted copies of 60 bytes ($3C)
spriteSplash4
		; shift 0
		.hex
			c0 00 00 00
			00 82 00 00
			84 a0 00 00
			00 00 00 00
			b1 98 84 00
			dc eb 00 00
			d4 ae 81 00
			c5 8a 85 00
			c0 8e 00 00
			c4 8a 81 00
			c0 9a 00 00
			c0 8b 00 00
			c0 8a 00 00
			d0 aa 00 00
			c7 8e 85 00
		.end
		; shift 1
		.hex
			00 81 00 00
			00 84 00 00
			88 c0 00 00
			00 00 00 00
			e2 b0 88 00
			b8 d7 81 00
			a8 dd 82 00
			8a 95 8a 00
			00 9d 00 00
			88 95 82 00
			00 b5 00 00
			00 97 00 00
			00 95 00 00
			a0 d5 00 00
			8e 9d 8a 00
		.end
		; shift 2
		.hex
			00 82 00 00
			00 88 00 00
			90 00 81 00
			00 00 00 00
			c4 e1 90 00
			f0 ae 83 00
			d0 ba 85 00
			94 aa 94 00
			00 ba 00 00
			90 aa 84 00
			00 ea 00 00
			00 ae 00 00
			00 aa 00 00
			c0 aa 81 00
			9c ba 94 00
		.end
		; shift 3
		.hex
			00 84 00 00
			00 90 00 00
			a0 00 82 00
			00 00 00 00
			88 c3 a1 00
			e0 dd 86 00
			a0 f5 8a 00
			a8 d4 a8 00
			00 f4 00 00
			a0 d4 88 00
			00 d4 81 00
			00 dc 00 00
			00 d4 00 00
			00 d5 82 00
			b8 f4 a8 00
		.end
		; shift 4
		.hex
			00 88 00 00
			00 a0 00 00
			c0 00 84 00
			00 00 00 00
			90 86 c3 00
			c0 bb 8d 00
			c0 ea 95 00
			d0 a8 d1 00
			00 e8 81 00
			c0 a8 91 00
			00 a8 83 00
			00 b8 81 00
			00 a8 81 00
			00 aa 85 00
			f0 e8 d1 00
		.end
		; shift 5
		.hex
			00 90 00 00
			00 c0 00 00
			00 81 88 00
			00 00 00 00
			a0 8c 86 81
			00 f7 9a 00
			00 d5 ab 00
			a0 d1 a2 81
			00 d0 83 00
			00 d1 a2 00
			00 d0 86 00
			00 f0 82 00
			00 d0 82 00
			00 d4 8a 00
			e0 d1 a3 81
		.end
		; shift 6
		.hex
			00 a0 00 00
			00 00 81 00
			00 82 90 00
			00 00 00 00
			c0 98 8c 82
			00 ee b5 00
			00 aa d7 00
			c0 a2 c5 82
			00 a0 87 00
			00 a2 c5 00
			00 a0 8d 00
			00 e0 85 00
			00 a0 85 00
			00 a8 95 00
			c0 a3 c7 82
		.end

; $4D - player sinking, the other sinkDir: $4D-$50 (sinkShapes+8), same bitmaps as $49-$4C
; 3x15 bytes, 7 pre-shifted copies of 45 bytes ($2D)
spriteSplash1b
		; shift 0
		.hex
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 a2 00
			00 ae 00
			c0 8a 81
		.end
		; shift 1
		.hex
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 c4 00
			00 dc 00
			00 95 82
		.end
		; shift 2
		.hex
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 88 81
			00 b8 81
			00 aa 84
		.end
		; shift 3
		.hex
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 90 82
			00 f0 82
			00 d4 88
		.end
		; shift 4
		.hex
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 a0 84
			00 e0 85
			00 a8 91
		.end
		; shift 5
		.hex
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 c0 88
			00 c0 8b
			00 d0 a2
		.end
		; shift 6
		.hex
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 91
			00 00 97
			00 a0 c5
		.end

; $4E - splash
; 3x15 bytes, 7 pre-shifted copies of 45 bytes ($2D)
spriteSplash2b
		; shift 0
		.hex
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 82 00
			00 a0 00
			00 a2 00
			c0 ba 00
			c0 ae 00
			d0 88 81
		.end
		; shift 1
		.hex
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 84 00
			00 c0 00
			00 c4 00
			00 f5 00
			00 dd 00
			a0 91 82
		.end
		; shift 2
		.hex
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 88 00
			00 00 81
			00 88 81
			00 ea 81
			00 ba 81
			c0 a2 84
		.end
		; shift 3
		.hex
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 90 00
			00 00 82
			00 90 82
			00 d4 83
			00 f4 82
			00 c5 88
		.end
		; shift 4
		.hex
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 a0 00
			00 00 84
			00 a0 84
			00 a8 87
			00 e8 85
			00 8a 91
		.end
		; shift 5
		.hex
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 c0 00
			00 00 88
			00 c0 88
			00 d0 8e
			00 d0 8b
			00 94 a2
		.end
		; shift 6
		.hex
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 00 81
			00 00 90
			00 00 91
			00 a0 9d
			00 a0 97
			00 a8 c4
		.end

; $4F - splash
; 3x15 bytes, 7 pre-shifted copies of 45 bytes ($2D)
spriteSplash3b
		; shift 0
		.hex
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			c0 00 00
			00 00 00
			00 a0 00
			c4 86 00
			d0 8b 00
			dc b2 00
			c4 a6 00
			c0 82 00
			c0 83 00
			c0 9a 00
			d0 a8 00
		.end
		; shift 1
		.hex
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 81 00
			00 00 00
			00 c0 00
			88 8d 00
			a0 97 00
			b8 e5 00
			88 cd 00
			00 85 00
			00 87 00
			00 b5 00
			a0 d1 00
		.end
		; shift 2
		.hex
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 82 00
			00 00 00
			00 00 81
			90 9a 00
			c0 ae 00
			f0 ca 81
			90 9a 81
			00 8a 00
			00 8e 00
			00 ea 00
			c0 a2 81
		.end
		; shift 3
		.hex
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 84 00
			00 00 00
			00 00 82
			a0 b4 00
			00 dd 00
			e0 95 83
			a0 b4 82
			00 94 00
			00 9c 00
			00 d4 81
			00 c5 82
		.end
		; shift 4
		.hex
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 88 00
			00 00 00
			00 00 84
			c0 e8 00
			00 ba 81
			c0 ab 86
			c0 e8 84
			00 a8 00
			00 b8 00
			00 a8 83
			00 8a 85
		.end
		; shift 5
		.hex
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 90 00
			00 00 00
			00 00 88
			00 d1 81
			00 f4 82
			00 d7 8c
			00 d1 89
			00 d0 00
			00 f0 00
			00 d0 86
			00 94 8a
		.end
		; shift 6
		.hex
			00 00 00
			00 00 00
			00 00 00
			00 00 00
			00 a0 00
			00 00 00
			00 00 90
			00 a2 83
			00 e8 85
			00 ae 99
			00 a2 93
			00 a0 81
			00 e0 81
			00 a0 8d
			00 a8 94
		.end

; $50 - splash
; 4x15 bytes, 7 pre-shifted copies of 60 bytes ($3C)
spriteSplash4b
		; shift 0
		.hex
			c0 00 00 00
			00 82 00 00
			84 a0 00 00
			00 00 00 00
			b1 98 84 00
			dc eb 00 00
			d4 ae 81 00
			c5 8a 85 00
			c0 8e 00 00
			c4 8a 81 00
			c0 9a 00 00
			c0 8b 00 00
			c0 8a 00 00
			d0 aa 00 00
			c7 8e 85 00
		.end
		; shift 1
		.hex
			00 81 00 00
			00 84 00 00
			88 c0 00 00
			00 00 00 00
			e2 b0 88 00
			b8 d7 81 00
			a8 dd 82 00
			8a 95 8a 00
			00 9d 00 00
			88 95 82 00
			00 b5 00 00
			00 97 00 00
			00 95 00 00
			a0 d5 00 00
			8e 9d 8a 00
		.end
		; shift 2
		.hex
			00 82 00 00
			00 88 00 00
			90 00 81 00
			00 00 00 00
			c4 e1 90 00
			f0 ae 83 00
			d0 ba 85 00
			94 aa 94 00
			00 ba 00 00
			90 aa 84 00
			00 ea 00 00
			00 ae 00 00
			00 aa 00 00
			c0 aa 81 00
			9c ba 94 00
		.end
		; shift 3
		.hex
			00 84 00 00
			00 90 00 00
			a0 00 82 00
			00 00 00 00
			88 c3 a1 00
			e0 dd 86 00
			a0 f5 8a 00
			a8 d4 a8 00
			00 f4 00 00
			a0 d4 88 00
			00 d4 81 00
			00 dc 00 00
			00 d4 00 00
			00 d5 82 00
			b8 f4 a8 00
		.end
		; shift 4
		.hex
			00 88 00 00
			00 a0 00 00
			c0 00 84 00
			00 00 00 00
			90 86 c3 00
			c0 bb 8d 00
			c0 ea 95 00
			d0 a8 d1 00
			00 e8 81 00
			c0 a8 91 00
			00 a8 83 00
			00 b8 81 00
			00 a8 81 00
			00 aa 85 00
			f0 e8 d1 00
		.end
		; shift 5
		.hex
			00 90 00 00
			00 c0 00 00
			00 81 88 00
			00 00 00 00
			a0 8c 86 81
			00 f7 9a 00
			00 d5 ab 00
			a0 d1 a2 81
			00 d0 83 00
			00 d1 a2 00
			00 d0 86 00
			00 f0 82 00
			00 d0 82 00
			00 d4 8a 00
			e0 d1 a3 81
		.end
		; shift 6
		.hex
			00 a0 00 00
			00 00 81 00
			00 82 90 00
			00 00 00 00
			c0 98 8c 82
			00 ee b5 00
			00 aa d7 00
			c0 a2 c5 82
			00 a0 87 00
			00 a2 c5 00
			00 a0 8d 00
			00 e0 85 00
			00 a0 85 00
			00 a8 95 00
			c0 a3 c7 82
		.end

; $51 - geyser, $51-$53 cycling (SHAPE_GEYSER)
; 2x15 bytes, 7 pre-shifted copies of 30 bytes ($1E)
spriteGeyser1
		; shift 0
		.hex
			81 00
			84 00
			84 00
			00 00
			90 00
			84 00
			00 00
			95 00
			95 00
			9d 00
			95 00
			95 00
			95 00
			95 00
			95 00
		.end
		; shift 1
		.hex
			82 00
			88 00
			88 00
			00 00
			a0 00
			88 00
			00 00
			aa 00
			aa 00
			ba 00
			aa 00
			aa 00
			aa 00
			aa 00
			aa 00
		.end
		; shift 2
		.hex
			84 00
			90 00
			90 00
			00 00
			c0 00
			90 00
			00 00
			d4 00
			d4 00
			f4 00
			d4 00
			d4 00
			d4 00
			d4 00
			d4 00
		.end
		; shift 3
		.hex
			88 00
			a0 00
			a0 00
			00 00
			00 81
			a0 00
			00 00
			a8 81
			a8 81
			e8 81
			a8 81
			a8 81
			a8 81
			a8 81
			a8 81
		.end
		; shift 4
		.hex
			90 00
			c0 00
			c0 00
			00 00
			00 82
			c0 00
			00 00
			d0 82
			d0 82
			d0 83
			d0 82
			d0 82
			d0 82
			d0 82
			d0 82
		.end
		; shift 5
		.hex
			a0 00
			00 81
			00 81
			00 00
			00 84
			00 81
			00 00
			a0 85
			a0 85
			a0 87
			a0 85
			a0 85
			a0 85
			a0 85
			a0 85
		.end
		; shift 6
		.hex
			c0 00
			00 82
			00 82
			00 00
			00 88
			00 82
			00 00
			c0 8a
			c0 8a
			c0 8e
			c0 8a
			c0 8a
			c0 8a
			c0 8a
			c0 8a
		.end

; $52 - geyser
; 2x15 bytes, 7 pre-shifted copies of 30 bytes ($1E)
spriteGeyser2
		; shift 0
		.hex
			84 00
			84 00
			85 00
			81 00
			90 00
			90 00
			00 00
			95 00
			95 00
			95 00
			95 00
			9d 00
			95 00
			95 00
			95 00
		.end
		; shift 1
		.hex
			88 00
			88 00
			8a 00
			82 00
			a0 00
			a0 00
			00 00
			aa 00
			aa 00
			aa 00
			aa 00
			ba 00
			aa 00
			aa 00
			aa 00
		.end
		; shift 2
		.hex
			90 00
			90 00
			94 00
			84 00
			c0 00
			c0 00
			00 00
			d4 00
			d4 00
			d4 00
			d4 00
			f4 00
			d4 00
			d4 00
			d4 00
		.end
		; shift 3
		.hex
			a0 00
			a0 00
			a8 00
			88 00
			00 81
			00 81
			00 00
			a8 81
			a8 81
			a8 81
			a8 81
			e8 81
			a8 81
			a8 81
			a8 81
		.end
		; shift 4
		.hex
			c0 00
			c0 00
			d0 00
			90 00
			00 82
			00 82
			00 00
			d0 82
			d0 82
			d0 82
			d0 82
			d0 83
			d0 82
			d0 82
			d0 82
		.end
		; shift 5
		.hex
			00 81
			00 81
			a0 81
			a0 00
			00 84
			00 84
			00 00
			a0 85
			a0 85
			a0 85
			a0 85
			a0 87
			a0 85
			a0 85
			a0 85
		.end
		; shift 6
		.hex
			00 82
			00 82
			c0 82
			c0 00
			00 88
			00 88
			00 00
			c0 8a
			c0 8a
			c0 8a
			c0 8a
			c0 8e
			c0 8a
			c0 8a
			c0 8a
		.end

; $53 - geyser
; 2x15 bytes, 7 pre-shifted copies of 30 bytes ($1E)
spriteGeyser3
		; shift 0
		.hex
			00 00
			00 00
			00 00
			94 00
			84 00
			91 00
			90 00
			95 00
			95 00
			95 00
			9d 00
			95 00
			95 00
			95 00
			95 00
		.end
		; shift 1
		.hex
			00 00
			00 00
			00 00
			a8 00
			88 00
			a2 00
			a0 00
			aa 00
			aa 00
			aa 00
			ba 00
			aa 00
			aa 00
			aa 00
			aa 00
		.end
		; shift 2
		.hex
			00 00
			00 00
			00 00
			d0 00
			90 00
			c4 00
			c0 00
			d4 00
			d4 00
			d4 00
			f4 00
			d4 00
			d4 00
			d4 00
			d4 00
		.end
		; shift 3
		.hex
			00 00
			00 00
			00 00
			a0 81
			a0 00
			88 81
			00 81
			a8 81
			a8 81
			a8 81
			e8 81
			a8 81
			a8 81
			a8 81
			a8 81
		.end
		; shift 4
		.hex
			00 00
			00 00
			00 00
			c0 82
			c0 00
			90 82
			00 82
			d0 82
			d0 82
			d0 82
			d0 83
			d0 82
			d0 82
			d0 82
			d0 82
		.end
		; shift 5
		.hex
			00 00
			00 00
			00 00
			00 85
			00 81
			a0 84
			00 84
			a0 85
			a0 85
			a0 85
			a0 87
			a0 85
			a0 85
			a0 85
			a0 85
		.end
		; shift 6
		.hex
			00 00
			00 00
			00 00
			00 8a
			00 82
			c0 88
			00 88
			c0 8a
			c0 8a
			c0 8a
			c0 8e
			c0 8a
			c0 8a
			c0 8a
			c0 8a
		.end

; $54 - boulder (SHAPE_BOULDER)
; 5x5 bytes, 7 pre-shifted copies of 25 bytes ($19)
spriteBoulder
		; shift 0
		.hex
			7f 7f 7f 1f 00
			2e 55 2a 15 00
			6c 55 2a 0d 00
			00 30 7a 01 00
			00 00 06 00 00
		.end
		; shift 1
		.hex
			7e 7f 7f 3f 00
			5c 2a 55 2a 00
			58 2b 55 1a 00
			00 60 74 03 00
			00 00 0c 00 00
		.end
		; shift 2
		.hex
			7c 7f 7f 7f 00
			38 55 2a 55 00
			30 57 2a 35 00
			00 40 69 07 00
			00 00 18 00 00
		.end
		; shift 3
		.hex
			78 7f 7f 7f 01
			70 2a 55 2a 01
			60 2e 55 6a 00
			00 00 53 0f 00
			00 00 30 00 00
		.end
		; shift 4
		.hex
			70 7f 7f 7f 03
			60 55 2a 55 02
			40 5d 2a 55 01
			00 00 26 1f 00
			00 00 60 00 00
		.end
		; shift 5
		.hex
			60 7f 7f 7f 07
			40 2b 55 2a 05
			00 3b 55 2a 03
			00 00 4c 3e 00
			00 00 40 01 00
		.end
		; shift 6
		.hex
			40 7f 7f 7f 0f
			00 57 2a 55 0a
			00 76 2a 55 06
			00 00 18 7d 00
			00 00 00 03 00
		.end

; $55 - boulder bursting, $54-$57 (burstShapes)
; 5x4 bytes, 7 pre-shifted copies of 20 bytes ($14)
spriteBoulderBurst1
		; shift 0
		.hex
			09 4f 37 0c 00
			2c 55 22 15 00
			64 15 02 0c 00
			00 10 20 01 00
		.end
		; shift 1
		.hex
			12 1e 6f 18 00
			58 2a 45 2a 00
			48 2b 04 18 00
			00 20 40 02 00
		.end
		; shift 2
		.hex
			24 3c 5e 31 00
			30 55 0a 55 00
			10 57 08 30 00
			00 40 00 05 00
		.end
		; shift 3
		.hex
			48 78 3c 63 00
			60 2a 15 2a 01
			20 2e 11 60 00
			00 00 01 0a 00
		.end
		; shift 4
		.hex
			10 71 79 46 01
			40 55 2a 54 02
			40 5c 22 40 01
			00 00 02 14 00
		.end
		; shift 5
		.hex
			20 62 73 0d 03
			00 2b 55 28 05
			00 39 45 00 03
			00 00 04 28 00
		.end
		; shift 6
		.hex
			40 44 67 1b 06
			00 56 2a 51 0a
			00 72 0a 01 06
			00 00 08 50 00
		.end

; $56 - boulder bursting
; 5x4 bytes, 7 pre-shifted copies of 20 bytes ($14)
spriteBoulderBurst2
		; shift 0
		.hex
			09 0c 15 08 00
			00 40 20 00 00
			24 14 02 00 00
			00 10 20 01 00
		.end
		; shift 1
		.hex
			12 18 2a 10 00
			00 00 41 00 00
			48 28 04 00 00
			00 20 40 02 00
		.end
		; shift 2
		.hex
			24 30 54 20 00
			00 00 02 01 00
			10 51 08 00 00
			00 40 00 05 00
		.end
		; shift 3
		.hex
			48 60 28 41 00
			00 00 04 02 00
			20 22 11 00 00
			00 00 01 0a 00
		.end
		; shift 4
		.hex
			10 41 51 02 01
			00 00 08 04 00
			40 44 22 00 00
			00 00 02 14 00
		.end
		; shift 5
		.hex
			20 02 23 05 02
			00 00 10 08 00
			00 09 45 00 00
			00 00 04 28 00
		.end
		; shift 6
		.hex
			40 04 46 0a 04
			00 00 20 10 00
			00 12 0a 01 00
			00 00 08 50 00
		.end

; $57 - boulder bursting
; 5x4 bytes, 7 pre-shifted copies of 20 bytes ($14)
spriteBoulderBurst3
		; shift 0
		.hex
			01 00 01 08 00
			00 00 00 00 00
			24 00 00 00 00
			00 00 00 01 00
		.end
		; shift 1
		.hex
			02 00 02 10 00
			00 00 00 00 00
			48 00 00 00 00
			00 00 00 02 00
		.end
		; shift 2
		.hex
			04 00 04 20 00
			00 00 00 00 00
			10 01 00 00 00
			00 00 00 04 00
		.end
		; shift 3
		.hex
			08 00 08 40 00
			00 00 00 00 00
			20 02 00 00 00
			00 00 00 08 00
		.end
		; shift 4
		.hex
			10 00 10 00 01
			00 00 00 00 00
			40 04 00 00 00
			00 00 00 10 00
		.end
		; shift 5
		.hex
			20 00 20 00 02
			00 00 00 00 00
			00 09 00 00 00
			00 00 00 20 00
		.end
		; shift 6
		.hex
			40 00 40 00 04
			00 00 00 00 00
			00 12 00 00 00
			00 00 00 40 00
		.end

; $58 - empty slot, slot 2's blinking marker (SHAPE_SLOT)
; 3x4 bytes, 7 pre-shifted copies of 12 bytes ($0C)
spriteSlot
		; shift 0
		.hex
			7f 03 00
			7f 03 00
			7f 03 00
			7f 03 00
		.end
		; shift 1
		.hex
			7e 07 00
			7e 07 00
			7e 07 00
			7e 07 00
		.end
		; shift 2
		.hex
			7c 0f 00
			7c 0f 00
			7c 0f 00
			7c 0f 00
		.end
		; shift 3
		.hex
			78 1f 00
			78 1f 00
			78 1f 00
			78 1f 00
		.end
		; shift 4
		.hex
			70 3f 00
			70 3f 00
			70 3f 00
			70 3f 00
		.end
		; shift 5
		.hex
			60 7f 00
			60 7f 00
			60 7f 00
			60 7f 00
		.end
		; shift 6
		.hex
			40 7f 01
			40 7f 01
			40 7f 01
			40 7f 01
		.end

; $59 - water drop (SHAPE_DROP)
; 2x1 bytes, 7 pre-shifted copies of 2 bytes ($02)
spriteDrop
		; shift 0
		.hex
			83 80
		.end
		; shift 1
		.hex
			86 80
		.end
		; shift 2
		.hex
			8c 80
		.end
		; shift 3
		.hex
			98 80
		.end
		; shift 4
		.hex
			b0 80
		.end
		; shift 5
		.hex
			e0 80
		.end
		; shift 6
		.hex
			c0 81
		.end

; $5A - boulder breaking, $5A-$5C (breakShapes)
; 4x8 bytes, 7 pre-shifted copies of 32 bytes ($20)
spriteBoulderBreak1
		; shift 0
		.hex
			80 80 80 80
			80 80 80 80
			80 80 80 80
			80 80 80 80
			80 80 80 80
			81 80 90 80
			86 80 87 80
			d4 ab 85 80
		.end
		; shift 1
		.hex
			80 80 80 80
			80 80 80 80
			80 80 80 80
			80 80 80 80
			80 80 80 80
			82 80 a0 80
			8c 80 8e 80
			a8 d7 8a 80
		.end
		; shift 2
		.hex
			80 80 80 80
			80 80 80 80
			80 80 80 80
			80 80 80 80
			80 80 80 80
			84 80 c0 80
			98 80 9c 80
			d0 ae 95 80
		.end
		; shift 3
		.hex
			80 80 80 80
			80 80 80 80
			80 80 80 80
			80 80 80 80
			80 80 80 80
			88 80 80 81
			b0 80 b8 80
			a0 dd aa 80
		.end
		; shift 4
		.hex
			80 80 80 80
			80 80 80 80
			80 80 80 80
			80 80 80 80
			80 80 80 80
			90 80 80 82
			e0 80 f0 80
			c0 ba d5 80
		.end
		; shift 5
		.hex
			80 80 80 80
			80 80 80 80
			80 80 80 80
			80 80 80 80
			80 80 80 80
			a0 80 80 84
			c0 81 e0 81
			80 f5 aa 81
		.end
		; shift 6
		.hex
			80 80 80 80
			80 80 80 80
			80 80 80 80
			80 80 80 80
			80 80 80 80
			c0 80 80 88
			80 83 c0 83
			80 ea d5 82
		.end

; $5B - boulder breaking
; 5x8 bytes, 7 pre-shifted copies of 40 bytes ($28)
spriteBoulderBreak2
		; shift 0
		.hex
			80 80 80 80 80
			80 80 80 80 80
			84 80 80 80 80
			80 80 c0 80 80
			c1 80 84 80 80
			84 80 80 83 80
			d8 89 d1 80 80
			d0 ea f5 80 80
		.end
		; shift 1
		.hex
			80 80 80 80 80
			80 80 80 80 80
			88 80 80 80 80
			80 80 80 81 80
			82 81 88 80 80
			88 80 80 86 80
			b0 93 a2 81 80
			a0 d5 eb 81 80
		.end
		; shift 2
		.hex
			80 80 80 80 80
			80 80 80 80 80
			90 80 80 80 80
			80 80 80 82 80
			84 82 90 80 80
			90 80 80 8c 80
			e0 a6 c4 82 80
			c0 aa d7 83 80
		.end
		; shift 3
		.hex
			80 80 80 80 80
			80 80 80 80 80
			a0 80 80 80 80
			80 80 80 84 80
			88 84 a0 80 80
			a0 80 80 98 80
			c0 cd 88 85 80
			80 d5 ae 87 80
		.end
		; shift 4
		.hex
			80 80 80 80 80
			80 80 80 80 80
			c0 80 80 80 80
			80 80 80 88 80
			90 88 c0 80 80
			c0 80 80 b0 80
			80 9b 91 8a 80
			80 aa dd 8e 80
		.end
		; shift 5
		.hex
			80 80 80 80 80
			80 80 80 80 80
			80 81 80 80 80
			80 80 80 90 80
			a0 90 80 81 80
			80 81 80 e0 80
			80 b6 a2 94 80
			80 d4 ba 9d 80
		.end
		; shift 6
		.hex
			80 80 80 80 80
			80 80 80 80 80
			80 82 80 80 80
			80 80 80 a0 80
			c0 a0 80 82 80
			80 82 80 c0 81
			80 ec c4 a8 80
			80 a8 f5 ba 80
		.end

; $5C - boulder breaking
; 5x8 bytes, 7 pre-shifted copies of 40 bytes ($28)
spriteBoulderBreak3
		; shift 0
		.hex
			91 80 80 8a 80
			80 80 80 80 80
			84 80 84 ac 80
			90 80 c1 80 80
			f1 80 c0 8b 80
			dc 82 d1 8b 80
			d4 ab d7 82 80
			d0 ba d5 83 80
		.end
		; shift 1
		.hex
			a2 80 80 94 80
			80 80 80 80 80
			88 80 88 d8 80
			a0 80 82 81 80
			e2 81 80 97 80
			b8 85 a2 97 80
			a8 d7 ae 85 80
			a0 f5 aa 87 80
		.end
		; shift 2
		.hex
			c4 80 80 a8 80
			80 80 80 80 80
			90 80 90 b0 81
			c0 80 84 82 80
			c4 83 80 ae 80
			f0 8a c4 ae 80
			d0 ae dd 8a 80
			c0 ea d5 8e 80
		.end
		; shift 3
		.hex
			88 81 80 d0 80
			80 80 80 80 80
			a0 80 a0 e0 82
			80 81 88 84 80
			88 87 80 dc 80
			e0 95 88 dd 80
			a0 dd ba 95 80
			80 d5 ab 9d 80
		.end
		; shift 4
		.hex
			90 82 80 a0 81
			80 80 80 80 80
			c0 80 c0 c0 85
			80 82 90 88 80
			90 8e 80 b8 81
			c0 ab 90 ba 81
			c0 ba f5 aa 80
			80 aa d7 ba 80
		.end
		; shift 5
		.hex
			a0 84 80 c0 82
			80 80 80 80 80
			80 81 80 81 8b
			80 84 a0 90 80
			a0 9c 80 f0 82
			80 d7 a0 f4 82
			80 f5 ea d5 80
			80 d4 ae f5 80
		.end
		; shift 6
		.hex
			c0 88 80 80 85
			80 80 80 80 80
			80 82 80 82 96
			80 88 c0 a0 80
			c0 b8 80 e0 85
			80 ae c1 e8 85
			80 ea d5 ab 81
			80 a8 dd ea 81
		.end

; $5D - blank 2x8 block, eraser drawn with drawStore (SHAPE_BLANK)
; 2x8 bytes, one copy shared by the 7 pointers
spriteBlank
		.fill	2 * 8, $00

; $925F-$937F: leftover memory (the old copy of $5D at $9280, assembler symbols, code)
		placeAt	$9380

; 31 water drops (1..$1F) falling along dropPathX/Y: step of each one on the
; path, +1 per frame. dropStep+0 and dropStep+$20 are not used.
dropStep
		.hex
	00 08 10 18 20 28 30 38 40 48 50 58 60 68 70 78
	80 88 90 98 A0 A8 B0 B8 C0 C8 D0 D8 E0 E8 F0 F8
	58
		.end

; the key: hidden until the 2nd gem fills slot 2, then falls from
; ($76,$96) to Y=$A3 where the player takes it (checkTakeKey)
keyX		.db	$76
keyY		.db	$96
keyState	.db	$00			; 0 hidden, 1 falling, $FF on the ground (or taken)
doorOpen	.db	$00			; 1 once the key opened the door ($78,$52)

; $93A5-$93FF: leftover memory (code)
		.hex
	4C 5A A0 60 8C F0 B3 A8 B9 FF B5 85 1C B9 7F B6
	85 1D A0 00 8C F7 B3 B1 1C 8D F1 B3 8D F3 B3 C8
	B1 1C 8D F4 B3 8E F5 B3 10 1E EE F7 B3 29 7F 8D
	F4 B3 BD 00 B2 0A 18 69 02 A8 B1 1C 8D 25 A1 C8
	B1 1C 8D 26 A1 4C 00 A1 BD 00 AF 0A 18 69 02 A8
	B1 1C 8D 25 A1 C8 B1 1C 8D 26 A1
		.end

; drop paths, 256 steps: 7 arcs, each from the top right (X $84-$87, Y $1C)
; down and left to the water (Y $A7-$AF), then the next one
dropPathX
		.hex
	85 81 7D 78 74 72 71 70 6F 6E 6E 6D 6C 6C 6B 6B
	6B 6B 6A 6A 6A 69 69 68 67 65 63 60 5C 58 54 4F
	1C 1C 1C 1C 0D 0D 0D 87 83 7F 7B 77 75 73 71 70
	6F 6E 6E 6D 6D 6D 6C 6B 6B 6B 6B 6A 6A 6A 6A 69
	67 66 64 63 62 60 5F 21 21 21 84 80 7C 79 77 75
	73 72 71 6F 6E 6E 6E 6D 6C 6C 6C 6C 6C 6B 6B 6A
	6A 6A 69 69 69 68 68 68 68 67 65 63 61 5E 5B 5A
	86 82 7E 7A 76 73 70 6F 6F 6E 6E 6D 6C 6B 6B 6B
	6A 6A 6A 6A 6A 6A 69 69 68 66 64 63 62 61 60 5F
	5E 5D 5B 15 15 15 85 82 7E 7A 76 74 72 71 70 6F
	6E 6D 6D 6D 6C 6C 6B 6B 6B 6B 6B 6B 6B 6B 6B 6A
	6A 6A 6A 68 67 65 64 63 62 61 60 5F 5E 5C 5A 58
	56 84 80 7C 79 76 73 71 70 6F 6E 6D 6C 6C 6C 6C
	6B 6B 6A 6A 6A 6A 69 69 69 68 67 64 62 60 5E 5A
	58 07 07 07 84 80 7A 76 73 71 70 6E 6E 6D 6D 6C
	6B 6B 6B 6A 6A 69 69 69 69 68 66 65 64 62 61 60
		.end
dropPathY
		.hex
	1C 1C 1C 1C 1E 20 22 26 2C 31 37 3E 44 4C 54 5D
	66 6F 79 84 90 9C A7 AB AE AE AC AC AC AC AC AC
	B4 B2 B0 AE B2 B0 AE 1C 1C 1C 1C 1C 1D 1F 21 25
	2B 2E 34 39 41 48 50 57 61 6A 74 7E 88 8C 96 A1
	A8 AB AA A9 A7 A8 AA B3 B1 AE 1D 1D 1D 1D 1D 1E
	1F 21 23 28 30 35 3C 43 46 4E 53 59 5D 63 6C 72
	7B 86 8E 93 98 9E A3 AC AE B0 AF AF AE AD AD AC
	1C 1C 1C 1C 1D 1F 23 27 2A 2F 35 3C 45 4F 59 60
	6B 75 80 8D 9C A1 A6 A9 AA AB A9 A6 A5 A4 A5 A7
	A9 AB AB B4 B2 AF 1D 1D 1D 1D 1D 1E 20 23 25 29
	2D 35 3A 40 47 4D 52 59 5E 65 69 70 78 7F 85 8B
	91 99 A4 A9 AC AB A8 A5 A5 A6 A8 AA AB AB AB AB
	AB 1C 1C 1C 1C 1D 1F 22 26 2A 2F 36 40 48 4D 52
	5A 63 68 71 7A 85 91 9D A6 AA AC AC AB AB AB AB
	AB B4 B2 AF 1C 1C 1C 1D 1F 22 26 2D 38 41 4A 53
	5D 65 6F 7D 8A 96 9F A6 AA A9 A8 A5 A3 A3 A4 A7
		.end
