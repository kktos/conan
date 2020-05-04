                  * = 4000
4000   A2 02      LDX #$02
4002   8E F1 B7   STX $B7F1
4005   A2 01      LDX #$01
4007   8E EC B7   STX $B7EC
400A   8E F4 B7   STX $B7F4
400D   CA         DEX
400E   8E ED B7   STX $B7ED
4011   86 48      STX $48
4013   8E EB B7   STX $B7EB
4016   A0 E8      LDY #$E8
4018   A9 B7      LDA #$B7
401A   20 B5 B7   JSR $B7B5
401D   EE ED B7   INC $B7ED
4020   EE F1 B7   INC $B7F1
4023   A2 00      LDX #$00
4025   86 48      STX $48
4027   A0 E8      LDY #$E8
4029   A9 B7      LDA #$B7
402B   20 B5 B7   JSR $B7B5
402E   4C 00 02   JMP $0200
4031   A9 00      LDA #$00
4033   8D F4 B7   STA $B7F4
4036   A9 10      LDA #$10
4038   8D EC B7   STA $B7EC
403B   A9 B7      LDA #$B7
403D   A0 E8      LDY #$E8
403F   20 B5 B7   JSR $B7B5
4042   BD 89 C0   LDA $C089,X
4045   A9 01      LDA #$01
4047   8D F4 B7   STA $B7F4
404A   A0 FF      LDY #$FF
404C   8C AB B7   STY $B7AB
404F   EE AB B7   INC $B7AB
4052   A9 00      LDA #$00
4054   85 3E      STA $3E
4056   85 3F      STA $3F
4058   85 48      STA $48
405A   A0 04      LDY #$04
405C   C6 3E      DEC $3E
405E   D0 04      BNE $4064
4060   C6 3F      DEC $3F
4062   F0 30      BEQ $4094
4064   BD 8C C0   LDA $C08C,X
4067   EA         NOP
4068   10 FA      BPL $4064
406A   D9 A5 B7   CMP $B7A5,Y
406D   D0 EB      BNE $405A
406F   88         DEY
4070   10 F2      BPL $4064
4072   A0 08      LDY #$08
4074   BD 8C C0   LDA $C08C,X
4077   85 2C      STA $2C
4079   10 F9      BPL $4074
407B   88         DEY
407C   D0 F6      BNE $4074
407E   20 AC B7   JSR $B7AC
4081   AC AB B7   LDY $B7AB
4084   D0 05      BNE $408B
4086   8D AA B7   STA $B7AA
4089   F0 C4      BEQ $404F
408B   CD AA B7   CMP $B7AA
408E   D0 0F      BNE $409F
4090   C0 18      CPY #$18
4092   D0 BB      BNE $404F
4094   BA         TSX
4095   A9 BE      LDA #$BE
4097   9D 02 01   STA $0102,X
409A   A9 AE      LDA #$AE
409C   4C C8 BF   JMP $BFC8
409F   BC 88 C0   LDY $C088,X
40A2   4C 00 A0   JMP $A000
40A5   AD BD BA   LDA $BABD
40A8   B7         ???
40A9   D5 00      CMP $00,X
40AB   00         BRK
40AC   BD 8C C0   LDA $C08C,X
40AF   EA         NOP
40B0   10 FA      BPL $40AC
40B2   60         RTS
40B3   DF         ???
40B4   60         RTS
40B5   08         PHP
40B6   78         SEI
40B7   20 00 BD   JSR $BD00
40BA   B0 03      BCS $40BF
40BC   28         PLP
40BD   18         CLC
40BE   60         RTS
40BF   28         PLP
40C0   38         SEC
40C1   60         RTS
40C2   AD BC B5   LDA $B5BC
40C5   8D F1 B7   STA $B7F1
40C8   A9 00      LDA #$00
40CA   8D F0 B7   STA $B7F0
40CD   AD F9 B5   LDA $B5F9
40D0   49 FF      EOR #$FF
40D2   8D EB B7   STA $B7EB
40D5   60         RTS
40D6   A9 00      LDA #$00
40D8   A8         TAY
40D9   91 42      STA ($42),Y
40DB   C8         INY
40DC   D0 FB      BNE $40D9
40DE   60         RTS
40DF   00         BRK
40E0   1B         ???
40E1   02         ???
40E2   0A         ASL A
40E3   1B         ???
40E4   E8         INX
40E5   B7         ???
40E6   00         BRK
40E7   B6 01      LDX $01,Y
40E9   60         RTS
40EA   01 FE      ORA ($FE,X)
40EC   00         BRK
40ED   01 FB      ORA ($FB,X)
40EF   B7         ???
40F0   00         BRK
40F1   B7         ???
40F2   00         BRK
40F3   00         BRK
40F4   02         ???
40F5   03         ???
40F6   FE 60 01   INC $0160,X
40F9   00         BRK
40FA   00         BRK
40FB   00         BRK
40FC   01 EF      ORA ($EF,X)
40FE   D8         CLD
40FF   00         BRK

// relocate MEM[4000-40FF] to MEM[B700-B7FF]
4100   A0 00      LDY #$00
4102   B9 00 40   LDA $4000,Y
4105   99 00 B7   STA $B700,Y
4108   C8         INY
4109   D0 F7      BNE $4102
410B   68         PLA
410C   AA         TAX
410D   BD 89 C0   LDA $C089,X
4110   4C 00 B7   JMP $B700

