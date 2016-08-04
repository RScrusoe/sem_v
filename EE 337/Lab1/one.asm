ORG  0000H
LJMP MAIN
ORG 0100H
MAIN:
	MOV R0, #050H	
	MOV @R0, #10H	; moving 10H number in 50H location address
	MOV R1, #060H
	MOV @R1, #20H	; moving 20H number in 50H location address
	MOV A, @R0		; moving 10H number in Accumulator
	ADD A, @R1		; Adding 20H to 10H in the Accumulator
	MOV R0, #070H	
	MOV @R0, A		; Moving result in 70H location address
	stop: SJMP stop
END