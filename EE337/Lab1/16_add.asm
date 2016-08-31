ORG  0000H
LJMP MAIN
ORG 0100H

ADDER:
	MOV A, 61H
	ADD A, 71H
	MOV R0, A
	MOV A, 60H
	ADDC A, 70H
	MOV R1, A
	RET
CARRY:
	MOV 62H, #1H	
	STOP: SJMP STOP
MAIN:
	CLR C
	MOV 62H, #0H
	MOV 60H, #0FFH
	MOV 61H, #080H
	MOV 70H, #0H
	MOV 71H, #03FH

	ACALL ADDER
	MOV 64H, R0
	MOV 63H, R1
	JC CARRY
	SJMP STOP	
END