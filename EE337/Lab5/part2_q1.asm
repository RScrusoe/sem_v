; LCD Pins
LCD_data equ P2 ;LCD Data port
LCD_rs equ P0.0 ;LCD Register Select
LCD_rw equ P0.1 ;LCD Read/Write
LCD_en equ P0.2 ;LCD Enable
ORG 0000H
LJMP MAIN
ORG 00XXH ; NEGATIVE EDGE ROUTINE of External Interrupt 0
; Display readings on LCD in this routine.
ORG 00XXH ; Timer 0 overflow interrupt routine
; Keep track of number of overflows here
ORG 0100H
;------------------------LCD Initialisation routine----------------------------------------------------
lcd_init:
	mov LCD_data,#38H ;Function set: 2 Line, 8-bit, 5x7 dots
	clr LCD_rs ;Selected command register
	clr LCD_rw ;We are writing in instruction register
	setb LCD_en ;Enable H->L
	acall delay
	clr LCD_en
	acall delay
	mov LCD_data,#0CH ;Display on, Curson off
	clr LCD_rs ;Selected instruction register
	clr LCD_rw ;We are writing in instruction register
	setb LCD_en ;Enable H->L
	acall delay
	clr LCD_en
	acall delay
	mov LCD_data,#01H ;Clear LCD
	clr LCD_rs ;Selected command register
	clr LCD_rw ;We are writing in instruction register
	setb LCD_en ;Enable H->L
	acall delay
	clr LCD_en
	acall delay
	mov LCD_data,#06H ;Entry mode, auto increment with no shift
	clr LCD_rs ;Selected command register
	clr LCD_rw ;We are writing in instruction register
	setb LCD_en ;Enable H->L
	acall delay
	clr LCD_en
	acall delay
	ret ;Return from routine
;-----------------------command sending routine-------------------------------------
lcd_command:
	mov LCD_data,A ;Move the command to LCD port
	clr LCD_rs ;Selected command register
	clr LCD_rw ;We are writing in instruction register
	setb LCD_en ;Enable H->L
	acall delay
	clr LCD_en
	acall delay
	ret
;-----------------------data sending routine-------------------------------------
lcd_senddata:
	mov LCD_data,A ;Move the command to LCD port
	setb LCD_rs ;Selected data register
	clr LCD_rw ;We are writing
	setb LCD_en ;Enable H->L
	acall delay
	clr LCD_en
	acall delay
	acall delay
	ret ;Return from busy routine
;----------------------delay routine-----------------------------------------------------
delay:
	USING 0
	PUSH AR0
	PUSH AR1
	mov r0,#1
	loop2: mov r1,#255
	loop1: djnz r1, loop1
	djnz r0,loop2
	POP AR1

	POP AR0
	ret
;----------------------- CONVERSION TO ASCII ----------------
ASCIICONV: ; binary to ascii converter
	; Write your subroutine here
	;
	RET ; bin to ascii ends here
;--------------- Specific to this application -------------
INITIALIZATION:
	; Port and register initialization
	; Timer0 initialization
	;Configure Timer0 in 16-bit and Gating mode from P3.2
	;MOV TH0,,#XXH;
	;MOV TL0,,#XXH;
	WAIT_NEW_PULSE: JB P3.2, WAIT_NEW_PULSE ; If previous pulse ''HIGH'' is already
	; started, Wait till it goes off. This will ensure measuremnt starts exactly at the
	; pulse start
	;Interrupt Configuration
	;MOV 88H, #XXH ;Clear false '1' of IE0 BIT before turning on iterrupt for first time,
	; if any.
	; Enable required interrupts(Falling edge interrupt on P3.2 and T0 Overflow interrupt)
	; Enable global interrupt bit
	; Configure Timer0 to run now.
	RET
;--------------- MAIN STARTS HERE --------------------
MAIN:
	LCALL INITIALIZATION
	OVER: SJMP OVER
END