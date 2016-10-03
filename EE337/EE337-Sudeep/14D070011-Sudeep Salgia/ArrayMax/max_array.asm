org 00H
	LJMP main
	
main:
	;MOV 50H, #0A1H
	;MOV 51H, #84H
	;MOV 52H, #92H
	;MOV 53H, #0C9H
	;MOV 54H, #0E9H
	LCALL signed
	stop: sjmp stop
	
signed:
	USING 0
	PUSH 0E0H
	PUSH 0
	PUSH 1
	PUSH 2
	PUSH 3
	PUSH 4
	
	MOV R1, #04H
	MOV R0, #51H	
	MOV A, 50H
	
	up1:
	MOV R2, A
	
	
	MOV 60H, @R0
	LCALL check_if_negative2
	MOV A, 56H
	DEC A
	MOV 60H, R2
	LCALL check_if_negative2
	MOV R3,56H
	DEC R3
	XRL A, R3
	MOV R4, A
	MOV A, R2
	CJNE R4, #00H, diff
	
	CJNE R3, #00, neg
	CLR C
	MOV A, @R0
	CPL A
	INC A
	CLR C
	ADD A, R2
	MOV A, R2
	JC down1
	MOV A, @R0
	JMP down1
	neg:
	CLR C
	MOV A, @R0
	CPL A
	INC A
	CLR C
	ADD A, R2
	MOV A, R2
		JC down1
		MOV A, @R0
		JMP down1
		
	diff:
		CJNE R3, #01, down1
		MOV A, @R0
		
		
	down1:
		INC R0
		DJNZ R1, up1
	
	MOV 57H, A
	
	POP 4
	POP 3
	POP 2
	POP 1
	POP 0
	POP 0E0H
	RET
	

check_if_negative2:
	USING 0
	PUSH 0E0H
	
	CLR C
	MOV A, 60H
	ANL A, #80H
	RLC A
	RLC A
	INC A
	MOV 56H, A
	
	POP 0E0H
	RET
	
check_if_negative:
	USING 0
	PUSH 0E0H
	
	CLR C
	MOV A, 50H
	ANL A, #80H
	RLC A
	RLC A
	INC A
	MOV 56H, A
	
	POP 0E0H
	RET



unsigned:
	USING 0
	PUSH 0E0H
	PUSH 0
	PUSH 1
	PUSH 2
	
	MOV R1, #04H
	MOV R0, #51H
	MOV A, 50H
	
	up:
	MOV R2, A
	CLR C
	SUBB A, @R0
	MOV A, R2
	JNC down
		MOV A, @R0
	down:
		INC R0
		DJNZ R1, up
	
	MOV 60H, A
	
	POP 2
	POP 1
	POP 0
	POP 0E0H
	
	RET
	


END
	
