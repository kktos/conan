                  * = 1D00
// display cracker page with moving text "conan"				  
1D00   20 3A 1D   JSR $1D3A
1D03   A9 41      LDA #$41
1D05   85 01      STA $01
1D07   A9 49      LDA #$49
1D09   85 02      STA $02
1D0B   A9 0B      LDA #$0B
1D0D   85 03      STA $03
1D0F   A9 1C      LDA #$1C
1D11   85 04      STA $04
1D13   A9 00      LDA #$00
1D15   85 FF      STA $FF
1D17   20 45 1D   JSR $1D45
1D1A   A9 70      LDA #$70
1D1C   20 A8 FC   JSR $FCA8 ;wait
1D1F   A5 01      LDA $01
1D21   C9 34      CMP #$34
1D23   B0 EE      BCS $1D13
1D25   A9 01      LDA #$01
1D27   85 FF      STA $FF
1D29   20 45 1D   JSR $1D45
1D2C   A9 70      LDA #$70
1D2E   20 A8 FC   JSR $FCA8 ;wait
1D31   A5 01      LDA $01
1D33   C9 41      CMP #$41
1D35   D0 F2      BNE $1D29
1D37   4C 00 1D   JMP $1D00

1D3A   AD 00 C0   LDA $C000
1D3D   10 05      BPL $1D44
1D3F   2C 10 C0   BIT $C010
1D42   68         PLA
1D43   68         PLA
1D44   60         RTS

1D45   A5 FF      LDA $FF
1D47   D0 3B      BNE $1D84
1D49   A5 01      LDA $01
1D4B   85 05      STA $05
1D4D   A5 02      LDA $02
1D4F   85 06      STA $06
1D51   A4 05      LDY $05
1D53   B9 C0 1D   LDA $1DC0,Y
1D56   85 07      STA $07
1D58   B9 80 1E   LDA $1E80,Y
1D5B   85 08      STA $08
1D5D   88         DEY
1D5E   B9 C0 1D   LDA $1DC0,Y
1D61   85 09      STA $09
1D63   B9 80 1E   LDA $1E80,Y
1D66   85 0A      STA $0A
1D68   A4 03      LDY $03
1D6A   B1 07      LDA ($07),Y
1D6C   91 09      STA ($09),Y
1D6E   C8         INY
1D6F   C4 04      CPY $04
1D71   90 F7      BCC $1D6A
1D73   F0 F5      BEQ $1D6A
1D75   E6 05      INC $05
1D77   A5 05      LDA $05
1D79   C5 06      CMP $06
1D7B   90 D4      BCC $1D51
1D7D   F0 D2      BEQ $1D51
1D7F   C6 01      DEC $01
1D81   C6 02      DEC $02
1D83   60         RTS

1D84   A5 01      LDA $01
1D86   85 05      STA $05
1D88   A5 02      LDA $02
1D8A   85 06      STA $06
1D8C   A4 06      LDY $06
1D8E   B9 C0 1D   LDA $1DC0,Y
1D91   85 07      STA $07
1D93   B9 80 1E   LDA $1E80,Y
1D96   85 08      STA $08
1D98   C8         INY
1D99   B9 C0 1D   LDA $1DC0,Y
1D9C   85 09      STA $09
1D9E   B9 80 1E   LDA $1E80,Y
1DA1   85 0A      STA $0A
1DA3   A4 03      LDY $03
1DA5   B1 07      LDA ($07),Y
1DA7   91 09      STA ($09),Y
1DA9   C8         INY
1DAA   C4 04      CPY $04
1DAC   90 F7      BCC $1DA5
1DAE   F0 F5      BEQ $1DA5
1DB0   C6 06      DEC $06
1DB2   A5 06      LDA $06
1DB4   C5 05      CMP $05
1DB6   90 03      BCC $1DBB
1DB8   4C 8C 1D   JMP $1D8C
1DBB   E6 01      INC $01
1DBD   E6 02      INC $02
1DBF   60         RTS

