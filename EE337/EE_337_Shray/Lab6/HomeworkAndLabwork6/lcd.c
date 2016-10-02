/**
 LCD HOMEWORK , LABWORK XX
 */

/* @section  I N C L U D E S */
#include "at89c5131.h"
#define LCD_data  P2	    					// LCD Data port

//Function Declarations
void LCD_Init();
void LCD_DataWrite(char dat);
void LCD_CmdWrite(char cmd);
void LCD_WriteString(char * str, unsigned char len);
void LCD_Ready();
void sdelay(int delay);
void delay_ms(int delay);

sbit CS_BAR = P1^4;									// Chip Select for the ADC
sbit LCD_rs = P0^0;  								// LCD Register Select
sbit LCD_rw = P0^1;  								// LCD Read/Write
sbit LCD_en = P0^2;  								// LCD Enable
sbit LCD_busy = P2^7;								// LCD Busy Flag

//Global Variables
bit transmit_completed= 0;					// To check if spi data transmit is complete
char serial_data, data_save_high, data_save_low;	

void main(void)
{
	P2 = 0x00;											// Make Port 2 output 
	LCD_Init();
	while(1)			   							// endless  
  {
		/* Code for displaying "Hello World"
			 on the LCD to be written here */		 
		delay_ms(5000);
	}
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
void LCD_WriteString( char * str, unsigned char length)
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

/**
 * FUNCTION_PURPOSE: A delay of around 1000us for a 24MHz crystel
 * FUNCTION_INPUTS: void
 * FUNCTION_OUTPUTS: none
 */
void delay_ms(int delay)
{
	int d=0;
	while(delay>0)
	{
		for(d=0;d<382;d++);
		delay--;
	}
}
