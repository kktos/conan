La000               jmp La0b9

Sa003               sty $b3f0
                    tay
                    lda $b5ff,y
                    sta $1c
                    lda $b67f,y
                    sta $1d
                    ldy #$00
                    sty $b3f7
                    lda ($1c),y
                    sta $b3f1
                    sta $b3f3
                    iny
                    lda ($1c),y
                    sta $b3f4
                    stx $b3f5
                    bpl La047
                    inc $b3f7
                    and #$7f
                    sta $b3f4
                    lda LB200,x
                    asl
                    clc
                    adc #$02
                    tay
                    lda ($1c),y
                    sta mask+1
                    iny
                    lda ($1c),y
                    sta mask+2
                    jmp La05a

La047               lda LAF00,x
                    asl
                    clc
                    adc #$02
                    tay
                    lda ($1c),y
                    sta mask+1
                    iny
                    lda ($1c),y
                    sta mask+2

La05a               ldy $b3f0
                    lda hgrLo,y
                    sta $1c
                    lda hgrHi,y
                    sta $1d
                    ldx $b3f5
                    ldy $b3f7
                    beq La076
                    lda LB000,x
                    tay
                    jmp La07a

La076               lda $b100,x
                    tay
La07a               cpy #$28
                    bcs La093
                    lda ($1c),y
                    tax
mask                lda $ffff
                    cmp ($1c),y
                    beq La08f
                    cpx #$00
                    beq La08f
                    jmp La093

La08f               eor ($1c),y
                    sta ($1c),y
La093               inc mask+1
                    bne La09b
                    inc mask+2
La09b               iny
                    cpy #$4a
                    bne La0a2
                    ldy #$00
La0a2               dec $b3f1
                    bne La07a
                    ldx $b3f3
                    stx $b3f1
                    dec $b3f4
                    beq La0b8
                    inc $b3f0
                    jmp La05a

La0b8               rts

La0b9               ldx $034f
                    bne La0c1
                    jsr Sa155
La0c1               jsr Sa0d9
                    jsr Sa2b2
                    jsr Sa111
                    jsr Sa1af
                    jsr Sa1f3
                    jsr Sa215
                    lda #$80
                    jsr $fca8
                    rts

Sa0d9               ldx $7900
                    bne La110
                    ldx spriteX
                    cpx #$82
                    bcc La110
                    cpx #$d0
                    bcs La110
                    ldx spriteY
                    cpx #$98
                    bcc La110
                    cpx #$c0
                    bcs La110
                    ldx $036e
                    bne La110
                    inc $036e
                    ldx #$01
                    jsr Sa145
                    ldx #$85
                    ldy #$9f
                    lda #$27
                    jsr $ae00
                    jsr $1038
                    jsr $0a6e
La110               rts

Sa111               ldx $036e
                    beq La110
                    ldx spriteX
                    cpx #$2e
                    bcs La144
                    ldx spriteY
                    cpx #$7b
                    bcc La144
                    cpx #$8c
                    bcs La144
                    ldx #$01
                    stx $7900
                    jsr Sa145
                    ldx #$00
                    stx $036e
                    ldx #$27
                    ldy #$7b
                    lda #$2a
                    jsr $ae00
                    jsr $1071
                    jsr $0a7d
La144               rts

Sa145               txa
                    tay
                    lda $036a,y
                    tax
                    tya
                    clc
                    adc #$26
                    ldy #$b9
                    jsr $ae00
                    rts

Sa155               ldx $034f
                    bne La165
                    ldx spriteY
                    cpx #$a8
                    bcc La165
                    cpx #$f0
                    bcc La166
La165               rts

La166               ldx spriteX
                    cpx #$50
                    bcc playerIsDead

                    ldx #$08
                    stx $034f

                    ldx spriteX
                    stx $7902
                    ldy spriteY
                    lda spriteID
                    jsr $b300

                    inc $7901
                    ldx #$01
                    stx $7903
                    ldx #$41
                    stx $7904
                    jsr Sa1e7
                    rts

