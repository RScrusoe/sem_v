LED EQU P0

org 0000H
	ljmp main
	
	org 100H
		main:
		
		MOV 50H, #02H
		MOV 51H, #52H
		MOV 52H, #03H
		MOV 53H, #0AFH
		
		lcall display
		
		STOP:
			sjmp STOP
		
		
		
		display:
			USING 0
			PUSH AR3
			PUSH B
			PUSH AR1
			PUSH AR2
			
			MOV R3,A
			MOV B,50H
			MOV R1, 51H
			
						
			LOOP:
				MOV R2, #20
				MOV A, @R1
				INC R1
				ANL A, #0FH
				MOV LED, A
				LoopDelay:
					lcall delay0
					DJNZ R2, LoopDelay
				DJNZ B, LOOP
			
			MOV A, R3
			
			POP AR2
			POP AR1
			POP B
			POP AR3
			
			RET

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
	