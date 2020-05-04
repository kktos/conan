                  * = 1000
L1001 = * + 1       
L1002 = * + 2       
L1000               jmp L108c
                    
L1004 = * + 1       
L1003               lda $c000
                    bpl L1003
                    jmp L102d
                    
L100b               bit $c010
                    stx $1c
                    ldx #$3e
                    stx $1d
                    ldy #$00
                    sta ($1c),y
                    lda ($22),y
                    dex
                    bne L1003
                    dec $1b
                    inc $1b
                    ldx $1d
                    cpx #$3d
                    bne L1003
                    bit $c030
                    bit $c030
L102d               jmp L108c
                    
L1030               jsr S1da1
                    rts
                    
L1034               jsr S1dbe
                    rts
                    
S1038               jsr S1ddb
                    rts
                    
L103c               jsr S1df8
                    rts
                    
L1040               jsr L1030
                    jsr L1030
                    jsr L1030
                    jsr L1030
                    jsr L1030
                    rts
                    
L1050               jsr L1034
                    jsr L1034
                    jsr L1040
                    rts
                    
L105a               jsr L1034
                    jsr L1034
                    jsr L1034
                    jsr L1034
                    jsr L1034
                    rts
                    
L106a               jsr L105a
                    jsr L1050
                    rts
                    
L1071               jsr S1038
                    jsr S1038
                    jsr L105a
                    rts
                    
S107b               txa
L107c               ldx $0380
                    pha
                    lda $c020,x
                    pla
L1084               tax
L1085               dex
                    bne L1085
                    dey
                    bne L107c
                    rts
                    
L108c               jsr L1a00
L108f               ldx #$00
                    jsr init
                    
                    ; anim conan jump / high score
                    jsr LA000
                    
L1097               jsr S1d40
                    jsr S1a11
                    jsr S18ab
                    
L10a0               jsr LA000
                    ldx #$00
                    stx $0383
                    jsr S1d7f
                    jsr S179e
                    jsr S1891
                    jsr S10d5
                    jsr S1160
                    jsr S141e
                    jsr S1593
                    jsr S1e5c
                    jsr S18fa
                    jsr S193a
                    jsr S1b63
                    jsr S1cb0
                    jsr S1d88
                    jsr S1e41
                    jmp L10a0
                    
S10d5               lda $c000
                    sta $030b
                    cmp $038b
                    beq L1154
                    cmp $038f
                    beq L1123
                    cmp $038a
                    beq L1108
                    cmp $038c
                    beq L1142
                    cmp $038d
                    beq L114b
                    cmp $0384
                    bne L10fc
                    bit $c010
L10fc               cmp $0385
                    bne L1104
                    bit $c010
L1104               jsr S1cc0
                    rts
                    
L1108               jsr S1e23
                    bit $c010
                    jmp L1097
                    
L1111               bit $c010
                    bit $c050
                    bit $c052
                    bit $c057
                    bit $c054
                    jmp L108f
                    
L1123               bit $c010
L1126               lda $c000
                    sta $030b
                    bmi L1139
                    ldx $037b
                    bpl L1126
                    lda $c061
                    bpl L1126
                    rts
                    
L1139               cmp $038f
                    bne L1123
                    bit $c010
                    rts
                    
L1142               ldx #$ff
                    stx $037b
                    bit $c010
                    rts
                    
L114b               ldx #$01
                    stx $037b
                    bit $c010
                    rts
                    
L1154               bit $c010
                    lda $0380
                    eor #$10
                    sta $0380
                    rts
                    
S1160               ldx $034f
                    beq L1168
                    jmp L198f
                    
L1168               ldx $0314
                    beq L1170
                    jmp L15ab
                    
L1170               ldx $0315
                    beq L1178
                    jmp S1381
                    
L1178               ldx $031f
                    beq L1180
                    jmp L13e5
                    
L1180               ldx $0309
                    beq L1188
                    jmp L1553
                    
L1188               ldx $0318
                    bpl L1190
                    jmp L1702
                    
L1190               jsr S11a3
                    jsr S134e
                    jsr S135d
                    jsr S1233
                    jsr S129c
                    jsr S12b4
                    rts
                    
S11a3               ldx $0378
                    bne L11fd
                    ldx $030b
                    bpl L11fd
                    cpx $038f
                    beq L11fd
                    cpx $0384
                    bne L11bd
                    bit $c010
                    jmp L11fe
                    
L11bd               cpx $0385
                    bne L11c8
                    bit $c010
                    jmp L1204
                    
L11c8               cpx $0386
                    bne L11d0
                    jmp L1487
                    
L11d0               cpx $0387
                    bne L11d8
                    jmp L1492
                    
L11d8               nop
                    cpx $0389
                    bne L11e4
                    bit $c010
                    jmp L16d2
                    
L11e4               cpx $0388
                    bne L11ef
                    bit $c010
                    jmp L13d0
                    
L11ef               ldx #$00
                    stx $0306
                    stx $0307
                    stx $030b
                    bit $c010
