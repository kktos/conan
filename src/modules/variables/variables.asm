		.namespace globals

		.org $300

block_start = *

spriteX		.db $d9
spriteY		.db $97
spriteID	.db $18
spriteXnew	.db $d9
spriteYNew	.db $09

spriteIDNew	.db $01

playerXspeed	.db 0
playerYspeed	.db 0

currentXspeed	.db $ff

L0309		.db $00
L030a		.db $04

keypressed	.db $00

playerAnimIDs = * - 1
		.db $0d, $0e, $0d, $0b
		.db $0f, $10, $0f, $0c

L0314		.db $00
L0315		.db $00
jumpAnimIdx	.db $08

L0317		.db $2c

;00:off / FF: on / 01:back to player
playerAxeState	.db $00
;00: normal / 01: axe behind / 02: axe forward
playerAxeAnim	.db $00
; x
axeXpos		.db $00
; y
axeYpos		.db $00
; id
axeSpriteID	.db $1e

L031D		.db $ff
L031E		.db $00

; 00: not jumping 01: is jumping
isPlayerJumping	.db $00

		.db $02
L0321		.db $01
L0322		.db $00

jumpAnimIDs = * - 1
; while going right
		.hex { 35 2c 2f 13 34 14 32 2b }
; while going left
		.hex { 36 2e 30 2d 33 12 31 11 }

L0333		.db $1c

; sprite IDs anim player throwing axe
axeAnimIDs
		.hex { 15 16 17 18 }

; seems to be related to sound counters for the axe sound
L0338		.db $30
L0339		.db $01

L033A		.db $03
L033B		.db $00

L033C		.db 0

; x positions on player info line

; playerScore
		.db $1a
		.db $1e
		.db $22
		.db $26
		.db $2a
; playerLifeCount
		.db $43
; level
		.db $61
; playerAxeCountHi
		.db $6e
; playerAxeCountLo
		.db $72


;
; Player Data
;

playerData = * - 1

playerScore	.db $00
L0347		.db $00
L0348		.db $00
L0349		.db $00
L034A		.db $00

playerLifeCount	.db $03

level		.db $00

playerAxeCountHi
		.db $01
playerAxeCountLo
		.db $00


playerDeadAnimIdx
		.db $00

;L0350
		.hex { 19 19 19 1a 1a 1b 1b }

highScore	.hex { 00 00 00 00 00 }

track		.db $0e
sector 		.db $13
trackend	.db $18
sectorend	.db $1D

; L0360
rangeIdx	.db $09

		.hex { 0e 13 18 1d }
Xpos		.db $de
Ypos		.db $de

; used by unpack
		.db $dc
		.db $df
		.db $df
		.db $dc

;
; Asset Data
;

assetData = * - 1
assetXpos:
assetKey	= *-assetXpos+1
		.db $77
assetGem	= *-assetXpos+1
		.db $7e

L036D		.db $7f

assetKeyCnt	.db 0
assetGemCnt	.db 0


		.db $00

sountCnt2	.db $03
soundCnt3	.db $dc
L0373		.db $00

unknown_xPos	.db $05
unknown_yPos	.db $06
		.db $d9

; unused ?
L0377		.db $d8
; readKbd: 0:yes !0:no
L0378		.db $00
; ?
L0379		.db $00

soundCnt1	.db $d8

; 01:kbd ff:joystick
inputMode	.db $01

joyX		.db $07
joyY		.db $08
; ?
L037E		.db $00

levelCnt	.db $d8

soundSwitch	.db $10 ; $10:on $00:off
; used by loadLevel
L0381		.db $09

axeSndCnt1	.db $0a

; => L0321; isPlayerJumping : seems unused
L0383		.db $00

; key definitions
keyLeft		.db $88
keyRight	.db $95
keyUp		.db $c1
keyDown		.db $da
keyJump		.db $f1
keyAxe		.db $a0
keyRestart	.db $8d
keySoundSwitch	.db "S" | $80
keyJoystick	.db "J" | $80
keyKeyboard	.db "K" | $80
		.db $ce
keyPause	.db $9b

;L0390
		.hex { 15 16 17 18 19 1a eb 69 }
		.hex { af 0d c9 6b 8f 0d ca a8 }
;L03a0
		.hex { 9f 1b 8f 1c 1d 1e 8f 8f 9f }
		.hex { 1f 8f 8f 20 21 8f 22 }
;L03b0
		.hex { 23 24 25 26 27 28 df df df }
		.hex { 9f df 29 2a 2b df 2c }
;L03c0
		.hex { 2d 2e 2f 30 31 32 df df 33 }
		.hex { 34 35 36 37 38 df 39 }

;L03d0
		jmp $9dbf
;L03d3
		jmp $9d84
;L03d6
		jmp $aafd
;L03d9
		jmp $b7b5
;L03dc
		lda $9d0f
		ldy $9d0e
		rts
;L03e3
		lda $aac2
		ldy $aac1
		rts

;L03ea
		jmp $a851
		.db $ea
		.db $ea
;L03ef
		jmp $fa59
		.db $af
		.db $be
		.db $1b
;L03f5
		jmp $ff58
		jmp $ff65
		jmp $ff65
		.db $65
;L03ff
		.db $ff

block_size= *-block_start

		.end namespace
