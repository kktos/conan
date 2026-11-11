.segment BOOTLOADER	{ start: $0800, size: $00A0 }
.segment TINY_DOS	{ start: $D000, size: $0300 }

.segment WELCOME	{ start: $0200, end: $03FF, pad: $00 }
.segment WELCOME_DATA	{ start: $6000, end: $6FFF, pad: $55 }

.segment UTILS		{ start: $D800, size: 0 }
; .segment SPRITELIB	{ start: $E000, end: $EFFF, pad: $00 }
.segment SPRITELIB	{ start: $E000, size: 0 }
.segment INTRO		{ start: $8000, end: $AFFF, pad: $00 }

; .segment VARIABLES	{ start: $0300, end: $FFF, pad: $55 }
.segment VARIABLES	{ start: $0300, size: $100 }
; .segment GAME		{ start: $1000, end: $1FFF, pad: $00 }
.segment GAME		{ start: $0A00, size: 0 }
; .segment SPRITES_DATA	{ start: $4000, end: $7FFF, pad: $00 }
.segment SPRITES_DATA	{ start: $4000, size: 0 }

.segment L0_BKGD	{ start: $7500, end: $7CFF, pad: $AA }
.segment L0_DATA	{ start: $7500, end: $9BFF, pad: $55 }
.segment L0_CODE	{ start: $A000, end: $A5FF, pad: $D5 }
.segment L0_BITMAP	{ start: $A600, end: $ADFF, pad: $D5 }

.segment L1_BKGD	{ start: $7500, end: $7CFF, pad: $AA }
.segment L1_DATA	{ start: $7500, end: $9BFF, pad: $55 }
.segment L1_CODE	{ start: $A000, end: $ADFF, pad: $D5 }
.segment L1_DEAD0	{ start: $7500, size: 840 }
.segment L1_DEAD1	{ start: $7500, size: 840 }
.segment L1_DEAD2	{ start: $7500, size: 840 }
.segment L1_DEAD3	{ start: $7500, size: 840 }

.segment L2_BKGD	{ start: $7500, end: $7EFF, pad: $AA }
.segment L2_DATA	{ start: $7500, end: $9BFF, pad: $55 }
.segment L2_CODE	{ start: $A000, end: $ADFF, pad: $D5 }
.segment L2_DEAD0	{ start: $7500, size: 840 }
.segment L2_DEAD1	{ start: $7500, size: 840 }
.segment L2_DEAD2	{ start: $7500, size: 840 }
.segment L2_DEAD3	{ start: $7500, size: 840 }

.segment L3_BKGD	{ start: $7500, end: $7EFF, pad: $AA }
.segment L3_DATA	{ start: $7500, end: $9BFF, pad: $55 }
.segment L3_CODE	{ start: $A000, end: $ADFF, pad: $D5 }
.segment L3_DEAD0	{ start: $7500, size: 840 }
.segment L3_DEAD1	{ start: $7500, size: 840 }
.segment L3_DEAD2	{ start: $7500, size: 840 }
.segment L3_DEAD3	{ start: $7500, size: 840 }

.segment L4_BKGD	{ start: $7500, end: $7DFF, pad: $AA }
.segment L4_DATA	{ start: $7500, end: $9BFF, pad: $55 }
.segment L4_CODE	{ start: $A000, end: $ADFF, pad: $D5 }
.segment L4_DEAD0	{ start: $7500, size: 840 }
.segment L4_DEAD1	{ start: $7500, size: 840 }
.segment L4_DEAD2	{ start: $7500, size: 840 }
.segment L4_DEAD3	{ start: $7500, size: 840 }

.segment L5_BKGD	{ start: $7500, end: $7EFF, pad: $AA }
.segment L5_DATA	{ start: $7500, end: $9BFF, pad: $55 }
.segment L5_CODE	{ start: $A000, end: $ADFF, pad: $D5 }
.segment L5_DEAD0	{ start: $7500, size: 840 }
.segment L5_DEAD1	{ start: $7500, size: 840 }
.segment L5_DEAD2	{ start: $7500, size: 840 }
.segment L5_DEAD3	{ start: $7500, size: 840 }

.segment L6_BKGD	{ start: $7500, end: $7EFF, pad: $AA }
.segment L6_DATA	{ start: $7500, end: $9BFF, pad: $55 }
.segment L6_CODE	{ start: $A000, end: $ADFF, pad: $D5 }
.segment L6_DEAD0	{ start: $7500, size: 840 }
.segment L6_DEAD1	{ start: $7500, size: 840 }
.segment L6_DEAD2	{ start: $7500, size: 840 }
.segment L6_DEAD3	{ start: $7500, size: 840 }

.segment L7_BKGD	{ start: $7500, end: $80FF, pad: $AA }
.segment L7_DATA	{ start: $7500, end: $9FFF, pad: $55 }	; c3 goes up to $9FFF
.segment L7_CODE	{ start: $A000, end: $ADFF, pad: $D5 }
.segment L7_DEAD0	{ start: $7500, size: 840 }
.segment L7_DEAD1	{ start: $7500, size: 840 }
.segment L7_DEAD2	{ start: $7500, size: 840 }
.segment L7_DEAD3	{ start: $7500, size: 840 }
.segment L7_FINAL	{ start: $9F00, end: $A9FF, pad: $D5 }	; the final animation, loaded by the level code

.segment L8_BKGD	{ start: $7500, end: $7FFF, pad: $AA }
.segment L8_DATA	{ start: $7500, end: $9BFF, pad: $55 }
.segment L8_CODE	{ start: $A000, end: $ADFF, pad: $D5 }
