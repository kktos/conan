	.namespace level1

	.module "L1/BKGD"

	.segment L1_BKGD
	.include "bkgnd.data.asm"

	.module "L1/DATA"

	.segment L1_DATA
	.include "sprites-dir.data.asm"
	.include "data-R2-7900.asm"
	.include "sprites.data.asm"

	.module "L1/CODE"

	.segment L1_CODE
	.include "code.asm"
	.include "data-R4-A200.asm"
	.include "level1.data-R5-AC00.asm"


	; game over: 4 pictures of 56 lines x 15 bytes, one per file, drawDeathMsg loads one at random
	.module "L1/DEAD0"
	.segment L1_DEAD0
	.incbin "../../../assets/gameover/L1_pic0_T1BS0.bin"

	.module "L1/DEAD1"
	.segment L1_DEAD1
	.incbin "../../../assets/gameover/L1_pic1_T1BS4.bin"

	.module "L1/DEAD2"
	.segment L1_DEAD2
	.incbin "../../../assets/gameover/L1_pic2_T1BS8.bin"

	.module "L1/DEAD3"
	.segment L1_DEAD3
	.incbin "../../../assets/gameover/L1_pic3_T1BSC.bin"

	assertGameStruct

	.end namespace
