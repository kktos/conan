;
; level 6 sprite bitmaps (disk chunk c3, at $7A00), for the headers
; $41-$62 of data-R1-7500.asm.
; A sprite is width x height bytes, rows top to bottom (7 pixels per byte,
; bit 0 first), one row per line below. defsprite sprites have 7 copies, one
; per X mod 7 shift; defpicture ones a single copy.
; Then the chandelier's bitmaps, the monsters' turn points, the speed table
; and the mover's scripts, read (and $9040 written) by the level code.
;

		placeAt	$7A00

; $41 - mover flying, $41-$43 (moverScriptShape); shot with the axe to build the ladder
; 3x7 bytes, 7 pre-shifted copies of 21 bytes ($15)
spriteMover1
		; shift 0
		.hex
			3e 00 00
			7d 01 00
			75 03 00
			74 03 00
			75 03 00
			7d 01 00
			3e 00 00
		.end
		; shift 1
		.hex
			7c 00 00
			7a 03 00
			6a 07 00
			68 07 00
			6a 07 00
			7a 03 00
			7c 00 00
		.end
		; shift 2
		.hex
			78 01 00
			74 07 00
			54 0f 00
			50 0f 00
			54 0f 00
			74 07 00
			78 01 00
		.end
		; shift 3
		.hex
			70 03 00
			68 0f 00
			28 1f 00
			20 1f 00
			28 1f 00
			68 0f 00
			70 03 00
		.end
		; shift 4
		.hex
			60 07 00
			50 1f 00
			50 3e 00
			40 3e 00
			50 3e 00
			50 1f 00
			60 07 00
		.end
		; shift 5
		.hex
			40 0f 00
			20 3f 00
			20 7d 00
			00 7d 00
			20 7d 00
			20 3f 00
			40 0f 00
		.end
		; shift 6
		.hex
			00 1f 00
			40 7e 00
			40 7a 01
			00 7a 01
			40 7a 01
			40 7e 00
			00 1f 00
		.end

; $42 - mover
; 3x7 bytes, 7 pre-shifted copies of 21 bytes ($15)
spriteMover2
		; shift 0
		.hex
			78 01 00
			7e 02 00
			5f 02 00
			5f 00 00
			5f 02 00
			7e 02 00
			78 01 00
		.end
		; shift 1
		.hex
			70 03 00
			7c 05 00
			3e 05 00
			3e 01 00
			3e 05 00
			7c 05 00
			70 03 00
		.end
		; shift 2
		.hex
			60 07 00
			78 0b 00
			7c 0a 00
			7c 02 00
			7c 0a 00
			78 0b 00
			60 07 00
		.end
		; shift 3
		.hex
			40 0f 00
			70 17 00
			78 15 00
			78 05 00
			78 15 00
			70 17 00
			40 0f 00
		.end
		; shift 4
		.hex
			00 1f 00
			60 2f 00
			70 2b 00
			70 0b 00
			70 2b 00
			60 2f 00
			00 1f 00
		.end
		; shift 5
		.hex
			00 3e 00
			40 5f 00
			60 57 00
			60 17 00
			60 57 00
			40 5f 00
			00 3e 00
		.end
		; shift 6
		.hex
			00 7c 00
			00 3f 01
			40 2f 01
			40 2f 00
			40 2f 01
			00 3f 01
			00 7c 00
		.end

; $43 - mover, also the first frame of moverHitShapes (SHAPE_MOVER_HIT)
; 3x7 bytes, 7 pre-shifted copies of 21 bytes ($15)
spriteMover3
		; shift 0
		.hex
			78 01 00
			2e 07 00
			0b 0d 00
			03 0c 00
			0b 0d 00
			2e 07 00
			78 01 00
		.end
		; shift 1
		.hex
			70 03 00
			5c 0e 00
			16 1a 00
			06 18 00
			16 1a 00
			5c 0e 00
			70 03 00
		.end
		; shift 2
		.hex
			60 07 00
			38 1d 00
			2c 34 00
			0c 30 00
			2c 34 00
			38 1d 00
			60 07 00
		.end
		; shift 3
		.hex
			40 0f 00
			70 3a 00
			58 68 00
			18 60 00
			58 68 00
			70 3a 00
			40 0f 00
		.end
		; shift 4
		.hex
			00 1f 00
			60 75 00
			30 51 01
			30 40 01
			30 51 01
			60 75 00
			00 1f 00
		.end
		; shift 5
		.hex
			00 3e 00
			40 6b 01
			60 22 03
			60 00 03
			60 22 03
			40 6b 01
			00 3e 00
		.end
		; shift 6
		.hex
			00 7c 00
			00 57 03
			40 45 06
			40 01 06
			40 45 06
			00 57 03
			00 7c 00
		.end

; $44 - the riser in the centre machine, $44-$46 (decorShape)
; 2x1 bytes, 7 pre-shifted copies of 2 bytes ($02)
spriteRiser1
		; shift 0
		.hex
			05 00
		.end
		; shift 1
		.hex
			0a 00
		.end
		; shift 2
		.hex
			14 00
		.end
		; shift 3
		.hex
			28 00
		.end
		; shift 4
		.hex
			50 00
		.end
		; shift 5
		.hex
			20 01
		.end
		; shift 6
		.hex
			40 02
		.end

; $45 - riser
; 2x2 bytes, 7 pre-shifted copies of 4 bytes ($04)
spriteRiser2
		; shift 0
		.hex
			41 00
			14 00
		.end
		; shift 1
		.hex
			02 01
			28 00
		.end
		; shift 2
		.hex
			04 02
			50 00
		.end
		; shift 3
		.hex
			08 04
			20 01
		.end
		; shift 4
		.hex
			10 08
			40 02
		.end
		; shift 5
		.hex
			20 10
			00 05
		.end
		; shift 6
		.hex
			40 20
			00 0a
		.end

; $46 - riser
; 2x2 bytes, 7 pre-shifted copies of 4 bytes ($04)
spriteRiser3
		; shift 0
		.hex
			14 00
			41 00
		.end
		; shift 1
		.hex
			28 00
			02 01
		.end
		; shift 2
		.hex
			50 00
			04 02
		.end
		; shift 3
		.hex
			20 01
			08 04
		.end
		; shift 4
		.hex
			40 02
			10 08
		.end
		; shift 5
		.hex
			00 05
			20 10
		.end
		; shift 6
		.hex
			00 0a
			40 20
		.end

; $47 - blinker under the machine (SHAPE_BLINK1)
; 2x3 bytes, 7 pre-shifted copies of 6 bytes ($06)
spriteBlink1
		; shift 0
		.hex
			55 00
			55 00
			55 00
		.end
		; shift 1
		.hex
			2a 01
			2a 01
			2a 01
		.end
		; shift 2
		.hex
			54 02
			54 02
			54 02
		.end
		; shift 3
		.hex
			28 05
			28 05
			28 05
		.end
		; shift 4
		.hex
			50 0a
			50 0a
			50 0a
		.end
		; shift 5
		.hex
			20 15
			20 15
			20 15
		.end
		; shift 6
		.hex
			40 2a
			40 2a
			40 2a
		.end

