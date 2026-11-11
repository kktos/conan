;
; level 6 description, disk chunk c5 ($AC00-$ADFF), read by the game
;

		.define geometry from "geometry.yaml"

		levelGeometry geometry		; $AC00-$ACFF

		placeAt $AD00
		.fill $20, 0

; animated decorations (ANIMATE_DECOR, and the level's animateTorches):
; X, Y, shape $21-$23, list ends at Y=0
; 12 torches; 8..11 are the chandelier's flames: checkAxeHitChain sets
; LAD30+8 to 0 when it falls
LAD20		.db $06, $84, $84, $0A, $10, $06, $84, $F0, $3B, $3E, $44, $47
		.fill $04, 0
LAD30		.db $A1, $A0, $7C, $6F, $6F, $54, $54, $2D, $0E, $0F, $0F, $0E
		.fill $04, 0
LAD40		.db $21, $23, $22, $22, $21, $23, $21, $22, $23, $22, $21, $22
		.fill $34, 0

		levelStartExit geometry		; $AD80-$AD88

; $AD89-$AD8A: $FF $FF on the disk, not read
		.fill $AE00 - *, 0