L11fd               rts
                    
L11fe               jsr S120a
                    bcc L121d
                    rts
                    
L1204               jsr S120a
                    bcc L1228
                    rts
                    
S120a               ldx $031f
                    bne L121b
                    ldx $0309
                    bne L121b
                    ldx $0314
                    bne L121b
                    clc
                    rts
                    
L121b               sec
                    rts
                    
L121d               dec $0306
                    ldx $0306
                    cpx #$fd
                    beq L1228
                    rts
                    
L1228               inc $0306
                    ldx $0306
                    cpx #$03
                    beq L121d
                    rts
                    
S1233               ldx $0309
                    beq L123f
                    ldx $0333
                    stx $0305
                    rts
                    
L123f               ldx $031f
                    bne L128b
                    lda $0306
                    beq L1275
                    ror a
                    bcs L1256
                    lda $030a
                    cmp #$03
                    bne L1256
                    dec $030a
L1256               lda $030a
                    cmp #$01
                    bne L1262
                    ldx #$04
                    stx $030a
L1262               lda $030a
                    ldy $0308
                    bmi L126d
                    clc
                    adc #$04
L126d               tax
                    lda $030b,x
                    sta $0305
                    rts
                    
L1275               ldx #$04
                    stx $030a
                    ldy $0308
                    bmi L1285
                    ldx #$0c
                    stx $0305
                    rts
                    
L1285               ldx #$0b
                    stx $0305
                    rts
                    
L128b               ldx $0308
                    bmi L1296
                    ldx #$10
                    stx $0305
                    rts
                    
L1296               ldx #$0e
                    stx $0305
                    rts
                    
S129c               lda $0300
                    clc
                    adc $0306
                    sta $0303
                    lda $0301
                    clc
                    adc $0307
                    sta $0304
                    jsr S1681
                    rts
                    
S12b4               lda $0306
                    bne L12d0
                    lda $0307
                    bne L12d0
                    lda $0309
                    bne L12cf
                    lda $0302
                    cmp #$0d
                    bcs L12d0
                    cmp $0305
                    bne L12d0
L12cf               rts
                    
L12d0               lda $0302
                    ldx $0300
                    ldy $0301
                    jsr LB300
                    ldx #$00
                    stx $b3f6
                    lda $0305
                    sta $0302
                    ldx $0303
                    stx $0300
                    ldy $0304
                    sty $0301
                    jsr LB300
                    rts
                    
S12f7               ldx $037e
                    beq L1312
                    stx $0300
                    stx $0303
                    ldy #$00
                    sty $037e
                    ldy #$e0
                    sty $0301
                    sty $0304
                    jmp L1324
                    
L1312               ldx $ad80
                    stx $0300
                    stx $0303
                    ldy $ad81
                    sty $0301
                    sty $0304
L1324               lda $ad83
                    sta $0308
                    lda $ad82
                    sta $0302
                    sta $0305
                    jsr LB300
                    ldx #$00
                    stx $0306
                    stx $0307
                    stx $0309
                    stx $031f
                    stx $031e
                    stx $0314
                    stx $0315
                    rts
                    
S134e               ldx $0306
                    cpx #$01
                    beq L1359
                    cpx #$ff
                    bne L135c
L1359               stx $0308
L135c               rts
                    
S135d               dec $030a
                    bne L1367
                    ldx #$04
                    stx $030a
L1367               lda $030a
                    asl a
                    asl a
                    tax
                    lda $0306
                    beq L1377
                    ldy #$10
                    jsr S107b
L1377               rts
                    
L1378               sty $0377
                    lda #$90
                    jsr $fca8
                    rts
                    
S1381               jsr S129c
                    ldx $0314
                    beq L13a3
                    jsr S15ca
                    bcs L13a3
                    ldx $0308
                    bmi L139b
                    ldx #$10
                    stx $0305
                    jmp L13b5
                    
L139b               ldx #$0e
                    stx $0305
                    jmp L13b5
                    
L13a3               lda $0316
                    ldx $0308
                    bmi L13ae
                    clc
                    adc #$08
L13ae               tax
                    lda $0322,x
                    sta $0305
L13b5               jsr S12b4
                    jsr S15fe
                    jsr S1953
                    bcc L13c5
                    dec $0316
                    bne L13cf
L13c5               ldx #$00
                    stx $0315
                    ldx #$08
                    stx $0316
L13cf               rts
                    
L13d0               inc $031f
                    lda $0307
                    sec
                    sbc #$05
                    sta $0307
                    ldx #$01
                    stx $0321
                    stx $0383
                    rts
                    
L13e5               jsr S129c
                    jsr S1233
                    ldx $0321
                    bmi L13fc
                    inc $0315
                    dec $0321
                    dec $0321
                    jmp L1414
                    
L13fc               ldx #$00
                    stx $031f
                    ldx #$04
                    stx $030a
                    jsr S1953
                    bcc L1414
                    inc $0314
                    inc $0315
                    jmp S1381
                    
