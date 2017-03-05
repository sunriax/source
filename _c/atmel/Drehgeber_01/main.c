/* G.Raf@2AAELI
 * uC1_b (Drehgeber_01) Duale Ausgabe
 * Inkrementaldrehgeberdaten  Interruptgesteurt Einlesen und Auswerten
 *
 * Board: Megacard
 * Hardware: Megacard, Drehgeber
 * Version: 1.0
 * Datum: 2016/12/15
 */

// Systemdefinitionen
#define F_CPU 12000000UL	// Systemtakt definieren
#define	 HIGH 0xFF			// HIGH Byte
#define   LOW 0x00			// LOW Byte

// Portdefinitionen (Register)
#define DDRINT DDRD			// Interrupt Register
#define DDROUT DDRC			// Output Register

// Portdefinitionen (I/O)
#define INTPUT  PIND		// Interupt Input Port
#define INTPULL PORTD		// Interrupt Port
#define  OUTPUT PORTC		// Output Port

// Pindefinitionen (I/O)
#define DIR PIND4			// Drehgeber richtungs Pin

// Header Dateien (*.h)
#include <avr/io.h>			// Globale I/O definitionen einbinden
#include <avr/interrupt.h>	// Interrupt definitionen einbinden

// Globale Variablen
//volatile static unsigned int pos;		// Positionsvariable 0-65535
										// (nicht benötigt da max. Schrittzahl 250)
volatile static unsigned char pos;		// Positionsvariable 0-255

// INT1 ISR für Winkelcodierer (CLK=1)
ISR(INT1_vect)
{
	if(INTPUT & (1<<DIR))				// Überprüfen ob Linksdrehung
		pos--;							// Hochzählen
	else if(!(INTPUT & (1<<DIR)))		// Überprüfen ob Rechtsdrehung
		pos++;							// Runterzählen
}

int main(void)
{
	// I/O Einstellungen
	DDRINT  = LOW;	// Richtungsregister (DDR*(D)) auf Eingang
	DDROUT  = HIGH;	// Richtungsregister (DDR*(C)) auf Ausgang
	INTPULL = HIGH;	// Pullup an (PORT*(D)) auf HIGH
	OUTPUT  = LOW;	// Ausgang (PORT(*C)) LOW, alle LEDs aus

	// Externe Interrupt Einstellungen
	MCUCR |= (1<<ISC11) | (1<<ISC10);	// Interrupt INT1 (auslösen durch steigende Flanke)
	GICR  |= (1<<INT1);					// Interrupt INT1 freigeben

	sei();					// Globale Interruptfreigabe

    while (1)
    {
		// Variable pos auf LCD Display ausgeben
		OUTPUT = pos;			// Ausgabe der Variable pos auf Ausgang(LEDs)
    }
}
// Programmende
