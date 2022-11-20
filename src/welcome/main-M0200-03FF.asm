		.namespace welcome

L1000		=	$1000

		.org $200

main		ldx #$01
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

                    ; will load data
                    ; and run intro screen
                    ; with the key settings screen
                    ; if user press R
L0254		jsr S02af

		; relocate T4S0 loaded in $1000
		; variables-page03
; L0257		ldx #$00
; L0259		lda L1000,x
; 		sta L0300,x
; 		inx
; 		bne L0259

		;;; useless now
		; MVPw L1000, variables.block_start, variables.block_size

		; nop
		; nop
		; nop

		jsr intro.showLevelBar

		;
		; load T6 to T9 in $4000:7FFF
		; load T5 in $1000:1FFF - game1
		; load T4 in $0300:0FFF
		; load T3 in $A700:B6FF
		;
		; .include "load-part2.asm"

		; read_diskw $0500, $1000, $1000
		read_file fgame_code
		; read_diskw $0600, $4000, $4000
		read_file fgame_data

		; read_diskw $0400, $0300, $1000-$0300
		read_file fvariables

		; read_diskw $0300, $A700, $B700-$A700
		read_file fspritelib

		; jsr intro.showFlipDisk
		jmp game1.gameStart

; clear hires1
S02af		ldy #$00
		sty $1a
		sty rwts_buf
		; sty L0810
		ldx #$20
		stx $1b
		tya
L02be		sta ($1a),y
		iny
		bne L02be
		inc $1b
		dex
		bpl L02be

		bit sys.PAGE2OFF
		bit sys.TEXTOFF
		bit sys.MIXEDOFF
		bit sys.HIRESON

; 05.0 load disk[A000-AFFF] to MEM[6000-6FFF]
; first screen
		; ldx #$0f
		; stx rwts_sec
		; ldx #$0a
		; stx rwts_trk
		; ldx #$6f
		; stx rwts_buf+1
		; jsr readTrack

		; read_diskw $0A00, $6000, $1000
		; read_diskw $0A00, $6000, $0E00
		read_file fwelcome_data

		lda sys.LCBANK2
		lda sys.LCBANK2

		; read_diskw $0102, $D000, $0E00
		read_file futils
		; MVPw $6E00, $D000, $200

; unpack to hires
; intro screen
		; ldx rwts_slot
		; lda $c089,x
		lda #$00
		ldx #$60
		ldy #192
		jsr unpack.run

		lda #$20
		ldx #$68
		ldy #192
		; stx L0343
		; ldx #$20
		; stx L0810
		jsr unpack.run

		;
		; load TB to TF in $6000:AFFF and T4S0:$1000 ->L0257
		;
		; .include "load-part1.asm"
		read_file fintro

		;;; useless now
		; read_diskw $0400, $1000, $0100

		bit sys.KBDSTRB

		; splash screens with anim
		jmp intro.run

		; .include "unpack.asm"
		; .include "read-disk.asm"

fwelcome_data:	.cstr "WELCOME_DATA"
fgame_data:	.cstr "GAME_DATA"
fgame_code:	.cstr "GAME_CODE"
fspritelib:	.cstr "SPRITELIB"
fvariables:	.cstr "VARIABLES"
futils:		.cstr "UTILS"
fintro:		.cstr "INTRO"

		; .align $100,$FF
