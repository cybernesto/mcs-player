10  HOME 
20  PRINT  CHR$(4)"BLOAD MCS"
30  PRINT  CHR$(4)"BLOAD JAM,A$8900
34  REM  SLOT 4
35  POKE 206,0: POKE 207,196
40  POKE 34066,4: CALL 34051
51  PRINT : PRINT "Press any key to STOP->";: GET A$
53  CALL 34060
55  PRINT : PRINT 
57  HOME 