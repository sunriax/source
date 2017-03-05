/* G.Raf@2AAELI
 * Gruppe B1
 * uC3_b (DigitalAnalog_02) Messung
 * Erzeugung einer Sägezahnspannung
 *
 * Board: Megacard
 * Hardware: Megacard, Analog Disovery
 * Version: 1.0
 * Datum: 2017/02/09
 */

// Systemdefinitionen
#define F_CPU 12000000UL	// Systemtakt definieren
#define	 HIGH 0xFF			// HIGH Byte
#define   LOW 0x00			// LOW Byte

// Portdefinitionen (Register)
#define DDROUT DDRB			// Output Register

// Portdefinitionen (I/O)
#define  OUTPUT PORTB		// Output Port

// Header Dateien (*.h)
#include <avr/io.h>			// Globale I/O definitionen einbinden
#include <avr/interrupt.h>	// Interrupt definitionen einbinden

// ISR bei Timer0 Überlauf
ISR(TIMER0_OVF_vect)	{
	OCR0++;					// OCR Wert um 1 erhöhen
}

int main(void)
{
    DDROUT = HIGH;		// PORTC als Ausgang definieren
	OUTPUT = LOW;		// Alle Ausgänge auf LOW

	TCCR0 |= (1<<CS00);					// Vorteiler 1 Einstellen
	TCCR0 |= (1<<COM01);				// OC0 bei Vergleich setzen und bei Endwert rücksetzen
	TCCR0 |= (1<<WGM01) | (1<<WGM00);	// Einstellung auf FAST PWM
	
	TIMSK |= (1<<TOIE0);				// Timer0 Überlauf Interrupt freigeben
	sei();								// Interrupts global freigeben

    while (1) 
    {
    }
}
// Programmende
