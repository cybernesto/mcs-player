                         ;"WILL HARVEY'S MUSIC"
                         ;"COPYRIGHT (C) 1983"
          ;ORG $8500
          ;OBJ $8500

OREGB     = $00
OREGA     = $01
ORB2      = $80
ORA2      = $81
DDRB2     = $82
DDRA2     = $83
DDRB      = $02
DDRA      = $03
T1CL      = $04
T1CH      = $05
ACR       = $0B
IFR       = $0D
IER       = $0E

SLOT      = $CE
SONGADD   = $EB
CHANNADD  = $D6
SONG      = $4000
BUFFER    = $800

;          JMP INTRUPT
;          JMP INIT
;          JMP INITMOCK
;          JMP SONGADDS
;          JMP PAUSE
;          JMP CONTINUE

TEMPO     !byte 04
DECAY     !byte 03
STARTADD  !word SONG-$02, SONG + $480 -$02
STRONG    !byte $0A
START     !byte 00
END       !byte 06
REST      !byte 08
TEMPCNTR  !byte 00
DECCNTR   !byte 00
TEMP0     !byte 00
TEMP1     !byte 00
TEMP2     !byte 00
TEMP4     !byte 00
TEMP5     !byte 00
CNTR      !byte $01,$01
VOICE     !byte $FF,$FF,$FF,$FF,$FF,$FF
PLUG      !byte 00
FREQLO    !byte 00
FREQHI    !byte 00
TIED      !byte $00,$00
FREQLOS   !byte $1E,$1F,$20,$22,$24,$26,$29,$2C
          !byte $2E,$30,$33,$36,$3A,$3D,$41,$45
          !byte $49,$4D,$52,$56,$5C,$61,$67,$6D
          !byte $73,$7A,$81,$89,$91,$9A,$A3,$AD
          !byte $B7,$C2,$CE,$DA,$E7,$F4,$03,$12
          !byte $23,$34,$46,$5A,$6E,$84,$9B,$B3
          !byte $CD,$E9,$06,$25,$45,$68,$8C,$B3
          !byte $DC,$08,$36,$67,$9B,$D2,$01,$01
FREQHIS   !byte $00,$00,$00,$00,$00,$00,$00,$00
          !byte $00,$00,$00,$00,$00,$00,$00,$00
          !byte $00,$00,$00,$00,$00,$00,$00,$00
          !byte $00,$00,$00,$00,$00,$00,$00,$00
          !byte $00,$00,$00,$00,$00,$00,$01,$01
          !byte $01,$01,$01,$01,$01,$01,$01,$01
          !byte $01,$01,$02,$02,$02,$02,$02,$02
          !byte $02,$03,$03,$03,$03,$03,$00,$00

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
          LDY #OREGA
          STA (SLOT),Y
          LDA #$F
          LDY #OREGB
          STA (SLOT),Y
          LDA #$C
          STA (SLOT),Y
          LDA BUFFER,X
          LDY #OREGA
          STA (SLOT),Y
          LDA #$E
          LDY #OREGB
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
.LOOP     LDA PARAMS,X
          STA BUFFER,X
          STA BUFFER+$10,X
          INX
          CPX #$10
          BNE .LOOP
          RTS

PARAMS    !byte $01,$00,$01,$00,$01,$00,$00,$F8
          !byte $00,$00,$00,$00,$00,$00,$00,$00
