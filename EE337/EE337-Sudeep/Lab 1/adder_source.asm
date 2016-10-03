org 0000H
	ljmp main
	
	org 100H
	
	main:
	 
	 nop
	 
	 MOV 50H, #0FFH
	 MOV 60H, #0F0H
	 
	 MOV A, 50H ; Move the data at the location 50H to the accumulator
	 ADD A, 60H ;  Add the contents of the accumulator to the contents in the memory location 60H
	 
	 MOV 70H, A ; Store the contents of the accumulator (the sum) at memory location 70H
	 END
		 