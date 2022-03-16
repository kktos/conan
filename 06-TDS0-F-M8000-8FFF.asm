                  .org $8000
;   A: img id
;   X: x coord
;   Y: y coord
drawImg             sty yPos
                    stx xPos
                    tay
                    lda spritesW,y
                    sta width
                    lda spritesH,y
                    sta height

                    lda spritesLo,y ; src lo
                    sta $1c
                    lda spritesHi,y ; src hi
                    sta $1d

                    ldx #$00
L801f               ldy yPos
                    lda hgrAddrLo,y ; hires addr lo
                    sta $1a
                    lda hgrAddrHi,y ; hires addr hi
                    clc
                    adc hgrPage ; page1:+$20 / page2:+$40
                    sta $1b

                    lda width
                    sta tmpW

                    lda xPos
                    sta L80f3

L803c               dec tmpW
                    bmi L8058
                    ldy L80f3
                    cpy #$28
                    bcs L804c
                    lda ($1c,x)
                    sta ($1a),y
L804c               inc L80f3
                    inc $1c
                    bne L803c
                    inc $1d
                    jmp L803c

L8058               dec height
                    beq L8063
                    inc yPos
                    jmp L801f

L8063               rts

L8064
                    .hex
                    01 01 00 00 01 01 00 00 01 01 00 00
                    01 01 00 00 11 25 0c 70 3d 07 40 3c 01 01 00 00
                    01 01 00 00 01 01 00 00 01 01 00 00 01 01 00 20
                    49 19 60 7b 0f 01 7b 00 01 01 00 00 01 01 00 00
                    01 01 00 00 01 01 00 00 01 01 40 10 31 41 77 1c
                    01 77 00 00 09 01 24 2a 01 75 22 00 79 07 00 00
                    11 01 48 54 01 6b 47 00 73 0f 02 00 21 01 10 28
                    01 55 0e 00 65 1f 04 00 41 01 20 52 03 29 1e 02
                    49 3f 08 00 01 01 40 24 05 51 3e 04 11 7f 10 00
                    .end

yPos                .db $01
xPos                .db $03
width               .db $00
L80f3               .db $48
tmpW                .db $0b
height              .db $21
hgrPage             .db $7c
L80f7               .hex 08 21 7f 20 00 01 05 00 12

L8100               sty $81f0
                    stx $81f1
                    tay
                    lda spritesW,y
                    sta $81f2
                    lda spritesH,y
                    sta $81f5
                    lda spritesLo,y
                    sta $1c
                    lda spritesHi,y
                    sta $1d
                    ldx #$00
L811f               ldy $81f0
                    lda hgrAddrLo,y
                    sta $1a
                    sta $1e
                    lda hgrAddrHi,y
                    sta $1b
                    clc
                    adc #$20
                    sta $1f
                    lda $81f2
                    sta $81f4
                    lda $81f1
                    sta $81f3
L813f               dec $81f4
                    bmi L815f
                    ldy $81f3
                    cpy #$28
                    bcs L8153
                    lda ($1e),y
                    bmi L8153
                    lda ($1c,x)
                    sta ($1a),y
L8153               inc $81f3
                    inc $1c
                    bne L813f
                    inc $1d
                    jmp L813f

L815f               dec $81f5
                    beq L816a
                    inc $81f0
                    jmp L811f

L816a               rts

                    .hex
                    00 01 03 00 00
                    21 01 02 00 21 01 00 00 01 05 00 00 41 01 04 00
                    41 01 00 00 01 09 00 00 01 01 08 00 01 01 00 00
                    01 15 00 00 05 07 10 00 01 03 00 00 05 21 00 00
                    01 05 20 00 01 05 00 00 01 41 00 00 01 09 40 00
                    69 01 00 4c 0b 01 44 02 01 15 00 00 61 01 00 78
                    01 01 18 02 01 1f 00 00 01 01 00 28 01 01 28 00
                    01 2b 00 00 03 01 00 52 01 01 58 00 01 51 02 00
                    51 03 00 58 17 01 0a 04 01 29 00 00 41 01 00 70
                    41 01 30 46 01 3d 00 00 01 01 00 50 01 01 50 00
                    .end

