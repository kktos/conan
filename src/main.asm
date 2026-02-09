
	;.lst off

	;.option local_label_char "!"
	.cpu "65C02"


	.include "segments.asm"

	.include "includes/macros.asm"
	.include "includes/extended-cmds.asm"
	.include "includes/disk-io.asm"
        .include "includes/a2-firmware.asm"
        .include "includes/smartport.asm"

        .include "modules/spritelib/spritelib.macros.asm"


	.include "modules/boot/boot.module.asm"

	;
	; TRACK $01
	;

	.include "modules/welcome/welcome.module.asm"
	.include "modules/welcome_data/welcome_data.module.asm"

	.include "modules/spritelib/spritelib.module.asm"
	.include "modules/utils/utils.module.asm"
	.include "modules/intro/intro.module.asm"

	.include "modules/variables/variables.module.asm"

	.include "modules/game/game.module.asm"

	; useful ?
	.include "modules/sprites_data/sprites_data.module.asm"

	;
	; TRACK $02
	;
	;.segment PAD1

	;.MODULE GAME

	;
	; TRACK $03
	;
	; .include "game1/sprite-lib.asm"

	;
	; TRACK $04
	;
	;.include "game1/data/data.asm"

	;
	; TRACK $05
	;
	;.include "game1/game1.asm"

	;
	; TRACK $06
	;
	;.include "game_data/game_data.asm"

	;
	; TRACK $0A
	;
	; .segment WELCOME_DATA
	; .include "modules/welcome/bkg-image-TAS0-F-M6000-6DFF.asm"
	; .include "welcome/hgr-tables-M6E00-6FFF.asm"

	;
	; TRACK $0B
	;
	;.include "intro/intro.asm"

	;.segment PAD2


	;
	; TRACK $10
	;

	.include "levels/level0/level.asm"
	.include "levels/level1/level.asm"
	.include "levels/level2/level.asm"

	.if .pass>1 {
		.out ""
		.out "***************"
		.out "conan's ready !"
	}
