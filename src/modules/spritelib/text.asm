; text.asm
; Renders text using tools/font.asm and spritelib tables

rowY 		.equ $00	; screen line of the glyph row being drawn
glyphEnd 	.equ $01	; offset in font past the glyph's last row
textPtr 	.equ $02
temp 		.equ $04

.procedure drawText

        stx textPtr
        sty textPtr+1

        ; Calculate initial byte offset and shift
        ; Since font width=6 and gap=1, stride is 7.
        ; This means (X % 7) is constant for the whole string!
        ; We only need to increment the byte offset by 1 for each character.

        ; Calculate Byte Offset and Shift
        lda textX
        ldy #0
        cmp #7
        bcc doneDiv
divLoop:
        sbc #7
        iny
        cmp #7
        bcs divLoop
doneDiv:
        sty currentByteOffset
        sta currentShift

charLoop:
        lda (textPtr)
        beq done

	inc textPtr
	bne :+
	inc textPtr+1
:

        jsr drawChar

        ; Advance to next character position (8 pixels = 1 byte + 1 pixel)
        inc currentByteOffset
        inc currentShift
        lda currentShift
        cmp #7
        bcc :+
        sbc #7
        sta currentShift
        inc currentByteOffset
:

        bra charLoop

done:
        rts

.end

; -----------------------------------------------------------------------------
; drawChar
; Inputs: A = ASCII char
; Context: currentByteOffset, textY, currentShift
; -----------------------------------------------------------------------------
.procedure drawChar
        ; 1. Map ASCII to the glyph's offset in font
        cmp #"a"
        bcc :+
        cmp #"z"+1
        bcs :+
        and #$DF        ; lowercase -> uppercase
:       sec
        sbc #FIRST_GLYPH
        cmp #GLYPH_COUNT
        bcs return      ; outside the table (chars below FIRST_GLYPH wrap above it)
        tax
        lda glyphOffsets,x
        cmp #NO_GLYPH
        beq return      ; no glyph for this char (space, ...)
        tax             ; X = offset of the glyph's first row in font
        clc
        adc #height
        sta glyphEnd
        lda textY
        sta rowY

        ; 2. Draw the glyph's rows
rowLoop:
        ; Get screen address of the row
        ldy rowY
        lda utils::hgrLow,y
        sta $1c
        lda utils::hgrHigh,y
        sta $1d

        ; Get font byte
        lda font,x

        sta temp
        stz temp+1

        ; Shift to position
        ldy currentShift
        beq noShift
shiftLoop:
        asl temp
        bpl :+

        lda temp
        and #$7f
        sta temp
        sec
        bra :++

:       clc

:
        rol temp+1
        dey
        bne shiftLoop
noShift:
        ldy currentByteOffset
        lda temp
        ora ($1c),y
        sta ($1c),y

        lda temp+1
        beq :+
        and #$7f
        iny
        ora ($1c),y
        sta ($1c),y
:

        inc rowY
        inx
        cpx glyphEnd
        bne rowLoop

return:
        rts

.end

; -----------------------------------------------------------------------------
; Font: page-aligned, so a glyph is read with lda font,x without crossing a page,
; and a glyph's offset in font is the low byte of its address.
; -----------------------------------------------------------------------------
	.align $100

font:
        .include "font.asm"
fontEnd:

	.assert fontEnd - font <= NO_GLYPH, "the font is ", fontEnd - font, " bytes: it must fit in one page, offset $FF excluded"

; Glyph offsets
; One entry per char from FIRST_GLYPH to LAST_GLYPH, indexed by (char - FIRST_GLYPH).
; Glyph labels are <prefix><letter> for A-Z, <prefix>Char_<hex code> otherwise (see font.asm).
; A char without a glyph gets NO_GLYPH, which drawChar skips.
FIRST_GLYPH = "."
LAST_GLYPH = "Z"
GLYPH_COUNT = LAST_GLYPH - FIRST_GLYPH + 1
NO_GLYPH = $FF

.function glyphAt(code) {
    name = prefix + "Char_" + .str(code, 16)
    .if code >= "A" && code <= "Z" {
        letters = .split("A B C D E F G H I J K L M N O P Q R S T U V W X Y Z")
        name = prefix + letters[code - "A"]
    }
    .if .def((name)) {
        .return .label(name) - font
    }
    .return NO_GLYPH
}

glyphOffsets:	.byte ... .map(.range(FIRST_GLYPH + 0, GLYPH_COUNT), glyphAt)
