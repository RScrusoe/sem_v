org 00H
	ljmp main
ORG 0300H
MAIN:
	MOV	TMOD,	#01	
	LOOP: 
		MOV	TL0,	#000H	
		MOV	TH0,	#000H	
		CPL	P1.0	
		ACALL	DELAY	
		SJMP	LOOP	
		
		
DELAY:
	Mov R7, #31
	delay_loop:
		SETB	TR0	
		AGAIN: JNB	TF0,	AGAIN	
		CLR	TR0	
		CLR	TF0	
		Djnz R7, delay_loop
	Ret
		
	
end