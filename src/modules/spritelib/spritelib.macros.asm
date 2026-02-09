

.macro drawText text, x, y {
	lda #x
	sta spritelib::textX
	lda #y
	sta spritelib::textY

	ldx #<text
	ldy #>text
	jsr spritelib::drawText
}
