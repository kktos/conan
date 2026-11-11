	.namespace level8

	.module "L8/BKGD"
	.segment L8_BKGD
	.incbin "../../../assets/bkgnd/L8_c0_7500.bin"

	.module "L8/DATA"
	.segment L8_DATA
	.include "data-R1-7500.asm"
	.include "data-R2-7900.asm"
	.include "data-R3-7A00.asm"

	.module "L8/CODE"
	.segment L8_CODE
	.include "code.asm"
	.include "data-R5-AC00.asm"

	; no game over pictures: the player can't die in the ending (disk 2 has none for level 8)

	assertGameStruct

	.end namespace
