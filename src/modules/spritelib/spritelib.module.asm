		.MODULE	SPRITELIB
		.SEGMENT	SPRITELIB

		.namespace	spritelib scope="lc_bank1"

		.include	"sprite-lib.asm"
		.include	"text.asm"
		.include	"variables.asm"

		.include	"tables.asm"
		.include	"global-sprites-dir.data.asm"

	; after the tables: the routines above keep their addresses
		.include	"sprite-plain.asm"

		.end	namespace
