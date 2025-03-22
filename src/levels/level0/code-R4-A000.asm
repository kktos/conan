
LA000      	jmp start

drawSpriteBis
		sty yPos
		tay
		lda spritelib.spriteLo-1,y
		sta $1c
		lda spritelib.spriteHi-1,y
		sta $1d

		ldy #$00
		sty spritelib.isFlipped
		lda ($1c),y
		sta spritelib.dsWidth
		sta spritelib.dsWidthInit
		iny
		lda ($1c),y
		sta spritelib.dsHeight
		stx Ypos
		bpl !+

		inc spritelib.isFlipped
		and #$7f
		sta spritelib.dsHeight
		lda spritelib.LB200,x
		bra !++
		; asl
		; clc
		; adc #$02
		; tay
		; lda ($1c),y
		; sta pixels
		; iny
		; lda ($1c),y
		; sta pixels+1
		; jmp La05a

!	     	lda spritelib.LAF00,x
!
		asl
		clc
		adc #$02
		tay
		lda ($1c),y
		sta pixels
		iny
		lda ($1c),y
		sta pixels+1

La05a       	ldy yPos
		lda utils.hgrLow,y
		sta $1c
		lda utils.hgrHigh,y
		sta $1d
		ldx Ypos

		ldy spritelib.isFlipped
		beq !+

		lda spritelib.LB000,x
		bra !++

!	      	lda spritelib.LB100,x
!		tay

La07a       	cpy #40
		bcs !+

pixels=*+1
		lda $ffff
		sta ($1c),y
!	   	inc pixels
		bne !+

		inc pixels+1
!	      	iny
		cpy #74
		bne !+

		ldy #$00
!               dec spritelib.dsWidth
		bne La07a

		ldx spritelib.dsWidthInit
		stx spritelib.dsWidth
		dec spritelib.dsHeight
		beq !+
		inc yPos
		jmp La05a

!		rts

; title screen / conan jumping over spring / hi-score
start               bit sys.KBDSTRB
                    jsr Sa379

mainLoop
		jsr animConanJump
		jsr exitOnEvent
		jsr drawHiScore

		ldx #$30
		jsr checkUserInput

		jsr drawHiScore
		jsr animConanJump
		jsr exitOnEvent
		jsr drawHiScore

		ldx #$30
		jsr checkUserInput

		jsr displayHelp
		jsr exitOnEvent
		jmp mainLoop

		rts

; A0D8
drawTitleBitmap
		lda #$00
		ldx #>titlePackedBitmap
		ldy #183
		jmp unpack.run

; A15A
displayHelp         jsr utils.clearScreen
                    jsr Sa1f1

                    ldx L7907
                    jsr checkUserInput

                    jsr Sa1f1
                    ldx #$40
                    stx L7907
                    jsr Sa1fb
                    jsr Sa205
                    jsr Sa23c

                    ldx #$10
                    jsr checkUserInput

                    jsr runAnimVolta
                    jsr Sa272

                    ldx #$10
                    jsr checkUserInput

                    jsr Sa27c
                    jsr Sa2b9

                    ldx #$20
                    jsr checkUserInput

                    jsr Sa230
                    jsr Sa2ad
                    jsr animVolta
                    jsr Sa2b9
                    jsr Sa272
                    jsr Sa23c
                    jsr Sa1fb
                    jsr Sa2c3

                    ldx #$ff
                    stx L7906
                    jsr displayHelpObj

                    ldx #$20
                    jsr checkUserInput

                    ldx #$01
                    stx L7906
                    jsr displayHelpObj

                    jsr drawTitleBitmap
                    rts
; A1C3
; clearScreen         ldx #$00
;                     stx L7900
; La1c8               jsr Sa1d6
;                     inc L7900
;                     ldx L7900
;                     cpx #$b7
;                     bne La1c8
;                     rts

; Sa1d6               ldx L7900
;                     jsr Sa1e6
;                     ldy #$27
;                     lda #$00
; La1e0               sta ($1c),y
;                     dey
;                     bpl La1e0
;                     rts

; Sa1e6               lda utils.hgrLow,x
;                     sta $1c
;                     lda utils.hgrHigh,x
;                     sta $1d
;                     rts

Sa1f1
		    drawSprite #$4f:#25:#16
                    rts

Sa1fb
		    drawSprite #$50:#48:#16
                    rts

Sa205               ldx #$0c
                    stx L7902
                    ldx #$f1
                    stx L7901
La20f               jsr Sa230
                    lda L7902
                    eor #$1c
                    sta L7902
                    inc L7901
                    inc L7901
                    jsr Sa230
                    ldx #$40
                    jsr waitAndExitOnEvent2
                    ldx L7901
                    cpx #$19
                    bne La20f
                    rts

Sa230               ldx L7901
                    lda L7902
                    ldy #$32
                    jsr spritelib.drawSprite
                    rts

Sa23c
                    drawSprite #$51:#20:#42
                    rts

runAnimVolta
		ldx #$00
		stx L7903
		jsr animVolta
