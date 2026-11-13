		.namespace	level2

		.module	"L2/BKGD"
		.segment	L2_BKGD
		.include	"data-bkgnd-R0-7500.asm"

		.module	"L2/DATA"
		.segment	L2_DATA
		.include	"data-R1-7500.asm"
		.include	"data-R2-7900.asm"
		.include	"data-R3-7A00.asm"

		.module	"L2/CODE"
		.segment	L2_CODE
		.include	"code.asm"
	; .include "data-R4-A200.asm"
		.include	"data-R5-AC00.asm"

	; game over: 4 pictures of 56 lines x 15 bytes, one per file, drawDeathMsg loads one at random
		.module	"L2/DEAD0"
		.segment	L2_DEAD0
		.incbin	"../../../assets/gameover/L2_pic0_T1CS0.bin"

		.module	"L2/DEAD1"
		.segment	L2_DEAD1
		.incbin	"../../../assets/gameover/L2_pic1_T1CS4.bin"

		.module	"L2/DEAD2"
		.segment	L2_DEAD2
		.incbin	"../../../assets/gameover/L2_pic2_T1CS8.bin"

		.module	"L2/DEAD3"
		.segment	L2_DEAD3
		.incbin	"../../../assets/gameover/L2_pic3_T1CSC.bin"

		assertGameStruct
	
		.end	namespace
