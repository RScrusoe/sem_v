org 0000H
ljmp main
	
	org 100H
		
		main: 
		 MOV R0, #60H 
		 MOV R1, #70H
		 
		 MOV @R0, #000H
		 MOV @R1, #0FFH
		 
		 INC R0
		 INC R1
		 
		 MOV @R0, #0FFH
		 MOV @R1, #0FFH
		 
		 ; The above values are used for initialization of the value which are to be added
		 
		 lcall adder16 ; call the subroutine adder16 which implements 16 bit addition
		 
		 stop:
			sjmp stop
		
		adder16:
			CLR C
			MOV R0, #60H ; Use R0 for addressing the memory of the first number
			MOV R1, #70H ; Use R1 for addressing the memory of the second number 
			MOV A, @R0
			XRL A, @R1
			MOV R4, A
			INC R0
			INC R1
			MOV A, @R0
			ADDC A, @R1
			;CLR A ; Clear the accumulator
			MOV 3, R0 ; Create a copy of the value in R0 in R3
				INC R0
				INC R0
				INC R0
			
			MOV @R0, A
			
			MOV 0, R3
			
			;  Call the subroutine of add8 for the LSB
			
			DEC R0 ; Decrement the pointer for first number
			DEC R1 ; Decrement the pointer for second number
			;  Call the subroutine add8 for the MSB
			
			
			MOV A, @R0
			ADDC A, @R1
			
			MOV 3, R0
			INC R0
			INC R0
			INC R0
			; Increment the content of R0 by 3 to store at the required memory location
			
			MOV @R0, A ;  Move the result of MSB from accumulator to the required location
			;MOV 0, R3
			
			
			DEC R0 ; Decrement R0 to access the third byte for the borrow bit
			MOV A, R4
			MOV R5, #00H
			jnc goto
				MOV R5, #80H
				goto:
			XRL A, R5
			MOV B, #00H ;  Clear the B register to store the default borrow of zero
			jnb 0E7H, label1
				INC B ;  If there is a borrow, increment the B register to account for it
				
				label1:
					MOV @R0, B
			
		ret
				
	END
				
			
			