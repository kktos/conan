;
; disk 5000-5FFF
;

		  * = 1000
L1001 = * + 1		
L1002 = * + 2		
L1000			jmp L108c
			
L1004 = * + 1		
L1003			lda $c000
				bpl L1003
				jmp L102d
			
L100b			bit $c010
				stx $1c
				ldx #$3e
				stx $1d
				ldy #$00
				sta ($1c),y
				lda ($22),y
				dex
				bne L1003
				dec $1b
				inc $1b
				ldx $1d
				cpx #$3d
				bne L1003
				bit $c030
				bit $c030
L102d			jmp L108c
			
L1030			jsr drawScore
				rts
			
L1034			jsr S1dbe
				rts
			
S1038			jsr S1ddb
				rts
			
L103c			jsr S1df8
				rts
			
L1040			jsr L1030
				jsr L1030
				jsr L1030
				jsr L1030
				jsr L1030
				rts
			
L1050			jsr L1034
				jsr L1034
				jsr L1040
				rts
			
L105a			jsr L1034
				jsr L1034
				jsr L1034
				jsr L1034
				jsr L1034
				rts
			
L106a			jsr L105a
				jsr L1050
				rts
			
L1071			jsr S1038
				jsr S1038
				jsr L105a
				rts
				
S107b			txa
L107c			ldx $0380
				pha
				lda $c020,x
				pla
L1084			tax
L1085			dex
				bne L1085
				dey
				bne L107c
				rts
			
L108c			jsr L1a00

L108f			ldx #$00
				jsr loadLevel
				
				; anim conan jump / high score
				jsr LA000
			
L1097			jsr S1d40
				jsr S1a11
				jsr S18ab
			
L10a0			jsr LA000
				ldx #$00
				stx $0383
				jsr S1d7f
				jsr S179e
				jsr S1891

				jsr readUserInput

				jsr S1160
				jsr S141e
				jsr S1593
				jsr S1e5c
				jsr S18fa
				jsr S193a
				jsr S1b63
				jsr S1cb0
				jsr S1d88

				jsr S1e41
				
				jmp L10a0
				
readUserInput	lda $c000
				sta keypressed

				cmp $038b ; D3/53/S
				beq L1154

				cmp keyPause ; 9B/1B/esc
				beq onKeyPause ; pause

				cmp keyRestart ; 8D/0D/return
				beq onKeyRestart ; restart level

				cmp $038c
				beq L1142 ; joystick only

				cmp $038d
				beq L114b ; keyboard only

				cmp keyLeft ; 88/08/left arrow
				bne L10fc

				bit $c010

L10fc			cmp keyRight ;95/15/right arrow
				bne L1104

				bit $c010
L1104			jsr readJoystick
				rts

; 1108			  
onKeyRestart		jsr S1e23
				bit $c010
				jmp L1097
			
L1111			bit $c010
				bit $c050
				bit $c052
				bit $c057
				bit $c054
				jmp L108f

; 1123			  
onKeyPause		bit $c010
L1126			lda $c000
				sta keypressed
				bmi L1139
				ldx inputMode ; 01:kbd ff:joystick
				bpl L1126 ; if kbd

				lda $c061
				bpl L1126
				rts
			
L1139			cmp keyPause ; 9B/1B/esc
				bne onKeyPause
				bit $c010
				rts
			
L1142			ldx #$ff ; input = joystick
				stx inputMode
				bit $c010
				rts
			
L114b			ldx #$01 ; input = keyboard
				stx inputMode
				bit $c010
				rts
			
L1154			bit $c010
				lda $0380
				eor #$10
				sta $0380
				rts
			
S1160			ldx playerDeadAnimIdx
				beq L1168
				jmp L198f
			
L1168			ldx $0314
				beq L1170
				jmp L15ab
			
L1170			ldx $0315
				beq L1178
				jmp S1381
			
L1178			ldx $031f
				beq L1180
				jmp L13e5
			
L1180			ldx $0309
				beq L1188
				jmp L1553
			
L1188			ldx playerAxeState ; 00:off / FF: on / 01:back to player
				bpl L1190
				jmp L1702
			
L1190			jsr S11a3
				jsr S134e
				jsr S135d
				jsr S1233
				jsr S129c
				jsr drawNewSprite
				rts
			
S11a3			ldx $0378
				bne L11fd
				ldx keypressed
				bpl L11fd
				cpx keyPause
				beq L11fd
				cpx keyLeft
				bne L11bd
				bit $c010
				jmp L11fe
			
L11bd			cpx keyRight
				bne L11c8
				bit $c010
				jmp L1204
			
L11c8			cpx keyUp
				bne L11d0
				jmp onKeyUp
			
L11d0			cpx keyDown
				bne L11d8
				jmp onKeyDown
			
L11d8			nop
				cpx keyAxe
				bne L11e4
				bit $c010
				jmp onKeyAxe
			
L11e4			cpx keyJump
				bne L11ef
				bit $c010
				jmp onKeyJump
			
L11ef			ldx #$00
				stx $0306
				stx $0307
				stx keypressed
				bit $c010
