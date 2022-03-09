SETKBD 			= $FE89
SETVID 			= $FE93
INIT 			= $FB2F

; $C600 boot loader
; https://apple2.org.za/gswv/a2zine/GS.WorldView/Resources/DOS.3.3.ANATOMY/BOOT.PROCESS.txt
; https://6502disassembly.com/a2-rom/C600ROM.html
;
BOOTSEC			= $3D
SLT16ZPG		= $2B
PT2BTBUF		= $26
ReadSector		= $C65C