L1414               jsr S1953
                    jsr S12b4
                    jsr S15fe
                    rts
                    
S141e               ldx $0309
                    bne L1440
                    ldx $0314
                    bne L1433
                    ldx $0315
                    bne L1433
                    ldx $031f
                    bne L1433
                    rts
                    
L1433               inc $0307
                    ldx $0307
                    cpx #$06
                    bne L1440
                    dec $0307
L1440               rts
                    
S1441               ldx $0307
                    bmi L1485
                    ldx #$ff
                    stx $0322
L144b               inc $0322
                    ldx $0322
                    lda LAC40,x
                    beq L1485
                    lda $0303
                    cmp LAC00,x
                    bcc L144b
                    cmp LAC20,x
                    beq L1465
                    bcs L144b
L1465               lda LAC40,x
                    clc
                    adc #$03
                    cmp $0304
                    bcc L144b
                    sec
                    sbc $0307
                    sec
                    sbc #$03
                    cmp #$f8
                    bcs L1480
                    cmp $0304
                    bcs L144b
L1480               stx $0379
                    clc
                    rts
                    
L1485               sec
                    rts
                    
L1487               ldx $0309
                    beq L149d
                    ldx #$fe
                    stx $0307
                    rts
                    
L1492               ldx $0309
                    beq L14b3
                    ldx #$02
                    stx $0307
                    rts
                    
L149d               jsr S14ca
                    bcc L14b2
                    ldx $0317
                    bpl L14b2
                    ldx #$fe
                    stx $0307
                    inc $0309
                    jmp L1553
                    
L14b2               rts
                    
L14b3               jsr S14ca
                    bcc L14b2
                    ldx $0317
                    bmi L14b2
                    beq L14b2
                    ldx #$02
                    stx $0307
                    inc $0309
                    jmp L1553
                    
S14ca               ldx #$ff
                    stx $0322
L14cf               inc $0322
                    ldx $0322
                    lda LAC60,x
                    beq L1543
                    lda LACA0,x
                    tay
                    dey
                    dey
                    cpy $0300
                    beq L14f4
                    iny
                    cpy $0300
                    beq L14f4
                    iny
                    cpy $0300
                    beq L14f4
                    jmp L14cf
                    
L14f4               lda LAC60,x
                    cmp $0301
                    beq L1527
                    bcs L14cf
                    lda LAC80,x
                    cmp $0301
                    beq L1535
                    bcc L14cf
                    lda LACA0,x
                    sta $0303
                    ldx $0301
                    stx $0304
                    ldx $0302
                    stx $0305
                    jsr S12b4
                    ldx #$00
                    stx $0317
                    stx $0306
                    sec
                    rts
                    
L1527               ldx #$01
                    stx $0317
                    dex
                    stx $0306
                    stx $0307
                    sec
                    rts
                    
L1535               ldx #$ff
                    stx $0317
                    inx
                    stx $0306
                    stx $0307
                    sec
                    rts
                    
L1543               clc
                    ldx #$00
                    stx $0309
                    rts
                    
S154a               lda $0333
                    eor #$01
                    sta $0333
                    rts
                    
L1553               jsr S1575
                    jsr S1233
                    jsr S129c
                    jsr S12b4
                    jsr S14ca
                    ldx $0307
                    beq L156a
                    jsr S154a
L156a               ldx $0317
                    beq L1574
                    ldx #$00
                    stx $0309
L1574               rts
                    
S1575               ldx $030b
                    bpl L1592
                    cpx $0386
                    bne L1582
                    jmp L1487
                    
L1582               cpx $0387
                    bne L158a
                    jmp L1492
                    
L158a               ldx #$00
                    stx $0306
                    stx $0307
L1592               rts
                    
S1593               jsr S1441
                    bcc L15aa
                    ldx $031f
                    bne L15aa
                    ldx $0309
                    bne L15aa
                    ldx $0318
                    bmi L15aa
                    inc $0314
L15aa               rts
                    
L15ab               ldx $0315
                    bne L15b3
                    inc $0315
L15b3               jsr S1381
                    jsr S1441
                    bcs L15c9
                    ldx #$00
                    stx $0315
                    stx $0314
                    stx $031f
                    jsr S12b4
L15c9               rts
                    
S15ca               ldx #$ff
                    stx $0322
L15cf               inc $0322
                    ldx $0322
                    lda LAC40,x
                    beq L15fc
                    lda $0303
                    cmp LAC00,x
                    bcc L15cf
                    cmp LAC20,x
                    bcs L15cf
                    lda LAC40,x
                    clc
                    adc #$06
                    cmp $0304
                    bcc L15cf
                    sec
                    sbc #$10
                    cmp $0304
                    bcs L15cf
                    clc
                    rts
                    
L15fc               sec
                    rts
                    
