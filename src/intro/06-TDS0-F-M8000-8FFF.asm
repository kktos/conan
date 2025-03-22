		.namespace intro

		; .export hgrAddrLo
		; .export hgrAddrHi

                ;   .org $8000

		.include "draw-img.asm"

;
; intro animation
;
run		lda #$00
		sta L8ff1
		sta L8ff0
		sta L8ff6
		sta isAnimDone
		sta L8ff5
		sta L8ff8
		sta L8ff2
		sta L8ffb
		sta L8ffc
		sta L8fff

		lda #$04
		sta L8ffe
		lda #$30
		sta L8ffd
		lda sys.KBDSTRB
		lda #$00
		sta hgrPage
		lda #$60
		sta scrollYpos
		lda #$ff
		sta L5ff7

                    ; scroll datasoft copyright
L883c		dec scrollYpos
		ldx #$0a
		lda #$17
		ldy scrollYpos
		cpy #$c0
		beq L8853
		jsr drawImgWithMask
		; bit sys.KBDSTRB
		; jmp L883c

!		lda sys.KBD
		bpl L883c
		bit sys.KBDSTRB


L8853
		.if 0

		stz L8ffe
		; ldx #$00
		; ldy #$00
loop:
		; lda spritesHi,x
		; beq !+
		; sta $1000,y
		; lda spritesLo,x
		; sta $1001,y
		; iny
		; iny
		; inx
		; bra loop

		jsr utils.clearScreen
		lda L8ffe
		ldy #$0c
		ldx #$05
		jsr drawImg
!		lda sys.KBD
		bpl !-
		bit sys.KBDSTRB

		inc L8ffe
		lda L8ffe
		cmp #$19+1
		bne loop

; !
; 		sty L8ffe
; 		.db $42,$FF
; 		.cstr "w:%W h:%H %D"
; 		.db 3
; 		.dw L8ffe, w, ptr

		brk

; w 		.db 1
; ptr 		.dw $1000

		.end

		; display hgr2 mask

		lda #$20
		sta hgrPage

		lda #$18 ; img id
		ldx #$0e ; x
		ldy #$20 ; y
		jsr drawImg

		; display hgr DATASOFT PRESENTS

		lda #$00
		sta hgrPage

		lda #$19 ; img id
		ldy #$0c ; x
		ldx #$0f ; y
		jsr drawImg

		; exit on key + wait
L886f		jsr S8881

		; anim sword in conan - once / anim knight on horse from left to right - repeat
		jsr S8894
		jsr S88ab
		jsr S8912
		jsr S896d
		jmp L886f

S8881		ldy #$08
L8883		lda sys.KBD
		bpl L888b
		jmp L89c3

L888b		lda #$10
		; jsr sys.WAIT
		jsr utils.wait
		dey
		bne L8883
		rts

S8894		inc L8ff0
		lda L8ff0
		beq L889d
		rts

L889d		inc L8ff1
		lda L8ff1
		cmp #$11
		bne L88aa
		jmp L89c3

L88aa		rts

S88ab		lda L8ff2
		bne L88c7
		lda L8ff1
		cmp #$04
		bne L88c6
		lda #$01
		sta L8ff2
		lda #$0c
		sta L8ff3
		lda #$f1
		sta L8ff4
L88c6		rts

L88c7		inc L8fff
		lda L8fff
		cmp #$08
		bne L88c6
		lda #$00
		sta L8fff
		jsr S88dd
		jsr S8906
		rts

S88dd		lda L8ff3
		cmp #$11
		bne L8902
		lda #$0c
		sta L8ff3
		inc L8ff4
		inc L8ff4
		inc L8ff4
		inc L8ff4
		lda L8ff4
		cmp #$29
		bne L8901
		lda #$f1
		sta L8ff4
L8901		rts

L8902		inc L8ff3
		rts

S8906		lda L8ff3
		ldy #$a2
		ldx L8ff4
		jsr drawImgWithMask
		rts

		; countdown between each sprite...
S8912		lda L8ff6
		bne L892d

		lda L8ff5
		bne L892e

		lda L8ff1
		cmp #$00
		bne L892d

		lda #$01
		sta L8ff5
		lda #$00
		sta L8ff7
L892d		rts

L892e		inc L8ffb
		lda L8ffb
		cmp L8ffd
		bne L896c

                    ; display
                    ; the key
                    lda L8ffd
                    cmp #$04
                    beq L8946
                    sec
                    sbc #$04
                    sta L8ffd

L8946               lda #$00
                    sta L8ffb
                    ldy L8ff7
                    lda L8a40,y ; img id
                    pha
                    ldx L8a00,y ; x
                    lda L8a20,y ; y
                    tay
                    pla
                    jsr drawImg

                    inc L8ff7
                    lda L8ff7
                    cmp #$21
                    bne L896c
                    lda #$01
                    sta L8ff6
L896c               rts

S896d               lda isAnimDone
                    bne L8988

                    lda L8ff8
                    bne L8989
                    lda L8ff1
                    cmp #$03
                    bne L8988
                    lda #$01
                    sta L8ff8
                    lda #$00
                    sta L8ffa
L8988               rts

L8989               inc L8ffc
                    lda L8ffc
                    cmp L8ffe
                    bne L89c2
                    lda L8ffe
                    cmp #$0d
                    beq L899e
                    inc L8ffe
