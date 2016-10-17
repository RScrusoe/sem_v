lcd_data equ P2
lcd_rs  equ P0.0
lcd_rw equ P0.1
lcd_en equ P0.2

org 000H
ljmp start

org 200H

initialise_ram:
	USING 0
	PUSH AR0
	
    MOV R0, #60H
	MOV @R0, #53H
	INC R0
	MOV @R0, #55H 
	INC R0
	MOV @R0, #44H 
	INC R0
	MOV @R0, #45H 
	INC R0
	MOV @R0, #45H
	INC R0	
	MOV @R0, #50H
	INC R0
	MOV @R0, #53H 
	INC R0
	MOV @R0, #41H 
	INC R0
	MOV @R0, #4CH 
	INC R0
	MOV @R0, #47H 
	INC R0
	MOV @R0, #49H 
	INC R0
	MOV @R0, #41H 
	INC R0
	
	POP AR0
	ret
start:
	LCALL initialise_ram
	mov P1, #00H
	mov P2, #00H

	acall delay_small
	acall delay_small

	acall lcd_init 	; initialize lcd

	acall delay_small
	acall delay_small
	acall delay_small

startRead:
	mov A, #01H		 
	acall lcd_command	

	acall delay_small

	MOV P1, #0F0H
	
	MOV 4DH , #3
	lcall DELAY
	
	MOV P1, #00H
	
	MOV 4DH , #1
	lcall DELAY
	
    acall readNibble
	readAgain:	
    MOV A , R5

	MOV P1, #0F0H
	
	MOV 4DH , #3
	lcall DELAY

    MOV P1, #00H
	
	MOV 4DH , #1
	lcall DELAY
	
	acall readNibble 
    CJNE A , 5 , readAgain
	
	SWAP A
	mov R1, A
	ACALL lcd_send_string1
	ACALL delay_small
	
	MOV 4DH , #5
	LCALL DELAY
	
	LCALL lcd_send_string1
	ACALL delay_small
	
	MOV 4DH , #5
	LCALL DELAY
	
	LJMP startRead

here: sjmp here



;------------------------LCD Initialisation routine----------------------------------------------------
lcd_init:
         mov   LCD_data,#38H  ;Function set: 2 Line, 8-bit, 5x7 dots
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay_small
         clr   LCD_en
	     acall delay_small

         mov   LCD_data,#0CH  ;Display on, Curson off
         clr   LCD_rs         ;Selected instruction register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay_small
         clr   LCD_en         
		 acall delay_small
		 
         mov   LCD_data,#01H  ;Clear LCD
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay_small
         clr   LCD_en
         
		 acall delay_small

         mov   LCD_data,#06H  ;Entry mode, auto increment with no shift
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay_small
         clr   LCD_en

		 acall delay_small
         
         ret                  ;Return from routine

;-----------------------command sending routine-------------------------------------
lcd_command:
	mov lcd_data, A 	;move the command to lcd_data
	clr   LCD_rs         ;Selected command register
    clr   LCD_rw         ;We are writing in instruction register
	setb  LCD_en         ;Enable H->L
    acall delay_small
    clr   LCD_en
	acall delay_small
	ret
;-----------------------New text strings sending routine-------------------------------------
lcd_send_string1:
	USING 0
	push 0E0H
	push AR7
	push AR6
	push AR4
	
	MOV R7 , #80h
	MOV R6 , #4
	
	lcdSend1:
		mov A, R7		    
		acall lcd_command	
	
		acall delay_small
		
		clr A
		mov A, @R1	
		
	
			
			LCALL lcd_senddata 
			LCALL delay_small
			
			
			
		
		INC R7
		INC R7
		INC R7
		INC R7
	
		INC R1
		DJNZ R6 , lcdSend1
	
	MOV R7 , #0C0H
	MOV R6 , #4

	lcdSend2:
		mov A, R7		    
		acall lcd_command	
	
		acall delay_small
		clr A
		mov A, @R1
		;ANL A, #0F0H
		;RR A
		;RR A
		;RR A
		;RR A
		;MOV R4,A
		;CLR C
		;SUBB A,#0AH
		;MOV A, R4
		;JC down11
		;	ADD A,#07H
		;	down11:
		;	ADD A, #30H
	
			LCALL lcd_senddata 
			LCALL delay_small
			
			
			
		
		INC R7
		INC R7
		INC R7
		INC R7
	
		INC R1
		DJNZ R6 , lcdSend2
	
	    POP AR4
		POP AR6
		POP AR7
		POP 0E0H
		ret
;-----------------------text strings sending routine-------------------------------------
lcd_send_string:
	push 0e0h
	lcd_send_loop:
		clr A
		movc A, @A + dptr		;load first character in accumulator
		jz exit					;go to exit if zero
		acall lcd_senddata
		acall delay_small
		inc dptr
		sjmp lcd_send_loop
	exit:
		pop 0e0h
		ret
;-----------------------data sending routine-------------------------------------		     
 lcd_senddata:
         mov   LCD_data,A     ;Move the command to LCD port
         setb  LCD_rs         ;Selected data register
         clr   LCD_rw         ;We are writing
         setb  LCD_en         ;Enable H->L
		 acall delay_small
         clr   LCD_en
         acall delay_small
		 acall delay_small
		 ; lcall lcd_init_helper
		 ; acall delay
         ret                  ;Return from busy routine

		
;----------------------delay routine-----------------------------------------------------
delay_small:	 push 0
	 push 1
         mov r0,#1
loop2:	 mov r1,#255
	 loop1:	 djnz r1, loop1
	 djnz r0, loop2
	 pop 1
	 pop 0 
	 ret

;--------------------------------------------------------------------------------------------
readnibble:
	
	push 0E0H

	MOV P1, #0FH
	
	MOV A , P1
	ANL A , #0FH
	MOV R5, A
	
	pop 0E0H
	RET					; read value on pins
;-----------------------------------------------------------------------------------
DELAY:
	USING 0		
        PUSH PSW
        PUSH AR1	
        PUSH AR2
        PUSH AR3
		PUSH AR4
		PUSH 0E0H
		
		MOV R4, 4DH  

delay1s:		
		MOV R3, #20  
DELAY_50ms:          
        NOP
		MOV R2, #200
		BACK1:
			MOV R1, #0FFH
			BACK:
				DJNZ R1, BACK
			DJNZ R2, BACK1
		DJNZ R3, DELAY_50ms
	DJNZ R4, delay1s
		
		POP 0E0H
		POP AR4
		POP AR3
        POP AR2 	
        POP AR1
        POP PSW
        RET

end