S15fe               ldx $b3f6
                    beq L1637
                    ldx $031e
                    bne L1637
                    ldx $0373
                    bne L1637
                    jsr S164d
                    bcs L1637
                    jsr S1638
                    lda $0303
                    sec
                    sbc $0306
                    sta $0303
                    ldx $0302
                    stx $0305
                    jsr S12b4
                    ldx #$01
                    stx $0314
                    dex
                    stx $0307
                    stx $0306
                    inc $031e
L1637               rts
                    
S1638               lda $0300
                    sec
                    sbc $0306
                    sta $0303
                    lda $0301
                    sec
                    sbc $0307
                    sta $0304
                    rts
                    
S164d               ldx #$ff
                    stx $0322
L1652               inc $0322
                    ldx $0322
                    lda LAC60,x
                    beq L167f
                    cmp $0301
                    bcs L1652
                    lda LAC80,x
                    cmp $0301
                    bcc L1652
                    lda LACA0,x
                    sec
                    sbc #$08
                    cmp $0300
                    bcs L1652
                    clc
                    adc #$0b
                    cmp $0300
                    bcc L1652
                    sec
                    rts
                    
L167f               clc
                    rts
                    
S1681               ldx #$ff
                    stx $0322
L1686               inc $0322
                    ldx $0322
                    lda LACF0,x
                    beq L16d1
                    lda $0303
                    cmp LACC0,x
                    beq L16a1
                    tay
                    iny
                    tya
                    cmp LACC0,x
                    bne L1686
L16a1               lda LACF0,x
                    cmp $0304
                    bne L1686
                    lda LACC0,x
                    sta $0303
                    ldx $0308
                    bmi L16ba
                    dec $0303
                    jmp L16bd
                    
L16ba               inc $0303
L16bd               ldx #$00
                    stx $0306
                    stx $0307
                    jsr S1233
                    ldx $0301
                    stx $0304
                    jsr S12b4
L16d1               rts
                    
L16d2               ldx $0309
                    bne L1701
                    ldx $0314
                    bne L1701
                    ldx $0315
                    bne L1701
                    ldx $031f
                    bne L1701
                    ldx $0318
                    bne L1701
                    ldx $034d
                    bne L16f5
                    ldx playerAxeCount
                    beq L1701
L16f5               ldx #$ff
                    stx $0318
                    inx
                    stx $0319
                    jsr S1b38
L1701               rts
                    
L1702               lda $0319
                    cmp #$02
                    beq L1739
                    ldy $0308
                    bmi L1711
                    clc
                    adc #$02
L1711               tay
                    lda $0334,y
                    sta $0305
                    lda $0300
                    ldx $0319
                    dex
                    bne L1729
                    ldy $0308
                    bpl L1729
                    sec
                    sbc #$02
L1729               sta $0303
                    ldy $0301
                    sty $0304
                    jsr S12b4
                    inc $0319
                    rts
                    
L1739               ldx #$01
                    stx $0318
                    lda $0300
                    ldy $0308
                    bmi L1754
                    ldx #$03
                    stx $033a
                    clc
                    adc #$07
                    sta $031a
                    jmp L175f
                    
L1754               sec
                    sbc #$03
                    sta $031a
                    ldx #$fd
                    stx $033a
L175f               lda $0301
                    clc
                    adc #$02
                    sta $031b
                    lda #$1e
                    sta $031c
                    jsr S1807
                    ldx $0308
                    stx $031d
                    ldx #$08
                    stx $0338
                    ldx #$01
                    stx $0339
                    stx $0318
                    jsr S1233
                    lda $0300
                    ldy $0308
                    bpl L1791
                    clc
                    adc #$02
L1791               sta $0303
                    ldx $0301
                    stx $0304
                    jsr S12b4
                    rts
                    
S179e               ldx $0318
                    dex
                    bpl L17a5
                    rts
                    
L17a5               jsr S184d
                    dec $0338
                    beq L17cd
L17ad               lda $031a
                    clc
                    adc $033a
                    sta $031a
                    inc $031c
                    ldx $031c
                    cpx #$21
                    bne L17c6
                    ldx #$1e
                    stx $031c
L17c6               jsr S1807
                    jsr S182b
                    rts
                    
L17cd               inc $0338
                    ldx $0339
                    bpl L17db
                    inc $031b
                    jmp L17ad
                    
L17db               ldx $031d
                    bmi L17ed
                    dec $033a
                    ldx $033a
                    cpx #$fd
                    beq L17fa
                    jmp L17ad
                    
L17ed               inc $033a
                    ldx $033a
                    cpx #$03
                    beq L17fa
                    jmp L17ad
                    
L17fa               ldx #$08
                    stx $0338
                    ldx #$ff
                    stx $0339
                    jmp L17ad
                    
S1807               ldx $031a
                    ldy #$00
                    sty $b3f6
                    ldy $031b
                    lda $031c
                    jsr LB300
                    rts
                    
L1819               jsr S184d
                    ldx #$00
                    stx $0318
                    stx $0319
                    stx $031a
                    stx $031b
                    rts
                    
