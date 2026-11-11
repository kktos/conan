;
; level 4 variables, disk chunk c2 ($7900-$79FF)
; private RAM of the level code, initial values from the disk.
; some initial values are leftovers (creature pool, testY..sinkFrame): the
; code sets them before using them.
;

		placeAt $7900

; boulder (shape $54): falls from the top left onto the ground and breaks,
; then sits on the geyser's hole and rides it up. While it is solid
; (isBoulderSolid) it is ledge $0E (LAC00/LAC20/LAC40+$0E)
boulderState	.db $00		; 0 = waiting, 1..3 = falling speed (accelerates), <0 = landed, counts up to 0
boulderWait	.db $30		; frames before the next fall (random $10-$4F)
boulderX	.db $08
boulderY	.db $2F		; from $2F (top) to $A4 (ground)

; geyser (shapes $51-$53, the rev-eng's L4_JUMPER_*): leaps out of its hole
; at ($42,$98) carrying the boulder, drawn without EOR on the way up (it
; leaves a column) and erased from the top on the way down
geyserWait	.db $00		; frames before it leaps
geyserState	.db $00		; 0 = waiting, 1 = going up, $FF = coming down (the boulder burst)
geyserX		.db $00		; $42
geyserY		.db $00		; starts at $98
geyserDY	.db $00		; vertical speed, starts at -3, +1 per frame above Y=$20
geyserShape	.db $00		; $51..$53 cycle
breakFrame	.db $00		; boulder breaking on the ground: frame 1..8, 0 = none
burstFrame	.db $00		; boulder bursting at the top: frame 1..4, 0 = none, $FF = done
burstShapes	.db $54, $55, $56, $57	; for burstFrame 1..4

spawnWait	.db $20		; frames before a creature appears (random AND spawnMask)
creature	.db $00		; current creature, 0..7 (index in the creature* tables)
testX		.db $00		; position tested against the ledges (findLedge)
testY		.db $8C
ledge		.db $F7		; ledge found by findLedge; also the drop index in updateDrops
sinkX		.db $B3		; player X when sinking, drawn at Y=$9C
sinkFrame	.db $B1		; 0..7
sinkDir		.db $00		; +1 / -1 (player X >= $40): selects the shape set; 0 = not sinking
bonusWait	.db $18		; frames before the next bonus (random)
bonusX		.db $00		; bonus position, one of spawnX/Y (+$18 on Y)
bonusY		.db $00
bonusTime	.db $00		; frames the bonus stays ($40-$BF), 0 = none
slot1Full	.db $00		; a gem is in slot 1 (X=$80, Y=$A6)
slot2Full	.db $00		; tested but never set: slot 2 sets keyState

; $791E-$791F: not referenced, leftover memory from an align
		.align $10

jumpShapes	.db $42, $42, $42, $43, $43, $44, $43, $43	; creature shape while jumping, by creatureDY+4
		.db $42, $42, $42
bonusKind	.db $00		; 1 = a gem (shape $28), $FF = an axe (shape $1E)
slotBlink	.db $FF		; $FF / $01: slot 2's marker (shape $58 at $76,$95) is drawn when $01
spawnMask	.db $7F		; random mask for spawnWait, -3 per creature down to 4 (they come faster)
halfFrame	.db $00		; 0 / 1: creatures move every other frame

; $792F-$793F: not referenced, leftover memory from an align
		.align $40

breakShapes	.db $5A, $5A, $5B, $5B, $5C, $5C, $5B, $5A	; for breakFrame 1..8

; $7948-$797F: not referenced, leftover memory from an align
		.align $80

; pool of 8 creatures (shapes $41-$48)
creatureX	.db $FF, $91, $1C, $EE, $7F, $A0, $D0, $03
creatureY	.db $EE, $80, $A0, $C8, $C0, $4A, $D0, $02
creatureShape	.db $A0, $00, $CE, $F1, $B3, $D0, $E3, $AE	; $41 walking, $42-$44 jumping, $45-$48 appearing / dying
creatureActive	.db $00, $00, $00, $00, $00, $00, $00, $00	; 0 = free slot
creatureState	.db $00, $00, $00, $00, $00, $00, $00, $00	; $FF = appearing, 0 = alive, 1 = dying
creatureTimer	.db $10, $10, $10, $10, $10, $10, $10, $10	; frames before it jumps (random 0..15)
creatureDX	.db $4E, $65, $1C, $0A, $45, $4F, $48, $06	; X direction (bit 7: left), negated when it bumps into something or leaves X $08-$5D
creatureJump	.db $00, $00, $00, $00, $00, $00, $00, $00	; 1 = jumping
creatureDY	.db $03, $4D, $00, $03, $85, $4E, $68, $85	; vertical speed while jumping ($FB, up to 5)
creatureFalling	.db $00, $00, $00, $00, $00, $00, $00, $00	; 1 = falling (no ledge under it)

sinkShapes	.db $49, $4A, $4B, $4C, $4C, $4B, $4A, $49	; player sinking, sinkDir +1
		.db $4D, $4E, $4F, $50, $50, $4F, $4E, $4D	; sinkDir -1

; 16 places where a creature (or a bonus, 24 lines lower) appears
spawnX		.db $4F, $34, $29, $21, $1C, $16, $22, $51
		.db $5B, $19, $1D, $24, $2B, $34, $51, $59
spawnY		.db $6B, $6B, $6B, $6B, $3E, $6B, $3E, $43
		.db $43, $0A, $0A, $0A, $0A, $0A, $07, $07
