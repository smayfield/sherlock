

	.FUNCT	RT-META-IN?,OBJ1,OBJ2
?PRG1:	ZERO?	OBJ1 /FALSE
	IN?	OBJ1,ROOMS /FALSE
	IN?	OBJ1,LOCAL-GLOBALS /FALSE
	EQUAL?	OBJ1,OBJ2 /TRUE
	LOC	OBJ1 >OBJ1
	JUMP	?PRG1


	.FUNCT	RT-SEE-INSIDE?,THING
	ZERO?	THING /FALSE
	FSET?	THING,FL-SURFACE /TRUE
	FSET?	THING,FL-CONTAINER \?CCL7
	FSET?	THING,FL-OPENED /TRUE
	FSET?	THING,FL-TRANSPARENT /TRUE
?CCL7:	FSET?	THING,FL-PERSON /?PRD15
	FSET?	THING,FL-ALIVE \FALSE
?PRD15:	EQUAL?	THING,CH-PLAYER /FALSE
	RTRUE	


	.FUNCT	RT-VISIBLE?,OBJ
	CALL	RT-ACCESSIBLE?,OBJ,TRUE-VALUE
	RSTACK	


	.FUNCT	CLOSED?,WLOC,VISIBLE?
	ZERO?	WLOC /FALSE
	FSET?	WLOC,FL-OPENED /FALSE
	ZERO?	VISIBLE? /?PRD7
	FSET?	WLOC,FL-TRANSPARENT /FALSE
?PRD7:	FSET?	WLOC,FL-SURFACE /FALSE
	FSET?	WLOC,FL-ALIVE /FALSE
	IN?	WLOC,ROOMS \TRUE
	RFALSE	


	.FUNCT	RT-ACCESSIBLE?,OBJ,VISIBLE?,LOC,OLOC,WLOC,RMG,RMGL
	GETPT	GL-PLACE-CUR,P?GLOBAL >RMG
	PTSIZE	RMG >RMGL
	ZERO?	OBJ \?CCL3
	SET	'GL-CLOSED-OBJECT,FALSE-VALUE
	RFALSE	
?CCL3:	EQUAL?	OBJ,ROOMS /TRUE
	EQUAL?	OBJ,PSEUDO-OBJECT \?CND1
	EQUAL?	LAST-PSEUDO-LOC,GL-PLACE-CUR /TRUE
	RFALSE	
?CND1:	LOC	GL-WINNER >WLOC
?PRG9:	IN?	WLOC,ROOMS /?REP10
	CALL	CLOSED?,WLOC,VISIBLE?
	ZERO?	STACK \?REP10
	LOC	WLOC >WLOC
	JUMP	?PRG9
?REP10:	SET	'OLOC,OBJ
	EQUAL?	OLOC,WLOC /TRUE
?PRG18:	ZERO?	OLOC /FALSE
	IN?	OLOC,GLOBAL-OBJECTS /?CCL23
	INTBL?	OLOC,RMG,RMGL,1 \?CND22
?CCL23:	IN?	OLOC,ROOMS \TRUE
	EQUAL?	OLOC,OBJ /TRUE
	RFALSE	
?CND22:	IN?	OLOC,ROOMS /FALSE
	LOC	OLOC >OLOC
	EQUAL?	OLOC,WLOC /TRUE
	CALL	CLOSED?,OLOC,VISIBLE?
	ZERO?	STACK /?PRG18
	IN?	OLOC,GLOBAL-OBJECTS /TRUE
	INTBL?	OLOC,RMG,RMGL,1 /TRUE
	SET	'GL-CLOSED-OBJECT,OLOC
	SET	'GL-IN-OUT,TRUE-VALUE
	RFALSE	


	.FUNCT	RT-DONT-ALL?,O,I,L
	LOC	O >L
	ZERO?	L /TRUE
	EQUAL?	O,I /TRUE
	FSET?	O,FL-BODYPART /TRUE
	FSET?	O,FL-NOALL /TRUE
	EQUAL?	GL-PRSA,V?TAKE \?CCL11
	ZERO?	I \?CCL14
	CALL	RT-META-IN?,O,GL-WINNER
	ZERO?	STACK /?CCL14
	IN?	O,GL-WINNER /TRUE
	GET	GL-P-NAMW,0
	ZERO?	STACK /TRUE
	GET	GL-P-BUTS,K-P-MATCHLEN
	ZERO?	STACK \TRUE
?CCL14:	FSET?	O,FL-TAKEABLE /?CCL22
	FSET?	O,FL-TRYTAKE \TRUE
?CCL22:	FSET?	L,FL-PERSON \?CCL26
	EQUAL?	L,I \TRUE
?CCL26:	FSET?	L,FL-CONTAINER \?CCL30
	FSET?	L,FL-OPENED \TRUE