1DC0   00         BRK
1DC1   00         BRK
1DC2   00         BRK
1DC3   00         BRK
1DC4   00         BRK
1DC5   00         BRK
1DC6   00         BRK
1DC7   00         BRK
1DC8   80         ???
1DC9   80         ???
1DCA   80         ???
1DCB   80         ???
1DCC   80         ???
1DCD   80         ???
1DCE   80         ???
1DCF   80         ???
1DD0   00         BRK
1DD1   00         BRK
1DD2   00         BRK
1DD3   00         BRK
1DD4   00         BRK
1DD5   00         BRK
1DD6   00         BRK
1DD7   00         BRK
1DD8   80         ???
1DD9   80         ???
1DDA   80         ???
1DDB   80         ???
1DDC   80         ???
1DDD   80         ???
1DDE   80         ???
1DDF   80         ???
1DE0   00         BRK
1DE1   00         BRK
1DE2   00         BRK
1DE3   00         BRK
1DE4   00         BRK
1DE5   00         BRK
1DE6   00         BRK
1DE7   00         BRK
1DE8   80         ???
1DE9   80         ???
1DEA   80         ???
1DEB   80         ???
1DEC   80         ???
1DED   80         ???
1DEE   80         ???
1DEF   80         ???
1DF0   00         BRK
1DF1   00         BRK
1DF2   00         BRK
1DF3   00         BRK
1DF4   00         BRK
1DF5   00         BRK
1DF6   00         BRK
1DF7   00         BRK
1DF8   80         ???
1DF9   80         ???
1DFA   80         ???
1DFB   80         ???
1DFC   80         ???
1DFD   80         ???
1DFE   80         ???
1DFF   80         ???

                  * = 1E00
