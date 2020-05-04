                  * = 0801
0801   A5 27      LDA $27
0803   C9 09      CMP #$09
0805   D0 18      BNE $081F
0807   A5 2B      LDA $2B
0809   4A         LSR A
080A   4A         LSR A
080B   4A         LSR A
080C   4A         LSR A
080D   09 C0      ORA #$C0
080F   85 3F      STA $3F
0811   A9 5C      LDA #$5C
0813   85 3E      STA $3E
0815   18         CLC
0816   AD FE 08   LDA $08FE
0819   6D FF 08   ADC $08FF
081C   8D FE 08   STA $08FE
081F   AE FF 08   LDX $08FF
0822   30 15      BMI $0839
0824   BD 4D 08   LDA $084D,X
0827   85 3D      STA $3D
0829   CE FF 08   DEC $08FF
082C   AD FE 08   LDA $08FE
082F   85 27      STA $27
0831   CE FE 08   DEC $08FE
0834   A6 2B      LDX $2B
0836   6C 3E 00   JMP ($003E)

0839   EE FE 08   INC $08FE
083C   EE FE 08   INC $08FE
083F   20 89 FE   JSR $FE89
0842   20 93 FE   JSR $FE93
0845   20 2F FB   JSR $FB2F
0848   A6 2B      LDX $2B
084A   4C B4 08   JMP $08B4

084D   00         BRK
084E   0D 0B 09   ORA $090B
0851   07         ???
0852   05 03      ORA $03
0854   01 0E      ORA ($0E,X)
0856   0C         ???
0857   0A         ASL A
0858   08         PHP
0859   06 04      ASL $04
085B   02         ???
085C   0F         ???
085D   00         BRK
085E   20 64 A7   JSR $A764
0861   B0 08      BCS $086B
0863   A9 00      LDA #$00
0865   A8         TAY
0866   8D 5D B6   STA $B65D
0869   91 40      STA ($40),Y
086B   AD C5 B5   LDA $B5C5
086E   4C D2 A6   JMP $A6D2
0871   AD 5D B6   LDA $B65D
0874   F0 08      BEQ $087E
0876   EE BD B5   INC $B5BD
0879   D0 03      BNE $087E
087B   EE BE B5   INC $B5BE
087E   A9 00      LDA #$00
0880   8D 5D B6   STA $B65D
0883   4C 46 A5   JMP $A546
0886   8D BC B5   STA $B5BC
0889   20 A8 A6   JSR $A6A8
088C   20 EA A2   JSR $A2EA
088F   4C 7D A2   JMP $A27D
0892   A0 13      LDY #$13
0894   B1 42      LDA ($42),Y
0896   D0 14      BNE $08AC
0898   C8         INY
0899   C0 17      CPY #$17
089B   D0 F7      BNE $0894
089D   A0 19      LDY #$19
089F   B1 42      LDA ($42),Y
08A1   99 A4 B5   STA $B5A4,Y
08A4   C8         INY
08A5   C0 1D      CPY #$1D
08A7   D0 F6      BNE $089F
08A9   4C BC A6   JMP $A6BC
08AC   A2 FF      LDX #$FF
08AE   8E 5D B6   STX $B65D
08B1   D0 F6      BNE $08A9
08B3   00         BRK

08B4   A9 00      LDA #$00
08B6   8D 78 04   STA $0478
08B9   8D F8 04   STA $04F8
08BC   8D 7E 04   STA $047E
08BF   8D FE 04   STA $04FE
08C2   6C FD 08   JMP ($08FD)
08C5   00         BRK
08C6   00         BRK
08C7   00         BRK
08C8   00         BRK
08C9   00         BRK
08CA   00         BRK
08CB   00         BRK
08CC   00         BRK
08CD   00         BRK
08CE   00         BRK
08CF   00         BRK
08D0   20 58 FC   JSR $FC58
08D3   A9 C2      LDA #$C2
08D5   20 ED FD   JSR $FDED
08D8   A9 01      LDA #$01
08DA   20 DA FD   JSR $FDDA
08DD   A9 AD      LDA #$AD
08DF   20 ED FD   JSR $FDED
08E2   A9 00      LDA #$00
08E4   20 DA FD   JSR $FDDA
08E7   60         RTS
08E8   00         BRK
08E9   00         BRK
08EA   00         BRK
08EB   00         BRK
08EC   00         BRK
08ED   00         BRK
08EE   00         BRK
08EF   00         BRK
08F0   00         BRK
08F1   00         BRK
08F2   00         BRK
08F3   00         BRK
08F4   00         BRK
08F5   00         BRK
08F6   00         BRK
08F7   00         BRK
08F8   00         BRK
08F9   00         BRK
08FA   00         BRK
08FB   00         BRK
08FC   00         BRK
08FD   00         BRK
08FE   B6
