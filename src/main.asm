
	;.lst off

	;.option local_label_char "!"
		.cpu	"65C02"

		.include	"segments.asm"

		.include	"includes/macros.asm"
		.include	"includes/level-geometry.macros.asm"
		.include	"includes/table-scan.macros.asm"
		.include	"includes/extended-cmds.asm"
		.include	"includes/a2-firmware.asm"
		.include	"includes/smartport.asm"

		.include	"modules/spritelib/spritelib.macros.asm"


		.include	"modules/boot/boot.module.asm"


		.include	"modules/welcome/welcome.module.asm"
		.include	"modules/welcome_data/welcome_data.module.asm"

		.include	"modules/spritelib/spritelib.module.asm"
		.include	"modules/utils/utils.module.asm"
		.include	"modules/intro/intro.module.asm"

		.include	"modules/variables/variables.module.asm"

		.include	"modules/game/game.module.asm"

	; useful ?
		.include	"modules/sprites_data/sprites_data.module.asm"

		.include	"levels/level0/level.asm"
		.include	"levels/level1/level.asm"
		.include	"levels/level2/level.asm"
		.include	"levels/level3/level.asm"
		.include	"levels/level4/level.asm"
		.include	"levels/level5/level.asm"
		.include	"levels/level6/level.asm"
		.include	"levels/level7/level.asm"
		.include	"levels/level8/level.asm"

		.if	.pass>1 {
			.out	""
			.out	"***************"
			.out	"conan's ready !"
		}