L11fd			rts
			
L11fe			jsr S120a
				bcc L121d
				rts
			
L1204			jsr S120a
				bcc L1228
				rts
			
S120a			ldx $031f
				bne L121b
				ldx $0309
				bne L121b
				ldx $0314
				bne L121b
				clc
				rts
			
L121b			sec
				rts
			
L121d			dec $0306
				ldx $0306
				cpx #$fd
				beq L1228
				rts
			
L1228			inc $0306
				ldx $0306
				cpx #$03
				beq L121d
				rts
			
S1233			ldx $0309
				beq L123f
				ldx $0333
				stx spriteIDNew
				rts
			
L123f			ldx $031f
				bne L128b
				lda $0306
				beq L1275
				ror a
				bcs L1256
				lda $030a
				cmp #$03
				bne L1256
				dec $030a
L1256			lda $030a
				cmp #$01
				bne L1262
				ldx #$04
				stx $030a
L1262			lda $030a
				ldy $0308
				bmi L126d
				clc
				adc #$04
L126d			tax
				lda keypressed,x
				sta spriteIDNew
				rts
			
L1275			ldx #$04
				stx $030a
				ldy $0308
				bmi L1285
				ldx #$0c
				stx spriteIDNew
				rts
			
L1285			ldx #$0b
				stx spriteIDNew
				rts
			
L128b			ldx $0308
				bmi L1296
				ldx #$10
				stx spriteIDNew
				rts
			
L1296			ldx #$0e
				stx spriteIDNew
				rts
			
S129c			lda spriteX
				clc
				adc $0306
				sta spriteXNew
				lda spriteY
				clc
				adc $0307
				sta spriteYNew
				jsr S1681
				rts
			
drawNewSprite	lda $0306
				bne L12d0
				lda $0307
				bne L12d0
				lda $0309
				bne L12cf
				lda spriteID
				cmp #$0d
				bcs L12d0
				cmp spriteIDNew
				bne L12d0
L12cf			rts
			
L12d0			lda spriteID ; clear current sprite
				ldx spriteX
				ldy spriteY
				jsr drawSpriteM
				
				ldx #$00
				stx $b3f6
				lda spriteIDNew ; get new sprite info
				sta spriteID
				ldx spriteXNew
				stx spriteX
				ldy spriteYNew
				sty spriteY
				jsr drawSpriteM
				rts
			
S12f7			ldx $037e
				beq L1312
				stx spriteX
				stx spriteXNew
				ldy #$00
				sty $037e
				ldy #$e0
				sty spriteY
				sty spriteYNew
				jmp L1324
			
L1312			ldx $ad80
				stx spriteX
				stx spriteXNew
				ldy $ad81
				sty spriteY
				sty spriteYNew

L1324			lda $ad83
				sta $0308
				lda $ad82
				sta spriteID
				sta spriteIDNew
				jsr drawSpriteM

				ldx #$00
				stx $0306
				stx $0307
				stx $0309
				stx $031f
				stx $031e
				stx $0314
				stx $0315
				rts
			
S134e			ldx $0306
			cpx #$01
			beq L1359
			cpx #$ff
			bne L135c
L1359			stx $0308
L135c			rts
			
S135d			dec $030a
			bne L1367
			ldx #$04
			stx $030a
L1367			lda $030a
			asl a
			asl a
			tax
			lda $0306
			beq L1377
			ldy #$10
			jsr S107b
L1377			rts
			
L1378			sty $0377
			lda #$90
			jsr $fca8
			rts
			
S1381			jsr S129c
			ldx $0314
			beq L13a3
			jsr S15ca
			bcs L13a3
			ldx $0308
			bmi L139b
			ldx #$10
			stx spriteIDNew
			jmp L13b5
			
L139b			ldx #$0e
			stx spriteIDNew
			jmp L13b5
			
L13a3			lda $0316
			ldx $0308
			bmi L13ae
			clc
			adc #$08
L13ae			tax
			lda $0322,x
			sta spriteIDNew
L13b5			jsr drawNewSprite
			jsr S15fe
			jsr S1953
			bcc L13c5
			dec $0316
			bne L13cf
L13c5			ldx #$00
			stx $0315
			ldx #$08
			stx $0316
L13cf			rts

; 13D0			  
onKeyJump		inc $031f
			lda $0307
			sec
			sbc #$05
			sta $0307
			ldx #$01
			stx $0321
			stx $0383
			rts
			
L13e5			jsr S129c
			jsr S1233
			ldx $0321
			bmi L13fc
			inc $0315
			dec $0321
			dec $0321
			jmp L1414
			
L13fc			ldx #$00
			stx $031f
			ldx #$04
			stx $030a
			jsr S1953
			bcc L1414
			inc $0314
			inc $0315
			jmp S1381
			
L1414			jsr S1953
			jsr drawNewSprite
			jsr S15fe
			rts
			
S141e			ldx $0309
			bne L1440
			ldx $0314
			bne L1433
			ldx $0315
			bne L1433
			ldx $031f
			bne L1433
			rts
			
L1433			inc $0307
			ldx $0307
			cpx #$06
			bne L1440
			dec $0307
