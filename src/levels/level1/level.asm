
.namespace level1

	.segment L1_BKGD
	.include "data-bkgnd-R0-7500.asm"

	.segment L1_DATA
	.include "data-R1-7500.asm"
	.include "data-R2-7900.asm"
	.include "data-R3-7A00.asm"

	.segment L1_CODE
	.include "level1.code-R4-A000.asm"
	.include "data-R4-A200.asm"
	.include "level1.data-R5-AC00.asm"


	assertGameStruct

.end
