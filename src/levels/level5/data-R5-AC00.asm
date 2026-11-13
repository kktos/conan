;
; level 5 description, disk chunk c5 ($AC00-$ADFF), read by the game
;

		.define	geometry from "geometry.yaml"

		levelGeometry	geometry	; $AC00-$ACFF

		placeAt	$AD00
		.fill	$20, 0

; animated decorations (ANIMATE_DECOR): X, Y, shape $21-$23, list ends at Y=0
; 6 torches
		.db	$84, $4B, $0E, $14, $6E, $74	; $AD20 TANIM_X
		.fill	$0A, 0
		.db	$97, $64, $5A, $5A, $0C, $0C	; $AD30 TANIM_Y
		.fill	$0A, 0
		.db	$21, $22, $21, $23, $22, $21	; $AD40 TANIM_SHAPE
		.fill	$3A, 0

		levelStartExit	geometry	; $AD80-$AD88

; $AD89-$AD8A: $FF $FF on the disk, not read
		.fill	$AE00 - *, 0