L1440			rts
			
S1441			ldx $0307
			bmi L1485
			ldx #$ff
			stx $0322
L144b			inc $0322
			ldx $0322
			lda LAC40,x
			beq L1485
			lda spriteXNew
			cmp LAC00,x
			bcc L144b
			cmp LAC20,x
			beq L1465
			bcs L144b
L1465			lda LAC40,x
			clc
			adc #$03
			cmp spriteYNew
			bcc L144b
			sec
			sbc $0307
			sec
			sbc #$03
			cmp #$f8
			bcs L1480
			cmp spriteYNew
			bcs L144b
L1480			stx $0379
			clc
			rts
			
L1485			sec
			rts

; 1487			  
onKeyUp 		ldx $0309
			beq L149d
			ldx #$fe
			stx $0307
			rts
			
; 1492			  
onKeyDown		ldx $0309
			beq L14b3
			ldx #$02
			stx $0307
			rts
			
L149d			jsr S14ca
			bcc L14b2
			ldx $0317
			bpl L14b2
			ldx #$fe
			stx $0307
			inc $0309
			jmp L1553
			
L14b2			rts
			
L14b3			jsr S14ca
			bcc L14b2
			ldx $0317
			bmi L14b2
			beq L14b2
			ldx #$02
			stx $0307
			inc $0309
			jmp L1553
			
S14ca			ldx #$ff
			stx $0322
L14cf			inc $0322
			ldx $0322
			lda LAC60,x
			beq L1543
			lda LACA0,x
			tay
			dey
			dey
			cpy spriteX
			beq L14f4
			iny
			cpy spriteX
			beq L14f4
			iny
			cpy spriteX
			beq L14f4
			jmp L14cf
			
L14f4			lda LAC60,x
			cmp spriteY
			beq L1527
			bcs L14cf

			lda LAC80,x
			cmp spriteY
			beq L1535
			bcc L14cf

			lda LACA0,x
			sta spriteXNew
			ldx spriteY
			stx spriteYNew
			ldx spriteID
			stx spriteIDNew
			jsr drawNewSprite
			ldx #$00
			stx $0317
			stx $0306
			sec
			rts
			
L1527			ldx #$01
			stx $0317
			dex
			stx $0306
			stx $0307
			sec
			rts
			
L1535			ldx #$ff
				stx $0317
				inx
				stx $0306
				stx $0307
				sec
				rts
			
L1543			clc
				ldx #$00
				stx $0309
				rts
				
S154a			lda $0333
				eor #$01
				sta $0333
				rts
			
L1553			jsr S1575
				jsr S1233
				jsr S129c
				jsr drawNewSprite
				jsr S14ca
				ldx $0307
				beq L156a
				jsr S154a
L156a			ldx $0317
				beq L1574
				ldx #$00
				stx $0309
L1574			rts
			
S1575			ldx keypressed
				bpl L1592

				cpx keyUp
				bne L1582
				jmp onKeyUp
			
L1582			cpx keyDown
				bne L158a
				jmp onKeyDown
			
L158a			ldx #$00
				stx $0306
				stx $0307
L1592			rts
			
S1593			jsr S1441
				bcc L15aa
				ldx $031f
				bne L15aa
				ldx $0309
				bne L15aa
				ldx playerAxeState ; 00:off / FF: on / 01:back to player
				bmi L15aa
				inc $0314
L15aa			rts
			
L15ab			ldx $0315
				bne L15b3
				inc $0315
L15b3			jsr S1381
				jsr S1441
				bcs L15c9
				ldx #$00
				stx $0315
				stx $0314
				stx $031f
				jsr drawNewSprite
L15c9			rts
			
S15ca			ldx #$ff
				stx $0322
L15cf			inc $0322
				ldx $0322
				lda LAC40,x
				beq L15fc
				lda spriteXNew
				cmp LAC00,x
				bcc L15cf
				cmp LAC20,x
				bcs L15cf
				lda LAC40,x
				clc
				adc #$06
				cmp spriteYNew
				bcc L15cf
				sec
				sbc #$10
				cmp spriteYNew
				bcs L15cf
				clc
				rts
			
L15fc			sec
			rts
			
S15fe			ldx $b3f6
			beq L1637
			ldx $031e
			bne L1637
			ldx $0373
			bne L1637
			jsr S164d
			bcs L1637
			jsr S1638
			lda spriteXNew
			sec
			sbc $0306
			sta spriteXNew
			ldx spriteID
			stx spriteIDNew
			jsr drawNewSprite
			ldx #$01
			stx $0314
			dex
			stx $0307
			stx $0306
			inc $031e
L1637			rts
			
S1638			lda spriteX
			sec
			sbc $0306
			sta spriteXNew
			lda spriteY
			sec
			sbc $0307
			sta spriteYNew
			rts
			
S164d			ldx #$ff
			stx $0322
L1652			inc $0322
			ldx $0322
			lda LAC60,x
			beq L167f
			cmp spriteY
			bcs L1652
			lda LAC80,x
			cmp spriteY
			bcc L1652
			lda LACA0,x
			sec
			sbc #$08
			cmp spriteX
			bcs L1652
			clc
			adc #$0b
			cmp spriteX
			bcc L1652
			sec
			rts
			
