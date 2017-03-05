/* G.Raf@2AAELI
 * Timer_01
 * Interrupt Timer0 durch Überlauf
 *
 * Board: Megacard
 * Version: 1.0
 */ 

//	#define F_CPU 12000000UL		// bereits in Project properities definiert
#include <avr/io.h>					// SFR Register und Bitdefinitionen
#include <avr/interrupt.h>
//	#include <util/delay.h>			// Delay-Funktionen

#define HIGH 0xFF		// HIGH Byte
#define LOW 0x00		// LOW Byte

// Timer0 Einstellungen
#define DDROUT DDRC		// Output Register
#define OUTPUT PORTC	// Output Port

ISR(TIMER0_OVF_vect)			// Timer0 Interrupt Overflow
{
	static int count_SW;		// Software Zähler initialisieren
	count_SW++;					// Software Zähler um 1 erhöhen
	
	if(count_SW >= 23437)		// Software Zählerwert prüfen ob >= 23437
	{
		count_SW = 0;			// Software Zählerwert Rücksetzen
		OUTPUT = ~(OUTPUT);		// Ausgang (LEDs) negieren (0xFF <-> 0x00)
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

