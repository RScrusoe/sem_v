org 00H
	LJMP main
	
//FOR 10KHZ 
//	MOV TL0, #0ACH
//	MOV TH0, #0FFH

//FOR 20KHZ 
//	MOV TL0, #0DDH
//	MOV TH0, #0FFH

//FOR 50KHZ
//	MOV TL0, #0FCH
//	MOV TH0, #0FFH


org 100H
	main:
	MOV TMOD, #01H
	SETB P3.0
	loopMain:
	CPL P3.0
	MOV TL0, #0FCH
	MOV TH0, #0FFH
//	MOV IE, #82H
	ACALL delay
	SJMP loopmain	
	

	
delay:
SETB	TR0
AGAIN: JNB TF0, AGAIN
CLR TR0
CLR TF0
RET
END