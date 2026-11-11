;
; level 3 variables, disk chunk c2 ($7900-$79FF)
; private RAM of the level code, initial values from the disk.
; monsters and ranges are indexed from 1 (table-1,x).
;

		placeAt $7900

; portal: appears at random at the bottom or at the top of the shaft,
; moves the player and monsters 1 and 3 through it
portalOn	.db $00		; active: frames left (random $10-$4F); also the tone's period
portalOff	.db $20		; idle: frames left before it opens again (random $08-$27)
portalShape	.db $48		; $48 / $49, toggled each frame
portalSide	.db $00		; bit 7: 1 = bottom portal (X=$5E, Y=$9C), 0 = top portal (X=$56, Y=$1B)

; 3 walking monsters (1..3)
monsterX	.db $7A, $5A, $56
monsterY	.db $AB, $6B, $2A
monsterShape	.db $47, $45, $46	; EOR 1 when turning around
rangeLo		.db $52, $47, $52	; walking range per range number (1..3): low X
unused7910	.db $FF, $01, $FF
monsterDX	.db $02, $01, $FE	; X speed, negated when turning around
rangeHi		.db $C0, $6C, $6A	; walking range per range number: high X

bubbleFrame	.db $00		; rising bubbles: frame 1..8, 0 = none
bubbleColumn	.db $00		; which of the 4 bubble columns, 0..3
bonusStep	.db $00		; step on the flying bonus' path (bonusPathX/Y/Shape)
monsterRange	.db $01, $02, $03	; range number (1..3) of each monster, changed by the portal

liftX		.db $00		; lift (shapes $41-$43), X = $2A once started
liftY		.db $00		; $8E up to $1B
liftState	.db $00		; 0 idle, >0 going up, $FF / $FE at the top
sinkFrame	.db $00		; player sinking in the water: frame 1..8, 0 = none
sinkX		.db $84		; player X when sinking, drawn at Y=$7F
onLift		.db $00		; 1 while the player rides the lift
bonusTaken	.db $00		; 0: bonus flying, 1: taken (extra life), $FF: taken and its path ended

; $7926-$797F: not referenced, leftover memory from an align
		.align $80

; 4 columns x (8 X, 8 Y), for bubbleFrame 1..8
bubblePath
	.hex
	21 21 21 21 21 21 21 21
	A2 A0 9C 9A 96 90 8C 8C
	31 31 31 31 31 31 31 31
	A0 9E 9C 96 90 8E 8C 8C
	28 28 28 28 28 28 28 28
	A2 A0 9E 9A 98 92 8C 8C
	39 39 39 39 39 39 39 39
	A4 A2 9F 9A 96 92 8C 8C
	.end

; for frames 1..8
bubbleShapes	.hex { 4C 4C 4C 4C 4C 4C 4D 4E }
sinkShapes	.hex { 4F 50 51 52 52 51 50 4F }

; $79D0-$79FF: not referenced, leftover memory (data-R3 starts with placeAt $7A00)
