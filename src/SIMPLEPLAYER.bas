10  HOME : PRINT "PLEASE WAIT..."
20  PRINT  CHR$(4)"BLOAD MCS"
30  PRINT  CHR$(4)"BLOAD JAM,A$8900
40  POKE 34066,4: CALL 34051
50  PRINT : PRINT "PRESS ANY KEY TO STOP->";: GET A$
60  CALL 34060
70  HOME 