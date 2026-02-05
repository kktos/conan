
drawSpriteBis
		sty yPos
		tay
		lda spritelib::spriteLo-1,y
		sta $1c
		lda spritelib::spriteHi-1,y
		sta $1d
		ldy #$00
		sty spritelib::isFlipped
		lda ($1c),y
		sta spritelib::dsWidth
		sta spritelib::dsWidthInit
		iny
		lda ($1c),y
		sta spritelib::dsHeight
		stx Ypos
		bpl :+

		inc spritelib::isFlipped
		and #$7f
		sta spritelib::dsHeight
		lda spritelib::LB200,x
		asl
		clc
		adc #$02
		tay
		lda ($1c),y
		sta pixels
		iny
		lda ($1c),y
		sta pixels+1
		jmp La05a

:	     	lda spritelib::LAF00,x
		asl
		clc
		adc #$02
		tay
		lda ($1c),y
		sta pixels
		iny
		lda ($1c),y
		sta pixels+1

La05a       	ldy yPos
		lda utils::hgrLow,y
		sta $1c
		lda utils::hgrHigh,y
		sta $1d
		ldx Ypos
		ldy spritelib::isFlipped
		beq :+

		lda spritelib::LB000,x
		tay
		jmp La07a

:	      	lda spritelib::LB100,x
		tay

La07a       	cpy #40
		bcs :+

pixels=*+1
		lda $ffff
		sta ($1c),y
:	   	inc pixels
		bne :+

		inc pixels+1
:	      	iny
		cpy #74
		bne :+

		ldy #$00
:               dec spritelib::dsWidth
		bne La07a

		ldx spritelib::dsWidthInit
		stx spritelib::dsWidth
		dec spritelib::dsHeight
		beq :+
		inc yPos
		jmp La05a

:		rts
