
LED EQU P1.7
ORG 00H
LJMP MAIN


;-----------------------------------------------------------------
ORG 50H

	
DELAY:				;subroutine causes a delay of 1000ms 
					;create a delay of D*1000 ms
MOV 4,@R0
BACK3:
MOV R3,#10
BACK2:
MOV R2,#200
BACK1:
MOV R1,#0FFH
BACK:
DJNZ R1, BACK
DJNZ R2, BACK1
DJNZ R3, BACK2
DJNZ R4, BACK3
RET

MAIN:
	MOV R0,#4FH
    MOV @R0,#4			;delays in seconds stored here, user should fill this 
		
				
	BACK_1:
	    SETB LED		;MAKE P1.7 OUTPUT PORT
		LCALL DELAY
		CLR LED	
		LCALL DELAY	
		SJMP BACK_1		;INFINITE LOOP

END
;-----------------------------