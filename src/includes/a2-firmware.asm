		.namespace sys

KBD			= $C000
KBDSTRB			= $C010

SPKR			= $C030

TEXTOFF			= $C050
MIXEDOFF		= $C052
PAGE2OFF		= $C054
HIRESON			= $C057

BUTNO			= $C061
BUTN1			= $C062
BUTN2			= $C063
PADDL0			= $C064
PADDL1			= $C065
PADDL2			= $C066
PADDL3			= $C067
PTRIG			= $C070

; RR LCBANK2 Read/write RAM bank 2
LCBANK2			= $C083
; R7 RDLCBNK2 1=bank2 available 0=bank1 available
RDLCBNK			= $C011
; R7 BSRREADRAM 1=LC active for read 0=ROM active
RDLCRAM			= $C012

PREAD 			= $FB1E
SETKBD 			= $FE89
SETVID 			= $FE93
INIT 			= $FB2F

WAIT 			= $FCA8

; $C600 boot loader
; https://apple2.org.za/gswv/a2zine/GS.WorldView/Resources/DOS.3.3.ANATOMY/BOOT.PROCESS.txt
; https://6502disassembly.com/a2-rom/C600ROM.html
;
BOOTSEC			= $3D
SLT16ZPG		= $2B
PT2BTBUF		= $26
ReadSector		= $C65C

		.namespace
