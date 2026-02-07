
tmpPtr		= $00
srcPtr		= $02
dstPtr		= $04
sizePtr		= $06
LINE10 		= $528
	.db 1
Start:
	stx smartport::unit

	txa
	and #$70
	lsr a
	lsr a
	lsr a
	lsr a
	ora #$C0
	sta tmpPtr+1
	sta callSP+2

	lda #$FF
	sta tmpPtr
	lda (tmpPtr)
	sta tmpPtr
	sta callSP+1

	inc smartport::bloklo
	inc smartport::adrhi
	inc smartport::adrhi
callSP:
	jsr $FFFF

        jsr sys::HOME

	lda sys::LCBANK2
	lda sys::LCBANK2

	lda #<(.segment.start+.segment.size)
	sta srcPtr
	lda #>(.segment.start+.segment.size)
	sta srcPtr+1

	dosSegment = .segment("TINY_DOS")
	lda #<dosSegment.start
	sta dstPtr
	lda #>dosSegment.start
	sta dstPtr+1

	lda #<dosSegment.size
	sta sizePtr
	lda #>dosSegment.size
	sta sizePtr+1

	ldy #0
RelocateLoop:
	lda (srcPtr),y
	sta (dstPtr),y
	inc srcPtr
	bne :+
	inc srcPtr+1
:
	inc dstPtr
	bne :+
	inc dstPtr+1
:
	lda sizePtr
	bne :+
	dec sizePtr+1
:
	dec sizePtr
	lda sizePtr
	ora sizePtr+1
	bne RelocateLoop

	lda tmpPtr
	sta tinyDOS::SmartPortEntry+1
	lda tmpPtr+1
	sta tinyDOS::SmartPortEntry+2

	;
	; add mem region
	;

	BRK
	.db $03
	.dw dosSegment.start
	.dw dosSegment.size
	.dw regionname
	.dw $0000

	ldx #<TargetName
	ldy #>TargetName
	jsr tinyDOS::LoadFile
	jmp (srcPtr)

TargetName:
        .pstr "WELCOME"

regionname:
        .cstr "tiny_dos"