; $48 - blinker (SHAPE_BLINK2)
; 2x3 bytes, 7 pre-shifted copies of 6 bytes ($06)
spriteBlink2
		; shift 0
		.hex
			15 00
			1b 00
			15 00
		.end
		; shift 1
		.hex
			2a 00
			36 00
			2a 00
		.end
		; shift 2
		.hex
			54 00
			6c 00
			54 00
		.end
		; shift 3
		.hex
			28 01
			58 01
			28 01
		.end
		; shift 4
		.hex
			50 02
			30 03
			50 02
		.end
		; shift 5
		.hex
			20 05
			60 06
			20 05
		.end
		; shift 6
		.hex
			40 0a
			40 0d
			40 0a
		.end

; $49 - lamp (SHAPE_LAMP)
; 1x5 bytes, 7 pre-shifted copies of 5 bytes ($05)
spriteLamp
		; shift 0
		.hex
			81
			81
			81
			81
			81
		.end
		; shift 1
		.hex
			82
			82
			82
			82
			82
		.end
		; shift 2
		.hex
			84
			84
			84
			84
			84
		.end
		; shift 3
		.hex
			88
			88
			88
			88
			88
		.end
		; shift 4
		.hex
			90
			90
			90
			90
			90
		.end
		; shift 5
		.hex
			a0
			a0
			a0
			a0
			a0
		.end
		; shift 6
		.hex
			c0
			c0
			c0
			c0
			c0
		.end

; $4A - ladder rung (SHAPE_RUNG)
; 2x6 bytes, 7 pre-shifted copies of 12 bytes ($0C)
spriteRung
		; shift 0
		.hex
			55 00
			41 00
			41 00
			55 00
			41 00
			41 00
		.end
		; shift 1
		.hex
			2a 01
			02 01
			02 01
			2a 01
			02 01
			02 01
		.end
		; shift 2
		.hex
			54 02
			04 02
			04 02
			54 02
			04 02
			04 02
		.end
		; shift 3
		.hex
			28 05
			08 04
			08 04
			28 05
			08 04
			08 04
		.end
		; shift 4
		.hex
			50 0a
			10 08
			10 08
			50 0a
			10 08
			10 08
		.end
		; shift 5
		.hex
			20 15
			20 10
			20 10
			20 15
			20 10
			20 10
		.end
		; shift 6
		.hex
			40 2a
			40 20
			40 20
			40 2a
			40 20
			40 20
		.end

; $4B - gate, first piece, frame 0 (SHAPE_GATE1 + gateFrame)
; 2x2 bytes, 7 pre-shifted copies of 4 bytes ($04)
spriteGate1A
		; shift 0
		.hex
			14 00
			05 00
		.end
		; shift 1
		.hex
			28 00
			0a 00
		.end
		; shift 2
		.hex
			50 00
			14 00
		.end
		; shift 3
		.hex
			20 01
			28 00
		.end
		; shift 4
		.hex
			40 02
			50 00
		.end
		; shift 5
		.hex
			00 05
			20 01
		.end
		; shift 6
		.hex
			00 0a
			40 02
		.end

; $4C - gate, first piece, frame 1
; 2x2 bytes, 7 pre-shifted copies of 4 bytes ($04)
spriteGate1B
		; shift 0
		.hex
			3c 00
			0f 00
		.end
		; shift 1
		.hex
			78 00
			1e 00
		.end
		; shift 2
		.hex
			70 01
			3c 00
		.end
		; shift 3
		.hex
			60 03
			78 00
		.end
		; shift 4
		.hex
			40 07
			70 01
		.end
		; shift 5
		.hex
			00 0f
			60 03
		.end
		; shift 6
		.hex
			00 1e
			40 07
		.end

; $4D - gate, second piece, frame 0 (SHAPE_GATE2 + gateFrame)
; 2x2 bytes, 7 pre-shifted copies of 4 bytes ($04)
spriteGate2A
		; shift 0
		.hex
			05 00
			14 00
		.end
		; shift 1
		.hex
			0a 00
			28 00
		.end
		; shift 2
		.hex
			14 00
			50 00
		.end
		; shift 3
		.hex
			28 00
			20 01
		.end
		; shift 4
		.hex
			50 00
			40 02
		.end
		; shift 5
		.hex
			20 01
			00 05
		.end
		; shift 6
		.hex
			40 02
			00 0a
		.end

; $4E - gate, second piece, frame 1
; 2x2 bytes, 7 pre-shifted copies of 4 bytes ($04)
spriteGate2B
		; shift 0
		.hex
			0f 00
			3c 00
		.end
		; shift 1
		.hex
			1e 00
			78 00
		.end
		; shift 2
		.hex
			3c 00
			70 01
		.end
		; shift 3
		.hex
			78 00
			60 03
		.end
		; shift 4
		.hex
			70 01
			40 07
		.end
		; shift 5
		.hex
			60 03
			00 0f
		.end
		; shift 6
		.hex
			40 07
			00 1e
		.end

; $4F - lower platform (SHAPE_LOWER_PLAT)
; 4x2 bytes, 7 pre-shifted copies of 8 bytes ($08)
spriteLowerPlat
		; shift 0
		.hex
			54 2a 01 00
			55 2a 05 00
		.end
		; shift 1
		.hex
			28 55 02 00
			2a 55 0a 00
		.end
		; shift 2
		.hex
			50 2a 05 00
			54 2a 15 00
		.end
		; shift 3
		.hex
			20 55 0a 00
			28 55 2a 00
		.end
		; shift 4
		.hex
			40 2a 15 00
			50 2a 55 00
		.end
		; shift 5
		.hex
			00 55 2a 00
			20 55 2a 01
		.end
		; shift 6
		.hex
			00 2a 55 00
			40 2a 55 02
		.end

; $50 - upper platform (SHAPE_UPPER_PLAT)
; 4x2 bytes, 7 pre-shifted copies of 8 bytes ($08)
spriteUpperPlat
		; shift 0
		.hex
			55 2a 05 00
			54 2a 01 00
		.end
		; shift 1
		.hex
			2a 55 0a 00
			28 55 02 00
		.end
		; shift 2
		.hex
			54 2a 15 00
			50 2a 05 00
		.end
		; shift 3
		.hex
			28 55 2a 00
			20 55 0a 00
		.end
		; shift 4
		.hex
			50 2a 55 00
			40 2a 15 00
		.end
		; shift 5
		.hex
			20 55 2a 01
			00 55 2a 00
		.end
		; shift 6
		.hex
			40 2a 55 02
			00 2a 55 00
		.end

; $51 - monster flying out, right arc, $51 / $52 (spawnShape)
; 3x3 bytes, 7 pre-shifted copies of 9 bytes ($09)
spriteSpawnR1
		; shift 0
		.hex
			00 2a 00
			50 02 00
			15 00 00
		.end
		; shift 1
		.hex
			00 54 00
			20 05 00
			2a 00 00
		.end
		; shift 2
		.hex
			00 28 01
			40 0a 00
			54 00 00
		.end
		; shift 3
		.hex
			00 50 02
			00 15 00
			28 01 00
		.end
		; shift 4
		.hex
			00 20 05
			00 2a 00
			50 02 00
		.end
		; shift 5
		.hex
			00 40 0a
			00 54 00
			20 05 00
		.end
		; shift 6
		.hex
			00 00 15
			00 28 01
			40 0a 00
		.end

