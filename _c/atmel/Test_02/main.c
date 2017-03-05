/* G.Raf@2AAELI
 * Test_02
 * Interrupt Timer0 durch Überlauf mit 30% On / 70% Off Tastverhältnis
 *
 * Board: Megacard
 * Version: 1.0
 */ 

#define F_CPU 12000000UL		// bereits in Project properities definiert
#include <avr/io.h>				// SFR Register und Bitdefinitionen
#include <avr/interrupt.h>
//	#include <util/delay.h>		// Delay-Funktionen

#define HIGH 0xFF		// HIGH Byte
#define LOW 0x00		// LOW Byte

// Timer0 Einstellungen
#define DDROUT DDRC		// Output Register
#define OUTPUT PORTC	// Output Port

volatile unsigned int count_SW;		// Software Zähler initialisieren

ISR(TIMER0_OVF_vect)			// Timer0 Interrupt Overflow
{
	count_SW++;					// Software Zähler um 1 erhöhen
	
	if(count_SW < 36)		// Software Zählerwert prüfen ob >= 23437
	{
		OUTPUT = 0xFF;		// Ausgang (LEDs) negieren (0xFF <-> 0x00)
	}
	else if(count_SW < 117)
	{
		OUTPUT = 0x00;
	}
	else
	{
		count_SW = 0;
	}
}

int main(void)
{

	DDROUT  = HIGH;		// Datenrichtungsregister OUTPUT auf Ausgang
	OUTPUT  = LOW;		// LEDs an OUTPUT auf Eingang

	// Timer0 Interrupts Register
	TCCR0 |= (1<<CS00);		// Timer0 Vorteiler (k(h)=1) einstellen
	TIMSK = (1<<TOIE0);		// Timer0 Interrupt freigeben

	sei();					// Interrupts Global Freigeben
	
    while (1) 
    {
		// Kein Programmcode vorhanden
    }
}

