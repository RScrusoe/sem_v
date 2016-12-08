/**
 UART HOMEWORK , LABWORK (SAME PROGRAM)
 */

/* @section  I N C L U D E S */
#include "at89c5131.h"
#include "stdio.h"
#define LCD_data  P2	    					// LCD Data port
bit transmit_completed = 0;
sbit toggle_bit = P1^4;
bit Parity;
void find_parity(char str);
int count = 0, i = 0 ;

void ISR_Serial(void) interrupt 4
{
	//SCON &= 0xFD;	
	//a = 'A' + 0;
	TI =0;
	transmit_completed = 1;
	toggle_bit = 1;
	find_parity('A');
	TB8 = Parity;
	//SBUF = 'A';
	//~P1^4;
}

void init_serial()
{
	SCON |= 0xC0;
	SCON &= 0xFC;
	TMOD = 0x20;
	TH1 = 0xCC;
	EA = 1;
	ET1 = 0;
	ES = 1;	
	TR1 = 1;
}

void find_parity(char str)
{
	Parity=1;
	count=0;
	for(i=0;i<8;i++)
	{
		Parity=str & 0x01;
		if(Parity==1) count=count+1;
		str=str>>1;
	}
	if(count%2==1){ Parity=1;}
	else Parity=0;
		
	
}

void main()
{
	init_serial();
	//P1^4 = 1;
	//SCON |= 0x10;
	while(1){
	SBUF = 'A';
		while(!transmit_completed);
		transmit_completed = 0;
		toggle_bit=0;
	}
}