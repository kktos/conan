
    $0300  D9 97 18 D9 09 01 00 00 FF 00 04 00 0D 0E 0D 0B
    $0310  0F 10 0F 0C 00 00 08 2C 00 00 00 00 1E FF 00 00
    $0320  02 01 00 35 2C 2F 13 34 14 32 2B 36 2E 30 2D 33
    $0330  12 31 11 1C 15 16 17 18 30 01 03 00 00 1A 1E 22
    $0340  26 2A 43 61 6E 72 

    $0346  00 00 00 00 00

playerLifeCount
    $034B  03

    $034C  00

    $034D  01 

playerAxeCount    
    $034E 00

    $034F 00
    $0350  19 19 19 1A 1A 1B 1B 

highScore
    $0357  00 00 00 00 00

    $035C  0E 13 18 1D
    $0360  09 0E 13 18 1D DE DE DC DF DF DC 77 7E 7F 00 00
    $0370  00 03 DC 00 05 06 D9 D8 00 00 D8 01 07 08 00 D8
    $0380  10 09 0A 00 88 95 C1 DA D1 A0 8D D3 00 00 CE 9B
    $0390  15 16 17 18 19 1A EB 69 AF 0D C9 6B 8F 0D CA A8
    $03A0  9F 1B 8F 1C 1D 1E 8F 8F 9F 1F 8F 8F 20 21 8F 22
    $03B0  23 24 25 26 27 28 DF DF DF 9F DF 29 2A 2B DF 2C
    $03C0  2D 2E 2F 30 31 32 DF DF 33 34 35 36 37 38 DF 39

                  * = 03D0
03D0   4C BF 9D   JMP $9DBF
03D3   4C 84 9D   JMP $9D84
03D6   4C FD AA   JMP $AAFD
03D9   4C B5 B7   JMP $B7B5

03DC   AD 0F 9D   LDA $9D0F
03DF   AC 0E 9D   LDY $9D0E
03E2   60         RTS

03E3   AD C2 AA   LDA $AAC2
03E6   AC C1 AA   LDY $AAC1
03E9   60         RTS

03EA   4C 51 A8   JMP $A851

03ED   EA         NOP
03EE   EA         NOP
03EF   4C 59 FA   JMP $FA59

03F2   AF BE 1B

                  * = 03F5
03F5   4C 58 FF   JMP $FF58
03F8   4C 65 FF   JMP $FF65
03FB   4C 65 FF   JMP $FF65
03FE   65 FF      ADC $FF
0400              .END

