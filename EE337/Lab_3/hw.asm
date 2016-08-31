org 00h
	ljmp main

org 100h
main:
	sjmp loop
old_data:
	MOV A, 4EH			;display data from 4eh
	SWAP A
	ORL A, #0FH
	lcall readnibble	;read the input on P1.0-P1.3 (nibble)
	MOV A, R0
	CJNE A, #00FH, Loop	;if read value != 0Fh go to loop
	SJMP old_data		;else return to caller with previously read nibble in location 4EH (lower 4 bits)
	
loop:
	MOV P1, #0FFH		;turn on all 4 leds (routine is ready to accept input)
	MOV 4FH, #5			;for 5 sec delay
	lcall delay			;wait for 5 sec during which user can give input 
	MOV P1, #0FH		;clear pins P1.4 to P1.7
	
	lcall readnibble	;read the input on P1.0-P1.3 (nibble)
	MOV 4FH, #1			;for 1 sec delay
	lcall delay			;wait for one sec
	
	MOV A, R0
	MOV 4EH, A			;store read value in 4eH loc
	SWAP A
	ORL A, #0FH
	MOV P1, A	 		;show the read value on pins P1.4-P1.7
	
	MOV 4FH, #5			;for 5 sec delay
	lcall delay			;wait for 5 sec 
	
	MOV P1,	#0FH		;clear leds
	
	MOV A, P1			; read value on pins
	ANL A, #00FH		;read the input from switches
	CJNE A, #00FH, Loop	;if read value != 0Fh go to loop
	SJMP old_data		;else return to caller with previously read nibble in location 4EH (lower 4 bits).
						
						
stop:
	sjmp stop
	
	
readnibble:
			;MOV P1, #0FFH		; set pins 0-3 for configuring as input pins
			MOV A, P1			; read value on pins
			ANL A, #00FH		;to extract lower nibble
			MOV 0, A			
			RET
DELAY:
	 
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
