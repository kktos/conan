		.namespace	level5

		.module	"L5/BKGD"
		.segment	L5_BKGD
		.incbin	"../../../assets/bkgnd/L5_c0_7500.bin"

		.module	"L5/DATA"
		.segment	L5_DATA
		.include	"data-R1-7500.asm"
		.include	"data-R2-7900.asm"
		.include	"data-R3-7A00.asm"

		.module	"L5/CODE"
		.segment	L5_CODE
		.include	"code.asm"
		.include	"data-R5-AC00.asm"

	; game over: 4 pictures of 56 lines x 15 bytes, one per file, drawDeathMsg loads one at random
		.module	"L5/DEAD0"
		.segment	L5_DEAD0
		.incbin	"../../../assets/gameover/L5_pic0_T1FS0.bin"

		.module	"L5/DEAD1"
		.segment	L5_DEAD1
		.incbin	"../../../assets/gameover/L5_pic1_T1FS4.bin"

		.module	"L5/DEAD2"
		.segment	L5_DEAD2
		.incbin	"../../../assets/gameover/L5_pic2_T1FS8.bin"

		.module	"L5/DEAD3"
		.segment	L5_DEAD3
		.incbin	"../../../assets/gameover/L5_pic3_T1FSC.bin"

		assertGameStruct

		.end	namespace
