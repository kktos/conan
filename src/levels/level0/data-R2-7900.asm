		.if * != $7900
		.error "this needs to be at $7900 !"
		.end

L7900		.hex 00
L7901		.hex F0
L7902		.hex 01
L7903		.hex 00
L7904		.hex F0
L7905		.hex 01
L7906		.hex 46
L7907		.hex 80

L7908		.hex 00
L7909		.hex 7D
L790A		.hex 02
		.hex 00 7D 02 00 7D

animVoltaSpriteIDs
		.hex 41 42 41 42 41 42 41 42 41 42 41 42 41 42 43 44
		.hex 43 44 43 44 43 44 45 46 45 46 45 46 45 45 45 45

animFrameIdx	.db $00
L7931		.hex F8
isSpringRunning	.db $00
springCurYpos	.db $A3
springCurId	.db $49
		.hex 00 78 01 00 70 00 00 10 02 00 50

		.hex 02 00 64 09 00 74 0B 00 74 0B 00 74 0B 00 74 0B
		.hex 00 64 09 00 70 03 00 60 01 00 20 04 00 20 05 00
		.hex 48 13 00 68 17 00 68 17 00 68 17 00 68 17 00 48
		.hex 13 00 60 07 00 40 03 00 40 08 00 40 0A 00 10 27
		.hex 00 50 2F 00 50 2F 00 50 2F 00 50 2F 00 10 27 00
		.hex 40 0F 00 00 07 00 00 11 00 00 15 00 20 4E 00 20
		.hex 5F 00 20 5F 00 20 5F 00 20 5F 00 20 4E 00 00 1F
		.hex 00 00 0E 00 00 22 00 00 2A 00 40 1C 01 40 3E 01
		.hex 40 3E 01 40 3E 01 40 3E 01 40 1C 01 00 3E 00 00
		.hex 1C 00 44 0A 00 76 02 00 7F 06 00 7E 0F 00 60 03
		.hex 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		.hex 08 15 00 6C 05 00 7E 0D 00 7C 1F 00 40 07 00 00
