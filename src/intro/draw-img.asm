;   A: img id
;   X: x coord
;   Y: y coord
drawImg		sty yPos
		stx xPos

		tay
		ldx spritesW,y
		stx width
		ldx spritesH,y
		stx height

		asl
		tay
		lda spritesAddr,y
		sta $1c
		lda spritesAddr+1,y
		sta $1d

		; lda spritesLo,y ; src lo
		; sta $1c
		; lda spritesHi,y ; src hi
		; sta $1d

		; .db $42,$FF
		; .cstr "drawImg id:%y %W %H %D"
		; .db 5
		; .dw xPos, yPos, width, height, $1c

                    ldx #$00
L801f               ldy yPos
                ;     lda hgrAddrLo,y ; hires addr lo
                    lda utils.hgrLow,y ; hires addr lo
                    sta $1a
                ;     lda hgrAddrHi,y ; hires addr hi
                    lda utils.hgrHigh,y ; hires addr hi
                    clc
                    adc hgrPage ; page1:+$00 / page2:+$20
                    sta $1b

                    lda width
                    sta tmpW

                    lda xPos
                    sta L80f3

L803c               dec tmpW
                    bmi L8058
                    ldy L80f3
                    cpy #$28
                    bcs L804c
                    lda ($1c,x)
                    sta ($1a),y
L804c               inc L80f3
                    inc $1c
                    bne L803c
                    inc $1d
                    jmp L803c

L8058               dec height
                    beq L8063
                    inc yPos
                    jmp L801f

L8063               rts

drawImgWithMask	sty L81F0
		stx L81F1
		tay

		ldx spritesW,y
		stx L81F2
		ldx spritesH,y
		stx L81F5

		; lda spritesLo,y
		; sta $1c
		; lda spritesHi,y
		; sta $1d

		asl
		tay
		lda spritesAddr,y
		sta $1c
		lda spritesAddr+1,y
		sta $1d


		ldx #$00
L811f               ldy L81F0
                ;     lda hgrAddrLo,y
                    lda utils.hgrLow,y
                    sta $1a
                    sta $1e
                ;     lda hgrAddrHi,y
                    lda utils.hgrHigh,y
                    sta $1b
                    clc
                    adc #$20
                    sta $1f
                    lda L81F2
                    sta L81F4
                    lda L81F1
                    sta L81F3
L813f               dec L81F4
                    bmi L815f
                    ldy L81F3
                    cpy #$28
                    bcs L8153
                    lda ($1e),y
                    bmi L8153
                    lda ($1c,x)
                    sta ($1a),y
L8153               inc L81F3
                    inc $1c
                    bne L813f
                    inc $1d
                    jmp L813f

L815f               dec L81F5
                    beq L816a
                    inc L81F0
                    jmp L811f

L816a               rts


yPos		.db $01
xPos		.db $03
width		.db $00
L80f3		.db $48
tmpW		.db $0b
height          .db $21
hgrPage         .db $7c
scrollYpos	.db $08

L81F0		.db $41
L81F1		.db $01
L81F2		.db $30
L81F3		.db $46
L81F4		.db $01
L81F5		.db $3d

; sprites width
spritesW            .hex
                    0b 0b 0b 0a 0a 0a 0a 0a 09 09 08 08 07 07 09 09
                    09 0a 0b 12 12 28 28 1e 0c 09 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    .end

; sprites height
spritesH            .hex
                    19 13 11 0f 0f 0e 0d 0c 0b 07 09 03 1f 1e 1f 1d
                    1f 1e 1f 13 13 09 09 3f 14 0c 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    .end
