

LAC00		=	$AC00
LAC20		=	$AC20
LAC40		=	$AC40

                    .db $07
                    .db $03
L0802               sec
                    rts

L0804               ldx #$ff
                    stx globals::L0317
                    inx
                    stx globals::playerXspeed
                    stx globals::playerYspeed
                    sec
                    rts

L0812               clc
                    ldx #$00
                    stx globals::L0309
                    rts

L0819               lda globals::L0333
                    eor #$01
                    sta globals::L0333
                    rts

L0822               jsr $1544
                    jsr $122f
                    jsr $1295
                    jsr $12ad
                    jsr $1499
                    ldx globals::playerYspeed
                    beq L0839
                    jsr $1519
L0839               ldx globals::L0317
                    beq L0843
                    ldx #$00
                    stx globals::L0309
L0843               rts

L0844               ldx globals::keypressed
                    bpl L085f
                    cpx #$c9
                    bne L0850
                    jmp $145b

L0850               cpx #$cb
                    bne L0857
                    jmp $1466

L0857               ldx #$00
                    stx globals::playerXspeed
                    stx globals::playerYspeed
L085f               rts

L0860               jsr $1417
                    bcc L0872
                    ldx globals::isPlayerJumping
                    bne L0872
                    ldx globals::L0309
                    bne L0872
                    inc globals::L0314
L0872               rts

L0873               ldx globals::L0315
                    bne L087b
                    inc globals::L0315
L087b               jsr $135e
                    jsr $1417
                    bcs L0891
                    ldx #$00
                    stx globals::L0315
                    stx globals::L0314
                    stx globals::isPlayerJumping
                    jsr $12ad
L0891               rts

L0892               ldx #$ff
                    stx globals::L0322
L0897               inc globals::L0322
                    ldx globals::L0322
                    lda LAC40,x
                    beq L08c4
                    lda globals::spriteXnew
                    cmp LAC00,x
                    bcc L0897
                    cmp LAC20,x
                    bcs L0897
                    lda LAC40,x
                    clc
                    adc #$06
                    cmp globals::spriteYNew
                    bcc L0897
                    sec
                    sbc #$10
                    cmp globals::spriteYNew
                    bcs L0897
                    clc
                    rts

L08c4               sec
                    rts

L08c6               ldx $b3f6
                    beq L08ff
                    ldx globals::L031E
                    bne L08ff
                    ldx globals::L0373
                    bne L08ff
                    jsr $1615
                    bcs L08ff
                    jsr $1600
                    lda globals::spriteXnew
                    sec
                    sbc globals::playerXspeed
                    sta globals::spriteXnew
                    ldx globals::spriteID
                    stx globals::spriteIDNew
                    jsr $12ad
                    ldx #$01
                    stx globals::L0314
                    dex
                    stx globals::playerYspeed
                    stx globals::playerXspeed
                    inc globals::L031E
L08ff               rts
