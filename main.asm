

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

	.out ""
	.out "***************"
	.out "conan's ready !"