$0400  A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0
$0410  A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0
$0420  A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0
$0430  A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0
$0440  A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0
$0450  A0 A0 A0 20 20 20 20 20 20 20 20 20 20 20 20 20
$0460  20 A0 A0 A0 A0 20 20 20 20 20 20 20 20 20 20 20
$0470  20 20 20 A0 A0 A0 A0 A0 04 FF FF FF FF FF 08 FF
$0480  A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0
$0490  A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0
$04A0  A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 20 20 20 20 20
$04B0  20 20 20 20 20 20 20 20 20 A0 A0 A0 A0 20 20 20
$04C0  20 20 20 20 20 20 20 20 20 20 20 A0 A0 A0 A0 A0
$04D0  A0 A0 A0 20 20 20 20 20 20 20 20 20 20 20 20 20
$04E0  20 A0 A0 A0 A0 20 20 20 20 20 20 20 20 20 20 20
$04F0  20 20 20 A0 A0 A0 A0 A0 04 FF FF FF FF FF 00 FF
$0500  A0 A0 A0 20 20 20 20 20 20 20 20 20 20 20 20 20
$0510  20 A0 A0 A0 A0 20 20 20 20 20 20 20 20 20 20 20
$0520  20 20 20 A0 A0 A0 A0 A0 A0 A0 A0 20 20 20 20 20
$0530  20 20 20 20 20 20 20 20 20 A0 A0 A0 A0 20 20 20
$0540  20 20 20 20 20 20 20 20 20 20 20 A0 A0 A0 A0 A0
$0550  A0 A0 A0 20 20 20 20 20 20 20 20 20 20 20 20 20
$0560  20 A0 A0 A0 A0 20 20 20 20 20 20 20 20 20 20 20
$0570  20 20 20 A0 A0 A0 A0 A0 24 FF FF FF FF FF FF FF
$0580  A0 A0 A0 20 20 20 20 20 20 20 20 20 20 20 20 20
$0590  20 A0 A0 A0 A0 20 20 20 20 20 20 20 20 20 20 20
$05A0  20 20 20 A0 A0 A0 A0 A0 A0 A0 A0 20 20 20 20 20
$05B0  20 20 20 20 20 20 20 20 20 A0 A0 A0 A0 20 20 20
$05C0  20 20 20 20 20 20 20 20 20 20 20 A0 A0 A0 A0 A0
$05D0  A0 A0 A0 20 20 20 20 20 20 20 20 20 20 20 20 20
$05E0  20 A0 A0 A0 A0 20 20 20 20 20 20 20 20 20 20 20
$05F0  20 20 20 A0 A0 A0 A0 A0 60 FF FF FF FF FF FF FF
$0600  A0 A0 A0 20 20 20 20 20 20 20 20 20 20 20 20 20
$0610  20 A0 A0 A0 A0 20 20 20 20 20 20 20 20 20 20 20
$0620  20 20 20 A0 A0 A0 A0 A0 A0 A0 A0 20 20 20 20 20
$0630  20 20 20 20 20 20 20 20 20 A0 A0 A0 A0 20 20 20
$0640  20 20 20 20 20 20 20 20 20 20 20 A0 A0 A0 A0 A0
$0650  A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0
$0660  A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0
$0670  A0 A0 A0 A0 A0 A0 A0 A0 60 FF FF FF FF FF FF FF
$0680  A0 A0 A0 20 20 20 20 20 20 20 20 20 20 20 20 20
$0690  20 A0 A0 A0 A0 20 20 20 20 20 20 20 20 20 20 20
$06A0  20 20 20 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0
$06B0  A0 A0 A0 20 20 20 20 20 20 A0 A0 A0 A0 20 20 20
$06C0  20 20 20 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0
$06D0  A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0
$06E0  A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0
$06F0  A0 A0 A0 A0 A0 A0 A0 A0 02 FF FF FF FF FF FF FF
$0700  A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0
$0710  A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0
$0720  A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0
$0730  A0 A0 A0 20 20 20 20 20 20 A0 A0 A0 A0 20 20 20
$0740  20 20 20 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0
$0750  A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0
$0760  A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0
$0770  A0 A0 A0 A0 A0 A0 A0 A0 FF FF FF FF FF FF FF FF
$0780  A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0
$0790  A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0
$07A0  A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0
$07B0  A0 A0 A0 20 20 20 20 20 20 A0 A0 A0 A0 20 20 20
$07C0  20 20 20 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0
$07D0  A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0
$07E0  A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0 A0
$07F0  A0 A0 A0 A0 A0 A0 A0 A0 C6 FF FF FF FF FF FF FF

                  * = 0800
