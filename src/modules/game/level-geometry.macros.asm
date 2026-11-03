;
; Level geometry: builds the tables the game engine scans, at the fixed
; addresses it reads ($AC00-$ACFF and $AD80-$AD88), from a level description
; loaded with .define (see levels/level1/geometry.yaml).
;
; Each list ends with a 0 in its key column, as the engine expects:
;   platforms: LAC40 (top) = 0
;   ladders:   LAC60 (top) = 0
;   walls:     LACF0 (y)   = 0
; so a top / y can't be 0, and a list holds at most column size - 1 entries.
;
; The labels (LAC00...) are set with .let: a label written in a macro body
; would stay local to the macro, and the level code needs them.
;

.macro levelGeometry lvl {

	nbPlatforms = .len(lvl.platforms)
	nbLadders = .len(lvl.ladders)
	nbWalls = .len(lvl.walls)

	.if nbPlatforms > $1F {
		.error "levelGeometry: ", nbPlatforms, " platforms, max is 31"
	}
	.if nbLadders > $1F {
		.error "levelGeometry: ", nbLadders, " ladders, max is 31"
	}
	.if nbWalls > $0F {
		.error "levelGeometry: ", nbWalls, " walls, max is 15"
	}

	placeAt $AC00

; platforms: the player stands on 'top', from left to right
	.let "LAC00" = *	; left
	.for p of lvl.platforms {
		.db p.left
	}
	.fill $20 - nbPlatforms, 0
	.let "LAC20" = *	; right
	.for p of lvl.platforms {
		.db p.right
	}
	.fill $20 - nbPlatforms, 0
	.let "LAC40" = *	; top
	.for p of lvl.platforms {
		.assert p.top != 0, "levelGeometry: a platform top can't be 0 (end of list)"
		.db p.top
	}
	.fill $20 - nbPlatforms, 0

; ladders: climbable at x, from top to bottom
	.let "LAC60" = *	; top
	.for l of lvl.ladders {
		.assert l.top != 0, "levelGeometry: a ladder top can't be 0 (end of list)"
		.db l.top
	}
	.fill $20 - nbLadders, 0
	.let "LAC80" = *	; bottom
	.for l of lvl.ladders {
		.db l.bottom
	}
	.fill $20 - nbLadders, 0
	.let "LACA0" = *	; x
	.for l of lvl.ladders {
		.db l.x
	}
	.fill $20 - nbLadders, 0

; walls: block horizontal moves at x, for the player's feet at y
	.let "LACC0" = *	; x
	.for w of lvl.walls {
		.db w.x
	}
	.fill $30 - nbWalls, 0
	.let "LACF0" = *	; y
	.for w of lvl.walls {
		.assert w.y != 0, "levelGeometry: a wall y can't be 0 (end of list)"
		.db w.y
	}
	.fill $10 - nbWalls, 0
}

;
; Player start and level exit, at $AD80-$AD88
;
.macro levelStartExit lvl {

	placeAt $AD80

	.let "LAD80" = *
	.db lvl.start.x
	.let "LAD81" = *
	.db lvl.start.y
	.let "LAD82" = *
	.db lvl.start.sprite
	.let "LAD83" = *
	.db .iif(lvl.start.facing == "left", $FF, $01)	; currentXspeed

	.let "LAD84" = *
	.db lvl.exit.arrow.x
	.let "LAD85" = *
	.db lvl.exit.arrow.y
	.let "LAD86" = *
	.db lvl.exit.arrow.sprite

	.let "LAD87" = *
	.db lvl.exit.win.x
	.let "LAD88" = *
	.db lvl.exit.win.y
}
