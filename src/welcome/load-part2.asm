		; 08 load disk[9000-9FFF] to MEM[7000-7FFF]
		ldx #$0f
		stx rwts_sec
		ldx #$7f
		stx rwts_buf+1
		ldx #$09
		stx rwts_trk
		jsr readTrack

		; 08 load disk[8000-8FFF] to MEM[6000-6FFF]
		dec rwts_trk
		jsr readTrack

		; 08 load disk[7000-7FFF] to MEM[5000-5FFF]
		dec rwts_trk
		jsr readTrack

		; 08 load disk[6000-6FFF] to MEM[4000-4FFF]
		dec rwts_trk
		jsr readTrack

		; 09 load disk[5000-5FFF] to MEM[1000-1FFF]
		dec rwts_trk
		ldx #$1f
		stx rwts_buf+1
		jsr readTrack

		; 10 load disk[4000-4CFF] to MEM[0300-0FFF]
		dec rwts_trk
		ldx #$0c
		stx rwts_sec
		jsr readTrack2

		; 11 load disk[3000-3FFF] to MEM[A700-B6FF]
		ldx #$b6
		stx rwts_buf+1
		ldx #$03
		stx rwts_trk
		jsr readTrack
