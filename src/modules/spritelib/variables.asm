; B3C5
		; .hex B3
		; .hex 4C 83 B3

		; .hex 03 05 00 02 04 06 01
		; .hex 00 80 00 80 00 80 00 80 00 20 40 60 80 A0 C0 E0
		; .hex 04 04 05 05 06 06 07 07 08 08 08 08 08 08 08 08

yPos       	.db $03
dsWidth 	.db $05
; LB3F2       	.db $00
dsWidthInit 	.db $02
dsHeight 	.db $04
dsHeightInit 	.db $06
isCollision	.db $01
isFlipped       .db $03
LB3F8        	.db $00

textX 			.byte 0
textY 			.byte 0
currentByteOffset 	.byte 0
currentShift      	.byte 0

; LB3F9        	.db $02
; LB3FA        	.db $04
; LB3FB        	.db $06
; LB3FC        	.db $06
; LB3FD 		.db $03
; LB3FE        	.db $05
; LB3FF        	.db $05

		.align $100
