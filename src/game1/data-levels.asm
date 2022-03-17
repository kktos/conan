
; levels(8) table used by L1EC3
; used to load a range of sectors
; - range 1: $7500 - packed level bkg img
; - range 2: $7500 -
; - range 3: $7900:79FF -
; - range 4: $7A00:9BFF -
; - range 5: $A000:ABFF -
; track list
; <start> <end>
L0900
		.hex 00 00 00 00 03 03
		.hex 03 04 04 04 05 05
		.hex 05 06 06 06 07 07

		.hex 07 08 08 08 0A 0A
		.hex 0B 0B 0B 0B 0D 0E
		.hex 0E 0F 0F 0F 11 11
		.hex 12 12 12 12 14 15
		.hex 15 16 16 16 18 19
		.hex 19 1A 1A 1A 1A 1A
		.hex 1A 00 00 00 00 00
		.hex 00 00 00 00 00 00 00 00 00 00 00 00
		.hex 00 00 00 00 00 00 00 00 00 00 00 00
		.hex 00 00 00 00 00 00 00 00 00 00 00 00
		.hex 00 00 00 00 00 00 00 00 00 00 00 00
		.hex 00 00 00 00 00 00 00 00 00 00 00 00
		.hex 00 00 00 00 00 00 00 00


; sector list
; <start> <end>
L0980
		.hex 01 09 0D 0E 00 0C
		.hex 0E 06 07 08 00 09
		.hex 0B 05 06 07 07 0D

		.hex 0F 08 0A 0B 04 0F
		.hex 01 0A 0C 0D 09 05
		.hex 07 01 03 04 02 0E
		.hex 00 0A 0D 0E 09 05
		.hex 07 03 07 08 0E 0A
		.hex 0C 07 08 09 0C 0D
		.hex 0F 00 00 00 00 00

		.hex 00 00 00 00 00 00 00 00 00 00 00 00
		.hex 00 00 00 00 00 00 00 00 00 00 00 00
		.hex 00 00 00 00 00 00 00 00 00 00 00 00
		.hex 00 00 00 00 00 00 00 00 00 00 00 00
		.hex 00 00 00 00 00 00 00 00 00 00 00 00
		.hex 00 00 00 00 00 00 00 00