L167f			clc
			rts
			
S1681			ldx #$ff
			stx $0322
L1686			inc $0322
			ldx $0322
			lda LACF0,x
			beq L16d1
			lda spriteXNew
			cmp LACC0,x
			beq L16a1
			tay
			iny
			tya
			cmp LACC0,x
			bne L1686
L16a1			lda LACF0,x
			cmp spriteYNew
			bne L1686
			lda LACC0,x
			sta spriteXNew
			ldx $0308
			bmi L16ba
			dec spriteXNew
			jmp L16bd
			
L16ba			inc spriteXNew
L16bd			ldx #$00
			stx $0306
			stx $0307
			jsr S1233
			ldx spriteY
			stx spriteYNew
			jsr drawNewSprite
L16d1			rts

; 16D2			  
onKeyAxe	ldx $0309
			bne L1701

			ldx $0314
			bne L1701

			ldx $0315
			bne L1701

			ldx $031f
			bne L1701

			ldx playerAxeState ; 00:off / FF: on / 01:back to player
			bne L1701

			ldx $034d
			bne L16f5

			ldx playerAxeCount
			beq L1701

L16f5		ldx #$ff
			stx playerAxeState ; 00:off / FF: on / 01:back to player
			inx
			stx playerAxeAnim ; 00: normal / 01: axe behind / 02: axe forward
			jsr updAxeCount
L1701		rts
			
L1702		lda playerAxeAnim ; 00: normal / 01: axe behind / 02: axe forward
			cmp #$02
			beq L1739
			ldy $0308
			bmi L1711
			clc
			adc #$02
L1711		tay
			lda $0334,y
			sta spriteIDNew
			lda spriteX
			ldx playerAxeAnim ; 00: normal / 01: axe behind / 02: axe forward
			dex
			bne L1729

			ldy $0308
			bpl L1729
			sec
			sbc #$02

L1729		sta spriteXNew
			ldy spriteY
			sty spriteYNew
			jsr drawNewSprite

			inc playerAxeAnim ; 00: normal / 01: axe behind / 02: axe forward
			rts
			
L1739			ldx #$01
				stx playerAxeState ; 00:off / FF: on / 01:back to player
				lda spriteX
				ldy $0308
				bmi L1754
				ldx #$03
				stx $033a
				clc
				adc #$07
				sta $031a
				jmp L175f
			
L1754			sec
				sbc #$03
				sta $031a
				ldx #$fd
				stx $033a
L175f			lda spriteY
				clc
				adc #$02
				sta $031b
				lda #$1e
				sta $031c
				jsr S1807
				ldx $0308
				stx $031d
				ldx #$08
				stx $0338
				ldx #$01
				stx $0339
				stx playerAxeState ; 00:off / FF: on / 01:back to player
				jsr S1233
				lda spriteX
				ldy $0308
				bpl L1791
				clc
				adc #$02
L1791			sta spriteXNew
				ldx spriteY
				stx spriteYNew
				jsr drawNewSprite
				rts
			
S179e			ldx playerAxeState ; 00:off / FF: on / 01:back to player
				dex
				bpl L17a5
				rts
			
L17a5			jsr S184d
				dec $0338
				beq L17cd
L17ad			lda $031a
				clc
				adc $033a
				sta $031a
				inc $031c
				ldx $031c
				cpx #$21
				bne L17c6
				ldx #$1e
				stx $031c
L17c6			jsr S1807
				jsr S182b
				rts
			
L17cd			inc $0338
				ldx $0339
				bpl L17db
				inc $031b
				jmp L17ad
			
L17db			ldx $031d
				bmi L17ed
				dec $033a
				ldx $033a
				cpx #$fd
				beq L17fa
				jmp L17ad
			
L17ed			inc $033a
				ldx $033a
				cpx #$03
				beq L17fa
				jmp L17ad
				
L17fa			ldx #$08
				stx $0338
				ldx #$ff
				stx $0339
				jmp L17ad
			
S1807			ldx $031a
				ldy #$00
				sty $b3f6
				ldy $031b
				lda $031c
				jsr drawSpriteM
				rts
			
L1819			jsr S184d
				ldx #$00
				stx playerAxeState ; 00:off / FF: on / 01:back to player
				stx playerAxeAnim ; 00: normal / 01: axe behind / 02: axe forward
				stx $031a
				stx $031b
				rts
			
S182b			jsr S1f2d
				ldx $b3f6
				beq L1841
				jsr S1b93
				jsr S185a
				bcs L1841
				jsr $0a50
L183e			jmp L1819
			
L1841			ldx $031a
				cpx #$f0
				bcs L184c
				cpx #$9d
				bcs L183e
L184c			rts
			
S184d			ldx $031a
				ldy $031b
				lda $031c
				jsr drawSpriteM
				rts
			
S185a			ldx #$ff
				stx $0322
