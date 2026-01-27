
tmpPtr		= $00
srcPtr		= $02
dstPtr		= $04
sizePtr		= $06

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

	lda #$FF
	sta tmpPtr
	lda (tmpPtr)
	sta tmpPtr

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
	sta SmartPortEntry+1
	lda tmpPtr+1
	sta SmartPortEntry+2

	ldx #<TargetName
	ldy #>TargetName
	jsr LoadFile
	jmp (tmpPtr)

ErrorMsg:
        .byte "UNABLE TO LOAD "

TargetName:
        .byte "WELCOME"
        .byte 0

ShowError:
        jsr sys::HOME

        lda #$12
	sta sys::CV
        lda #$6
	sta sys::CH

        ldx #0
PrintLoop:
        lda ErrorMsg,x
        beq Hang
        jsr sys::COUT
        inx
        bne PrintLoop
Hang:
        bra Hang
