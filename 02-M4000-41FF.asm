                    .org $B700

L4000               ldx #$02
                    stx rwts.hibuf
                    ldx #$01
                    stx rwts.trk
                    stx rwts.cmd
                    dex
                    stx rwts.sec
                    stx $48
                    stx rwts.vol
                    ldy #$e8
                    lda #$b7
                    jsr rwts
                    inc rwts.sec
                    inc rwts.hibuf
                    ldx #$00
                    stx $48
                    ldy #$e8
                    lda #$b7
                    jsr rwts
                    jmp $0200
                    
L4031               lda #$00
                    sta rwts.cmd
                    lda #$10
                    sta rwts.trk
                    lda #$b7
                    ldy #$e8
                    jsr rwts
                    lda $c089,x
                    lda #$01
                    sta rwts.cmd
                    ldy #$ff
                    sty $b7ab
L404f               inc $b7ab
                    lda #$00
                    sta $3e
                    sta $3f
                    sta $48
L405a               ldy #$04
                    dec $3e
                    bne L4064
                    dec $3f
                    beq L4094
L4064               lda $c08c,x
                    nop
                    bpl L4064
                    cmp $b7a5,y
                    bne L405a
                    dey
                    bpl L4064
                    ldy #$08
L4074               lda $c08c,x
                    sta $2c
                    bpl L4074
                    dey
                    bne L4074
                    jsr $b7ac
                    ldy $b7ab
                    bne L408b
                    sta $b7aa
                    beq L404f
L408b               cmp $b7aa
                    bne L409f
                    cpy #$18
                    bne L404f
L4094               tsx
                    lda #$be
                    sta $0102,x
                    lda #$ae
                    jmp $bfc8
                    
L409f               ldy $c088,x
                    jmp LA000
                    
L40a5               ad 
                    bd ba 
L40a8               b7 
L40a9               d5 
                    00 
                    00 
                    
L40ac               lda $c08c,x
                    nop
                    bpl L40ac
                    rts
                    
L40b3               df 
L40b4               rts
                    
L40b5               php
                    sei
L40b7               jsr $bd00
                    bcs L40bf
                    plp
                    clc
                    rts
                    
L40bf               plp
                    sec
                    rts
                    
L40c2               lda $b5bc
                    sta rwts.hibuf
                    lda #$00
                    sta rwts.lobuf
                    lda $b5f9
                    eor #$ff
                    sta rwts.vol
                    rts
                    
L40d6               lda #$00
                    tay
L40d9               sta ($42),y
                    iny
                    bne L40d9
                    rts

                    .hex                    
                    00 
                    1b 02 0a 1b e8 b7 00 b6 01 60 01 fe 00 01 fb b7 
                    00 b7 00 00 02 03 fe 60 01 00 00 00 01 ef d8 00 
                    .end

;
; relocate MEM[4000-40FF] to MEM[B700-B7FF]
;

                    .org $4100

L4100               ldy #$00
L4102               lda L4000,y
                    sta $b700,y
                    iny
                    bne L4102
                    pla
                    tax
                    lda $c089,x
                    jmp $b700

                    .hex                                       
                             08 00 80 a8 0c 00 82 40 7f 1f 1f 00 85 
                    18 00 64 00 18 01 02 00 82 0c 00 06 08 00 8a 8a 
                    00 07 7e 60 70 00 7f 1f 0f a8 05 00 84 60 0c 00 
                    62 18 01 0c 88 10 78 7f 00 40 46 18 06 0c 06 00 
                    8a 78 0f 1e 3c 7b 1b 7c 0f 60 6e 0f 08 00 81 8a 
                    0f 01 00 86 07 1f 40 3c 43 01 a8 0c 00 82 60 7f 
                    3f 20 00 8a 8a 60 1e 07 00 40 0e 7e 07 03 a8 1f 
                    00 84 40 09 12 44 24 21 00 87 60 3c 00 4e 47 07 
                    70 0f 5b 00 80 60 02 00 81 0c 03 1f 00 0a aa 30 
                    00 80 8a 08 00 80 a8 05 00 80 70 01 00 81 07 01 
                    01 00 82 60 7f 3f 1f 00 85 18 00 06 00 18 01 02 
                    00 82 06 00 06 08 00 8a 8a 60 1e 03 00 40 00 7e 
                    0f 03 a8 05 00 8f 60 0c 00 42 18 0c 06 10 00 7f 
                    00 40 26 30 06 0c 1a 00 81 8a 0f 01 00 86 07 3e 
                    60 3c 03 01 a8 0c 00 82 60 7f 3f 20 00 8a 8a 00
                    .end
