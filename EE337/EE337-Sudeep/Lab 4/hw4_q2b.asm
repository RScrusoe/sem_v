; This subroutine writes characters on the LCD
LCD_data equ P2    ;LCD Data port
LCD_rs   equ P0.0  ;LCD Register Select
LCD_rw   equ P0.1  ;LCD Read/Write
LCD_en   equ P0.2  ;LCD Enable

ORG 0000H
Lcall ReadValues

org 200h

DELAY:
	 
		USING 0		;ASSEMBLER DIRECTIVE TO INDICATE REGISTER BANK0
		
		push 0E0H		
        PUSH 1		; STORE R1 (BANK O) ON THE STACK
        PUSH 2
		PUSH 3
		
		MOV A, 7				;store delay to accumulator  R7 contains delay in sec
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
		POP 0E0H

        RET
	 
 readnibble:
		push 0E0H
		MOV P1, #0FFH		; set pins 0-3 for configuring as input pins
		MOV A, P1			; read value on pins
		ANL A, #00FH		;to extract lower nibble
		MOV 0, A
		POP 0E0H
		RET
		
		
packNibbles:

		push 0e0H
		Push 0
		Push 7
		;------------read upper nibble-----------------------------
		;MOV P1, #0FFH		;turn on all 4 leds (routine is ready to accept input)
		;MOV 7, #5			;for 5 sec delay
		;lcall delay			;wait for 5 sec during which user can give input 
		;MOV P1, #0FH		;clear pins P1.4 to P1.7
		
		lcall readnibble	;read higher nibble
		;MOV 7, #1			;for 1 sec delay
		mov A, r0
		swap A
		;lcall delay			;wait for one sec
		
		;mov p1, A			;show upper nibble on led
		;mov 7, #5
		;lcall delay
		
		;---------------------read lower nibble--------------------------------
		;MOV P1, #0FFH		;turn on all 4 leds (routine is ready to accept input)
		;MOV 7, #5			;for 5 sec delay
		;lcall delay			;wait for 5 sec during which user can give input 
		;MOV P1, #0FH		;clear pins P1.4 to P1.7
		
		lcall readnibble	;read higher nibble
		;MOV 7, #1			;for 1 sec delay
		;lcall delay
		
		ORL A, R0			;pack byte and store in 4FH
		MOV 4FH, A 
		
		;SWAP A
		;ORL A, #0FH
		;MOV P1, A			; show lower nibble to led
		;MOV 7, #5			;for 1 sec delay
		;lcall delay
		
		Pop 7
		POP 0
		POP 0e0H
		ret
		
ReadValues:
		Push 0E0H
		Push 0
		Push 7
		
		Mov 7, 50H			;R7 contains value K
		Mov R0, 51H			; R0 contains destination location

	write_loop:
			Lcall packNibbles
			MOV A, 4FH
			MOV @R0, A
			INC R0
			DJNZ R7, write_loop
		RET

End