?CCL30:	ZERO?	I /?CCL34
	EQUAL?	L,I \TRUE
	CALL2	RT-SEE-INSIDE?,I
	ZERO?	STACK /TRUE
	RFALSE	
?CCL34:	EQUAL?	L,GL-PLACE-CUR /FALSE
	CALL2	RT-SEE-INSIDE?,L
	ZERO?	STACK /TRUE
	RFALSE	
?CCL11:	EQUAL?	GL-PRSA,V?DROP,V?PUT,V?PUT-ON /?CTR44
	EQUAL?	GL-PRSA,V?THROW,V?THROW-OVER \FALSE
?CTR44:	EQUAL?	O,TH-POCKET /TRUE
	EQUAL?	L,TH-POCKET /TRUE
	FSET?	O,FL-WORN /TRUE
	EQUAL?	L,GL-WINNER /FALSE
	RTRUE	


	.FUNCT	DPRINT,O,X
	FSET?	O,FL-HAS-SDESC \?CCL3
	GETP	O,P?ACTION >X
	ZERO?	X /?CCL3
	CALL	X,K-M-SDESC
	RSTACK	
?CCL3:	PRINTD	O
	RTRUE	


	.FUNCT	RT-A-PRINT,O
	ICALL	RT-THEO-PRINT,O,FALSE-VALUE,K-DESC-A
	RTRUE	


	.FUNCT	RT-THEO-PRINT,O,CAP?,CLASS,?TMP1
	ASSIGNED?	'CLASS /?CND1
	SET	'CLASS,K-DESC-THE
?CND1:	ZERO?	O \?CND3
	SET	'O,GL-PRSO
?CND3:	ZERO?	CAP? /?PRG7
	DIROUT	K-D-SCR-OFF
	DIROUT	K-D-TBL-ON,GL-DIROUT-TBL
?PRG7:	FSET?	O,FL-NOARTC /?CCL11
	FSET?	O,FL-YOUR \?CCL14
	PRINTI	"your"
	JUMP	?CND12
?CCL14:	EQUAL?	CLASS,K-DESC-ANY \?CCL16
	PRINTI	"any"
	JUMP	?CND12
?CCL16:	EQUAL?	CLASS,K-DESC-THE /?CTR17
	FSET?	O,FL-PLURAL \?CCL18
	FSET?	O,FL-PERSON \?CCL18
?CTR17:	PRINTI	"the"
	JUMP	?CND12
?CCL18:	FSET?	O,FL-PLURAL \?CCL24
	FSET?	O,FL-PERSON /?CCL24
	PRINTI	"some"
	JUMP	?CND12
?CCL24:	EQUAL?	O,LG-WATER /?CND12
	FSET?	O,FL-VOWEL \?CCL30
	PRINTI	"an"
	JUMP	?CND12
?CCL30:	PRINTC	97
?CND12:	PRINTC	32
?CND9:	EQUAL?	O,CH-ME \?CCL34
	ZERO?	CAP? /?CCL34
	PRINTI	"you"
	JUMP	?REP8
?CCL11:	FSET?	O,FL-HAS-SDESC \?CND9
	GETP	O,P?ACTION
	ICALL	STACK,K-M-SDESC,CLASS
	JUMP	?REP8
?CCL34:	ICALL2	DPRINT,O
?REP8:	ZERO?	CAP? /TRUE
	DIROUT	K-D-TBL-OFF
	DIROUT	K-D-SCR-ON
	GETB	GL-DIROUT-TBL,2 >CAP?
	LESS?	CAP?,97 /?CND39
	GRTR?	CAP?,122 /?CND39
	SUB	CAP?,32
	PUTB	GL-DIROUT-TBL,2,STACK
?CND39:	ADD	GL-DIROUT-TBL,2 >?TMP1
	GET	GL-DIROUT-TBL,0
	PRINTT	?TMP1,STACK
	RTRUE	


	.FUNCT	RT-CTHEO-PRINT,O
	CALL	RT-THEO-PRINT,O,TRUE-VALUE
	RSTACK	


	.FUNCT	RT-THEI-PRINT,I
	ZERO?	I \?CND1
	SET	'I,GL-PRSI
?CND1:	CALL2	RT-THEO-PRINT,I
	RSTACK	


	.FUNCT	RT-CTHEI-PRINT,I
	ZERO?	I \?CND1
	SET	'I,GL-PRSI
?CND1:	CALL	RT-THEO-PRINT,I,TRUE-VALUE
	RSTACK	


	.FUNCT	RT-PRINT-SPACES,N,AMT
?PRG1:	GRTR?	N,GL-BLANKS-LEN \?CCL5
	SET	'AMT,GL-BLANKS-LEN
	JUMP	?CND3
