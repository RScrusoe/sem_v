; This subroutine writes characters on the LCD
LCD_data equ P2    ;LCD Data port
LCD_rs   equ P0.0  ;LCD Register Select
LCD_rw   equ P0.1  ;LCD Read/Write
LCD_en   equ P0.2  ;LCD Enable

ORG 0000H
Lcall main

org 200h
main:
	;----------------lcd initial setup--------------------------	
		mov P2,#00h
		mov P1,#00h
	  
		lcall lcd_init      ;initialise LCD

;---------------end lcd init-------------------------
		lcall Init
		mov a,#83h		 ;Put cursor on first row,5 column
		acall lcd_command	 ;send command to LCD
		lcall delay1
		mov a, 64H
		lcall lcd_senddata 
		lcall wait_for_input
		lcall lcd_init
		
		Lcall Display_values
		here: sjmp here	
Init:
	mov 51H, #061H
	Mov 50H, #5
	Mov 61H, #04CH
	MOV 62H, #049H
	Mov 63H, #046H
	Mov 64H, #045H
	Ret

;------------------------LCD Initialisation routine----------------------------------------------------
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
		 
delay1:	 push 0
	 push 1
         mov r0,#1
loop2:	 mov r1,#255
	 loop1:	 djnz r1, loop1
	 djnz r0, loop2
	 pop 1
	 pop 0 
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

wait_for_input:
		Push 7
		MOV P1, #0FFH		;turn on all 4 leds (routine is ready to accept input)
		MOV 7, #5			;for 5 sec delay
		lcall delay			;wait for 5 sec during which user can give input 
		MOV P1, #0FH		;clear pins P1.4 to P1.7
		Pop 7
		ret
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
		;lcall wait_for_input
		
		lcall readnibble	;read higher nibble
		;MOV 7, #1			;for 1 sec delay
		mov A, r0
		swap A
		;lcall delay			;wait for one sec
		
		;mov p1, A			;show upper nibble on led
		;mov 7, #5
		;lcall delay
		
		;---------------------read lower nibble--------------------------------
		;lcall wait_for_input
		
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
		
Display_values:
		Push 0E0H
		Push 0
		Push 1
		Push 6
	Display_Values_continue:
		Mov R0, 51H			;add of source is stored in R0
		Mov R6, 50H			;K is stored in R7
		
		lcall wait_for_input
		MOV P1, #00FH		; set pins 0-3 for configuring as input pins
		MOV A, P1			; read value on pins
		ANL A, #00FH		;to extract lower nibble
	
  
		CJNE A, 6, Display_label1
	Display_label1:
		JNC Display_label2
		
		Add A, R0
		mov 1, A
		
		mov a,#83h		 ;Put cursor on first row,5 column
		acall lcd_command	 ;send command to LCD
		lcall delay1
		Mov A, @R1
		lcall lcd_senddata 
		lcall delay1

		mov 7, #2
		lcall delay
		lcall lcd_init
		sjmp Display_Values_continue
		
	Display_label2:
		mov   LCD_data,#01H  ;Clear LCD
		
		Pop 6
		Pop 1
		Pop 0 
		Pop 0e0H
		Ret
		
		
		

End