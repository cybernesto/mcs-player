                         ;"WILL HARVEY'S MUSIC"
                         ;"COPYRIGHT (C) 1983"
          ORG $8500
          OBJ $8500
ORB       EQU $C400
ORA       EQU $C401
ORB2      EQU $C480
ORA2      EQU $C481
DDRB2     EQU $C482
DDRA2     EQU $C483
DDRB      EQU $C402
DDRA      EQU $C403
T1CL      EQU $C404
T1CH      EQU $C405
ACR       EQU $C40B
IFR       EQU $C40D
IER       EQU $C40E

SONGADD   EQU $EB
CHANNADD  EQU $D6
BUFFER    EQU $8400

          JMP INTRUPT
          JMP INIT
          JMP INITMOCK
          JMP SONGADDS
          JMP PAUSE
          JMP CONTINUE

TEMPO     HEX 04
DECAY     HEX 03
STARTADD  HEX FE887E8D
STRONG    HEX 0A
START     HEX 00
END       HEX 06
REST      HEX 08
TEMPCNTR  HEX 00
DECCNTR   HEX 00
TEMP0     HEX 00
TEMP1     HEX 00
TEMP2     HEX 00
TEMP4     HEX 00
TEMP5     HEX 00
CNTR      HEX 0101
VOICE     HEX FFFFFFFFFFFF
PLUG      HEX 00
FREQLO    HEX 00
FREQHI    HEX 00
TIED      HEX 0000
FREQLOS   HEX 1D1E20222426292B
          HEX 2E3033363A3D4144
          HEX 484D51565B61676D
          HEX 737A8189919AA3AC
          HEX B7C1CDD9E6F40212
          HEX 223345596D839AB2
          HEX CCE8052344668BB2
          HEX DB06346598CF0101
FREQHIS   HEX 0000000000000000
          HEX 0000000000000000
          HEX 0000000000000000
          HEX 0000000000000000
          HEX 0000000000000101
          HEX 0101010101010101
          HEX 0101020202020202
          HEX 0203030303030000

INTRUPT   TXA
          PHA
          TYA
          PHA
          LDA #%11000000
          STA IFR
          INC DECCNTR
          INC TEMPCNTR
          LDA DECCNTR
          CMP DECAY
          BNE NODECAY
          JSR DIMINISH
          LDA #0
          STA DECCNTR
NODECAY   LDA TEMPCNTR
          CMP TEMPO
          BEQ MUSIC
          JMP MUSICRTI
MUSIC     LDA #$0
          STA TEMPCNTR
          LDX #0
MUSIC12   STX TEMP2
          TXA
          ASL
          STA TEMP4
          DEC CNTR,X
          LDA CNTR,X
          BNE MUSIC9
          JSR STOPVOIC
MUSIC15   LDX TEMP4
          LDA SONGADD,X
          CLC
          ADC #2
          STA SONGADD,X
          BCC MUSIC10
          INC SONGADD+1,X
MUSIC10   LDA (SONGADD,X)
          LSR
          STA TEMP0
          INC SONGADD,X
          LDA (SONGADD,X)
          DEC SONGADD,X
          STA TEMP1
          ORA TEMP0
          BNE MUSIC11
          JSR SONGADDS
          JMP MUSIC3
MUSIC11   LDX TEMP2
          JSR SEARCH
          LDA TEMP2
          STA VOICE,X
          STX TEMP5
          LDX TEMP0
          LDA FREQLOS,X
          STA FREQLO
          LDA FREQHIS,X
          STA FREQHI
          LDA STRONG
          STA PLUG
          LDX TEMP5
          JSR PLUGIT
          LDX TEMP2
          LDA TEMP1
          AND #$40
          STA TIED,X
          LDA TEMP1
          AND #$3F
          STA CNTR,X
          LDA TEMP1
          AND #$80
          BNE MUSIC15
MUSIC9    LDX TEMP2
          INX
          CPX #$2
          BEQ MUSIC3
          JMP MUSIC12
MUSIC3    JSR INITMOCK
MUSICRTI  PLA
          TAY
          PLA
          TAX
          LDA $45
          RTI

