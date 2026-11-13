;
; level 7 variables, disk chunk c2 ($7900-$79FF)
; private RAM of the level code, initial values from the disk.
; tables indexed from 1 are used as table-1,x.
;

		placeAt	$7900

sparkPos	.db	$01, $10, $20, $2C	; the 4 sparks: step in sparkX/Y, 0..$34
orbPos		.db	$08, $0F		; the 2 orbs: step in orbX/Y, 0..$0F
idx		.db	$00			; loop index: 3..0 over the sparks, 1..0 over the orbs
flag1Frame	.db	$02			; 0..3, added to SHAPE_FLAG at ($00,$0A)
flag2Frame	.db	$00			; 0..3, added to SHAPE_FLAG at ($0A,$0F)
dotX		.db	$07			; 7 down to 3: X of the dot at Y $2E
toggle		.db	$00			; 0 / 1, flipped every frame, not read
flameTimer	.db	$10			; frames before the flame changes (random 8..15); it flickers under 6
flameFrame	.db	$00			; 0 / 2, added to the flame shapes
leverOn		.db	$00			; the lever is armed: the catapult works
gemStep		.db	$80			; the gem coming to the figure: step in gemPathX/Y 0..$17, < 0 waiting
splashX		.db	$00			; where the player fell
splashFrame	.db	$00			; 1..8 in splashShapes, 0 = none
splashShapes	.db	$62, $63, $64, $65, $65, $64, $63, $62
splashY		.db	$00			; $4F in the pit under the bridge, $A1 in the bottom left corner
bridgeOn	.db	$00			; the bridge at the left is there (ledge BRIDGE_LEDGE)
bridgeTimer	.db	$30			; frames before it comes or goes (random 0..$7F); also its tone
bridgeShape	.db	$54			; $54 / $55, flickering
leverDrawn	.db	$00			; 0 / 1: the lever's blink is on the screen
prisonerFrame	.db	$00			; 0 / 1, added to SHAPE_PRISONER
prisonerTimer	.db	$10			; frames before it changes (random 0..$1F)
throwStep	.db	$00			; the figure throwing: 1..$0C, 0 = not
throwDelay	.db	$01			; frames before the next throwStep (2)
shot		.db	$00			; the shot being updated, 3..0
landY		.db	$B3			; a falling gem's Y when it lands
nextBatX	.db	$A0			; the next bat walking to the door: X $A0 down to $84, Y $98
nextBatShape	.db	$42			; $42 / $43
nextBatWaitX	.db	$00			; its X once it waits at the door ($84), 0 = none
batX		.db	$00			; the bat flying
batY		.db	$00
batShape	.db	$00			; 0 = none
batStep		.db	$00			; step in its route, $FF = dying
batTime		.db	$00			; frames left in the step
batDX		.db	$00
batDY		.db	$00
batRoute	.db	$00			; 0..3
gemWait		.db	$80			; gemStep's next start (- frames to wait), +6 per throw, up to $F2
batDieShapes	.db	$66, $66, $67		; the bat falling, by batDieFrame
batDieFrame	.db	$00			; 0..2
doorTimer	.db	$00			; frames before the door goes ($10)
gemsGiven	.db	$00			; gems given to the figure, 3: the end
handEmpty	.db	$69			; not 0: the figure's hand isn't drawn (from the throw to the next gem)
inPlay		.db	$00			; gems coming + shots out, 0..4

; $7938-$793F: not referenced, leftover memory from an align
		.align	$10

; the gem coming to the figure, by gemStep 0..$17
gemPathX	.db	$FC, $FD, $FE, $FF, $00, $01, $02, $03
		.db	$04, $05, $06, $07, $08, $09, $0A, $0B
		.db	$0C, $0E, $0F, $10, $11, $11, $11, $12
gemPathY	.db	$04, $04, $04, $04, $04, $04, $05, $05
		.db	$06, $06, $07, $07, $08, $08, $09, $09
		.db	$09, $0B, $0D, $10, $14, $18, $1C, $20

; the orbs under the bridge, by orbPos 0..$0F
orbX		.db	$2C, $2C, $2C, $50, $50, $50, $50, $38
		.db	$38, $38, $56, $56, $56, $33, $33, $33
orbY		.db	$63, $61, $5E, $65, $63, $60, $5E, $63
		.db	$60, $5E, $63, $61, $5E, $63, $61, $5F

; the sparks on the bridge, by sparkPos 0..$34: they end the page,
; $7990-$7995 is leftover memory
		placeAt	$7A00 - 53 * 2

sparkX		.db	$42, $42, $42, $42, $42, $42, $42, $42
		.db	$43, $43, $43, $45, $48, $4B, $4D, $4E
		.db	$4E, $42, $42, $41, $40, $3E, $3B, $39
		.db	$39, $39, $42, $42, $42, $43, $44, $46
		.db	$48, $4A, $4C, $41, $41, $3F, $3D, $3B
		.db	$3B, $3B, $43, $42, $41, $41, $40, $3E
		.db	$3B, $38, $36, $36, $36
sparkY		.db	$59, $54, $50, $49, $44, $41, $3F, $3E
		.db	$5A, $58, $56, $54, $52, $53, $55, $57
		.db	$59, $59, $56, $52, $4F, $4D, $4D, $50
		.db	$53, $57, $59, $56, $51, $4F, $4C, $4A
		.db	$4A, $4B, $4E, $58, $56, $54, $51, $54
		.db	$57, $5B, $58, $56, $52, $4D, $4A, $48
		.db	$47, $49, $4C, $4F, $53
