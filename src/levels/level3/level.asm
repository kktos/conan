	.namespace level3

	.module "L3/BKGD"
	.segment L3_BKGD
	.incbin "../../../assets/bkgnd/L3_c0_7500.bin"

	.module "L3/DATA"
	.segment L3_DATA
	; .include "data-R1-7500.asm"
	; .include "data-R2-7900.asm"
	; .include "data-R3-7A00.asm"

	.module "L3/CODE"
	.segment L3_CODE
	; .include "code.asm"
	; .include "data-R5-AC00.asm"

	assertGameStruct
	
	.end namespace