; $52 - monster flying out, right arc
; 3x3 bytes, 7 pre-shifted copies of 9 bytes ($09)
spriteSpawnR2
		; shift 0
		.hex
			00 3f 00
			78 03 00
			1f 00 00
		.end
		; shift 1
		.hex
			00 7e 00
			70 07 00
			3e 00 00
		.end
		; shift 2
		.hex
			00 7c 01
			60 0f 00
			7c 00 00
		.end
		; shift 3
		.hex
			00 78 03
			40 1f 00
			78 01 00
		.end
		; shift 4
		.hex
			00 70 07
			00 3f 00
			70 03 00
		.end
		; shift 5
		.hex
			00 60 0f
			00 7e 00
			60 07 00
		.end
		; shift 6
		.hex
			00 40 1f
			00 7c 01
			40 0f 00
		.end

; $53 - monster flying out, left arc, $53 / $54
; 3x3 bytes, 7 pre-shifted copies of 9 bytes ($09)
spriteSpawnL1
		; shift 0
		.hex
			15 00 00
			50 02 00
			00 2a 00
		.end
		; shift 1
		.hex
			2a 00 00
			20 05 00
			00 54 00
		.end
		; shift 2
		.hex
			54 00 00
			40 0a 00
			00 28 01
		.end
		; shift 3
		.hex
			28 01 00
			00 15 00
			00 50 02
		.end
		; shift 4
		.hex
			50 02 00
			00 2a 00
			00 20 05
		.end
		; shift 5
		.hex
			20 05 00
			00 54 00
			00 40 0a
		.end
		; shift 6
		.hex
			40 0a 00
			00 28 01
			00 00 15
		.end

; $54 - monster flying out, left arc
; 3x3 bytes, 7 pre-shifted copies of 9 bytes ($09)
spriteSpawnL2
		; shift 0
		.hex
			3f 00 00
			70 03 00
			00 3f 00
		.end
		; shift 1
		.hex
			7e 00 00
			60 07 00
			00 7e 00
		.end
		; shift 2
		.hex
			7c 01 00
			40 0f 00
			00 7c 01
		.end
		; shift 3
		.hex
			78 03 00
			00 1f 00
			00 78 03
		.end
		; shift 4
		.hex
			70 07 00
			00 3e 00
			00 70 07
		.end
		; shift 5
		.hex
			60 0f 00
			00 7c 00
			00 60 0f
		.end
		; shift 6
		.hex
			40 1f 00
			00 78 01
			00 40 1f
		.end

; $55 - lightning bolt (SHAPE_BOLT + boltFrame)
; 3x32 bytes, 7 pre-shifted copies of 96 bytes ($60)
spriteBolt1
		; shift 0
		.hex
			14 00 00
			14 00 00
			14 00 00
			14 00 00
			10 00 00
			50 00 00
			50 00 00
			40 00 00
			40 00 00
			40 00 00
			40 00 00
			50 00 00
			50 02 00
			10 02 00
			10 08 00
			10 08 00
			50 00 00
			44 00 00
			44 00 00
			04 02 00
			01 02 00
			01 02 00
			01 02 00
			00 02 00
			40 08 00
			40 08 00
			40 00 00
			40 00 00
			10 02 00
			10 00 00
			10 00 00
			00 00 00
		.end
		; shift 1
		.hex
			28 00 00
			28 00 00
			28 00 00
			28 00 00
			22 00 00
			22 01 00
			22 01 00
			00 01 00
			00 01 00
			00 01 00
			00 01 00
			20 01 00
			20 05 00
			20 04 00
			00 00 00
			08 04 00
			08 01 00
			08 01 00
			02 01 00
			02 04 00
			02 04 00
			00 01 00
			00 01 00
			00 01 00
			00 01 00
			20 04 00
			20 04 00
			20 04 00
			20 04 00
			20 00 00
			20 00 00
			00 00 00
		.end
		; shift 2
		.hex
			50 00 00
			50 00 00
			50 00 00
			50 00 00
			40 00 00
			40 02 00
			40 02 00
			00 02 00
			00 02 00
			00 02 00
			00 02 00
			40 02 00
			40 02 00
			40 00 00
			40 00 00
			40 00 00
			40 02 00
			10 02 00
			10 02 00
			10 08 00
			04 08 00
			04 08 00
			04 22 00
			04 22 00
			10 02 00
			10 00 00
			10 00 00
			10 00 00
			50 00 00
			44 00 00
			44 00 00
			40 00 00
		.end
		; shift 3
		.hex
			20 01 00
			20 01 00
			20 01 00
			20 01 00
			00 01 00
			00 05 00
			00 05 00
			20 04 00
			20 04 00
			20 04 00
			08 04 00
			08 05 00
			00 05 00
			00 01 00
			00 01 00
			00 01 00
			00 05 00
			20 04 00
			20 04 00
			20 10 00
			08 10 00
			08 10 00
			28 00 00
			20 00 00
			20 01 00
			00 01 00
			00 01 00
			20 04 00
			00 04 00
			00 04 00
			00 00 00
			00 00 00
		.end
		; shift 4
		.hex
			40 02 00
			40 02 00
			40 02 00
			40 02 00
			00 02 00
			00 0a 00
			00 0a 00
			00 08 00
			00 08 00
			00 08 00
			00 08 00
			00 0a 00
			00 0a 00
			00 02 00
			00 02 00
			00 02 00
			00 0a 00
			40 08 00
			40 08 00
			40 20 00
			10 20 00
			10 20 00
			10 08 01
			10 08 01
			40 08 00
			40 00 00
			40 00 00
			40 00 00
			40 02 00
			10 02 00
			10 02 00
			00 02 00
		.end
		; shift 5
		.hex
			00 05 00
			00 05 00
			00 05 00
			00 05 00
			20 04 00
			20 14 00
			20 14 00
			00 10 00
			00 10 00
			00 10 00
			00 10 00
			00 14 00
			00 54 00
			00 44 00
			00 00 00
			00 41 00
			00 11 00
			00 11 00
			20 10 00
			20 40 00
			20 40 00
			00 10 00
			00 10 00
			00 10 00
			00 10 00
			00 44 00
			00 44 00
			00 44 00
			00 44 00
			00 04 00
			00 04 00
			00 00 00
		.end
		; shift 6
		.hex
			00 0a 00
			00 0a 00
			00 0a 00
			00 0a 00
			00 08 00
			00 28 00
			00 28 00
			00 20 00
			00 20 00
			00 20 00
			00 20 00
			00 28 00
			00 28 01
			00 08 01
			00 08 04
			00 08 04
			00 28 00
			00 22 00
			00 22 00
			00 02 01
			40 00 01
			40 00 01
			40 00 01
			00 00 01
			00 20 04
			00 20 04
			00 20 00
			00 20 00
			00 08 01
			00 08 00
			00 08 00
			00 00 00
		.end