L185f			inc $0322
				ldx $0322
				lda LAC60,x
				beq L188f
				lda $031b
				cmp LAC60,x
				bcc L185f
				sec
				sbc #$10
				cmp LAC80,x
				bcs L185f
				lda LACA0,x
				sec
				sbc #$08
				cmp $031a
				bcs L185f
				clc
				adc #$13
				cmp $031a
				bcc L185f
				sec
				rts
			
L188f			clc
				rts
			
S1891			ldx spriteY
				cpx LAD88
				bne L18a7
				ldx spriteX
				cpx LAD87
				beq L18a8
				dex
				cpx LAD87
				beq L18a8
L18a7			rts
			
L18a8			jsr $0a00
S18ab			ldx $037e
				bne L18c1
				ldx level
				stx $037f
L18b6			dec $037f
				bmi L18c1
				jsr S1038
				jmp L18b6
			
L18c1			ldx $037e
				beq L18d9
				ldx #$07
				stx level
				jsr drawDigit
				dec level
				ldx #$07
				jsr drawDigit
				jmp L18e6
			
L18d9			ldx #$07
				jsr drawDigit
				inc level
				ldx #$07
				jsr drawDigit

L18e6			ldx level
				jsr loadLevel

				ldx #$00
				stx playerAxeState ; 00:off / FF: on / 01:back to player
				stx keypressed
				bit $c010
				jmp S12f7
			
;
S18fa			ldx #$ff
				stx $0322
L18ff			inc $0322
				ldx $0322
				lda LAD30,x
				beq L1925
				jsr S1926

				ldx $0322
				inc LAD40,x
				lda LAD40,x
				cmp #$24
				bne L191f
				lda #$21
				sta LAD40,x
L191f			jsr S1926

				jmp L18ff
			
L1925			rts
			
S1926			lda LAD30,x
				tay
				lda LAD20,x
				sta $033b
				lda LAD40,x
				ldx $033b
				jsr drawSprite
				rts

;			
S193a			inc $033c
				lda $033c
				ror a
				bcs L1952
				ror a
				bcs L1952
				ldx LAD84
				ldy LAD85
				lda LAD86
				jsr drawSprite
L1952			rts
			
S1953			jsr S1441
				bcs L1979
				lda LAC40,x
				sta spriteYNew
				inc spriteYNew
				lda spriteX
				clc
				adc $0306
				sta spriteXNew
				jsr S1233
				jsr drawNewSprite
				ldx #$00
				stx $0307
				stx $031e
L1979			rts
			
drawDigit		lda $0345,x
				tay
				lda $033c,x
				tax
				tya
				ldy #$b9
				cmp #$00
				bne L198b
				lda #$0a
L198b			jsr drawSprite
				rts
			
L198f			jsr $0a2d
				ldx playerDeadAnimIdx
				cpx #$08
				bcs L19bd
				jsr S19aa
				inc playerDeadAnimIdx
				ldx playerDeadAnimIdx
				cpx #$08 ; anim player dying: 7 frames
				beq L19a9
				jsr S19aa
L19a9			rts
			
S19aa			ldx playerDeadAnimIdx
				lda playerDeadAnimIdx,x
				sta spriteID
				ldx spriteX
				ldy spriteY
				jsr drawSpriteM
				rts
				
L19bd			inc playerDeadAnimIdx
				ldx playerDeadAnimIdx
				cpx #$18
				beq L19c8
				rts
			
L19c8			jsr updLifeCount
				jsr S12f7
				ldx #$00
				stx playerDeadAnimIdx
				ldy playerAxeState ; 00:off / FF: on / 01:back to player
				bpl L19db
				stx playerAxeState ; 00:off / FF: on / 01:back to player
L19db			bit $c010
				rts
			
updLifeCount	ldx #$06
				jsr drawDigit
				dec playerLifeCount ; cheat
				bmi L19ef
				ldx #$06
				jsr drawDigit
				rts
			
L19ef			inc playerLifeCount
				ldx #$06
				jsr drawDigit
				jsr S1e23
				jsr S1c6b
				jmp L108f
			
L1a00			ldx #$09
				stx $0322
L1a05			ldx $0322
				jsr drawDigit
				dec $0322
				bne L1a05
				rts
			
S1a11			jsr L1a00
				ldx #$00
				stx $0346
				stx $0347
				stx $0348
				stx $0349
				stx $034a
				stx playerAxeCount
				stx level
				inx
				stx $034d
				inx
				stx playerLifeCount
				jsr L1a00
				rts
			
loadLevel		stx $0381
				lda #$00
L1a3c			dex
				bmi init2
				clc
				adc #$06
				jmp L1a3c
			
