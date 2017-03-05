/*
 * Schleifentest_01.c
 *
 * Created: 9.11.2016 19:58:09
 * Author: Harry
 * Hardware: MEGACARD
 * Zweck: Test der Zählschleife
 */ 

#define F_CPU 12000000UL // Systemtakt definieren
#include <util/delay.h>  // Delay-Funktionen einbinden (Systembibliothek)
#include <avr/io.h>	     // I/O Definitionen einbinden (Systembibliothek)

int main(void)
{
    //PORTKONFIGURATION:
	DDRC=0xFF;  //LED-Port: Ausgang
    PORTC=0x00; //alle LEDs ausschalten (default)
    
	for(;;) //Endlosschleife
    {
        for (unsigned char i=0; i<=8; i++) //lokale Deklaration der Laufvariablen i
		{
			PORTC=i;			// PORTC mit i Beschreiben
			_delay_ms(500);		// 500ms Zeitverzögerung
		} 
    } 
}