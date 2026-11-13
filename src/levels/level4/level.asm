		.namespace	level4

		.module	"L4/BKGD"
		.segment	L4_BKGD
		.incbin	"../../../assets/bkgnd/L4_c0_7500.bin"

		.module	"L4/DATA"
		.segment	L4_DATA
		.include	"data-R1-7500.asm"
		.include	"data-R2-7900.asm"
		.include	"data-R3-7A00.asm"

		.module	"L4/CODE"
		.segment	L4_CODE
		.include	"code.asm"
		.include	"data-R5-AC00.asm"

	; game over: 4 pictures of 56 lines x 15 bytes, one per file, drawDeathMsg loads one at random
		.module	"L4/DEAD0"
		.segment	L4_DEAD0
		.incbin	"../../../assets/gameover/L4_pic0_T1ES0.bin"

		.module	"L4/DEAD1"
		.segment	L4_DEAD1
		.incbin	"../../../assets/gameover/L4_pic1_T1ES4.bin"

		.module	"L4/DEAD2"
		.segment	L4_DEAD2
		.incbin	"../../../assets/gameover/L4_pic2_T1ES8.bin"

		.module	"L4/DEAD3"
		.segment	L4_DEAD3
		.incbin	"../../../assets/gameover/L4_pic3_T1ESC.bin"

		assertGameStruct

		.end	namespace
