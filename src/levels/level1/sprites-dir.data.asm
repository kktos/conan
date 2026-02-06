; data-R1-7500

	.include "../../includes/defsprite.macro.asm"

; sprite width, height
L7500
	; 03 0a 00 7a 1e 7a 3c 7a 5a 7a 78 7a 96 7a b4 7a
	; 03 10 d2 7a 02 7b 32 7b 62 7b 92 7b c2 7b f2 7b
	; 03 10 22 7c 52 7c 82 7c b2 7c e2 7c 12 7d 42 7d

	defprite $03, $0A, $7A00
	defprite $03, $10, $7AD2
	defprite $03, $10, $7C22

	; $44-$46 - Explosion animation sequence (falling).
	defprite $04, $0B, $7D72
	defprite $04, $0C, $7EA6
	defprite $03, $09, $7FF6

	; 04 0b 72 7d 9e 7d ca 7d f6 7d 22 7e 4e 7e 7a 7e
	; 04 0c a6 7e d6 7e 06 7f 36 7f 66 7f 96 7f c6 7f
	; 03 09 f6 7f 11 80 2c 80 47 80 62 80 7d 80 98 80
	; 03 04 b3 80 bf 80 cb 80 d7 80 e3 80 ef 80 fb 80
	; 03 04 07 81 13 81 1f 81 2b 81 37 81 43 81 4f 81
	; 03 04 5b 81 67 81 73 81 7f 81 8b 81 97 81 a3 81

	; $47-$49 -  Splash/Dust animation sequence (hitting ground).
	defprite $03, $04, $80B3
	defprite $03, $04, $8107
	defprite $03, $04, $815B

;L7580
/*
	.hex
	c3 e6 17 d0 bf c5 02 f0 d7 ec a3 23 f0 d2 e6 00
	00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.end
L75c0
	.hex
	00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
	.end
*/
