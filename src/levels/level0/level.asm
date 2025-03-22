	.namespace level0

	.segment L0_BKGD
	.include "data-bkgnd-R0-7500.asm"

	.segment L0_DATA
	.include "data-R1-7500.asm"
	.include "data-R2-7900.asm"
	.include "data-R3-7A00.asm"

	.segment L0_CODE
	.include "code-R4-A000.asm"

	.segment L0_BITMAP
	.include "data-A600.asm"

	assertGameStruct

	.end