;A192
playerIsDead        ldx #$01
                    stx $034f

                    ldx spriteX
                    ldy spriteY
                    lda spriteID
                    jsr $b300 ; clear player current sprite

                    ldx spriteX
                    ldy spriteY
                    lda #$19
                    jsr $b300 ; player death sprite 1st frame

                    rts

Sa1af               ldx $7900
                    bne La1bb
                    ldx spriteX
                    cpx #$2c
                    bcc La1bc
La1bb               rts

La1bc               ldx spriteX
                    ldy spriteY
                    lda spriteID
                    jsr $b300
                    lda spriteX
                    sec
                    sbc $0306
                    sta spriteX
                    ldx #$00
                    stx $0306
                    stx $0307
                    ldx spriteX
                    ldy spriteY
                    lda spriteID
                    jsr $b300
La1e6               rts

Sa1e7               ldx $7902
                    ldy #$a2
                    lda $7904
                    jsr Sa003
                    rts

Sa1f3               ldx $7901
                    beq La1e6
                    jsr Sa1e7
                    ldx $7903
                    cpx #$09
                    beq La20f
                    lda $7907,x
                    sta $7904
                    jsr Sa1e7
                    inc $7903
                    rts

La20f               ldx #$00
                    stx $7901
                    rts

Sa215               jsr Sa264
                    ldx $7907
                    beq La220
                    jsr Sa257
La220               ldx $7905
                    ldy #$01
                    lda #$45
                    jsr Sa003
                    inc $7905
                    ldx $7905
                    ldy #$01
                    lda #$45
                    jsr Sa003
                    ldx $7906
                    ldy #$1a
                    lda #$46
                    jsr Sa003
                    inc $7906
                    ldx $7906
                    ldy #$1a
                    lda #$46
                    jsr Sa003
                    ldx $7907
                    beq La256
                    jsr Sa257
La256               rts

Sa257               ldx spriteX
                    ldy spriteY
                    lda spriteID
                    jsr $b300
                    rts

Sa264               ldx spriteY
                    cpx #$ef
                    bcs La272
                    cpx #$1a
                    bcc La272
                    jmp La288

La272               lda $7905
                    sec
                    sbc #$0a
                    cmp spriteX
                    bcs La288
                    clc
                    adc #$22
                    cmp spriteX
                    bcc La288
                    jmp La2a6

La288               lda spriteY
                    cmp #$2b
                    bcs La2ac
                    cmp #$0e
                    bcc La2ac
                    lda $7906
                    sec
                    sbc #$09
                    cmp spriteX
                    bcs La2ac
                    clc
                    adc #$1e
                    cmp spriteX
                    bcc La2ac
La2a6               ldx #$04
                    stx $7907
                    rts

La2ac               ldx #$00
                    stx $7907
                    rts

Sa2b2               ldx $7910
                    lda La400,x
                    cmp La401,x
                    bne La2d1
                    lda La500,x
                    cmp La501,x
                    bne La2d1
                    lda La300,x
                    cmp La301,x
                    bne La2d1
                    inc $7910
                    rts

La2d1               jsr Sa2db
                    inc $7910
                    jsr Sa2db
                    rts

Sa2db               ldx $7910
                    lda La400,x
                    tay
                    lda La500,x
                    pha
                    lda La300,x
                    tax
                    pla
                    jsr $ae00
                    rts

                                                                 00
                    00 00 00 00 40 00 00 00 20 71 07 00 10 79 1a 00
