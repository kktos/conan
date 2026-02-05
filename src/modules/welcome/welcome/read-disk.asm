readTrack	jsr readSector
		dec rwts_buf+1
		dec rwts_sec
		bpl readTrack
		ldx #$0f
		stx rwts_sec
		rts

readTrack2	jsr readSector
		dec rwts_buf+1
		dec rwts_sec
		bne readTrack2
		ldx #$0f
		stx rwts_sec
		rts

readSector	ldx #$00
		stx $48
		stx rwts_vol
		ldy #$e8
		lda #$b7
		jmp enterwts
