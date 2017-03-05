/* G.Raf@2AAELI
 * Gruppe B1
 * uC3_d (DigitalAnalog_03) Messung
 * Erzeugung einer Sinus
 *
 * Board: Megacard
 * Hardware: Megacard, Analog Disovery
 * Version: 1.0
 * Datum: 2017/02/09
 */

// Systemdefinitionen
#define F_CPU 12000000UL	// Systemtakt definieren
#define PI 3.1415926		// PI
#define	 HIGH 0xFF			// HIGH Byte
#define   LOW 0x00			// LOW Byte

// Portdefinitionen (Register)
#define DDROUT DDRB			// Output Register

// Portdefinitionen (I/O)
#define  OUTPUT PORTB		// Output Port

// Header Dateien (*.h)
#include <avr/io.h>			// Globale I/O definitionen einbinden
#include <avr/interrupt.h>	// Interrupt definitionen einbinden
#include <math.h>			// Mathematische Funktionen einbinden

static unsigned char sinus[200];
volatile unsigned char counter = 0, counter1 = 0; rev_count = sizeof(sinus);

ISR(TIMER0_OVF_vect)	{
counter++;


if(counter < 100)
{
	OCR0 = sin(PI/(2*counter)) * 255;
}
else if(counter < 200)
{
	counter1++;
	OCR0 = sin(PI/(2*(100-counter1))) * 255;
}
else
{
counter = 0;
counter1 = 0;
}



}

int main(void)
{

    DDROUT = 0xFF;	// PORTC als Ausgang definieren
    OUTPUT = 0x00;	// Alle Ausgänge auf LOW

    TCCR0 |= (1<<CS00);					// Vorteiler 1 Einstellen
    TCCR0 |= (1<<COM01);				// OC0 bei Vergleich setzen und bei Endwert rücksetzen
    TCCR0 |= (1<<WGM01) | (1<<WGM00);	// Einstellung auf FAST PWM
    
    TIMSK |= (1<<OCIE0) | (1<<TOIE0);
	sei();

	while (1)
	{
		//OCR0 = sinus[counter];
	}
}

