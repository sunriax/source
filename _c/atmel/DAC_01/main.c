/* G.Raf@2AAELI
 * Gruppe B1
 * uC3_a (DigitalAnalog_01) Messung
 * Ausgabe eines Rechtecksignals an PIN OC0
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

int main(void)
{
	DDROUT = HIGH;			// PORTC als Ausgang definieren
	OUTPUT = LOW;			// Alle Ausg�nge auf LOW

	TCCR0 |= (1<<CS00);					// Vorteiler 1 Einstellen
	TCCR0 |= (1<<COM01);				// OC0 bei Vergleich setzen und bei Endwert r�cksetzen
	TCCR0 |= (1<<WGM01) | (1<<WGM00);	// Einstellung auf FAST PWM

	OCR0 = 89;	// Tastverh�ltnis auf 35%

    while (1) 
    {
    }
}
//Programmende

