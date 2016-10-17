org 0000H
	ljmp main
	
	org 100H
		
		main:
		
		MOV 50H,#03H
		MOV 51H, #55H
		MOV 52H, #60H
		MOV 55H, #23H
		MOV 56H, #34H
		MOV 57H, #4EH
		
		lcall bin2ascii
		
		STOP: sjmp STOP
		
		
		bin2ascii:
			
			USING 0
			PUSH B
			PUSH AR0
			PUSH AR1
			PUSH AR2
			PUSH AR3
			PUSH AR4
			
			MOV R4,A
			
			MOV B, 50H
			MOV R0, 51H
			MOV R1, 52H
			
			LOOP:
				MOV A, @R0
				ANL A, #0F0H
				RR A
				RR A
				RR A
				RR A
				MOV R3,A
				CLR C
				SUBB A,#0AH
				MOV A, R3
				JC down
					ADD A,#07H
					down:
					ADD A, #30H
					MOV @R1, A
					INC R1
				
				MOV A, @R0
				ANL A, #0FH
				MOV R3,A
				CLR C
				SUBB A,#0AH
				MOV A, R3
				JC down1
					ADD A,#07H
					down1:
					ADD A, #30H
					MOV @R1, A
					INC R1
					
				INC R0
				
				DJNZ B, LOOP
				
			MOV R4, A
			
			POP AR4
			POP AR3
			POP AR2
			POP AR1
			POP AR0
			POP B
			
			RET
			
		END
				
						
				
				
			