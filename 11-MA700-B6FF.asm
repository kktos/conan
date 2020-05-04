
$A700 00 x 256
$A800 00 x 256
$A900 00 x 256
$AA00 00 x 256
$AB00 00 x 256
$AC00 00 x 256
$AD00 00 x 256

                  * = AE00
AE00   8C F0 B3   STY $B3F0
AE03   A8         TAY
AE04   B9 FF B5   LDA $B5FF,Y
AE07   85 1C      STA $1C
AE09   B9 7F B6   LDA $B67F,Y
AE0C   85 1D      STA $1D
AE0E   A0 00      LDY #$00
AE10   8C F7 B3   STY $B3F7
AE13   B1 1C      LDA ($1C),Y
AE15   8D F1 B3   STA $B3F1
AE18   8D F3 B3   STA $B3F3
AE1B   C8         INY
AE1C   B1 1C      LDA ($1C),Y
AE1E   8D F4 B3   STA $B3F4
AE21   8E F5 B3   STX $B3F5
AE24   10 1E      BPL $AE44
AE26   EE F7 B3   INC $B3F7
AE29   29 7F      AND #$7F
AE2B   8D F4 B3   STA $B3F4
AE2E   BD 00 B2   LDA $B200,X
AE31   0A         ASL A
AE32   18         CLC
AE33   69 02      ADC #$02
AE35   A8         TAY
AE36   B1 1C      LDA ($1C),Y
AE38   8D 7C AE   STA $AE7C
AE3B   C8         INY
AE3C   B1 1C      LDA ($1C),Y
AE3E   8D 7D AE   STA $AE7D
AE41   4C 57 AE   JMP $AE57
AE44   BD 00 AF   LDA $AF00,X
AE47   0A         ASL A
AE48   18         CLC
AE49   69 02      ADC #$02
AE4B   A8         TAY
AE4C   B1 1C      LDA ($1C),Y
AE4E   8D 7C AE   STA $AE7C
AE51   C8         INY
AE52   B1 1C      LDA ($1C),Y
AE54   8D 7D AE   STA $AE7D
AE57   AC F0 B3   LDY $B3F0
AE5A   B9 00 B4   LDA $B400,Y
AE5D   85 1C      STA $1C
AE5F   B9 00 B5   LDA $B500,Y
AE62   85 1D      STA $1D
AE64   AE F5 B3   LDX $B3F5
AE67   AC F7 B3   LDY $B3F7
AE6A   F0 07      BEQ $AE73
AE6C   BD 00 B0   LDA $B000,X
AE6F   A8         TAY
AE70   4C 77 AE   JMP $AE77
AE73   BD 00 B1   LDA $B100,X
AE76   A8         TAY
AE77   C0 28      CPY #$28
AE79   B0 13      BCS $AE8E
AE7B   AD FF FF   LDA $FFFF
AE7E   AA         TAX
AE7F   29 80      AND #$80
AE81   8D F8 B3   STA $B3F8
AE84   8A         TXA
AE85   51 1C      EOR ($1C),Y
AE87   29 7F      AND #$7F
AE89   0D F8 B3   ORA $B3F8
AE8C   91 1C      STA ($1C),Y
AE8E   EE 7C AE   INC $AE7C
AE91   D0 03      BNE $AE96
AE93   EE 7D AE   INC $AE7D
AE96   C8         INY
AE97   C0 4A      CPY #$4A
AE99   D0 02      BNE $AE9D
AE9B   A0 00      LDY #$00
AE9D   CE F1 B3   DEC $B3F1
AEA0   D0 D5      BNE $AE77
AEA2   AE F3 B3   LDX $B3F3
AEA5   8E F1 B3   STX $B3F1
AEA8   CE F4 B3   DEC $B3F4
AEAB   F0 06      BEQ $AEB3
AEAD   EE F0 B3   INC $B3F0
AEB0   4C 57 AE   JMP $AE57
AEB3   60         RTS
AEB4   00         BRK
AEB5   00         BRK
AEB6   00         BRK
AEB7   00         BRK
AEB8   00         BRK
AEB9   00         BRK
AEBA   00         BRK
AEBB   00         BRK
AEBC   00         BRK
AEBD   00         BRK
AEBE   00         BRK
AEBF   00         BRK
AEC0   00         BRK
AEC1   00         BRK
AEC2   00         BRK
AEC3   00         BRK
AEC4   00         BRK
AEC5   00         BRK
AEC6   00         BRK
AEC7   00         BRK
AEC8   00         BRK
AEC9   00         BRK
AECA   00         BRK
AECB   00         BRK
AECC   00         BRK
AECD   00         BRK
AECE   00         BRK
AECF   00         BRK
AED0   00         BRK
AED1   00         BRK
AED2   00         BRK
AED3   00         BRK
AED4   00         BRK
AED5   00         BRK
AED6   00         BRK
AED7   00         BRK
AED8   00         BRK
AED9   00         BRK
AEDA   00         BRK
AEDB   00         BRK
AEDC   00         BRK
AEDD   00         BRK
AEDE   00         BRK
AEDF   00         BRK
AEE0   00         BRK
AEE1   00         BRK
AEE2   00         BRK
AEE3   00         BRK
AEE4   00         BRK
AEE5   00         BRK
AEE6   00         BRK
AEE7   00         BRK
AEE8   00         BRK
AEE9   00         BRK
AEEA   00         BRK
AEEB   00         BRK
AEEC   00         BRK
AEED   00         BRK
AEEE   00         BRK
AEEF   00         BRK
AEF0   00         BRK
AEF1   00         BRK
AEF2   00         BRK
AEF3   00         BRK
AEF4   00         BRK
AEF5   00         BRK
AEF6   00         BRK
AEF7   00         BRK
AEF8   00         BRK
AEF9   00         BRK
AEFA   00         BRK
AEFB   00         BRK
AEFC   00         BRK
AEFD   00         BRK
AEFE   00         BRK
AEFF   00         BRK

