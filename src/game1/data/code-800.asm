

LAC00		=	$AC00
LAC20		=	$AC20
LAC40		=	$AC40

                    .db $07
                    .db $03
L0802               sec
                    rts

L0804               ldx #$ff
                    stx L0317
                    inx
                    stx playerXspeed
                    stx playerYspeed
                    sec
                    rts

L0812               clc
                    ldx #$00
                    stx L0309
                    rts

L0819               lda L0333
                    eor #$01
                    sta L0333
                    rts

L0822               jsr $1544
                    jsr $122f
                    jsr $1295
                    jsr $12ad
                    jsr $1499
                    ldx playerYspeed
                    beq L0839
                    jsr $1519
L0839               ldx L0317
                    beq L0843
                    ldx #$00
                    stx L0309
L0843               rts

L0844               ldx keypressed
                    bpl L085f
                    cpx #$c9
                    bne L0850
                    jmp $145b

L0850               cpx #$cb
                    bne L0857
                    jmp $1466

L0857               ldx #$00
                    stx playerXspeed
                    stx playerYspeed
L085f               rts

L0860               jsr $1417
                    bcc L0872
                    ldx isPlayerJumping
                    bne L0872
                    ldx L0309
                    bne L0872
                    inc L0314
L0872               rts

L0873               ldx L0315
                    bne L087b
                    inc L0315
L087b               jsr $135e
                    jsr $1417
                    bcs L0891
                    ldx #$00
                    stx L0315
                    stx L0314
                    stx isPlayerJumping
                    jsr $12ad
L0891               rts

L0892               ldx #$ff
                    stx L0322
L0897               inc L0322
                    ldx L0322
                    lda LAC40,x
                    beq L08c4
                    lda spriteXnew
                    cmp LAC00,x
                    bcc L0897
                    cmp LAC20,x
                    bcs L0897
                    lda LAC40,x
                    clc
                    adc #$06
                    cmp spriteYNew
                    bcc L0897
                    sec
                    sbc #$10
                    cmp spriteYNew
                    bcs L0897
                    clc
                    rts

L08c4               sec
                    rts

L08c6               ldx $b3f6
                    beq L08ff
                    ldx L031E
                    bne L08ff
                    ldx L0373
                    bne L08ff
                    jsr $1615
                    bcs L08ff
                    jsr $1600
                    lda spriteXnew
                    sec
                    sbc playerXspeed
                    sta spriteXnew
                    ldx spriteID
                    stx spriteIDNew
                    jsr $12ad
                    ldx #$01
                    stx L0314
                    dex
                    stx playerYspeed
                    stx playerXspeed
                    inc L031E
L08ff               rts
