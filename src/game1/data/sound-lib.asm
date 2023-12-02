		.namespace soundlib
		.org $0A00

L0A00               ldx #$f8
L0a02               ldy #$04
                    txa
                    pha
                    ldx soundSwitch
L0a09               lda sys.SPKR-$10,x
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
                    bne L0A00
                    ldx #$04
                    stx L0a02+1
                    rts

L0a2d               lda $034f
                    beq L0a4f
                    cmp #$0d
                    bcs L0a4f
                    asl
                    asl
                    asl
L0a39               ldy #$04
L0a3b               ldx soundSwitch
                    pha
                    lda sys.SPKR-$10,x
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
                    jsr tone
                    rts

L0a58               ldx #$60
                    ldy #$40
                    jsr tone
                    ldx #$30
                    ldy #$60
                    jsr tone
                    ldx #$10
                    ldy #$f0
                    jsr tone
                    rts

L0a6e               ldx #$90
                    ldy #$10
                    jsr tone
                    ldx #$30
                    ldy #$a0
                    jsr tone
                    rts

L0a7d               jsr S0a88
                    ldx #$d0
                    ldy #$40
                    jsr tone
                    rts

S0a88               lda #$01
L0a8a               ldy #$08
L0a8c               ldx soundSwitch
                    cmp sys.SPKR-$10,x
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
L0aa3               ldx soundSwitch
                    cmp sys.SPKR-$10,x
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
                    jsr tone
                    ldx #$20
                    ldy #$30
                    jsr tone
                    rts

L0ac5               ldx #$08
                    ldy #$e0
                    jsr tone
                    jsr L0a9f
                    ldx #$80
                    ldy #$70
                    jsr tone
                    rts

L0ad7               ldx #$18
                    ldy #$50
                    jsr tone
                    ldx #$28
                    ldy #$68
                    jsr tone
                    rts

L0ae6               tya
L0ae7               pha
                    jsr S0b51
                    tax
                    ldy #$02
                    jsr tone
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
                    jsr tone
                    ldx #$f0
                    ldy #$45
                    jsr tone
                    ldx #$d0
                    ldy #$20
                    jsr tone
                    ldx #$80
                    ldy #$18
                    jsr tone
                    rts

L0b23               jsr S0a88
                    ldx #$20
                    ldy #$9a
                    jsr tone
                    ldx #$10
                    ldy #$b0
                    jsr tone
                    jsr L0a9f
                    ldx #$80
                    ldy #$50
                    jsr tone
                    rts

L0b3f               ldx #$10
                    ldy #$d0
                    jsr tone
                    ldx #$80
                    ldy #$40
                    jsr tone
                    jsr S0a88
                    rts

S0b51               rol $4e
                    rol globals.soundCnt1
                    rol globals.sountCnt2
                    lda $4e
                    asl
                    eor $4f
                    eor globals.sountCnt2
                    rol
                    rol
                    rol
                    rol
                    rol
                    pha
                    rol $4f
                    lda $4f
                    eor globals.soundCnt1
                    sta $4e
                    pla
                    sta globals.sountCnt2
                    adc $4e
                    adc globals.soundCnt1
                    sta globals.soundCnt3
                    rts

		.align $10
		.db "soundlib"

		.align $100