L899e               lda #$00
                    sta L8ffc
                    ldy L8ffa
                    ldx L8a60,y
                    lda L8a80,y
                    ldy #$20
                    jsr drawImgWithMask
                    ldy L8ffa
                    iny
                    sty L8ffa
                    lda L8a80,y
                    bne L89c2
                    lda #$01
                    sta isAnimDone
L89c2               rts

                    ; if "R" is pressed, launch key settings dialog
L89c3               cmp #"r
;"
                    beq L89cb

                    pla
                    pla
                    clc
                    rts

L89cb               jsr setup_dlg.run
                    pla
                    pla
                    sec
                    rts

;
; FLIP DISK
;

showFlipDisk	lda sys.KBDSTRB

; display "flip disk"
		lda #$15 	; img id
		ldx #0 	; x coord
		ldy #183 	; y coord
		jsr drawImg

L89e7		lda sys.KBD
		bpl L89e7

showLevelBar
		lda sys.KBDSTRB

; display player bottom info [score men level axe]
		lda #$16 	; img id
		ldx #0 		; x coord
		ldy #183 	; y coord
		jmp drawImg

;L89f9
		; .hex cc a0 ce cf ce 8d a0

		.align $100

; sprites X
L8a00		.hex 0e 0e 0e 0e 0e 0e 0e 0e 0e 0e 0e 0e 0e 0e 0e 0e
		.hex 0e 0e 0e 0e 0e 0e 0e 0e 0e 0e 0e 0e 0e 0e 0e 0e
; sprites Y
L8a20		.hex 36 36 36 36 36 34 34 34 34 32 32 32 32 2f 2f 2f
		.hex 2c 2c 2c 29 29 29 27 27 27 25 25 24 24 23 22 20
; sprites ID
L8a40		.hex 0b 0b 0b 0b 0b 0a 0a 0a 0a 09 09 09 09 08 08 08
		.hex 07 07 07 06 06 06 05 05 05 04 04 03 03 02 01 00
; xpos for the knight anim
L8a60		.hex ec ed ee ef f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 fa fb
		.hex fc fd fe ff 00 01 02 03 04 05 06 07 08 09 0a 0a
; sprite IDs for the knight anim - null terminated
L8a80		.hex 13 14 13 14 13 14 13 14 13 14 13 14 13 14 13 14
		.hex 13 14 13 14 13 14 13 14 13 14 13 14 13 14 13 00

		; .hex
		; 13 14 13 14 13 14 00 00 00 00 00 00 00 00 00 00
		; 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		; 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		; 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		; 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		; 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		; .end

; 		.org $8B00

; ; L8b00
; 		.hex
; 		80 80 80 80 00 00 00 00 e0 87 80 80 80 80 80 80
; 		80 80 80 80 80 80 00 00 00 00 c0 83 80 80 80 80
; 		80 80 80 80 80 80 80 80 00 00 00 00 c0 83 80 80
; 		80 80 80 80 80 80 80 80 80 80 00 00 00 00 c0 83
; 		80 80 80 80 80 80 80 80 80 80 80 80 00 00 00 00
; 		80 83 80 80 80 80 80 80 80 80 80 80 80 80
; 		.end


		; .align $100
;L8f00
		; .hex
		; 00 19 72 00 41 19 3e 18 7d 01 40 60 0f 01 00 00
		; 21 01 00 00 01 01 00 00 01 01 00 00 01 01 00 00
		; 21 01 00 00 01 01 00 00 01 01 00 00 01 01 00 00
		; 21 01 00 00 01 01 00 00 01 01 00 00 01 01 00 00
		; 21 01 00 00 01 01 00 00 01 01 00 00 01 01 00 00
		; 21 01 00 00 01 01 00 00 01 01 00 00 01 01 00 00
		; 21 01 32 3e 4d 79 02 60 4f 07 32 3e 7d 79 72 66
		; 6d 1f 00 00 01 01 00 00 01 01 00 00 01 33 66 4c
		; 19 03 60 4c 19 33 66 4c 61 31 66 40 01 01 00 00
		; 01 01 00 00 05 05 00 00 0d 67 4c 78 03 61 4e 18
		; 33 7f 4c 60 71 67 4c 06 01 01 00 00 05 05 00 00
		; 01 01 00 4c 67 4d 79 00 61 4d 18 32 67 4d 61 30
		; 67 4d 00 40 01 01 00 00 01 01 00 00 01 01 0c 7e
		; 7d 19 02 60 4d 07 0c 66 4d 61 30 66 4f 1f 02 00
		; 01 01 00 00 01 01 00 00 01 71 66 4c 1f 3f 7e 7c
		; .end

L8ff0		.hex 79
L8ff1		.hex 73
L8ff2		.hex 66
L8ff3		.hex 4e
L8ff4		.hex 1f
L8ff5		.hex 31
L8ff6		.hex 60
L8ff7		.hex 4c
L8ff8		.hex 19
isAnimDone	.db 0
L8ffa		.hex 66
L8ffb		.hex 0c
L8ffc		.hex 61
L8ffd		.hex 31
L8ffe		.hex 60
L8fff		.hex 4c
L5ff7		.db 0