La24e
		jsr animVolta
		inc L7903
		jsr animVolta
		ldx #$12
		jsr waitAndExitOnEvent2
		ldx L7903
		cpx #$1f
		bne La24e
		rts

animVolta
		ldx L7903
		drawSprite animVoltaSpriteIDs,x : $62 : $31
		rts

Sa272
		drawSprite #$52:#$5A:#29
		rts

Sa27c               ldx #$f0
                    stx L7904
                    ldx #$47
                    stx L7905
La286               jsr Sa2ad
                    inc L7904
                    inc L7904
                    jsr Sa2ad
                    ldx L7904
                    cpx #$40
                    beq La2a1
                    ldx #$40
                    jsr waitAndExitOnEvent2
                    jmp La286

La2a1      	jsr Sa2ad
		ldx #$48
		stx L7905
		jsr Sa2ad
		rts

Sa2ad
		drawSprite L7905:L7904:#60
		rts

Sa2b9
		drawSprite #$53:#$3a:#$54
		rts

Sa2c3
		drawSprite #$54:#$2e:#$10
		rts

; $A2CD
.function displayHelpObj {

		.define spriteList
		- { id: $55, x: $0d, y: $30, name:"text key"}
		- { id: $27, x: 15, y: 60, name:"img key"}
		- { id: $57, x: $31, y: $27, name:"text locked door"}
		- { id: $5C, x: $3A, y: $3C, name:"img locked door"}
		- { id: $58, x: $59, y: $27, name:"text unlocked door"}
		- { id: $5d, x: $67, y: $3C, name:"img unlocked door"}
		- { id: $59, x: $25, y: $64, name:"text gem"}
		- { id: $28, x: $28, y: $6e, name:"img gem"}
		- { id: $5a, x: $53, y: $5b, name:"text gem holder"}
		- { id: $56, x: $5b, y: $6d, name:"img gem holder"}
		- { id: $5b, x: $2e, y: $88, name:"text extra sword"}
		- { id: $1e, x: $40, y: $9b, name:"img extra sword"}
		.end

		.for sprite of spriteList
		drawSprite #sprite.id : #sprite.x : #sprite.y
		jsr waitAndExitOnEvent
		.end

		rts

}

waitAndExitOnEvent
		ldx L7906
waitAndExitOnEvent2
!       	lda #$18
		jsr utils.WAIT
		jsr exitOnEvent2
		dex
		bne !-
		rts

checkUserInput
		lda #$ff
		jsr utils.WAIT
		jsr exitOnEvent2
		dex
		bne checkUserInput
		rts

Sa379               ldx #$00
La37b               lda highScore,x
                    cmp playerScore,x
                    bcc La38b
                    bne La38a
                    inx
                    cpx #$05
                    bne La37b
La38a               rts

La38b               ldx #$04
La38d               lda playerScore,x
                    sta highScore,x
                    dex
                    bpl La38d
                    rts

; A397
		.include "animConanJump.asm"

; draw highscore
drawHiScore
		    drawSprite #$4c : #$28 : #$8c ; hi-sc
		    drawSprite #$4d : #$3b : #$8c ; ore :
                    jsr drawHSvalue
                    rts

drawHSvalue         ldx #$4b ; x pos
                    stx L7908
                    ldy #$8c ; y pos
                    sty L7909
                    ldx #$00
                    stx L790A ; digits count
La48a               ldx L790A
                    jsr Sa4a0
                    inc L790A
                    ldx L790A
                    cpx #$05 ; 5 digits
                    bne La48a
                    lda #$0a
                    jsr Sa4a9
                    rts

Sa4a0               lda highScore,x
                    cmp #$00
                    bne Sa4a9
                    lda #$0a
Sa4a9               ldx L7908 ; x pos
                    ldy L7909 ; y pos
                    jsr spritelib.drawSprite ; draw sprite
                    lda L7908 ; x pos
                    clc
                    adc #$04 ; add char sprte width
                    sta L7908 ; x pos
                    rts

; A4BC
exitOnEvent         jsr Sa4c4
                    bcc La4c3
                    pla
                    pla
La4c3               rts

Sa4c4               lda sys.KBD
                    bmi La4da
                    ldy sys.BUTNO
                    bpl La4e0
                    ldy sys.BUTN1
                    bmi La4e0
                    ldy #$ff
                    sty inputMode
                    lda #$00
La4da               cmp #$9e
                    beq La4ec
                    sec
                    rts

La4e0               clc
                    rts

; A4E2
exitOnEvent2        jsr Sa4c4
                    bcc La4c3
                    pla
                    pla
                    pla
                    pla
                    rts

La4ec               jsr utils.clearScreen
                    ldx #$12
                    ldy #$10
                    lda #$5e ; special thanks
                    jsr spritelib.drawSprite

                    bit sys.KBDSTRB
                    ldx #$40
La4fd               lda #$ff
                    jsr utils.WAIT
                    dex
                    bne La4fd

                    jsr drawTitleBitmap

                    ldx #$00
                    stx isSpringRunning
                    jmp mainLoop
