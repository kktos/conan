
.proc spritesDebug {
		bit sys::KBDSTRB

		lda #$41		; 1st id of current level sprites
		sta spriteID


:loop
		jsr utils::clearScreen

; :		lda $C019
; 		bpl :-
; :		lda $C019
; 		bmi :-

		lda spriteID
		ldx #.lobyte(idHexString)
		ldy #.hibyte(idHexString)
		jsr utils::int2hex

		lda spriteID
		jsr spritelib::getSpriteDimensions

		lda spritelib::dsWidth
		ldx #.lobyte(widthStr)
		ldy #.hibyte(widthStr)
		jsr utils::int2str

		lda spritelib::dsHeight
		ldx #.lobyte(heightStr)
		ldy #.hibyte(heightStr)
		jsr utils::int2str

		lda spritelib::dsWidth
		ora spritelib::dsWidth
		beq :+

		lsr spritelib::dsWidth
		lda #140/2
		sec
		sbc  spritelib::dsWidth
		tax

		lsr spritelib::dsHeight
		lda #180/2
		sec
		sbc spritelib::dsHeight
		tay

		lda spriteID
		jsr spritelib::drawSpriteM

:
		jsr clearDbgView
		drawText widthString, 108, 170
		drawText heightString, 188, 170
		drawText idString, 48, 170

:		lda sys::KBD
		bpl :-
		bit sys::KBDSTRB
		and #$7f

		cmp #"-"
		bne :+

		dec spriteID
		jmp :loop
:
		cmp #"+"
		bne :+

		inc spriteID
		jmp :loop
:
		rts

clearDbgView:
		ldx #165
		stx globals::unknown_yPos
L1c03		jsr S1c11
		inc globals::unknown_yPos
		ldx globals::unknown_yPos
		cpx #179
		bne L1c03
		rts

S1c11		jsr getHGRLineAddr
		ldy #$06
		lda #$00
L1c18		sta ($1a),y
		iny
		cpy #36
		bne L1c18
		rts

getHGRLineAddr
		ldx globals::unknown_yPos
		lda utils::hgrLow,x
		sta $1a
		lda utils::hgrHigh,x
		sta $1b
		rts

spriteID	.db $00


idString	.str "ID:"
idHexString	.str "00"
		.db $00

widthString	.str "w: "
widthStr	.str "0000"
		.db $00

heightString	.str "h: "
heightStr	.str "0000"
		.db $00
}
