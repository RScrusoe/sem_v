org 0000H
	ljmp main
	
	org 100H
		main:
		
		MOV B, #06H
		MOV 50H, #04H
		MOV 51H, #52H
		MOV 52H, #04H
		MOV 53H, #67H
		MOV 54H, #08H
		MOV 55H, #0D7H
		MOV 56H, #9FH
		MOV 57H, #07H
		MOV 58H, #08H
		
		lcall zeroOut
		STOP:
			sjmp STOP
			
		
		zeroOut:
			USING 0
			PUSH B
			PUSH AR1
			
			MOV B, 50H
			MOV R1, 51H
			
			LOOP:
				MOV @R1, #00H
				INC R1
				DJNZ B, LOOP
				
			POP AR1
			POP B
			
			RET
			
		END
			
			
			