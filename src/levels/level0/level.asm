	.namespace level0

	.module "L0.BKGD"
	.segment L0_BKGD
	.include "data-bkgnd-R0-7500.asm"

	.module "L0.DATA"
	.segment L0_DATA
	.include "data-R1-7500.asm"
	.include "variables.asm"
	.include "data-R3-7A00.asm"

	.module "L0.CODE"
	.segment L0_CODE
	.include "code.asm"

	.module "L0.BMP"
	.segment L0_BITMAP
	.include "data-A600.asm"

	assertGameStruct

	.end namespace
