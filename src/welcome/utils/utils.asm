		.namespace utils
		.org $D000

		.include "unpack.asm"

wait:
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

.function clearScreen {
		stz yPos
!		jsr clearByte
		inc yPos
		ldx yPos
		cpx #$b7
		bne !-
		rts
yPos		.db 0

clearByte:
		jsr getHGRLineAddr
		ldy #$27
		lda #$00
!		sta ($1c),y
		dey
		bpl !-
		rts

getHGRLineAddr:
		lda hgrLow,x
		sta $1c
		lda hgrHigh,x
		sta $1d
		rts
}
		.align $10
		.db "clearScreen"
		.align $10

PREAD
		lda  sys.PTRIG 		; TRIGGER PADDLES
		ldy  #$00 		; INIT COUNT
		nop         		; COMPENSATE FOR 1ST COUNT
		nop
!		lda  sys.PADDL0,x 	;  COUNT Y-REG EVERY
		bpl  !+  		; 12 uSec [actually 11]
		iny
		bne  !-       		;EXIT AT 255 MAX
		dey
!		rts

		.align $10
		.db "PREAD"
		.align $10

		.include "hgr-tables-M6E00-6FFF.asm"

		.end namespace
