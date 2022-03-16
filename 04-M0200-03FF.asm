		.namespace boot2

		.export L0200

                  * = $200

L0200               ldx #$01
                    stx $0478
                    ldx #$04
                    stx $04f8
                    ldx #$21
                    stx $0578
                    ldx #$60
                    stx $05f8
                    stx $0678
                    ldx #$02
                    stx $06f8
                    ldx #$c6
                    stx $07f8
                    jmp L0254

readTrack           jsr readSector
                    dec rwts_buf+1
                    dec rwts_sec
                    bpl readTrack
                    ldx #$0f
                    stx rwts_sec
                    rts

readTrack2          jsr readSector
                    dec rwts_buf+1
                    dec rwts_sec
                    bne readTrack2
                    ldx #$0f
                    stx rwts_sec
                    rts

readSector          ldx #$00
                    stx $48
                    stx rwts_vol
                    ldy #$e8
                    lda #$b7
                    jmp enterwts

                    ; will load data
                    ; and run intro screen
                    ; with the key settings screen
                    ; if user press R
L0254               jsr S02af

L0257               ldx #$00
L0259               lda $1000,x
                    sta $0300,x
                    inx
                    bne L0259

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

                    jsr $89db
                    jmp $1000

; clear hires1
S02af               ldy #$00
                    sty $1a
                    sty rwts_buf
                    sty $0810
                    ldx #$20
                    stx $1b
                    tya
L02be               sta ($1a),y
                    iny
                    bne L02be
                    inc $1b
                    dex
                    bpl L02be

                    bit $c054
                    bit $c050
                    bit $c052
                    bit $c057

; 05.0 load disk[A000-AFFF] to MEM[6000-6FFF]
; first screen
                    ldx #$0f
                    stx rwts_sec
                    ldx #$0a
                    stx rwts_trk
                    ldx #$6f
                    stx rwts_buf+1
                    jsr readTrack

; unpack to hires
; intro screen
                    ldx rwts_slot
                    lda $c089,x
                    jsr unpack

                    ldx #$68
                    stx L0342+1
                    ldx #$20
                    stx $0810
                    jsr unpack

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

                    bit $c010
                    jsr $8800 ; splash screens with anim
                    rts

unpack              ldx #$00
                    stx $0800
                    stx $0801
L0342               ldx #$60
                    stx $1d
                    ldx #$00
                    stx $1c
L034a               jsr S0357 ; read cmd
                    cmp #$fe ; is repeat ?
                    beq L03a8
                    jsr S0366
                    jmp L034a

; read packed byte
S0357               ldy #$00
                    lda ($1c),y
                    jsr S035f
                    rts

S035f               inc $1c
                    bne L0365
                    inc $1d
L0365               rts

; store byte to hires
S0366               sta $0808
                    jsr S0376 ; set hires addr
                    lda $0808
                    ldy #$00
                    sta ($1a),y
                    jmp L038c

; set hires address from tables to ($1A)
S0376               ldx $0801
                    lda $6f00,x
                    clc
                    adc $0810
                    sta $1b
                    lda $6e00,x
                    clc
                    adc $0800
                    sta $1a
                    rts

L038c               inc $0801
                    ldx $0801
                    cpx #$c0
                    bne L03a7
                    ldx #$00
                    stx $0801
                    inc $0800
                    ldx $0800
                    cpx #$28
                    bne L03a7
                    pla
                    pla
L03a7               rts

; process repeat bytes
L03a8               jsr S0357 ; read packed byte
                    sta $0802
                    jsr S0357 ; read packed byte
                    sta $0803
L03b4               lda $0802
                    jsr S0366
                    dec $0803
                    bne L03b4
                    jmp L034a

		.align $100 $FF
