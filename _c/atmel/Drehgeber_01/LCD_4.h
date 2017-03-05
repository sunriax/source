#include "printf.h"
#include <avr/io.h>
//#include <avr/interrupt.h>
#define F_CPU 12000000UL //Systemtakt MEGACARD: 12 MHz
                         //Achtung: muss vor Einbindung der Delay-Library definiert sein!
#include <util/delay.h>
#include <avr/../string.h>
#include <avr/../stdlib.h>

//========================================
//Definition wo das LCD angeschlossen ist:
//========================================
#define RS				6
#define EN				4
#define DB4				2
#define DB5				5
#define DB6				6
#define DB7				7

//Definition des Timings:
/* Alternativ
#define WAIT_0	0.1
#define WAIT_1	0.5
#define WAIT_2	2
#define WAIT_3	10
#define WAIT_4	30
*/
#define WAIT_0	0.2
#define WAIT_1	0.2
#define WAIT_2	20
#define WAIT_3	15
#define WAIT_4	5

//Funktionsprototypen
void lcd_init(void);
void lcd_home(void);
void lcd_zToLCD(char dataD);
void lcd_pos(unsigned char zeile, unsigned char Pos);
void my_putc ( void* p, char c);

