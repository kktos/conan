		.namespace	level6

		.module	"L6/BKGD"
		.segment	L6_BKGD
		.incbin	"../../../assets/bkgnd/L6_c0_7500.bin"

		.module	"L6/DATA"
		.segment	L6_DATA
		.include	"sprites-definition.asm"
		.include	"variables.asm"
		.include	"sprites-data.asm"

		.module	"L6/CODE"
		.segment	L6_CODE
		.include	"code.asm"
		.include	"data-R5-AC00.asm"

	; game over: 4 pictures of 56 lines x 15 bytes, one per file, drawDeathMsg loads one at random
		.module	"L6/DEAD0"
		.segment	L6_DEAD0
		.incbin	"../../../assets/gameover/L6_pic0_T20S0.bin"

		.module	"L6/DEAD1"
		.segment	L6_DEAD1
		.incbin	"../../../assets/gameover/L6_pic1_T20S4.bin"

		.module	"L6/DEAD2"
		.segment	L6_DEAD2
		.incbin	"../../../assets/gameover/L6_pic2_T20S8.bin"

		.module	"L6/DEAD3"
		.segment	L6_DEAD3
		.incbin	"../../../assets/gameover/L6_pic3_T20SC.bin"

		assertGameStruct

		.end	namespace
