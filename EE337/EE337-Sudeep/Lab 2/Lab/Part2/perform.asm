LED EQU P1

ORG 0000H
	ljmp main
	
	ORG 100H
		main:
			MOV SP, #0CFH
			
			MOV 50H, #05H
			MOV 51H, #61H
			lcall zeroOut
			
			MOV 50H, #05H
			MOV 51H, #71H
			lcall zeroOut
			
			MOV 50H, #05H
			MOV 51H, #61H
			MOV 52H, #71H
			MOV 61H, #23H
			MOV 62H, #34H
			MOV 63H, #45H
			MOV 64H, #7EH
			MOV 65H, #0ADH
			lcall bin2ascii
			
			MOV 50H, #05H
			MOV 51H, #71H
			MOV 52H, #71H
			lcall memcpy
			
			MOV 50H, #0AH
			MOV 51H, #71H
			MOV 4FH, #01H
			lcall display
			
			here: 
				sjmp here
				
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
			
				LOOPbinary:
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
				
					DJNZ B, LOOPbinary
				
				MOV R4, A
			
				POP AR4
				POP AR3
				POP AR2
				POP AR1
				POP AR0
				POP	B
			
				RET
				
			display:
				USING 0
				PUSH AR3
				PUSH B
				PUSH AR1
				PUSH AR2
				
				MOV R3,A
				MOV B,50H
				MOV R1, 51H
			
						
				LOOPdisp:
					MOV R2, #20
					MOV A, @R1
					INC R1
					ANL A, #0FH
					MOV LED, A
					LoopInside:
						lcall delay0
						DJNZ R2, LoopInside
					DJNZ B, LOOPdisp
			
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
		
		delayDby2:
			USING 0
			PUSH AR1
			PUSH B		
			
			MOV R1, A
			MOV A, 4FH
			MOV B, #0AH
			MUL AB
			
			MOV B,A
			
			loopdelay: 
				lcall delay0
				DJNZ B, loopdelay
			
			MOV A, R1
			POP B
			POP AR1
			
			RET
		
		zeroOut:
			USING 0
			PUSH B
			PUSH AR1
			
			MOV B, 50H
			MOV R1, 51H
			
			LOOPzero:
				MOV @R1, #00H
				INC R1
				DJNZ B, LOOPzero
				
			POP AR1
			POP B
			
			RET
		
		memcpy: 
		USING 0
			PUSH B
			PUSH AR0
			PUSH AR1
					
			MOV B, 50H
			MOV R0, 51H
			MOV R1, 52H
			MOV A, R0
			CLR C
			SUBB A, R1
			jc downmemory
			loopmemcopy:
				MOV A, @R0
				MOV @R1, A
				INC R0
				INC R1
				DJNZ B, loopmemcopy
				downmemory: 
				jnc further
				DEC B
				MOV A, R0
				ADD A,B
				MOV R0, A
				MOV A, R1
				ADD A, B
				MOV R1, A
				INC B
				loopmem2:
				MOV A, @R0
				MOV @R1,A
				DEC R0
				DEC R1
				DJNZ B, loopmem2
			
				further:
				
			POP AR1
			POP AR0
			POP B
		
		
			RET

		END
			
			
			
			