1E00   28         PLP
1E01   28         PLP
1E02   28         PLP
1E03   28         PLP
1E04   28         PLP
1E05   28         PLP
1E06   28         PLP
1E07   28         PLP
1E08   A8         TAY
1E09   A8         TAY
1E0A   A8         TAY
1E0B   A8         TAY
1E0C   A8         TAY
1E0D   A8         TAY
1E0E   A8         TAY
1E0F   A8         TAY
1E10   28         PLP
1E11   28         PLP
1E12   28         PLP
1E13   28         PLP
1E14   28         PLP
1E15   28         PLP
1E16   28         PLP
1E17   28         PLP
1E18   A8         TAY
1E19   A8         TAY
1E1A   A8         TAY
1E1B   A8         TAY
1E1C   A8         TAY
1E1D   A8         TAY
1E1E   A8         TAY
1E1F   A8         TAY
1E20   28         PLP
1E21   28         PLP
1E22   28         PLP
1E23   28         PLP
1E24   28         PLP
1E25   28         PLP
1E26   28         PLP
1E27   28         PLP
1E28   A8         TAY
1E29   A8         TAY
1E2A   A8         TAY
1E2B   A8         TAY
1E2C   A8         TAY
1E2D   A8         TAY
1E2E   A8         TAY
1E2F   A8         TAY
1E30   28         PLP
1E31   28         PLP
1E32   28         PLP
1E33   28         PLP
1E34   28         PLP
1E35   28         PLP
1E36   28         PLP
1E37   28         PLP
1E38   A8         TAY
1E39   A8         TAY
1E3A   A8         TAY
1E3B   A8         TAY
1E3C   A8         TAY
1E3D   A8         TAY
1E3E   A8         TAY
1E3F   A8         TAY
1E40   50 50      BVC $1E92
1E42   50 50      BVC $1E94
1E44   50 50      BVC $1E96
1E46   50 50      BVC $1E98
1E48   D0 D0      BNE $1E1A
1E4A   D0 D0      BNE $1E1C
1E4C   D0 D0      BNE $1E1E
1E4E   D0 D0      BNE $1E20
1E50   50 50      BVC $1EA2
1E52   50 50      BVC $1EA4
1E54   50 50      BVC $1EA6
1E56   50 50      BVC $1EA8
1E58   D0 D0      BNE $1E2A
1E5A   D0 D0      BNE $1E2C
1E5C   D0 D0      BNE $1E2E
1E5E   D0 D0      BNE $1E30
1E60   50 50      BVC $1EB2
1E62   50 50      BVC $1EB4
1E64   50 50      BVC $1EB6
1E66   50 50      BVC $1EB8
1E68   D0 D0      BNE $1E3A
1E6A   D0 D0      BNE $1E3C
1E6C   D0 D0      BNE $1E3E
1E6E   D0 D0      BNE $1E40
1E70   50 50      BVC $1EC2
1E72   50 50      BVC $1EC4
1E74   50 50      BVC $1EC6
1E76   50 50      BVC $1EC8
1E78   D0 D0      BNE $1E4A
1E7A   D0 D0      BNE $1E4C
1E7C   D0 D0      BNE $1E4E
1E7E   D0 D0      BNE $1E50
1E80   20 24 28   JSR $2824
1E83   2C 30 34   BIT $3430
1E86   38         SEC
1E87   3C         ???
1E88   20 24 28   JSR $2824
1E8B   2C 30 34   BIT $3430
1E8E   38         SEC
1E8F   3C         ???
1E90   21 25      AND ($25,X)
1E92   29 2D      AND #$2D
1E94   31 35      AND ($35),Y
1E96   39 3D 21   AND $213D,Y
1E99   25 29      AND $29
1E9B   2D 31 35   AND $3531
1E9E   39 3D 22   AND $223D,Y
1EA1   26 2A      ROL $2A
1EA3   2E 32 36   ROL $3632
1EA6   3A         ???
1EA7   3E 22 26   ROL $2622,X
1EAA   2A         ROL A
1EAB   2E 32 36   ROL $3632
1EAE   3A         ???
1EAF   3E 23 27   ROL $2723,X
1EB2   2B         ???
1EB3   2F         ???
1EB4   33         ???
1EB5   37         ???
1EB6   3B         ???
1EB7   3F         ???
1EB8   23         ???
1EB9   27         ???
1EBA   2B         ???
1EBB   2F         ???
1EBC   33         ???
1EBD   37         ???
1EBE   3B         ???
1EBF   3F         ???
1EC0   20 24 28   JSR $2824
1EC3   2C 30 34   BIT $3430
1EC6   38         SEC
1EC7   3C         ???
1EC8   20 24 28   JSR $2824
1ECB   2C 30 34   BIT $3430
1ECE   38         SEC
1ECF   3C         ???
1ED0   21 25      AND ($25,X)
1ED2   29 2D      AND #$2D
1ED4   31 35      AND ($35),Y
1ED6   39 3D 21   AND $213D,Y
1ED9   25 29      AND $29
1EDB   2D 31 35   AND $3531
1EDE   39 3D 22   AND $223D,Y
1EE1   26 2A      ROL $2A
1EE3   2E 32 36   ROL $3632
1EE6   3A         ???
1EE7   3E 22 26   ROL $2622,X
1EEA   2A         ROL A
1EEB   2E 32 36   ROL $3632
1EEE   3A         ???
1EEF   3E 23 27   ROL $2723,X
1EF2   2B         ???
1EF3   2F         ???
1EF4   33         ???
1EF5   37         ???
1EF6   3B         ???
1EF7   3F         ???
1EF8   23         ???
1EF9   27         ???
1EFA   2B         ???
1EFB   2F         ???
1EFC   33         ???
1EFD   37         ???
1EFE   3B         ???
1EFF   3F         ???

                  * = 1F00
1F00   20 24 28   JSR $2824
1F03   2C 30 34   BIT $3430
1F06   38         SEC
1F07   3C         ???
1F08   20 24 28   JSR $2824
1F0B   2C 30 34   BIT $3430
1F0E   38         SEC
1F0F   3C         ???
1F10   21 25      AND ($25,X)
1F12   29 2D      AND #$2D
1F14   31 35      AND ($35),Y
1F16   39 3D 21   AND $213D,Y
1F19   25 29      AND $29
1F1B   2D 31 35   AND $3531
1F1E   39 3D 22   AND $223D,Y
1F21   26 2A      ROL $2A
1F23   2E 32 36   ROL $3632
1F26   3A         ???
1F27   3E 22 26   ROL $2622,X
1F2A   2A         ROL A
1F2B   2E 32 36   ROL $3632
1F2E   3A         ???
1F2F   3E 23 27   ROL $2723,X
1F32   2B         ???
1F33   2F         ???
1F34   33         ???
1F35   37         ???
1F36   3B         ???
1F37   3F         ???
1F38   23         ???
1F39   27         ???
1F3A   2B         ???
1F3B   2F         ???
1F3C   33         ???
1F3D   37         ???
1F3E   3B         ???
1F3F   3F         ???

