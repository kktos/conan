

	.setcpu 65C02

	.include "includes/disk-io.inc"
        .include "includes/a2-firmware.inc"

	;
	; TRACK 0
	;


.segment BOOT1
	;
	; load T0S0 - T0S9
	; into $B600 - $BF00
	;
	.include "D1T1-boot.asm"


.segment LOADER
	;
	; load T0SA-B disk[0A00-0Bff] mem[4000-41FF]
	;
	; T0S1
	.include "D1T1-loader.asm"

	; T0S2-S9
        .fill .SEGMENTEND-*+1 $55

.segment BOOT2
	;
	; relocate MEM[4000-40FF] to MEM[B700-B7FF]
	;

	; T0SB
	.include "03-M4100.asm"

	; T0SC-SF
	.fill .SEGMENTEND-*+1 $55

.segment BOOT3
	;
	; load T1S0-T1S1 -> $0200:03FF
	;

	; T0SA
	.include "03-MB700.asm"


	;
	; TRACK 1
	;

.segment WELCOME
	.include "04-M0200-03FF.asm"

	; T0S2-SF
	.fill .SEGMENTEND-*+1 $55


	;
	; TRACK $02-$03
	;
.segment PAD1
	.fill .SEGMENTEND-*+1 $AA

	;
	; TRACK $04
	;
.segment VARIABLES
	.include "07-variables-page03.asm"
	.fill .SEGMENTEND-*+1 $55

	;
	; TRACK $05
	;
.segment GAME1
	.include "09-M1000-1FFF.asm"

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
	.fill .SEGMENTEND-*+1 $DD

	;
	; TRACK $0C
	;
.segment DATA2
	.include "06-TCS0-F-M7000-7FFF.asm"

	;
	; TRACK $0D
	;
.segment INTRO
	.include "06-TDS0-F-M8000-8FFF.asm"

	;
	; TRACK $0E
	;
.segment DATA3
	.include "06-TES0-F-M9000-9FFF.asm"

	;
	; TRACK $0F
	;
.segment DATA4
	.include "05.1-TFS0-F-MA000-AFFF.asm"


	.out ""
	.out "***************"
	.out "conan's ready !"
