		.namespace globals

		.org $300

block_start = *

spriteX		.hex d9
spriteY		.hex 97
spriteID	.hex 18
spriteXnew	.hex d9
spriteYNew	.hex 09

spriteIDNew	.hex 01

playerXspeed	.db 0
playerYspeed	.db 0

currentXspeed	.db $ff

L0309		.hex 00
L030a		.hex 04

keypressed	.hex 00

playerAnimIDs = * - 1
		.hex 0d 0e 0d 0b
		.hex 0f 10 0f 0c

L0314		.hex 00
L0315		.hex 00
jumpAnimIdx	.hex 08

L0317		.hex 2c

;00:off / FF: on / 01:back to player
playerAxeState
		.hex 00

;00: normal / 01: axe behind / 02: axe forward
playerAxeAnim	.hex 00

; sprite... ? key ? axe ?
; x
L031A		.hex 00
; y
L031B		.hex 00
; id
L031C		.hex 1e

L031D		.hex ff
L031E		.hex 00

; 00: not jumping 01: is jumping
isPlayerJumping	.hex 00

		.hex 02
L0321		.hex 01
L0322		.hex 00

jumpAnimIDs = * - 1
; while going right
		.hex 35 2c 2f 13 34 14 32 2b
; while going left
		.hex 36 2e 30 2d 33 12 31 11

L0333		.hex 1c

; sprite IDs anim player throwing axe
axeAnimIDs
		.hex 15 16 17 18

; seems to be related to sound counters for the axe sound
L0338		.hex 30
L0339		.hex 01

L033A		.hex 03
L033B		.hex 00

L033C		.db 0

; x positions on player info line

; playerScore
		.hex 1a
		.hex 1e
		.hex 22
		.hex 26
		.hex 2a
; playerLifeCount
		.hex 43
; level
		.hex 61
; playerAxeCountHi
		.hex 6e
; playerAxeCountLo
		.hex 72


;
; Player Data
;

playerData = * - 1

playerScore	.hex 00
L0347		.hex 00
L0348		.hex 00
L0349		.hex 00
L034A		.hex 00

playerLifeCount	.hex 03

level		.hex 00

playerAxeCountHi
		.hex 01
playerAxeCountLo
		.hex 00


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

; used by unpack
L0367		.hex dc
L0368		.hex df
L0369		.hex df

L036A		.hex dc

;
; Asset Data
;

assetData = * - 1
assetXpos:
assetKey	= *-assetXpos+1
		.hex 77
assetGem	= *-assetXpos+1
		.hex 7e

L036D		.hex 7f

assetKeyCnt	.db 0
assetGemCnt	.db 0


		.hex 00

sountCnt2	.hex 03
soundCnt3	.hex dc
L0373		.hex 00

unknown_xPos	.hex 05
unknown_yPos	.hex 06
		.hex d9

; unused ?
L0377		.hex d8
; readKbd: 0:yes !0:no
L0378		.hex 00
; ?
L0379		.hex 00

soundCnt1	.hex d8

; 01:kbd ff:joystick
inputMode	.hex 01

joyX		.hex 07
joyY		.hex 08
; ?
L037E		.hex 00

levelCnt	.hex d8

soundSwitch	.db $10 ; $10:on $00:off
; used by loadLevel
L0381		.hex 09

axeSndCnt1	.hex 0a

; => L0321; isPlayerJumping : seems unused
L0383		.hex 00

; key definitions
keyLeft		.hex 88
keyRight	.hex 95
keyUp		.hex c1
keyDown		.hex da
keyJump		.hex f1
keyAxe		.hex a0
keyRestart	.hex 8d
keySoundSwitch	.db "S" | $80
keyJoystick	.db "J" | $80
keyKeyboard	.db "K" | $80
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

block_size= *-block_start

		.export "sprite"
		.export "player"
		.export "key"
		.export "L03"
		.export "joy"
		.export "asset"

		.export axeAnimIDs
		.export level
		.export highScore
		.export track
		.export sector
		.export trackend
		.export sectorend
		.export rangeIdx
		.export inputMode
		.export Xpos
		.export Ypos
		.export soundSwitch
		.export unknown_xPos
		.export unknown_yPos
		.export currentXspeed
		.export levelCnt
		.export axeSndCnt1

		.end namespace
