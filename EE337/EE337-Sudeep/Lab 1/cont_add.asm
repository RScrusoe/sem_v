org 0000H
	ljmp main1
	
	org 1000H
		
		main1:
		
		nop
		
		MOV R0, #50H ;	R0 will store the memory locations of where the numbers have to be stored	
		MOV @R0, #05H
		MOV B , @R0 
		INC R0
		MOV @R0, #01H ;
		MOV R1, #02H ; This will generate the list of natural numbers which have to be added
		DEC B
		MOV A, B ; this is to check the corner case of when number is 1 or 2 
		
		jz down ; for the above case

		
		
		label1:
		
			MOV A, @R0 ; Move the contents of location contained in R0 to the accumulator
			ADD A, R1 ;  Add the contents of R1 to accumulator
			INC R0
			MOV @R0,A
			INC R1
			DEC B
			MOV A,B
			jnz label1
		
		down:
		END
			
			