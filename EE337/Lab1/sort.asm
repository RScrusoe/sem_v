ORG 0000H
LJMP MAIN
ORG 0100H

MAIN:
	
	MOV 60H , #24H
	MOV 61H , #3H
	MOV 62H , #15H
	MOV 63H, #11H
	MOV 64H, #14H
	
	MOV R1, #4
	
	LOOP2:  
		MOV R0, #60H
		MOV R2, 1
		
		 LOOP1: 
			 MOV A, @R0
			 INC R0
			 MOV R5,A
			 SUBB A, @R0
			 JC FORWARD
			 MOV A,R5 
			 MOV 4, @R0
			 MOV @R0, A
			 clr A
			 MOV A, R4
			 DEC R0
			 MOV @R0, A
			 INC R0
			 DJNZ R2, LOOP1
			 DJNZ R1 , LOOP2  
			 SJMP HERE 
			 FORWARD : DJNZ R2, LOOP1
					 DJNZ R1 , LOOP2
		
		HERE: SJMP HERE 
END