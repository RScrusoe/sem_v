org 00h
	ljmp main

org 100h
main:
	sjmp loop
old_data:
	MOV A, 4EH			;display data from 4eh
	ANL A, #0FH
	SWAP A
	MOV P1, A
	lcall readnibble	;read the input on P1.0-P1.3 (nibble)
	MOV A, R1
	CJNE A, #0FH, loop	;if read value != 0Fh go to loop
	sjmp old_data		;else return to caller with previously read nibble in location 4EH (lower 4 bits).
	
loop:
	MOV P1, #0FFH		;turn on all 4 leds (routine is ready to accept input)
	lcall delay5sec		;wait for 5 sec during which user can give input 
	MOV P1, #0FH		;clear pins P1.4 to P1.7
	lcall readnibble	;read the input on P1.0-P1.3 (nibble)
	lcall delay1sec		;wait for one sec
	MOV A, R1
	MOV 4EH, A
	ANL A, #00FH
	SWAP A
	MOV P1, A			;show the read value on pins P1.4-P1.7
	lcall delay5sec		;wait for 5 sec 
	MOV P1, #0FH		;clear leds
	MOV A, P1			;read the input from switches
	ANL A, #0FH
	CJNE A, #0FH, loop	;if read value != 0Fh go to loop
	sjmp old_data		;else return to caller with previously read nibble in location 4EH (lower 4 bits).
						
						
stop:
	sjmp stop
	
readnibble:
			MOV P1, #0FH			; set pins 0-3 for configuring as input pins
			MOV A, P1			; read value on pins
			ANL A, #0FH
			MOV 1, A
			RET
			
delay5sec:
	USING 0
		PUSH B
		MOV B, #64H
		loop5:
			lcall delay0
			DJNZ B, loop5
		POP B
	RET
	
delay1sec:
	USING 0
		PUSH B
		MOV B, #14H
		loop1:
			lcall delay0
			DJNZ B, loop1
		POP B
	RET
	
delay0:
		USING 0
		PUSH AR2
		PUSH AR1
		
		MOV R2, #200
		BACK1:
			MOV R1, #0FFH
			BACK:
				DJNZ R1, BACK
			DJNZ R2, BACK1
			
		POP AR1
		POP AR2
		
		RET
	
END	
