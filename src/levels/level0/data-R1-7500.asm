
; level 0 sprites directory, starting at id $40

; $41 - $50
L7500
		; $41:$46 - Volta materializing (help page, animVoltaSpriteIDs):
		;   $41/$42 x7, then $43/$44 x4, then $45/$46 flashing, ends on $45
		; $41 - lightning sparks
		defprite	$02, $12, spriteLightningSparks
		; $42 - lightning bolt
		defprite	$02, $12, spriteLightningBolt
		; $43 - Volta forming 1
		defprite	$02, $93, spriteVoltaForming1
		; $44 - Volta forming 2
		defprite	$02, $92, spriteVoltaForming2
		; $45 - volta colored
		defprite	$03, $93, spriteVoltaColored
		; $46 - volta white
		defprite	$03, $93, spriteVoltaWhite

		; $47 - bird flying (help "avian ally": flies in from x=$F0 to $40)
		defprite	$04, $8d, spriteBirdFlying
		; $48 - bird landed (drawn once the flight ends)
		defprite	$04, $91, spriteBirdLanded
		; $49 - spring frame 1 (title anim: alternates with $4A, x=$45)
		defprite	$02, $0f, spriteSpring1
		; $4A - spring frame 2
		defprite	$02, $0f, spriteSpring2
		; $4B - unused: not drawn by level 0
		defprite	$02, $04, spriteUnused4B

		; $4C - HI-SC
		defprite	$06, $05, spriteHiSc
		; $4D - ORE
		defprite	$05, $05, spriteOre
		; $4E - blank 2x5 block, drawn twice with drawStore to erase the spring
		defpicture	$02, $05, spriteBlank
		; $4F - Help "introduction": underline + "HALL OF VOLTA", rows 6-22 of the original
		; 27x75 screen; the text is drawn with drawText (level0 drawIntroduction)
		defpicture	$1b, $11, spriteIntroduction
		; $50 - Help "characters"
		defpicture	$0c, $07, spriteHelpCharacters


; $51 - $60
L7600
		; $51 - Help "conan"
		defpicture	$06, $05, spriteHelpConan
		; $52 - Help "volta"
		defpicture	$07, $05, spriteHelpVolta
		; $53 - Help "avian ally"
		defpicture	$07, $0d, spriteHelpAvianAlly
		; $54 - Help "objects"
		defpicture	$09, $07, spriteHelpObjects
		; $55 - Help "key"
		defpicture	$04, $05, spriteHelpKey
		; $56 - Help icon gem holder
		defpicture	$02, $07, spriteIconGemHolder
		; $57 - Help "locked door"
		defpicture	$07, $0c, spriteHelpLockedDoor
		; $58 - Help "unlocked door"
		defpicture	$0a, $0c, spriteHelpUnlockedDoor
		; $59 - Help "gem"
		defpicture	$04, $05, spriteHelpGem
		; $5A - Help "gem holder"
		defpicture	$07, $0c, spriteHelpGemHolder
		; $5B - Help "extra sword"
		defpicture	$09, $0d, spriteHelpExtraSword

		; $5C - Help icon locked door
		defpicture	$03, $12, spriteIconLockedDoor
		; $5D - Help icon unlocked door
		defpicture	$03, $12, spriteIconUnlockedDoor

		; $5E - SPECIAL THANKS
		defpicture	$1e, $38, spriteSpecialThanks

		; $5F:$60 - unused: leftover disk buffer bytes (6502 code + "BLOAD LO TO HI"),
		; not a valid directory entry
		;.hex	a0 86 a9 95 20 f9 08 20 d3 0e 4c fc 11 42 4c 4f
		;.hex	41 44 20 4c 4f 20 54 4f 20 48 49 00 a0 11 a9 79

		.align	$100

; anim jumping conan title screen
; x pos for anim
spriteXtabl
		.hex
		6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 69 67 65 63 61 5f
		5d 5b 59 57 55 53 51 4f 4d 4b 49 47 45 43 41 3f
		3d 3b 39 37 35 33 31 2f 2d 2b 29 27 25 23 21 1f
		1d 1b 19 17 15 13 11 0f 0d 0b 09 07 f1 f1 f1 f1
		f1 f1 f1 f1 f1 f1 f1 f1 f1 f1 f1 f1 f1 f1 f1 f1
		f1 f1 f1 f1 f1 f1 f1 f1 f1 f1 f1 f1 f1 f1 f1 f1
		f1 f1 f1 f1 f1 f1 f1 f1 f1 f1 f1 f1 f1 f1 f1 f1
		f1 f1 f1 f1 f1 f1 f1 f1 f1 f1 f1 f1 f1 f1 f1 f1
		.end

; y pos for anim
spriteYtabl
		.hex
		9c 9c 9c 9c 9c 9c 9c 9c 9c 9c 9c 9c 9c 9c 9c 9c
		9c 9c 9c 9c 9c 9c 9c 9c 97 93 90 8e 8d 8d 8e 90
		93 97 9c 9c 9c 9c 9c 9c 97 93 90 8e 8d 8c 8c 8d
		90 93 95 95 96 96 96 97 97 97 97 97 97 97 97 97
		97 97 97 97 97 97 97 97 97 97 97 97 97 97 97 97
		97 97 97 97 97 97 97 97 97 97 97 97 97 97 97 97
		97 97 97 97 97 97 97 97 97 97 97 97 97 97 97 97
		97 97 97 97 97 97 97 97 97 97 97 97 97 97 97 97
		.end

; sprite id for anim
spriteIDtabl
		.hex
		0b 0b 0b 0b 0b 0b 0b 0b 0b 0b 0e 0b 0e 0b 0e 0b
		0e 0b 0e 0b 0e 0b 0e 0b 0e 2b 32 14 34 13 2f 2c
		35 2b 0e 0b 0e 0b 0e 0b 0e 2b 32 14 34 13 2f 2c
		35 35 0e 0b 0e 0b 0e 0b 0e 0b 0e 0b 0b 0b 0b 0b
		0b 0b 0b 0b 0b 0b 0b 0b 0b 0b 0b 0b 0b 0b 0b 0b
		0b 0b 0b 0b 0b 0b 0b 0b 0b 0b 0b 0b 0b 0b 0b 0b
		0b 0b 0b 0b 0b 0b 0b 0b 0b 0b 0b 0b 0b 0b 0b 0b
		0b 0b 0b 0b 0b 0b 0b 0b 0b 0b 0b 0b 0b 0b 0b 0b
		.end
