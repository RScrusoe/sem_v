org 0000H
	ljmp main
	
	org 100H
	
	main:
		USING 0
		MOV B, 50H
		MOV R0, 51H
		MOV R1, 52H
		MOV R2, B
		MOV A, B
		LOOP1:
			MOV 4, @R0
			PUSH AR4
			INC R0
			DJNZ B, LOOP1
		
		DEC A
		ADD A, R1
		MOV R1, A
		
		LOOP2:
			POP AR4
			MOV @R1,4
			DEC R1
			DJNZ R2, LOOP2
			
			STOP: sjmp STOP

		END
			