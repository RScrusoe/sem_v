LCD_data equ P2    ;LCD Data port
LCD_rs   equ P0.0  ;LCD Register Select
LCD_rw   equ P0.1  ;LCD Read/Write
LCD_en   equ P0.2  ;LCD Enable
	
org 00H
	ljmp main
Org 0003H
	ljmp ext_intr
Org 000BH
	ljmp timer_intr
	
org 200h
my_string1:
         DB   "PULSE WIDTH ", 00H
			 
my_string2:
         DB   "COUNT IS ", 00H

	
ORG 0300H
MAIN:

	Lcall init
	Lcall lcd_init
	Mov P1, #00H
	CLR C
	Lcall count
	
	Mov P1, #0FFH
	
	mov a,#80h		 ;Put cursor on first row,5 column
    acall lcd_command	 ;send command to LCD
    acall delay1
    mov   dptr,#my_string1   ;Load DPTR with sring1 Addr
    acall lcd_sendstring	   ;call text strings sending routine
    acall delay1

    mov a,#0C0h		  ;Put cursor on second row,3 column
    acall lcd_command
    acall delay1
	mov   dptr,#my_string2   ;Load DPTR with sring1 Addr
    acall lcd_sendstring	   ;call text strings sending routine
    acall delay1
	
	Lcall Display
	Lcall wait_for_input
	sjmp Main

init:
		MOV	TMOD, #061H
		MOV	TL0, #000H	
		MOV	TH0, #000H	
		Mov IE,	 #083H		;enable timer0 and ext0 interrupt	
		Mov IP , #01H		;set priority of ext0 greater
		Mov R7, #00H		;R7 containes overflow
		ret
				
Count:
		SETB TR0
	Count_here:	
		JNC count_here
	CLR TF0
	
	Ret
	
ext_intr:
	Clr IE.0
	SetB C
	Reti
	
timer_intr:	
	Inc R7
	RetI
	
wait_for_input:
		Push 7
		MOV P1, #0FFH		;turn on all 4 leds (routine is ready to accept input)
		MOV 7, #5			;for 5 sec delay
		lcall delay			;wait for 5 sec during which user can give input 
		MOV P1, #0FH		;clear pins P1.4 to P1.7
		Pop 7
		ret

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

	lcd_init:
			 mov   LCD_data,#38H  ;Function set: 2 Line, 8-bit, 5x7 dots
			 clr   LCD_rs         ;Selected command register
			 clr   LCD_rw         ;We are writing in instruction register
			 setb  LCD_en         ;Enable H->L
			 acall delay1
			 clr   LCD_en
			 acall delay1

			 mov   LCD_data,#0CH  ;Display on, Curson off
			 clr   LCD_rs         ;Selected instruction register
			 clr   LCD_rw         ;We are writing in instruction register
			 setb  LCD_en         ;Enable H->L
			 acall delay1
			 clr   LCD_en
			 
			 acall delay1
			 mov   LCD_data,#01H  ;Clear LCD
			 clr   LCD_rs         ;Selected command register
			 clr   LCD_rw         ;We are writing in instruction register
			 setb  LCD_en         ;Enable H->L
			 acall delay1
			 clr   LCD_en
			 
			 acall delay1

			 mov   LCD_data,#06H  ;Entry mode, auto increment with no shift
			 clr   LCD_rs         ;Selected command register
			 clr   LCD_rw         ;We are writing in instruction register
			 setb  LCD_en         ;Enable H->L
			 acall delay1
			 clr   LCD_en

			 acall delay1
			 
			 ret                  ;Return from routine

	;-----------------------command sending routine-------------------------------------
	 lcd_command:
			 mov   LCD_data,A     ;Move the command to LCD port
			 clr   LCD_rs         ;Selected command register
			 clr   LCD_rw         ;We are writing in instruction register
			 setb  LCD_en         ;Enable H->L
			 acall delay1
			 clr   LCD_en
			 acall delay1
		
			 ret  
	;-----------------------data sending routine-------------------------------------		     
	 lcd_senddata:
			 mov   LCD_data,A     ;Move the command to LCD port
			 setb  LCD_rs         ;Selected data register
			 clr   LCD_rw         ;We are writing
			 setb  LCD_en         ;Enable H->L
			 acall delay1
			 clr   LCD_en
			 acall delay1
			 acall delay1
			 ret 		 ;Return from busy routine

	lcd_sendstring:
		 push 0e0h
		 lcd_sendstring1:
			clr   a                 ;clear Accumulator for any previous data
			 movc  a,@a+dptr         ;load the first character in accumulator
			 jz    exit              ;go to exit if zero
			 acall lcd_senddata      ;send first char
			 inc   dptr              ;increment data pointer
			 sjmp  LCD_sendstring1    ;jump back to send the next character
	exit:    pop 0e0h
			 ret                     ;End of routine
			 
			 
	delay1:	 push 0
		 push 1
			 mov r0,#1
	loop2:	 mov r1,#255
		 loop1:	 djnz r1, loop1
		 djnz r0, loop2
		 pop 1
		 pop 0 
		 ret
	
Display:
	 Mov A, R7
	 Lcall Print
	 Mov A, TH0
	 Lcall Print
	 Mov A, TL0
	 Lcall Print
	 Ret
	 
	 
Print:
	 ANL A, #0F0H
	 Swap A
	 Lcall bin2ascii
	 Lcall lcd_senddata
	 
	 Mov A, R7
	 ANL A, #00FH
	 Lcall bin2ascii
	 Lcall lcd_senddata
	 
	 Ret
	 
bin2ascii:
		CJNE A, #9, bin_label
	bin_label:
		JNC	bin_label2
		Add A, #030H
		RET
	bin_label2:
		Add A, #037H
		Ret
end