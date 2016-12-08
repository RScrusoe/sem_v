org 00h
	ljmp read_values

org 100H

readInitialValues:
	MOV 50H, #49H
	MOV 51H, #65H
	MOV R1, 50H
	MOV R0, 51H
	RET


read_values:
	LCALL readInitialValues
	loop:
		LCALL pack_nibbles
		MOV A, 4FH
		MOV @R0, A
		INC R0
		DJNZ R1, loop
	here : SJMP here


pack_nibbles:
	LCALL readnibble
	MOV A, R7
	MOV R6, A
	LCALL delay5sec
	LCALL readnibble
	MOV A, R6
	SWAP A
	ORL A, R7
	MOV 4FH, A

	RET


readnibble:
	MOV P1, #0FH
	MOV A, P1
	ANL A, #0FH
	MOV R7, A
	RET

delay5sec:
	MOV R2, #100
	loop1:
		MOV R3, #200
	loop2:
		MOV R4, #0FFh
	loop3: 
		DJNZ R4, loop3
		DJNZ R3, loop2
		DJNZ R2, loop1
	RET
	
	END