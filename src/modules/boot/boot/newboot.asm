		.namespace boot

                .db $01

		jsr sys::SETKBD
		jsr sys::SETVID
		jsr sys::INIT
		ldx sys::SLT16ZPG
		stz $0478
		stz $04f8
		stz $047e
		stz $04fe

		dosLoadFile fwelcome
		jmp welcome::main

fwelcome:
		.cstr "WELCOME"
