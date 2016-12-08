org 00H
	LJMP main
	
	main:
		PUSH SP 
		MOV A, 08H
		MOV B, 07H
		
		here: sjmp here
	END