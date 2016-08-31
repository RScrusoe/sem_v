 
; My first assembly Program

LED	EQU P1.7	
	
	org 40H

; Some data 
M: DB 20
COUNT1:	DB 	28	;Decimal Number 28
N1:	DB	34 		;Hexadecimal number
STRING1:	DB	"ABCD123"	;ASCII CHARACTER
Name1: DB 'Suryakant'  ; String 
	
	 ;-------------------------------------------------
	 ; 		Main program
	 ;-------------------------------------------------
	 
	 ; Setup the Instruction location counter (ILC) of the 	assembler 
	 ; to point to reset vector of our Microcontroller
 
 org 0H

	 ; transfer control to main program segment as some code memory loccations 
	 ; near zero ( reset vector)  are used for special purpose activity 
	 ; handling like pointing to interrupts service routines
	 ; Placing code here may give unpredictable results
 
 ljmp main

 
	 ; The actual task for the main program is  Turn a LED on and OFF are regular interval.
	 ; In order to do it we call it after setting a port line high 
	 ; which will drive a LED so that we will have a visual feed back
	 ; note that the LED may be turning on and off very fast, so when 
	 ; we change the delay count its apparent brightness will change.
	 ; in general the LED will be brightest for lowest delay value.
	 
 
  
	; setup ILC to the locaiton of the Main program
	org 100H



main:


	nop

	MOV A,#0FFH				; Set the dElay value to store
	MOV R0, #DELAY_COUNT 	; Setup address of DELAY_COUNT in R0 register
	MOV @R0,A	; save it
	
	

	; now for visual presentation
	; lets chose a LED say P1.7 ( MSB of port 1)

Task1 :
	setb LED	; turn on LED
	lcall MyDelay

	clr LED	; turn off LED
	lcall MyDelay16

	sjmp Task1


; Define a data at location 20

DELAY_COUNT	DATA 20
 
	;-------------------------------------------------
	; 		MyDelay routine Starts
	;-------------------------------------------------

 	; delay count is at locations DELAY_COUNT 
	; which is indirectly adressable using R0 or R1


	; the routine is to use read the DELAY_COUNT Value
 
 MyDelay: 

	; lets load the value from Memory  using R0 register as a pointer
	 mov R0,#DELAY_COUNT 	; point to the Delay count value
	 mov A,@R0	; get a copy to use	 
	 MOV r1,A 
	 
	 TaskD:
		; decrement and if not zero go to TaskD to execute further
		djnz R1,TaskD	
		
	 ; when r1 is zero control comes here for next instruction
	 
	 ; we go back to the calling program
	 ret
	 
	 ;-------------------------------------------------
	 ; 		routine ENDS
	 ;-------------------------------------------------


 MyDelay16: 

	; We use Local delay counter of 16 bit (LSB in R2)
	; MSB in R1
	 mov R2,#0FFH 	; Delay count LSB value in R0
	 mov R1,#01H 	; Delay count MSB value in R1
	 
	 D_MSB:
		MOV 0,R2		; make a copy of the LSB for work
	 D_LSB:
		; decrement LSB and if its not zero go to decrement it furthe
		djnz R0,D_LSB
		; LSB reached zero so now decrement MSB
		; decrement MSB and if its not zero go to decrement it furthe
		
		djnz R1,D_MSB

		; when both are zero control comes here for next instruction
	 
		; we go back to the calling program
	 ret
	 
	 ;-------------------------------------------------
	 ; 		routine ENDS
	 ;-------------------------------------------------
	 
	 
	 ; Let the assembler knwo there are no more instructions to convert (end of file)
 END
 
 


