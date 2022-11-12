; 05.1 load disk[F000-FFFF] to MEM[A000-AFFF]
;
; data ???
;
		; ldx #$0f
		; stx rwts_trk
		; ldx #$af
		; stx rwts_buf+1
		; jsr readTrack

		; read_diskw $0F00, $A000, $1000

; 06 load disk[E000-EFFF] to MEM[9000-9FFF]
;
; setup dialog code and data
;
		; dec rwts_trk
		; jsr readTrack

		; read_diskw $0E00, $9000, $1000

; load disk[D000-DFFF] to MEM[8000-8FFF]
;
; intro code and data
;
		; dec rwts_trk
		; jsr readTrack

		; read_diskw $0D00, $8000, $1000

; load disk[C000-CFFF] to MEM[7000-7FFF]
;
; data ???
;
		; dec rwts_trk
		; jsr readTrack

		; read_diskw $0C00, $7000, $1000

; load disk[B000-BFFF] to MEM[6000-6FFF]
;
; data intro ???
;
		; dec rwts_trk
		; jsr readTrack

		; read_diskw $0B00, $6000, $1000


;
; all in one
;
		read_diskw $0B00, $6000, $5000

; 07 load disk[4000-40FF] to MEM[1000-10FF]
; will be relocated to $0300 -> L0257
; 07-vectors-page03.asm
		; ldx #$10
		; stx rwts_buf+1
		; ldx #$04
		; stx rwts_trk
		; ldx #$00
		; stx rwts_sec
		; jsr readSector

		read_diskw $0400, $1000, $0100

