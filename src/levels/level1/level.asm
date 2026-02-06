	.namespace level1

	.module "L1.BKGD"

	.segment L1_BKGD
	.include "bkgnd.data.asm"

	.module "L1.DATA"

	.segment L1_DATA
	.include "sprites-dir.data.asm"
	.include "data-R2-7900.asm"
	.include "sprites.data.asm"

	.module "L1.CODE"

	.segment L1_CODE
	.include "code.asm"
	.include "data-R4-A200.asm"
	.include "level1.data-R5-AC00.asm"


	assertGameStruct

	.end namespace
