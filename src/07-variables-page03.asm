		.namespace variables

		.export spriteX
		.export spriteY
		.export spriteID
		.export spriteXnew
		.export spriteYNew
		.export keypressed
		.export playerAxeState
		.export playerAxeAnim
		.export axeAnimIDs
		.export playerLifeCount
		.export level
		.export playerAxeCount
		.export playerDeadAnimIdx
		.export highScore
		.export track
		.export sector
		.export trackend
		.export sectorend
		.export rangeIdx
		.export L0380
		.export L0383
		.export L038B
		.export keyPause
		.export keyRestart
		.export keyJoystick
		.export keyKeyboard
		.export inputMode
		.export keyLeft
		.export keyRight
		.export keyUp
		.export keyDown
		.export keyAxe
		.export keyJump
		.export spriteIDNew
		.export L0306
		.export L0307
		.export L0308
		.export L0309
		.export L030a
		.export L0314
		.export L0315
		.export L0316
		.export L0317
		.export L031A
		.export L031B
		.export L031C
		.export L031D
		.export L031E
		.export L031F
		.export L0321
		.export L0322
		.export L0333
		.export L0338
		.export L0339
		.export L033A
		.export L033B
		.export L033C
		.export L0345
		.export L0346
		.export L0347
		.export L0348
		.export L0349
		.export L034A
		.export L034D
		.export L0367
		.export L0368
		.export L0369
		.export L036A
		.export L036E
		.export L036F
		.export L0371
		.export L0372
		.export L0373
		.export L0374
		.export L0375
		.export L0377
		.export L0378
		.export L0379
		.export L037A
		.export L037C
		.export L037D
		.export L037E
		.export L037F
		.export L0381
		.export L0382

		.export Xpos
		.export Ypos

		.org $300

spriteX		.hex d9
spriteY		.hex 97
spriteID	.hex 18
spriteXnew	.hex d9
spriteYNew	.hex 09

spriteIDNew	.hex 01

L0306		.hex 00
L0307		.hex 00
L0308		.hex ff
L0309		.hex 00
L030a		.hex 04

keypressed	.hex 00

		.hex 0d 0e 0d 0b
		.hex 0f 10 0f 0c

L0314		.hex 00
L0315		.hex 00
L0316		.hex 08
L0317		.hex 2c

;00:off / FF: on / 01:back to player
playerAxeState
		.hex 00

;00: normal / 01: axe behind / 02: axe forward
playerAxeAnim	.hex 00

L031A		.hex 00
L031B		.hex 00
L031C		.hex 1e
L031D		.hex ff
L031E		.hex 00
L031F		.hex 00
		.hex 02
L0321		.hex 01
L0322		.hex 00

		.hex 35 2c 2f 13 34
		.hex 14
		.hex 32 2b 36 2e 30 2d 33
		.hex 12
		.hex 31 11

L0333		.hex 1c

; sprite IDs anim player throwing axe
axeAnimIDs
		.hex 15 16 17 18

L0338		.hex 30
L0339		.hex 01
L033A		.hex 03
L033B		.hex 00
L033C		.hex 00
		.hex 1a 1e 22
;L0340
		.hex 26
		.hex 2a 43 61 6e
L0345		.hex 72
L0346		.hex 00
L0347		.hex 00
L0348		.hex 00
L0349		.hex 00
L034A		.hex 00

playerLifeCount	.hex 03

level		.hex 00

L034D		.hex 01

playerAxeCount	.hex 00

playerDeadAnimIdx
		.hex 00

;L0350
		.hex 19 19 19 1a 1a 1b 1b

highScore	.hex 00 00 00 00 00

track		.hex 0e
sector 		.hex 13
trackend	.hex 18
sectorend	.hex 1D

; L0360
rangeIdx	.hex 09

		.hex 0e 13 18 1d
Xpos		.hex de
Ypos		.hex de

L0367		.hex dc
L0368		.hex df
L0369		.hex df
L036A		.hex dc

		.hex 77 7e 7f

L036E		.hex 00
L036F		.hex 00

		.hex 00

L0371		.hex 03
L0372		.hex dc
L0373		.hex 00

L0374		.hex 05
L0375		.hex 06
		.hex d9

L0377		.hex d8
L0378		.hex 00
L0379		.hex 00
L037A		.hex d8

; 01:kbd ff:joystick
inputMode	.hex 01

L037C		.hex 07
L037D		.hex 08
L037E		.hex 00
L037F		.hex d8
L0380		.hex 10
L0381		.hex 09
L0382		.hex 0a
L0383		.hex 00

; key definitions
keyLeft		.hex 88
keyRight	.hex 95
keyUp		.hex c1
keyDown		.hex da
keyJump		.hex d1
keyAxe		.hex a0
keyRestart	.hex 8d
L038B		.hex d3
keyJoystick	.hex 00
keyKeyboard	.hex 00
		.hex ce
keyPause	.hex 9b

;L0390
		.hex 15 16 17 18 19 1a eb 69
		.hex af 0d c9 6b 8f 0d ca a8
;L03a0
		.hex 9f 1b 8f 1c 1d 1e 8f 8f 9f
		.hex 1f 8f 8f 20 21 8f 22
;L03b0
		.hex 23 24 25 26 27 28 df df df
		.hex 9f df 29 2a 2b df 2c
;L03c0
		.hex 2d 2e 2f 30 31 32 df df 33
		.hex 34 35 36 37 38 df 39

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