; $56 - lightning bolt
; 3x32 bytes, 7 pre-shifted copies of 96 bytes ($60)
spriteBolt2
		; shift 0
		.hex
			3c 00 00
			3c 00 00
			3c 00 00
			3c 00 00
			33 00 00
			73 01 00
			73 01 00
			40 01 00
			40 01 00
			40 01 00
			40 01 00
			70 01 00
			70 07 00
			30 06 00
			00 00 00
			0c 04 00
			4c 01 00
			4c 01 00
			43 01 00
			03 06 00
			03 06 00
			40 01 00
			40 01 00
			40 01 00
			40 01 00
			30 06 00
			30 06 00
			30 06 00
			30 06 00
			30 00 00
			30 00 00
			00 00 00
		.end
		; shift 1
		.hex
			78 00 00
			78 00 00
			78 00 00
			78 00 00
			66 00 00
			66 03 00
			66 03 00
			00 03 00
			00 03 00
			00 03 00
			00 03 00
			60 03 00
			60 0f 00
			60 0c 00
			00 00 00
			18 0c 00
			18 03 00
			18 03 00
			06 03 00
			06 0c 00
			06 0c 00
			00 03 00
			00 03 00
			00 03 00
			00 03 00
			60 0c 00
			60 0c 00
			60 0c 00
			60 0c 00
			60 00 00
			60 00 00
			00 00 00
		.end
		; shift 2
		.hex
			70 01 00
			70 01 00
			70 01 00
			70 01 00
			40 01 00
			40 07 00
			40 07 00
			00 06 00
			00 06 00
			00 06 00
			00 06 00
			40 07 00
			40 07 00
			40 01 00
			40 01 00
			40 01 00
			40 07 00
			30 06 00
			30 06 00
			30 18 00
			0c 18 00
			0c 18 00
			0c 66 00
			0c 66 00
			30 06 00
			30 00 00
			30 00 00
			30 00 00
			70 01 00
			4c 01 00
			4c 01 00
			40 01 00
		.end
		; shift 3
		.hex
			60 03 00
			60 03 00
			60 03 00
			60 03 00
			00 03 00
			00 0f 00
			00 0f 00
			60 0c 00
			60 0c 00
			60 0c 00
			18 0c 00
			18 0f 00
			00 0f 00
			00 03 00
			00 03 00
			00 03 00
			00 0f 00
			60 0c 00
			60 0c 00
			60 30 00
			18 30 00
			18 30 00
			78 00 00
			60 00 00
			60 03 00
			00 03 00
			00 03 00
			60 0c 00
			00 0c 00
			00 0c 00
			00 00 00
			00 00 00
		.end
		; shift 4
		.hex
			40 07 00
			40 07 00
			40 07 00
			40 07 00
			00 06 00
			00 1e 00
			00 1e 00
			00 18 00
			00 18 00
			00 18 00
			00 18 00
			00 1e 00
			00 1e 00
			00 06 00
			00 06 00
			00 06 00
			00 1e 00
			40 19 00
			40 19 00
			40 61 00
			30 60 00
			30 60 00
			30 18 03
			30 18 03
			40 19 00
			40 01 00
			40 01 00
			40 01 00
			40 07 00
			30 06 00
			30 06 00
			00 06 00
		.end
		; shift 5
		.hex
			00 0f 00
			00 0f 00
			00 0f 00
			00 0f 00
			60 0c 00
			60 3c 00
			60 3c 00
			00 30 00
			00 30 00
			00 30 00
			00 30 00
			00 3c 00
			00 7c 01
			00 4c 01
			00 00 00
			00 03 01
			00 33 00
			00 33 00
			60 30 00
			60 40 01
			60 40 01
			00 30 00
			00 30 00
			00 30 00
			00 30 00
			00 4c 01
			00 4c 01
			00 4c 01
			00 4c 01
			00 0c 00
			00 0c 00
			00 00 00
		.end
		; shift 6
		.hex
			00 1e 00
			00 1e 00
			00 1e 00
			00 1e 00
			00 18 00
			00 78 00
			00 78 00
			00 60 00
			00 60 00
			00 60 00
			00 60 00
			00 78 00
			00 78 03
			00 18 03
			00 18 0c
			00 18 0c
			00 78 00
			00 66 00
			00 66 00
			00 06 03
			40 01 03
			40 01 03
			40 01 03
			00 00 03
			00 60 0c
			00 60 0c
			00 60 00
			00 60 00
			00 18 03
			00 18 00
			00 18 00
			00 00 00
		.end

; $57 - monster walking, $57 / $58 (SHAPE_MONSTER)
; 3x9 bytes, 7 pre-shifted copies of 27 bytes ($1B)
spriteMonster1
		; shift 0
		.hex
			10 00 00
			40 08 00
			71 02 00
			54 0f 01
			70 02 00
			71 08 00
			10 06 00
			00 00 00
			00 00 00
		.end
		; shift 1
		.hex
			20 00 00
			00 01 00
			32 05 00
			38 00 02
			30 1d 00
			60 11 00
			28 0c 00
			00 00 00
			00 00 00
		.end
		; shift 2
		.hex
			00 02 00
			00 00 00
			00 00 00
			40 26 06
			04 2e 00
			60 22 00
			40 18 00
			00 00 00
			00 00 00
		.end
		; shift 3
		.hex
			00 02 00
			00 44 00
			18 14 00
			20 5e 00
			00 16 00
			00 40 06
			00 30 00
			00 00 00
			00 00 00
		.end
		; shift 4
		.hex
			00 26 00
			00 00 03
			00 22 0c
			40 41 01
			00 08 00
			00 0a 19
			30 62 00
			00 00 00
			00 00 00
		.end
		; shift 5
		.hex
			00 04 00
			00 13 22
			20 4c 00
			00 0d 03
			00 40 00
			20 06 02
			00 46 01
			00 00 08
			00 10 00
		.end
		; shift 6
		.hex
			00 18 00
			00 20 04
			40 01 01
			00 03 46
			00 22 03
			40 62 04
			00 18 03
			00 18 00
			00 00 00
		.end

; $58 - monster walking (SHAPE_MONSTER2)
; 3x10 bytes, 7 pre-shifted copies of 30 bytes ($1E)
spriteMonster2
		; shift 0
		.hex
			30 03 00
			00 03 00
			30 67 00
			0c 0c 00
			40 01 00
			70 59 01
			33 06 00
			40 01 00
			40 19 00
			30 00 00
		.end
		; shift 1
		.hex
			60 00 00
			00 33 00
			06 0c 00
			1c 18 03
			18 0f 00
			1e 33 00
			60 0e 00
			60 00 00
			00 00 00
			00 00 00
		.end
		; shift 2
		.hex
			60 46 01
			40 19 00
			30 00 00
			40 67 06
			0c 7e 00
			60 66 00
			40 19 00
			00 00 00
			00 00 00
			00 00 00
		.end
		; shift 3
		.hex
			00 03 06
			00 4c 01
			18 30 00
			60 4e 01
			00 36 00
			40 41 07
			30 30 00
			00 00 00
			00 00 00
			00 00 00
		.end
		; shift 4
		.hex
			00 66 06
			00 00 03
			60 00 0c
			40 41 01
			30 18 00
			00 06 1b
			30 66 03
			00 30 00
			00 00 00
			00 00 00
		.end
		; shift 5
		.hex
			00 0c 00
			00 30 06
			60 5c 01
			00 7f 33
			00 5c 01
			60 1c 06
			00 4c 01
			00 00 00
			00 00 00
			00 00 00
		.end
		; shift 6
		.hex
			00 00 00
			00 60 00
			40 01 00
			00 19 66
			00 00 00
			40 01 0c
			00 46 01
			00 18 03
			00 00 00
			00 00 00
		.end

