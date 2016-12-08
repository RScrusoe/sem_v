LCD_data equ P2    ;LCD Data port
LCD_rs   equ P0.0  ;LCD Register Select
LCD_rw   equ P0.1  ;LCD Read/Write
LCD_en   equ P0.2  ;LCD Enable
	
org 00H
	ljmp main

Org 000BH
	ljmp timer_intr
	
	
ORG 0300H
MAIN:
	MOV	TMOD,	#01	
	LOOP: 
		CLR C
		MOV	TL0,	#000H	
		MOV	TH0,	#000H	
		Mov IE,	 #082H
		CPL	P1.0	
		ACALL	DELAY	
		SJMP	LOOP	
		
		
DELAY:
	Mov R7, #31
	SETB	TR0	
	delay_here:	JNC delay_here	
	Ret
		
timer_intr:	
	DJNZ R7, continue
	SetB C
	Reti
	
	continue:
	RetI
	
end