; load welcome screen
; 1A45
init2			sta rangeIdx
				tay

				;
				; R0 : background image
				;
				; L0:12 T00S1-8 / M7500-7CFF
				; L1:	T03SE-T04S5 / M7500-7CFF
				; L2:	T05SB-T06S4 / M7500-
				; L3:	T07SF-T08S5 / M7500-
				; L4:	T0BS1-T0BS5 / M7500-
				; L5:	T0ES7-T0FS5 / M7500-
				; L6:	T12S0-T12S5 / M7500-
				; L7:	T15S7-T16S5 / M7500-
				; L8:	T19SC-T1AS5 / M7500-
				; L9:	T1ASF-T00S0 / M7500-
				ldx #$75
				stx rwts.hibuf
				jsr loadRange

				; unpack & display
				jsr unpackToHgr

				inc rangeIdx
				ldy rangeIdx

				;
				; R1 : data (anim?, sprites)
				;
				; L0:13 T0S9-C / M7500-78FF
				; L1:	T4S6 / M7500-75FF
				; L2:	T6S5 / M7500-75FF
				ldx #$75
				stx rwts.hibuf
				jsr loadRange

				inc rangeIdx
				ldy rangeIdx

				;
				; R2 : data
				;
				; L0:14 T0SD/ M7900-79FF
				; L1:	T4S7/ M7900-79FF
				; L2:	T6S6/ M7900-79FF
				ldx #$79
				stx rwts.hibuf
				jsr loadRange

				inc rangeIdx
				ldy rangeIdx

				;
				; R3 : data
				;
				; L0:15 T0SE-T2SF / M7A00-9BFF
				; L1:	T4S8-T4SF / M7A00-81FF
				; L2:	T6S7-T7S6 / M7A00-89FF
				ldx #$7a
				stx rwts.hibuf
				jsr loadRange

				inc rangeIdx
				ldy rangeIdx

				;
				; R4 : code
				;
				; L0:16 T3S0-T3SB / MA000-ABFF
				; L1:	T5S0-T5S8 / MA000-A7FF
				; L2:	T7S7-T7SC / MA000-A5FF
				ldx #$a0
				stx rwts.hibuf
				jsr loadRange

				inc rangeIdx
				ldy rangeIdx

				;
				; R5 : data
				;
				; L0: T3SC-T3SD / MAC00-ADFF
				; L1: T5S9-T5SA / MAC00-ADFF
				; L2: T7SD-T7SE / MAC00-ADFF
				ldx #$ac
				stx rwts.hibuf
				jsr loadRange
				rts

; L1A9B 		   
unpackToHgr		ldx #$00
				stx $1c
				stx Xpos
				stx Ypos
				ldx #$75 ; packed img at $7500
				stx $1d

L1aa9			jsr S1ab6
				cmp #$fe
				beq L1b03
				jsr S1ac5
				jmp L1aa9
			
S1ab6			ldy #$00
				lda ($1c),y
				jsr S1abe
				rts
			
S1abe			inc $1c
				bne L1ac4
				inc $1d
L1ac4			rts
			
S1ac5			sta $0369
				jsr S1ad5
				lda $0369
				ldy #$00
				sta ($1a),y
				jmp L1ae7
			
S1ad5			ldx Ypos
				lda hgrHi,x
				sta $1b
				lda hgrLo,x
				clc
				adc Xpos
				sta $1a
				rts
			
L1ae7			inc Ypos
				ldx Ypos
				cpx #$b7
				bne L1b02
				ldx #$00
				stx Ypos
				inc Xpos
				ldx Xpos
				cpx #$28
				bne L1b02
				pla
				pla
L1b02			rts
			
L1b03			jsr S1ab6
				sta $0367
				jsr S1ab6
				sta $0368
L1b0f			lda $0367
				jsr S1ac5
				dec $0368
				bne L1b0f
				jmp L1aa9
			
; 1B1D
readSector		ldx track
				stx rwts.trk
				ldx sector
				stx rwts.sec
				ldx #$00
				stx rwts.vol
				stx $48
				ldy #$e8
				lda #$b7
				jsr rwts
				rts
			
updAxeCount		ldx #$09
				jsr drawDigit
				dec playerAxeCount ; cheat
				bmi L1b48
				ldx #$09
				jsr drawDigit
				rts
			
L1b48			ldx #$09
				stx playerAxeCount
				jsr drawDigit
				ldx $034d
				beq L1b62
				ldx #$08
				jsr drawDigit
				dec $034d
				ldx #$08
				jsr drawDigit
L1b62			rts
			
S1b63			jsr S1441
				bcs L1b69
				rts
			
L1b69			ldx spriteX
				cpx #$f0
				bcs L1b7c
				cpx #$89
				bcc L1b92
				ldx #$88
				stx spriteXNew
				jmp L1b81
			
L1b7c			ldx #$00
				stx spriteXNew
L1b81			ldx spriteID
				stx spriteIDNew
				jsr drawNewSprite
				ldx #$00
				stx $0306
				stx $0307
L1b92			rts
			
S1b93			ldx playerDeadAnimIdx
				bne L1b92
				lda spriteX
				sec
				sbc #$05
				cmp $031a
				bcs L1b92
				clc
				adc #$0c
				cmp $031a
				bcc L1b92
				lda spriteY
				sec
				sbc #$03
				cmp $031b
				bcs L1b92
				clc
				adc #$11
				cmp $031b
				bcc L1b92
				jsr S1bca
				jsr L1819
				jsr L0AD7
				pla
				pla
				rts
			
