	.namespace level7

	.module "L7/BKGD"
	.segment L7_BKGD
	.incbin "../../../assets/bkgnd/L7_c0_7500.bin"

	.module "L7/DATA"
	.segment L7_DATA
	; .include "data-R1-7500.asm"
	; .include "data-R2-7900.asm"
	; .include "data-R3-7A00.asm"

	.module "L7/CODE"
	.segment L7_CODE
	; .include "code.asm"
	; .include "data-R5-AC00.asm"

	; game over: 4 pictures of 56 lines x 15 bytes, one per file, drawDeathMsg loads one at random
	.module "L7/DEAD0"
	.segment L7_DEAD0
	.incbin "../../../assets/gameover/L7_pic0_T21S0.bin"

	.module "L7/DEAD1"
	.segment L7_DEAD1
	.incbin "../../../assets/gameover/L7_pic1_T21S4.bin"

	.module "L7/DEAD2"
	.segment L7_DEAD2
	.incbin "../../../assets/gameover/L7_pic2_T21S8.bin"

	.module "L7/DEAD3"
	.segment L7_DEAD3
	.incbin "../../../assets/gameover/L7_pic3_T21SC.bin"

	assertGameStruct

	.end namespace
