org 00h
	ljmp pack_nibbles

org 100H

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

	here : SJMP here


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