S1bca			ldx #$09
				jsr drawDigit
				inc playerAxeCount
				ldx playerAxeCount
				cpx #$0a
				beq L1bdf
				ldx #$09
				jsr drawDigit
				rts
			
L1bdf			ldx #$00
				stx playerAxeCount
				ldx #$09
				jsr drawDigit
				ldx #$08
				jsr drawDigit
				inc $034d
				ldx #$08
				jsr drawDigit
				rts
			
S1bf7			jsr S1bfe
				jsr S1c20
				rts
			
S1bfe			ldx #$3b
				stx $0374
L1c03			jsr S1c11
				inc $0374
				ldx $0374
				cpx #$7e
				bne L1c03
				rts
			
S1c11			jsr S1c5d
				ldy #$0c
				lda #$00
L1c18			sta ($1a),y
				iny
				cpy #$1c
				bne L1c18
				rts
				
S1c20			ldx #$00
				stx $1c
				ldx #$75
				stx $1d
				ldx #$41
				stx $0374
L1c2d			jsr S1c3b
				inc $0374
				ldx $0374
				cpx #$79
				bne L1c2d
				rts
			
S1c3b			jsr S1c5d
				ldy #$0d
				sty $0375
L1c43			ldy #$00
				lda ($1c),y
				ldy $0375
				sta ($1a),y
				inc $1c
				bne L1c52
				inc $1d
L1c52			inc $0375
				ldy $0375
				cpy #$1c
				bne L1c43
				rts
			
S1c5d			ldx $0374
				lda hgrLo,x
				sta $1a
				lda hgrHi,x
				sta $1b
				rts
			
S1c6b			jsr S1e97
				and #$03
				asl a
				asl a
				sta rwts.sec
				lda level
				clc
				adc #$1a
				sta rwts.trk
				ldx #$75
				stx rwts.hibuf
				ldx #$00
				stx rwts.lobuf
				jsr S1f0d
				jsr S1bf7
				bit $c010
				ldy #$60
L1c93			lda #$ff
				jsr $fca8
				lda $c000
				bmi L1ca5
				jsr S1e4e
				bcs L1ca5
				dey
				bne L1c93
L1ca5			bit $c010
				cpy #$00
				beq L1caf
				jmp L1097
			
L1caf			rts
			
S1cb0			inc $037a
				lda $037a
				adc $7900
				adc $0349
				sta $037a
L1cbf			rts
			
readJoystick	ldx inputMode ; 01:kbd ff:joystick
				bpl L1cbf ; if kdb

				ldx $0309
				beq L1ccf
				ldx #$00
				jmp L1d01
			
L1ccf			ldx $c061
				bmi L1d16
				ldx playerAxeState ; 00:off / FF: on / 01:back to player
				bne L1cde
				ldx $c062
				bmi L1d1d
L1cde			ldx #$fe
				lda $037c
				cmp #$10
				bcc L1cf7
				inx
				cmp #$40
				bcc L1cf7
				inx
				cmp #$c0
				bcc L1cf7
				inx
				cmp #$f0
				bcc L1cf7
				inx
L1cf7			cpx $0306
				beq L1d01
				bmi L1d32
				jmp L1d39
			
L1d01			ldy $037d
				cpy #$30
				bcc L1d24
				cpy #$d0
				bcs L1d2b
				cpx #$00
				bne L1d15
				ldx #$ff
				stx keypressed
L1d15			rts
			
L1d16			ldx keyJump
				stx keypressed
				rts
			
L1d1d			ldx keyAxe
				stx keypressed
				rts
			
L1d24			ldx keyUp
				stx keypressed
				rts
			
L1d2b			ldx keyDown
				stx keypressed
				rts
			
L1d32			ldx keyLeft
				stx keypressed
				rts
			
L1d39			ldx keyRight
				stx keypressed
				rts
			
S1d40			bit $c010
				ldx #$00
				stx playerDeadAnimIdx
				stx $031e
				stx $031f
				stx playerAxeState ; 00:off / FF: on / 01:back to player
				stx $0314
				stx $0315
				stx $0309
				stx $0306
				stx $0307
				ldx $036e
				beq L1d6f
				ldx #$01
				jsr S1d91
				ldx #$00
				stx $036e
L1d6f			ldx $036f
				beq L1d7e
				ldx #$02
				jsr S1d91
				ldx #$00
				stx $036f
L1d7e			rts
			
S1d7f			ldx #$00
				jsr $fb1e
				sty $037c
				rts
			
S1d88			ldx #$01
				jsr $fb1e
				sty $037d
				rts
			
S1d91			txa
				tay
				lda $036a,y
				tax
				tya
				clc
				adc #$26
				ldy #$b9
				jsr drawSprite
				rts
			
drawScore		ldx #$05
				jsr drawDigit
				ldx #$05
				inc $034a
				ldy $034a
				cpy #$0a
				beq L1db6
				jsr drawDigit
				rts
			
L1db6			lda #$00
				sta $034a
				jsr drawDigit
S1dbe			ldx #$04
				jsr drawDigit
				ldx #$04
				inc $0349
				ldy $0349
				cpy #$0a
				beq L1dd3
				jsr drawDigit
				rts
			
