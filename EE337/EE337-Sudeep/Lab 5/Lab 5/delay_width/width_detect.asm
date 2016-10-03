LCD_data equ P2    ;LCD Data port
LCD_rs   equ P0.0  ;LCD Register Select
LCD_rw   equ P0.1  ;LCD Read/Write
LCD_en   equ P0.2  ;LCD Enable

org 00H
	LJMP main

org 000BH
	LJMP timerInterruptJumpsHere

org 0003H
	LJMP externalInterruptJumpsHere

org 300H
	str1: DB "PULSE WIDTH" ,00H
	str2: DB "COUNT IS" ,00H 
	
org 100H	
main:
loopMain:
		MOV	TMOD, #09H
		MOV	TL0, #00H	
		MOV	TH0, #00H	
		Mov IE,	 #83H		;enable timer0 and ext0 interrupt	
		Mov R6, #00H
		LCALL lcd_init
		LCALL increment
		
		MOV A,#80H		 ;Put cursor on first row,5 column
		ACALL lcd_command	 ;send command to LCD
		ACALL delay1
		MOV   DPTR,#str1   ;Load DPTR with sring1 Addr
		ACALL lcd_sendstring	   ;call text strings sending routine
		ACALL delay1

		MOV A,#0C0h		  ;Put cursor on second row,3 column
		ACALL lcd_command
		ACALL delay1
		MOV   DPTR,#str2   ;Load DPTR with sring1 Addr
		ACALL lcd_sendstring	   ;call text strings sending routine
		ACALL delay1
	
		Lcall dispOnLED
		Lcall delay2sec
		LJMP loopMain
		


increment:
	SETB TR0
	loopHere: JNB P1.7, loopHere	
	RET
	
timerInterruptJumpsHere:
	CLR TF0
	INC R6
	RETI

externalInterruptJumpsHere:
	CLR IE.0
	SETB P1.7
	RETI
	
	
	



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
	 
DispOnLED:
	MOV A, R6
	LCALL printONLED
	MOV A, TH0
	LCALL printONLED
	MOV A, TL0
	LCALL printONLED
	 
printOnLED:
	USING 0
	PUSH AR3
	
	MOV R3,A
	ANL A, #0F0H
	SWAP A
	LCALL bin2ascii
	LCALL lcd_senddata
	 
	MOV A, R3
	ANL A, #0FH
	LCALL bin2ascii
	LCALL lcd_senddata
	
	POP AR3
	 
	RET	 
	 
bin2ascii:
	USING 0
	PUSH AR1
	
	MOV R1, A
	CLR C
	SUBB A, #0AH
	MOV A, R1
	JNC down
		ADD A, #30H
		JMP further
	down:
		ADD A, #37H
		further:
	POP AR1
	RET
	
delay2sec:
	 
		USING 0		;ASSEMBLER DIRECTIVE TO INDICATE REGISTER BANK0
		
		push 0E0H		
        PUSH 1		; STORE R1 (BANK O) ON THE STACK
        PUSH 2
		PUSH 3
		
		;MOV A, 7				;store delay to accumulator  R7 contains delay in sec
		;MOV B, #014H			;for 1/2 second delay BACK1 loop should run 10 times  hence multiplying by 10 
		;MUL AB
		;MOV 3,A
		MOV R3, #40
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
		
END

		
			
	