		.namespace loader

		.org $B700

;
; https://apple2.org.za/gswv/a2zine/GS.WorldView/Resources/DOS.3.3.ANATOMY/BOOT.PROCESS.txt
;

BOOT1               stx local_rwts_slot
                    stx local_rwts_lstslot
                    txa
                    pha
                    lsr a
                    lsr a
                    lsr a
                    lsr a
                    tax
                    lda #$00
                    sta $0478,x
                    sta $04f8,x
                    lda #$9d
                    sta LB792
                    lda #$b7
                    sta LB793

;
; START CRACKERS PAGE
;

; load disk[2800-2FFF] mem[4000-4FFF]

Lb71f
		bra boot1_2
		    ; lda #>local_rwts_iob
                    ldy #<local_rwts_iob
                    sei
                    jsr rwts

                    dec local_rwts_sector
                    dec local_rwts_hibuf
                    lda local_rwts_hibuf
                    cmp #$40
                    bcs Lb71f

; load disk[2800-2FFF] mem[1D00-1FFF]

                    lda #$1f
                    sta local_rwts_hibuf
Lb739               lda #>local_rwts_iob
                    ldy #<local_rwts_iob
                    sei
                    jsr rwts

                    dec local_rwts_sector
                    dec local_rwts_hibuf
                    lda local_rwts_hibuf
                    cmp #$1d
                    bcs Lb739

; unpack cracker splash screen
                    jsr $1f40

                    lda $c057
                    lda $c054
                    lda $c052
                    lda $c050

; display cracker splash screen
                    jsr $1d00

;
; END CRACKERS PAGE
;

; load disk[0A00-0Bff] mem[4000-41FF]
boot1_2
                    lda #$00
                    sta local_rwts_track
                    lda #$0b
                    sta local_rwts_sector
                    lda #$41
                    sta local_rwts_hibuf
                    lda #>local_rwts_iob
                    ldy #<local_rwts_iob
                    sei
                    jsr rwts

                    dec local_rwts_sector
                    dec local_rwts_hibuf
                    lda #>local_rwts_iob
                    ldy #<local_rwts_iob
                    sei
                    jsr rwts

                    lda #$00
                    sta $48
                    jmp L4100

local_rwts_iob:
                    .DB $01
local_rwts_slot     .DB $60
                    .DB $01
                    .DB $00
local_rwts_track    .DB $02
local_rwts_sector   .DB $0f
LB792               .DB $ff
LB793               .DB $ff
local_rwts_lobuf    .DB $00
local_rwts_hibuf    .DB $47
                    .DB $00
                    .DB $00
                    .DB $01
                    .DB $00
                    .DB $00
local_rwts_lstslot  .DB $60

                    .DB $01
                    .DB $00
                    .DB $01
                    .DB $ef
                    .DB $d8

		.align $100

		.if 0
                    .DB $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
                    .DB $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
                    .DB $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
                    .DB $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
                    .DB $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
                    .DB $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00 $00
		.end

                    .if 0