; $59 - monster landing (end of the arc) / dying, $59 / $5A
; 3x5 bytes, 7 pre-shifted copies of 15 bytes ($0F)
spriteMonsterLand1
		; shift 0
		.hex
			40 00 00
			00 2a 00
			70 0e 00
			55 23 00
			10 00 00
		.end
		; shift 1
		.hex
			00 10 00
			00 63 00
			60 1d 00
			2c 07 00
			22 04 00
		.end
		; shift 2
		.hex
			10 00 00
			00 30 00
			40 2e 00
			10 0a 00
			4c 00 00
		.end
		; shift 3
		.hex
			00 04 00
			00 50 02
			00 77 00
			28 1d 02
			00 01 00
		.end
		; shift 4
		.hex
			00 00 01
			00 18 06
			00 6e 01
			60 3a 00
			10 22 00
		.end
		; shift 5
		.hex
			00 01 00
			00 00 03
			00 74 02
			00 51 00
			60 04 00
		.end
		; shift 6
		.hex
			00 20 00
			00 00 15
			00 38 07
			40 6a 11
			00 08 00
		.end

; $5A - monster landing / dying
; 3x5 bytes, 7 pre-shifted copies of 15 bytes ($0F)
spriteMonsterLand2
		; shift 0
		.hex
			40 01 00
			00 3e 00
			70 0e 00
			7f 37 00
			30 00 00
		.end
		; shift 1
		.hex
			00 30 00
			00 63 00
			60 1f 00
			6c 0f 00
			66 0c 00
		.end
		; shift 2
		.hex
			30 00 00
			00 30 00
			40 3f 00
			30 0e 00
			4c 01 00
		.end
		; shift 3
		.hex
			00 0c 00
			00 70 03
			00 77 00
			78 1f 03
			00 03 00
		.end
		; shift 4
		.hex
			00 00 03
			00 18 06
			00 6e 01
			60 7e 00
			30 66 00
		.end
		; shift 5
		.hex
			00 03 00
			00 00 03
			00 7c 03
			00 73 00
			60 0c 00
		.end
		; shift 6
		.hex
			00 60 00
			00 00 1f
			00 38 07
			40 7f 19
			00 18 00
		.end

; $5B - flame guarding the exit, first half (SHAPE_FLAME1 + flameFrame)
; 2x14 bytes, 7 pre-shifted copies of 28 bytes ($1C)
spriteFlame1A
		; shift 0
		.hex
			01 00
			01 00
			05 00
			04 00
			04 00
			14 00
			10 00
			10 00
			04 00
			04 00
			14 00
			11 00
			01 00
			01 00
		.end
		; shift 1
		.hex
			02 00
			02 00
			0a 00
			08 00
			08 00
			28 00
			20 00
			20 00
			08 00
			08 00
			28 00
			22 00
			02 00
			02 00
		.end
		; shift 2
		.hex
			04 00
			04 00
			14 00
			10 00
			10 00
			50 00
			40 00
			40 00
			10 00
			10 00
			50 00
			44 00
			04 00
			04 00
		.end
		; shift 3
		.hex
			08 00
			08 00
			28 00
			20 00
			20 00
			20 01
			00 01
			00 01
			20 00
			20 00
			20 01
			08 01
			08 00
			08 00
		.end
		; shift 4
		.hex
			10 00
			10 00
			50 00
			40 00
			40 00
			40 02
			00 02
			00 02
			40 00
			40 00
			40 02
			10 02
			10 00
			10 00
		.end
		; shift 5
		.hex
			20 00
			20 00
			20 01
			00 01
			00 01
			00 05
			00 04
			00 04
			00 01
			00 01
			00 05
			20 04
			20 00
			20 00
		.end
		; shift 6
		.hex
			40 00
			40 00
			40 02
			00 02
			00 02
			00 0a
			00 08
			00 08
			00 02
			00 02
			00 0a
			40 08
			40 00
			40 00
		.end

; $5C - flame, second half (SHAPE_FLAME2 + flameFrame)
; 2x14 bytes, 7 pre-shifted copies of 28 bytes ($1C)
spriteFlame2A
		; shift 0
		.hex
			03 00
			03 00
			0f 00
			0c 00
			0c 00
			3c 00
			30 00
			30 00
			0c 00
			0c 00
			3c 00
			33 00
			03 00
			03 00
		.end
		; shift 1
		.hex
			06 00
			06 00
			1e 00
			18 00
			18 00
			78 00
			60 00
			60 00
			18 00
			18 00
			78 00
			66 00
			06 00
			06 00
		.end
		; shift 2
		.hex
			0c 00
			0c 00
			3c 00
			30 00
			30 00
			70 01
			40 01
			40 01
			30 00
			30 00
			70 01
			4c 01
			0c 00
			0c 00
		.end
		; shift 3
		.hex
			18 00
			18 00
			78 00
			60 00
			60 00
			60 03
			00 03
			00 03
			60 00
			60 00
			60 03
			18 03
			18 00
			18 00
		.end
		; shift 4
		.hex
			30 00
			30 00
			70 01
			40 01
			40 01
			40 07
			00 06
			00 06
			40 01
			40 01
			40 07
			30 06
			30 00
			30 00
		.end
		; shift 5
		.hex
			60 00
			60 00
			60 03
			00 03
			00 03
			00 0f
			00 0c
			00 0c
			00 03
			00 03
			00 0f
			60 0c
			60 00
			60 00
		.end
		; shift 6
		.hex
			40 01
			40 01
			40 07
			00 06
			00 06
			00 1e
			00 18
			00 18
			00 06
			00 06
			00 1e
			40 19
			40 01
			40 01
		.end

; $5D - flame, first half, flameFrame 2
; 2x14 bytes, 7 pre-shifted copies of 28 bytes ($1C)
spriteFlame1B
		; shift 0
		.hex
			04 00
			04 00
			14 00
			10 00
			10 00
			54 00
			44 00
			41 00
			11 00
			10 00
			10 00
			44 00
			04 00
			04 00
		.end
		; shift 1
		.hex
			08 00
			08 00
			28 00
			20 00
			20 00
			28 01
			08 01
			02 01
			22 00
			20 00
			20 00
			08 01
			08 00
			08 00
		.end
		; shift 2
		.hex
			10 00
			10 00
			50 00
			40 00
			40 00
			50 02
			10 02
			04 02
			44 00
			40 00
			40 00
			10 02
			10 00
			10 00
		.end
		; shift 3
		.hex
			20 00
			20 00
			20 01
			00 01
			00 01
			20 05
			20 04
			08 04
			08 01
			00 01
			00 01
			20 04
			20 00
			20 00
		.end
		; shift 4
		.hex
			40 00
			40 00
			40 02
			00 02
			00 02
			40 0a
			40 08
			10 08
			10 02
			00 02
			00 02
			40 08
			40 00
			40 00
		.end
		; shift 5
		.hex
			00 01
			00 01
			00 05
			00 04
			00 04
			00 15
			00 11
			20 10
			20 04
			00 04
			00 04
			00 11
			00 01
			00 01
		.end
		; shift 6
		.hex
			00 02
			00 02
			00 0a
			00 08
			00 08
			00 2a
			00 22
			40 20
			40 08
			00 08
			00 08
			00 22
			00 02
			00 02
		.end

