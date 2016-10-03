LED EQU P1.7

org 00H
	ljmp main
	
  org 100H
	main:
		MOV A, 4FH
		MOV B, #0AH
		MUL AB
		
		INC A
		
		
		repeat:
			lcall Task1
			sjmp repeat
		
		Task1:
		MOV B,A
		SETB LED
		
		LOOP:
			lcall delay0
			DJNZ B, LOOP
			
		MOV B,A
		CLR LED
		
		LOOP1:
			lcall delay0
			DJNZ B, LOOP1
			
		RET
		
		
		
		;MOV R3, #0FFH
		
	
	
	
	
	delay0:
		USING 0
		PUSH AR2
		PUSH AR1
		
		MOV R2, #200
		BACK1:
			MOV R1, #0FFH
			BACK:
				DJNZ R1, BACK
			DJNZ R2, BACK1
			
		POP AR1
		POP AR2
		
		RET 
		
		END