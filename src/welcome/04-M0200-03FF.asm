		.namespace boot2

		.export welcome

L1000		=	$1000
L0300		=	$0300


		.org $200

welcome		ldx #$01
		stx $0478
		ldx #$04
		stx $04f8
		ldx #$21
		stx $0578
		ldx #$60
		stx $05f8
		stx $0678
		ldx #$02
		stx $06f8
		ldx #$c6
		stx $07f8

		jmp L0254

		.include "read-disk.asm"

                    ; will load data
                    ; and run intro screen
                    ; with the key settings screen
                    ; if user press R
L0254		jsr S02af

		; relocate T4S0 loaded in $1000
		; variables-page03
L0257		ldx #$00
L0259		lda L1000,x
		sta L0300,x
		inx
		bne L0259

		;
		; load T6 to T9 in $4000:7FFF
		; load T5 in $1000:1FFF - game1
		; load T4 in $0300:0FFF
		; load T3 in $A700:B6FF
		;
		.include "load-part2.asm"

		jsr showFlipDisk
		jmp game1.gameStart

; clear hires1
S02af		ldy #$00
		sty $1a
		sty rwts_buf
		sty L0810
		ldx #$20
		stx $1b
		tya
L02be		sta ($1a),y
		iny
		bne L02be
		inc $1b
		dex
		bpl L02be

		bit $c054
		bit $c050
		bit $c052
		bit $c057

; 05.0 load disk[A000-AFFF] to MEM[6000-6FFF]
; first screen
		ldx #$0f
		stx rwts_sec
		ldx #$0a
		stx rwts_trk
		ldx #$6f
		stx rwts_buf+1
		jsr readTrack

; unpack to hires
; intro screen
		ldx rwts_slot
		lda $c089,x
		jsr unpack

		ldx #$68
		stx L0343
		ldx #$20
		stx L0810
		jsr unpack

		;
		; load TB to TF in $6000:AFFF and T4S0:$1000 ->L0257
		;

		.include "load-part1.asm"

		bit $c010
		; splash screens with anim
		jsr showIntro
		rts

		.include "unpack.asm"

		.align $100 $FF