; $5E - flame, second half, flameFrame 2
; 2x14 bytes, 7 pre-shifted copies of 28 bytes ($1C)
spriteFlame2B
		; shift 0
		.hex
			0c 00
			0c 00
			3c 00
			30 00
			30 00
			7c 01
			4c 01
			43 01
			33 00
			30 00
			30 00
			4c 01
			0c 00
			0c 00
		.end
		; shift 1
		.hex
			18 00
			18 00
			78 00
			60 00
			60 00
			78 03
			18 03
			06 03
			66 00
			60 00
			60 00
			18 03
			18 00
			18 00
		.end
		; shift 2
		.hex
			30 00
			30 00
			70 01
			40 01
			40 01
			70 07
			30 06
			0c 06
			4c 01
			40 01
			40 01
			30 06
			30 00
			30 00
		.end
		; shift 3
		.hex
			60 00
			60 00
			60 03
			00 03
			00 03
			60 0f
			60 0c
			18 0c
			18 03
			00 03
			00 03
			60 0c
			60 00
			60 00
		.end
		; shift 4
		.hex
			40 01
			40 01
			40 07
			00 06
			00 06
			40 1f
			40 19
			30 18
			30 06
			00 06
			00 06
			40 19
			40 01
			40 01
		.end
		; shift 5
		.hex
			00 03
			00 03
			00 0f
			00 0c
			00 0c
			00 3f
			00 33
			60 30
			60 0c
			00 0c
			00 0c
			00 33
			00 03
			00 03
		.end
		; shift 6
		.hex
			00 06
			00 06
			00 1e
			00 18
			00 18
			00 7e
			00 66
			40 61
			40 19
			00 18
			00 18
			00 66
			00 06
			00 06
		.end

; $5F - player leaving (SHAPE_LEAVE)
; 3x16 bytes, 7 pre-shifted copies of 48 bytes ($30)
spriteLeave
		; shift 0
		.hex
			30 00 00
			3c 00 00
			4c 01 00
			0f 00 00
			00 00 00
			3c 00 00
			7c 01 00
			5c 07 00
			40 07 00
			7c 00 00
			7c 03 00
			7c 07 00
			1f 06 00
			0f 3e 00
			03 1e 00
			03 06 00
		.end
		; shift 1
		.hex
			60 00 00
			78 00 00
			18 03 00
			1e 00 00
			00 00 00
			78 00 00
			78 03 00
			38 0f 00
			00 0f 00
			78 01 00
			78 07 00
			78 0f 00
			3e 0c 00
			1e 7c 00
			06 3c 00
			06 0c 00
		.end
		; shift 2
		.hex
			40 01 00
			70 01 00
			30 06 00
			3c 00 00
			00 00 00
			70 01 00
			70 07 00
			70 1e 00
			00 1e 00
			70 03 00
			70 0f 00
			70 1f 00
			7c 18 00
			3c 78 01
			0c 78 00
			0c 18 00
		.end
		; shift 3
		.hex
			00 03 00
			60 03 00
			60 0c 00
			78 00 00
			00 00 00
			60 03 00
			60 0f 00
			60 3d 00
			00 3c 00
			60 07 00
			60 1f 00
			60 3f 00
			78 31 00
			78 70 03
			18 70 01
			18 30 00
		.end
		; shift 4
		.hex
			00 06 00
			40 07 00
			40 19 00
			70 01 00
			00 00 00
			40 07 00
			40 1f 00
			40 7b 00
			00 78 00
			40 0f 00
			40 3f 00
			40 7f 00
			70 63 00
			70 61 07
			30 60 03
			30 60 00
		.end
		; shift 5
		.hex
			00 0c 00
			00 0f 00
			00 33 00
			60 03 00
			00 00 00
			00 0f 00
			00 3f 00
			00 77 01
			00 70 01
			00 1f 00
			00 7f 00
			00 7f 01
			60 47 01
			60 43 0f
			60 40 07
			60 40 01
		.end
		; shift 6
		.hex
			00 18 00
			00 1e 00
			00 66 00
			40 07 00
			00 00 00
			00 1e 00
			00 7e 00
			00 6e 03
			00 60 03
			00 3e 00
			00 7e 01
			00 7e 03
			40 0f 03
			40 07 1f
			40 01 0f
			40 01 03
		.end

; $60 - mover hit, shrinking, $60-$62 (moverHitShapes)
; 3x6 bytes, 7 pre-shifted copies of 18 bytes ($12)
spriteMoverHit1
		; shift 0
		.hex
			00 00 00
			78 01 00
			2e 07 00
			2b 0d 00
			2e 07 00
			78 01 00
		.end
		; shift 1
		.hex
			00 00 00
			70 03 00
			5c 0e 00
			56 1a 00
			5c 0e 00
			70 03 00
		.end
		; shift 2
		.hex
			00 00 00
			60 07 00
			38 1d 00
			2c 35 00
			38 1d 00
			60 07 00
		.end
		; shift 3
		.hex
			00 00 00
			40 0f 00
			70 3a 00
			58 6a 00
			70 3a 00
			40 0f 00
		.end
		; shift 4
		.hex
			00 00 00
			00 1f 00
			60 75 00
			30 55 01
			60 75 00
			00 1f 00
		.end
		; shift 5
		.hex
			00 00 00
			00 3e 00
			40 6b 01
			60 2a 03
			40 6b 01
			00 3e 00
		.end
		; shift 6
		.hex
			00 00 00
			00 7c 00
			00 57 03
			40 55 06
			00 57 03
			00 7c 00
		.end

; $61 - mover hit
; 3x5 bytes, 7 pre-shifted copies of 15 bytes ($0F)
spriteMoverHit2
		; shift 0
		.hex
			00 00 00
			00 00 00
			7e 07 00
			3b 0d 00
			7e 07 00
		.end
		; shift 1
		.hex
			00 00 00
			00 00 00
			7c 0f 00
			76 1a 00
			7c 0f 00
		.end
		; shift 2
		.hex
			00 00 00
			00 00 00
			78 1f 00
			6c 35 00
			78 1f 00
		.end
		; shift 3
		.hex
			00 00 00
			00 00 00
			70 3f 00
			58 6b 00
			70 3f 00
		.end
		; shift 4
		.hex
			00 00 00
			00 00 00
			60 7f 00
			30 57 01
			60 7f 00
		.end
		; shift 5
		.hex
			00 00 00
			00 00 00
			40 7f 01
			60 2e 03
			40 7f 01
		.end
		; shift 6
		.hex
			00 00 00
			00 00 00
			00 7f 03
			40 5d 06
			00 7f 03
		.end

