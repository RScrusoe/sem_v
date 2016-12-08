org 00H
	LJMP main
	

	
org 100H
	main:
	MOV TMOD, #01H
	CLR P1.7
	loopMain:
		MOV TH0, #00H
		MOV TL0, #00H
		CPL P1.7
		LCALL delay
		CPL P1.7
		;LJMP loopMain	
		stop: sjmp stop
	
	
delay:
	MOV R6, #31
	loopDelay:
		SETB	TR0	
		here: JNB	TF0, here	
		CLR	TR0	
		CLR	TF0	
		DJNZ R6, loopDelay
	RET
	
END
	