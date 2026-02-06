		.if * < $7900
			.org $7900
		.end
		.if * > $7900
			.error "this needs to be at $7900 !","PC=",.hex(.pc)
		.end


batPathIndex		.db $00
batTempX		.db $00
batState		.db $00 ; 00: Active, 01: Exploding, FF: Dead
effectX			.db $00
effectY			.db $00
effectSpriteID		.db $01

; Sprite IDs for explosion animation
; Sequence: $44 -> $46 -> $45
animExplosionSeq1	.db $44
animExplosionSeq2	.db $46
animExplosionSeq3	.db $45

effectAnimFrameIdx	.db $01
splashActive		.db $00 ; 00: Falling/Exploding, 08: Splash on ground
splashTimer		.db $06
splashRectIdx		.db $00

; Other Sprite IDs identified:
; $47, $48, $49 : Splash/Dust animation

		.align $100

/*
		.hex
			00 00 00
			00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
			00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
			00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
			00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
			00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
			00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
			00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
			00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
			00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
			00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
			00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
			00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
			00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
			00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
			00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		.end
*/