S182b               jsr S1f2d
                    ldx $b3f6
                    beq L1841
                    jsr S1b93
                    jsr S185a
                    bcs L1841
                    jsr $0a50
L183e               jmp L1819
                    
L1841               ldx $031a
                    cpx #$f0
                    bcs L184c
                    cpx #$9d
                    bcs L183e
L184c               rts
                    
S184d               ldx $031a
                    ldy $031b
                    lda $031c
                    jsr LB300
                    rts
                    
S185a               ldx #$ff
                    stx $0322
L185f               inc $0322
                    ldx $0322
                    lda LAC60,x
                    beq L188f
                    lda $031b
                    cmp LAC60,x
                    bcc L185f
                    sec
                    sbc #$10
                    cmp LAC80,x
                    bcs L185f
                    lda LACA0,x
                    sec
                    sbc #$08
                    cmp $031a
                    bcs L185f
                    clc
                    adc #$13
                    cmp $031a
                    bcc L185f
                    sec
                    rts
                    
L188f               clc
                    rts
                    
S1891               ldx $0301
                    cpx LAD88
                    bne L18a7
                    ldx $0300
                    cpx LAD87
                    beq L18a8
                    dex
                    cpx LAD87
                    beq L18a8
L18a7               rts
                    
L18a8               jsr $0a00
S18ab               ldx $037e
                    bne L18c1
                    ldx $034c
                    stx $037f
L18b6               dec $037f
                    bmi L18c1
                    jsr S1038
                    jmp L18b6
                    
L18c1               ldx $037e
                    beq L18d9
                    ldx #$07
                    stx $034c
                    jsr S197a
                    dec $034c
                    ldx #$07
                    jsr S197a
                    jmp L18e6
                    
L18d9               ldx #$07
                    jsr S197a
                    inc $034c
                    ldx #$07
                    jsr S197a
L18e6               ldx $034c
                    jsr init
                    ldx #$00
                    stx $0318
                    stx $030b
                    bit $c010
                    jmp S12f7
                    
S18fa               ldx #$ff
                    stx $0322
L18ff               inc $0322
                    ldx $0322
                    lda LAD30,x
                    beq L1925
                    jsr S1926
                    ldx $0322
                    inc LAD40,x
                    lda LAD40,x
                    cmp #$24
                    bne L191f
                    lda #$21
                    sta LAD40,x
L191f               jsr S1926
                    jmp L18ff
                    
L1925               rts
                    
S1926               lda LAD30,x
                    tay
                    lda LAD20,x
                    sta $033b
                    lda LAD40,x
                    ldx $033b
                    jsr LAE00
                    rts
                    
S193a               inc $033c
                    lda $033c
                    ror a
                    bcs L1952
                    ror a
                    bcs L1952
                    ldx LAD84
                    ldy LAD85
                    lda LAD86
                    jsr LAE00
L1952               rts
                    
S1953               jsr S1441
                    bcs L1979
                    lda LAC40,x
                    sta $0304
                    inc $0304
                    lda $0300
                    clc
                    adc $0306
                    sta $0303
                    jsr S1233
                    jsr S12b4
                    ldx #$00
                    stx $0307
                    stx $031e
L1979               rts
                    
S197a               lda $0345,x
                    tay
                    lda $033c,x
                    tax
                    tya
                    ldy #$b9
                    cmp #$00
                    bne L198b
                    lda #$0a
L198b               jsr LAE00
                    rts
                    
L198f               jsr $0a2d
                    ldx $034f
                    cpx #$08
                    bcs L19bd
                    jsr S19aa
                    inc $034f
                    ldx $034f
                    cpx #$08
                    beq L19a9
                    jsr S19aa
L19a9               rts
                    
S19aa               ldx $034f
                    lda $034f,x
                    sta $0302
                    ldx $0300
                    ldy $0301
                    jsr LB300
                    rts
                    
L19bd               inc $034f
                    ldx $034f
                    cpx #$18
                    beq L19c8
                    rts
                    
L19c8               jsr S19df
                    jsr S12f7
                    ldx #$00
                    stx $034f
                    ldy $0318
                    bpl L19db
                    stx $0318
L19db               bit $c010
                    rts
                    
S19df               ldx #$06
                    jsr S197a
                    dec playerLifeCount
                    bmi L19ef
                    ldx #$06
                    jsr S197a
                    rts
                    
L19ef               inc playerLifeCount
                    ldx #$06
                    jsr S197a
                    jsr S1e23
                    jsr S1c6b
                    jmp L108f
                    
L1a00               ldx #$09
                    stx $0322
L1a05               ldx $0322
                    jsr S197a
                    dec $0322
                    bne L1a05
                    rts
                    
S1a11               jsr L1a00
                    ldx #$00
                    stx $0346
                    stx $0347
                    stx $0348
                    stx $0349
                    stx $034a
                    stx playerAxeCount
                    stx $034c
                    inx
                    stx $034d
                    inx
                    stx playerLifeCount
                    jsr L1a00
                    rts
                    
