; Defining timer 2 registers
T2CON DATA 0C8H
T2MOD DATA 0C9H
RCAP2L DATA 0CAH
RCAP2H DATA 0CBH
TL2 DATA 0CCH
TH2 DATA 0CDH

; Defining the interrupt enable (IE) bit
ET2 BIT 0ADH

;Defining interrupt priority (IP) bit
PT2 BIT 0BDH

;Defining P1
T2EX BIT 91H
T2 BIT 90H
	
;Defining timer control (T2CON) register bits
TF2 BIT 0CFH
EXF2 BIT 0CEH
RCLK BIT 0CDH
TCLK BIT 0CCH
EXEN2 BIT 0CBH
TR2 BIT 0CAH
C_T2 BIT 0C9H
CP_RL2 BIT 0C8H
	
org 0000H	
	ljmp main


org 100H
; Timer 2 intialisation
T2_init:
	MOV	T2MOD, #03H
	CLR EXF2
;	T2CON, #04H
	CLR RCLK
	CLR TCLK
	CLR EXEN2
	
	MOV TH2, #0E8H
	MOV TL2, #90H
	
	MOV RCAP2H, #0E8H
	MOV RCAP2L, #90H
	SETB TR2
	CLR C_T2
	CLR CP_RL2
	SETB ET2
	

	RET
	
	main:
		; Port Initialization
		SETB EA
		CLR TF2
		lcall T2_INIT
		
		here: sjmp here
		
END
