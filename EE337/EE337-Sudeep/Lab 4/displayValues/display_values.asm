org 00H
lcd_data EQU P2
lcd_rs  EQU P0.0
lcd_rw EQU P0.1
lcd_en EQU P0.2

	LJMP display_values

org 100H


displayInitialvalues:
	mov 50H, #3H	;value of K
	mov 51H, #65H	;start of the stored array
	mov 65H, #49H
	mov 66H, #41H
	mov 67H, #42H
	mov 68H, #43H
	mov 69H, #44H
	mov 6AH, #45H
	mov 6BH, #46H
	mov R2, 50H
	mov R0, 51H
	ret

display_values:

		LCALL lcd_init
	loop_disp:
		LCALL delay2sec
		LCALL displayInitialvalues
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
readnibble:
	MOV P1, #0fh
	MOV A, P1
	ANL A, #0fh
	MOV R7, A
	RET

delay2sec:
	PUSH 05H
	MOV R3, #40
	loop1:
		MOV R4, #200
	loop2:
		MOV R5, #0FFH
	loop3: 
		DJNZ R5, loop3
		DJNZ R4, loop2
		DJNZ R3, loop1
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
END

