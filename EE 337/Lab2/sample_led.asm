;---------------------------------------------------------------
;PROBLEM STATEMENT: BLINKING LEDS OF PORT0
;PURPOSE: 1. GOOD CODING STYLES 
;	  2. USING PUSH, POP INSTRUCTIONS IN SUBROUTINES
;---------------------------------------------------------------

	LED EQU P0

	ORG 00H
	LJMP MAIN


;----------------------------------------------------------------
	ORG 50H

DELAY:
	USING 0		;ASSEMBLER DIRECTIVE TO INDICATE REGISTER BANK0
        PUSH PSW
        PUSH AR1	; STORE R1 (BANK O) ON THE STACK
        PUSH AR2

        MOV R1, #0FFH
        MOV R2, #0FFH
DELAY1:
        NOP
        DJNZ R1, DELAY1
        DJNZ R2, DELAY1

        POP AR2 	; POP MUST BE IN REVERSE ORDER OF PUSH
        POP AR1
        POP PSW
        RET

;----------------------------------------------------------------------

MAIN:
		MOV LED,#00H		;MAKE P0 OUTPUT PORT
		MOV A,#55H          	;01010101B
	BACK:MOV LED,A
		LCALL DELAY
		CPL A			;10101010B
		SJMP BACK		;INFINITE LOOP

;--------------------------------------------------------------------------
