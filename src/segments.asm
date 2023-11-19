.segment BOOT1		{ start: 0x0800, end: 0x08FF }
.segment LOADER		{ start: 0xB700, end: 0xBFFF }
.segment BOOT3		{ start: 0xB700, end: 0xB7FF }
.segment BOOT2		{ start: 0x4100, end: 0x45FF }
.segment WELCOME	{ start: 0x0200, end: 0x03FF, pad: 0x00 }
.segment UTILS		{ start: 0xD000, end: 0xDDFF, pad: 0x60 }
.segment PAD1		{ start: 0x0000, end: 0x0FFF, pad: 0x55 }
.segment SPRITELIB	{ start: 0xA700, end: 0xB6FF, pad: 0xFF }
.segment VARIABLES	{ start: 0x0300, end: 0xFFF, pad: 0x55 }
.segment GAME_CODE	{ start: 0x1000, end: 0x1FFF, pad: 0x00 }
.segment GAME_DATA	{ start: 0x4000, end: 0x7FFF, pad: 0x00 }
.segment WELCOME_DATA	{ start: 0x6000, end: 0x6FFF, pad: 0x55 }
.segment INTRO		{ start: 0x6000, end: 0xAFFF, pad: 0x00 }
.segment L0_BKGD	{ start: 0x7500, end: 0x7CFF, pad: 0xAA }
.segment L0_DATA	{ start: 0x7500, end: 0x9BFF, pad: 0x55 }
.segment L0_CODE	{ start: 0xA000, end: 0xADFF, pad: 0xD5 }
.segment L1_BKGD	{ start: 0x7500, end: 0x7CFF, pad: 0xAA }
.segment L1_DATA	{ start: 0x7500, end: 0x9BFF, pad: 0x55 }
.segment L1_CODE	{ start: 0xA000, end: 0xADFF, pad: 0xD5 }
.segment L2_BKGD	{ start: 0x7500, end: 0x7EFF, pad: 0xAA }
.segment L2_DATA	{ start: 0x7500, end: 0x9BFF, pad: 0x55 }
.segment L2_CODE	{ start: 0xA000, end: 0xADFF, pad: 0xD5 }