; $62 - mover hit
; 3x4 bytes, 7 pre-shifted copies of 12 bytes ($0C)
spriteMoverHit3
		; shift 0
		.hex
			00 00 00
			00 00 00
			00 00 00
			7f 0f 00
		.end
		; shift 1
		.hex
			00 00 00
			00 00 00
			00 00 00
			7e 1f 00
		.end
		; shift 2
		.hex
			00 00 00
			00 00 00
			00 00 00
			7c 3f 00
		.end
		; shift 3
		.hex
			00 00 00
			00 00 00
			00 00 00
			78 7f 00
		.end
		; shift 4
		.hex
			00 00 00
			00 00 00
			00 00 00
			70 7f 01
		.end
		; shift 5
		.hex
			00 00 00
			00 00 00
			00 00 00
			60 7f 03
		.end
		; shift 6
		.hex
			00 00 00
			00 00 00
			00 00 00
			40 7f 07
		.end

; $8BE2-$8BFF: sector slack
		placeAt	$8C00

; the chandelier falling (drawChandelier): 18 lines x 5 bytes, drawn at
; screen column $11
chandelier
		.hex
	00 00 00 00 00 00 00 00 00 00 00 C0 80 00 00 00
	00 00 00 00 00 C0 80 00 00 00 00 00 00 00 00 C0
	80 00 00 00 D0 82 00 00 81 D0 82 A0 00 84 C2 C0
	80 81 90 C8 C1 88 80 C4 C0 D3 A2 00 82 D2 C3 90
	80 82 C1 A0 90 80 9A C5 A9 9C 00 B8 D7 EB 8D 00
	00 9C 9A 00 00 00 90 82 00 00
		.end

; $8C5A-$8CFF: leftover memory
		.hex
	00 00 00 00 00 A0 00 A9 03 20 D9 03 60 00 86 00
	81 C0 88 81 C0 88 81 C0 80 81 C0 80 81 C0 80 81
	C0 80 81 C0 80 81 C0 80 81 C0 80 81 C0 88 81 C0
	88 81 C0 88 81 F0 EA 81 C0 88 81 80 91 82 E0 D5
	83 80 91 82 80 91 82 80 91 82 80 91 82 80 81 82
	80 81 82 80 81 82 80 81 82 80 81 82 80 81 82 80
	81 82 80 91 82 80 91 82 80 91 82 E0 D5 83 80 91
	82 80 A2 84 C0 AB 87 80 A2 84 80 A2 84 80 A2 84
	80 A2 84 80 82 84 80 82 84 80 82 84 80 82 84 80
	82 84 80 82 84 80 82 84 80 A2 84 80 A2 84 80 A2
	84 C0 AB 87 80 A2
		.end

; the chandelier crashing on the centre machine (drawCrashFrame): 6 frames
; of 25 lines x 5 bytes ($7D), one every $80, drawn at column $10, lines
; $41-$59
crashFrames
		.hex
	00 00 90 85 00 00 00 95 81 00 00 00 8C D0 80 00
	80 94 92 90 00 80 D0 A6 81 00 88 D0 A1 83 00 82
	C0 EA A8 00 8A C1 9A 88 C0 AA 85 A8 85 C0 AE 81
	A0 83 C0 AE C4 E0 A1 A0 D5 92 D0 A1 D0 AA 85 A2
	95 D0 AA 95 8A 81 D0 AA D5 A8 81 D0 AA D5 AA 81
	D0 AA D5 AA 81 D0 AA D5 AA 81 A0 D5 AA D5 80 C0
	BE D5 AA 80 C0 BA D5 AA 80 C0 FA D5 AA 80 C0 EA
	D5 AA 00 00 EA D5 8A 00 00 AA D5 8A 00 00 00 00
	00 00 80 80 00 00 00 80 80 00 00 00 80 80 80 00
	80 80 81 80 00 80 90 85 84 00 80 B4 80 80 00 82
	8D 82 84 00 82 C4 C0 80 C0 A2 C4 A1 81 C0 AE C1
	EB 80 C0 AE C0 9A 88 A0 D5 C2 A8 89 D0 AA 91 A0
	83 D0 AA 91 82 80 D0 AA D0 E0 A9 D0 AA C5 80 80
	D0 AA D5 A8 81 D0 AA D5 AA 81 A0 D5 AA D5 80 C0
	BE D5 AA 80 C0 BA D5 AA 80 C0 FA D5 AA 80 C0 EA
	D5 AA 00 00 EA D5 8A 00 00 AA D5 8A 00 00 00 00
	00 00 80 80 00 00 00 80 80 00 00 00 80 80 80 00
	80 80 80 80 00 80 80 80 80 00 80 80 80 80 00 82
	80 80 80 00 82 82 A0 80 C0 A2 82 81 80 C0 AE A1
	89 80 C0 AE B4 80 80 A0 D5 8E C2 80 D0 AA D1 D0
	80 D0 AA 91 98 80 D0 AA D0 8E 80 D0 AA C5 80 80
	D0 AA D5 A0 80 D0 AA D5 A8 81 A0 D5 AA C5 80 C0
	BE D5 AA 80 C0 BA D5 AA 80 C0 FA D5 AA 80 C0 EA
	D5 AA 00 00 EA D5 8A 00 00 AA D5 8A 00 00 00 00
	00 00 80 80 00 00 00 80 80 00 00 00 80 80 80 00
	80 80 80 80 00 80 80 80 80 00 80 80 80 80 00 82
	90 80 80 00 82 90 80 80 C0 A2 80 80 80 C0 AE 81
	88 80 C0 AE 80 80 81 A0 D5 C2 80 80 D0 AA 81 80
	80 D0 AA 91 80 80 D0 AA 80 A0 80 D0 AA C1 80 80
	D0 AA D1 80 84 D0 AA 95 88 80 A0 D5 AA 84 80 C0
	BE D5 AA 80 C0 BA D5 AA 90 C0 FA D5 AA 80 C0 EA
	D5 AA 00 00 EA D5 8A 00 00 AA D5 8A 00 00 00 00
	00 00 80 82 00 00 00 80 82 00 00 00 80 80 80 00
	80 80 80 80 00 80 80 80 80 00 80 80 80 80 00 82
	80 80 80 00 82 80 80 80 C0 A2 80 80 80 C0 AE 81
	80 80 C0 AE 80 80 80 A0 D5 80 80 80 D0 AA 80 80
	90 D0 AA 81 80 80 D0 AA 80 82 80 D0 AA F1 80 80
	D0 AA D1 80 80 D0 AA 95 88 80 A0 D5 AA 84 80 C0
	BE D5 A2 80 C0 BA D5 AA 80 C0 FA D5 AA 80 C0 EA
	D5 AA 00 00 EA D5 8A 84 00 AA D5 8A C0 00 00 00
	00 00 80 80 00 00 00 80 80 00 00 00 80 80 80 00
	80 80 80 80 00 80 80 80 80 00 80 80 80 80 00 82
	80 80 80 00 82 80 80 80 C0 A2 80 80 80 C0 AE 81
	80 80 C0 AE 80 80 80 A0 D5 80 80 80 D0 AA 80 80
	80 D0 AA 81 80 80 D0 AA 80 80 80 D0 8A C1 80 80
	D0 AA D1 80 80 D0 AA 95 80 80 A0 D5 AA 84 80 C0
	BE D5 A2 80 C0 BA D5 AA 80 C0 FA D5 AA 80 C0 EA
	D5 AA 00 00 EA D5 8A 80 00 AA D5 8A 80 00 00 00
		.end

