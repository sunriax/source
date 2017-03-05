/* G.Raf@2AAELI
 * Timer_02
 * Polling von Timer0 �ber Timer Flag
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

// I/O Einstellungen
#define DDROUT DDRC		// Output Register
#define OUTPUT PORTC	// Output Port

static int count_SW;		// Software Z�hler initialisieren

int main(void)
{

	DDROUT  = HIGH;		// Datenrichtungsregister OUTPUT auf Ausgang
	OUTPUT  = LOW;		// LEDs an OUTPUT auf Eingang

	// Timer0 Einstellungen
	TCCR0 |= (1<<CS00);		// Timer0 Vorteiler (k(h)=1) einstellen
	
    while (1) 
    {
		if(TIFR & (1<<TOV0))			// Pr�fen ob Timer0 Overflow Flag gesetzt
		{
			count_SW++;					// Software Z�hler erh�hen
			if(count_SW >= 23437)		// Software Z�hlerwert pr�fen ob >= 23437
			{
				count_SW = 0;			// Software Z�hlerwert R�cksetzen
				OUTPUT = ~(OUTPUT);		// Ausgang (LEDs) negieren (0xFF <-> 0x00)
			}
			TIFR = (1<<TOV0);			// Timer0 Overflow Flag r�cksetzen
		}	
    }
}

