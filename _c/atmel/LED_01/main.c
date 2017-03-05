/* G.Raf@2AAELI
 * LED_01.c
 * Created: 06.10.2016 12:20:55
 * 
 * LED Toggeln
 */ 

//#define F_CPU 12000000UL		// bereits in Project properities definiert
#include <avr/io.h>				// SFR Register und Bitdefinitionen
#include <util/delay.h>			// Delay-Funktionen

#define HIGH 0xFF				// HIGH Byte
#define LOW 0x00				// LOW Byte

int main(void)	// Modul Hauptprogramm
{
	// PORTC auf AUSGANG
	DDRC = HIGH;	// LED-Port (PortC): Ausgang
	PORTC= 0x55;	// LEDs 0,2,4,6 einschalten

    while (1)		// Endlosschleife
    {
		PORTC = ~PORTC;	// alle LEDs umschalten
		_delay_ms(200);	// 200 ms warten
    }					// ende Arbeitsschleife
}