L1dd3			lda #$00
				sta $0349
				jsr drawDigit
S1ddb			ldx #$03
				jsr drawDigit
				ldx #$03
				inc $0348
				ldy $0348
				cpy #$0a
				beq L1df0
				jsr drawDigit
				rts
			
L1df0			lda #$00
				sta $0348
				jsr drawDigit
S1df8			ldx #$02
				jsr drawDigit
				ldx #$02
				inc $0347
				ldy $0347
				cpy #$0a
				beq L1e0d
				jsr drawDigit
				rts
			
L1e0d			lda #$00
				sta $0347
				jsr drawDigit
				ldx #$01
				jsr drawDigit
				inc $0346
				ldx #$01
				jsr drawDigit
				rts
			
S1e23			ldx #$00
L1e25			lda highScore,x
				cmp $0346,x
				bcc L1e35
				bne L1e34
				inx
				cpx #$05
				bne L1e25
	L1e34			rts
			
L1e35			ldx #$04
L1e37			lda $0346,x
				sta highScore,x
				dex
				bpl L1e37
L1e40			rts
			
S1e41			ldx level
				cpx #$09
				bne L1e40
				dec level
				jmp L1111
			
S1e4e			lda inputMode ; 01:kbd ff:joystick
				bpl L1e5a ; if kbd

				lda $c061
				bpl L1e5a
				sec
				rts
			
L1e5a			clc
L1e5b			rts
			
S1e5c			ldx playerAxeState ; 00:off / FF: on / 01:back to player
				dex
				bmi L1e5b
				lda $0339
				bpl L1e70
				lda #$09
				sec
				sbc $0338
				jmp L1e73
			
L1e70			lda $0338
L1e73			asl a
				asl a
				sta $0382
L1e78			lda #$02
L1e7a			ldy $0382
				ldx $0380
L1e80			cmp $c020,x
				dey
				bne L1e80
				sec
				sbc #$01
				bne L1e7a
				lda $0382
				sec
				sbc #$01
				sta $0382
				bne L1e78
				rts
			
S1e97			rol $4e
				rol $037a
				rol $0371
				lda $4e
				asl a
				eor $4f
				eor $0371
				rol a
				rol a
				rol a
				rol a
				rol a
				pha
				rol $4f
				lda $4f
				eor $037a
				sta $4e
				pla
				sta $0371
				adc $4e
				adc $037a
				sta $0372
				rts
; 1EC3			
loadRange		lda L0900,y
				sta track
				lda L0980,y
				sta sector
				iny
				lda L0900,y
				sta trackend
				lda L0980,y
				sta sectorend
				ldx #$00
				stx rwts.lobuf
			; check if ptrs =. exit of true
L1ee1			ldx sector
				cpx sectorend
				bne L1ef2
				ldx track
				cpx trackend
				bne L1ef2
				rts
			
L1ef2			jsr readSector
				inc rwts.hibuf
				inc sector
				ldx sector
				cpx #$10
				bne L1ee1
				ldx #$00
				stx sector
				inc track
				jmp L1ee1
			
S1f0d			jsr S1f1e
				inc rwts.hibuf
				inc rwts.sec
				ldx rwts.sec
				cpx #$10
				bne S1f0d
				rts
			
S1f1e			ldx #$00
				stx rwts.vol
				stx $48
				ldy #$e8
				lda #$b7
				jsr rwts
L1f2c			rts
			
S1f2d			ldx playerDeadAnimIdx
				bne L1f2c
				lda spriteX
				sec
				sbc #$02
				cmp $031a
				bcs L1f2c
				clc
				adc #$04
				cmp $031a
				bcc L1f2c
				lda spriteY
				sec
				sbc #$03
				cmp $031b
				bcs L1f2c
				clc
				adc #$11
				cmp $031b
				bcc L1f2c
				jsr S1bca
				jsr L1819
				jsr L0AD7
				pla
				pla
				rts
L1f64			 
	c2 ce c5 a0 ce cf d7 c9 ce 8d a0 cc 
	c4 d8 a0 a4 b3 b0 b0 8d a0 c3 d0 d8 a0 a4 c1 c4 
	b8 b7 8d a0 c2 c5 d1 a0 d7 c9 ce cc c5 d6 8d a0 
	c4 c5 d8 8d a0 c3 d0 d8 a0 a4 c1 c4 b8 b7 8d a0 
	c2 c5 d1 a0 d7 c9 ce cc c5 d6 8d ce cf d7 c9 ce 
	a0 d2 d4 d3 8d d7 c9 ce cc c5 d6 a0 ca d3 d2 a0 
	d7 c9 ce d3 cf d5 8d cc c5 d6 c5 cc a0 cc c4 d8 
	a0 a4 b3 b7 c5 8d a0 c2 ce c5 a0 c5 ce c4 c2 cf 
	ce d5 d3 8d a0 cc c4 d8 a0 a4 b3 b4 c3 8d a0 d3 
	d4 d8 a0 a4 b3 b7 c6 8d c2 cf ce d5 d3 cc cf a0 

2000		  .END