; table hires lo addr
hgrAddrLo           .hex
                    00 00 00 00 00 00 00 00 80 80 80 80 80 80 80 80
                    00 00 00 00 00 00 00 00 80 80 80 80 80 80 80 80
                    00 00 00 00 00 00 00 00 80 80 80 80 80 80 80 80
                    00 00 00 00 00 00 00 00 80 80 80 80 80 80 80 80
                    28 28 28 28 28 28 28 28 a8 a8 a8 a8 a8 a8 a8 a8
                    28 28 28 28 28 28 28 28 a8 a8 a8 a8 a8 a8 a8 a8
                    28 28 28 28 28 28 28 28 a8 a8 a8 a8 a8 a8 a8 a8
                    28 28 28 28 28 28 28 28 a8 a8 a8 a8 a8 a8 a8 a8
                    50 50 50 50 50 50 50 50 d0 d0 d0 d0 d0 d0 d0 d0
                    50 50 50 50 50 50 50 50 d0 d0 d0 d0 d0 d0 d0 d0
                    50 50 50 50 50 50 50 50 d0 d0 d0 d0 d0 d0 d0 d0
                    50 50 50 50 50 50 50 50 d0 d0 d0 d0 d0 d0 d0 d0
                    d0 d0 d0 d0 d0 d0 d0 d0 d0 d0 d0 d0 d0 d0 d0 d0
                    d0 d0 d0 d0 d0 d0 d0 d0 d0 d0 d0 d0 d0 d0 d0 d0
                    d0 d0 d0 d0 d0 d0 d0 d0 d0 d0 d0 d0 d0 d0 d0 d0
                    d0 d0 d0 d0 d0 d0 d0 d0 d0 d0 d0 d0 d0 d0 d0 d0
                    .end

; table hires hi addr
hgrAddrHi           .hex
                    20 24 28 2c 30 34 38 3c 20 24 28 2c 30 34 38 3c
                    21 25 29 2d 31 35 39 3d 21 25 29 2d 31 35 39 3d
                    22 26 2a 2e 32 36 3a 3e 22 26 2a 2e 32 36 3a 3e
                    23 27 2b 2f 33 37 3b 3f 23 27 2b 2f 33 37 3b 3f
                    20 24 28 2c 30 34 38 3c 20 24 28 2c 30 34 38 3c
                    21 25 29 2d 31 35 39 3d 21 25 29 2d 31 35 39 3d
                    22 26 2a 2e 32 36 3a 3e 22 26 2a 2e 32 36 3a 3e
                    23 27 2b 2f 33 37 3b 3f 23 27 2b 2f 33 37 3b 3f
                    20 24 28 2c 30 34 38 3c 20 24 28 2c 30 34 38 3c
                    21 25 29 2d 31 35 39 3d 21 25 29 2d 31 35 39 3d
                    22 26 2a 2e 32 36 3a 3e 22 26 2a 2e 32 36 3a 3e
                    23 27 2b 2f 33 37 3b 3f 23 27 2b 2f 33 37 3b 3f
                    3f 3f 3f 3f 3f 3f 3f 3f 3f 3f 3f 3f 3f 3f 3f 3f
                    3f 3f 3f 3f 3f 3f 3f 3f 3f 3f 3f 3f 3f 3f 3f 3f
                    3f 3f 3f 3f 3f 3f 3f 3f 3f 3f 3f 3f 3f 3f 3f 3f
                    3f 3f 3f 3f 3f 3f 3f 3f 3f 3f 3f 3f 3f 3f 3f 00
                    .end

; sprites width
spritesW            .hex
                    0b 0b 0b 0a 0a 0a 0a 0a 09 09 08 08 07 07 09 09
                    09 0a 0b 12 12 28 28 1e 0c 09 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    .end

; sprites height
spritesH            .hex
                    19 13 11 0f 0f 0e 0d 0c 0b 07 09 03 1f 1e 1f 1d
                    1f 1e 1f 13 13 09 09 3f 14 0c 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    .end

; sprites addr lo
spritesLo           .hex
                    00 13 e4 9f 35 cb 57 d9 51 b4 f3 3b 53 2c fe 15
                    1a 31 5d b2 08 5e c6 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    .end

; sprites addr hi
spritesHi           .hex
                    60 61 61 62 63 63 64 64 65 65 65 66 66 67 67 69
                    6a 6b 6c 6d 6f 8b 8c a0 a8 a9 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00
                    .end

S8765               .db 0
                    .hex
                                      00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    .end

