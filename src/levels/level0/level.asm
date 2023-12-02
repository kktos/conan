;		.namespace level0
;		.include "data-R0-7500.asm"
;		.include "data-R1-7500.asm"
;		.include "data-R2-7900.asm"
;		.include "data-R3-7A00.asm"
;		.include "code-R4-A000.asm"
;		.include "data-R5-AC00.asm"

	.namespace level0

	.segment L0_BKGD
	.include "data-bkgnd-R0-7500.asm"

	.segment L0_DATA
	.include "data-R1-7500.asm"
	.include "data-R2-7900.asm"
	.include "data-R3-7A00.asm"

	.segment L0_CODE
	.include "code-R4-A000.asm"
	.include "level0.data-R5-AC00.asm"

	assertGameStruct

	.end
