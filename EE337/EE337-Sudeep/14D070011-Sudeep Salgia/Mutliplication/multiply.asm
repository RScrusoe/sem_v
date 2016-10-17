org 00H
	LJMP main
	
	main:
		;MOV 70H, #81H
		;MOV 71H, #05H
		MOV R2, #00H
		MOV R3, #00H
		MOV R4, #00H
		
		
		MOV R0, #70H
		MOV R1, #71H
		CLR C
		MOV A, @R0
		ANL A, #80H
		RLC A
		RLC A
		MOV B, A
		CLR C
		MOV A, @R1
		ANL A, #80H
		RLC A
		RLC A
		XRL A,B
		CLR C
		RRC A
		RRC A
		MOV B, A
		
		MOV A, @R0
		ANL A, #7FH
		MOV R2, A
		MOV A, @R1
		ANL A, #7FH
		MOV R3, A
		
		CLR C
		MOV A, #00H
		
		up:
		ADD A, R2
		JNC down
			INC R4
			CLR C
		down:
		DJNZ R3, up
		
		MOV 72H, A
		MOV A, R4
		ORL A, B
		MOV 73H, A
		
		stop: sjmp stop
		
END
		