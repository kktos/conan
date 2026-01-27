	.MODULE BOOT
	;
	; TRACK 0
	;


	.segment BOOTLOADER
	.include "bootloader.asm"

	.segment TINY_DOS
	.include "tiny-dos.asm"


	;.segment DIRBLOCK
	;.include "prodos/dir.asm"

/*
	.segment BOOT1
	;
	; load loader
	; load T0S0 - T0S9 into $B600:$BF00
	;
	; .include "boot/00-boot.asm"
	.include "boot/newboot.asm"
*/

	;.segment LOADER
	;
	; load T0SA-B disk[0A00-0BFF] into $4000:41FF
	;
	; T0S1
	;.include "boot/01-loader.asm"

	; T0S2-S9
        ;.fill .SEGMENTEND-*+1, $55

	;.segment BOOT2
	;
	; relocate MEM[4000-40FF] to MEM[B700-B7FF]
	;

	; T0SB
	;.include "boot/03-boot2.M4100.asm"

	; T0SC-SF
	;.fill .SEGMENTEND-*+1, $55

	;.segment BOOT3
	;
	; load welcome
	; load T1S0-T1S1 -> $0200:03FF
	; jmp welcome
	;

	; T0SA
	;.include "boot/04-boot3.MB700.asm"