$AF00  00 02 04 06 01 03 05 00 02 04 06 01 03 05 00 02
$AF10  04 06 01 03 05 00 02 04 06 01 03 05 00 02 04 06
$AF20  01 03 05 00 02 04 06 01 03 05 00 02 04 06 01 03
$AF30  05 00 02 04 06 01 03 05 00 02 04 06 01 03 05 00
$AF40  02 04 06 01 03 05 00 02 04 06 01 03 05 00 02 04
$AF50  06 01 03 05 00 02 04 06 01 03 05 00 02 04 06 01
$AF60  03 05 00 02 04 06 01 03 05 00 02 04 06 01 03 05
$AF70  00 02 04 06 01 03 05 00 02 04 06 01 03 05 00 02
$AF80  04 06 01 03 05 00 02 04 06 01 03 05 00 02 04 06
$AF90  01 03 05 00 02 04 06 01 03 05 00 02 04 06 01 03
$AFA0  05 00 02 04 06 01 03 05 00 02 04 06 01 03 05 00
$AFB0  02 04 06 01 03 05 00 02 04 06 01 03 05 00 02 04
$AFC0  06 01 03 05 00 02 04 06 01 03 05 00 02 04 06 01
$AFD0  03 05 00 02 04 06 01 03 05 00 02 04 06 01 03 05
$AFE0  06 01 03 05 00 02 04 06 01 03 05 00 02 04 06 01
$AFF0  03 05 00 02 04 06 01 03 05 00 02 04 06 01 03 05

$B000  00 00 00 01 01 01 01 02 02 02 03 03 03 03 04 04
$B010  04 05 05 05 05 06 06 06 07 07 07 07 08 08 08 09
$B020  09 09 09 0A 0A 0A 0B 0B 0B 0B 0C 0C 0C 0D 0D 0D
$B030  0D 0E 0E 0E 0F 0F 0F 0F 10 10 10 11 11 11 11 12
$B040  12 12 13 13 13 13 14 14 14 15 15 15 15 16 16 16
$B050  17 17 17 17 18 18 18 19 19 19 19 1A 1A 1A 1B 1B
$B060  1B 1B 1C 1C 1C 1D 1D 1D 1D 1E 1E 1E 1F 1F 1F 1F
$B070  20 20 20 21 21 21 21 22 22 22 23 23 23 23 24 24
$B080  24 25 25 25 25 26 26 26 27 27 27 27 28 28 28 29
$B090  29 29 29 2A 2A 2A 2B 2B 2B 2B 2C 2C 2C 2D 2D 2D
$B0A0  2D 2E 2E 2E 2F 2F 2F 2F 30 30 30 31 31 31 31 32
$B0B0  32 32 33 33 33 33 34 34 34 35 35 35 35 36 36 36
$B0C0  37 37 37 37 38 38 38 39 39 39 39 3A 3A 3A 3B 3B
$B0D0  3B 3B 3C 3C 3C 3D 3D 3D 3D 3E 3E 3E 3F 3F 3F 3F
$B0E0  41 41 41 41 42 42 42 43 43 43 43 44 44 44 45 45
$B0F0  45 45 46 46 46 47 47 47 47 48 48 48 49 49 49 49

