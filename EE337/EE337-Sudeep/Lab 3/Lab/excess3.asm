org 0000H
	ljmp bin_to_excess3
	
org 100H
	bin_to_excess3:
		lcall readnibble
		MOV A, R1
		CLR C
		SUBB A, #0AH
		JC down
		MOV P1, #0F0H
		lcall delay5sec
		MOV P1, #00H
		lcall delay5sec
		MOV P1, #0F0H
		lcall delay5sec
		JNC further
		down:
			MOV A,R1
			ADD A, #03H
			ANL A, #0FH
			SWAP A
			MOV P1,A
		further:
		ljmp bin_to_excess3
		
			
	
	
	
	
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