?CCL5:	SET	'AMT,N
?CND3:	PRINTT	GL-BLANKS,AMT
	SUB	N,AMT >N
	GRTR?	N,0 /?PRG1
	RTRUE	


	.FUNCT	SAY-NUMBER,N,X
	SET	'X,10000
?PRG1:	LESS?	N,X \?REP2
	PRINTC	32
	DIV	X,10 >X
	LESS?	X,10 \?PRG1
?REP2:	PRINTN	N
	RTRUE	


	.FUNCT	RT-UPDATE-STATUS-LINE
	GET	0,8
	BTST	STACK,4 \?CND1
	ICALL2	RT-INIT-SCREEN,TRUE-VALUE
	GET	0,8
	BAND	STACK,-5
	PUT	0,8,STACK
?CND1:	SCREEN	K-S-WIN
	HLIGHT	K-H-INV
	EQUAL?	GL-PLACE-CUR,GL-PLACE-STS /?CND3
	ZERO?	GL-SHORT-STAT? /?CCL7
	CURSET	GL-SPLIT-ROW,1
	JUMP	?CND5
?CCL7:	CURSET	GL-SPLIT-ROW,2
?CND5:	ICALL2	RT-PRINT-SPACES,GL-STAT-MAX-ROOM
	CURSET	GL-SPLIT-ROW,2
	CALL	RT-SAY-ROOM-NAME-IF-LIT,GL-PLACE-CUR,FALSE-VALUE,TRUE-VALUE
	ZERO?	STACK /?CCL10
	SET	'GL-PLACE-STS,GL-PLACE-CUR
	JUMP	?CND3
?CCL10:	SET	'GL-PLACE-STS,-1
?CND3:	EQUAL?	GL-SCORE-CUR,GL-SCORE-STS /?CND11
	SET	'GL-SCORE-STS,GL-SCORE-CUR
	ADD	GL-SCORE-HEADER-LEN,GL-STAT-S-POS
	CURSET	GL-SPLIT-ROW,STACK
	ICALL2	SAY-NUMBER,GL-SCORE-CUR
?CND11:	CURSET	GL-SPLIT-ROW,GL-STAT-T-POS
	ZERO?	GL-SHORT-STAT? /?CCL15
	ICALL2	RT-CLK-DOW-MSG,3
	PRINTC	32
	ICALL2	RT-CLK-NTI-MSG,22
	JUMP	?CND13
?CCL15:	ICALL2	RT-CLK-DOW-MSG,5
	ADD	10,GL-STAT-T-POS
	CURSET	GL-SPLIT-ROW,STACK
	ICALL2	RT-CLK-NTI-MSG,7
?CND13:	HLIGHT	K-H-NRM
	SCREEN	K-S-NOR
	RTRUE	


	.FUNCT	RT-REFER-TO-MSG
	PRINTR	"[To what are you referring?]"


	.FUNCT	RT-SAY-ROOM-NAME-IF-LIT,HERE,FORCE?,SL?,LEN,MAXLEN,LC,X,CNT
	ASSIGNED?	'HERE /?CND1
	SET	'HERE,GL-PLACE-CUR
?CND1:	SET	'MAXLEN,300
	SET	'CNT,2
	ZERO?	SL? /?CND3
	SET	'MAXLEN,GL-STAT-MAX-ROOM
?CND3:	ZERO?	FORCE? \?CTR6
	ZERO?	GL-NOW-LIT? /?CCL7
?CTR6:	DIROUT	K-D-SCR-OFF
	DIROUT	K-D-TBL-ON,GL-DIROUT-TBL
	ICALL2	DPRINT,HERE
	DIROUT	K-D-TBL-OFF
	DIROUT	K-D-SCR-ON
	GET	GL-DIROUT-TBL,0 >LEN
	INC	'LEN
	PUT	GL-DIROUT-TBL,0,0
	GRTR?	LEN,1 \?CCL12
	SET	'LC,32
?PRG13:	GETB	GL-DIROUT-TBL,CNT >X
	LESS?	X,97 /?CND15
	GRTR?	X,122 /?CND15
	EQUAL?	CNT,2 /?CCL20
	EQUAL?	LC,32 \?CND15
?CCL20:	SUB	X,32 >X
?CND15:	PRINTC	X
	SET	'LC,X
	IGRTR?	'CNT,LEN /TRUE
	GRTR?	CNT,MAXLEN \?PRG13
	RTRUE	
?CCL12:	GET	GL-DIROUT-TBL,2
	PRINTC	STACK
	RTRUE	
?CCL7:	PRINTI	"Darkness"
	RFALSE	


	.FUNCT	RT-DESCRIBE-PLACE,PLACE,LOOK
	ZERO?	PLACE \?CND1
	SET	'PLACE,GL-PLACE-CUR
