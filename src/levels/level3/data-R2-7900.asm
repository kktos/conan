;
; level 3 variables, disk chunk c2 ($7900-$79FF)
; private RAM of the level code, initial values from the disk.
; monsters and ranges are indexed from 1 (table-1,x).
;

		placeAt	$7900

; portal: appears at random at the bottom or at the top of the shaft,
; moves the player and monsters 1 and 3 through it
		.struct PortalVars
on		.byte				; active: frames left (random $10-$4F); also the tone's period
off		.byte				; idle: frames left before it opens again (random $08-$27)
shape		.byte				; $48 / $49, toggled each frame
side		.byte				; bit 7: 1 = bottom portal (X=$5E, Y=$9C), 0 = top portal (X=$56, Y=$1B)
		.end

; 3 walking monsters (1..3): one table per field, indexed by the monster
		.struct MonsterVars
x		.res	3
y		.res	3
shape		.res	3			; EOR 1 when turning around
dx		.res	3			; X speed, negated when turning around
range		.res	3			; range number (1..3) of each monster, changed by the portal
		.end

; walking ranges, per range number (1..3)
		.struct RangeVars
lo		.res	3			; low X
hi		.res	3			; high X
		.end

; rising bubbles
		.struct BubbleVars
frame		.byte				; 1..8, 0 = none
column		.byte				; which of the 4 bubble columns, 0..3
		.end

; flying bonus
		.struct BonusVars
step		.byte				; step on its path (bonusPathX/Y/Shape)
taken		.byte				; 0: flying, 1: taken (extra life), $FF: taken and its path ended
		.end

; lift (shapes $41-$43)
		.struct LiftVars
x		.byte				; $2A once started
y		.byte				; $8E up to $1B
state		.byte				; 0 idle, >0 going up, $FF / $FE at the top
		.end

; player sinking in the water
		.struct SinkVars
frame		.byte				; 1..8, 0 = none
x		.byte				; player X, drawn at Y=$7F
		.end

portal		.res	PortalVars { off: $20, shape: $48 }
monsters	.res	MonsterVars { x: [$7A, $5A, $56], y: [$AB, $6B, $2A], shape: [$47, $45, $46], dx: [$02, $01, $FE], range: [$01, $02, $03] }
ranges		.res	RangeVars { lo: [$52, $47, $52], hi: [$C0, $6C, $6A] }

;unused7910	.db	$FF, $01, $FF

bubble		.res	BubbleVars
bonus		.res	BonusVars
lift		.res	LiftVars
sink		.res	SinkVars { x: $84 }

onLift		.db	$00			; 1 while the player rides the lift

; $7926-$797F: not referenced, leftover memory from an align
		.align	$80

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
bubbleShapes	.hex	{ 4C 4C 4C 4C 4C 4C 4D 4E }
sinkShapes	.hex	{ 4F 50 51 52 52 51 50 4F }

; $79D0-$79FF: not referenced, leftover memory (data-R3 starts with placeAt $7A00)
