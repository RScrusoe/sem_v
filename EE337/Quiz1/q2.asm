ORG 0000H
LJMP MAIN
ORG 0200H
MAIN:

		MOV 50H, #0A1H
		MOV 51H, #84H
		MOV 52H, #92H
		MOV 53H, #0C9H
		MOV 54H, #0E6H
		
		MOV R0, #50H
		MOV R1, #51H
		MOV 62H, #54H
		SUBSTRACT:
				
				
				MOV A, @R0
				SUBB A, @R1
				
				JC CARRY1
				
		H1:
		JNC CARRY0
		H2:
		MOV A, R1
		SUBB A, #54H
		JNC STOP
		JC SUBSTRACT
		STOP: SJMP STOP
				
				
					CARRY1:
						MOV 60H, R0
						MOV 61H, R1
						MOV R0, 61H
						MOV R1, 60H
						INC R1
						INC R1
						
						SJMP H1
						
					CARRY0:
						MOV 60H, R0
						MOV 61H, R1
						MOV R0, 60H
						MOV R1, 61H
						INC R1
						MOV A, R0
						SUBB A, R1
						SETB C
						CJNE A, #0H, H2
						INC R1
														
						SJMP H2
						
						
END