;
; intro animation
;
L8800               lda #$00
                    sta L8ff1
                    sta L8ff0
                    sta L8ff6
                    sta L8ff9
                    sta L8ff5
                    sta L8ff8
                    sta L8ff2
                    sta L8ffb
                    sta L8ffc
                    sta L8fff
                    lda #$04
                    sta L8ffe
                    lda #$30
                    sta L8ffd
                    lda $c010
                    lda #$00
                    sta hgrPage
                    lda #$60
                    sta L80f7
                    lda #$ff
                    sta $5ff7

                    ; scroll datasoft copyright
L883c               dec L80f7
                    ldx #$0a
                    lda #$17
                    ldy L80f7
                    cpy #$c0
                    beq L8853
                    jsr L8100
                    bit $c010
                    jmp L883c

L8853
                    ; display hgr2 mask

                    lda #$20
                    sta hgrPage

                    lda #$18 ; img id
                    ldx #$0e ; x
                    ldy #$20 ; y
                    jsr drawImg

                    ; display hgr DATASOFT PRESENTS

                    lda #$00
                    sta hgrPage

                    lda #$19 ; img id
                    ldy #$0c ; x
                    ldx #$0f ; y
                    jsr drawImg

                    ; exit on key + wait
L886f               jsr S8881

                    ; anim sword in conan - once / anim knight on horse from left to right - repeat
                    jsr S8894
                    jsr S88ab
                    jsr S8912
                    jsr S896d
                    jmp L886f

S8881               ldy #$08
L8883               lda $c000
                    bpl L888b
                    jmp L89c3

L888b               lda #$10
                    jsr $fca8
                    dey
                    bne L8883
                    rts

S8894               inc L8ff0
                    lda L8ff0
                    beq L889d
                    rts

L889d               inc L8ff1
                    lda L8ff1
                    cmp #$11
                    bne L88aa
                    jmp L89c3

L88aa               rts

S88ab               lda L8ff2
                    bne L88c7
                    lda L8ff1
                    cmp #$04
                    bne L88c6
                    lda #$01
                    sta L8ff2
                    lda #$0c
                    sta L8ff3
                    lda #$f1
                    sta L8ff4
L88c6               rts

L88c7               inc L8fff
                    lda L8fff
                    cmp #$08
                    bne L88c6
                    lda #$00
                    sta L8fff
                    jsr S88dd
                    jsr S8906
                    rts

S88dd               lda L8ff3
                    cmp #$11
                    bne L8902
                    lda #$0c
                    sta L8ff3
                    inc L8ff4
                    inc L8ff4
                    inc L8ff4
                    inc L8ff4
                    lda L8ff4
                    cmp #$29
                    bne L8901
                    lda #$f1
                    sta L8ff4
L8901               rts

L8902               inc L8ff3
                    rts

S8906               lda L8ff3
                    ldy #$a2
                    ldx L8ff4
                    jsr L8100
                    rts

                    ; countdown between each sprite...
S8912               lda L8ff6
                    bne L892d
                    lda L8ff5
                    bne L892e
                    lda L8ff1
                    cmp #$00
                    bne L892d
                    lda #$01
                    sta L8ff5
                    lda #$00
                    sta L8ff7
L892d               rts

L892e               inc L8ffb
                    lda L8ffb
                    cmp L8ffd
                    bne L896c

                    ; display
                    ; the key
                    lda L8ffd
                    cmp #$04
                    beq L8946
                    sec
                    sbc #$04
                    sta L8ffd

L8946               lda #$00
                    sta L8ffb
                    ldy L8ff7
                    lda L8a40,y ; img id
                    pha
                    ldx L8a00,y ; x
                    lda L8a20,y ; y
                    tay
                    pla
                    jsr drawImg

                    inc L8ff7
                    lda L8ff7
                    cmp #$21
                    bne L896c
                    lda #$01
                    sta L8ff6
L896c               rts

S896d               lda L8ff9
                    bne L8988
                    lda L8ff8
                    bne L8989
                    lda L8ff1
                    cmp #$03
                    bne L8988
                    lda #$01
                    sta L8ff8
                    lda #$00
                    sta L8ffa
L8988               rts

L8989               inc L8ffc
                    lda L8ffc
                    cmp L8ffe
                    bne L89c2
                    lda L8ffe
                    cmp #$0d
                    beq L899e
                    inc L8ffe
L899e               lda #$00
                    sta L8ffc
                    ldy L8ffa
                    ldx L8a60,y
                    lda L8a80,y
                    ldy #$20
                    jsr L8100
                    ldy L8ffa
                    iny
                    sty L8ffa
                    lda L8a80,y
                    bne L89c2
                    lda #$01
                    sta L8ff9