B800   A2 00      LDX #$00
B802   A0 02      LDY #$02
B804   88         DEY
B805   B1 3E      LDA ($3E),Y
B807   4A         LSR A
B808   3E 00 BC   ROL $BC00,X
B80B   4A         LSR A
B80C   3E 00 BC   ROL $BC00,X
B80F   99 00 BB   STA $BB00,Y
B812   E8         INX
B813   E0 56      CPX #$56
B815   90 ED      BCC $B804
B817   A2 00      LDX #$00
B819   98         TYA
B81A   D0 E8      BNE $B804
B81C   A2 55      LDX #$55
B81E   BD 00 BC   LDA $BC00,X
B821   29 3F      AND #$3F
B823   9D 00 BC   STA $BC00,X
B826   CA         DEX
B827   10 F5      BPL $B81E
B829   60         RTS
B82A   38         SEC
B82B   86 27      STX $27
B82D   8E 78 06   STX $0678
B830   BD 8D C0   LDA $C08D,X
B833   BD 8E C0   LDA $C08E,X
B836   30 7C      BMI $B8B4
B838   AD 00 BC   LDA $BC00
B83B   85 26      STA $26
B83D   A9 FF      LDA #$FF
B83F   9D 8F C0   STA $C08F,X
B842   1D 8C C0   ORA $C08C,X
B845   48         PHA
B846   68         PLA
B847   EA         NOP
B848   A0 04      LDY #$04
B84A   48         PHA
B84B   68         PLA
B84C   20 B9 B8   JSR $B8B9
B84F   88         DEY
B850   D0 F8      BNE $B84A
B852   A9 D5      LDA #$D5
B854   20 B8 B8   JSR $B8B8
B857   A9 AA      LDA #$AA
B859   20 B8 B8   JSR $B8B8
B85C   A9 AD      LDA #$AD
B85E   20 B8 B8   JSR $B8B8
B861   98         TYA
B862   A0 56      LDY #$56
B864   D0 03      BNE $B869
B866   B9 00 BC   LDA $BC00,Y
B869   59 FF BB   EOR $BBFF,Y
B86C   AA         TAX
B86D   BD 29 BA   LDA $BA29,X
B870   A6 27      LDX $27
B872   9D 8D C0   STA $C08D,X
B875   BD 8C C0   LDA $C08C,X
B878   88         DEY
B879   D0 EB      BNE $B866
B87B   A5 26      LDA $26
B87D   EA         NOP
B87E   59 00 BB   EOR $BB00,Y
B881   AA         TAX
B882   BD 29 BA   LDA $BA29,X
B885   AE 78 06   LDX $0678
B888   9D 8D C0   STA $C08D,X
B88B   BD 8C C0   LDA $C08C,X
B88E   B9 00 BB   LDA $BB00,Y
B891   C8         INY
B892   D0 EA      BNE $B87E
B894   AA         TAX
B895   BD 29 BA   LDA $BA29,X
B898   A6 27      LDX $27
B89A   20 BB B8   JSR $B8BB
B89D   A9 DE      LDA #$DE
B89F   20 B8 B8   JSR $B8B8
B8A2   A9 AA      LDA #$AA
B8A4   20 B8 B8   JSR $B8B8
B8A7   A9 EB      LDA #$EB
B8A9   20 B8 B8   JSR $B8B8
B8AC   A9 FF      LDA #$FF
B8AE   20 B8 B8   JSR $B8B8
B8B1   BD 8E C0   LDA $C08E,X
B8B4   BD 8C C0   LDA $C08C,X
B8B7   60         RTS
B8B8   18         CLC
B8B9   48         PHA
B8BA   68         PLA
B8BB   9D 8D C0   STA $C08D,X
B8BE   1D 8C C0   ORA $C08C,X
B8C1   60         RTS
B8C2   A0 00      LDY #$00
B8C4   A2 56      LDX #$56
B8C6   CA         DEX
B8C7   30 FB      BMI $B8C4
B8C9   B9 00 BB   LDA $BB00,Y
B8CC   5E 00 BC   LSR $BC00,X
B8CF   2A         ROL A
B8D0   5E 00 BC   LSR $BC00,X
B8D3   2A         ROL A
B8D4   91 3E      STA ($3E),Y
B8D6   C8         INY
B8D7   C4 26      CPY $26
B8D9   D0 EB      BNE $B8C6
B8DB   60         RTS
B8DC   A0 20      LDY #$20
B8DE   88         DEY
B8DF   F0 61      BEQ $B942
B8E1   BD 8C C0   LDA $C08C,X
B8E4   10 FB      BPL $B8E1
B8E6   49 D5      EOR #$D5
B8E8   D0 F4      BNE $B8DE
B8EA   EA         NOP
B8EB   BD 8C C0   LDA $C08C,X
B8EE   10 FB      BPL $B8EB
B8F0   C9 AA      CMP #$AA
B8F2   D0 F2      BNE $B8E6
B8F4   A0 56      LDY #$56
B8F6   BD 8C C0   LDA $C08C,X
B8F9   10 FB      BPL $B8F6
B8FB   C9 AD      CMP #$AD
B8FD   D0 E7      BNE $B8E6
B8FF   A9 00      LDA #$00
B901   88         DEY
B902   84 26      STY $26
B904   BC 8C C0   LDY $C08C,X
B907   10 FB      BPL $B904
B909   59 00 BA   EOR $BA00,Y
B90C   A4 26      LDY $26
B90E   99 00 BC   STA $BC00,Y
B911   D0 EE      BNE $B901
B913   84 26      STY $26
B915   BC 8C C0   LDY $C08C,X
B918   10 FB      BPL $B915
B91A   59 00 BA   EOR $BA00,Y
B91D   A4 26      LDY $26
B91F   99 00 BB   STA $BB00,Y
B922   C8         INY
B923   D0 EE      BNE $B913
B925   BC 8C C0   LDY $C08C,X
B928   10 FB      BPL $B925
B92A   D9 00 BA   CMP $BA00,Y
B92D   D0 13      BNE $B942
B92F   BD 8C C0   LDA $C08C,X
B932   10 FB      BPL $B92F
B934   C9 DE      CMP #$DE
B936   D0 0A      BNE $B942
B938   EA         NOP
B939   BD 8C C0   LDA $C08C,X
B93C   10 FB      BPL $B939
B93E   C9 AA      CMP #$AA
B940   F0 5C      BEQ $B99E
B942   38         SEC
B943   60         RTS
B944   A0 FC      LDY #$FC
B946   84 26      STY $26
B948   C8         INY
B949   D0 04      BNE $B94F
B94B   E6 26      INC $26
B94D   F0 F3      BEQ $B942
B94F   BD 8C C0   LDA $C08C,X
B952   10 FB      BPL $B94F
B954   C9 D5      CMP #$D5
B956   D0 F0      BNE $B948
B958   EA         NOP
B959   BD 8C C0   LDA $C08C,X
B95C   10 FB      BPL $B959
B95E   C9 AA      CMP #$AA
B960   D0 F2      BNE $B954
B962   A0 03      LDY #$03
B964   BD 8C C0   LDA $C08C,X
B967   10 FB      BPL $B964
B969   C9 96      CMP #$96
B96B   D0 E7      BNE $B954
B96D   A9 00      LDA #$00
B96F   85 27      STA $27
B971   BD 8C C0   LDA $C08C,X
B974   10 FB      BPL $B971
B976   2A         ROL A
B977   85 26      STA $26
B979   BD 8C C0   LDA $C08C,X
B97C   10 FB      BPL $B979
B97E   25 26      AND $26
B980   99 2C 00   STA $002C,Y
B983   45 27      EOR $27
B985   88         DEY
B986   10 E7      BPL $B96F
B988   A8         TAY
B989   D0 B7      BNE $B942
B98B   BD 8C C0   LDA $C08C,X
B98E   10 FB      BPL $B98B
B990   C9 DE      CMP #$DE
B992   D0 AE      BNE $B942
B994   EA         NOP
B995   BD 8C C0   LDA $C08C,X
B998   10 FB      BPL $B995
B99A   C9 AA      CMP #$AA
B99C   D0 A4      BNE $B942
B99E   18         CLC
B99F   60         RTS
B9A0   86 2B      STX $2B
B9A2   85 2A      STA $2A
B9A4   CD 78 04   CMP $0478
B9A7   F0 53      BEQ $B9FC
B9A9   A9 00      LDA #$00
B9AB   85 26      STA $26
B9AD   AD 78 04   LDA $0478
B9B0   85 27      STA $27
B9B2   38         SEC
B9B3   E5 2A      SBC $2A
B9B5   F0 33      BEQ $B9EA
B9B7   B0 07      BCS $B9C0
B9B9   49 FF      EOR #$FF
B9BB   EE 78 04   INC $0478
B9BE   90 05      BCC $B9C5
B9C0   69 FE      ADC #$FE
B9C2   CE 78 04   DEC $0478
B9C5   C5 26      CMP $26
B9C7   90 02      BCC $B9CB
B9C9   A5 26      LDA $26
B9CB   C9 0C      CMP #$0C
B9CD   B0 01      BCS $B9D0
B9CF   A8         TAY
B9D0   38         SEC
B9D1   20 EE B9   JSR $B9EE
B9D4   B9 11 BA   LDA $BA11,Y
B9D7   20 00 BA   JSR $BA00
B9DA   A5 27      LDA $27
B9DC   18         CLC
B9DD   20 F1 B9   JSR $B9F1
B9E0   B9 1D BA   LDA $BA1D,Y
B9E3   20 00 BA   JSR $BA00
B9E6   E6 26      INC $26
B9E8   D0 C3      BNE $B9AD
B9EA   20 00 BA   JSR $BA00
B9ED   18         CLC
B9EE   AD 78 04   LDA $0478
B9F1   29 03      AND #$03
B9F3   2A         ROL A
B9F4   05 2B      ORA $2B
B9F6   AA         TAX
B9F7   BD 80 C0   LDA $C080,X
B9FA   A6 2B      LDX $2B
B9FC   60         RTS
B9FD   AA         TAX
B9FE   A0 A0      LDY #$A0
BA00   A2 11      LDX #$11
BA02   CA         DEX
BA03   D0 FD      BNE $BA02
BA05   E6 46      INC $46
BA07   D0 02      BNE $BA0B
BA09   E6 47      INC $47
BA0B   38         SEC
BA0C   E9 01      SBC #$01
BA0E   D0 F0      BNE $BA00
BA10   60         RTS
BA11   01 30      ORA ($30,X)
BA13   28         PLP
BA14   24 20      BIT $20
BA16   1E 1D 1C   ASL $1C1D,X
BA19   1C         ???
BA1A   1C         ???
BA1B   1C         ???
BA1C   1C         ???
BA1D   70 2C      BVS $BA4B
BA1F   26 22      ROL $22
BA21   1F         ???
BA22   1E 1D 1C   ASL $1C1D,X
BA25   1C         ???
BA26   1C         ???
BA27   1C         ???
BA28   1C         ???
BA29   96 97      STX $97,Y
BA2B   9A         TXS
BA2C   9B         ???
BA2D   9D 9E 9F   STA $9F9E,X
BA30   A6 A7      LDX $A7
BA32   AB         ???
BA33   AC AD AE   LDY $AEAD
BA36   AF         ???
BA37   B2         ???
BA38   B3         ???
BA39   B4 B5      LDY $B5,X
BA3B   B6 B7      LDX $B7,Y
BA3D   B9 BA BB   LDA $BBBA,Y
BA40   BC BD BE   LDY $BEBD,X
BA43   BF         ???
BA44   CB         ???
BA45   CD CE CF   CMP $CFCE
BA48   D3         ???
BA49   D6 D7      DEC $D7,X
BA4B   D9 DA DB   CMP $DBDA,Y
BA4E   DC         ???
BA4F   DD DE DF   CMP $DFDE,X
BA52   E5 E6      SBC $E6
BA54   E7         ???
BA55   E9 EA      SBC #$EA
BA57   EB         ???
BA58   EC ED EE   CPX $EEED
BA5B   EF         ???
BA5C   F2         ???
BA5D   F3         ???
BA5E   F4         ???
BA5F   F5 F6      SBC $F6,X
BA61   F7         ???
BA62   F9 FA FB   SBC $FBFA,Y
BA65   FC         ???
BA66   FD FE FF   SBC $FFFE,X
BA69   B3         ???
BA6A   B3         ???
BA6B   A0 E0      LDY #$E0
BA6D   B3         ???
BA6E   C3         ???
BA6F   C5 B3      CMP $B3
BA71   A0 E0      LDY #$E0
BA73   B3         ???
BA74   C3         ???
BA75   C5 B3      CMP $B3
BA77   A0 E0      LDY #$E0
BA79   B3         ???
BA7A   B3         ???
BA7B   C5 AA      CMP $AA
BA7D   A0 82      LDY #$82
BA7F   B3         ???
BA80   B3         ???
BA81   C5 AA      CMP $AA
BA83   A0 82      LDY #$82
BA85   C5 B3      CMP $B3
BA87   B3         ???
BA88   AA         TAX
BA89   88         DEY
BA8A   82         ???
BA8B   C5 B3      CMP $B3
BA8D   B3         ???
BA8E   AA         TAX
BA8F   88         DEY
BA90   82         ???
BA91   C5 C4      CMP $C4
BA93   B3         ???
BA94   B0 88      BCS $BA1E
BA96   00         BRK
BA97   01 98      ORA ($98,X)
BA99   99 02 03   STA $0302,Y
BA9C   9C         ???
BA9D   04         ???
BA9E   05 06      ORA $06
BAA0   A0 A1      LDY #$A1
BAA2   A2 A3      LDX #$A3
BAA4   A4 A5      LDY $A5
BAA6   07         ???
BAA7   08         PHP
BAA8   A8         TAY
BAA9   A9 AA      LDA #$AA
BAAB   09 0A      ORA #$0A
BAAD   0B         ???
BAAE   0C         ???
BAAF   0D B0 B1   ORA $B1B0
BAB2   0E 0F 10   ASL $100F
BAB5   11 12      ORA ($12),Y
BAB7   13         ???
BAB8   B8         CLV
BAB9   14         ???
BABA   15 16      ORA $16,X
BABC   17         ???
BABD   18         CLC
BABE   19 1A C0   ORA $C01A,Y
BAC1   C1 C2      CMP ($C2,X)
BAC3   C3         ???
BAC4   C4 C5      CPY $C5
BAC6   C6 C7      DEC $C7
BAC8   C8         INY
BAC9   C9 CA      CMP #$CA
BACB   1B         ???
BACC   CC 1C 1D   CPY $1D1C
BACF   1E D0 D1   ASL $D1D0,X
BAD2   D2         ???
BAD3   1F         ???
BAD4   D4         ???
BAD5   D5 20      CMP $20,X
BAD7   21 D8      AND ($D8,X)
BAD9   22         ???
BADA   23         ???
BADB   24 25      BIT $25
BADD   26 27      ROL $27
BADF   28         PLP
BAE0   E0 E1      CPX #$E1
BAE2   E2         ???
BAE3   E3         ???
BAE4   E4 29      CPX $29
BAE6   2A         ROL A
BAE7   2B         ???
BAE8   E8         INX
BAE9   2C 2D 2E   BIT $2E2D
BAEC   2F         ???
BAED   30 31      BMI $BB20
BAEF   32         ???
BAF0   F0 F1      BEQ $BAE3
BAF2   33         ???
BAF3   34         ???
BAF4   35 36      AND $36,X
BAF6   37         ???
BAF7   38         SEC
BAF8   F8         SED
BAF9   39 3A 3B   AND $3B3A,Y
BAFC   3C         ???
BAFD   3D 3E 3F   AND $3F3E,X
BB00   28         PLP
BB01   04         ???
BB02   32         ???
BB03   34         ???
BB04   3F         ???
BB05   39 11 34   AND $3411,Y
BB08   00         BRK
BB09   39 11 0E   AND $0E11,Y
BB0C   3A         ???
BB0D   00         BRK
BB0E   34         ???
BB0F   3C         ???
BB10   18         CLC
BB11   00         BRK
BB12   0C         ???
BB13   0A         ASL A
BB14   09 08      ORA #$08
BB16   07         ???
BB17   07         ???
BB18   07         ???
BB19   07         ???
BB1A   07         ???
BB1B   07         ???
BB1C   07         ???
BB1D   1C         ???
BB1E   0B         ???
BB1F   09 08      ORA #$08
BB21   07         ???
BB22   07         ???
BB23   07         ???
BB24   07         ???
BB25   07         ???
BB26   07         ???
BB27   07         ???
BB28   07         ???
BB29   25 25      AND $25
BB2B   26 26      ROL $26
BB2D   27         ???
BB2E   27         ???
BB2F   27         ???
BB30   29 29      AND #$29
BB32   2A         ROL A
BB33   2B         ???
BB34   2B         ???
BB35   2B         ???
BB36   2B         ???
BB37   2C 2C 2D   BIT $2D2C
BB3A   2D 2D 2D   AND $2D2D
BB3D   2E 2E 2E   ROL $2E2E
BB40   2F         ???
BB41   2F         ???
BB42   2F         ???
BB43   2F         ???
BB44   32         ???
BB45   33         ???
BB46   33         ???
BB47   33         ???
BB48   34         ???
BB49   35 35      AND $35,X
BB4B   36 36      ROL $36,X
BB4D   36 37      ROL $37,X
BB4F   37         ???
BB50   37         ???
BB51   37         ???
BB52   39 39 39   AND $3939,Y
BB55   3A         ???
BB56   3A         ???
BB57   3A         ???
BB58   3B         ???
BB59   3B         ???
BB5A   3B         ???
BB5B   3B         ???
BB5C   3C         ???
BB5D   3C         ???
BB5E   3D 3D 3D   AND $3D3D,X
BB61   3D 3E 3E   AND $3E3E,X
BB64   3E 3F 3F   ROL $3F3F,X
BB67   3F         ???
BB68   3F         ???
BB69   2C 2C 28   BIT $282C
BB6C   38         SEC
BB6D   2C 30 31   BIT $3130
BB70   2C 28 38   BIT $3828
BB73   2C 30 31   BIT $3130
BB76   2C 28 38   BIT $3828
BB79   2C 2C 31   BIT $312C
BB7C   2A         ROL A
BB7D   28         PLP
BB7E   20 2C 2C   JSR $2C2C
BB81   31 2A      AND ($2A),Y
BB83   28         PLP
BB84   20 31 2C   JSR $2C31
BB87   2C 2A 22   BIT $222A
BB8A   20 31 2C   JSR $2C31
BB8D   2C 2A 22   BIT $222A
BB90   20 31 31   JSR $3131
BB93   2C 2C 22   BIT $222C
BB96   00         BRK
BB97   00         BRK
BB98   26 26      ROL $26
BB9A   00         BRK
BB9B   00         BRK
BB9C   27         ???
BB9D   01 01      ORA ($01,X)
BB9F   01 28      ORA ($28,X)
BBA1   28         PLP
BBA2   28         PLP
BBA3   28         PLP
BBA4   29 29      AND #$29
BBA6   01 02      ORA ($02,X)
BBA8   2A         ROL A
BBA9   2A         ROL A
BBAA   2A         ROL A
BBAB   02         ???
BBAC   02         ???
BBAD   02         ???
BBAE   03         ???
BBAF   03         ???
BBB0   2C 2C 03   BIT $032C
BBB3   03         ???
BBB4   04         ???
BBB5   04         ???
BBB6   04         ???
BBB7   04         ???
BBB8   2E 05 05   ROL $0505
BBBB   05 05      ORA $05
BBBD   06 06      ASL $06
BBBF   06 30      ASL $30
BBC1   30 30      BMI $BBF3
BBC3   30 31      BMI $BBF6
BBC5   31 31      AND ($31),Y
BBC7   31 32      AND ($32),Y
BBC9   32         ???
BBCA   32         ???
BBCB   06 33      ASL $33
BBCD   07         ???
BBCE   07         ???
BBCF   07         ???
BBD0   34         ???
BBD1   34         ???
BBD2   34         ???
BBD3   07         ???
BBD4   35 35      AND $35,X
BBD6   08         PHP
BBD7   08         PHP
BBD8   36 08      ROL $08,X
BBDA   08         PHP
BBDB   09 09      ORA #$09
BBDD   09 09      ORA #$09
BBDF   0A         ASL A
BBE0   38         SEC
BBE1   38         SEC
BBE2   38         SEC
BBE3   38         SEC
BBE4   39 0A 0A   AND $0A0A,Y
BBE7   0A         ASL A
BBE8   3A         ???
BBE9   0B         ???
BBEA   0B         ???
BBEB   0B         ???
BBEC   0B         ???
BBED   0C         ???
BBEE   0C         ???
BBEF   0C         ???
BBF0   3C         ???
BBF1   3C         ???
BBF2   0C         ???
BBF3   0D 0D 0D   ORA $0D0D
BBF6   0D 0E 3E   ORA $3E0E
BBF9   0E 0E 0E   ASL $0E0E
BBFC   0F         ???
BBFD   0F         ???
BBFE   0F         ???
BBFF   0F         ???
BC00   05 06      ORA $06
BC02   36 36      ROL $36,X
BC04   37         ???
BC05   3B         ???
BC06   1B         ???
BC07   1B         ???
BC08   11 11      ORA ($11),Y
BC0A   11 22      ORA ($22),Y
BC0C   2A         ROL A
BC0D   28         PLP
BC0E   2B         ???
BC0F   0F         ???
BC10   03         ???
BC11   01 07      ORA ($07,X)
BC13   07         ???
BC14   03         ???
BC15   33         ???
BC16   35 31      AND $31,X
BC18   31 1A      AND ($1A),Y
BC1A   1A         ???
BC1B   12         ???
BC1C   16 24      ASL $24,X
BC1E   00         BRK
BC1F   03         ???
BC20   0B         ???
BC21   03         ???
BC22   17         ???
BC23   25 22      AND $22
BC25   22         ???
BC26   2B         ???
BC27   03         ???
BC28   03         ???
BC29   15 09      ORA $09,X
BC2B   02         ???
BC2C   22         ???
BC2D   23         ???
BC2E   33         ???
BC2F   07         ???
BC30   0B         ???
BC31   03         ???
BC32   33         ???
BC33   33         ???
BC34   33         ???
BC35   30 1A      BMI $BC51
BC37   13         ???
BC38   10 13      BPL $BC4D
BC3A   23         ???
BC3B   23         ???
BC3C   2B         ???
BC3D   23         ???
BC3E   03         ???
BC3F   03         ???
BC40   00         BRK
BC41   02         ???
BC42   11 1C      ORA ($1C),Y
BC44   1C         ???
BC45   2C 2C 24   BIT $242C
BC48   24 15      BIT $15
BC4A   09 0A      ORA #$0A
BC4C   0A         ASL A
BC4D   08         PHP
BC4E   30 32      BMI $BC82
BC50   0E 0F 3C   ASL $3C0F
BC53   3D 14 14   AND $1414,X
BC56   38         SEC
BC57   BD 8D C0   LDA $C08D,X
BC5A   BD 8E C0   LDA $C08E,X
BC5D   30 5E      BMI $BCBD
BC5F   A9 FF      LDA #$FF
BC61   9D 8F C0   STA $C08F,X
BC64   DD 8C C0   CMP $C08C,X
BC67   48         PHA
BC68   68         PLA
BC69   20 C3 BC   JSR $BCC3
BC6C   20 C3 BC   JSR $BCC3
BC6F   9D 8D C0   STA $C08D,X
BC72   DD 8C C0   CMP $C08C,X
BC75   EA         NOP
BC76   88         DEY
BC77   D0 F0      BNE $BC69
BC79   A9 D5      LDA #$D5
BC7B   20 D5 BC   JSR $BCD5
BC7E   A9 AA      LDA #$AA
BC80   20 D5 BC   JSR $BCD5
BC83   A9 96      LDA #$96
BC85   20 D5 BC   JSR $BCD5
BC88   A5 41      LDA $41
BC8A   20 C4 BC   JSR $BCC4
BC8D   A5 44      LDA $44
BC8F   20 C4 BC   JSR $BCC4
BC92   A5 3F      LDA $3F
BC94   20 C4 BC   JSR $BCC4
BC97   A5 41      LDA $41
BC99   45 44      EOR $44
BC9B   45 3F      EOR $3F
BC9D   48         PHA
BC9E   4A         LSR A
BC9F   05 3E      ORA $3E
BCA1   9D 8D C0   STA $C08D,X
BCA4   BD 8C C0   LDA $C08C,X
BCA7   68         PLA
BCA8   09 AA      ORA #$AA
BCAA   20 D4 BC   JSR $BCD4
BCAD   A9 DE      LDA #$DE
BCAF   20 D5 BC   JSR $BCD5
BCB2   A9 AA      LDA #$AA
BCB4   20 D5 BC   JSR $BCD5
BCB7   A9 EB      LDA #$EB
BCB9   20 D5 BC   JSR $BCD5
BCBC   18         CLC
BCBD   BD 8E C0   LDA $C08E,X
BCC0   BD 8C C0   LDA $C08C,X
BCC3   60         RTS
BCC4   48         PHA
BCC5   4A         LSR A
BCC6   05 3E      ORA $3E
BCC8   9D 8D C0   STA $C08D,X
BCCB   DD 8C C0   CMP $C08C,X
BCCE   68         PLA
BCCF   EA         NOP
BCD0   EA         NOP
BCD1   EA         NOP
BCD2   09 AA      ORA #$AA
BCD4   EA         NOP
BCD5   EA         NOP
BCD6   48         PHA
BCD7   68         PLA
BCD8   9D 8D C0   STA $C08D,X
BCDB   DD 8C C0   CMP $C08C,X
BCDE   60         RTS
BCDF   88         DEY
BCE0   A5 E8      LDA $E8
BCE2   91 A0      STA ($A0),Y
BCE4   94 88      STY $88,X
BCE6   96 E8      STX $E8,Y
BCE8   91 A0      STA ($A0),Y
BCEA   94 88      STY $88,X
BCEC   96 91      STX $91,Y
BCEE   91 C8      STA ($C8),Y
BCF0   94 D0      STY $D0,X
BCF2   96 91      STX $91,Y
BCF4   91 C8      STA ($C8),Y
BCF6   94 D0      STY $D0,X
BCF8   96 91      STX $91,Y
BCFA   A3         ???
BCFB   C8         INY
BCFC   A0 A5      LDY #$A5
BCFE   85 A4      STA $A4