// unpack pict from $4000 to $2000
1F40   A0 00      LDY #$00
1F42   A2 40      LDX #$40
1F44   A9 20      LDA #$20
1F46   84 02      STY $02
1F48   86 03      STX $03
1F4A   85 06      STA $06
1F4C   18         CLC
1F4D   69 20      ADC #$20
1F4F   85 07      STA $07
1F51   A2 00      LDX #$00
1F53   86 05      STX $05
1F55   A1 02      LDA ($02,X)
1F57   85 04      STA $04
1F59   E6 02      INC $02
1F5B   D0 02      BNE $1F5F
1F5D   E6 03      INC $03
1F5F   A5 06      LDA $06
1F61   85 01      STA $01
1F63   A5 05      LDA $05
1F65   85 00      STA $00
1F67   A1 02      LDA ($02,X)
1F69   30 43      BMI $1FAE
1F6B   E6 02      INC $02
1F6D   D0 02      BNE $1F71
1F6F   E6 03      INC $03
1F71   A8         TAY
1F72   C8         INY
1F73   A1 02      LDA ($02,X)
1F75   81 00      STA ($00,X)
1F77   48         PHA
1F78   A5 00      LDA $00
1F7A   18         CLC
1F7B   B8         CLV
1F7C   65 04      ADC $04
1F7E   85 00      STA $00
1F80   69 08      ADC #$08
1F82   50 02      BVC $1F86
1F84   85 00      STA $00
1F86   90 0A      BCC $1F92
1F88   85 00      STA $00
1F8A   E6 01      INC $01
1F8C   A5 01      LDA $01
1F8E   C5 07      CMP $07
1F90   B0 0C      BCS $1F9E
1F92   68         PLA
1F93   88         DEY
1F94   D0 DF      BNE $1F75
1F96   E6 02      INC $02
1F98   D0 CD      BNE $1F67
1F9A   E6 03      INC $03
1F9C   D0 C9      BNE $1F67
1F9E   68         PLA
1F9F   E6 02      INC $02
1FA1   D0 02      BNE $1FA5
1FA3   E6 03      INC $03
1FA5   E6 05      INC $05
1FA7   A5 05      LDA $05
1FA9   C5 04      CMP $04
1FAB   D0 B2      BNE $1F5F
1FAD   60         RTS

1FAE   49 80      EOR #$80
1FB0   A8         TAY
1FB1   C8         INY
1FB2   E6 02      INC $02
1FB4   D0 02      BNE $1FB8
1FB6   E6 03      INC $03
1FB8   A1 02      LDA ($02,X)
1FBA   81 00      STA ($00,X)
1FBC   E6 02      INC $02
1FBE   D0 02      BNE $1FC2
1FC0   E6 03      INC $03
1FC2   A5 00      LDA $00
1FC4   18         CLC
1FC5   B8         CLV
1FC6   65 04      ADC $04
1FC8   85 00      STA $00
1FCA   69 08      ADC #$08
1FCC   50 02      BVC $1FD0
1FCE   85 00      STA $00
1FD0   90 0A      BCC $1FDC
1FD2   85 00      STA $00
1FD4   E6 01      INC $01
1FD6   A5 01      LDA $01
1FD8   C5 07      CMP $07
1FDA   B0 C9      BCS $1FA5
1FDC   88         DEY
1FDD   D0 D9      BNE $1FB8
1FDF   F0 86      BEQ $1F67
1FE1   00         BRK
1FE2   00         BRK
1FE3   00         BRK
1FE4   00         BRK
1FE5   00         BRK
1FE6   00         BRK
1FE7   00         BRK
1FE8   00         BRK
1FE9   00         BRK
1FEA   00         BRK
1FEB   00         BRK
1FEC   00         BRK
1FED   00         BRK
1FEE   00         BRK
1FEF   00         BRK
1FF0   00         BRK
1FF1   00         BRK
1FF2   00         BRK
1FF3   00         BRK
1FF4   00         BRK
1FF5   00         BRK
1FF6   00         BRK
1FF7   00         BRK
1FF8   00         BRK
1FF9   00         BRK
1FFA   00         BRK
1FFB   00         BRK
1FFC   00         BRK
1FFD   00         BRK
1FFE   00         BRK
1FFF   FF         ???
2000              .END