La300               f0
La301                  f0 f0 f0 f0 f0 f0 f0 f0 f0 f0 f0 f0 f0 f0 f0
                    f0 f0 f0 f0 f0 f0 f0 f0 f0 f0 f0 f0 f0 f0 f0 f0
                    f0 f0 f0 f0 f0 f0 f0 f0 f0 f0 f0 f0 f0 f0 f0 f0
                    f0 f0 f0 f0 f0 f0 f0 f0 f0 f0 f0 f0 f0 f0 f0 f0
                    f0 f0 f0 f0 f0 f0 f0 f0 f0 f0 f2 f4 f6 f8 fa fa
                    fc fe 00 02 04 06 08 0a 0c 0e 10 12 12 12 12 12
                    12 12 12 12 12 12 12 12 12 12 12 12 12 12 12 12
                    12 12 12 12 12 12 12 12 12 12 12 12 12 12 12 12
                    12 12 12 12 12 12 12 12 12 12 12 12 12 14 16 18
                    1a 1a 1a 1a 1a 1a 1a 1a 1a 1a 1a 1a 1a 1a 1a 1a
                    1a 1a 1a 1a 1a 1a 1a 1a 1a 1a 1a 1a 1a 18 16 14
                    12 10 0e 0c 0a 08 06 04 02 00 fe fc fa f8 f6 f6
                    f6 f6 f6 f6 f6 f6 f6 f6 f6 f6 f6 f6 f6 f6 f6 f6
                    f6 f6 f6 f6 f6 f6 f6 f6 f6 f6 f6 f6 f6 f6 f6 f6
                    f6 f6 f6 f6 f6 f6 f6 f6 f6 f6 f6 f6 f6 f6 f6 f6
                    f6 f6 f6 f6 f6 f6 f6 f6 f6 f6 f6 f6 f6 f6 f6 f6
La400               4e
La401                  4e 4e 4e 4e 4e 4e 4e 4e 4e 4e 4e 4e 4e 4e 4e
                    4e 4e 4e 4e 4e 4e 4e 4e 4e 4e 4e 4e 4e 4e 4e 4e
                    4e 4e 4e 4e 4e 4e 4e 4e 4e 4e 4e 4e 4e 4e 4e 4e
                    4e 4e 4e 4e 4e 4e 4e 4e 4e 4e 4e 4e 4e 4e 4e 4e
                    4e 4e 4e 4e 4e 4e 4e 4e 4e 4e 4e 4e 4e 4e 4e 4f
                    51 53 55 58 5c 60 63 65 66 64 61 62 63 63 63 63
                    63 63 63 63 63 63 63 63 63 63 63 63 63 63 63 63
                    63 63 63 63 63 63 63 63 63 63 63 63 63 63 63 63
                    63 63 63 63 63 63 63 63 63 63 62 60 5d 58 54 52
                    53 53 53 53 53 53 53 53 53 53 53 53 53 53 53 53
                    53 53 53 53 53 53 53 53 53 53 53 53 51 51 53 56
                    5a 5f 64 68 6b 6e 70 71 70 6e 6b 67 64 63 62 62
                    62 62 62 62 62 62 62 62 62 62 62 62 62 62 62 62
                    62 62 62 62 62 62 62 62 62 62 62 62 62 62 62 62
                    62 62 62 62 62 62 62 62 62 62 62 62 62 62 62 62
                    62 62 62 62 62 62 62 62 62 62 62 62 62 62 62 62
La500               47
La501                  47 47 47 47 47 47 47 47 47 47 47 47 47 47 47
                    47 47 47 47 47 47 47 47 47 47 47 47 47 47 47 47
                    47 47 47 47 47 47 47 47 47 47 47 47 47 47 47 47
                    47 47 47 47 47 47 47 47 47 47 47 47 47 47 47 47
                    47 47 47 47 47 47 47 47 47 47 47 47 47 47 47 47
                    47 47 47 47 47 47 47 47 47 47 47 47 49 49 49 49
                    49 49 49 49 49 49 49 49 49 49 49 49 49 4a 4a 4a
                    4a 4a 4a 4a 4a 4a 4a 4a 4a 4a 4a 4a 4a 4a 4a 4a
                    4a 4a 4a 4a 4a 4a 4a 4a 49 49 49 47 47 47 47 47
                    49 49 49 49 49 49 4a 4a 4a 4a 4a 4a 4a 4a 4a 4a
                    4a 4a 4a 4a 4a 4a 4a 4a 4a 4a 4a 4a 4a 48 48 48
                    48 48 48 48 48 48 48 48 48 48 48 48 48 48 48 48
                    48 48 48 48 48 48 48 48 48 48 48 48 48 48 48 48
                    48 48 48 48 48 48 48 48 48 48 48 48 48 48 48 48
                    48 48 48 48 48 48 48 48 48 48 48 48 48 48 48 48
                    48 48 48 48 48 48 48 48 48 48 48 48 48 48 48 48
