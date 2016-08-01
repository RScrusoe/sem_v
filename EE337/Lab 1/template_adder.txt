ORG 0000H
LJMP MAIN

;R0 and R1 should contain the address of two no.s
;location given by R0:- 	MSB of 1st no.
;location given by R0+1:-	LSB of 1st no.
;location given by R1:- 	MSB of 1st no.
;location given by R1+1:-	LSB of 1st no.
;location given by R0+2:- 	CARRY	
;location given by R0+3:-	MSB OF ANS	
;location given by R0+4:- 	LSB OF ANS

;---------------------------------------------------------;
;this function adds and stores result in appropriate location
ADDER_16BIT:
	;-- push the registers which will be affected by this subroutine 
	;	but will be needed later 	
	
	;-- perform the addition/subtraction of 2 16-bit no.s
	;-- you may use subroutine wrtten for addition of 2 8-bit no.s
	;-- remember the no.s are given in 2's complement form
	
	;-- take care when you set carry/borrow.
	
	;-- store the result at appropriate locations.
	
	RETURN:	
	;-- pop the registers
	RET

INIT:
	;-- store the numbers to be added/subtracted at appropriate location
	RET


ORG 0100H
MAIN:
	MOV SP,#0C0H	;move stack pointer to indirect RAM location
	ACALL INIT
	ACALL ADDER_16BIT
END