?CND1:	CALL	RT-IS-LIT?,PLACE,TRUE-VALUE
	ZERO?	STACK \?CND3
	PRINT	K-TOO-DARK-MSG
	CRLF	
	RTRUE	
?CND3:	HLIGHT	K-H-BLD
	ICALL	RT-SAY-ROOM-NAME-IF-LIT,PLACE,TRUE-VALUE
	CRLF	
	CRLF	
	HLIGHT	K-H-NRM
	ZERO?	LOOK /?CCL7
	CALL	RT-EXEC-RM-DESCFCN,PLACE,K-M-DESC-3
	RSTACK	
?CCL7:	FSET?	PLACE,FL-TOUCHED /?CCL9
	FSET	PLACE,FL-TOUCHED
	CALL	RT-EXEC-RM-DESCFCN,PLACE,K-M-DESC-1
	RSTACK	
?CCL9:	EQUAL?	GL-DESC-LEVEL,2 \?CCL11
	CALL	RT-EXEC-RM-DESCFCN,PLACE,K-M-DESC-2
	RSTACK	
?CCL11:	EQUAL?	GL-DESC-LEVEL,1 /TRUE
	ZERO?	GL-DESC-LEVEL /FALSE
	RFALSE	


	.FUNCT	RT-EXEC-RM-DESCFCN,PLACE,CONTEXT,DF
	FSET?	PLACE,FL-HAS-DESCFCN \TRUE
	GETP	PLACE,P?ACTION
	CALL	STACK,CONTEXT
	ZERO?	STACK /TRUE
	RFALSE	


	.FUNCT	RT-DESCFCN-CONTEXT,CONTEXT
	EQUAL?	CONTEXT,K-M-DESC-1,K-M-DESC-2,K-M-DESC-3 /TRUE
	RFALSE	


	.FUNCT	RT-DESC-ALL,PLACE,LOOK,HOLMES-IN-HOUSE?
	CALL	RT-DESCRIBE-PLACE,PLACE,LOOK
	ZERO?	STACK /?CND1
	ICALL	RT-DESCRIBE-PLACE-CONTENTS,PLACE,LOOK
?CND1:	CALL	RT-IS-LIT?,PLACE,TRUE-VALUE
	ZERO?	STACK /TRUE
	ZERO?	GL-PUPPY-MSG? \?CCL7
	SET	'GL-PUPPY-MSG?,TRUE-VALUE
	RTRUE	
?CCL7:	ZERO?	GL-PUPPY /TRUE
	EQUAL?	GL-PUPPY,CH-HOLMES \?CCL11
	CRLF	
	CALL2	RT-PICK-NEXT,GL-HOLMES-DESC-TXT
	PRINT	STACK
	EQUAL?	GL-PLACE-CUR,RM-ENTRY-HALL,RM-PARLOUR,RM-VESTIBULE /?CCL13
	EQUAL?	GL-PLACE-CUR,RM-HOLMES-STUDY,RM-HOLMES-BEDROOM \?CND12
?CCL13:	SET	'HOLMES-IN-HOUSE?,TRUE-VALUE
?CND12:	ZERO?	LOOK /?CCL18
	IN?	CH-HOLMES,TH-BOAT \?CCL21
	PRINT	K-SEASICK-MSG
	JUMP	?CND19
?CCL21:	IN?	CH-HOLMES,TH-HANSOM-CAB /?CTR22
	IN?	CH-HOLMES,TH-GROWLER-CAB \?CCL23
?CTR22:	PRINT	K-SITTING-QUIETLY-MSG
	JUMP	?CND19
?CCL23:	ZERO?	HOLMES-IN-HOUSE? /?CCL27
	CALL2	RT-PICK-NEXT,GL-HOLMES-HOUSE-LOOK-TXT
	PRINT	STACK
	JUMP	?CND19
?CCL27:	FSET?	GL-PLACE-CUR,FL-INDOORS \?CCL29
	CALL2	RT-PICK-NEXT,GL-HOLMES-INDOORS-LOOK-TXT
	PRINT	STACK
	JUMP	?CND19
?CCL29:	CALL2	RT-PICK-NEXT,GL-HOLMES-OUTDOORS-LOOK-TXT
	PRINT	STACK
?CND19:	PRINTR	"."
?CCL18:	EQUAL?	GL-DESC-LEVEL,2,1 \TRUE
	ZERO?	HOLMES-IN-HOUSE? /?CCL33
	CALL2	RT-PICK-NEXT,GL-HOLMES-HOUSE-ENTER-TXT
	PRINT	STACK
	JUMP	?CND31
