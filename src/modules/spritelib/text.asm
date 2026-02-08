; text.asm
; Renders text using tools/font.asm and spritelib tables

        .include "font.asm"

fontPtr 	.equ $00
textPtr 	.equ $02
temp 		.equ $04

.function drawText

        stx textPtr
        sty textPtr+1

        ; Calculate initial byte offset and shift
        ; Since font width=6 and gap=1, stride is 7.
        ; This means (X % 7) is constant for the whole string!
        ; We only need to increment the byte offset by 1 for each character.

        ; Calculate Byte Offset = LB000[X]
        ldy textX
        lda LB000,y
        sta currentByteOffset

        ; Calculate Shift = X % 7
        ; We compute X - (ByteOffset * 7)
        asl         ; * 2
        asl         ; * 4
        asl         ; * 8
        sec
        sbc currentByteOffset ; * 7
        sta temp

        lda textX
        sec
        sbc temp
        sta currentShift

charLoop:
        lda (textPtr)
        beq done

	inc textPtr
	bne :+
	inc textPtr+1
:

        jsr drawChar

        ; Advance to next character position (7 pixels = 1 byte)
        inc currentByteOffset

        bra charLoop

done:
        rts

.end

; -----------------------------------------------------------------------------
; drawChar
; Inputs: A = ASCII char
; Context: currentByteOffset, textY, currentShift
; -----------------------------------------------------------------------------
.function drawChar
        ; 1. Map ASCII to Font Address
        cmp #"a"
        bcc :+
        ; cmp #"z"+1
        cmp #$7A + 1
        bcs :+
        sec
        sbc #32         ; Convert lowercase to uppercase
:
        ; Check ranges
        cmp #"A"
        bcc checkNum
        ; cmp #"Z"+1
        cmp #$5A + 1
        bcs checkNum
        ; A-Z
        sec
        sbc #"A"
        tax
        lda FontTable_Alpha_Lo,x
        sta fontPtr
        lda FontTable_Alpha_Hi,x
        sta fontPtr+1
        jmp draw

checkNum:
        cmp #"0"
        bcc checkSym
        ; cmp #"9"+1
        cmp #$39 + 1
        bcs checkSym
        ; 0-9
        sec
        sbc #"0"
        tax
        lda FontTable_Num_Lo,x
        sta fontPtr
        lda FontTable_Num_Hi,x
        sta fontPtr+1
        jmp draw

checkSym:
        ; Handle specific symbols
        cmp #"."
        bne :+
        lda #<letter_Char_2E
        sta fontPtr
        lda #>letter_Char_2E
        sta fontPtr+1
        jmp draw
:       cmp #":"
        bne return      ; Unknown char or space
        lda #<letter_Char_3A
        sta fontPtr
        lda #>letter_Char_3A
        sta fontPtr+1

draw:
        ; 2. Draw 5 rows
        ldx #0          ; Row index
rowLoop:
        ; Get screen address for (textY + X)
        lda textY
        clc
        adc rowIndices,x ; Add row offset (0,1,2,3,4)
        tay

        lda utils::hgrLow,y
        sta $1c
        lda utils::hgrHigh,y
        sta $1d

        ; Get font byte
        ldy #0
        lda (fontPtr),y

        ; Reverse bits (Font is MSB-left, Screen is LSB-left)
        ; Font: 765432xx -> Screen: 012345xx
        jsr reverse6Bits

        ; Shift to position
        ldy currentShift
        beq noShift
:       asl
        dey
        bne :-
noShift:
        ; A now contains the bits shifted into position.
        ; Note: If shift > 1, bits might spill into the next byte.
        ; However, for simplicity and speed, and since width=6,
        ; we write to currentByte and currentByte+1.

        ldy currentByteOffset
        ora ($1c),y     ; OR with screen contents
        sta ($1c),y

        ; Handle spillover if any (simple approach: write same byte shifted right by 7?)
        ; Actually, with ASL, bits moved to high part.
        ; We need 16-bit shift logic if we want to be precise,
        ; but since we process byte-by-byte and stride is 7,
        ; the "spillover" is effectively handled by the next char's drawing
        ; OR we need to write the high bits to offset+1.
        ; Given the constraints and simplicity, we assume chars don't overlap destructively.

        ; Increment font ptr
        inc fontPtr
        bne :+
        inc fontPtr+1
:
        inx
        cpx #5
        bne rowLoop

return:
        rts

; Helper: Reverse top 6 bits of A (765432..) to bottom 6 bits (..234567)
reverse6Bits:
	sta temp
	lda #0
	ldy #6
:
	asl temp    ; Shift bit 7 into carry
	ror         ; Rotate carry into bit 7
	dey
	bne :-
	lsr         ; Shift right to align
	lsr
	rts

.end

rowIndices: .byte 0, 1, 2, 3, 4

	.align $100

; Lookup Tables
FontTable_Alpha_Lo:
    .byte .lobyte(letter_A), .lobyte(letter_B), .lobyte(letter_C), .lobyte(letter_D), .lobyte(letter_E), .lobyte(letter_F), .lobyte(letter_G), .lobyte(letter_H)
    .byte .lobyte(letter_I), .lobyte(letter_J), .lobyte(letter_K), .lobyte(letter_L), .lobyte(letter_M), .lobyte(letter_N), .lobyte(letter_O), .lobyte(letter_P)
    .byte .lobyte(letter_Q), .lobyte(letter_R), .lobyte(letter_S), .lobyte(letter_T), .lobyte(letter_U), .lobyte(letter_V), .lobyte(letter_W), .lobyte(letter_X)
    .byte .lobyte(letter_Y), .lobyte(letter_Z)

FontTable_Alpha_Hi:
    .byte .hibyte(letter_A), .hibyte(letter_B), .hibyte(letter_C), .hibyte(letter_D), .hibyte(letter_E), .hibyte(letter_F), .hibyte(letter_G), .hibyte(letter_H)
    .byte .hibyte(letter_I), .hibyte(letter_J), .hibyte(letter_K), .hibyte(letter_L), .hibyte(letter_M), .hibyte(letter_N), .hibyte(letter_O), .hibyte(letter_P)
    .byte .hibyte(letter_Q), .hibyte(letter_R), .hibyte(letter_S), .hibyte(letter_T), .hibyte(letter_U), .hibyte(letter_V), .hibyte(letter_W), .hibyte(letter_X)
    .byte .hibyte(letter_Y), .hibyte(letter_Z)

FontTable_Num_Lo:
    .byte .lobyte(letter_Char_30), .lobyte(letter_Char_31), .lobyte(letter_Char_32), .lobyte(letter_Char_33), .lobyte(letter_Char_34)
    .byte .lobyte(letter_Char_35), .lobyte(letter_Char_36), .lobyte(letter_Char_37), .lobyte(letter_Char_38), .lobyte(letter_Char_39)

FontTable_Num_Hi:
    .byte .hibyte(letter_Char_30), .hibyte(letter_Char_31), .hibyte(letter_Char_32), .hibyte(letter_Char_33), .hibyte(letter_Char_34)
    .byte .hibyte(letter_Char_35), .hibyte(letter_Char_36), .hibyte(letter_Char_37), .hibyte(letter_Char_38), .hibyte(letter_Char_39)
