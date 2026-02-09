		.namespace utils scope="lc_bank2"

		.include "unpack.asm"

.proc wait {
		sec                ;2
wait2
		pha                ;3
wait3
		sbc     #$01       ;2
		bne     wait3      ;2+
		pla                ;4
		sbc     #$01       ;2
		bne     wait2      ;2+
		rts                ;6

		.align $10
		.db "wait"
		.align $10
}

.proc clearScreen {
		stz yPos
:		jsr clearHGRLine
		inc yPos
		ldx yPos
		cpx #$b7
		bne :-
		rts
yPos		.db 0

clearHGRLine:
		lda hgrLow,x
		sta $1c
		lda hgrHigh,x
		sta $1d

		ldy #$27
		lda #$00
:		sta ($1c),y
		dey
		bpl :-
		rts

		.align $10
		.db "clearScreen"
		.align $10
}

.proc PREAD {
		lda  sys::PTRIG 		; TRIGGER PADDLES
		ldy  #$00 		; INIT COUNT
		nop         		; COMPENSATE FOR 1ST COUNT
		nop
:		lda  sys::PADDL0,x 	;  COUNT Y-REG EVERY
		bpl  :+  		; 12 uSec [actually 11]
		iny
		bne  :-       		;EXIT AT 255 MAX
		dey
:		rts

		.align $10
		.db "PREAD"
		.align $10
}

.proc int2str {

HTD_IN 		.equ $00
HTD_OUT 	.equ $01
strPtr 		.equ $03

int2str:
		stx strPtr
		sty strPtr+1

		sta HTD_IN
		sed
		stz HTD_OUT     ; Inititalize output word as 0.
		stz HTD_OUT+1

		ldx #$08
loop:
		asl HTD_IN		; Shift out one bit

		lda HTD_OUT	; And add into result
		adc HTD_OUT
		sta HTD_OUT

		lda HTD_OUT+1	; propagating any carry
		adc HTD_OUT+1
		sta HTD_OUT+1

		dex		; And repeat for next bit
		bne loop

		cld

		ldx #$01
		ldy #$00
:loop
		lda HTD_OUT,x
		lsr
		lsr
		lsr
		lsr
		clc
		adc #$30
		sta (strPtr),y

		iny
		lda HTD_OUT,x
		and #$0F
		clc
		adc #$30
		sta (strPtr),y
		iny
		dex
		bpl :loop
		rts
}

.proc int2hex {

strPtr 		.equ $03

		stx strPtr
		sty strPtr+1

		pha

		; Convert high nibble
		lsr
		lsr
		lsr
		lsr
		jsr nibbleToHex
		ldy #$00
		sta (strPtr),y

		; Convert low nibble
		pla
		and #$0F
		jsr nibbleToHex
		iny
		sta (strPtr),y

		rts

; Convert nibble (0-15) in A to ASCII hex digit ('0'-'9', 'A'-'F')
nibbleToHex:
		cmp #10
		bcc @digit      ; Branch if 0-9

		; A-F
		adc #$41 - 11     ; Carry is set, so adds 'A'-10
		rts

@digit:
		adc #"0"        ; Carry is clear
		rts

}

		.include "hgr-tables-M6E00-6FFF.asm"

		.end namespace