?CCL33:	FSET?	GL-PLACE-CUR,FL-INDOORS \?CCL35
	CALL2	RT-PICK-NEXT,GL-HOLMES-INDOORS-ENTER-TXT
	PRINT	STACK
	JUMP	?CND31
?CCL35:	CALL2	RT-PICK-NEXT,GL-HOLMES-OUTDOORS-ENTER-TXT
	PRINT	STACK
?CND31:	PRINTR	"."
?CCL11:	EQUAL?	GL-PUPPY,CH-WIGGINS \TRUE
	CRLF	
	CALL2	RT-PICK-NEXT,GL-WIGGINS-DESC-TXT
	PRINT	STACK
	ZERO?	LOOK /?CCL39
	IN?	CH-WIGGINS,TH-BOAT \?CCL42
	PRINT	K-ENJOYING-RIDE-MSG
	JUMP	?CND40
?CCL42:	IN?	CH-WIGGINS,TH-HANSOM-CAB /?CTR43
	IN?	CH-WIGGINS,TH-GROWLER-CAB \?CCL44
?CTR43:	PRINT	K-FIDGETING-MSG
	JUMP	?CND40
?CCL44:	CALL2	RT-PICK-NEXT,GL-WIGGINS-LOOK-TXT
	PRINT	STACK
?CND40:	PRINTR	"."
?CCL39:	EQUAL?	GL-DESC-LEVEL,2,1 \TRUE
	CALL2	RT-PICK-NEXT,GL-WIGGINS-ENTER-TXT
	PRINT	STACK
	PRINTR	"."


	.FUNCT	RT-GOTO,NEWPLACE,X,NEWLIT?,OLDPLACE,AMP?,SS?
	SET	'OLDPLACE,GL-PLACE-CUR
	MOVE	CH-PLAYER,NEWPLACE
	SET	'GL-PLACE-CUR,NEWPLACE
	CALL1	RT-IS-LIT? >NEWLIT?
	MOVE	CH-PLAYER,OLDPLACE
	SET	'GL-PLACE-CUR,OLDPLACE
	ZERO?	NEWLIT? \?CND1
	ICALL2	TOO-DARK-TO-GO,NEWPLACE
	RTRUE	
?CND1:	GETP	GL-PLACE-CUR,P?ACTION
	CALL	STACK,K-M-EXIT >X
	FSET?	OLDPLACE,FL-INDOORS /?CND3
	FSET?	NEWPLACE,FL-INDOORS /?CND3
	ICALL	RT-CLOCK-JMP,0,5,0
?CND3:	SET	'GL-PLACE-PRV,OLDPLACE
	SET	'GL-PLACE-CUR,NEWPLACE
	CALL1	RT-IS-LIT? >GL-NOW-LIT?
	MOVE	CH-PLAYER,GL-PLACE-CUR
	GETP	GL-PLACE-CUR,P?ACTION
	CALL	STACK,K-M-ENTERING >X
	ZERO?	GL-PUPPY /?CCL9
	LOC	CH-PLAYER
	MOVE	GL-PUPPY,STACK
	JUMP	?CND7
?CCL9:	ZERO?	GL-FORMER-PUPPY /?CND7
	IN?	GL-FORMER-PUPPY,GL-PLACE-CUR \?CND7
	FSET?	GL-FORMER-PUPPY,FL-ASLEEP /?CND7
	SET	'GL-PUPPY,GL-FORMER-PUPPY
	SET	'GL-FORMER-PUPPY,FALSE-VALUE
?CND7:	ICALL1	RT-DESC-ALL
	IN?	TH-ETHERIUM-AMPOULE,CH-PLAYER \?PST15
	FSET?	TH-ETHERIUM-AMPOULE,FL-BROKEN /?PRD18
	SET	'AMP?,1
	JUMP	?PEN14
?PRD18:	SET	'AMP?,0
	JUMP	?PEN14
?PST15:	SET	'AMP?,0
?PEN14:	FSET?	TH-STETHOSCOPE,FL-WORN /?PRD20
	PUSH	0
	JUMP	?PRD21
?PRD20:	PUSH	1
?PRD21:	SET	'SS?,STACK
	ZERO?	AMP? \?CCL23
	ZERO?	SS? /?CND22
?CCL23:	ICALL	HOLMES-COMPLAINS,AMP?,SS?
?CND22:	GETP	GL-PLACE-CUR,P?ACTION
	CALL	STACK,K-M-ENTERED >X
	ICALL1	RT-RESET-THEM
	IN?	TH-ETHERIUM-GAS,GL-PLACE-CUR \TRUE
	ICALL1	RT-SMELL-ETHERIUM?
	RTRUE	


	.FUNCT	RT-RESET-THEM
	CALL2	RT-VISIBLE?,GL-P-IT-OBJECT
	ZERO?	STACK \?CND1
	SET	'GL-P-IT-OBJECT,TH-NOT-HERE-OBJECT
