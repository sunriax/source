/* G.Raf@2AAELI
 * Analog_01
 * ADC über Polling auslesen
 *
 * Board: Megacard
 * Version: 1.0
 */ 

//	#define F_CPU 12000000UL		// bereits in Project properities definiert
#include <avr/io.h>					// SFR Register und Bitdefinitionen
#include <avr/interrupt.h>
#include "lcd_4.h"

#define HIGH 0xFF		// HIGH Byte
#define LOW  0x00		// LOW Byte

// I/O Einstellungen
#define DDROUT DDRC		// Output Register
#define OUTPUT PORTC	// Output Port


unsigned char ADC_SingleRead(unsigned char channel)
{
	unsigned char buffer[100];
	unsigned int result = 0;

	ADMUX = 0x00;
	ADMUX |= (1<<REFS0) | (1<<ADLAR);	// Referenzspannung auf AVCC
										// Ausrichtung Links
	// Kanal Auswahl
	switch(channel)
	{
		case 1	:	ADMUX |=   (1<<MUX0);							break;	// Kanal 1 einstellen
		case 2	:	ADMUX |=   (1<<MUX1);							break;	// Kanal 2 einstellen
		case 3	:	ADMUX |=   (1<<MUX1) | (1<<MUX0);				break;	// Kanal 3 einstellen
		case 4	:	ADMUX |=   (1<<MUX2);							break;	// Kanal 4 einstellen
		case 5	:	ADMUX |=   (1<<MUX2) | (1<<MUX0);				break;	// Kanal 5 einstellen
		case 6	:	ADMUX |=   (1<<MUX2) | (1<<MUX1);				break;	// Kanal 6 einstellen
		case 7	:	ADMUX |=   (1<<MUX2) | (1<<MUX1) | (1<<MUX0);	break;	// Kanal 7 einstellen
		default	:	ADMUX &= ~((1<<MUX2) | (1<<MUX1) | (1<<MUX0));	break;	// Kanal 0 (Defaultwert)
	}

	// Vorteiler einstellen
	ADCSRA |= (1<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);

	// Betriebsmodus Einzelwandlung
	ADCSRA &= ~(1<<ADATE);

	// Wandlar aktivieren
	ADCSRA |= (1<<ADEN);

	for(unsigned char i=0; i < sizeof(buffer); i++)
	{
			// Wandlung starten
			ADCSRA |= (1<<ADSC);

			// Warten bis Wandler fertig
			while(ADCSRA & (1<<ADSC))
			{
				asm volatile ("nop");
			}

			buffer[i] = ADCH;
	}

	// Wandler Ausschalten
	ADCSRA &= ~(1<<ADEN);

	// Mittelwert berechnen
	for(unsigned char i=0; i < sizeof(buffer); i++)
	{
		result += buffer[i];
	}
	result = result / sizeof(buffer);

	return result;
}

int main(void)
{
	unsigned char adcread;
	unsigned int calc;

	lcd_init();
	lcd_pos(0,0);
	printf("Analog_01");

    DDROUT = HIGH;
	OUTPUT = LOW;
    
	while (1) 
    {
	adcread = ADC_SingleRead(5);
	OUTPUT = adcread;

	calc = 5 * adcread/256;

	lcd_pos(1,0);
	printf("U=%5u",calc);
    }
}

