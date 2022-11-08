	.lst off

	.cpu "65C02"

	.include "includes/disk-io.inc"
        .include "includes/a2-firmware.inc"

	;
	; TRACK 0
	;


.segment BOOT1
	;
	; load loader
	; load T0S0 - T0S9 into $B600:$BF00
	;
	.include "boot/00-boot.asm"


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
	.include "welcome/04-M0200-03FF.asm"

	; T0S2-SF
	.fill .SEGMENTEND-*+1, $55


	;
	; TRACK $02
	;
.segment PAD1
	.fill .SEGMENTEND-*+1, $AA

	;
	; TRACK $03
	;
.segment SPRITELIB
	.include "game1/sprite-lib.asm"
	.fill .SEGMENTEND-*+1, $EA

	;
	; TRACK $04
	;
.segment VARIABLES
	.include "game1/variables.asm"
	.include "game1/helpers.asm"

	.fill .SEGMENTEND-*+1, $55

	;
	; TRACK $05
	;
.segment GAME1
	.include "game1/main.asm"

	;
	; TRACK $06
	;
.segment DATA6
	.include "08-data-M4000-4FFF.asm"

	;
	; TRACK $07
	;
.segment DATA7
	.include "08-data-M5000-5FFF.asm"

	;
	; TRACK $08
	;
.segment DATA8
	.include "08-data-M6000-6FFF.asm"

	;
	; TRACK $09
	;
.segment DATA9
	.include "08-data-M7000-7FFF.asm"

	;
	; TRACK $0A
	;
.segment DATA1
	.include "05.0-TAS0-F-M6000-6FFF.asm"


	;
	; TRACK $0B L$1000
	;
.segment PAD3
	.fill .SEGMENTEND-*+1, $DD

	;
	; TRACK $0C
	;
.segment DATA2
	.include "06-TCS0-F-M7000-7FFF.asm"

	;
	; TRACK $0D
	;
.segment INTRO
	.include "intro/06-TDS0-F-M8000-8FFF.asm"

	;
	; TRACK $0E
	;
.segment SETUP
	.include "intro/setupKeysDlg/dialog.asm"

	;
	; TRACK $0F
	;
.segment DATA4
	.include "05.1-TFS0-F-MA000-AFFF.asm"

	;
	; TRACK $10
	;
.segment LEVEL0
	.include "levels/level0/level.asm"


	.out ""
	.out "***************"
	.out "conan's ready !"