BD00   84 48      STY $48
BD02   85 49      STA $49
BD04   A0 02      LDY #$02
BD06   8C F8 06   STY $06F8
BD09   A0 04      LDY #$04
BD0B   8C F8 04   STY $04F8
BD0E   A0 01      LDY #$01
BD10   B1 48      LDA ($48),Y
BD12   AA         TAX
BD13   A0 0F      LDY #$0F
BD15   D1 48      CMP ($48),Y
BD17   F0 1B      BEQ $BD34
BD19   8A         TXA
BD1A   48         PHA
BD1B   B1 48      LDA ($48),Y
BD1D   AA         TAX
BD1E   68         PLA
BD1F   48         PHA
BD20   91 48      STA ($48),Y
BD22   BD 8E C0   LDA $C08E,X
BD25   A0 08      LDY #$08
BD27   BD 8C C0   LDA $C08C,X
BD2A   DD 8C C0   CMP $C08C,X
BD2D   D0 F6      BNE $BD25
BD2F   88         DEY
BD30   D0 F8      BNE $BD2A
BD32   68         PLA
BD33   AA         TAX
BD34   BD 8E C0   LDA $C08E,X
BD37   BD 8C C0   LDA $C08C,X
BD3A   A0 08      LDY #$08
BD3C   BD 8C C0   LDA $C08C,X
BD3F   48         PHA
BD40   68         PLA
BD41   48         PHA
BD42   68         PLA
BD43   8E F8 05   STX $05F8
BD46   DD 8C C0   CMP $C08C,X
BD49   D0 03      BNE $BD4E
BD4B   88         DEY
BD4C   D0 EE      BNE $BD3C
BD4E   08         PHP
BD4F   BD 89 C0   LDA $C089,X
BD52   A0 06      LDY #$06
BD54   B1 48      LDA ($48),Y
BD56   99 36 00   STA $0036,Y
BD59   C8         INY
BD5A   C0 0A      CPY #$0A
BD5C   D0 F6      BNE $BD54
BD5E   A0 03      LDY #$03
BD60   B1 3C      LDA ($3C),Y
BD62   85 47      STA $47
BD64   A0 02      LDY #$02
BD66   B1 48      LDA ($48),Y
BD68   A0 10      LDY #$10
BD6A   D1 48      CMP ($48),Y
BD6C   F0 06      BEQ $BD74
BD6E   91 48      STA ($48),Y
BD70   28         PLP
BD71   A0 00      LDY #$00
BD73   08         PHP
BD74   6A         ROR A
BD75   90 05      BCC $BD7C
BD77   BD 8A C0   LDA $C08A,X
BD7A   B0 03      BCS $BD7F
BD7C   BD 8B C0   LDA $C08B,X
BD7F   66 35      ROR $35
BD81   28         PLP
BD82   08         PHP
BD83   D0 0B      BNE $BD90
BD85   A0 07      LDY #$07
BD87   20 00 BA   JSR $BA00
BD8A   88         DEY
BD8B   D0 FA      BNE $BD87
BD8D   AE F8 05   LDX $05F8
BD90   A0 04      LDY #$04
BD92   B1 48      LDA ($48),Y
BD94   20 5A BE   JSR $BE5A
BD97   28         PLP
BD98   D0 11      BNE $BDAB
BD9A   A4 47      LDY $47
BD9C   10 0D      BPL $BDAB
BD9E   A0 12      LDY #$12
BDA0   88         DEY
BDA1   D0 FD      BNE $BDA0
BDA3   E6 46      INC $46
BDA5   D0 F7      BNE $BD9E
BDA7   E6 47      INC $47
BDA9   D0 F3      BNE $BD9E
BDAB   A0 0C      LDY #$0C
BDAD   B1 48      LDA ($48),Y
BDAF   F0 5A      BEQ $BE0B
BDB1   C9 04      CMP #$04
BDB3   F0 58      BEQ $BE0D
BDB5   6A         ROR A
BDB6   08         PHP
BDB7   B0 03      BCS $BDBC
BDB9   20 00 B8   JSR $B800
BDBC   A0 30      LDY #$30
BDBE   8C 78 05   STY $0578
BDC1   AE F8 05   LDX $05F8
BDC4   20 44 B9   JSR $B944
BDC7   90 24      BCC $BDED
BDC9   CE 78 05   DEC $0578
BDCC   10 F3      BPL $BDC1
BDCE   AD 78 04   LDA $0478
BDD1   48         PHA
BDD2   A9 60      LDA #$60
BDD4   20 95 BE   JSR $BE95
BDD7   CE F8 06   DEC $06F8
BDDA   F0 28      BEQ $BE04
BDDC   A9 04      LDA #$04
BDDE   8D F8 04   STA $04F8
BDE1   A9 00      LDA #$00
BDE3   20 5A BE   JSR $BE5A
BDE6   68         PLA
BDE7   20 5A BE   JSR $BE5A
BDEA   4C BC BD   JMP $BDBC
BDED   A4 2E      LDY $2E
BDEF   CC 78 04   CPY $0478
BDF2   F0 1C      BEQ $BE10
BDF4   AD 78 04   LDA $0478
BDF7   48         PHA
BDF8   98         TYA
BDF9   20 95 BE   JSR $BE95
BDFC   68         PLA
BDFD   CE F8 04   DEC $04F8
BE00   D0 E5      BNE $BDE7
BE02   F0 CA      BEQ $BDCE
BE04   68         PLA
BE05   A9 40      LDA #$40
BE07   28         PLP
BE08   4C 48 BE   JMP $BE48
BE0B   F0 39      BEQ $BE46
BE0D   4C AF BE   JMP $BEAF
BE10   A0 03      LDY #$03
BE12   B1 48      LDA ($48),Y
BE14   48         PHA
BE15   A5 2F      LDA $2F
BE17   A0 0E      LDY #$0E
BE19   91 48      STA ($48),Y
BE1B   68         PLA
BE1C   F0 08      BEQ $BE26
BE1E   C5 2F      CMP $2F
BE20   F0 04      BEQ $BE26
BE22   A9 20      LDA #$20
BE24   D0 E1      BNE $BE07
BE26   A0 05      LDY #$05
BE28   B1 48      LDA ($48),Y
BE2A   A8         TAY
BE2B   B9 B8 BF   LDA $BFB8,Y
BE2E   C5 2D      CMP $2D
BE30   D0 97      BNE $BDC9
BE32   28         PLP
BE33   90 1C      BCC $BE51
BE35   20 DC B8   JSR $B8DC
BE38   08         PHP
BE39   B0 8E      BCS $BDC9
BE3B   28         PLP
BE3C   A2 00      LDX #$00
BE3E   86 26      STX $26
BE40   20 C2 B8   JSR $B8C2
BE43   AE F8 05   LDX $05F8
BE46   18         CLC
BE47   24 38      BIT $38
BE49   A0 0D      LDY #$0D
BE4B   91 48      STA ($48),Y
BE4D   BD 88 C0   LDA $C088,X
BE50   60         RTS
BE51   20 2A B8   JSR $B82A
BE54   90 F0      BCC $BE46
BE56   A9 10      LDA #$10
BE58   B0 EE      BCS $BE48
BE5A   48         PHA
BE5B   A0 01      LDY #$01
BE5D   B1 3C      LDA ($3C),Y
BE5F   6A         ROR A
BE60   68         PLA
BE61   90 08      BCC $BE6B
BE63   0A         ASL A
BE64   20 6B BE   JSR $BE6B
BE67   4E 78 04   LSR $0478
BE6A   60         RTS
BE6B   85 2A      STA $2A
BE6D   20 8E BE   JSR $BE8E
BE70   B9 78 04   LDA $0478,Y
BE73   24 35      BIT $35
BE75   30 03      BMI $BE7A
BE77   B9 F8 04   LDA $04F8,Y
BE7A   8D 78 04   STA $0478
BE7D   A5 2A      LDA $2A
BE7F   24 35      BIT $35
BE81   30 05      BMI $BE88
BE83   99 F8 04   STA $04F8,Y
BE86   10 03      BPL $BE8B
BE88   99 78 04   STA $0478,Y
BE8B   4C A0 B9   JMP $B9A0
BE8E   8A         TXA
BE8F   4A         LSR A
BE90   4A         LSR A
BE91   4A         LSR A
BE92   4A         LSR A
BE93   A8         TAY
BE94   60         RTS
BE95   48         PHA
BE96   A0 02      LDY #$02
BE98   B1 48      LDA ($48),Y
BE9A   6A         ROR A
BE9B   66 35      ROR $35
BE9D   20 8E BE   JSR $BE8E
BEA0   68         PLA
BEA1   0A         ASL A
BEA2   24 35      BIT $35
BEA4   30 05      BMI $BEAB
BEA6   99 F8 04   STA $04F8,Y
BEA9   10 03      BPL $BEAE
BEAB   99 78 04   STA $0478,Y
BEAE   60         RTS
BEAF   A2 20      LDX #$20
BEB1   BD D7 BE   LDA $BED7,X
BEB4   9D 00 02   STA $0200,X
BEB7   CA         DEX
BEB8   10 F7      BPL $BEB1
BEBA   AD E9 B7   LDA $B7E9
BEBD   4A         LSR A
BEBE   4A         LSR A
BEBF   4A         LSR A
BEC0   4A         LSR A
BEC1   09 C0      ORA #$C0
BEC3   8D 18 02   STA $0218
BEC6   A9 02      LDA #$02
BEC8   8D F3 03   STA $03F3
BECB   E8         INX
BECC   8E F2 03   STX $03F2
BECF   A9 A7      LDA #$A7
BED1   8D F4 03   STA $03F4
BED4   4C 00 02   JMP $0200
BED7   A9 04      LDA #$04
BED9   8D 0C 02   STA $020C
BEDC   A2 BC      LDX #$BC
BEDE   A0 00      LDY #$00
BEE0   98         TYA
BEE1   99 00 FF   STA $FF00,Y
BEE4   88         DEY
BEE5   D0 FA      BNE $BEE1
BEE7   EE 0C 02   INC $020C
BEEA   CA         DEX
BEEB   D0 F4      BNE $BEE1
BEED   4C 00 08   JMP $0800
BEF0   A5 2D      LDA $2D
BEF2   D0 F1      BNE $BEE5
BEF4   20 DC B8   JSR $B8DC
BEF7   B0 EC      BCS $BEE5
BEF9   E6 44      INC $44
BEFB   A5 44      LDA $44
BEFD   C9 23      CMP #$23
BEFF   90 D3      BCC $BED4
BF01   18         CLC
BF02   90 05      BCC $BF09
BF04   A0 0D      LDY #$0D
BF06   91 48      STA ($48),Y
BF08   38         SEC
BF09   BD 88 C0   LDA $C088,X
BF0C   60         RTS
BF0D   A9 00      LDA #$00
BF0F   85 3F      STA $3F
BF11   A0 80      LDY #$80
BF13   D0 02      BNE $BF17
BF15   A4 45      LDY $45
BF17   20 56 BC   JSR $BC56
BF1A   B0 6B      BCS $BF87
BF1C   20 2A B8   JSR $B82A
BF1F   B0 66      BCS $BF87
BF21   E6 3F      INC $3F
BF23   A5 3F      LDA $3F
BF25   C9 10      CMP #$10
BF27   90 EC      BCC $BF15
BF29   A0 0F      LDY #$0F
BF2B   84 3F      STY $3F
BF2D   A9 30      LDA #$30
BF2F   8D 78 05   STA $0578
BF32   99 A8 BF   STA $BFA8,Y
BF35   88         DEY
BF36   10 FA      BPL $BF32
BF38   A4 45      LDY $45
BF3A   20 87 BF   JSR $BF87
BF3D   20 87 BF   JSR $BF87
BF40   20 87 BF   JSR $BF87
BF43   48         PHA
BF44   68         PLA
BF45   EA         NOP
BF46   88         DEY
BF47   D0 F1      BNE $BF3A
BF49   20 44 B9   JSR $B944
BF4C   B0 23      BCS $BF71
BF4E   A5 2D      LDA $2D
BF50   F0 15      BEQ $BF67
BF52   A9 10      LDA #$10
BF54   C5 45      CMP $45
BF56   A5 45      LDA $45
BF58   E9 01      SBC #$01
BF5A   85 45      STA $45
BF5C   C9 05      CMP #$05
BF5E   B0 11      BCS $BF71
BF60   38         SEC
BF61   60         RTS
BF62   20 44 B9   JSR $B944
BF65   B0 05      BCS $BF6C
BF67   20 DC B8   JSR $B8DC
BF6A   90 1C      BCC $BF88
BF6C   CE 78 05   DEC $0578
BF6F   D0 F1      BNE $BF62
BF71   20 44 B9   JSR $B944
BF74   B0 0B      BCS $BF81
BF76   A5 2D      LDA $2D
BF78   C9 0F      CMP #$0F
BF7A   D0 05      BNE $BF81
BF7C   20 DC B8   JSR $B8DC
BF7F   90 8C      BCC $BF0D
BF81   CE 78 05   DEC $0578
BF84   D0 EB      BNE $BF71
BF86   38         SEC
BF87   60         RTS
BF88   A4 2D      LDY $2D
BF8A   B9 A8 BF   LDA $BFA8,Y
BF8D   30 DD      BMI $BF6C
BF8F   A9 FF      LDA #$FF
BF91   99 A8 BF   STA $BFA8,Y
BF94   C6 3F      DEC $3F
BF96   10 CA      BPL $BF62
BF98   A5 44      LDA $44
BF9A   D0 0A      BNE $BFA6
BF9C   A5 45      LDA $45
BF9E   C9 10      CMP #$10
BFA0   90 E5      BCC $BF87
BFA2   C6 45      DEC $45
BFA4   C6 45      DEC $45
BFA6   18         CLC
BFA7   60         RTS
BFA8   FF         ???
BFA9   FF         ???
BFAA   FF         ???
BFAB   FF         ???
BFAC   FF         ???
BFAD   FF         ???
BFAE   FF         ???
BFAF   FF         ???
BFB0   FF         ???
BFB1   FF         ???
BFB2   FF         ???
BFB3   FF         ???
BFB4   FF         ???
BFB5   FF         ???
BFB6   FF         ???
BFB7   FF         ???
BFB8   00         BRK
BFB9   0D 0B 09   ORA $090B
BFBC   07         ???
BFBD   05 03      ORA $03
BFBF   01 0E      ORA ($0E,X)
BFC1   0C         ???
BFC2   0A         ASL A
BFC3   08         PHP
BFC4   06 04      ASL $04
BFC6   02         ???
BFC7   0F         ???
BFC8   9D 01 01   STA $0101,X
BFCB   60         RTS
BFCC   81 C0      STA ($C0,X)
BFCE   AD 81 C0   LDA $C081
BFD1   A9 00      LDA #$00
BFD3   8D 00 E0   STA $E000
BFD6   4C 44 B7   JMP $B744
BFD9   00         BRK
BFDA   00         BRK
BFDB   00         BRK
BFDC   8D 63 AA   STA $AA63
BFDF   8D 70 AA   STA $AA70
BFE2   8D 71 AA   STA $AA71
BFE5   60         RTS
BFE6   20 5B A7   JSR $A75B
BFE9   8C B7 AA   STY $AAB7
BFEC   60         RTS
BFED   20 7E AE   JSR $AE7E
BFF0   AE 9B B3   LDX $B39B
BFF3   9A         TXS
BFF4   20 16 A3   JSR $A316
BFF7   BA         TSX
BFF8   8E 9B B3   STX $B39B
BFFB   A9 09      LDA #$09
BFFD   4C 85 B3   JMP $B385

              .END
