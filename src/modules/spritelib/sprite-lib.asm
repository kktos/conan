; disk T3 into $A700:B6FF

		; .export hgrHi
		; .export hgrLo

; $A700 00 x 256
; $A800 00 x 256
; $A900 00 x 256
; $AA00 00 x 256
; $AB00 00 x 256
; $AC00 00 x 256
; $AD00 00 x 256
		; .fill 256*7

		; .org $AE00

.macro drawSprite id, x, y {
		ldx x
		ldy y
		lda id
		jsr spritelib::drawSprite
}

.function drawSprite {
		sty yPos
		tay
		lda spriteLo-1,y
		sta $1c
		lda spriteHi-1,y
		sta $1d

		ldy #$00
		sty isFlipped
		lda ($1c),y
		sta dsWidth
		sta dsWidthInit
		iny
		lda ($1c),y
		sta dsHeight
		stx dsHeightInit
		bpl Lae44

		inc isFlipped
		and #$7f
		sta dsHeight
		lda LB200,x
		bra :+

Lae44		lda LAF00,x
:
		asl
		clc
		adc #$02
		tay
		lda ($1c),y
		sta pixels
		iny
		lda ($1c),y
		sta pixels+1

loop:		ldy yPos
		lda utils::hgrLow,y
		sta $1c
		lda utils::hgrHigh,y
		sta $1d
		ldx dsHeightInit

		ldy isFlipped
		beq :+

		lda LB000,x
		jmp nextItem

;Lae73
:		lda LB100,x
nextItem
		tay

Lae77               cpy #40 ; $28
                    bcs Lae8e

pixels=*+1
                    lda $ffff

                    tax
                    and #$80
                    sta LB3F8
                    txa
                    eor ($1c),y
                    and #$7f
                    ora LB3F8
                    sta ($1c),y
Lae8e               inc pixels
                    bne Lae96

                    inc pixels+1
Lae96               iny
                    cpy #$4a
                    bne Lae9d

                    ldy #$00
Lae9d               dec dsWidth
                    bne Lae77

                    ldx dsWidthInit
                    stx dsWidth
                    dec dsHeight
                    beq Laeb3

                    inc yPos
                    jmp loop

Laeb3               rts
}

; $B300
.function drawSpriteM {
		sty yPos
		tay
		lda spriteLo-1,y
		sta $1c
		lda spriteHi-1,y
		sta $1d
		ldy #$00
		sty isFlipped
		lda ($1c),y
		sta dsWidth   ; width
		sta dsWidthInit
		iny
		lda ($1c),y
		sta dsHeight   ; height
		stx dsHeightInit
		bpl Lb344

		inc isFlipped
		and #$7f
		sta dsHeight
		lda LB200,x
		asl
		clc
		adc #$02
		tay
		lda ($1c),y
		sta mask
		iny
		lda ($1c),y
		sta mask+1
		jmp Lb357

Lb344               lda LAF00,x
		asl
		clc
		adc #$02
		tay
		lda ($1c),y
		sta mask
		iny
		lda ($1c),y
		sta mask+1

Lb357               ldy yPos
		lda utils::hgrLow,y
		sta $1c
		lda utils::hgrHigh,y
		sta $1d
		ldx dsHeightInit
		ldy isFlipped
		beq Lb373
		lda LB000,x
		tay
		jmp Lb377

Lb373               lda LB100,x
                    tay
Lb377               cpy #$28
                    bcs Lb388
                    lda ($1c),y
                    bmi Lb388
                    bne Lb3ae

mask=*+1
loop:
		lda $ffff

		eor ($1c),y
		sta ($1c),y
Lb388 		inc mask
		bne Lb390
		inc mask+1
Lb390 		iny
		cpy #$4a
		bne Lb397
		ldy #$00
Lb397 		dec dsWidth
		bne Lb377
		ldx dsWidthInit
		stx dsWidth
		dec dsHeight
		beq Lb3ad
		inc yPos
		jmp Lb357

Lb3ad 		rts

Lb3ae 		ldx mask
		stx mask2
		ldx mask+1
		stx mask2+1

mask2=*+1
		and $ffff

		beq loop
		inc isCollision
		jmp loop
}
