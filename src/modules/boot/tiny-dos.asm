
	; .namepace tinyDOS

tmpPtr		= $00
BUFFER 		= $0A00

SmartPortEntry:
	jmp $FFFF

LoadFile:
	lda #<TargetName
	sta tmpPtr
	lda #>TargetName
	sta tmpPtr+1

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
        bcs LoadFileBlocks          ; C=1 if found

	; get next directory block
	lda BUFFER+2
	sta smartport::bloklo
	lda BUFFER+3
	sta smartport::blokhi

	lda smartport::bloklo
	ora smartport::blokhi
	bne dirLoop

	bne LoadFileBlocks

	jmp ShowError

LoadFileBlocks:
        jmp LoadFileBlocks

FindFile:
        ldy #4                      ; first entry

NextEntry:
        lda (smartport::adrlo),y
        beq NotFound                ; unused entry

        jsr MatchName
        bcc Next                    ; C=0 → no match

        ; Verify SYSTEM file
        lda (smartport::adrlo),y
        and #$0F
        cmp #$0F
        bne Next

        ; Starting block
        lda (smartport::adrlo),y
        clc
        adc #$11
        tay
        lda (smartport::adrlo),y
        sta smartport::bloklo
        iny
        lda (smartport::adrlo),y
        sta smartport::blokhi

        ; Load address
        iny
        lda (smartport::adrlo),y
	tax
        iny
        lda (smartport::adrlo),y
        sta smartport::adrhi
        stx smartport::adrlo

        sec
        rts

Next:
        tya
        clc
        adc #$27
        tay
        bcc NextEntry

NotFound:
        clc
        rts

MatchName:
        phy
        lda (smartport::adrlo),y
        and #$0F
        cmp (tmpPtr),y
        bne NoMatch
	tax
        iny
NameLoop:
        lda (smartport::adrlo),y
        cmp (tmpPtr),y
        bne NoMatch
        iny
	dex
        bne NameLoop

        sec
        ply
        rts

NoMatch:
        clc
        ply
        rts

	; .org $A00 - 5
	; .text "kktos"

	; .end namepace