0800   07         ???
0801   03         ???
0802   38         SEC
0803   60         RTS
0804   A2 FF      LDX #$FF
0806   8E 17 03   STX $0317
0809   E8         INX
080A   8E 06 03   STX $0306
080D   8E 07 03   STX $0307
0810   38         SEC
0811   60         RTS
0812   18         CLC
0813   A2 00      LDX #$00
0815   8E 09 03   STX $0309
0818   60         RTS
0819   AD 33 03   LDA $0333
081C   49 01      EOR #$01
081E   8D 33 03   STA $0333
0821   60         RTS
0822   20 44 15   JSR $1544
0825   20 2F 12   JSR $122F
0828   20 95 12   JSR $1295
082B   20 AD 12   JSR $12AD
082E   20 99 14   JSR $1499
0831   AE 07 03   LDX $0307
0834   F0 03      BEQ $0839
0836   20 19 15   JSR $1519
0839   AE 17 03   LDX $0317
083C   F0 05      BEQ $0843
083E   A2 00      LDX #$00
0840   8E 09 03   STX $0309
0843   60         RTS
0844   AE 0B 03   LDX $030B
0847   10 16      BPL $085F
0849   E0 C9      CPX #$C9
084B   D0 03      BNE $0850
084D   4C 5B 14   JMP $145B
0850   E0 CB      CPX #$CB
0852   D0 03      BNE $0857
0854   4C 66 14   JMP $1466
0857   A2 00      LDX #$00
0859   8E 06 03   STX $0306
085C   8E 07 03   STX $0307
085F   60         RTS
0860   20 17 14   JSR $1417
0863   90 0D      BCC $0872
0865   AE 1F 03   LDX $031F
0868   D0 08      BNE $0872
086A   AE 09 03   LDX $0309
086D   D0 03      BNE $0872
086F   EE 14 03   INC $0314
0872   60         RTS
0873   AE 15 03   LDX $0315
0876   D0 03      BNE $087B
0878   EE 15 03   INC $0315
087B   20 5E 13   JSR $135E
087E   20 17 14   JSR $1417
0881   B0 0E      BCS $0891
0883   A2 00      LDX #$00
0885   8E 15 03   STX $0315
0888   8E 14 03   STX $0314
088B   8E 1F 03   STX $031F
088E   20 AD 12   JSR $12AD
0891   60         RTS
0892   A2 FF      LDX #$FF
0894   8E 22 03   STX $0322
0897   EE 22 03   INC $0322
089A   AE 22 03   LDX $0322
089D   BD 40 AC   LDA $AC40,X
08A0   F0 22      BEQ $08C4
08A2   AD 03 03   LDA $0303
08A5   DD 00 AC   CMP $AC00,X
08A8   90 ED      BCC $0897
08AA   DD 20 AC   CMP $AC20,X
08AD   B0 E8      BCS $0897
08AF   BD 40 AC   LDA $AC40,X
08B2   18         CLC
08B3   69 06      ADC #$06
08B5   CD 04 03   CMP $0304
08B8   90 DD      BCC $0897
08BA   38         SEC
08BB   E9 10      SBC #$10
08BD   CD 04 03   CMP $0304
08C0   B0 D5      BCS $0897
08C2   18         CLC
08C3   60         RTS
08C4   38         SEC
08C5   60         RTS
08C6   AE F6 B3   LDX $B3F6
08C9   F0 34      BEQ $08FF
08CB   AE 1E 03   LDX $031E
08CE   D0 2F      BNE $08FF
08D0   AE 73 03   LDX $0373
08D3   D0 2A      BNE $08FF
08D5   20 15 16   JSR $1615
08D8   B0 25      BCS $08FF
08DA   20 00 16   JSR $1600
08DD   AD 03 03   LDA $0303
08E0   38         SEC
08E1   ED 06 03   SBC $0306
08E4   8D 03 03   STA $0303
08E7   AE 02 03   LDX $0302
08EA   8E 05 03   STX $0305
08ED   20 AD 12   JSR $12AD
08F0   A2 01      LDX #$01
08F2   8E 14 03   STX $0314
08F5   CA         DEX
08F6   8E 07 03   STX $0307
08F9   8E 06 03   STX $0306
08FC   EE 1E 03   INC $031E
08FF   60         RTS


; tables used by L1EC3
; used to load a range of sectors
; track list
; <start> <end>
$0900  00 00 00 00 03 03 03 04 04 04 05 05 05 06 06 06
$0910  07 07 07 08 08 08 0A 0A 0B 0B 0B 0B 0D 0E 0E 0F
$0920  0F 0F 11 11 12 12 12 12 14 15 15 16 16 16 18 19
$0930  19 1A 1A 1A 1A 1A 1A 00 00 00 00 00 00 00 00 00
$0940  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
$0950  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
$0960  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
$0970  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