?CND1:	CALL2	RT-VISIBLE?,GL-P-THEM-OBJECT
	ZERO?	STACK \?CND3
	SET	'GL-P-THEM-OBJECT,TH-NOT-HERE-OBJECT
?CND3:	CALL2	RT-VISIBLE?,GL-P-HIM-OBJECT
	ZERO?	STACK \?CND5
	SET	'GL-P-HIM-OBJECT,TH-NOT-HERE-OBJECT
?CND5:	CALL2	RT-VISIBLE?,GL-P-HER-OBJECT
	ZERO?	STACK \TRUE
	SET	'GL-P-HER-OBJECT,TH-NOT-HERE-OBJECT
	RTRUE	


	.FUNCT	RT-UPDATE-SCORE,PTS
	ASSIGNED?	'PTS /?CND1
	SET	'PTS,1
?CND1:	ADD	GL-SCORE-CUR,PTS >GL-SCORE-CUR
	CALL2	RT-NEW-SCORE-MSG,PTS
	RSTACK	


	.FUNCT	RT-UPDATE-MOVES,MVS
	ASSIGNED?	'MVS /?CND1
	SET	'MVS,1
?CND1:	ZERO?	GL-CLOCK-WAIT \FALSE
	ZERO?	GL-CLOCK-STOP \FALSE
	ADD	GL-MOVES-CUR,MVS >GL-MOVES-CUR
	RETURN	GL-MOVES-CUR


	.FUNCT	RT-UPDATE-CLOCK,HRS,MIN,SEC
	ZERO?	HRS \?CCL2
	ZERO?	MIN \?CCL2
	ZERO?	SEC /?CND1
?CCL2:	ICALL	RT-DO-CLOCK-SET,GL-TIME-UPDT-INC,HRS,MIN,SEC
?CND1:	CALL1	RT-CLOCK-INC
	RSTACK	


	.FUNCT	RT-MAIN-LOOP,ICNT,OCNT,NUM,CNT,OBJ,TBL,V,PTBL,OBJ1,TMP,X,TOUCH-VERB?,MYCROFT?,TV,?TMP1
?PRG1:	SET	'CNT,0
	SET	'OBJ,FALSE-VALUE
	SET	'PTBL,TRUE-VALUE
	SET	'GL-P-MULT?,FALSE-VALUE
	EQUAL?	GL-PLACE-CUR,GL-P-QCONTEXT-RM /?CND3
	SET	'GL-P-QCONTEXT-TH,FALSE-VALUE
?CND3:	CALL1	RT-PARSER >GL-P-GOOD
	ZERO?	GL-P-GOOD /?CCL7
	GET	GL-P-PRSI,K-P-MATCHLEN >ICNT
	GET	GL-P-PRSO,K-P-MATCHLEN >OCNT
	ZERO?	GL-P-IT-OBJECT /?CND8
	CALL2	RT-ACCESSIBLE?,GL-P-IT-OBJECT
	ZERO?	STACK /?CND8
	SET	'TMP,FALSE-VALUE
?PRG12:	IGRTR?	'CNT,ICNT /?REP13
	GET	GL-P-PRSI,CNT
	EQUAL?	STACK,TH-IT \?PRG12
	PUT	GL-P-PRSI,CNT,GL-P-IT-OBJECT
	SET	'TMP,TRUE-VALUE
?REP13:	ZERO?	TMP \?CND19
	SET	'CNT,0
?PRG21:	IGRTR?	'CNT,OCNT /?CND19
	GET	GL-P-PRSO,CNT
	EQUAL?	STACK,TH-IT \?PRG21
	PUT	GL-P-PRSO,CNT,GL-P-IT-OBJECT
?CND19:	SET	'CNT,0
?CND8:	ZERO?	OCNT \?CCL30
	SET	'NUM,OCNT
	JUMP	?CND28
?CCL30:	GRTR?	OCNT,1 \?CCL32
	SET	'TBL,GL-P-PRSO
	ZERO?	ICNT \?CCL35
	SET	'OBJ,FALSE-VALUE
	JUMP	?CND33
?CCL35:	GET	GL-P-PRSI,1 >OBJ
?CND33:	SET	'NUM,OCNT
	JUMP	?CND28
?CCL32:	GRTR?	ICNT,1 \?CCL37
	SET	'PTBL,FALSE-VALUE
	SET	'TBL,GL-P-PRSI
	GET	GL-P-PRSO,1 >OBJ
	SET	'NUM,ICNT
	JUMP	?CND28
?CCL37:	SET	'NUM,1
?CND28:	ZERO?	OBJ \?CND38
	EQUAL?	ICNT,1 \?CND38
	GET	GL-P-PRSI,1 >OBJ