; where the monsters turn back (checkTurns): X / Y pairs, list ends at Y=0
turnX
		.hex
	05 83 13 3C 4D 83 06 10 19 36 48 83 01 2C 54 81
	06 27 00 00 00 00 00 00
		.end
turnY
		.hex
	A5 A5 81 81 81 81 57 57 57 57 57 57 2F 2F 2F 2F
	07 07 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	00 00 00 00 00 00 00 00
		.end

onPlatform	.db	$00			; $FF while the player rides the lower platform: the monsters don't kill him

; $9041-$9047: leftover memory
		.hex
	78 7F 7F 00 00 08 04
		.end

; WAIT per frame, by the number of monsters out (0..6): the more, the faster
waitByMonsters
		.hex
	50 40 30 20 10 01 01 01
		.end

; $9050-$90FF: leftover memory
		.hex
	01 0A 00 00 00 00 00 00 AA 85 00 00 00 54 02 00
	AA 85 00 00 00 00 00 D5 82 00 00 00 2A 01 00 D5
	82 00 00 00 00 00 81 2E 00 00 00 00 00 00 00 00
	55 2A 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	00 00 C0 80 00 00 00 00 00 00 00 00 00 00 00 00
	00 00 00 00 00 20 55 2A 55 0A 00 50 0A 00 00 00
	2A 01 AA 85 00 00 00 00 00 AA D5 8A 80 00 00 00
	00 00 AA 85 00 00 28 05 00 D5 82 50 0A 00 50 2A
	55 0A 00 00 00 00 00 00 AA 85 00 00 00 04 02 00
	AA 85 00 00 00 00 00 D5 82 00 00 00 02 01 00 D5
	82 00 00 00 00 00 50 2A 00 00 00 00 00 00 00 00
		.end

; the mover's 8 scripts, $20 steps each (startMover picks one at random):
; per step a shape ($41-$43, 0 ends the script), a move per frame (dX, dY)
; and how many frames it lasts
moverScriptShape
		.hex
	43 41 41 43 42 43 41 43 42 42 42 43 43 41 43 42
	43 41 43 42 43 42 43 41 43 42 42 42 43 42 43 00
	41 43 41 41 43 42 43 41 43 41 43 42 43 42 43 00
	00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	43 41 43 42 43 43 42 42 43 41 41 41 41 41 41 43
	42 43 41 43 42 43 42 42 43 42 43 42 43 41 43 00
	41 42 41 43 41 43 42 43 41 43 42 43 41 43 41 41
	43 43 42 42 41 41 43 42 42 42 43 00 00 00 00 00
	41 43 41 43 42 43 41 42 42 42 43 41 43 41 41 42
	43 42 43 41 43 42 43 41 00 00 00 00 00 00 00 00
	43 41 43 41 42 42 43 41 43 42 43 43 42 42 43 41
	43 42 43 41 41 43 42 43 41 43 42 43 41 43 00 00
	42 41 41 43 41 42 42 43 41 43 42 43 43 41 41 43
	42 43 41 43 00 00 00 00 00 00 00 00 00 00 00 00
	41 43 43 42 42 43 41 41 43 41 42 43 43 41 43 42
	42 41 42 41 41 43 41 42 42 42 41 42 43 43 00 00
		.end
moverScriptDX
		.hex
	00 FF 00 00 00 00 FF 00 01 01 01 00 00 FF 00 00
	00 00 00 01 00 00 00 FF 00 02 02 01 00 00 00 00
	FE 00 FF FF 00 02 00 FE 00 00 00 00 00 01 00 00
	00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	00 FF 00 00 00 00 01 01 00 FF FF FF FF FF FF 00
	01 00 FF 00 00 00 00 01 00 02 00 00 00 00 00 00
	FE 01 FE 00 FE 00 02 00 FF 00 00 00 00 00 FE FF
	00 00 00 01 FE FE 00 02 01 02 00 00 00 00 00 00
	FE 00 FE 00 00 00 FF 02 01 02 00 FE 00 FE FF 02
	00 00 00 FF 00 02 00 FF 00 00 00 00 00 00 00 00
	00 FE 00 FE 02 02 00 FE 00 02 00 00 02 02 00 FE
	00 00 00 FE FE 00 01 00 FE 00 02 00 00 00 00 00
	01 FF FE 00 FF 01 02 00 FE 00 03 00 00 00 FF 00
	00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	FE 00 00 02 02 00 FE FE 00 FE 02 00 00 00 00 02
	00 FE 03 FF FE 00 FE 02 02 01 FE 02 00 00 00 00
		.end
moverScriptDY
		.hex
	01 00 00 00 00 01 00 01 00 02 00 FF 00 00 FF 00
	00 00 00 FF FF 00 00 01 01 00 FE FE FE 00 FE 00
	00 01 01 00 00 00 00 00 FE 00 00 00 00 00 FF 00
	00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	01 00 00 00 00 01 01 00 FF 00 FF FE 02 01 00 01
	00 01 01 01 00 FF 00 FF FF 00 FE 00 00 00 FE 00
	00 02 01 01 01 01 00 FF 00 01 00 00 00 FE 00 FE
	FE 00 00 00 FE 02 00 00 FE 00 FE 00 00 00 00 00
	00 02 01 FF 00 00 02 00 02 00 00 00 FF 00 02 01
	FF 00 00 00 FE 00 FE FF 00 00 00 00 00 00 00 00
	02 01 02 00 FF 01 00 00 02 00 FF 03 01 00 FF 00
	00 00 00 00 FF FE FF FE 00 FF 00 00 00 FD 00 00
	01 01 00 01 00 FF 00 FE 00 FF 00 00 FF 00 00 FF
	00 00 00 FF 00 00 00 00 00 00 00 00 00 00 00 00
	00 02 00 01 00 FF 01 00 02 00 01 03 00 00 00 01
	00 03 00 FF 00 FE 00 FF 01 FD 00 FF 00 FE 00 00
		.end
moverScriptTime
		.hex
	37 32 04 04 04 28 1E 2C 28 12 2F 0D 11 73 18 07
	03 04 03 09 2F 06 04 09 05 0E 05 06 0A 05 22 00
	15 0F 28 0B 05 3A 05 1E 07 05 03 05 08 19 2D 00
	00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	37 17 03 04 03 1A 0E 22 0E 2C 04 0D 08 0E 1F 0E
	09 1F 08 25 05 25 05 08 1D 0D 2A 05 03 04 1B 00
	0C 12 16 0E 0F 33 35 10 39 30 05 03 05 10 14 09
	0B 04 05 0F 07 04 03 0D 19 11 1A 00 00 00 00 00
	1A 13 11 0E 03 03 08 20 13 12 04 13 0F 05 03 0A
	0C 04 03 13 0D 16 12 1B 00 00 00 00 00 00 00 00
	13 19 0E 14 05 0D 04 0E 13 18 0B 0C 0D 10 06 28
	07 06 03 0D 05 0C 0A 11 05 0C 13 03 06 26 00 00
	18 21 15 24 26 0B 0D 0C 15 03 27 02 09 05 51 1B
	05 03 05 15 00 00 00 00 00 00 00 00 00 00 00 00
	1B 10 05 14 12 13 16 0F 0E 13 05 0C 06 05 03 01
	08 04 25 0C 2E 0E 05 06 0A 0E 19 17 06 17 00 00
		.end
