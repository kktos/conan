;
; level 6 variables, disk chunk c2 ($7900-$79FF)
; private RAM of the level code, initial values from the disk.
; tables indexed from 1 are used as table-1,x.
;

clock		.db	$00			; 0..$0F, +1 per frame: drives the gate, the riser and the blinkers
lamp		.db	$01			; 1..4: the lit one of the 4 lamps (shape $49 at X $3A+4n, Y $4E)
flameTimer	.db	$0A			; frames before the exit's flame flickers again (random 8..15)
flameFrame	.db	$00			; 0 / 2, added to the flame shapes $5B / $5C at ($84,$2C)
gateOn		.db	$00			; the gate of the centre machine is drawn (clock 9 to 13)
gateFrame	.db	$00			; 0 / 1, added to the gate shapes

; the mover: flies in from below the screen along a script, kills on touch;
; hit with the axe, it shrinks away and adds a rung to the ladder at X $23
moverOn		.db	$00			; flying
moverStep	.db	$00			; step in the script (moverScript*, data-R3-7A00.asm)
moverX		.db	$00			; as drawn
moverY		.db	$00
moverShape	.db	$01
moverNewX	.db	$00			; where to draw it next
moverNewY	.db	$00
moverNewShape	.db	$01
moverTime	.db	$01			; frames left in the current step
moverDX		.db	$00			; move per frame in the current step
moverDY		.db	$00

; two bars moving left and right, under the floor $52 and in the floor $7C:
; when they line up, a lightning bolt strikes between them (Y $6B-$8B)
upperPlatX	.db	$1C			; at Y $69 (shape $50), $1A..$7A, by 2
lowerPlatX	.db	$70			; at Y $8B (shape $4F), $14..$7A, by 1; carries the player (ledge 0)
upperPlatDX	.db	$02			; +2 / -2
lowerPlatDX	.db	$FF			; +1 / -1
boltTimer	.db	$00			; frames the bolt stays, 2 down to 0 (0 = none)
boltFrame	.db	$00			; 0 / 1, added to the bolt shape $55
boltX		.db	$00			; upperPlatX when it struck

levelDone	.db	$00			; the chandelier fell: everything stops and the exit opens (checkLeave)
spawnStep	.db	$00			; a monster flying out of the centre machine: step 1..$10 in the
				; left arc, $11..$20 in the right one (spawnX/Y/Shape), 0 = none

; $791A-$791F: not referenced, leftover memory from an align
		.align	$10

monster		.db	$00			; the monster updateMonsters is on, 1..6
tmpX		.db	$00			; the monster's X / Y compared with a ladder's
moverHit	.db	$00			; 1..4: frame of the mover shrinking (moverHitShapes), 5 = gone

moverHitShapes	.db	$43, $60, $61, $62
; the ladder at X $23 (ladder 9 of geometry.yaml), a rung for each mover shot
rungX		.db	$23, $23, $23, $23, $23, $23	; rung 1..6 (shape $4A)
rungY		.db	$17, $1D, $23, $29, $2F, $35
rung		.db	$01			; next rung, 1..6; 0 once the ladder is complete

; the chandelier falling (dropChandelier)
drawLine	.db	$00			; screen line being drawn (chandelier and crash)
chandelierY	.db	$07			; +2 per frame, up to $31
fallDelay	.db	$A9			; WAIT per frame, -8 per frame: it speeds up

bonusOn		.db	$00			; the axe bonus (shape $1E at $45,$A6) is there

; 6 monsters (shapes $57 / $58), slots 0..5 (1..6 as table-1,x); the loops
; over the slots go up to 7, slots 6 and 7 stay free
monsterHit	.db	$00, $00, $00, $00, $00, $00, $00, $00	; 1..$0A: dying, frame by frame
monsterX	.db	$00, $00, $00, $00, $00, $00, $00, $00
monsterY	.db	$00, $00, $00, $00, $00, $00, $00, $00	; $2F / $57 / $81 / $A5: the 4 floors
monsterState	.db	$00, $00, $00, $00, $00, $00, $00, $00	; 0 = free, <0 = flying out (spawnStep), else its shape
monsterDX	.db	$00, $00, $00, $00, $00, $00, $00, $00	; +1 / -1, 0 = standing
monsterDY	.db	$00, $00, $00, $00, $00, $00, $00, $00	; +1 / -1 on a ladder
monsterClimb	.db	$00, $00, $00, $00, $00, $00, $00, $00	; on a ladder: 1 going down, $FF going up

; a monster flying out of the centre machine, by spawnStep 1..$20: to the
; left of the floor $2A ($25,$2F), then to its right ($59,$2F)
spawnX		.db	$3B, $39, $37, $36, $34, $33, $31, $30
		.db	$2E, $2D, $2B, $2A, $28, $27, $26, $25
		.db	$3D, $3F, $41, $43, $45, $47, $49, $4B
		.db	$4D, $4F, $51, $53, $55, $57, $58, $59
spawnY		.db	$46, $41, $3B, $36, $31, $2B, $27, $24
		.db	$22, $20, $1F, $20, $21, $23, $27, $2B
		.db	$47, $41, $3B, $36, $31, $2B, $27, $24
		.db	$22, $20, $1F, $20, $21, $23, $27, $2B
spawnShape	.db	$53, $54, $53, $54, $53, $54, $53, $54
		.db	$53, $54, $53, $54, $59, $5A, $59, $5A
		.db	$51, $52, $51, $52, $51, $52, $51, $52
		.db	$51, $52, $51, $52, $59, $5A, $59, $5A

; the riser in the centre machine, by clock 0..$0C (shapes $44-$46)
decorX		.db	$4B, $4B, $4B, $4B, $4B, $4B, $4A, $4A
		.db	$4A, $4A, $4A, $4A, $4A, $00, $00, $00
decorY		.db	$5C, $5B, $5A, $59, $58, $57, $56, $55
		.db	$54, $53, $52, $51, $50, $00, $00, $00
decorShape	.db	$44, $44, $44, $44, $44, $44, $45, $45
		.db	$45, $45, $45, $46, $46, $00, $00, $00