?CND38:	EQUAL?	GL-PRSA,V?WALK \?CCL44
	CALL	RT-PERFORM,GL-PRSA,GL-PRSO >V
	JUMP	?CND42
?CCL44:	ZERO?	NUM \?CCL46
	GETB	GL-P-SYNTAX,0
	SHIFT	STACK,-6
	ZERO?	STACK \?CCL49
	CALL2	RT-PERFORM,GL-PRSA >V
	SET	'GL-PRSO,FALSE-VALUE
	JUMP	?CND42
?CCL49:	ZERO?	GL-NOW-LIT? \?CCL51
	ICALL1	RT-P-CLEAR
	PRINT	K-TOO-DARK-MSG
	CRLF	
	JUMP	?CND42
?CCL51:	ICALL1	RT-P-CLEAR
	PRINTI	"[There isn't anything to "
	GET	GL-P-ITBL,K-P-VERBN >TMP
	CALL1	RT-TALK-VERB?
	ZERO?	STACK /?CCL54
	PRINTI	"talk to"
	JUMP	?CND52
?CCL54:	ZERO?	GL-P-MERGED \?CTR55
	ZERO?	GL-P-ORPH /?CCL56
?CTR55:	GET	TMP,0
	PRINTB	STACK
	JUMP	?CND52
?CCL56:	GETB	TMP,2 >?TMP1
	GETB	TMP,3
	CALL	RT-WORD-PRINT,?TMP1,STACK >V
?CND52:	PRINTI	".]"
	CRLF	
	SET	'V,FALSE-VALUE
	JUMP	?CND42
?CCL46:	SET	'X,0
	GRTR?	NUM,1 \?CND59
	SET	'GL-P-MULT?,TRUE-VALUE
?CND59:	SET	'TMP,FALSE-VALUE
?PRG61:	IGRTR?	'CNT,NUM \?CCL65
	GRTR?	X,0 \?CCL68
	PRINTI	"[The "
	EQUAL?	X,NUM /?CND69
	PRINTI	"other "
?CND69:	PRINTI	"object"
	EQUAL?	X,1 /?CND71
	PRINTC	115
?CND71:	PRINTI	" that you mentioned "
	EQUAL?	X,1 /?CCL75
	PRINTI	"are"
	JUMP	?CND73
?CCL75:	PRINTI	"is"
?CND73:	PRINTI	"n't here.]"
	CRLF	
	JUMP	?REP62
?CCL68:	ZERO?	TMP \?REP62
	ICALL1	RT-REFER-TO-MSG
	JUMP	?REP62
?CCL65:	ZERO?	PTBL /?CCL79
	GET	GL-P-PRSO,CNT >OBJ1
	JUMP	?CND77
?CCL79:	GET	GL-P-PRSI,CNT >OBJ1
?CND77:	GRTR?	NUM,1 /?CCL81
	GET	GL-P-ITBL,K-P-NC1
	GET	STACK,0
	EQUAL?	STACK,W?ALL,W?EVERYTHING \?CND80
?CCL81:	EQUAL?	OBJ1,TH-NOT-HERE-OBJECT \?CCL86
	INC	'X
	JUMP	?PRG61
?CCL86:	EQUAL?	GL-P-GET-FLAGS,K-P-ALL \?CCL88
	CALL	RT-DONT-ALL?,OBJ1,OBJ
	ZERO?	STACK \?PRG61
?CCL88:	CALL2	RT-ACCESSIBLE?,OBJ1
	ZERO?	STACK /?PRG61
	EQUAL?	OBJ1,CH-PLAYER /?PRG61
	EQUAL?	OBJ1,TH-IT \?CCL97
	ICALL2	RT-CTHEO-PRINT,GL-P-IT-OBJECT
	JUMP	?CND95
?CCL97:	ICALL2	RT-CTHEO-PRINT,OBJ1
?CND95:	PRINTI	": "
?CND80:	SET	'TMP,TRUE-VALUE
	ZERO?	PTBL /?CCL100
	SET	'GL-PRSO,OBJ1
	JUMP	?CND98
?CCL100:	SET	'GL-PRSO,OBJ
?CND98:	ZERO?	PTBL /?CCL103
	SET	'GL-PRSI,OBJ
	JUMP	?CND101
?CCL103:	SET	'GL-PRSI,OBJ1
?CND101:	EQUAL?	GL-WINNER,CH-BUTLER \?CND104
	GET	GL-P-NAMW,0
	EQUAL?	STACK,W?HOLMES,W?MYCROFT \?CND104
	SET	'MYCROFT?,TRUE-VALUE
	SET	'TOUCH-VERB?,FALSE-VALUE