4113   08         PHP
4114   00         BRK
4115   80         ???
4116   A8         TAY
4117   0C         ???
4118   00         BRK
4119   82         ???
411A   40         RTI
411B   7F         ???
411C   1F         ???
411D   1F         ???
411E   00         BRK
411F   85 18      STA $18
4121   00         BRK
4122   64         ???
4123   00         BRK
4124   18         CLC
4125   01 02      ORA ($02,X)
4127   00         BRK
4128   82         ???
4129   0C         ???
412A   00         BRK
412B   06 08      ASL $08
412D   00         BRK
412E   8A         TXA
412F   8A         TXA
4130   00         BRK
4131   07         ???
4132   7E 60 70   ROR $7060,X
4135   00         BRK
4136   7F         ???
4137   1F         ???
4138   0F         ???
4139   A8         TAY
413A   05 00      ORA $00
413C   84 60      STY $60
413E   0C         ???
413F   00         BRK
4140   62         ???
4141   18         CLC
4142   01 0C      ORA ($0C,X)
4144   88         DEY
4145   10 78      BPL $41BF
4147   7F         ???
4148   00         BRK
4149   40         RTI
414A   46 18      LSR $18
414C   06 0C      ASL $0C
414E   06 00      ASL $00
4150   8A         TXA
4151   78         SEI
4152   0F         ???
4153   1E 3C 7B   ASL $7B3C,X
4156   1B         ???
4157   7C         ???
4158   0F         ???
4159   60         RTS
415A   6E 0F 08   ROR $080F
415D   00         BRK
415E   81 8A      STA ($8A,X)
4160   0F         ???
4161   01 00      ORA ($00,X)
4163   86 07      STX $07
4165   1F         ???
4166   40         RTI
4167   3C         ???
4168   43         ???
4169   01 A8      ORA ($A8,X)
416B   0C         ???
416C   00         BRK
416D   82         ???
416E   60         RTS
416F   7F         ???
4170   3F         ???
4171   20 00 8A   JSR $8A00
4174   8A         TXA
4175   60         RTS
4176   1E 07 00   ASL $0007,X
4179   40         RTI
417A   0E 7E 07   ASL $077E
417D   03         ???
417E   A8         TAY
417F   1F         ???
4180   00         BRK
4181   84 40      STY $40
4183   09 12      ORA #$12
4185   44         ???
4186   24 21      BIT $21
4188   00         BRK
4189   87         ???
418A   60         RTS
418B   3C         ???
418C   00         BRK
418D   4E 47 07   LSR $0747
4190   70 0F      BVS $41A1
4192   5B         ???
4193   00         BRK
4194   80         ???
4195   60         RTS
4196   02         ???
4197   00         BRK
4198   81 0C      STA ($0C,X)
419A   03         ???
419B   1F         ???
419C   00         BRK
419D   0A         ASL A
419E   AA         TAX
419F   30 00      BMI $41A1
41A1   80         ???
41A2   8A         TXA
41A3   08         PHP
41A4   00         BRK
41A5   80         ???
41A6   A8         TAY
41A7   05 00      ORA $00
41A9   80         ???
41AA   70 01      BVS $41AD
41AC   00         BRK
41AD   81 07      STA ($07,X)
41AF   01 01      ORA ($01,X)
41B1   00         BRK
41B2   82         ???
41B3   60         RTS
41B4   7F         ???
41B5   3F         ???
41B6   1F         ???
41B7   00         BRK
41B8   85 18      STA $18
41BA   00         BRK
41BB   06 00      ASL $00
41BD   18         CLC
41BE   01 02      ORA ($02,X)
41C0   00         BRK
41C1   82         ???
41C2   06 00      ASL $00
41C4   06 08      ASL $08
41C6   00         BRK
41C7   8A         TXA
41C8   8A         TXA
41C9   60         RTS
41CA   1E 03 00   ASL $0003,X
41CD   40         RTI
41CE   00         BRK
41CF   7E 0F 03   ROR $030F,X
41D2   A8         TAY
41D3   05 00      ORA $00
41D5   8F         ???
41D6   60         RTS
41D7   0C         ???
41D8   00         BRK
41D9   42         ???
41DA   18         CLC
41DB   0C         ???
41DC   06 10      ASL $10
41DE   00         BRK
41DF   7F         ???
41E0   00         BRK
41E1   40         RTI
41E2   26 30      ROL $30
41E4   06 0C      ASL $0C
41E6   1A         ???
41E7   00         BRK
41E8   81 8A      STA ($8A,X)
41EA   0F         ???
41EB   01 00      ORA ($00,X)
41ED   86 07      STX $07
41EF   3E 60 3C   ROL $3C60,X
41F2   03         ???
41F3   01 A8      ORA ($A8,X)
41F5   0C         ???
41F6   00         BRK
41F7   82         ???
41F8   60         RTS
41F9   7F         ???
41FA   3F         ???
41FB   20 00 8A   JSR $8A00
41FE   8A         TXA
41FF   00         BRK
4200              .END
