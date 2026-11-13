; level 0 variables (c2, originally at $7900; the L79xx names keep the original addresses)

; read as animVoltaSpriteIDs,x: 32 bytes aligned on 32, so it never crosses a page
		.align	$20
animVoltaSpriteIDs
		.hex
			41 42 41 42 41 42 41 42 41 42 41 42 41 42 43 44
			43 44 43 44 43 44 45 46 45 46 45 46 45 45 45 45
		.end

L7900		.db	$00
L7901		.db	$F0
L7902		.db	$01
voltaFrameIdx	.db	$00			; index into animVoltaSpriteIDs
birdX		.db	$F0			; help "avian ally" bird: x pos
birdSpriteID	.db	$01			; $47 flying, $48 landed
L7906		.db	$46
introDelay	.db	$80			; INTRODUCTION screen display time; $40 after the first help cycle

HS_Xpos		.db	$00
HS_Ypos		.db	$7D
HS_digitCount	.db	$02

		.db	$00, $7D, $02, $00, $7D

animFrameIdx	.db	$00
L7931		.db	$F8
isSpringRunning	.db	$00
springCurYpos	.db	$A3
springCurId	.db	$49