L89c2               rts

                    ; if "R" is pressed, launch key settings dialog
L89c3               cmp #$d2
                    beq L89cb
                    pla
                    pla
                    clc
                    rts

L89cb               jsr $9700
                    pla
                    pla
                    sec
                    rts

L89d2               jsr S8765
                    jsr S8765
                    jsr S8765

L89DB               lda $c010

; display "flip disk"
                    lda #$15 ; img id
                    ldx #$00 ; x coord
                    ldy #$b7 ; 183 y coord
                    jsr drawImg

L89e7               lda $c000
                    bpl L89e7
                    lda $c010

; display player bottom info [score men level axe]
                    lda #$16 ; img id
                    ldx #$00 ; x coord
                    ldy #$b7 ; 183 y coord
                    jsr drawImg
                    rts

L89f9               .hex cc a0 ce cf ce 8d a0

; sprites X
L8a00               .hex 0e 0e 0e 0e 0e 0e 0e 0e 0e 0e 0e 0e 0e 0e 0e 0e
                    .hex 0e 0e 0e 0e 0e 0e 0e 0e 0e 0e 0e 0e 0e 0e 0e 0e
; sprites Y
L8a20               .hex 36 36 36 36 36 34 34 34 34 32 32 32 32 2f 2f 2f
                    .hex 2c 2c 2c 29 29 29 27 27 27 25 25 24 24 23 22 20
; sprites ID
L8a40               .hex 0b 0b 0b 0b 0b 0a 0a 0a 0a 09 09 09 09 08 08 08
                    .hex 07 07 07 06 06 06 05 05 05 04 04 03 03 02 01 00

L8a60               .hex ec ed ee ef f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 fa fb
                    .hex fc fd fe ff 00 01 02 03 04 05 06 07 08 09 0a 0a
L8a80               .hex
                    13 14 13 14 13 14 13 14 13 14 13 14 13 14 13 14
                    13 14 13 14 13 14 13 14 13 14 13 14 13 14 13 00
                    13 14 13 14 13 14 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    .end
L8b00               .hex
                    80 80 80 80 00 00 00 00 e0 87 80 80 80 80 80 80
                    80 80 80 80 80 80 00 00 00 00 c0 83 80 80 80 80
                    80 80 80 80 80 80 80 80 00 00 00 00 c0 83 80 80
                    80 80 80 80 80 80 80 80 80 80 00 00 00 00 c0 83
                    80 80 80 80 80 80 80 80 80 80 80 80 00 00 00 00
                    80 83 80 80 80 80 80 80 80 80 80 80 80 80 d5 aa
                    d5 aa d5 aa d5 aa d5 aa d5 aa d5 aa d5 aa d5 aa
                    d5 aa d5 aa d5 aa d5 aa d5 aa d5 aa d5 aa d5 aa
                    d5 aa d5 aa d5 aa 85 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 a8 85 80
                    .end
L8bb0               .hex 80 00 a8 91 a0 c5 8a c0 82 95 aa c4 80 d0 a2 c5
                    .hex 82 00 aa d4 a8 d1
L8bc6               .hex
                    a2 85 a0 c5 8a 91 00 c4 a8 91
                    82 00 00 00 00 a8 85 80 80 00 88 90 00 c1 88 c0
                    88 84 82 c4 80 90 a2 c4 88 00 a2 c4 88 90 a0 00
                    a0 c4 88 91 00 c4 88 90 82 00 00 00 00 a8 85 80
                    .end
L8c00               .hex
                    80 00 a8 90 00 c1 8a c0 88 84 aa 94 80 d0 a2 c4
                    88 00 aa d4 a8 d0 a2 85 a0 c5 88 84 00 94 a8 c0
                    80 00 00 00 00 a8 85 80 80 00 88 90 00 c1 80 c0
                    88 84 a0 c4 80 90 a2 c4 88 00 82 94 88 00 82 84
                    a0 c4 88 84 00 c4 88 c0 80 00 00 00 00 a8 85 80
                    80 00 88 d0 a2 c5 80 c0 82 95 aa c4 80 90 a2 c4
                    82 00 82 c4 a8 d1 a2 85 a0 c4 88 84 00 c4 a8 c1
                    80 00 00 00 00 a8 85 00 80 80 80 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 80 80 80 80 a8 d5 aa
                    d5 aa d5 aa d5 aa d5 aa d5 aa d5 aa d5 aa d5 aa
                    d5 aa d5 aa d5 aa d5 aa d5 aa d5 aa d5 aa d5 aa
                    d5 aa d5 aa d5 aa d5 aa d5 aa d5 aa d5 aa d5 aa
                    d5 aa d5 aa d5 aa d5 aa d5 aa d5 aa d5 aa d5 aa
                    d5 aa d5 aa d5 aa d5 aa d5 aa d5 aa d5 aa 85 80
                    80 80 80 80 80 80 80 80 80 80 80 80 94 80 80 80
                    .end