SEARCH    CPX #$0
          BNE S2
          LDX START
S4        LDA VOICE,X
          BMI S3
          INX
          CPX END
          BNE S4
          DEX
          RTS

S2        LDX END
          DEX
S5        LDA VOICE,X
          BMI S3
          DEX
          CPX START
          BNE S5
S3        RTS

PLUGIT    TXA
          PHA
          TYA
          PHA
          LDA #0
          CPX #3
          BCC PI2
          DEX
          DEX
          DEX
          LDA #$10
PI2       STA CHANNADD
          TXA
          ASL
          TAY
          LDA FREQLO
          STA (CHANNADD),Y
          INY
          LDA FREQHI
          STA (CHANNADD),Y
          TXA
          CLC
          ADC #$8
          TAY
          LDA PLUG
          STA (CHANNADD),Y
          PLA
          TAY
          PLA
          TAX
          RTS

INITMOCK  TYA
          PHA
          LDA #$FF
          STA DDRA
          STA DDRA2
          LDA #$7
          STA DDRB
          STA DDRB2
          LDY #$0
IM2       STY ORA
          LDA #$7
          STA ORB
          LDA #$4
          STA ORB
          LDA BUFFER,Y
          STA ORA
          LDA #$6
          STA ORB
          LDA #$4
          STA ORB
          STY ORA2
          LDA #$7
          STA ORB2
          LDA #$4
          STA ORB2
          LDA BUFFER+$10,Y
          STA ORA2
          LDA #$6
          STA ORB2
          LDA #$4
          STA ORB2
          INY
          CPY #$F
          BNE IM2
          PLA
          TAY
          RTS

STOPVOIC  LDX START
SV2       LDA VOICE,X
          CMP TEMP2
          BNE SV3
          LDA #$FF
          STA VOICE,X
          LDA #$0
          STA PLUG
          JSR PLUGIT
SV3       INX
          CPX END
          BNE SV2
          RTS

SONGADDS  LDA STARTADD
          STA SONGADD
          LDA STARTADD+1
          STA SONGADD+1
          LDA STARTADD+2
          STA SONGADD+2
          LDA STARTADD+3
          STA SONGADD+3
          LDA #<INTRUPT
          STA $3FE
          LDA #>INTRUPT
          STA $3FF
          LDA #<BUFFER
          STA CHANNADD
          LDA #>BUFFER
          STA CHANNADD+1
          LDA #$1
          STA CNTR
          STA CNTR+1
          LDA #$0
          STA TEMP2
          JSR STOPVOIC
          LDA #$1
          STA TEMP2
          JSR STOPVOIC
          RTS

INIT      JSR INITPAR
          JSR SONGADDS
          LDA #%01000000
          STA ACR
          LDA #%01111111
          STA IER
          LDA #%11000000
          STA IFR
          STA IER
          LDA #$FF
          STA T1CL
          LDA #$40
          STA T1CH
          CLI
          RTS

DIMINISH  LDX #$00
D1        LDA VOICE,X
          CMP #$2
          BCS D2
          TAY
          LDA TIED,Y
          BNE D2
          LDA BUFFER+$8,X
          CMP REST
          BEQ D2
          DEC BUFFER+$8,X
D2        LDA VOICE+3,X
          CMP #$2
          BCS D3
          TAY
          LDA TIED,Y
          BNE D3
          LDA BUFFER+$18,X
          CMP REST
          BEQ D3
          DEC BUFFER+$18,X
D3        INX
          CPX #$3
          BNE D1
          RTS

PAUSE     SEI
          LDA #0
          STA TEMP2
          JSR STOPVOIC
          INC TEMP2
          JSR STOPVOIC
          JSR INITMOCK
          RTS

CONTINUE  CLI
          RTS

INITPAR   LDX #0
]LOOP     LDA PARAMS,X
          STA BUFFER,X
          STA BUFFER+$10,X
          INX
          CPX #$10
          BNE ]LOOP
          RTS

PARAMS    HEX 01000100010000F8
          HEX 0000000000000000
