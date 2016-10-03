org 00H
	LJMP main
	
org 000BH
	LJMP interruptJumpsHere

org 100H
	main:
	MOV TMOD, #01H
	loopMain:
	CLR P1.7
	CLR P1.6
	MOV TL0, #00H
	MOV TH0, #00H
	MOV IE, #82H
	CPL P1.7
	LCALL delay
	;LJMP loopMain	
	CPL p1.7
	stop: sjmp stop
	
	
	
delay:
	MOV R6, #31
	loopDelay:
		SETB	TR0	
		here: JNB P1.6	, here		
	RET
	
	interruptJumpsHere:
		DJNZ R6, down
		SETB P1.6
		RETI
		down:
		RETI
	
END