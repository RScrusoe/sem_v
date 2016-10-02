
ORG 00H
	LJMP MAIN

;Some Command Definitions are written here used in the code 
LCD_CLR 		EQU 001H;directly stores values here
LCD_HOME 		EQU 002H
LCD_CURSOR_DEC 	EQU 004H
LCD_CURSOR_INC 	EQU 006H
LCD_LINE1		EQU 080H
LCD_LINE2		EQU 0C0H
LCD_CURSOR_OFF	EQU 00CH
LCD_OFF			EQU 008H

;Ports
LCD_DB		EQU P2		;Data Bus
LCD_RS		EQU P0.0	;Register Select: H - Data
LCD_RW		EQU P0.1	;R/W: H - Read
LCD_EN		EQU P0.2	;Enable: H to L Transition

;Cursor Store
CURSOR_MEM	EQU 0FFH	;Previous Cursor Location necessary for ram implementation
	
ORG 30H

DELAY_500mS:
;Gives 4FH*500ms Delay

	PUSH ACC	;PUSH the necessary registers
	PUSH 1
	PUSH 2
	PUSH 3
	PUSH 4FH
	
	MOV A, 4FH
	JZ RETURN_D_500	;If 0 seconds delay
	
	BACK_D3_500:				;500ms
		MOV R3,#10			
		BACK_D2_500:			;50ms
			MOV R2,#198			;Optimised for 50ms
			NOP
			NOP
			NOP
			BACK_D1_500:
				MOV R1,#0FBH	;Optimised for 50ms
				BACK_D_500:
					DJNZ R1, BACK_D_500
					DJNZ R2, BACK_D1_500
					DJNZ R3, BACK_D2_500
					DJNZ 4FH, BACK_D3_500
		
	RETURN_D_500:		
		POP 4FH
		POP 3	
		POP 2
		POP 1
		POP ACC

RET

DELAY_10mS:
;Gives 4FH*10ms Delay

	PUSH ACC	;PUSH the necessary registers
	PUSH 1
	PUSH 2
	PUSH 4FH
	
	MOV A, 4FH
	JZ RETURN_D_10	;If 0 seconds delay
				
	BACK_D1_10:
		MOV R1,#0FBH	;Optimised for 50ms
		BACK_D_10:
			DJNZ R1, BACK_D_10
			DJNZ 4FH, BACK_D1_10

	RETURN_D_10:		;Pop the necessary registers
		POP 4FH	
		POP 2
		POP 1
		POP ACC

RET

LCD_INIT:
;Initializes the LCD
;dont know how this works .. copied from the already given code 
	PUSH 4FH
	PUSH ACC
	
	MOV 4FH, #2			;Delay of 20ms
	
	LCALL DELAY_10mS	;Wait for LCD ON
	LCALL DELAY_10mS
	
	MOV A, #38H			;Use 2 lines and 5×7 matrix
	ACALL LCD_COMMAND	;Send Command to the LCD
	LCALL DELAY_10mS
	
	MOV A, #0CH			;LCD ON, Cursor OFF
	ACALL LCD_COMMAND
	LCALL DELAY_10mS
	
	MOV A, #06H			;Increment cursor
	ACALL LCD_COMMAND
	
	MOV A, #01H			;Clear screen
	ACALL LCD_COMMAND
	
	POP ACC
	POP 4FH
RET

LCD_COMMAND:
;Send Command to the LCD
;Command stored in ACC

	CLR LCD_RW		;Clear for Write
	CLR LCD_RS		;Clear for command
	MOV LCD_DB, A	;Send command
	MOV 4FH, #10
	
	SETB LCD_EN			;High to Low edge
	ACALL DELAY_10mS
	CLR LCD_EN			;To enable the command
RET

LCD_DATA:
;Show 8-bit data on LCD
;Previous Cursor Location to be stored at CURSOR_MEM
;Data displayed at CURSOR_MEM + 1
;Data must be stored in ACC for code to work

	PUSH 0
	PUSH PSW
	MOV R0, A				;Remember Data
	MOV A, CURSOR_MEM		;Previous Cursor Location
	INC A					;Next Location
	INC CURSOR_MEM			;Increment Previous Location
	CLR C
	SUBB A, #17				
	JNC LCD_DATA_CON1		;If in Line2
	ADD A, #090H			;Else set command to set cursor on first line
	JMP LCD_DATA_AHEAD		;Skip Line2 check
	LCD_DATA_CON1:
		SUBB A, #16			;Check if out-of range
		JC LCD_DATA_CON2	;If not
		MOV A, LCD_LINE1	;Else send cursor home
		MOV CURSOR_MEM, #01	;Store Previous Location
		JMP LCD_DATA_AHEAD	;Skip If condition
		LCD_DATA_CON2:
		ADD A, #0D0H		;Set the necessary command
	
	LCD_DATA_AHEAD:
	ACALL LCD_COMMAND		;Send the command

	
	MOV A, R0		;Move Data Back
	
	CLR LCD_RW		;Clear to Write
	SETB LCD_RS		;Set to send data
	MOV LCD_DB, A	;Send Data
	MOV 4FH, #10
	
	SETB LCD_EN		;Falling Edge for enable	
	ACALL DELAY_10mS
	CLR LCD_EN
	
	POP PSW
	POP 0
RET

LCD_STRING_ROM:
;Show String from ROM location
;Starting address stored in DPTR
;End if 00H is encountered

	PUSH ACC
	
	LCD_STRING_ROM_LOOP:
		CLR	 A					;Set A to 0
		MOVC A, @A+DPTR			;Move data from RoM	
		JZ 	LCD_STRING_EXIT		;Exit if 0
		ACALL LCD_DATA			;Else show data
		INC DPTR				;Next Data
		JMP LCD_STRING_ROM_LOOP	;Loop Back
		
	LCD_STRING_EXIT:
	POP ACC
RET


	
MAIN:
	ACALL LCD_INIT

	MOV CURSOR_MEM, #00H
	MOV DPTR, #lab_name
	ACALL LCD_STRING_ROM

	MOV DPTR, #my_name
	ACALL LCD_STRING_ROM

	LOOP:SJMP LOOP
	lab_name:	DB	' EE 337 - Lab 4 ', 00H
	my_name:	DB	'      SHRAY     ', 00H
END