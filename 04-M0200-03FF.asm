                  * = 0200

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
                    dec rwts.hibuf
                    dec rwts.sec
                    bpl readTrack
                    ldx #$0f
                    stx rwts.sec
                    rts
                    
S0235               jsr readSector
                    dec rwts.hibuf
                    dec rwts.sec
                    bne S0235
                    ldx #$0f
                    stx rwts.sec
                    rts
                    
readSector          ldx #$00
                    stx $48
                    stx rwts.vol
                    ldy #$e8
                    lda #$b7
                    jmp rwts
                    
L0254               jsr S02af

                    ldx #$00
L0259               lda $1000,x
                    sta $0300,x
                    inx
                    bne L0259

; load disk[9000-9FFF] to MEM[7000-7FFF]
                    ldx #$0f
                    stx rwts.sec
                    ldx #$7f
                    stx rwts.hibuf
                    ldx #$09
                    stx rwts.trk
                    jsr readTrack

; load disk[8000-8FFF] to MEM[6000-6FFF]
                    dec rwts.trk
                    jsr readTrack

; load disk[7000-7FFF] to MEM[5000-5FFF]
                    dec rwts.trk
                    jsr readTrack

; load disk[6000-6FFF] to MEM[4000-4FFF]
                    dec rwts.trk
                    jsr readTrack

; load disk[5000-5FFF] to MEM[1000-1FFF]
                    dec rwts.trk
                    ldx #$1f
                    stx rwts.hibuf
                    jsr readTrack

; load disk[4000-4CFF] to MEM[0300-0FFF]
                    dec rwts.trk
                    ldx #$0c
                    stx rwts.sec
                    jsr S0235

; load disk[3000-3FFF] to MEM[A700-B6FF]
                    ldx #$b6
                    stx rwts.hibuf
                    ldx #$03
                    stx rwts.trk
                    jsr readTrack

                    jsr $89db
                    jmp $1000

; clear hires1		            
S02af               ldy #$00
                    sty $1a
                    sty $b7f0
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

; load disk[A000-AFFF] to MEM[6000-6FFF]
; first screen
                    ldx #$0f
                    stx rwts.sec
                    ldx #$0a
                    stx rwts.trk
                    ldx #$6f
                    stx rwts.hibuf
                    jsr readTrack

; unpack to hires
                    ldx $b7e9
                    lda $c089,x
                    jsr S033a
                    ldx #$68
                    stx $0343
                    ldx #$20
                    stx $0810
                    jsr S033a

; load disk[F000-FFFF] to MEM[A000-AFFF]
                    ldx #$0f
                    stx rwts.trk
                    ldx #$af
                    stx rwts.hibuf
                    jsr readTrack

; load disk[E000-EFFF] to MEM[9000-9FFF]
                    dec rwts.trk
                    jsr readTrack

; load disk[D000-DFFF] to MEM[8000-8FFF]
                    dec rwts.trk
                    jsr readTrack

; load disk[C000-CFFF] to MEM[7000-7FFF]
                    dec rwts.trk
                    jsr readTrack

; load disk[B000-BFFF] to MEM[6000-6FFF]
                    dec rwts.trk
                    jsr readTrack

; load disk[4000-40FF] to MEM[1000-10FF]
                    ldx #$10
                    stx rwts.hibuf
                    ldx #$04
                    stx rwts.trk
                    ldx #$00
                    stx rwts.sec
                    jsr readSector

                    bit $c010
                    jsr $8800 ; splash screens with anim
                    rts
                    
S033a               ldx #$00
                    stx $0800
                    stx $0801
                    ldx #$60
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

03C2   FF         ???
03C3   FF         ???
03C4   FF         ???
03C5   FF         ???
03C6   FF         ???
03C7   FF         ???
03C8   FF         ???
03C9   FF         ???
03CA   FF         ???
03CB   FF         ???
03CC   FF         ???
03CD   FF         ???
03CE   FF         ???
03CF   FF         ???
03D0   FF         ???
03D1   FF         ???
03D2   FF         ???
03D3   FF         ???
03D4   FF         ???
03D5   FF         ???
03D6   FF         ???
03D7   FF         ???
03D8   FF         ???
03D9   FF         ???
03DA   FF         ???
03DB   FF         ???
03DC   FF         ???
03DD   FF         ???
03DE   FF         ???
03DF   FF         ???
03E0   FF         ???
03E1   FF         ???
03E2   FF         ???
03E3   FF         ???
03E4   FF         ???
03E5   FF         ???
03E6   FF         ???
03E7   FF         ???
03E8   FF         ???
03E9   FF         ???
03EA   FF         ???
03EB   FF         ???
03EC   FF         ???
03ED   FF         ???
03EE   FF         ???
03EF   FF         ???
03F0   FF         ???
03F1   FF         ???
03F2   FF         ???
03F3   FF         ???
03F4   FF         ???
03F5   FF         ???
03F6   FF         ???
03F7   FF         ???
03F8   FF         ???
03F9   FF         ???
03FA   FF         ???
03FB   FF         ???
03FC   FF         ???
03FD   FF         ???
03FE   FF         ???
03FF   FF         ???
0400              .END