$B100  00 00 00 00 01 01 01 02 02 02 02 03 03 03 04 04
$B110  04 04 05 05 05 06 06 06 06 07 07 07 08 08 08 08
$B120  09 09 09 0A 0A 0A 0A 0B 0B 0B 0C 0C 0C 0C 0D 0D
$B130  0D 0E 0E 0E 0E 0F 0F 0F 10 10 10 10 11 11 11 12
$B140  12 12 12 13 13 13 14 14 14 14 15 15 15 16 16 16
$B150  16 17 17 17 18 18 18 18 19 19 19 1A 1A 1A 1A 1B
$B160  1B 1B 1C 1C 1C 1C 1D 1D 1D 1E 1E 1E 1E 1F 1F 1F
$B170  20 20 20 20 21 21 21 22 22 22 22 23 23 23 24 24
$B180  24 24 25 25 25 26 26 26 26 27 27 27 28 28 28 28
$B190  29 29 29 2A 2A 2A 2A 2B 2B 2B 2C 2C 2C 2C 2D 2D
$B1A0  2D 2E 2E 2E 2E 2F 2F 2F 30 30 30 30 31 31 31 32
$B1B0  32 32 32 33 33 33 34 34 34 34 35 35 35 36 36 36
$B1C0  36 37 37 37 38 38 38 38 39 39 39 3A 3A 3A 3A 3B
$B1D0  3B 3B 3C 3C 3C 3C 3D 3D 3D 3E 3E 3E 3E 3F 3F 3F
$B1E0  41 41 41 42 42 42 42 43 43 43 44 44 44 44 44 45
$B1F0  45 45 46 46 46 46 47 47 47 48 48 48 48 49 49 49

$B200  01 03 05 00 02 04 06 01 03 05 00 02 04 06 01 03
$B210  05 00 02 04 06 01 03 05 00 02 04 06 01 03 05 00
$B220  02 04 06 01 03 05 00 02 04 06 01 03 05 00 02 04
$B230  06 01 03 05 00 02 04 06 01 03 05 00 02 04 06 01
$B240  03 05 00 02 04 06 01 03 05 00 02 04 06 01 03 05
$B250  00 02 04 06 01 03 05 00 02 04 06 01 03 05 00 02
$B260  04 06 01 03 05 00 02 04 06 01 03 05 00 02 04 06
$B270  01 03 05 00 02 04 06 01 03 05 00 02 04 06 01 03
$B280  05 00 02 04 06 01 03 05 00 02 04 06 01 03 05 00
$B290  02 04 06 01 03 05 00 02 04 06 01 03 05 00 02 04
$B2A0  06 01 03 05 00 02 04 06 01 03 05 00 02 04 06 01
$B2B0  03 05 00 02 04 06 01 03 05 00 02 04 06 01 03 05
$B2C0  00 02 04 06 01 03 05 00 02 04 06 01 03 05 00 02
$B2D0  04 06 01 03 05 00 02 04 06 01 03 05 00 02 04 06
$B2E0  00 02 04 06 01 03 05 00 02 04 06 01 03 05 00 02
$B2F0  04 06 01 03 05 00 02 04 06 01 03 05 00 02 04 06

                  * = B300
drawSpriteM         sty LB3F0
                    tay
                    lda LB5ff,y
                    sta $1c
                    lda LB67f,y
                    sta $1d
                    ldy #$00
                    sty LB3F7
                    lda ($1c),y
                    sta LB3F1
                    sta LB3F3
                    iny
                    lda ($1c),y
                    sta LB3F4
                    stx LB3F5
                    bpl Lb344
                    inc LB3F7
                    and #$7f
                    sta LB3F4
                    lda LB200,x
                    asl a
                    clc
                    adc #$02
                    tay
                    lda ($1c),y
                    sta mask + 1
                    iny
                    lda ($1c),y
                    sta mask + 2
                    jmp Lb357
                    
Lb344               lda LAF00,x
                    asl a
                    clc
                    adc #$02
                    tay
                    lda ($1c),y
                    sta mask + 1
                    iny
                    lda ($1c),y
                    sta mask + 2

Lb357               ldy LB3F0
                    lda hgrLo,y
                    sta $1c
                    lda hgrHi,y
                    sta $1d
                    ldx LB3F5
                    ldy LB3F7
                    beq Lb373
                    lda LB000,x
                    tay
                    jmp Lb377
                    
Lb373               lda LB100,x
                    tay
Lb377               cpy #$28
                    bcs Lb388
                    lda ($1c),y
                    bmi Lb388
                    bne Lb3ae
mask                lda $ffff
                    eor ($1c),y
                    sta ($1c),y
Lb388               inc mask + 1
                    bne Lb390
                    inc mask + 2
Lb390               iny
                    cpy #$4a
                    bne Lb397
                    ldy #$00
Lb397               dec LB3F1
                    bne Lb377
                    ldx LB3F3
                    stx LB3F1
                    dec LB3F4
                    beq Lb3ad
                    inc LB3F0
                    jmp Lb357
                    
Lb3ad               rts
                    
Lb3ae               ldx mask + 1
                    stx mask2 + 1
                    ldx mask + 2
                    stx mask2 + 2
mask2               and $ffff
                    beq mask
                    inc $b3f6
                    jmp mask

