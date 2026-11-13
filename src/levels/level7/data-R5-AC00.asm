;
; level 7 description, disk chunk c5 ($AC00-$ADFF), read by the game
;

		.define	geometry from "geometry.yaml"

		levelGeometry	geometry	; $AC00-$ACFF

		placeAt	$AD00
		.fill	$20, 0

; animated decorations (ANIMATE_DECOR): X, Y, shape $21-$23, list ends at Y=0
LAD20		.db	$40, $46, $6E, $74, $86, $07, $0D, $7C, $82
		.fill	$07, 0
LAD30		.db	$70, $70, $62, $62, $49, $42, $42, $1B, $1B
		.fill	$07, 0
LAD40		.db	$21, $22, $22, $23, $23, $21, $23, $22, $21
		.fill	$37, 0

		levelStartExit	geometry	; $AD80-$AD88

		.fill	$AE00 - *, 0
