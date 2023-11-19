
	.namespace level2

	.segment L2_BKGD
	.include "data-bkgnd-R0-7500.asm"

	.segment L2_DATA
	.include "data-R1-7500.asm"
	.include "data-R2-7900.asm"
	.include "data-R3-7A00.asm"

	.segment L2_CODE
	.include "code-R4-A000.asm"
	; .include "data-R4-A200.asm"
	.include "data-R5-AC00.asm"
