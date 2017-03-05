/********************************************************************
 *    Title:    LCD_printf	
 *    Author:   lau, wa
 *    Date:     12/2016
 *    Purpose:  Ansteuerung einer HD44780-LCD im 4-Bit-Modus
 *    Hardware: LCD-Modul und Megacard v4
 *    Software: Atmel Studio 6.2sp2
 *    Hardware: ATmega16 / Megacard v4
 *    Note:     fclk=12MHz
 **********************************************************************/
/* ACHTUNG: Vor Programm-Download das LCD-Modul von Megacard entfernen
 **********************************************************************/

//#define F_CPU 12000000UL	// bereits in "lcd_4.h" definiert 
#include "lcd_4.h"

unsigned int count=0;

int main(void){
	lcd_init();
	lcd_pos(0,0);
	printf("Mega v4");

	for(;;)                 
	{
		count++;									
		lcd_pos(1,0);
		printf("T= %5d",count);
		_delay_ms(500);
	}
}
