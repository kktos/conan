
	.include "../../includes/prodos.asm"

	.namespace tinyDOS scope="lc_bank2"

namelen 	= $02
tmplen 		= $03
blockPage	= $04
BUFFER 		= $0A00

SmartPortEntry:
	jmp $FFFF

LoadFile:
	stx tmpPtr
	sty tmpPtr+1

	; read
	lda #$01
	sta smartport::command

	; directory block $0002
	inc a
	sta smartport::bloklo
	stz smartport::blokhi

	lda #>BUFFER
	sta smartport::adrhi
	stz smartport::adrlo

dirLoop:
        jsr SmartPortEntry

        jsr FindFile
        bcc :+		          ; C=1 if found

        jmp LoadFileBlocks

:
	lda #>BUFFER
	sta smartport::adrhi

	; get next directory block
	lda BUFFER+2
	sta smartport::bloklo
	lda BUFFER+3
	sta smartport::blokhi

	lda smartport::bloklo
	ora smartport::blokhi
	bne dirLoop

	jmp ShowError

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
	; addMemRegion(filename, addr, len, color)
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

	BRK
	.db $03
start:	.dw $0000
size:	.dw $0000
name:	.dw $0000
	.dw $0000

	lda #>BUFFER
	sta smartport::adrhi
	stz smartport::adrlo

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

	ldy #$00
loop:
	lda (tmpPtr),y
	beq loaded

        sta smartport::bloklo
        jsr SmartPortEntry

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

	.end namespace

	; .org $A00 - 5
	; .text "kktos"
