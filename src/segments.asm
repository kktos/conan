.segment BOOT1		{ start: $0800, end: $08FF }
.segment LOADER		{ start: $B700, end: $BFFF }
.segment BOOT3		{ start: $B700, end: $B7FF }
.segment BOOT2		{ start: $4100, end: $45FF }
.segment WELCOME	{ start: $0200, end: $03FF, pad: $00 }
.segment UTILS		{ start: $D000, end: $DDFF, pad: $60 }
.segment PAD1		{ start: $0000, end: $0FFF, pad: $55 }
.segment SPRITELIB	{ start: $A700, end: $B6FF, pad: $FF }
.segment VARIABLES	{ start: $0300, end: $FFF, pad: $55 }
.segment GAME_CODE	{ start: $1000, end: $1FFF, pad: $00 }
.segment GAME_DATA	{ start: $4000, end: $7FFF, pad: $00 }
.segment WELCOME_DATA	{ start: $6000, end: $6FFF, pad: $55 }
.segment INTRO		{ start: $8000, end: $AFFF, pad: $00 }
.segment PAD2		{ start: $0000, end: $1FFF, pad: $55 }

.segment L0_BKGD	{ start: $7500, end: $7CFF, pad: $AA }
.segment L0_DATA	{ start: $7500, end: $9BFF, pad: $55 }
.segment L0_CODE	{ start: $A000, end: $A5FF, pad: $D5 }
.segment L0_BITMAP	{ start: $A600, end: $ADFF, pad: $D5 }

.segment L1_BKGD	{ start: $7500, end: $7CFF, pad: $AA }
.segment L1_DATA	{ start: $7500, end: $9BFF, pad: $55 }
.segment L1_CODE	{ start: $A000, end: $ADFF, pad: $D5 }

.segment L2_BKGD	{ start: $7500, end: $7EFF, pad: $AA }
.segment L2_DATA	{ start: $7500, end: $9BFF, pad: $55 }
.segment L2_CODE	{ start: $A000, end: $ADFF, pad: $D5 }