L8d00               .hex
                    80 80 d0 80 80 80 80 80 80 80 80 8a 80 80 80 80
                    80 80 80 80 80 a8 c5 8a 95 aa d4 a8 81 80 80 80
                    80 80 80 aa 94 aa d4 a8 81 80 d0 88 d0 a2 c4 8a
                    81 80 80 8a 83 80 80 80 80 80 80 80 80 a8 c5 80
                    81 a2 c4 88 90 80 80 80 80 80 80 a2 94 aa 84 88
                    91 80 d0 88 90 a0 c4 80 81 82 80 ea 81 80 80 80
                    80 80 80 80 80 a8 c5 8a 81 a2 d4 a8 80 80 80 80
                    80 80 80 a2 94 aa 94 88 81 80 d0 88 d0 a0 c4 8a
                    81 80 80 ea 87 80 80 80 80 80 80 80 80 a8 85 88
                    81 a2 94 88 90 80 80 80 80 80 80 a2 94 a2 84 88
                    91 80 d0 88 90 a0 c4 80 81 82 80 ea 9c 80 80 80
                    80 80 80 80 80 a8 c5 8a 95 aa c4 a8 81 80 80 80
                    80 80 80 aa 94 a2 d4 88 81 80 d0 a8 d1 82 c1 8a
                    95 80 80 8a f0 80 80 80 80 80 80 80 80 a8 85 80
                    80 80 80 80 80 80 80 80 80 80 80 80 94 80 80 80
                    80 80 d0 80 80 80 80 80 80 80 80 8a 80 80 80 80
                    .end
L8e00               .hex
                    80 80 80 80 80 a8 d5 aa d5 aa d5 aa d5 aa d5 aa
                    d5 aa d5 aa d5 aa d5 aa d5 aa d5 aa d5 aa d5 aa
                    d5 aa d5 aa d5 aa d5 aa d5 aa d5 aa d5 aa 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                    .end
L8f00               .hex
                    00 19 72 00 41 19 3e 18 7d 01 40 60 0f 01 00 00
                    21 01 00 00 01 01 00 00 01 01 00 00 01 01 00 00
                    21 01 00 00 01 01 00 00 01 01 00 00 01 01 00 00
                    21 01 00 00 01 01 00 00 01 01 00 00 01 01 00 00
                    21 01 00 00 01 01 00 00 01 01 00 00 01 01 00 00
                    21 01 00 00 01 01 00 00 01 01 00 00 01 01 00 00
                    21 01 32 3e 4d 79 02 60 4f 07 32 3e 7d 79 72 66
                    6d 1f 00 00 01 01 00 00 01 01 00 00 01 33 66 4c
                    19 03 60 4c 19 33 66 4c 61 31 66 40 01 01 00 00
                    01 01 00 00 05 05 00 00 0d 67 4c 78 03 61 4e 18
                    33 7f 4c 60 71 67 4c 06 01 01 00 00 05 05 00 00
                    01 01 00 4c 67 4d 79 00 61 4d 18 32 67 4d 61 30
                    67 4d 00 40 01 01 00 00 01 01 00 00 01 01 0c 7e
                    7d 19 02 60 4d 07 0c 66 4d 61 30 66 4f 1f 02 00
                    01 01 00 00 01 01 00 00 01 71 66 4c 1f 3f 7e 7c
                    .end
L8ff0               .hex 79
L8ff1               .hex 73
L8ff2               .hex 66
L8ff3               .hex 4e
L8ff4               .hex 1f
L8ff5               .hex 31
L8ff6               .hex 60
L8ff7               .hex 4c
L8ff8               .hex 19
L8ff9               .hex 33
L8ffa               .hex 66
L8ffb               .hex 0c
L8ffc               .hex 61
L8ffd               .hex 31
L8ffe               .hex 60
L8fff               .hex 4c
