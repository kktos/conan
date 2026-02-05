	.macro defprite width, height, addr {
		.db width
		.db height
		.repeat 7 as idx
			.dw addr + (width * (height & $7F) * (idx-1))
		.end
	}
