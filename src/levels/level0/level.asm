		.namespace	level0

		.module	"L0/BKGD"
		.segment	L0_BKGD
		.incbin	"../../../assets/bkgnd/L0_c0_7500.bin"


		.module	"L0/DATA"
		.segment	L0_DATA
		.include	"sprites-definition.asm"
		.include	"variables.asm"
		.include	"sprites-data.asm"

		.module	"L0/CODE"
		.segment	L0_CODE
		.include	"code.asm"

		.module	"L0/BMP"
		.segment	L0_BITMAP
		.include	"data-A600.asm"

		assertGameStruct

		.end	namespace