; sector list
; <start> <end>
$0980  01 09 0D 0E 00 0C 0E 06 07 08 00 09 0B 05 06 07
$0990  07 0D 0F 08 0A 0B 04 0F 01 0A 0C 0D 09 05 07 01
$09A0  03 04 02 0E 00 0A 0D 0E 09 05 07 03 07 08 0E 0A
$09B0  0C 07 08 09 0C 0D 0F 00 00 00 00 00 00 00 00 00
$09C0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
$09D0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
$09E0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
$09F0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

                  * = 0A00
0A00   A2 F8      LDX #$F8
0A02   A0 04      LDY #$04
0A04   8A         TXA
0A05   48         PHA
0A06   AE 80 03   LDX $0380
0A09   BD 20 C0   LDA $C020,X
0A0C   88         DEY
0A0D   D0 FA      BNE $0A09
0A0F   68         PLA
0A10   AA         TAX
0A11   A8         TAY
0A12   88         DEY
0A13   D0 FD      BNE $0A12
0A15   E8         INX
0A16   E0 F8      CPX #$F8
0A18   D0 E8      BNE $0A02
0A1A   EE 03 0A   INC $0A03
0A1D   EE 03 0A   INC $0A03
0A20   AE 03 0A   LDX $0A03
0A23   E0 10      CPX #$10
0A25   D0 D9      BNE $0A00
0A27   A2 04      LDX #$04
0A29   8E 03 0A   STX $0A03
0A2C   60         RTS
0A2D   AD 4F 03   LDA $034F
0A30   F0 1D      BEQ $0A4F
0A32   C9 0D      CMP #$0D
0A34   B0 19      BCS $0A4F
0A36   0A         ASL A
0A37   0A         ASL A
0A38   0A         ASL A
0A39   A0 04      LDY #$04
0A3B   AE 80 03   LDX $0380
0A3E   48         PHA
0A3F   BD 20 C0   LDA $C020,X
0A42   68         PLA
0A43   AA         TAX
0A44   CA         DEX
0A45   D0 FD      BNE $0A44
0A47   88         DEY
0A48   D0 F1      BNE $0A3B
0A4A   38         SEC
0A4B   E9 04      SBC #$04
0A4D   B0 EA      BCS $0A39
0A4F   60         RTS
0A50   A2 08      LDX #$08
0A52   A0 70      LDY #$70
0A54   20 7B 10   JSR $107B
0A57   60         RTS
0A58   A2 60      LDX #$60
0A5A   A0 40      LDY #$40
0A5C   20 7B 10   JSR $107B
0A5F   A2 30      LDX #$30
0A61   A0 60      LDY #$60
0A63   20 7B 10   JSR $107B
0A66   A2 10      LDX #$10
0A68   A0 F0      LDY #$F0
0A6A   20 7B 10   JSR $107B
0A6D   60         RTS
0A6E   A2 90      LDX #$90
0A70   A0 10      LDY #$10
0A72   20 7B 10   JSR $107B
0A75   A2 30      LDX #$30
0A77   A0 A0      LDY #$A0
0A79   20 7B 10   JSR $107B
0A7C   60         RTS
0A7D   20 88 0A   JSR $0A88
0A80   A2 D0      LDX #$D0
0A82   A0 40      LDY #$40
0A84   20 7B 10   JSR $107B
0A87   60         RTS
0A88   A9 01      LDA #$01
0A8A   A0 08      LDY #$08
0A8C   AE 80 03   LDX $0380
0A8F   DD 20 C0   CMP $C020,X
0A92   AA         TAX
0A93   CA         DEX
0A94   D0 FD      BNE $0A93
0A96   88         DEY
0A97   D0 F3      BNE $0A8C
0A99   18         CLC
0A9A   69 09      ADC #$09
0A9C   10 EC      BPL $0A8A
0A9E   60         RTS
0A9F   A9 7F      LDA #$7F
0AA1   A0 08      LDY #$08
0AA3   AE 80 03   LDX $0380
0AA6   DD 20 C0   CMP $C020,X
0AA9   AA         TAX
0AAA   CA         DEX
0AAB   D0 FD      BNE $0AAA
0AAD   88         DEY
0AAE   D0 F3      BNE $0AA3
0AB0   38         SEC
0AB1   E9 09      SBC #$09
0AB3   10 EC      BPL $0AA1
0AB5   60         RTS
0AB6   A2 05      LDX #$05
0AB8   A0 50      LDY #$50
0ABA   20 7B 10   JSR $107B
0ABD   A2 20      LDX #$20
0ABF   A0 30      LDY #$30
0AC1   20 7B 10   JSR $107B
0AC4   60         RTS
0AC5   A2 08      LDX #$08
0AC7   A0 E0      LDY #$E0
0AC9   20 7B 10   JSR $107B
0ACC   20 9F 0A   JSR $0A9F
0ACF   A2 80      LDX #$80
0AD1   A0 70      LDY #$70
0AD3   20 7B 10   JSR $107B
0AD6   60         RTS
0AD7   A2 18      LDX #$18
0AD9   A0 50      LDY #$50
0ADB   20 7B 10   JSR $107B
0ADE   A2 28      LDX #$28
0AE0   A0 68      LDY #$68
0AE2   20 7B 10   JSR $107B
0AE5   60         RTS
0AE6   98         TYA
0AE7   48         PHA
0AE8   20 51 0B   JSR $0B51
0AEB   AA         TAX
0AEC   A0 02      LDY #$02
0AEE   20 7B 10   JSR $107B
0AF1   68         PLA
0AF2   38         SEC
0AF3   E9 01      SBC #$01
0AF5   10 F0      BPL $0AE7
0AF7   60         RTS
0AF8   20 9F 0A   JSR $0A9F
0AFB   EA         NOP
0AFC   EA         NOP
0AFD   EA         NOP
0AFE   EA         NOP
0AFF   EA         NOP
0B00   EA         NOP
0B01   EA         NOP
0B02   20 88 0A   JSR $0A88
0B05   60         RTS
0B06   A2 03      LDX #$03
0B08   A0 70      LDY #$70
0B0A   20 7B 10   JSR $107B
0B0D   A2 F0      LDX #$F0
0B0F   A0 45      LDY #$45
0B11   20 7B 10   JSR $107B
0B14   A2 D0      LDX #$D0
0B16   A0 20      LDY #$20
0B18   20 7B 10   JSR $107B
0B1B   A2 80      LDX #$80
0B1D   A0 18      LDY #$18
0B1F   20 7B 10   JSR $107B
0B22   60         RTS
0B23   20 88 0A   JSR $0A88
0B26   A2 20      LDX #$20
0B28   A0 9A      LDY #$9A
0B2A   20 7B 10   JSR $107B
0B2D   A2 10      LDX #$10
0B2F   A0 B0      LDY #$B0
0B31   20 7B 10   JSR $107B
0B34   20 9F 0A   JSR $0A9F
0B37   A2 80      LDX #$80
0B39   A0 50      LDY #$50
0B3B   20 7B 10   JSR $107B
0B3E   60         RTS
0B3F   A2 10      LDX #$10
0B41   A0 D0      LDY #$D0
0B43   20 7B 10   JSR $107B
0B46   A2 80      LDX #$80
0B48   A0 40      LDY #$40
0B4A   20 7B 10   JSR $107B
0B4D   20 88 0A   JSR $0A88
0B50   60         RTS
0B51   26 4E      ROL $4E
0B53   2E 7A 03   ROL $037A
0B56   2E 71 03   ROL $0371
0B59   A5 4E      LDA $4E
0B5B   0A         ASL A
0B5C   45 4F      EOR $4F
0B5E   4D 71 03   EOR $0371
0B61   2A         ROL A
0B62   2A         ROL A
0B63   2A         ROL A
0B64   2A         ROL A
0B65   2A         ROL A
0B66   48         PHA
0B67   26 4F      ROL $4F
0B69   A5 4F      LDA $4F
0B6B   4D 7A 03   EOR $037A
0B6E   85 4E      STA $4E
0B70   68         PLA
0B71   8D 71 03   STA $0371
0B74   65 4E      ADC $4E
0B76   6D 7A 03   ADC $037A
0B79   8D 72 03   STA $0372
0B7C   60         RTS

