	.macro defsprite width, height, addr {
		.db width
		.db height
		.repeat 7 as idx
			.dw addr + (width * (height & $7F) * (idx-1))
		.end
	}

sprites:

	; 0-9 digits
	defsprite $02, $05, $4000
	defsprite $02, $05, $4046
	defsprite $02, $05, $408C
	defsprite $02, $05, $40D2
	defsprite $02, $05, $4118
	defsprite $02, $05, $415E
	defsprite $02, $05, $41A4
	defsprite $02, $05, $41EA
	defsprite $02, $05, $4230
	defsprite $02, $05, $4276

	; 10-15 Conan Walk/Stand
	defsprite $03, $10, $42BC ; 10
	defsprite $03, $10, $440C ; 11
	defsprite $03, $90, $455C ; 12
	defsprite $03, $8F, $46AC ; 13
	defsprite $03, $90, $47E7 ; 14
	defsprite $03, $0F, $4937 ; 15

	; 16-19 Conan
	defsprite $03, $0C, $4A72 ; 16
	defsprite $03, $8B, $4B6E ; 17
	defsprite $03, $8C, $4C55 ; 18
	defsprite $03, $0B, $4D51 ; 19

	; 20-23 Conan
	defsprite $04, $10, $4E38 ; 20
	defsprite $04, $90, $4FF8 ; 21
	defsprite $04, $90, $51B8 ; 22
	defsprite $04, $90, $5378 ; 23

	; 24-27 Conan
	defsprite $03, $10, $5538 ; 24
	defsprite $03, $0E, $5688 ; 25
	defsprite $03, $0C, $57AE ; 26
	defsprite $03, $10, $58AA ; 27

	; 28-31 Conan / Axe
	defsprite $03, $10, $59FA ; 28
	defsprite $03, $09, $5B4A ; 29
	defsprite $03, $05, $5C07 ; 30
	defsprite $03, $05, $5C70 ; 31

	; 32-37 Axe
	defsprite $02, $84, $5CD9 ; 32
	defsprite $02, $84, $5D11 ; 33
	defsprite $02, $84, $5D49 ; 34
	defsprite $02, $87, $5D81 ; 35
	defsprite $02, $87, $5DE3 ; 36
	defsprite $02, $88, $5E45 ; 37

	; 38-41
	defsprite $03, $83, $5EB5 ; 38
	defsprite $02, $85, $5EF4 ; 39
	defsprite $02, $84, $5F3A ; 40
	defsprite $03, $12, $5F72 ; 41

	; 42-45 Conan Jump
	defsprite $03, $8C, $60EC ; 42
	defsprite $03, $8B, $61E8 ; 43
	defsprite $03, $8C, $62CF ; 44
	defsprite $03, $0B, $63CB ; 45

	; 46-49 Conan Jump
	defsprite $03, $8C, $64B2 ; 46
	defsprite $03, $0C, $65AE ; 47
	defsprite $03, $8C, $66AA ; 48
	defsprite $03, $0C, $67A6 ; 49

	; 50-53 Conan Jump
	defsprite $03, $8A, $68A2 ; 50
	defsprite $03, $0A, $6974 ; 51
	defsprite $03, $8A, $6A46 ; 52
	defsprite $03, $0A, $6B18 ; 53
