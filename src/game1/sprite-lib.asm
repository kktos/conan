; disk T3 into $A700:B6FF

		.segment SPRITELIB
		.namespace spritelib

		; .export hgrHi
		; .export hgrLo

; $A700 00 x 256
; $A800 00 x 256
; $A900 00 x 256
; $AA00 00 x 256
; $AB00 00 x 256
; $AC00 00 x 256
; $AD00 00 x 256
		; .fill 256*7

		; .org $AE00

.macro drawSprite %id:%x:%y {
		ldx %x
		ldy %y
		lda %id
		jsr spritelib.drawSprite
}

.function drawSprite {
		sty yPos
		tay
		lda spriteLo-1,y
		sta $1c
		lda spriteHi-1,y
		sta $1d

		ldy #$00
		sty isFlipped
		lda ($1c),y
		sta dsWidth
		sta dsWidthInit
		iny
		lda ($1c),y
		sta dsHeight
		stx dsHeightInit
		bpl Lae44

		inc isFlipped
		and #$7f
		sta dsHeight
		lda LB200,x
		bra :+

Lae44		lda LAF00,x
:
		asl
		clc
		adc #$02
		tay
		lda ($1c),y
		sta pixels
		iny
		lda ($1c),y
		sta pixels+1

loop:		ldy yPos
		lda utils.hgrLow,y
		sta $1c
		lda utils.hgrHigh,y
		sta $1d
		ldx dsHeightInit

		ldy isFlipped
		beq :+

		lda LB000,x
		jmp nextItem

;Lae73
:		lda LB100,x
nextItem
		tay

Lae77               cpy #40 ; $28
                    bcs Lae8e

pixels=*+1
                    lda $ffff

                    tax
                    and #$80
                    sta LB3F8
                    txa
                    eor ($1c),y
                    and #$7f
                    ora LB3F8
                    sta ($1c),y
Lae8e               inc pixels
                    bne Lae96

                    inc pixels+1
Lae96               iny
                    cpy #$4a
                    bne Lae9d

                    ldy #$00
Lae9d               dec dsWidth
                    bne Lae77

                    ldx dsWidthInit
                    stx dsWidth
                    dec dsHeight
                    beq Laeb3

                    inc yPos
                    jmp loop

Laeb3               rts
}

; $B300
.function drawSpriteM {
		sty yPos
		tay
		lda spriteLo-1,y
		sta $1c
		lda spriteHi-1,y
		sta $1d
		ldy #$00
		sty isFlipped
		lda ($1c),y
		sta dsWidth   ; width
		sta dsWidthInit
		iny
		lda ($1c),y
		sta dsHeight   ; height
		stx dsHeightInit
		bpl Lb344

		inc isFlipped
		and #$7f
		sta dsHeight
		lda LB200,x
		asl
		clc
		adc #$02
		tay
		lda ($1c),y
		sta mask
		iny
		lda ($1c),y
		sta mask+1
		jmp Lb357

Lb344               lda LAF00,x
		asl
		clc
		adc #$02
		tay
		lda ($1c),y
		sta mask
		iny
		lda ($1c),y
		sta mask+1

Lb357               ldy yPos
		lda utils.hgrLow,y
		sta $1c
		lda utils.hgrHigh,y
		sta $1d
		ldx dsHeightInit
		ldy isFlipped
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

mask=*+1
loop:
		lda $ffff

		eor ($1c),y
		sta ($1c),y
Lb388 		inc mask
		bne Lb390
		inc mask+1
Lb390 		iny
		cpy #$4a
		bne Lb397
		ldy #$00
Lb397 		dec dsWidth
		bne Lb377
		ldx dsWidthInit
		stx dsWidth
		dec dsHeight
		beq Lb3ad
		inc yPos
		jmp Lb357

Lb3ad 		rts

Lb3ae 		ldx mask
		stx mask2
		ldx mask+1
		stx mask2+1

mask2=*+1
		and $ffff

		beq loop
		inc isCollision
		jmp loop
}

; B3C5
		; .hex B3
		; .hex 4C 83 B3

		; .hex 03 05 00 02 04 06 01
		; .hex 00 80 00 80 00 80 00 80 00 20 40 60 80 A0 C0 E0
		; .hex 04 04 05 05 06 06 07 07 08 08 08 08 08 08 08 08

