;
; level 2 description, disk chunk c5 ($AC00-$ADFF), read by the game
;
; the whole $AD00 page must be in the file: tinyDOS loads 512-byte blocks,
; so a file ending at $ACFF would leave the rest of its last block in $AD00-$ADFF
;

		.define	geometry from "geometry.yaml"

		levelGeometry	geometry	; $AC00-$ACFF

		placeAt	$AD00
		.fill	$20, 0

; animated decorations (ANIMATE_DECOR): X, Y, shape $21-$23, list ends at Y=0
; one torch
		.db	$84			; $AD20 TANIM_X
		.fill	$0F, 0
		.db	$2B			; $AD30 TANIM_Y
		.fill	$0F, 0
		.db	$21			; $AD40 TANIM_SHAPE
		.fill	$3F, 0

		levelStartExit	geometry	; $AD80-$AD88

		.fill	$AE00 - *, 0
