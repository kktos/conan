La000               jsr Sa017
                    lda #$80
                    jsr $fca8
                    ldx $7902
                    bne La016
                    jsr Sa0e6

                    jsr Sa09b
                    jsr Sa1b0
La016               rts
                    
Sa017               ldx $7902
                    bne La05c
                    ldx $7900
                    lda batXposTbl,x
                    cmp $a601,x
                    bne La03b
                    lda batYposTbl,x
                    cmp $a701,x
                    bne La03b
                    lda batSpriteTbl,x
                    cmp $a801,x
                    bne La03b
                    inc $7900
                    rts
                    
La03b               jsr Sa045
                    inc $7900
                    jsr Sa045
                    rts
                    
Sa045               ldx $7900
                    lda batYposTbl,x
                    tay
                    lda batXposTbl,x
                    sta $7901
                    lda batSpriteTbl,x
                    ldx $7901
                    jsr $b300
                    rts
                    
La05c               bmi La016
                    ldx $790a
                    bne La079
                    jsr Sa13a
                    inc $7904
                    inc $7904
                    inc $7904
                    jsr Sa14c
                    jsr Sa13a
                    jsr Sa165
                    rts
                    
La079               dec $790b
                    bmi La07f
                    rts
                    
La07f               jsr Sa13a
                    ldx #$06
                    stx $790b
                    inc $7905
                    ldx $7905
                    cpx #$4a
                    beq La095
                    jsr Sa13a
                    rts
                    
La095               ldx #$ff
                    stx $7902
                    rts
                    
Sa09b               ldx $7900
                    lda spriteX
                    sec
                    sbc #$06
                    cmp batXposTbl,x
                    bcs La0e5
                    clc
                    adc #$0c
                    cmp batXposTbl,x
                    bcc La0e5
                    lda spriteY
                    sec
                    sbc #$08
                    cmp batYposTbl,x
                    bcs La0e5
                    clc
                    adc #$13
                    cmp batYposTbl,x
                    bcc La0e5

                    ldx playerDeadAnimIdx
                    bne La0e5

                    ldx #$01
                    stx playerDeadAnimIdx

                    ldx spriteX
                    ldy spriteY
                    lda spriteID
                    jsr $b300 ; clear player current sprite

                    ldx spriteX
                    ldy spriteY
                    lda #$19
                    jsr $b300 ; player death sprite 1st frame

La0e5               rts
                    
Sa0e6               ldx $0318
                    beq La0e5
                    ldx $7900
                    lda $031a
                    sec
                    sbc #$0c
                    cmp batXposTbl,x
                    bcs La139
                    clc
                    adc #$10
                    cmp batXposTbl,x
                    bcc La139
                    lda $031b
                    sec
                    sbc #$0d
                    cmp batYposTbl,x
                    bcs La139
                    clc
                    adc #$13
                    cmp batYposTbl,x
                    bcc La139

                    ldx #$01
                    stx $7902
                    ldx $7900
                    lda batXposTbl,x
                    sta $7903
                    lda batYposTbl,x
                    sta $7904
                    lda batSpriteTbl,x
                    sta $7905
                    ldx #$01
                    stx $7909
                    jsr $106a
                    
                    jsr $0a58

La139               rts
                    
Sa13a               ldx #$00
                    stx $b3f6
                    ldx $7903
                    ldy $7904
                    lda $7905
                    jsr $b300
                    rts
                    
Sa14c               ldx $7909
                    lda $7905,x
                    sta $7905
                    inc $7909
                    ldx $7909
                    cpx #$04
                    bne La164
                    ldx #$01
                    stx $7909
La164               rts
                    
Sa165               ldx #$ff
La167               inx
                    lda $ac40,x
                    beq La1af
                    clc
                    adc #$08
                    cmp $7904
                    bcs La167

                    clc
                    adc #$08
                    cmp $7904
                    bcc La167

                    lda $ac00,x
                    cmp $7903
                    bcs La167

                    lda $ac20,x
                    cmp $7903
                    bcc La167

                    stx $790c
                    jsr Sa13a
                    ldx #$08
                    stx $790a
                    stx $790b
                    ldx $790c
                    lda $ac40,x
                    clc
                    adc #$0d
                    sta $7904
                    ldx #$47
                    stx $7905
                    jsr Sa13a
La1af               rts
                    
Sa1b0               ldx spriteX
                    cpx #$7a
                    bcc La1d1
                    ldx $0309
                    beq La1d1
                    ldx #$06
                    jsr Sa1d2
                    inc $034b
                    ldx #$06
                    jsr Sa1d2
                    ldx #$60
                    stx Sa1b0
                    jsr $0b23
La1d1               rts
                    
Sa1d2               lda $0345,x
                    tay
                    lda $033c,x
                    tax
                    tya
                    ldy #$b9
                    cmp #$00
                    bne La1e3
                    lda #$0a
La1e3               jsr $ae00
                    rts