yPos       	.db $03
dsWidth 	.db $05
; LB3F2       	.db $00
dsWidthInit 	.db $02
dsHeight 	.db $04
dsHeightInit 	.db $06
isCollision	.db $01
isFlipped       .db $03
LB3F8        	.db $00
; LB3F9        	.db $02
; LB3FA        	.db $04
; LB3FB        	.db $06
; LB3FC        	.db $06
; LB3FD 		.db $03
; LB3FE        	.db $05
; LB3FF        	.db $05


		.align $100

		; .org $AF00

; $AF00
LAF00:
		.hex 00 02 04 06 01 03 05 00 02 04 06 01 03 05 00 02
		.hex 04 06 01 03 05 00 02 04 06 01 03 05 00 02 04 06
		.hex 01 03 05 00 02 04 06 01 03 05 00 02 04 06 01 03
		.hex 05 00 02 04 06 01 03 05 00 02 04 06 01 03 05 00
		.hex 02 04 06 01 03 05 00 02 04 06 01 03 05 00 02 04
		.hex 06 01 03 05 00 02 04 06 01 03 05 00 02 04 06 01
		.hex 03 05 00 02 04 06 01 03 05 00 02 04 06 01 03 05
		.hex 00 02 04 06 01 03 05 00 02 04 06 01 03 05 00 02
		.hex 04 06 01 03 05 00 02 04 06 01 03 05 00 02 04 06
		.hex 01 03 05 00 02 04 06 01 03 05 00 02 04 06 01 03
		.hex 05 00 02 04 06 01 03 05 00 02 04 06 01 03 05 00
		.hex 02 04 06 01 03 05 00 02 04 06 01 03 05 00 02 04
		.hex 06 01 03 05 00 02 04 06 01 03 05 00 02 04 06 01
		.hex 03 05 00 02 04 06 01 03 05 00 02 04 06 01 03 05
		.hex 06 01 03 05 00 02 04 06 01 03 05 00 02 04 06 01
		.hex 03 05 00 02 04 06 01 03 05 00 02 04 06 01 03 05

; $B000
LB000:
		.hex 00 00 00 01 01 01 01 02 02 02 03 03 03 03 04 04
		.hex 04 05 05 05 05 06 06 06 07 07 07 07 08 08 08 09
		.hex 09 09 09 0A 0A 0A 0B 0B 0B 0B 0C 0C 0C 0D 0D 0D
		.hex 0D 0E 0E 0E 0F 0F 0F 0F 10 10 10 11 11 11 11 12
		.hex 12 12 13 13 13 13 14 14 14 15 15 15 15 16 16 16
		.hex 17 17 17 17 18 18 18 19 19 19 19 1A 1A 1A 1B 1B
		.hex 1B 1B 1C 1C 1C 1D 1D 1D 1D 1E 1E 1E 1F 1F 1F 1F
		.hex 20 20 20 21 21 21 21 22 22 22 23 23 23 23 24 24
		.hex 24 25 25 25 25 26 26 26 27 27 27 27 28 28 28 29
		.hex 29 29 29 2A 2A 2A 2B 2B 2B 2B 2C 2C 2C 2D 2D 2D
		.hex 2D 2E 2E 2E 2F 2F 2F 2F 30 30 30 31 31 31 31 32
		.hex 32 32 33 33 33 33 34 34 34 35 35 35 35 36 36 36
		.hex 37 37 37 37 38 38 38 39 39 39 39 3A 3A 3A 3B 3B
		.hex 3B 3B 3C 3C 3C 3D 3D 3D 3D 3E 3E 3E 3F 3F 3F 3F
		.hex 41 41 41 41 42 42 42 43 43 43 43 44 44 44 45 45
		.hex 45 45 46 46 46 47 47 47 47 48 48 48 49 49 49 49

