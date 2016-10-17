/**
 UART HOMEWORK , LABWORK (SAME PROGRAM)
 */

/* @section  I N C L U D E S */
#include "at89c5131.h"
#include "stdio.h"
#define LCD_data  P2  // LCD Data port

void init_serial(void);
void LCD_Init();
void LCD_DataWrite(char dat);
void LCD_CmdWrite(char cmd);
void LCD_StringWrite(char * str, unsigned char len);
void LCD_Ready();
void sdelay(int delay);
void send_serial(char str);
void send_string(char* string, int length);
void delay_ms(int delay);
void find_parity(char str);

sbit LCD_rs = P0^0;  								// LCD Register Select
sbit LCD_rw = P0^1;  								// LCD Read/Write
sbit LCD_en = P0^2;  								// LCD Enable
sbit LCD_busy = P2^7;								// LCD Busy Flag
//sbit ONULL = P1^0;

bit Parity;
sbit toggle_bit = P1^4;

char old_value = 0;
char switch_value = 0;



char byteToWrite;
int rcount = 0;


void main()
{
	init_serial();
	LCD_Init();
	//P1^4 = 1;
	//SCON |= 0x10;
	while(1){
		switch_value = P1 &=0x0F;
		if(!(switch_value == old_value))
		{
			old_value = P1 &= 0x0F;
			LCD_CmdWrite(0x80);
			LCD_StringWrite("AAAAAAAAAA", 10);
			send_string("AAAAAAAAAA", 10);
		}
		else
			LCD_Init();
		
		delay_ms(500);
		
	/*SBUF = 'A';
		while(!transmit_completed);
		transmit_completed = 0;
		toggle_bit=0;*/
		
	}
}

void ISR_Serial(void) interrupt 4
{

	
	if(RI == 1)
	{
		RI = 0;
		byteToWrite = SBUF;
		if(rcount == 0)
			LCD_CmdWrite(0xC0);
		LCD_DataWrite(byteToWrite);
		rcount ++;
		if(rcount == 10)
			rcount =0;
	}
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
	REN =1;
}

	/**
 * FUNCTION_PURPOSE:LCD Initialization
 * FUNCTION_INPUTS: void
 * FUNCTION_OUTPUTS: none
 */
void LCD_Init()
{
  sdelay(100);
  LCD_CmdWrite(0x38);   	// LCD 2lines, 5*7 matrix
  LCD_CmdWrite(0x0E);			// Display ON cursor ON  Blinking off
  LCD_CmdWrite(0x01);			// Clear the LCD
  LCD_CmdWrite(0x80);			// Cursor to First line First Position
}

/**
 * FUNCTION_PURPOSE: Write Command to LCD
 * FUNCTION_INPUTS: cmd- command to be written
 * FUNCTION_OUTPUTS: none
 */
void LCD_CmdWrite(char cmd)
{
	LCD_Ready();
	LCD_data=cmd;     			// Send the command to LCD
	LCD_rs=0;         	 		// Select the Command Register by pulling LCD_rs LOW
  LCD_rw=0;          			// Select the Write Operation  by pulling RW LOW
  LCD_en=1;          			// Send a High-to-Low Pusle at Enable Pin
  sdelay(5);
  LCD_en=0;
	sdelay(5);
}

/**
 * FUNCTION_PURPOSE: Write Command to LCD
 * FUNCTION_INPUTS: dat- data to be written
 * FUNCTION_OUTPUTS: none
 */
void LCD_DataWrite( char dat)
{
	LCD_Ready();
  LCD_data=dat;	   				// Send the data to LCD
  LCD_rs=1;	   						// Select the Data Register by pulling LCD_rs HIGH
  LCD_rw=0;    	     			// Select the Write Operation by pulling RW LOW
  LCD_en=1;	   						// Send a High-to-Low Pusle at Enable Pin
  sdelay(5);
  LCD_en=0;
	sdelay(5);
}
/**
 * FUNCTION_PURPOSE: Write a string on the LCD Screen
 * FUNCTION_INPUTS: 1. str - pointer to the string to be written, 
										2. length - length of the array
 * FUNCTION_OUTPUTS: none
 */
void LCD_StringWrite( char * str, unsigned char length)
{
    while(length>0)
    {
        LCD_DataWrite(*str);
        str++;
        length--;
    }
}

/**
 * FUNCTION_PURPOSE: To check if the LCD is ready to communicate
 * FUNCTION_INPUTS: void
 * FUNCTION_OUTPUTS: none
 */
void LCD_Ready()
{
	LCD_data = 0xFF;
	LCD_rs = 0;
	LCD_rw = 1;
	LCD_en = 0;
	sdelay(5);
	LCD_en = 1;
	while(LCD_busy == 1)
	{
		LCD_en = 0;
		LCD_en = 1;
	}
	LCD_en = 0;
}

/**
 * FUNCTION_PURPOSE: A delay of 15us for a 24 MHz crystal
 * FUNCTION_INPUTS: void
 * FUNCTION_OUTPUTS: none
 */
void sdelay(int delay)
{
	char d=0;
	while(delay>0)
	{
		for(d=0;d<5;d++);
		delay--;
	}
}

void send_serial(char str)
{

		SBUF=str;
		find_parity(str);
		TB8=Parity;
		while(TI==0);
//		~toggle_bit;
		TI=0;
	
	
}

void send_string(char* string, int length)
{
	
		while(length>0)
    {
        send_serial(*string);
        string++;
        length--;
    }
}

void delay_ms(int delay)
{
	int d=0;
	while(delay>0)
	{
		for(d=0;d<382;d++);
		delay--;
	}
}