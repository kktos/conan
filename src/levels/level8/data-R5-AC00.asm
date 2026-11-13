;
; level 8 description, disk chunk c5 ($AC00-$ADFF), read by the game
; all zeros but the start and the exit (geometry.yaml).
;

		.define	geometry from "geometry.yaml"

		levelGeometry	geometry	; $AC00-$ACFF

		placeAt	$AD00
		.fill	$80, 0			; no animated decorations ($AD20/$AD30/$AD40 lists empty)

		levelStartExit	geometry	; $AD80-$AD88

		.fill	$AE00 - *, 0