; $B100
LB100:
		.hex 00 00 00 00 01 01 01 02 02 02 02 03 03 03 04 04
		.hex 04 04 05 05 05 06 06 06 06 07 07 07 08 08 08 08
		.hex 09 09 09 0A 0A 0A 0A 0B 0B 0B 0C 0C 0C 0C 0D 0D
		.hex 0D 0E 0E 0E 0E 0F 0F 0F 10 10 10 10 11 11 11 12
		.hex 12 12 12 13 13 13 14 14 14 14 15 15 15 16 16 16
		.hex 16 17 17 17 18 18 18 18 19 19 19 1A 1A 1A 1A 1B
		.hex 1B 1B 1C 1C 1C 1C 1D 1D 1D 1E 1E 1E 1E 1F 1F 1F
		.hex 20 20 20 20 21 21 21 22 22 22 22 23 23 23 24 24
		.hex 24 24 25 25 25 26 26 26 26 27 27 27 28 28 28 28
		.hex 29 29 29 2A 2A 2A 2A 2B 2B 2B 2C 2C 2C 2C 2D 2D
		.hex 2D 2E 2E 2E 2E 2F 2F 2F 30 30 30 30 31 31 31 32
		.hex 32 32 32 33 33 33 34 34 34 34 35 35 35 36 36 36
		.hex 36 37 37 37 38 38 38 38 39 39 39 3A 3A 3A 3A 3B
		.hex 3B 3B 3C 3C 3C 3C 3D 3D 3D 3E 3E 3E 3E 3F 3F 3F
		.hex 41 41 41 42 42 42 42 43 43 43 44 44 44 44 44 45
		.hex 45 45 46 46 46 46 47 47 47 48 48 48 48 49 49 49

; $B200
LB200:
		.hex 01 03 05 00 02 04 06 01 03 05 00 02 04 06 01 03
		.hex 05 00 02 04 06 01 03 05 00 02 04 06 01 03 05 00
		.hex 02 04 06 01 03 05 00 02 04 06 01 03 05 00 02 04
		.hex 06 01 03 05 00 02 04 06 01 03 05 00 02 04 06 01
		.hex 03 05 00 02 04 06 01 03 05 00 02 04 06 01 03 05
		.hex 00 02 04 06 01 03 05 00 02 04 06 01 03 05 00 02
		.hex 04 06 01 03 05 00 02 04 06 01 03 05 00 02 04 06
		.hex 01 03 05 00 02 04 06 01 03 05 00 02 04 06 01 03
		.hex 05 00 02 04 06 01 03 05 00 02 04 06 01 03 05 00
		.hex 02 04 06 01 03 05 00 02 04 06 01 03 05 00 02 04
		.hex 06 01 03 05 00 02 04 06 01 03 05 00 02 04 06 01
		.hex 03 05 00 02 04 06 01 03 05 00 02 04 06 01 03 05
		.hex 00 02 04 06 01 03 05 00 02 04 06 01 03 05 00 02
		.hex 04 06 01 03 05 00 02 04 06 01 03 05 00 02 04 06
		.hex 00 02 04 06 01 03 05 00 02 04 06 01 03 05 00 02
		.hex 04 06 01 03 05 00 02 04 06 01 03 05 00 02 04 06

; sprites addr lo - $B600
spriteLo:
		.hex 00 10 20 30 40 50 60 70 80 90 A0 B0 C0 D0 E0 F0
		.hex 00 10 20 30 40 50 60 70 80 90 A0 B0 C0 D0 E0 F0
		.hex 00 10 20 30 40 50 60 70 80 90 A0 B0 C0 D0 E0 F0
		.hex 00 10 20 30 40 50 60 70 80 90 A0 B0 C0 D0 E0 F0
		.hex 00 10 20 30 40 50 60 70 80 90 A0 B0 C0 D0 E0 F0
		.hex 00 10 20 30 40 50 60 70 80 90 A0 B0 C0 D0 E0 F0
		.hex 00 10 20 30 40 50 60 70 80 90 A0 B0 C0 D0 E0 F0
		.hex 00 10 20 30 40 50 60 70 80 90 A0 B0 C0 D0 E0 F0

; sprites addr hi - $B680
spriteHi:
		.hex 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C 0C
		.hex 0D 0D 0D 0D 0D 0D 0D 0D 0D 0D 0D 0D 0D 0D 0D 0D
		.hex 0E 0E 0E 0E 0E 0E 0E 0E 0E 0E 0E 0E 0E 0E 0E 0E
		.hex 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F
		.hex 75 75 75 75 75 75 75 75 75 75 75 75 75 75 75 75
		.hex 76 76 76 76 76 76 76 76 76 76 76 76 76 76 76 76
		.hex 77 77 77 77 77 77 77 77 77 77 77 77 77 77 77 77
		.hex 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78 78

		.end namespace
