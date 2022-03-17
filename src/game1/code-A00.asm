L0a00               ldx #$f8
L0a02               ldy #$04
                    txa
                    pha
                    ldx $0380
L0a09               lda $c020,x
                    dey
                    bne L0a09
                    pla
                    tax
                    tay
L0a12               dey
                    bne L0a12
                    inx
                    cpx #$f8
                    bne L0a02
                    inc L0a02+1
                    inc L0a02+1
                    ldx L0a02+1
                    cpx #$10
                    bne L0a00
                    ldx #$04
                    stx L0a02+1
                    rts

L0a2d               lda $034f
                    beq L0a4f
                    cmp #$0d
                    bcs L0a4f
                    asl a
                    asl a
                    asl a
L0a39               ldy #$04
L0a3b               ldx $0380
                    pha
                    lda $c020,x
                    pla
                    tax
L0a44               dex
                    bne L0a44
                    dey
                    bne L0a3b
                    sec
                    sbc #$04
                    bcs L0a39
L0a4f               rts

L0a50               ldx #$08
                    ldy #$70
                    jsr $107b
                    rts

L0a58               ldx #$60
                    ldy #$40
                    jsr $107b
                    ldx #$30
                    ldy #$60
                    jsr $107b
                    ldx #$10
                    ldy #$f0
                    jsr $107b
                    rts

L0a6e               ldx #$90
                    ldy #$10
                    jsr $107b
                    ldx #$30
                    ldy #$a0
                    jsr $107b
                    rts

L0a7d               jsr S0a88
                    ldx #$d0
                    ldy #$40
                    jsr $107b
                    rts

S0a88               lda #$01
L0a8a               ldy #$08
L0a8c               ldx $0380
                    cmp $c020,x
                    tax
L0a93               dex
                    bne L0a93
                    dey
                    bne L0a8c
                    clc
                    adc #$09
                    bpl L0a8a
                    rts

L0a9f               lda #$7f
L0aa1               ldy #$08
L0aa3               ldx $0380
                    cmp $c020,x
                    tax
L0aaa               dex
                    bne L0aaa
                    dey
                    bne L0aa3
                    sec
                    sbc #$09
                    bpl L0aa1
                    rts

L0ab6               ldx #$05
                    ldy #$50
                    jsr $107b
                    ldx #$20
                    ldy #$30
                    jsr $107b
                    rts

L0ac5               ldx #$08
                    ldy #$e0
                    jsr $107b
                    jsr L0a9f
                    ldx #$80
                    ldy #$70
                    jsr $107b
                    rts

L0ad7               ldx #$18
                    ldy #$50
                    jsr $107b
                    ldx #$28
                    ldy #$68
                    jsr $107b
                    rts

L0ae6               tya
L0ae7               pha
                    jsr S0b51
                    tax
                    ldy #$02
                    jsr $107b
                    pla
                    sec
                    sbc #$01
                    bpl L0ae7
                    rts

L0af8               jsr L0a9f
                    nop
                    nop
                    nop
                    nop
                    nop
                    nop
                    nop
                    jsr S0a88
                    rts

L0b06               ldx #$03
                    ldy #$70
                    jsr $107b
                    ldx #$f0
                    ldy #$45
                    jsr $107b
                    ldx #$d0
                    ldy #$20
                    jsr $107b
                    ldx #$80
                    ldy #$18
                    jsr $107b
                    rts

L0b23               jsr S0a88
                    ldx #$20
                    ldy #$9a
                    jsr $107b
                    ldx #$10
                    ldy #$b0
                    jsr $107b
                    jsr L0a9f
                    ldx #$80
                    ldy #$50
                    jsr $107b
                    rts

L0b3f               ldx #$10
                    ldy #$d0
                    jsr $107b
                    ldx #$80
                    ldy #$40
                    jsr $107b
                    jsr S0a88
                    rts

S0b51               rol $4e
                    rol $037a
                    rol $0371
                    lda $4e
                    asl a
                    eor $4f
                    eor $0371
                    rol a
                    rol a
                    rol a
                    rol a
                    rol a
                    pha
                    rol $4f
                    lda $4f
                    eor $037a
                    sta $4e
                    pla
                    sta $0371
                    adc $4e
                    adc $037a
                    sta $0372
                    rts