$0B7D                                         00 00 00
$0B80  55 2A 55 2A 01 00 00 00 00 00 00 00 00 00 00 00
$0B90  00 00 00 00 00 00 00 00 00 00 40 2A 09 24 55 2A
$0BA0  55 2A 01 00 00 00 00 00 55 02 00 41 00 00 00 00
$0BB0  00 D0 00 00 00 00 00 00 00 00 00 00 00 00 00 00
$0BC0  00 00 00 00 00 00 50 2A 00 00 00 00 20 55 2A 55
$0BD0  55 02 00 D5 00 00 00 00 00 D5 00 00 00 00 00 D5
$0BE0  00 00 00 00 00 D5 00 00 02 01 00 00 00 00 55 02
$0BF0  00 00 00 00 00 00 40 2A 00 00 00 00 00 00 00 00

$0C00  02 05 00 40 0A 40 14 40 1E 40 28 40 32 40 3C 40
$0C10  02 05 46 40 50 40 5A 40 64 40 6E 40 78 40 82 40
$0C20  02 05 8C 40 96 40 A0 40 AA 40 B4 40 BE 40 C8 40
$0C30  02 05 D2 40 DC 40 E6 40 F0 40 FA 40 04 41 0E 41
$0C40  02 05 18 41 22 41 2C 41 36 41 40 41 4A 41 54 41
$0C50  02 05 5E 41 68 41 72 41 7C 41 86 41 90 41 9A 41
$0C60  02 05 A4 41 AE 41 B8 41 C2 41 CC 41 D6 41 E0 41
$0C70  02 05 EA 41 F4 41 FE 41 08 42 12 42 1C 42 26 42
$0C80  02 05 30 42 3A 42 44 42 4E 42 58 42 62 42 6C 42