init                stx $0381
                    lda #$00
L1a3c               dex
                    bmi init2
                    clc
                    adc #$06
                    jmp L1a3c
                    
                    ; load welcome screen
init2               sta rangeIdx
                    tay
                    ldx #$75
                    stx rwts.hibuf
                    ; T0S1-8 / M7500-7CFF
                    jsr loadRange
                    
                    ; unpack & display
                    jsr unpackToHgr
                    inc rangeIdx
                    
                    ldy rangeIdx
                    ldx #$75
                    stx rwts.hibuf
                    ; T0S9-C / M7500-78FF
                    jsr loadRange
                    inc rangeIdx
                    
                    ldy rangeIdx
                    ldx #$79
                    stx rwts.hibuf
                    ; T0SD/ M7900-79FF
                    jsr loadRange
                    inc rangeIdx
                    
                    ldy rangeIdx
                    ldx #$7a
                    stx rwts.hibuf
                    ; T0SE-T2SF / M7A00-9BFF
                    jsr loadRange
                    inc rangeIdx
                    
                    ldy rangeIdx
                    ldx #$a0
                    stx rwts.hibuf
                    ; T3S0-T3SB / MA000-ABFF
                    jsr loadRange
                    inc rangeIdx
                    
                    ldy rangeIdx
                    ldx #$ac
                    stx rwts.hibuf
                    ; T3SC / MAC00-ACFF
                    jsr loadRange
                    rts
                    
unpackToHgr         ldx #$00
                    stx $1c
                    stx $0365
                    stx $0366
                    ldx #$75
                    stx $1d
L1aa9               jsr S1ab6
                    cmp #$fe
                    beq L1b03
                    jsr S1ac5
                    jmp L1aa9
                    
S1ab6               ldy #$00
                    lda ($1c),y
                    jsr S1abe
                    rts
                    
S1abe               inc $1c
                    bne L1ac4
                    inc $1d
L1ac4               rts
                    
S1ac5               sta $0369
                    jsr S1ad5
                    lda $0369
                    ldy #$00
                    sta ($1a),y
                    jmp L1ae7
                    
S1ad5               ldx $0366
                    lda LB500,x
                    sta $1b
                    lda LB400,x
                    clc
                    adc $0365
                    sta $1a
                    rts
                    
L1ae7               inc $0366
                    ldx $0366
                    cpx #$b7
                    bne L1b02
                    ldx #$00
                    stx $0366
                    inc $0365
                    ldx $0365
                    cpx #$28
                    bne L1b02
                    pla
                    pla
L1b02               rts
                    
L1b03               jsr S1ab6
                    sta $0367
                    jsr S1ab6
                    sta $0368
L1b0f               lda $0367
                    jsr S1ac5
                    dec $0368
                    bne L1b0f
                    jmp L1aa9
                    
readSector          ldx track
                    stx rwts.trk
                    ldx sector
                    stx rwts.sec
                    ldx #$00
                    stx rwts.vol
                    stx $48
                    ldy #$e8
                    lda #$b7
                    jsr rwts
                    rts
                    
S1b38               ldx #$09
                    jsr S197a
                    dec playerAxeCount
                    bmi L1b48
                    ldx #$09
                    jsr S197a
                    rts
                    
L1b48               ldx #$09
                    stx playerAxeCount
                    jsr S197a
                    ldx $034d
                    beq L1b62
                    ldx #$08
                    jsr S197a
                    dec $034d
                    ldx #$08
                    jsr S197a
L1b62               rts
                    
S1b63               jsr S1441
                    bcs L1b69
                    rts
                    
L1b69               ldx $0300
                    cpx #$f0
                    bcs L1b7c
                    cpx #$89
                    bcc L1b92
                    ldx #$88
                    stx $0303
                    jmp L1b81
                    
L1b7c               ldx #$00
                    stx $0303
L1b81               ldx $0302
                    stx $0305
                    jsr S12b4
                    ldx #$00
                    stx $0306
                    stx $0307
L1b92               rts
                    
S1b93               ldx $034f
                    bne L1b92
                    lda $0300
                    sec
                    sbc #$05
                    cmp $031a
                    bcs L1b92
                    clc
                    adc #$0c
                    cmp $031a
                    bcc L1b92
                    lda $0301
                    sec
                    sbc #$03
                    cmp $031b
                    bcs L1b92
                    clc
                    adc #$11
                    cmp $031b
                    bcc L1b92
                    jsr S1bca
                    jsr L1819
                    jsr L0AD7
                    pla
                    pla
                    rts
                    
S1bca               ldx #$09
                    jsr S197a
                    inc playerAxeCount
                    ldx playerAxeCount
                    cpx #$0a
                    beq L1bdf
                    ldx #$09
                    jsr S197a
                    rts
                    
L1bdf               ldx #$00
                    stx playerAxeCount
                    ldx #$09
                    jsr S197a
                    ldx #$08
                    jsr S197a
                    inc $034d
                    ldx #$08
                    jsr S197a
                    rts
                    
