LCD_data equ P2    ;LCD Data port
LCD_rs   equ P0.0  ;LCD Register Select
LCD_rw   equ P0.1  ;LCD Read/Write
LCD_en   equ P0.2  ;LCD Enable

ORG 00H
	ljmp main
ORG 100H
	
	main:
		MOV SP , #0CFH
		MOV 50H , #2
		MOV 51H , #60H
		MOV 4FH , #00H
		
		MOV P1, #00H
		MOV P2, #00H
		acall delay_small
		acall delay_small
		
		acall lcd_init      ;initialise LCD
	
		acall delay_small
		acall delay_small
		acall delay_small
		
		MOV P1 , #0FFH 						
						
		MOV 4DH , #5
		lcall DELAY
						;wait for 5 sec during which user can give input 
		lcall readValues
		
		MOV 50H , #2
		MOV 51H , #60H
		MOV 52H , #70H
		lcall shuffleBits
						
		MOV P1, #0F0H
		
		MOV 4DH , #5
		lcall DELAY

		MOV P1, #00H					
							;clear pins P1.4 to P1.7

		MOV 4DH , #1
		lcall DELAY
		
		MOV 50H , #2
		MOV 51H , #70H
		lcall displayValues
		
		here: SJMP here
;-----------------------------------------------------------------------------------

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
         mov   LCD_data,A     ;Move the command to LCD port
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay_small
         clr   LCD_en
		 acall delay_small
    
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
         ret 		 ;Return from busy routine
		 

;-----------------------------------------------------------------------------------

;-----------------------------------------------------------------------------------
DELAY:
	USING 0		;ASSEMBLER DIRECTIVE TO INDICATE REGISTER BANK0
        PUSH PSW
        PUSH AR1	; STORE R1 (BANK O) ON THE STACK
        PUSH AR2
        PUSH AR3
		PUSH AR4
		PUSH 0E0H
		
		MOV R4, 4DH  ; Transfer value D to R4

delay1ms:		
		MOV R3, #20  ; Multiplies by 10 to give a delay of 1 s to Loop
DELAY_50ms:          ; 50ms delay Loop (Already given) 
        NOP
		MOV R2, #200
		BACK1:
			MOV R1, #0FFH
			BACK:
				DJNZ R1, BACK
			DJNZ R2, BACK1
		DJNZ R3, DELAY_50ms
	DJNZ R4, delay1ms
		
		POP 0E0H
		POP AR4
		POP AR3
        POP AR2 	; POP MUST BE IN REVERSE ORDER OF PUSH
        POP AR1
        POP PSW
        RET

;---------------------------------------------------------------------------------------

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
	 
;---------------------------------------------------------------------------------------

packNibble:
	USING 0
	PUSH PSW 
	PUSH AR0
	PUSH 0e0h
	
	
	;startAgain:
	MOV P1, #0FH				

	MOV 4DH , #1
	lcall DELAY
	
	lcall readnibble	;read the input on P1.0-P1.3 (nibble)
	
	;--------------
	MOV A , R0
	SWAP A
	ANL A , #0F0H
	MOV 4FH , A
	ORL A , #0FH
	MOV P1, A
						;show the read value on pins P1.4-P1.7
	
	MOV 4DH , #2
	lcall DELAY
						;wait for 5 sec 
	MOV P1, #0FH
	
	MOV 4DH , #1
	lcall DELAY
	
	lcall readnibble
						
	;--------------
	MOV A , R0
	ANL A , #0FH
	ORL A , 4FH
	MOV 4FH , A
	MOV A , R0
	SWAP A
	ORL A , #0FH
	MOV P1, A                            

	MOV 4DH , #2
	lcall DELAY
						

	POP 0E0H
	POP AR0
	POP PSW
	RET
;--------------------------------------------------------------------------------------------------------
	
readnibble:
	MOV P1, #0FH
	
	MOV A , P1
	ANL A , #0FH
	MOV R0, A
	RET					
	
;--------------------------------------------------------------------------------------------------------

readValues:
		USING 0		
		PUSH AR1
        PUSH AR2
		PUSH PSW
		PUSH 0E0H

		MOV R1 , 51H       ;Location to Store
		MOV R2 , 50H       ;K value
	
	loop_nibble_read:
		lcall packNibble
		MOV  @R1 , 4FH
		INC R1
		DJNZ R2 , loop_nibble_read  
		
		POP 0E0H
		POP PSW
        POP AR2	
        POP AR1
		RET

;------------------------------------------------------------------------------------------------

shuffleBits:
		USING 0		
        PUSH AR0
		PUSH AR1	
        PUSH AR2
        PUSH AR3
		PUSH PSW
		PUSH 0E0H

		MOV R0 , 51H   ;A location 
		MOV R1 , 52H   ;B location
		MOV R2 , 50H   ;Value of K

		DEC R2         
		MOV 3 , 0    
		
		loop_xor:
		MOV A , @R0
		INC R0
		XRL A , @R0
		MOV @R1 , A
		INC R1
		DJNZ R2 , loop_xor

		MOV A , @R0
		MOV 0 , 3
		XRL A , @R0
		MOV @R1 , A
		
		POP 0E0H
		POP PSW
		POP AR3
        POP AR2	; STORE R1 (BANK O) ON THE STACK
        POP AR1        
		POP AR0
		RET

;--------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------
displayValues:
		USING 0		
		PUSH AR0
        PUSH AR1	
        PUSH AR2
        PUSH AR3
		PUSH AR4
		PUSH PSW
		PUSH 0E0H

		MOV R3 , 51H
		MOV R2 , 50H
	
	loop_display:
		lcall readNibble
		MOV A , R0
		CLR C
		SUBB A , R2
		JNC endTask
		
		MOV A , R0
		ADD A , R3
		MOV R1 , A
		
		MOV A,#83h		 
		ACALL lcd_command	 
		LCALL delay_small
		MOV A, @R1
		
	
		;ANL A, #0F0H
		;RR A
		;RR A
		;RR A
		;RR A
		;MOV R4,A
		;CLR C
		;SUBB A,#0AH
		;MOV A, R4
		;JC down
		;	ADD A,#07H
		;	down:
		;	ADD A, #30H
			
		;	LCALL lcd_senddata 
		;	LCALL delay_small
			
			
		;	MOV A, @R1
		;	ANL A, #0FH
		;	MOV R4,A
		;	CLR C
		;	SUBB A,#0AH
		;	MOV A, R4
		;	JC down1
		;	ADD A,#07H
		;		down1:
		;		ADD A, #30H
		;		LCALL lcd_senddata 
		;		LCALL delay_small
				
		
		
		
		LCALL lcd_senddata 
		LCALL delay_small
		
		MOV 4DH , #2
		lcall DELAY
		
		ljmp loop_display

	endTask:
		 acall delay
         mov   LCD_data,#01H  ;Clear LCD
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         
		 ACALL delay
		 
		POP 0E0H
		POP PSW
		POP AR4
		POP AR3
        POP AR2	
        POP AR1
		POP AR0
		 
		RET

		
END

	