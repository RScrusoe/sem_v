lcd_data equ P2
lcd_rs  equ P0.0
lcd_rw equ P0.1
lcd_en equ P0.2

org 000H
ljmp start

org 200H

initializeRAM:
	MOV R0, #80H
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
	MOV @R0, #00H		
	RET

start:
	lcall initializeRAM
	mov P2, #00h
	mov P1, #00h

	acall delay
	acall delay

	acall lcd_init 	; initialize lcd

	acall delay
	acall delay
	acall delay

	mov A, #81H		; put cursor on first row, fifth column
	acall lcd_command	;send command to the lcd

	acall delay

	mov dptr, #my_string1 	;Load DPTR with sring1 Addr
	acall lcd_send_string   ;call text strings sending routine
	acall delay

	mov R2, #00h
	mov R0, #80h
	loop_ex:
		inc R2
		inc R0
		mov A, @R0
		JNZ loop_ex

	mov A, #10H
	subb A, R2
	rrc A
	add A, #0c0h
	; mov A, #0c3h
	acall lcd_command

	mov R1, #80h
	acall lcd_send_string1
	acall delay

here: sjmp here



;------------------------LCD Initialisation routine----------------------------------------------------
lcd_init:
		mov lcd_data, #38H	;Function set: 2 Line, 8-bit, 5x7 dots
		acall lcd_init_helper

		mov lcd_data, #0ch	;Display on, Curson off
		acall lcd_init_helper

		mov lcd_data,#01H	;Clear LCD
		acall lcd_init_helper

		mov lcd_data, #06H	;Entry mode, auto increment with no shift
		acall lcd_init_helper

		ret

lcd_init_helper:
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
	acall lcd_init_helper
	ret
;-----------------------New text strings sending routine-------------------------------------
lcd_send_string1:
	push 0e0h
	lcd_send_loop1string:
		clr A
		mov A, @R1		;load first character in accumulator
		jz exit1					;go to exit if zero
		acall lcd_senddata
		acall delay
		inc R1
		sjmp lcd_send_loop1string
		exit1:
		pop 0e0h
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
         mov   LCD_data,A     ;Move the command to LCD port
         setb  LCD_rs         ;Selected data register
         clr   LCD_rw         ;We are writing
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         acall delay
		 acall delay
		 ; lcall lcd_init_helper
		 ; acall delay
         ret                  ;Return from busy routine

		
;----------------------delay routine-----------------------------------------------------
delay:	 push 0
	 push 1
         mov r0,#1
loop2:	 mov r1,#255
	 loop1:	 djnz r1, loop1
	 djnz r0, loop2
	 pop 1
	 pop 0 
	 ret

;------------- ROM text strings---------------------------------------------------------------
org 300h
my_string1:
         DB   "EE 337 - Lab 2", 00H
end

