; This subroutine writes characters on the LCD

LED EQU P1
ORG 000H
	
	
;LJMP MAIN:

MAIN:
	MOV P1, #0FFH		;turn on all 4 leds (routine is ready to accept input)
	
	MOV 4FH, #5			;for 5 sec delay
	lcall delay			;wait for 5 sec during which user can give input 
	ANL P1, #0FH		;clear pins P1.4 to P1.7
	
	lcall readnibble	;read the input on P1.0-P1.3 (nibble)
	mov R1, #50H
	MOV A, R0
	MOV @R1, A
	MOV 4FH, #2		;for 2 sec delay
	lcall delay
	
	MOV P1, #0FFH		;turn on all 4 leds (routine is ready to accept input)
	
	MOV 4FH, #5			;for 5 sec delay
	lcall delay			;wait for 5 sec during which user can give input 
	ANL P1, #0FH		;clear pins P1.4 to P1.7
	
	lcall readnibble	;read the input on P1.0-P1.3 (nibble)
	mov R1, #60H
	MOV A, R0
	MOV @R1, A
	MOV 4FH, #2		;for 2 sec delay
	lcall delay
	
	
	MOV A, 50H
	SWAP A
	ADD A, 60H
	
	MOV 4FH, A
	
	STOP: SJMP STOP
	
readnibble:
	MOV A, P1			; read value on pins
	ANL A, #00FH		;to extract lower nibble
	MOV R0, A			
	RET

	
delay:
	 
		USING 0		;ASSEMBLER DIRECTIVE TO INDICATE REGISTER BANK0
			
        PUSH 1		; STORE R1 (BANK O) ON THE STACK
        PUSH 2
		PUSH 3
		
		MOV A, 4FH				;store delay to accumulator
		MOV B, #014H			;for 1/2 second delay BACK1 loop should run 10 times  hence multiplying by 10 
		MUL AB
		MOV 3,A
		BACK2:					;loop for required delay
			MOV R2,#200			;Loop for 50ms delay 
			BACK1:
				MOV R1,#0FFH
				BACK:
				DJNZ R1, BACK
			DJNZ R2, BACK1
		DJNZ R3, BACK2
		
		POP 3	; STORE R1 (BANK O) ON THE STACK
        POP 2
		POP 1

        RET


END