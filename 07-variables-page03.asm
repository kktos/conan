
		.export L0380

L0300		.hex d9
L0301		.hex 97 18 d9 09 01 00 00 ff
L0309		.hex 00
L030a		.hex 04 00 0d 0e 0d 0b
L0310		.hex 0f
L0311		.hex 10 0f 0c 00 00 08 2c 00
L0319		.hex 00
L031a		.hex 00 00 1e ff 00 00
L0320		.hex 02
L0321		.hex 01 00 35 2c 2f 13 34
L0328		.hex 14
L0329		.hex 32 2b 36 2e 30 2d 33
L0330		.hex 12
L0331		.hex 31 11 1c 15 16 17 18
L0338		.hex 30
L0339		.hex 01 03 00 00 1a 1e 22
L0340		.hex 26
L0341		.hex 2a 43 61 6e 72 00 00
L0348		.hex 00
L0349		.hex 00 00 03 00 01 00 00
L0350		.hex 19
L0351		.hex 19 19 1a 1a 1b 1b 00
L0358		.hex 00
L0359		.hex 00 00 00 0e 13 18 1d
L0360		.hex 09
L0361		.hex 0e 13 18 1d de de dc
L0368		.hex df
L0369		.hex df dc 77 7e 7f 00 00
L0370		.hex 00
L0371		.hex 03 dc 00 05 06 d9 d8
L0378		.hex 00
L0379		.hex 00 d8 01 07 08 00 d8
L0380		.hex 10
L0381		.hex 09
L0382		.hex 0a
L0383		.hex 00
L0384		.hex 88
L0385		.hex 95
L0386		.hex c1 da
L0388		.hex d1
L0389		.hex a0 8d d3 00 00 ce 9b
L0390		.hex 15
L0391		.hex 16 17 18 19 1a eb 69
L0398		.hex af
L0399		.hex 0d c9 6b 8f 0d ca a8
L03a0		.hex 9f
L03a1		.hex 1b 8f 1c 1d 1e 8f 8f 9f
L03a9		.hex 1f
L03aa		.hex 8f 8f 20 21 8f 22
L03b0		.hex 23
L03b1		.hex 24 25 26 27 28 df df df
L03b9		.hex 9f
L03ba		.hex df 29 2a 2b df 2c
L03c0		.hex 2d
L03c1		.hex 2e 2f 30 31 32 df df 33
L03c9		.hex 34
L03ca		.hex 35 36 37 38 df 39

L03d0               jmp $9dbf

L03d3               jmp $9d84

L03d6               jmp $aafd

L03d9               jmp $b7b5

L03dc               lda $9d0f
                    ldy $9d0e
                    rts

L03e3               lda $aac2
                    ldy $aac1
                    rts

L03ea               jmp $a851

L03ed               .db $ea
L03ee               .db $ea

L03ef               jmp $fa59

L03f2               .db $af
L03f3               .db $be
L03f4               .db $1b

L03f5               jmp $ff58

                    jmp $ff65

L03fb               jmp $ff65

L03fe               .db $65
L03ff               .db $ff