$0C90  02 05 76 42 80 42 8A 42 94 42 9E 42 A8 42 B2 42
$0CA0  03 10 BC 42 EC 42 1C 43 4C 43 7C 43 AC 43 DC 43
$0CB0  03 10 0C 44 3C 44 6C 44 9C 44 CC 44 FC 44 2C 45
$0CC0  03 90 5C 45 8C 45 BC 45 EC 45 1C 46 4C 46 7C 46
$0CD0  03 8F AC 46 D9 46 06 47 33 47 60 47 8D 47 BA 47
$0CE0  03 90 E7 47 17 48 47 48 77 48 A7 48 D7 48 07 49
$0CF0  03 0F 37 49 64 49 91 49 BE 49 EB 49 18 4A 45 4A
$0D00  03 0C 72 4A 96 4A BA 4A DE 4A 02 4B 26 4B 4A 4B
$0D10  03 8B 6E 4B 8F 4B B0 4B D1 4B F2 4B 13 4C 34 4C
$0D20  03 8C 55 4C 79 4C 9D 4C C1 4C E5 4C 09 4D 2D 4D
$0D30  03 0B 51 4D 72 4D 93 4D B4 4D D5 4D F6 4D 17 4E
$0D40  04 10 38 4E 78 4E B8 4E F8 4E 38 4F 78 4F B8 4F
$0D50  04 90 F8 4F 38 50 78 50 B8 50 F8 50 38 51 78 51
$0D60  04 90 B8 51 F8 51 38 52 78 52 B8 52 F8 52 38 53
$0D70  04 90 78 53 B8 53 F8 53 38 54 78 54 B8 54 F8 54
$0D80  03 10 38 55 68 55 98 55 C8 55 F8 55 28 56 58 56
$0D90  03 0E 88 56 B2 56 DC 56 06 57 30 57 5A 57 84 57
$0DA0  03 0C AE 57 D2 57 F6 57 1A 58 3E 58 62 58 86 58
$0DB0  03 10 AA 58 DA 58 0A 59 3A 59 6A 59 9A 59 CA 59
$0DC0  03 10 FA 59 2A 5A 5A 5A 8A 5A BA 5A EA 5A 1A 5B
$0DD0  03 09 4A 5B 65 5B 80 5B 9B 5B B6 5B D1 5B EC 5B
$0DE0  03 05 07 5C 16 5C 25 5C 34 5C 43 5C 52 5C 61 5C
$0DF0  03 05 70 5C 7F 5C 8E 5C 9D 5C AC 5C BB 5C CA 5C
$0E00  02 84 D9 5C E1 5C E9 5C F1 5C F9 5C 01 5D 09 5D
$0E10  02 84 11 5D 19 5D 21 5D 29 5D 31 5D 39 5D 41 5D
$0E20  02 84 49 5D 51 5D 59 5D 61 5D 69 5D 71 5D 79 5D
$0E30  02 87 81 5D 8F 5D 9D 5D AB 5D B9 5D C7 5D D5 5D
$0E40  02 87 E3 5D F1 5D FF 5D 0D 5E 1B 5E 29 5E 37 5E
$0E50  02 88 45 5E 55 5E 65 5E 75 5E 85 5E 95 5E A5 5E
$0E60  03 83 B5 5E BE 5E C7 5E D0 5E D9 5E E2 5E EB 5E
$0E70  02 85 F4 5E FE 5E 08 5F 12 5F 1C 5F 26 5F 30 5F
$0E80  02 84 3A 5F 42 5F 4A 5F 52 5F 5A 5F 62 5F 6A 5F
$0E90  03 12 72 5F A8 5F DE 5F 14 60 4A 60 80 60 B6 60
$0EA0  03 8C EC 60 10 61 34 61 58 61 7C 61 A0 61 C4 61
$0EB0  03 8B E8 61 09 62 2A 62 4B 62 6C 62 8D 62 AE 62
$0EC0  03 8C CF 62 F3 62 17 63 3B 63 5F 63 83 63 A7 63
$0ED0  03 0B CB 63 EC 63 0D 64 2E 64 4F 64 70 64 91 64
$0EE0  03 8C B2 64 D6 64 FA 64 1E 65 42 65 66 65 8A 65
$0EF0  03 0C AE 65 D2 65 F6 65 1A 66 3E 66 62 66 86 66
$0F00  03 8C AA 66 CE 66 F2 66 16 67 3A 67 5E 67 82 67
$0F10  03 0C A6 67 CA 67 EE 67 12 68 36 68 5A 68 7E 68
$0F20  03 8A A2 68 C0 68 DE 68 FC 68 1A 69 38 69 56 69
$0F30  03 0A 74 69 92 69 B0 69 CE 69 EC 69 0A 6A 28 6A
$0F40  03 8A 46 6A 64 6A 82 6A A0 6A BE 6A DC 6A FA 6A
$0F50  03 0A 18 6B 36 6B 54 6B 72 6B 90 6B AE 6B CC 6B
$0F60  80 80 80 FF FF 80 80 80 FF FF 80 80 80 FF FF 80
$0F70  80 80 FF FF 80 80 80 FF FF 80 80 80 FF FF 80 80
$0F80  80 FF FF 80 80 80 FF FF 80 80 80 FF FF 80 80 80
$0F90  FF FF 80 80 80 FF FF 80 80 80 FF FF 80 80 80 FF
$0FA0  FF 80 80 80 FF FF 80 80 80 FF FF 80 80 80 FF FF
$0FB0  80 80 80 FF FF 80 80 80 FF FF 80 80 80 FF FF 80
$0FC0  80 80 FF FF 80 80 80 FF FF 80 80 80 FF FF 80 80
$0FD0  80 FF FF 80 80 80 FF FF 80 80 80 FF FF 80 80 80
$0FE0  FF FF 80 80 80 FF FF 80 80 80 FF FF 80 80 80 FF
$0FF0  FF 80 80 80 FF FF 80 80 80 FF FF 80 00 00 00 00
