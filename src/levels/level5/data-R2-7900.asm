;
; level 5 variables, disk chunk c2 ($7900-$79FF)
; private RAM of the level code, initial values from the disk.
; the gem pile is indexed from 1 (table-1,x); the walker tables' initial
; values are leftovers: walkerDX = 0 is a free slot.
;

; fire at ($14,$14), top left, in front of the key: flickers, burns the
; player while fireTimer < 7, put out with a gem
fireTimer	.db	$20			; frames before it flickers again (random 8..15)

; the pile of 6 gems at the bottom left (shape $28), 1..6 from the top of the
; pile: itemsLeft is the next one. Each one is either released as a walker
; (releaseWait) or taken by the player
itemX		.db	$10, $0C, $08, $0E, $0A, $0C
itemY		.db	$A5, $A5, $A5, $A0, $A0, $9A
itemsLeft	.db	$06			; gems still on the pile, 6 down to 0
releaseWait	.db	$10			; frames before the next gem turns into a walker (releaseDelays)
walker		.db	$AE			; current walker / shot, 0..5
fireFrame	.db	$00			; 0 / 2, added to the fire shapes
releaseDelays	.db	$E0, $C0, $80, $50, $20	; by itemsLeft-1; itemsLeft = 6 reads burrowerX

; burrower (shapes $49-$4D): walks along the bottom and kills on touch; at
; the holes X $46 / $61 / $79 it goes into the ground and comes out of
; another one, at random
burrowerX	.db	$50			; $32..$81
burrowerY	.db	$97			; + burrowerYOfs
burrowerState	.db	$00			; 0 = walking, $FF = going into the ground, 1 = coming out
burrowerDX	.db	$01			; +1 / -1, negated at X $32 and $81
burrowerShape	.db	$49			; walking: $49 / $4A (EOR 3); $4B-$4D in the ground
burrowerAnim	.db	$01			; +1 / -1: going into / out of the ground
burrowerYOfs	.db	$02, $00, $06, $0B, $0C	; Y offset of shapes $49-$4D
shot		.db	$AE			; shot loop index (removeShot)
unused7922	.db	$00			; not referenced

itemsDone	.db	$00			; gems taken or walkers killed, 0..6 (6 opens the door at $58,$17)
topOpen		.db	$00			; set when the player gets to the top (Y<$20) after the 6: the
				; top portal stops, the passage at X $53 opens, the guard shows
topBarOn	.db	$00			; the top portal's bar (shape $52 at $25,$17) is drawn, it blinks
guardShape	.db	$01			; the guard at ($4A,$58) while topOpen: $49 / $4A (EOR 3)
gemReturned	.db	$00			; a gem went back on the pile when topOpen was lost
fireOn		.db	$01			; 1 = burning (shapes $4E/$4F + fireFrame), 0 = put out
splashFrame	.db	$00			; player fell in the water (X>=$42, Y>=$A0): frame 1..8, 0 = none
splashShapes	.db	$53, $54, $55, $56, $56, $55, $54, $53	; for splashFrame 1..8
splashX		.db	$01			; player X when falling in
splashY		.db	$01			; $97
bonusOn		.db	$00			; the axe bonus (shape $1E at $54,$9C) is there
doorOpen	.db	$00			; the key opened the door at the top right ($2A at $83,$21)

; $7936-$7937: not referenced, leftover memory from an align
		.align	$08

; WAIT per frame, by 6 - itemsLeft - itemsDone: the game speeds up
speed		.db	$50, $40, $30, $20, $10, $01, $01, $01

; $7940-$79C3: not referenced, leftover memory: the walker tables end the page
		placeAt	$7A00 - 10 * 6

; 6 walkers (shapes $41-$44), released from the gem pile at Y $3D, going
; through the portals like the player, each with one shot (shapes $47/$48)
walkerState	.db	$01, $01, $01, $01, $01, $01	; 0 = alive, <0 = dying ($F8, counts up to 0)
shotDX		.db	$03, $03, $03, $03, $03, $03	; +3 / -3
walkerX		.db	$E1, $00, $C0, $1C, $24, $D0
walkerY		.db	$00, $4B, $A4, $E0, $00, $20	; $15 / $3D / $5B: the 3 floors
walkerShape	.db	$E4, $F0, $00, $00, $08, $08	; $41/$42 going left (EOR 3), $43/$44 going right (EOR 7)
walkerDX	.db	$00, $00, $00, $00, $00, $00	; +2 / -2, 0 = free slot
shotTime	.db	$05, $05, $05, $05, $05, $05	; >= 0: frames before the walker shoots; <0: flying, ends at $ED
shotX		.db	$2E, $26, $2B, $2D, $2F, $2A
shotY		.db	$55, $15, $35, $75, $F5, $01
shotShape	.db	$00, $0A, $00, $64, $00, $E8	; $47 going left, $48 going right
