		.if * < $7900
		.align $7900
		.end
		.if * > $7900
		.error "this needs to be at $7900 !"
		.end

L7900		.db 0
L7901		.db 0
L7902		.db 0
L7903		.db 1
L7904		.db 1
L7905		.db $60
L7906		.db $20
L7907		.db 0

		.hex
		41 42 43 44 44 43 42 41
		.end

L7910		.db 00

		.hex
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		32 67 8A 13 08 38 58 38 39 57 75 69 8B 81 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		9F 9F 9C 9B 98 7C 71 59 3F 35 49 2B 03 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		2C 40 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		A0 5A 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		5A 31 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		08 14 22 59 84 4F 2E 2E 00 66 4E 66 82 8B 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
		9C A0 A0 A0 9D 72 5A 40 00 4A 36 2C 04 04 00 00
		.end
