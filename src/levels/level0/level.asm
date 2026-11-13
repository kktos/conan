		.namespace	level0

		.module	"L0/BKGD"
		.segment	L0_BKGD
		.incbin	"../../../assets/bkgnd/L0_c0_7500.bin"


		.module	"L0/DATA"
		.segment	L0_DATA
		.include	"sprites-definition.asm"
		.include	"variables.asm"
		.include	"sprites-data.asm"

		.module	"L0/CODE"
		.segment	L0_CODE
		.include	"code.asm"

		.module	"L0/BMP"
		.segment	L0_BITMAP
		.include	"data-A600.asm"

; no level description (c5) here: the title picture fills $AC00-$ADFF and the
; game only reads c5 once level 1 is loaded. The labels are only there for
; assertGameStruct.
;LAC00		.equ	$AC00
;LAC20		.equ	$AC20
;LAC40		.equ	$AC40
;LAC60		.equ	$AC60
;LAC80		.equ	$AC80
;LACA0		.equ	$ACA0
;LACC0		.equ	$ACC0
;LACF0		.equ	$ACF0
;		assertGameStruct

		.end	namespace
