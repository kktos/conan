		.macro	defsprite width, height, addr {
			.db	width
			.db	height
			.repeat	7 as idx
				.dw	addr + (width * (height & $7F) * (idx-1))
			.end
		}

		; a picture stored once: the 7 shift pointers all point to it,
		; so it is only drawn on a byte boundary
		.macro	defpicture width, height, addr {
			.db	width
			.db	height
			.repeat	7
				.dw	addr
			.end
		}
