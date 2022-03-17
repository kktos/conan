; 05.1 load disk[F000-FFFF] to MEM[A000-AFFF]
		ldx #$0f
		stx rwts_trk
		ldx #$af
		stx rwts_buf+1
		jsr readTrack

; 06 load disk[E000-EFFF] to MEM[9000-9FFF]
		dec rwts_trk
		jsr readTrack

; load disk[D000-DFFF] to MEM[8000-8FFF]
		dec rwts_trk
		jsr readTrack

; load disk[C000-CFFF] to MEM[7000-7FFF]
		dec rwts_trk
		jsr readTrack

; load disk[B000-BFFF] to MEM[6000-6FFF]
		dec rwts_trk
		jsr readTrack

; 07 load disk[4000-40FF] to MEM[1000-10FF]
; will be relocated to $0300 -> L0257
; 07-vectors-page03.asm
		ldx #$10
		stx rwts_buf+1
		ldx #$04
		stx rwts_trk
		ldx #$00
		stx rwts_sec
		jsr readSector
