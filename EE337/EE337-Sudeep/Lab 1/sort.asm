org 0000H
	ljmp main
	
	org 100H
	
	main:
		MOV B,#05H
		MOV R0,#60H
		MOV R1,#70H
		loop1:
			MOV 2,@R0
			MOV @R1,2
			INC R0
			INC R1
			djnz B, loop1
			
		MOV R2,#05H
		MOV R1, #70H
		loop4:
			lcall sort
			INC R1
			djnz R2, loop4
			
		MOV @R0, #00H
	
	
	
	sort:
		MOV R0, #70H
		MOV A,@R0
		MOV B,#05H
				
		loop2: 
			SETB C
			CPL C
			SUBB A,@R1
			
			jc loop3
				MOV 3,@R0
				MOV 4,@R1
				MOV @R0,4
				MOV @R1,3
				
				
				loop3:
					INC R0
					MOV A, @R0
				
				djnz B, loop2
				
		ret
	
	END
				
		
	