?CND104:	ZERO?	MYCROFT? \?CND108
	EQUAL?	GL-PRSA,V?FIND /?CND108
	CALL1	RT-TOUCH-VERB? >TOUCH-VERB?
	ZERO?	TOUCH-VERB? \?CCL109
	INTBL?	GL-PRSA,GL-SEE-VERBS+2,20 >TV \?CND108
?CCL109:	ZERO?	GL-PRSO /?CCL117
	CALL2	RT-VISIBLE?,GL-PRSO
	ZERO?	STACK \?CCL117
	ICALL2	RT-CANT-SEE-ANY-MSG,GL-PRSO
	GRTR?	OCNT,1 /?PRG61
	SET	'V,FATAL-VALUE
	JUMP	?REP62
?CCL117:	ZERO?	GL-PRSI /?CND108
	CALL2	RT-VISIBLE?,GL-PRSI
	ZERO?	STACK \?CND108
	ICALL2	RT-CANT-SEE-ANY-MSG,GL-PRSI
	GRTR?	ICNT,1 /?PRG61
	SET	'V,FATAL-VALUE
	JUMP	?REP62
?CND108:	ZERO?	TOUCH-VERB? /?CND127
	ZERO?	GL-PRSO /?CCL131
	CALL2	RT-ACCESSIBLE?,GL-PRSO
	ZERO?	STACK \?CCL131
	ICALL	RT-CANT-TOUCH-MSG,GL-PRSO,GL-CLOSED-OBJECT,GL-IN-OUT
	GRTR?	OCNT,1 /?PRG61
	SET	'V,FATAL-VALUE
	JUMP	?REP62
?CCL131:	ZERO?	GL-PRSI /?CND127
	CALL2	RT-ACCESSIBLE?,GL-PRSI
	ZERO?	STACK \?CND127
	ICALL	RT-CANT-TOUCH-MSG,GL-PRSI,GL-CLOSED-OBJECT,GL-IN-OUT
	GRTR?	ICNT,1 /?PRG61
	SET	'V,FATAL-VALUE
	JUMP	?REP62
?CND127:	CALL	RT-PERFORM,GL-PRSA,GL-PRSO,GL-PRSI >V
	EQUAL?	V,FATAL-VALUE \?PRG61
?REP62:	ZERO?	GL-P-OVERFLOW /?CND42
	CRLF	
	PRINTI	"[Note: There are so many objects here that a few may have been overlooked. Please double check to make sure you have accomplished what you intended.]"
	CRLF	
?CND42:	EQUAL?	V,FATAL-VALUE \?CND5
	SET	'GL-P-CONT,FALSE-VALUE
	JUMP	?CND5
?CCL7:	SET	'GL-P-CONT,FALSE-VALUE
?CND5:	ZERO?	GL-P-GOOD /?CND147
	EQUAL?	V,FATAL-VALUE /?CND147
	INTBL?	GL-PRSA,GL-GAME-VERBS+2,10 >TV /?CND147
	ICALL1	RT-UPDATE-MOVES
	ICALL1	RT-UPDATE-CLOCK
	ICALL1	RT-ALARM-CHK
?CND147:	ICALL1	RT-TIME-OF-DAY-MSG
	SET	'GL-PRSA,FALSE-VALUE
	SET	'GL-PRSO,FALSE-VALUE
	SET	'GL-PRSI,FALSE-VALUE
	JUMP	?PRG1


	.FUNCT	RT-TOUCH-VERB?
	INTBL?	GL-PRSA,GL-TOUCH-VERBS+2,69 /?BOGUS1
?BOGUS1:	RSTACK	


	.FUNCT	RT-TALK-VERB?
	INTBL?	GL-PRSA,GL-TALK-VERBS+2,19 /?BOGUS1
?BOGUS1:	RSTACK	


	.FUNCT	RT-AC-CH-PLAYER,CONTEXT
	SET	'GL-WAIT-BELL,FALSE-VALUE
	EQUAL?	CONTEXT,K-M-WINNER \?CCL3
	EQUAL?	GL-PRSA,V?TELL \?CCL6
	SET	'GL-CLOCK-WAIT,FALSE-VALUE
	RFALSE	
?CCL6:	EQUAL?	GL-PRSO,TH-HANDS /?PRD10
	EQUAL?	GL-PRSI,TH-HANDS \?CCL8
?PRD10:	CALL1	RT-CHECK-HANDS
	ZERO?	STACK \FALSE
?CCL8:	CALL1	RT-TOUCH-VERB?
	ZERO?	STACK /FALSE
	FSET?	TH-HANDS,FL-LOCKED \FALSE
	CALL1	RT-HANDS-COVERING-EARS
	RSTACK	
?CCL3:	CALL1	RT-AC-CH-PLAYER-AUX
	RSTACK	

	.ENDI
