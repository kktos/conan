	.MODULE WELCOME

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
	.include "main-M0200-03FF.asm"
