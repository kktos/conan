		.macro	dosLoadFile(filename) {
			ldx	#<filename
			ldy	#>filename
			jsr	tinyDOS::LoadFile
		}

		.macro	dosLoadFromFile(params) {
			ldx	#<params
			ldy	#>params
			jsr	tinyDOS::LoadFromFile
		}

		.macro	addMemRegion(filename, addr, len, bank) {
			BRK
			.db	$03
			.dw	addr
			.dw	len
			.dw	filename
			.dw	bank
		}

		.macro	delRegions(...list) {
			brk
			.db	$04
			.db	.len(list)

			.for	name of list as idx {
				.dw	.label("region" + .str(idx))
			}

			bra	:+

			.for	name of list as idx {
				.let	"region" + .str(idx) = *
				.cstr	name
			}

:
		}

