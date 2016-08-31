ORG 0000H
LJMP MAIN

LED EQU P1
org 000BH

DJNZ R7, BACK
CLR TR0
MOV LED, #0FH

BACK:
	MOV TMOD,#01H;; Timer0 as 16 bit counter
	MOV TH0,#0B1H;
	MOV TL0,#0DFH;
	RETI	
ORG 0100H	
INITIALIZATION:
; Timer0 initialization
MOV TMOD,#01H;; Timer0 as 16 bit counter
MOV TH0,#0B1H;
MOV TL0,#0DFH;
MOV R7, #64H ; Count to keep track of number of overflows
RET

MAIN:
SETB IE.7
SETB IE.1
ACALL INITIALIZATION
SETB TR0

MOV LED, #0FFH


EXIT: SJMP EXIT

END

