		.namespace boot

;
; nearly standard DOS 3.3 BOOT code
; https://6502disassembly.com/a2-rom/BOOT1.html
;

                .org $800

                .hex 01

                  ;
                  ; load T0S0 - T0S9
                  ; into $B600 - $BF00
                  ;
BOOT0               lda sys.PT2BTBUF+1
                    cmp #$09
                    bne L081f
                    lda sys.SLT16ZPG
                    lsr
                    lsr
                    lsr
                    lsr
                    ora #$c0
                    sta $3f
                    lda #$5c
                    sta $3e
                    clc
                    lda addrHi
                    adc sectorCnt
                    sta addrHi
L081f               ldx sectorCnt
                    bmi L0839
                    lda dskSectors,x
                    sta sys.BOOTSEC
                    dec sectorCnt
                    lda addrHi
                    sta sys.PT2BTBUF+1
                    dec addrHi
                    ldx sys.SLT16ZPG
                    jmp ($003e) ; $C65C

L0839               inc addrHi ; = $B600
                    inc addrHi ; = $B700
                    jsr sys.SETKBD
                    jsr sys.SETVID
                    jsr sys.INIT
                    ldx sys.SLT16ZPG
                    jmp BOOT_END

dskSectors          .hex 00 0d 0b 09 07 05 03 01 0e 0c
                    .hex 0a 08 06 04 02 0f 00

L085e               jsr $a764
                    bcs L086b
                    lda #$00
                    tay
                    sta $b65d
                    sta ($40),y
L086b               lda $b5c5
                    jmp $a6d2

L0871               lda $b65d
                    beq L087e
                    inc $b5bd
                    bne L087e
                    inc $b5be
L087e               lda #$00
                    sta $b65d
                    jmp $a546

L0886               sta $b5bc
                    jsr $a6a8
                    jsr $a2ea
                    jmp $a27d

L0892               ldy #$13
L0894               lda ($42),y
                    bne L08ac
                    iny
                    cpy #$17
                    bne L0894
                    ldy #$19
L089f               lda ($42),y
                    sta $b5a4,y
                    iny
                    cpy #$1d
                    bne L089f
L08a9               jmp $a6bc

L08ac               ldx #$ff
                    stx $b65d
                    bne L08a9
                    brk

BOOT_END            lda #$00
                    sta $0478
                    sta $04f8
                    sta $047e
                    sta $04fe
                    jmp (addrLo) ; jmp $B700

                    .hex 00 00 00 00 00 00 00 00 00 00 00

L08d0               jsr $fc58
                    lda #$c2
                    jsr $fded
                    lda #$01
                    jsr $fdda
                    lda #$ad
                    jsr $fded
                    lda #$00
                    jsr $fdda
                    rts

                    .hex 00 00 00 00 00 00 00 00
                    .hex 00 00 00 00 00 00 00 00 00 00 00 00 00

addrLo              .hex 00
addrHi              .hex b6
sectorCnt           .hex 09
