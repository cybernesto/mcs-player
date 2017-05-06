                         ;"WILL HARVEY'S MUSIC"
                         ;"COPYRIGHT (C) 1983"
          ORG $8500
          OBJ $8500

ORB       EQU $00
ORA       EQU $01
ORB2      EQU $80
ORA2      EQU $81
DDRB2     EQU $82
DDRA2     EQU $83
DDRB      EQU $02
DDRA      EQU $03
T1CL      EQU $04
T1CH      EQU $05
ACR       EQU $0B
IFR       EQU $0D
IER       EQU $0E

SLOT      EQU $CE
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
FREQLOS   HEX 1E1F20222426292C
          HEX 2E3033363A3D4145
          HEX 494D52565C61676D
          HEX 737A8189919AA3AD
          HEX B7C2CEDAE7F40312
          HEX 2334465A6E849BB3
          HEX CDE9062545688CB3
          HEX DC0836679BD20101
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
          LDY #IFR
          STA (SLOT),Y
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

INITMOCK  TXA
          PHA
          TYA
          PHA
          LDA #$FF
          LDY #DDRA
          STA (SLOT),Y
          LDY #DDRA2
          STA (SLOT),Y
          LDA #$1F
          LDY #DDRB
          STA (SLOT),Y
          LDY #DDRB2
          STA (SLOT),Y
          LDX #$0
IM2       TXA
          LDY #ORA
          STA (SLOT),Y
          LDA #$F
          LDY #ORB
          STA (SLOT),Y
          LDA #$C
          STA (SLOT),Y
          LDA BUFFER,X
          LDY #ORA
          STA (SLOT),Y
          LDA #$E
          LDY #ORB
          STA (SLOT),Y
          LDA #$C
          STA (SLOT),Y
          TXA
          LDY #ORA2
          STA (SLOT),Y
          LDA #$17
          LDY #ORB2
          STA (SLOT),Y
          LDA #$14
          STA (SLOT),Y
          LDA BUFFER+$10,X
          LDY #ORA2
          STA (SLOT),Y
          LDA #$16
          LDY #ORB2
          STA (SLOT),Y
          LDA #$14
          STA (SLOT),Y
          INX
          CPX #$F
          BNE IM2
          PLA
          TAY
          PLA
          TAX
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

INIT      TYA
          PHA
          JSR INITPAR
          JSR SONGADDS
          LDA #%01000000
          LDY #ACR
          STA (SLOT),Y
          LDA #%01111111
          LDY #IER
          STA (SLOT),Y
          LDA #%11000000
          LDY #IFR
          STA (SLOT),Y
          LDY #IER
          STA (SLOT),Y
          LDA #$FF
          LDY #T1CL
          STA (SLOT),Y
          LDA #$40
          LDY #T1CH
          STA (SLOT),Y
          CLI
          PLA
          TAY
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
