org 0000H
ljmp main1
	
	org 200H
		
		main1:
			CLR A
			CLR C
		 MOV R0, #60H 
		 MOV R1, #70H
		 
		 MOV @R0, #0FFH
		 MOV @R1, #000H
		 
		 INC R0
		 INC R1
		 
		 MOV @R0, #0FFH
		 MOV @R1, #002H
		 ; Initialise the values which have to be subtracted
		 lcall sub16 ; call the subroutine sub16 to perform the subtraction
		 
		 stop:
			sjmp stop  ; Infinite loop for the termination
		 
		 
		
		sub16:
			; This subroutine is used to asubtract the two 16 bit numbers stored in the memory locations
			; pointed at by the register R0 and R1 in the big endian format. Also, it has the additional
			; property of storing the result in a memory location pointed whose address is given by 3 more
			; than the location of the equivalent byte of the first number ie, the LSB of the result will 
			; be at a memory location 3 more than the memory LSB of the first number
		
			CLR C		;  Clear the borrow bit	
			MOV R0, #61H  ; Use R0 for addressing the memory of the first number
			MOV R1, #71H  ; Use R0 for addressing the memory of the second number			
			MOV A, @R0 ;  Move the contents of the memory location pointed to by R0 to the accumulator (LSB) 
			SUBB A, @R1 ;  Subtract with borrow the contents of the memory location pointed by R1 
						; from the accumulator
			MOV 3, R0  ; Create a copy of the contents of R0 in R3
			INC R0
			INC R0
			INC R0
			; Increment the content of R0 by 3 to store at the required memory location
			MOV @R0, A ;  Move the result of LSB from accumulator to the required location
			
			MOV 0, R3 ;  Restore the contents of R0
			DEC R0  ;  Decrement the pointer for the first number
			DEC R1  ;  Decrement the pointer for the second number
			
			MOV A, @R0 ;  Move the contents of the memory location pointed to by R0 too the accumulator (MSB) 
			SUBB A, @R1 ;  Subtract with borrow the contents of the memory location pointed by R1 
						; from the accumulator
			;MOV 3, R0
			INC R0
			INC R0
			INC R0
			; Increment the content of R0 by 3 to store at the required memory location
			
			MOV @R0, A ;  Move the result of MSB from accumulator to the required location
			;MOV 0, R3
			
			DEC R0 ; Decrement R0 to access the third byte for the borrow bit
			MOV B, #00H ;  Clear the B register to store the default borrow of zero
			jnc label1
				INC B ;  If there is a borrow, increment the B register to account for it
				
				label1:
					MOV @R0, B  ; Move the contents of the register B to the third byte for the borrow bit
			
		ret
			
			
			
			
			
			
			
				
	END
				
			
			