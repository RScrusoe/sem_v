ORG 0000H
LJMP MAIN
ORG 0200H
MAIN:


;	IF NUMBER IS > 80H IT WILL BE NEGATIVE
;	SO FIRST CHECKING SIGNS OF 2 NUMBERS AND IF NUMBER IS NEGATIVE STORE 80H IN 76H, 77H (JUST SO THAT WE CAN COMPARE THE SIGNS OF 2 NUMBERS LATER)
;	IF NUMBER IS GREATER THAN 80 SUBSTRACT 80 FROM IT AND COPY MODIFIED NUMBERS IN 74H, 75H
;	MULTIPLY 74H AND 75H
;	NOW COMPARE 76H, 77H IF IT IS SAME I.E. SIGNS ARE SAME SO PRODUCT IS > 0
;	ELSE ADD 80 IN MSB OF PRODUCT 
;
;

		CLR C
		MOV 70H, #086H
		MOV 71H, #29H
		MOV 76H, #0H
		MOV 77H, #0H
		
		MOV A, #80H
		SUBB A, 70H
		JC ADJUST1
		H1:
		JNC JUST1
		H2:
		
		CLR C
		MOV A, #80H
		SUBB A, 71H
		JC ADJUST2
		H3:
		JNC JUST2
		H4:	
		MOV A, 74H
		MOV B, 75H
		MUL AB
		
		MOV 72H, A
		MOV 73H, B
		MOV A, 77H
		
		CJNE A, 76H, FINAL
		H5:		
	
				
				STOP: SJMP STOP
		
		ADJUST1:
				MOV A, 70H
				SUBB A, #80H
				ADD A, #1H
				MOV 74H, A
				MOV 76H, #80H
				CPL C
				SJMP H1
		ADJUST2:
				MOV A, 71H
				SUBB A, #80H
				ADD A, #1H
				MOV 75H, A
				MOV 77H, #80H
				CPL C
				SJMP H3
		JUST1:
				MOV 74H, 70H
				SJMP H2
		JUST2:
				MOV 75H, 71H
				SJMP H4
				
		FINAL:
				MOV A, B
				ADD A, #80H
				MOV 73H, A
				SJMP H5

END