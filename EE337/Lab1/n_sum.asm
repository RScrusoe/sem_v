ORG 0000H
LJMP MAIN
ORG 0100H
MAIN:
	MOV R0, #50H
	MOV @R0, #5H 	; moving 5H number in 50H location address	
	MOV R1, #51H	
	MOV @R1, #1H		; moving 1H number in 51H location address		
	MOV A, @R1
	MOV R2, A
	DEC @R0			; Decrementing number stored in 50H location i.e. decrementing N
	MOV 40H, #0H
	GOTO:	 
	MOV A, 40H
	MOV A, @R1		; Copying last partial sum into B
	INC R1			; Incrementing value in R1
	INC R2			; Incrementing value in R1
	ADD A, R2		; Adding sum in B 
	MOV @R1, A
	MOV 40H, A
	DEC @R0
	MOV A, @R0		;Copying N in Accumulator
	JNZ GOTO		; if N is not 0 then goto GOTO, else END
	stop: SJMP stop
END