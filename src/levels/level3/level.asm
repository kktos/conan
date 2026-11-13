		.namespace	level3

		.module	"L3/BKGD"
		.segment	L3_BKGD
		.incbin	"../../../assets/bkgnd/L3_c0_7500.bin"

		.module	"L3/DATA"
		.segment	L3_DATA
		.include	"sprites-definition.asm"
		.include	"variables.asm"
		.include	"sprites-data.asm"

		.module	"L3/CODE"
		.segment	L3_CODE
		.include	"code.asm"
		.include	"data-R5-AC00.asm"

	; game over: 4 pictures of 56 lines x 15 bytes, one per file, drawDeathMsg loads one at random
		.module	"L3/DEAD0"
		.segment	L3_DEAD0
		.incbin	"../../../assets/gameover/L3_pic0_T1DS0.bin"

		.module	"L3/DEAD1"
		.segment	L3_DEAD1
		.incbin	"../../../assets/gameover/L3_pic1_T1DS4.bin"

		.module	"L3/DEAD2"
		.segment	L3_DEAD2
		.incbin	"../../../assets/gameover/L3_pic2_T1DS8.bin"

		.module	"L3/DEAD3"
		.segment	L3_DEAD3
		.incbin	"../../../assets/gameover/L3_pic3_T1DSC.bin"

		assertGameStruct
	
		.end	namespace
