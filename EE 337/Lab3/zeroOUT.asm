LED EQU P0

ORG 00H
LJMP MAIN
ORG 0100H
ZEROOUT:
	BACK:
		MOV @R1, #0H		;write 0h in location address stored in R1
		INC R1				;increment location address stored in R1
		DJNZ R0, BACK		; check R0, if not 0, then
	RET

MAIN:
	
	MOV 52H, #1H			; randomly writing number in 52H location for checking
	MOV 53H, #2H			;
	MOV 54H, #3H			;	
	MOV 55H, #4H			;	
	
	MOV 50H, #10			
	MOV 51H, #52H
	MOV R0, 50H
	MOV R1, 51H
	
	LCALL ZEROOUT

	STOP: SJMP STOP			; infinite loop


END