
	.include "../../includes/prodos.asm"

	.namespace tinyDOS scope="lc_bank2"

BUFFER 		= $0A00

namelen 	= $02
tmplen 		= $03
blockPage	= $04
blockStart	= $05
blockCount	= $06

SmartPortEntry:
	jmp $FFFF

;
; x/y points to
;  .pstr filename
;
LoadFile:
	stz blockStart		; read from first file block
	lda #$FF 		; read the 256 block, i.e all
	sta blockCount

	stx tmpPtr
	sty tmpPtr+1

internalLoadFile:
	; read
	lda #$01
	sta smartport::command

	; directory block $0002
	inc a
	sta smartport::bloklo
	stz smartport::blokhi

dirLoop:
	jsr initBuffer
        jsr SmartPortEntry

        jsr FindFile
        bcc :+		          ; C=1 if found

        jmp LoadFileBlocks

:
	; get next directory block
	lda BUFFER+2
	sta smartport::bloklo
	lda BUFFER+3
	sta smartport::blokhi

	lda smartport::bloklo
	ora smartport::blokhi
	bne dirLoop

	jmp ShowError

;
; x/y points to
;  .db block start
;  .db block count
;  .pstr filename
;
LoadFromFile:
	stx tmpPtr
	sty tmpPtr+1

	lda (tmpPtr)
	sta blockStart
	inc tmpPtr

	lda (tmpPtr)
	sta blockCount
	inc tmpPtr
	bra internalLoadFile

initBuffer:
	lda #>BUFFER
	sta smartport::adrhi
	stz smartport::adrlo
	rts


FindFile:
	stz blockPage
        ldy #4                      ; first entry

NextEntry:
        lda (smartport::adrlo),y
        beq NotFound                ; unused entry

        jsr MatchName
        bcc Next                    ; C=0 → no match

	lda smartport::adrhi
	sta srcPtr+1

	tya
	clc
	adc smartport::adrlo
	sta srcPtr
	bcc :+
	inc srcPtr+1
:
        ; Starting block
	ldy #prodos::keyPtr
        lda (srcPtr),y
        sta smartport::bloklo
        iny
        lda (srcPtr),y
        sta smartport::blokhi

        ; Load address
	ldy #prodos::auxType
        lda (srcPtr),y
        sta tmpPtr
        iny
        lda (srcPtr),y
        sta tmpPtr+1

        sec
        rts

Next:
        tya
        clc
        adc #$27
        tay
        bcc NextEntry

	lda blockPage
	bne NotFound 	; we should read the next dir block - TBD

	inc blockPage
	inc smartport::adrhi
        bra NextEntry

NotFound:
        clc
        rts

MatchName:
        and #$0F
        cmp (tmpPtr)
        bne NotFound

        phy
	sta namelen
        iny
	lda #$01
	sta tmplen

NameLoop:
        phy
        ldy tmplen
        lda (tmpPtr),y
        ply
        cmp (smartport::adrlo),y
        bne NoMatch

        iny
        inc tmplen
        lda tmplen
	cmp namelen	; <= namelen
        bcc NameLoop
        beq NameLoop

        ply
        rts

NoMatch:
        clc
        ply
        rts

LoadFileBlocks:
	jsr dbgAddMemRegion

	jsr initBuffer

	; read index block
        jsr SmartPortEntry

	lda tmpPtr
	sta smartport::adrlo
	sta srcPtr
	lda tmpPtr+1
	sta smartport::adrhi
	sta srcPtr+1

	lda #>BUFFER
	sta tmpPtr+1
	stz tmpPtr

	; =0 LoadFile
	; =xx LoadFromFile
	ldy blockStart
loop:
	lda (tmpPtr),y
	beq loaded

        sta smartport::bloklo
        jsr SmartPortEntry

	dec blockCount
	beq loaded

	inc smartport::adrhi
	inc smartport::adrhi
	iny
	bne loop
loaded:
	rts

ShowError:
	lda sys::PAGE2OFF
	lda sys::TEXTON

        ldy #$00
        lda (tmpPtr),y
	tay
:
        lda (tmpPtr),y
	sta ErrorMsgFile,y
	dey
	bne :-

        ldx #0
        ldy #5
:
        lda ErrorMsg,x
        beq Hang
	ora #$80
	sta LINE10,y
        inx
        iny
        bne :-
Hang:
        bra Hang

ErrorMsg:
        .text "UNABLE TO FIND "
ErrorMsgFile:
        .fill 15, $A0
	.db 0

dbgAddMemRegion:

	lda tmpPtr
	sta start
	lda tmpPtr+1
	sta start+1

        ; ; block size
	; ldy #prodos::blockSize
        ; lda (srcPtr),y
        ; sta size
        ; iny
        ; lda (srcPtr),y
        ; sta size+1

        ; block size
	ldy #prodos::EOF
        lda (srcPtr),y
        sta size
        iny
        lda (srcPtr),y
        sta size+1

        ; filename
        lda srcPtr+1
        sta name+1
	clc
	lda #prodos::filename
        adc srcPtr
        sta name
	bcc :+
        inc name+1
:
	; addMemRegion(filename, addr, len, color)

	BRK
	.db $03
start:	.dw $0000
size:	.dw $0000
name:	.dw $0000
	.dw $0000

	rts
	.align $10
	.text "tiny_dos"
	.end namespace

	; .org $A00 - 5
	; .text "kktos"
