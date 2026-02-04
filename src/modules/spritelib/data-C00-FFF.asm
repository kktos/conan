	.macro defprite width, height, w1, w2, w3, w4, w5, w6, w7 {
		.db width
		.db height
		.dw w1, w2, w3, w4
		.dw w5, w6, w7
	}

sprites:

	; 0-9 digits
	defprite $02, $05, $4000, $400A, $4014, $401E, $4028, $4032, $403C
	defprite $02, $05, $4046, $4050, $405A, $4064, $406E, $4078, $4082
	defprite $02, $05, $408C, $4096, $40A0, $40AA, $40B4, $40BE, $40C8
	defprite $02, $05, $40D2, $40DC, $40E6, $40F0, $40FA, $4104, $410E
	defprite $02, $05, $4118, $4122, $412C, $4136, $4140, $414A, $4154
	defprite $02, $05, $415E, $4168, $4172, $417C, $4186, $4190, $419A
	defprite $02, $05, $41A4, $41AE, $41B8, $41C2, $41CC, $41D6, $41E0
	defprite $02, $05, $41EA, $41F4, $41FE, $4208, $4212, $421C, $4226
	defprite $02, $05, $4230, $423A, $4244, $424E, $4258, $4262, $426C
	defprite $02, $05, $4276, $4280, $428A, $4294, $429E, $42A8, $42B2

	; 10-15 Conan Walk/Stand
	defprite $03, $10, $42BC, $42EC, $431C, $434C, $437C, $43AC, $43DC ; 10
	defprite $03, $10, $440C, $443C, $446C, $449C, $44CC, $44FC, $452C ; 11
	defprite $03, $90, $455C, $458C, $45BC, $45EC, $461C, $464C, $467C ; 12
	defprite $03, $8F, $46AC, $46D9, $4706, $4733, $4760, $478D, $47BA ; 13
	defprite $03, $90, $47E7, $4817, $4847, $4877, $48A7, $48D7, $4907 ; 14
	defprite $03, $0F, $4937, $4964, $4991, $49BE, $49EB, $4A18, $4A45 ; 15

	; 16-19 Conan
	defprite $03, $0C, $4A72, $4A96, $4ABA, $4ADE, $4B02, $4B26, $4B4A ; 16
	defprite $03, $8B, $4B6E, $4B8F, $4BB0, $4BD1, $4BF2, $4C13, $4C34 ; 17
	defprite $03, $8C, $4C55, $4C79, $4C9D, $4CC1, $4CE5, $4D09, $4D2D ; 18
	defprite $03, $0B, $4D51, $4D72, $4D93, $4DB4, $4DD5, $4DF6, $4E17 ; 19

	; 20-23 Conan
	defprite $04, $10, $4E38, $4E78, $4EB8, $4EF8, $4F38, $4F78, $4FB8 ; 20
	defprite $04, $90, $4FF8, $5038, $5078, $50B8, $50F8, $5138, $5178 ; 21
	defprite $04, $90, $51B8, $51F8, $5238, $5278, $52B8, $52F8, $5338 ; 22
	defprite $04, $90, $5378, $53B8, $53F8, $5438, $5478, $54B8, $54F8 ; 23

	; 24-27 Conan
	defprite $03, $10, $5538, $5568, $5598, $55C8, $55F8, $5628, $5658 ; 24
	defprite $03, $0E, $5688, $56B2, $56DC, $5706, $5730, $575A, $5784 ; 25
	defprite $03, $0C, $57AE, $57D2, $57F6, $581A, $583E, $5862, $5886 ; 26
	defprite $03, $10, $58AA, $58DA, $590A, $593A, $596A, $599A, $59CA ; 27

	; 28-31 Conan / Axe
	defprite $03, $10, $59FA, $5A2A, $5A5A, $5A8A, $5ABA, $5AEA, $5B1A ; 28
	defprite $03, $09, $5B4A, $5B65, $5B80, $5B9B, $5BB6, $5BD1, $5BEC ; 29
	defprite $03, $05, $5C07, $5C16, $5C25, $5C34, $5C43, $5C52, $5C61 ; 30
	defprite $03, $05, $5C70, $5C7F, $5C8E, $5C9D, $5CAC, $5CBB, $5CCA ; 31

	; 32-37 Axe
	defprite $02, $84, $5CD9, $5CE1, $5CE9, $5CF1, $5CF9, $5D01, $5D09 ; 32
	defprite $02, $84, $5D11, $5D19, $5D21, $5D29, $5D31, $5D39, $5D41 ; 33
	defprite $02, $84, $5D49, $5D51, $5D59, $5D61, $5D69, $5D71, $5D79 ; 34
	defprite $02, $87, $5D81, $5D8F, $5D9D, $5DAB, $5DB9, $5DC7, $5DD5 ; 35
	defprite $02, $87, $5DE3, $5DF1, $5DFF, $5E0D, $5E1B, $5E29, $5E37 ; 36
	defprite $02, $88, $5E45, $5E55, $5E65, $5E75, $5E85, $5E95, $5EA5 ; 37

	; 38-41
	defprite $03, $83, $5EB5, $5EBE, $5EC7, $5ED0, $5ED9, $5EE2, $5EEB ; 38
	defprite $02, $85, $5EF4, $5EFE, $5F08, $5F12, $5F1C, $5F26, $5F30 ; 39
	defprite $02, $84, $5F3A, $5F42, $5F4A, $5F52, $5F5A, $5F62, $5F6A ; 40
	defprite $03, $12, $5F72, $5FA8, $5FDE, $6014, $604A, $6080, $60B6 ; 41

	; 42-45 Conan Jump
	defprite $03, $8C, $60EC, $6110, $6134, $6158, $617C, $61A0, $61C4 ; 42
	defprite $03, $8B, $61E8, $6209, $622A, $624B, $626C, $628D, $62AE ; 43
	defprite $03, $8C, $62CF, $62F3, $6317, $633B, $635F, $6383, $63A7 ; 44
	defprite $03, $0B, $63CB, $63EC, $640D, $642E, $644F, $6470, $6491 ; 45

	; 46-49 Conan Jump
	defprite $03, $8C, $64B2, $64D6, $64FA, $651E, $6542, $6566, $658A ; 46
	defprite $03, $0C, $65AE, $65D2, $65F6, $661A, $663E, $6662, $6686 ; 47
	defprite $03, $8C, $66AA, $66CE, $66F2, $6716, $673A, $675E, $6782 ; 48
	defprite $03, $0C, $67A6, $67CA, $67EE, $6812, $6836, $685A, $687E ; 49

	; 50-53 Conan Jump
	defprite $03, $8A, $68A2, $68C0, $68DE, $68FC, $691A, $6938, $6956 ; 50
	defprite $03, $0A, $6974, $6992, $69B0, $69CE, $69EC, $6A0A, $6A28 ; 51
	defprite $03, $8A, $6A46, $6A64, $6A82, $6AA0, $6ABE, $6ADC, $6AFA ; 52
	defprite $03, $0A, $6B18, $6B36, $6B54, $6B72, $6B90, $6BAE, $6BCC ; 53

	.hex
		80 80 80 FF FF 80 80 80 FF FF 80 80 80 FF FF 80
		80 80 FF FF 80 80 80 FF FF 80 80 80 FF FF 80 80
		80 FF FF 80 80 80 FF FF 80 80 80 FF FF 80 80 80
		FF FF 80 80 80 FF FF 80 80 80 FF FF 80 80 80 FF
		FF 80 80 80 FF FF 80 80 80 FF FF 80 80 80 FF FF
		80 80 80 FF FF 80 80 80 FF FF 80 80 80 FF FF 80
		80 80 FF FF 80 80 80 FF FF 80 80 80 FF FF 80 80
		80 FF FF 80 80 80 FF FF 80 80 80 FF FF 80 80 80
		FF FF 80 80 80 FF FF 80 80 80 FF FF 80 80 80 FF
		FF 80 80 80 FF FF 80 80 80 FF FF 80 00 00 00 00
	.end
