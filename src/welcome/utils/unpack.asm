
		.namespace unpack

; .function unpack(dst:A src:X maxYpos:Y)

; A: dest
; X: source
; Y: max Y pos
run		sta hgrPage
		sty maxYpos
		stz Xpos
		stz Ypos

; L0343		=	*+1

		stx $1d
                stz $1c
loop
		jsr readPakByt ; read cmd
                cmp #$fe ; is repeat ?
                beq repeatByte

                jsr writeHGRbyte
                bra loop

; read packed byte
readPakByt	ldy #$00
		lda ($1c),y
		jsr nextByte
		rts

nextByte	inc $1c
		bne L0365
		inc $1d
L0365		rts

; set hires address from tables to ($1A)
getPixAddr
		ldx Ypos
		lda utils.hgrHigh,x
		clc
		adc hgrPage
		sta $1b
		lda utils.hgrLow,x
		clc
		adc Xpos
		sta $1a
		rts

; store byte to hires
writeHGRbyte
		sta hgrByte
		jsr getPixAddr ; set hires addr
		lda hgrByte
		ldy #$00
		sta ($1a),y

;L038c
		inc Ypos
		ldx Ypos
		; cpx #$c0
		; cpx #183
		cpx maxYpos
		bne L03a7
		ldx #$00
		stx Ypos
		inc Xpos
		ldx Xpos
		cpx #$28
		bne L03a7
		pla
		pla
L03a7
		rts

; process repeat bytes
repeatByte
		jsr readPakByt ; read packed byte
		sta repeatValue
		jsr readPakByt ; read packed byte
		sta repeatCount
!
		lda repeatValue
		jsr writeHGRbyte
		dec repeatCount
		bne !-

		jmp loop

Xpos		.db 00
Ypos		.db 00
maxYpos		.db 00
repeatValue	.db 00
repeatCount	.db 00
hgrByte		.db 00
hgrPage		.db 00

		.align $10
		.db "unpack"
		.align $10

		.end namespace
