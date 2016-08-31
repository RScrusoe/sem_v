ORG 0000H
LJMP MAIN

LED EQU P1
ORG 0100H

	



INITIALIZATION:
; Timer0 initialization
MOV TMOD,#01H;; Timer0 as 16 bit counter
MOV TH0,#0B1H;
MOV TL0,#0DFH;
MOV R7, #64H ; Count to keep track of number of overflows
RET

DELAY:

ACALL INITIALIZATION
SETB TR0
; Start the timer run
BACK: ; Wait here till Timer does not overflow
JNB TCON.5, BACK
CLR TCON.5; Clear timer flag
MOV TMOD,#01H;; Timer0 as 16 bit counter
MOV TH0,#0B1H;
MOV TL0,#0DFH;
DJNZ R7, BACK;Reduce R7 by 1. If R7 is not zero go to back
RET

;--------------- MAIN STARTS HERE --------------------


MAIN:
MOV LED, #0FFH
ACALL DELAY
MOV LED, #0FH
ACALL DELAY
MOV LED, #0FFH
ACALL DELAY
MOV LED, #0FH
ACALL DELAY
;--delay by poling ends--;
OVER: SJMP OVER
END