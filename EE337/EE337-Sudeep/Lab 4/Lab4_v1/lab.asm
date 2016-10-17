org 00H

lcd_data EQU P2
lcd_rs  EQU P0.0
lcd_rw EQU P0.1
lcd_en EQU P0.2
	ljmp main
	
	main:
		MOV SP, #0CFH
		MOV 50H, #02H
		MOV 51H, #60H
		MOV 4FH, #00H
		LCALL read_values
		
		
		MOV 50H, #03H
		MOV 51H, #60H
		MOV 52H, #70H
		LCALL shuffleBits
	
		MOV 50H, #03H
		MOV 51H, #70H
		LCALL display_values
		
		here: sjmp here
		
shuffleBits:
	USING 0
		PUSH AR1
		PUSH AR2
		PUSH AR0
		PUSH AR3
		PUSH B
		
	MOV R2, 50H
	MOV R1, 51H
	MOV R0, 52H
	MOV 3, R1
	MOV A, R2
	ADD A, R0
	MOV R1, A
	MOV A, @R0
	MOV @R1, A
	MOV 1, R3
	INC R2
	up:
	MOV A, @R1
	INC R1
	XRL A, @R1
	MOV @R0,A
	INC R0
	DJNZ R1, up
		
		POP B
		POP AR3
		POP AR0
		POP AR2
		POP AR1
	
	RET
			
	
readInitialValues:
	;MOV 50H, #49H
	;MOV 51H, #65H
	MOV R1, 50H
	MOV R0, 51H
	RET


read_values:
	LCALL readInitialValues
	loop:
		LCALL pack_nibbles
		MOV A, 4FH
		MOV @R0, A
		INC R0
		DJNZ R1, loop
	RET
	
	
pack_nibbles:
	LCALL readnibble
	MOV A, R7
	MOV R6, A
	LCALL delay5sec
	MOV P1, #0FH
	LCALL delay2sec
	LCALL readnibble
	MOV A, R6
	SWAP A
	ORL A, R7
	MOV 4FH, A

	RET


readnibble:
	MOV P1, #0FFH
	MOV A, P1
	ANL A, #0FH
	MOV R7, A
	RET

delay5sec:
	MOV R2, #100
	loop1:
		MOV R3, #200
	loop2:
		MOV R4, #0FFh
	loop3: 
		DJNZ R4, loop3
		DJNZ R3, loop2
		DJNZ R2, loop1
	RET
	
	
		


display_values:

		LCALL lcd_init
	loop_disp:
		LCALL delay2sec
		mov R2, 50H
		mov R0, 51H
		;LCALL displayInitialvalues
		LCALL readnibble
		MOV R5, A
		SUBB A, R2
		JNC displayNull 		
		MOV A, R0
		ADD A, R5
		MOV R0, A
		
		MOV A, #85H
		LCALL lcd_command
		MOV A, @R0
		LCALL lcd_senddata
		;INC R0
		SJMP loop_disp
	displayNull:
		MOV lcd_data,#01H	
		ACALL lcdInitCommon
		LCALL delay2sec
		SJMP loop_disp
		

; set pins 0-3 for configuring as input pins
; read value on pins
;readnibble:
;	MOV P1, #0fh
;	MOV A, P1
;	ANL A, #0fh
;	MOV R7, A
;	RET

delay2sec:
	PUSH 05H
	MOV R3, #40
	loop12:
		MOV R4, #200
	loop22:
		MOV R5, #0FFH
	loop32: 
		DJNZ R5, loop32
		DJNZ R4, loop22
		DJNZ R3, loop12
	POP 05H
	RET




;------------------------LCD Initialisation routine----------------------------------------------------
lcd_init:
		mov lcd_data, #38H	;Function set: 2 Line, 8-bit, 5x7 dots
		acall lcdInitCommon

		mov lcd_data, #0CH	;Display on, Curson off
		acall lcdInitCommon

		mov lcd_data,#01H	;Clear LCD
		acall lcdInitCommon

		mov lcd_data, #06H	;Entry mode, auto increment with no shift
		acall lcdInitCommon

		ret

lcdInitCommon:
		clr lcd_rs			;Selected command register
		clr lcd_rw			;We are writing in instruction register
		setb lcd_en 		;Enable H->L
		acall delay
		clr lcd_en
		acall delay
		ret
;-----------------------command sending routine-------------------------------------
lcd_command:
	mov lcd_data, A 	;move the command to lcd_data
	acall lcdInitCommon
	ret

;-----------------------text strings sending routine-------------------------------------
lcd_send_string:
	push 0e0h
	lcd_send_loop:
		clr A
		movc A, @A + dptr		;load first character in accumulator
		jz exit					;go to exit if zero
		acall lcd_senddata
		acall delay
		inc dptr
		sjmp lcd_send_loop
	exit:
		pop 0e0h
		ret
;-----------------------data sending routine-------------------------------------		     
 lcd_senddata:
         MOV   LCD_data,A     
         SETB  LCD_rs         
         CLR   LCD_rw         
         SETB LCD_en         
		 ACALL delay
         CLR   LCD_en
         ACALL delay
		 ACALL delay
         RET                  

		
;----------------------delay routine-----------------------------------------------------
delay:	 PUSH 0
		 PUSH 1
         MOV r0,#1
loop2delay:	 MOV r1,#255
	 loop1delay:	 DJNZ r1, loop1delay
	 DJNZ r0, loop2delay
	 POP 1
	 POP 0 
	 RET

;------------- ROM text strings---------------------------------------------------------------
org 300h
my_string1:
         DB   "HELLO", 00H
my_string2:
		 DB   "WORLD", 00H
			 
bin2ascii:
			
			USING 0
			PUSH B
			PUSH AR0
			PUSH AR1
			PUSH AR2
			PUSH AR3
			PUSH AR4
			
			MOV R4,A
			
			MOV B, 50H
			MOV R0, 70H
			;MOV R1, 52H
			
			LOOPbin:
				MOV A, @R0
				ANL A, #0F0H
				RR A
				RR A
				RR A
				RR A
				MOV R3,A
				CLR C
				SUBB A,#0AH
				MOV A, R3
				JC down
					ADD A,#07H
					down:
					ADD A, #30H
					LCALL lcd_senddata
					;INC R1
				
				MOV A, @R0
				ANL A, #0FH
				MOV R3,A
				CLR C
				SUBB A,#0AH
				MOV A, R3
				JC down1
					ADD A,#07H
					down1:
					ADD A, #30H
					LCALL lcd_senddata
					;INC R1
					
				INC R0
				LCALL delay2sec
				LCALL lcd_init
				
				DJNZ B, LOOPbin
				
			MOV R4, A
			
			POP AR4
			POP AR3
			POP AR2
			POP AR1
			POP AR0
			POP B
			
			RET
			
		
		
END

