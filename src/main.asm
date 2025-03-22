	;.lst off

	.cpu "65C02"

	.include "segments.asm"

	.include "includes/macros.asm"
	.include "includes/extended-cmds.asm"
	.include "includes/disk-io.asm"
        .include "includes/a2-firmware.asm"

	;
	; TRACK 0
	;


	.segment BOOT1
	;
	; load loader
	; load T0S0 - T0S9 into $B600:$BF00
	;
	; .include "boot/00-boot.asm"
	.include "boot/newboot.asm"


	.segment LOADER
	;
	; load T0SA-B disk[0A00-0BFF] into $4000:41FF
	;
	; T0S1
	.include "boot/01-loader.asm"

	; T0S2-S9
        ;.fill .SEGMENTEND-*+1, $55

	.segment BOOT2
	;
	; relocate MEM[4000-40FF] to MEM[B700-B7FF]
	;

	; T0SB
	.include "boot/03-boot2.M4100.asm"

	; T0SC-SF
	;.fill .SEGMENTEND-*+1, $55

	.segment BOOT3
	;
	; load welcome
	; load T1S0-T1S1 -> $0200:03FF
	; jmp welcome
	;

	; T0SA
	.include "boot/04-boot3.MB700.asm"


	;
	; TRACK $01
	;

	.segment WELCOME
	; S0-S1
	;
	; load intro
	; load TB to TF in $6000:AFFF and T4S0:$1000->$0300
	; run intro
	;
	; load T6 to T9 in $4000:7FFF
	; load T5 in $1000:1FFF -> game1
	; load T4 in $0300:0FFF
	; load T3 in $A700:B6FF
	; jump game1
	;
	.include "welcome/main-M0200-03FF.asm"

	.segment UTILS
	; S2-SF
	.include "welcome/utils/utils.asm"

	;
	; TRACK $02
	;
	.segment PAD1

	;
	; TRACK $03
	;
	.include "game1/sprite-lib.asm"

	;
	; TRACK $04
	;
	.include "game1/data/data.asm"

	;
	; TRACK $05
	;
	.include "game1/game1.asm"

	;
	; TRACK $06
	;
	.include "game_data/game_data.asm"

	;
	; TRACK $0A
	;
	.segment WELCOME_DATA
	.include "welcome/bkg-image-TAS0-F-M6000-6DFF.asm"
	; .include "welcome/hgr-tables-M6E00-6FFF.asm"

	;
	; TRACK $0B
	;
	.include "intro/intro.asm"

	.segment PAD2


	;
	; TRACK $10
	;

	.include "levels/level0/level.asm"
	.include "levels/level1/level.asm"
	.include "levels/level2/level.asm"

	.out ""
	.out "***************"
	.out "conan's ready !"
