/* G.Raf@2AAELI
 * Analog_02
 * Durch Interrupt ADC auslesen
 *
 * Board: Megacard
 * Version: 1.0
 */ 

//	#define F_CPU 12000000UL		// bereits in Project properities definiert
#include <avr/io.h>					// SFR Register und Bitdefinitionen
#include <avr/interrupt.h>

#define HIGH 0xFF		// HIGH Byte
#define LOW  0x00		// LOW Byte

// I/O Einstellungen
#define DDROUT DDRC		// Output Register
#define OUTPUT PORTC	// Output Port

ISR(ADC_vect)
{
	OUTPUT = ADCH;
}

int main(void)
{
    DDROUT = HIGH;
	OUTPUT = LOW;
 
 	ADMUX = 0x00;
 	ADMUX |= (1<<REFS0) | (1<<ADLAR);	// Referenzspannung auf AVCC
										// Ausrichtung Links
	ADMUX |= (1<<MUX2) | (1<<MUX0);

	// Vorteiler einstellen
	ADCSRA |= (1<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
	// Wandlar Ein & Start und Dauerwandlung Ein
	ADCSRA |= (1<<ADEN) | (1<<ADSC) | (1<<ADATE);

	ADCSRA |= (1<<ADIE);	// Interrupt individuell freigeben

	sei();	// Interrupt global freigeben

	asm volatile ("nop");
    
	while (1) 
    {
		
    }
}

