
		.namespace unpack

		.org $D000

; L0800		=	$0800
; L0801		=	$0801
; L0802		=	$0802
; L0803		=	$0803
; L0808		=	$0808
; L0810		=	$0810

run		sta L0810
		stz L0800
		stz L0801

; L0343		=	*+1

		; ldx #$60
		stx $1d
                ; ldx #$00
                stz $1c
L034a           jsr readByte ; read cmd
                cmp #$fe ; is repeat ?
                beq L03a8

                jsr S0366
                jmp L034a

; read packed byte
readByte	ldy #$00
		lda ($1c),y
		jsr S035f
		rts

S035f               inc $1c
                    bne L0365
                    inc $1d
L0365               rts

; store byte to hires
S0366               sta L0808
                    jsr S0376 ; set hires addr
                    lda L0808
                    ldy #$00
                    sta ($1a),y
                    jmp L038c

; set hires address from tables to ($1A)
S0376               ldx L0801
                    lda hgrHigh,x
                    clc
                    adc L0810
                    sta $1b
                    lda hgrLow,x
                    clc
                    adc L0800
                    sta $1a
                    rts

L038c               inc L0801
                    ldx L0801
                    cpx #$c0
                    bne L03a7
                    ldx #$00
                    stx L0801
                    inc L0800
                    ldx L0800
                    cpx #$28
                    bne L03a7
                    pla
                    pla
L03a7               rts

; process repeat bytes
L03a8               jsr readByte ; read packed byte
                    sta L0802
                    jsr readByte ; read packed byte
                    sta L0803
L03b4               lda L0802
                    jsr S0366
                    dec L0803
                    bne L03b4
                    jmp L034a

L0800		.db 00
L0801		.db 00
L0802		.db 00
L0803		.db 00
L0808		.db 00
L0810		.db 00

		.align $100
		.namespace
