org 0000H
	ljmp main
	
	org 100H
		
	
	main:
		USING 0
		MOV 50H, #03H
		MOV 51H, #61H
		MOV 52H, #62H
		MOV 61H, #01H
		MOV 62H, #02H
		MOV 63H, #03H
		MOV B, 50H
		MOV R0, 51H
		MOV R1, 52H
		MOV A, R0
		CLR C
		SUBB A, R1
		jc down
		loop1:
			MOV A, @R0
			MOV @R1, A
			INC R0
			INC R1
			DJNZ B, loop1
			down: 
			jnc further
			DEC B
			MOV A, R0
			ADD A,B
			MOV R0, A
			MOV A, R1
			ADD A, B
			MOV R1, A
			INC B
			loop2:
			MOV A, @R0
			MOV @R1,A
			DEC R0
			DEC R1
			DJNZ B, loop2
			
			further:
		
		
		STOP: sjmp STOP

		END
			