S1bf7               jsr S1bfe
                    jsr S1c20
                    rts
                    
S1bfe               ldx #$3b
                    stx $0374
L1c03               jsr S1c11
                    inc $0374
                    ldx $0374
                    cpx #$7e
                    bne L1c03
                    rts
                    
S1c11               jsr S1c5d
                    ldy #$0c
                    lda #$00
L1c18               sta ($1a),y
                    iny
                    cpy #$1c
                    bne L1c18
                    rts
                    
S1c20               ldx #$00
                    stx $1c
                    ldx #$75
                    stx $1d
                    ldx #$41
                    stx $0374
L1c2d               jsr S1c3b
                    inc $0374
                    ldx $0374
                    cpx #$79
                    bne L1c2d
                    rts
                    
S1c3b               jsr S1c5d
                    ldy #$0d
                    sty $0375
L1c43               ldy #$00
                    lda ($1c),y
                    ldy $0375
                    sta ($1a),y
                    inc $1c
                    bne L1c52
                    inc $1d
L1c52               inc $0375
                    ldy $0375
                    cpy #$1c
                    bne L1c43
                    rts
                    
S1c5d               ldx $0374
                    lda LB400,x
                    sta $1a
                    lda LB500,x
                    sta $1b
                    rts
                    
S1c6b               jsr S1e97
                    and #$03
                    asl a
                    asl a
                    sta rwts.sec
                    lda $034c
                    clc
                    adc #$1a
                    sta rwts.trk
                    ldx #$75
                    stx rwts.hibuf
                    ldx #$00
                    stx rwts.lobuf
                    jsr S1f0d
                    jsr S1bf7
                    bit $c010
                    ldy #$60
L1c93               lda #$ff
                    jsr $fca8
                    lda $c000
                    bmi L1ca5
                    jsr S1e4e
                    bcs L1ca5
                    dey
                    bne L1c93
L1ca5               bit $c010
                    cpy #$00
                    beq L1caf
                    jmp L1097
                    
L1caf               rts
                    
S1cb0               inc $037a
                    lda $037a
                    adc $7900
                    adc $0349
                    sta $037a
L1cbf               rts
                    
S1cc0               ldx $037b
                    bpl L1cbf
                    ldx $0309
                    beq L1ccf
                    ldx #$00
                    jmp L1d01
                    
L1ccf               ldx $c061
                    bmi L1d16
                    ldx $0318
                    bne L1cde
                    ldx $c062
                    bmi L1d1d
L1cde               ldx #$fe
                    lda $037c
                    cmp #$10
                    bcc L1cf7
                    inx
                    cmp #$40
                    bcc L1cf7
                    inx
                    cmp #$c0
                    bcc L1cf7
                    inx
                    cmp #$f0
                    bcc L1cf7
                    inx
L1cf7               cpx $0306
                    beq L1d01
                    bmi L1d32
                    jmp L1d39
                    
L1d01               ldy $037d
                    cpy #$30
                    bcc L1d24
                    cpy #$d0
                    bcs L1d2b
                    cpx #$00
                    bne L1d15
                    ldx #$ff
                    stx $030b
L1d15               rts
                    
L1d16               ldx $0388
                    stx $030b
                    rts
                    
L1d1d               ldx $0389
                    stx $030b
                    rts
                    
L1d24               ldx $0386
                    stx $030b
                    rts
                    
L1d2b               ldx $0387
                    stx $030b
                    rts
                    
L1d32               ldx $0384
                    stx $030b
                    rts
                    
L1d39               ldx $0385
                    stx $030b
                    rts
                    
S1d40               bit $c010
                    ldx #$00
                    stx $034f
                    stx $031e
                    stx $031f
                    stx $0318
                    stx $0314
                    stx $0315
                    stx $0309
                    stx $0306
                    stx $0307
                    ldx $036e
                    beq L1d6f
                    ldx #$01
                    jsr S1d91
                    ldx #$00
                    stx $036e
L1d6f               ldx $036f
                    beq L1d7e
                    ldx #$02
                    jsr S1d91
                    ldx #$00
                    stx $036f
L1d7e               rts
                    
S1d7f               ldx #$00
                    jsr $fb1e
                    sty $037c
                    rts
                    
S1d88               ldx #$01
                    jsr $fb1e
                    sty $037d
                    rts
                    
S1d91               txa
                    tay
                    lda $036a,y
                    tax
                    tya
                    clc
                    adc #$26
                    ldy #$b9
                    jsr LAE00
                    rts
                    
S1da1               ldx #$05
                    jsr S197a
                    ldx #$05
                    inc $034a
                    ldy $034a
                    cpy #$0a
                    beq L1db6
                    jsr S197a
                    rts
                    
L1db6               lda #$00
                    sta $034a
                    jsr S197a
S1dbe               ldx #$04
                    jsr S197a
                    ldx #$04
                    inc $0349
                    ldy $0349
                    cpy #$0a
                    beq L1dd3
                    jsr S197a
                    rts
                    