B3C5   B3         ???
B3C6   4C 83 B3   JMP $B383

$B3C9                             03 05 00 02 04 06 01
$B3D0  00 80 00 80 00 80 00 80 00 20 40 60 80 A0 C0 E0
$B3E0  04 04 05 05 06 06 07 07 08 08 08 08 08 08 08 08
$B3F0  03 05 00 02 04 06 01 03 00 02 04 06 06 03 05 05

; hires addr lo
$B400  00 00 00 00 00 00 00 00 80 80 80 80 80 80 80 80
$B410  00 00 00 00 00 00 00 00 80 80 80 80 80 80 80 80
$B420  00 00 00 00 00 00 00 00 80 80 80 80 80 80 80 80
$B430  00 00 00 00 00 00 00 00 80 80 80 80 80 80 80 80
$B440  28 28 28 28 28 28 28 28 A8 A8 A8 A8 A8 A8 A8 A8
$B450  28 28 28 28 28 28 28 28 A8 A8 A8 A8 A8 A8 A8 A8
$B460  28 28 28 28 28 28 28 28 A8 A8 A8 A8 A8 A8 A8 A8
$B470  28 28 28 28 28 28 28 28 A8 A8 A8 A8 A8 A8 A8 A8
$B480  50 50 50 50 50 50 50 50 D0 D0 D0 D0 D0 D0 D0 D0
$B490  50 50 50 50 50 50 50 50 D0 D0 D0 D0 D0 D0 D0 D0
$B4A0  50 50 50 50 50 50 50 50 D0 D0 D0 D0 D0 D0 D0 D0
$B4B0  50 50 50 50 50 50 50 50 D0 D0 D0 D0 D0 D0 D0 60
$B4C0  60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60
$B4D0  60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60
$B4E0  60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60
$B4F0  60 60 60 60 60 60 60 60 60 60 60 60 60 60 60 60

; hires addr hi
$B500  20 24 28 2C 30 34 38 3C 20 24 28 2C 30 34 38 3C
$B510  21 25 29 2D 31 35 39 3D 21 25 29 2D 31 35 39 3D
$B520  22 26 2A 2E 32 36 3A 3E 22 26 2A 2E 32 36 3A 3E
$B530  23 27 2B 2F 33 37 3B 3F 23 27 2B 2F 33 37 3B 3F
$B540  20 24 28 2C 30 34 38 3C 20 24 28 2C 30 34 38 3C
$B550  21 25 29 2D 31 35 39 3D 21 25 29 2D 31 35 39 3D
$B560  22 26 2A 2E 32 36 3A 3E 22 26 2A 2E 32 36 3A 3E
$B570  23 27 2B 2F 33 37 3B 3F 23 27 2B 2F 33 37 3B 3F
$B580  20 24 28 2C 30 34 38 3C 20 24 28 2C 30 34 38 3C
$B590  21 25 29 2D 31 35 39 3D 21 25 29 2D 31 35 39 3D
$B5A0  22 26 2A 2E 32 36 3A 3E 22 26 2A 2E 32 36 3A 3E
$B5B0  23 27 2B 2F 33 37 3B 3F 23 27 2B 2F 33 37 3B 0F
$B5C0  0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F
$B5D0  0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F
$B5E0  0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F
$B5F0  0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F

; sprites addr lo
$B600  00 10 20 30 40 50 60 70 80 90 A0 B0 C0 D0 E0 F0
$B610  00 10 20 30 40 50 60 70 80 90 A0 B0 C0 D0 E0 F0
$B620  00 10 20 30 40 50 60 70 80 90 A0 B0 C0 D0 E0 F0
$B630  00 10 20 30 40 50 60 70 80 90 A0 B0 C0 D0 E0 F0
$B640  00 10 20 30 40 50 60 70 80 90 A0 B0 C0 D0 E0 F0
$B650  00 10 20 30 40 50 60 70 80 90 A0 B0 C0 D0 E0 F0
$B660  00 10 20 30 40 50 60 70 80 90 A0 B0 C0 D0 E0 F0
$B670  00 10 20 30 40 50 60 70 80 90 A0 B0 C0 D0 E0 F0

; sprites addr hi
$B680  0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C
$B690  0D 0D 0D 0D 0D 0D 0D 0D 0D 0D 0D 0D 0D 0D 0D 0D
$B6A0  0E 0E 0E 0E 0E 0E 0E 0E 0E 0E 0E 0E 0E 0E 0E 0E
$B6B0  0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F
$B6C0  75 75 75 75 75 75 75 75 75 75 75 75 75 75 75 75
$B6D0  76 76 76 76 76 76 76 76 76 76 76 76 76 76 76 76
$B6E0  77 77 77 77 77 77 77 77 77 77 77 77 77 77 77 77
$B6F0  78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78
