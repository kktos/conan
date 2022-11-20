	.lst off

	.cpu "65C02"

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
        .fill .SEGMENTEND-*+1, $55

.segment BOOT2
	;
	; relocate MEM[4000-40FF] to MEM[B700-B7FF]
	;

	; T0SB
	.include "boot/03-boot2.M4100.asm"

	; T0SC-SF
	.fill .SEGMENTEND-*+1, $55

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
.segment SPRITELIB
	.include "game1/sprite-lib.asm"

	;
	; TRACK $04
	;
.segment VARIABLES
	.include "game1/variables.asm"
	.include "game1/data-400-7FF.asm"
	.include "game1/code-800.asm"
	.include "game1/data-levels.asm"
	.include "game1/sound-lib.asm"
	.include "game1/data-C00-FFF.asm"

	;
	; TRACK $05
	;
.segment GAME_CODE
	.include "game1/game1.asm"

	;
	; TRACK $06
	;
.segment GAME_DATA
	.include "08-data-M4000-4FFF.asm"
	;
	; TRACK $07
	;
	.include "08-data-M5000-5FFF.asm"
	;
	; TRACK $08
	;
	.include "08-data-M6000-6FFF.asm"
	;
	; TRACK $09
	;
	.include "08-data-M7000-7FFF.asm"

	;
	; TRACK $0A
	;
.segment WELCOME_DATA
	.include "welcome/bkg-image-TAS0-F-M6000-6DFF.asm"
	; .include "welcome/hgr-tables-M6E00-6FFF.asm"


	;
	; TRACK $0B
	;
.segment INTRO
	.include "intro/06-TDS0-F-M8000-8FFF.asm"
	; TRACK $0C
	;
	.include "intro/sprites.asm"
	; TRACK $0D
	;
	; .include "intro/T0C-M7000-7FFF.asm"
	;
	; TRACK $0E
	;
	.include "intro/setupKeysDlg/dialog.asm"
	;
	; TRACK $0F
	;
	; .include "intro/05.1-data-TFS0-F-MA000-AFFF.asm"


	;
	; TRACK $10
	;
.segment L0_BKGD
	.include "levels/level0/data-bkgnd-R0-7500.asm"

.segment L0_DATA
	.include "levels/level0/data-R1-7500.asm"
	.include "levels/level0/data-R2-7900.asm"
	.include "levels/level0/data-R3-7A00.asm"

.segment L0_CODE
	.include "levels/level0/code-R4-A000.asm"
	; .include "levels/level0/data-R5-AC00.asm"

.segment L1_BKGD
	.include "levels/level1/data-bkgnd-R0-7500.asm"

.segment L1_DATA
	.include "levels/level1/data-R1-7500.asm"
	.include "levels/level1/data-R2-7900.asm"
	.include "levels/level1/data-R3-7A00.asm"

.segment L1_CODE
	.include "levels/level1/code-R4-A000.asm"
	.include "levels/level1/data-R4-A200.asm"
	.include "levels/level1/data-R5-AC00.asm"

.segment L2_BKGD
	.include "levels/level2/data-bkgnd-R0-7500.asm"

.segment L2_DATA
	.include "levels/level2/data-R1-7500.asm"
	.include "levels/level2/data-R2-7900.asm"
	.include "levels/level2/data-R3-7A00.asm"

.segment L2_CODE
	.include "levels/level2/code-R4-A000.asm"
	; .include "levels/level2/data-R4-A200.asm"
	.include "levels/level2/data-R5-AC00.asm"


	.out ""
	.out "***************"
	.out "conan's ready !"
