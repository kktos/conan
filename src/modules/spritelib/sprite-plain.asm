;
; drawPlain / drawStore: draw shape A at X, line Y, without the priority /
; collision test of drawSpriteM and with all 8 bits of each byte (drawSprite
; keeps the shape's bit 7):
; - drawPlain EORs the shape on the screen (draw it twice to erase it)
; - drawStore stores the shape's bytes as is (it erases what was under it)
; They were DRAW_PLAIN, a copy in each level's code: drawPlain in levels 3,
; 4, 5, 7 and level 7's final animation (the leftover source's STORD),
; drawStore in levels 0 and 4.
; out: X = the shape's width, Y = the column after the last one drawn
;
; the blend instruction, patched by the entry point:
BLEND_EOR	= $51		; eor ($1c),y
BLEND_KEEP	= $29		; and #$ff: A unchanged

drawStore	pha
		lda #BLEND_KEEP
		sta dpBlend
		lda #$ff
		bra :+

drawPlain	pha
		lda #BLEND_EOR
		sta dpBlend
		lda #$1c
:		sta dpBlend+1
		pla

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
		bpl :+

		inc isFlipped
		and #$7f
		sta dsHeight
		lda LB200,x
		bra :++

:		lda LAF00,x
:		asl
		clc
		adc #$02
		tay
		lda ($1c),y
		sta dpPixels
		iny
		lda ($1c),y
		sta dpPixels+1

dpLine		ldy yPos
		lda utils::hgrLow,y
		sta $1c
		lda utils::hgrHigh,y
		sta $1d
		ldx dsHeightInit
		ldy isFlipped
		beq :+

		lda LB000,x
		bra :++

:		lda LB100,x
:		tay

dpColumn	cpy #40
		bcs :+

dpPixels=*+1
		lda $ffff
dpBlend		eor ($1c),y
		sta ($1c),y

:		inc dpPixels
		bne :+

		inc dpPixels+1
:		iny
		cpy #74
		bne :+

		ldy #$00
:		dec dsWidth
		bne dpColumn

		ldx dsWidthInit
		stx dsWidth
		dec dsHeight
		beq :+

		inc yPos
		bra dpLine

:		rts
