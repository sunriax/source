/* G.Raf@2AAELI
 * LED_01.c
 * Created: 06.10.2016 12:20:55
 * 
 * LED Toggeln 2
 */ 

#define F_CPU 12000000UL		// bereits in Project properities definiert
#include <avr/io.h>				// SFR Register und Bitdefinitionen
#include <util/delay.h>			// Delay-Funktionen

#define HIGH 0xFF				// HIGH Byte
#define LOW 0x00				// LOW Byte

int main(void)	// Modul Hauptprogramm
{
	// PORTC auf AUSGANG
	DDRC = HIGH;	// LED-Port (PortC): Ausgang
	PORTC = LOW;	// LEDs mit LOW initialisieren

    while (1)		// Endlosschleife
    {
		unsigned int readout = 0;
		
		PORTC++;		// PORTC erhöhen
		_delay_ms(500);	// 500 ms warten
		
    }					// ende Arbeitsschleife
}