L1dd3               lda #$00
                    sta $0349
                    jsr S197a
S1ddb               ldx #$03
                    jsr S197a
                    ldx #$03
                    inc $0348
                    ldy $0348
                    cpy #$0a
                    beq L1df0
                    jsr S197a
                    rts
                    
L1df0               lda #$00
                    sta $0348
                    jsr S197a
S1df8               ldx #$02
                    jsr S197a
                    ldx #$02
                    inc $0347
                    ldy $0347
                    cpy #$0a
                    beq L1e0d
                    jsr S197a
                    rts
                    
L1e0d               lda #$00
                    sta $0347
                    jsr S197a
                    ldx #$01
                    jsr S197a
                    inc $0346
                    ldx #$01
                    jsr S197a
                    rts
                    
S1e23               ldx #$00
L1e25               lda highScore,x
                    cmp $0346,x
                    bcc L1e35
                    bne L1e34
                    inx
                    cpx #$05
                    bne L1e25
L1e34               rts
                    
L1e35               ldx #$04
L1e37               lda $0346,x
                    sta highScore,x
                    dex
                    bpl L1e37
L1e40               rts
                    
S1e41               ldx $034c
                    cpx #$09
                    bne L1e40
                    dec $034c
                    jmp L1111
                    
S1e4e               lda $037b
                    bpl L1e5a
                    lda $c061
                    bpl L1e5a
                    sec
                    rts
                    
L1e5a               clc
L1e5b               rts
                    
S1e5c               ldx $0318
                    dex
                    bmi L1e5b
                    lda $0339
                    bpl L1e70
                    lda #$09
                    sec
                    sbc $0338
                    jmp L1e73
                    
L1e70               lda $0338
L1e73               asl a
                    asl a
                    sta $0382
L1e78               lda #$02
L1e7a               ldy $0382
                    ldx $0380
L1e80               cmp $c020,x
                    dey
                    bne L1e80
                    sec
                    sbc #$01
                    bne L1e7a
                    lda $0382
                    sec
                    sbc #$01
                    sta $0382
                    bne L1e78
                    rts
                    
S1e97               rol $4e
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
                    
loadRange           lda L0900,y
                    sta track
                    lda L0980,y
                    sta sector
                    iny
                    lda L0900,y
                    sta trackend
                    lda L0980,y
                    sta sectorend
                    ldx #$00
                    stx rwts.lobuf
                    ; check if ptrs =. exit of true
L1ee1               ldx sector
                    cpx sectorend
                    bne L1ef2
                    ldx track
                    cpx trackend
                    bne L1ef2
                    rts
                    
L1ef2               jsr readSector
                    inc rwts.hibuf
                    inc sector
                    ldx sector
                    cpx #$10
                    bne L1ee1
                    ldx #$00
                    stx sector
                    inc track
                    jmp L1ee1
                    
S1f0d               jsr S1f1e
                    inc rwts.hibuf
                    inc rwts.sec
                    ldx rwts.sec
                    cpx #$10
                    bne S1f0d
                    rts
                    
S1f1e               ldx #$00
                    stx rwts.vol
                    stx $48
                    ldy #$e8
                    lda #$b7
                    jsr rwts
L1f2c               rts
                    
S1f2d               ldx $034f
                    bne L1f2c
                    lda $0300
                    sec
                    sbc #$02
                    cmp $031a
                    bcs L1f2c
                    clc
                    adc #$04
                    cmp $031a
                    bcc L1f2c
                    lda $0301
                    sec
                    sbc #$03
                    cmp $031b
                    bcs L1f2c
                    clc
                    adc #$11
                    cmp $031b
                    bcc L1f2c
                    jsr S1bca
                    jsr L1819
                    jsr L0AD7
                    pla
                    pla
                    rts
L1f64                    
        c2 ce c5 a0 ce cf d7 c9 ce 8d a0 cc 
        c4 d8 a0 a4 b3 b0 b0 8d a0 c3 d0 d8 a0 a4 c1 c4 
        b8 b7 8d a0 c2 c5 d1 a0 d7 c9 ce cc c5 d6 8d a0 
        c4 c5 d8 8d a0 c3 d0 d8 a0 a4 c1 c4 b8 b7 8d a0 
        c2 c5 d1 a0 d7 c9 ce cc c5 d6 8d ce cf d7 c9 ce 
        a0 d2 d4 d3 8d d7 c9 ce cc c5 d6 a0 ca d3 d2 a0 
        d7 c9 ce d3 cf d5 8d cc c5 d6 c5 cc a0 cc c4 d8 
        a0 a4 b3 b7 c5 8d a0 c2 ce c5 a0 c5 ce c4 c2 cf 
        ce d5 d3 8d a0 cc c4 d8 a0 a4 b3 b4 c3 8d a0 d3 
        d4 d8 a0 a4 b3 b7 c6 8d c2 cf ce d5 d3 cc cf a0 

2000              .END
