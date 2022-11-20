		.namespace levels

; levels(8) table used by L1EC3
; used to load a range of sectors
; - range 1: $7500 - packed level bkg img
; - range 2: $7500 -
; - range 3: $7900:79FF -
; - range 4: $7A00:9BFF -
; - range 5: $A000:ABFF -
; track list
; <start> <end>
; $0900
rangeTracks
		; .hex 00 00
		; .hex 00 00
		; .hex 03 03
		; .hex 03 04
		; .hex 04 04
		; .hex 05 05

		.hex 10 10 10 10 12 13 13
		.hex 04 04 04 05 05 05 06
		.hex 06 06 07 07 07 08 08
		.hex 08 0A 0A

		.hex 0B 0B
		.hex 0B 0B
		.hex 0D 0E
		.hex 0E 0F
		.hex 0F 0F
		.hex 11 11

		.hex 12 12
		.hex 12 12
		.hex 14 15
		.hex 15 16
		.hex 16 16
		.hex 18 19

		.hex 19 1A
		.hex 1A 1A
		.hex 1A 1A
		.hex 1A 00
		.hex 00 00
		.hex 00 00

		.hex 00 00 00 00 00 00 00 00 00 00 00 00
		.hex 00 00 00 00 00 00 00 00 00 00 00 00
		.hex 00 00 00 00 00 00 00 00 00 00 00 00
		.hex 00 00 00 00 00 00 00 00 00 00 00 00
		.hex 00 00 00 00 00 00 00 00 00 00 00 00
		.hex 00 00 00 00 00 00 00 00


; sector list
; <start> <end>
; $0980
rangeSectors
		; .hex 01 09 00 08 0D 0E 00 0C 0E 06 07 08 00 09

		.hex 00 08 0C 0D 0F 0B 0D
		.hex 06 07 08 00 09 0B 05

		.hex 06 07
		.hex 07 0D
		.hex 0F 08
		.hex 0A 0B
		.hex 04 0F

		.hex 01 0A
		.hex 0C 0D
		.hex 09 05
		.hex 07 01
		.hex 03 04
		.hex 02 0E

		.hex 00 0A
		.hex 0D 0E
		.hex 09 05
		.hex 07 03
		.hex 07 08
		.hex 0E 0A

		.hex 0C 07
		.hex 08 09
		.hex 0C 0D
		.hex 0F 00
		.hex 00 00
		.hex 00 00

		.hex 00 00 00 00 00 00 00 00 00 00 00 00
		.hex 00 00 00 00 00 00 00 00 00 00 00 00
		.hex 00 00 00 00 00 00 00 00 00 00 00 00
		.hex 00 00 00 00 00 00 00 00 00 00 00 00
		.hex 00 00 00 00 00 00 00 00 00 00 00 00
		.hex 00 00 00 00 00 00 00 00
