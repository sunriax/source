/* G.Raf@2AAELI
 * uC1_e (Drehgeber_04) LCD Display
 * Inkrementaldrehgeberdaten Interruptgesteurrt Einlesen und auf LED Band ausgeben
 *
 * Board: Megacard
 * Hardware: Megacard, Display, Drehgeber
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
#define INTPUT  PIND		// Interrupt Input Register
#define INTPULL PORTD		// Interrupt Port
#define  OUTPUT PORTC		// Output Port

// Pindefinitionen (I/O)
#define DIR PIND4			// Drehgeber richtungs Pin

// Header Dateien (*.h)
#include <avr/io.h>			// Globale I/O definitionen einbinden
#include <avr/interrupt.h>	// Interrupt definitionen einbinden
#include "lcd_4.h"			// LCD definitionen einbinden

// Globale Variablen
//volatile static unsigned int pos;		// Positionsvariable 0-1024
volatile static unsigned char pos;		// Positionsvariable 0-255

static const unsigned char steps = 250;		// Schrittanzahl / Umdrehung
static unsigned char cycle;					// Umdrehungsvariable 0-8
static unsigned char pattern[] = {	0b00000001,
									0b00000011,
									0b00000111,
									0b00001111,
									0b00011111,
									0b00111111,
									0b01111111,
									0b11111111	};	// Ausgabemuster für PORTC (LEDs)

// INT1 ISR für Winkelcodierer (CLK=1)
ISR(INT1_vect)
{
	if(INTPUT & (1<<DIR))				// Überprüfen ob Linksdrehung
		pos--;							// Variable pos Hochzählen
	else if(!(INTPUT & (1<<DIR)))		// Überprüfen ob Rechtsdrehung
		pos++;							// Variable pos Runterzählen
}

int main(void)
{
	// I/O Einstellungen
	DDRINT  = LOW;	// Richtungsregister (DDR*(D)) auf Eingang
	DDROUT  = HIGH;	// Richtungsregister (DDR*(C)) auf Ausgang
	INTPULL = HIGH;	// Pullup an (PORT*(D)) auf HIGH
	OUTPUT  = LOW;	// Ausgang (PORT(*C)) LOW, alle LEDs aus

	// LCD Display Grundeinstellung
	lcd_init();				// LCD initialisieren
	lcd_pos(0,0);			// LCD Zeigerposition (Zeile/Spalte (0,0))
	printf("ENCODER");		// LCD Ausgabe (encoder)

	// Externe Interrupt Einstellungen
	MCUCR |= (1<<ISC11) | (1<<ISC10);	// Interrupt INT1 (auslösen durch steigende Flanke)
	GICR  |= (1<<INT1);					// Interrupt INT1 freigeben

	sei();					// Globale Interruptfreigabe

    while (1)
    {
		
		if(pos == (steps - 1))		// Wenn Posistion gleich 250 Schritte (0-249)
		{
			pos = 0;				// Position auf 0 rücksetzten

			if(cycle < 8)			// Wenn Zyklus kleiner 8
				cycle++;			// Zyklus um 1 erhöhen
			else
				pos = steps - 2;	// Fehler = 1 da 249 nicht möglich!
		}
		else if(pos > (steps - 1))	// Wenn Position größer 250 Schritte (0-249)
		{
			pos = steps - 2;		// Posistion auf 248 setzen

			if(cycle > 0)			// Wenn Zyklus > 0 Zyklus erniedrigen			
				cycle--;			// Zyklusvariable um 1 erniedrigen
			else
				pos = 0;			// Wenn Zyklus auf 0 und mehr als eine ganze
									// Umdrehung durchgeführt posistion auf 0
		}
		
		switch(cycle)				// LED Muster Fallausgabe auf PORTC (LEDs)
		{
			case 1	:	OUTPUT = pattern[0];	break;		// 1 Umdrehung
			case 2	:	OUTPUT = pattern[1];	break;		// 2 Umdrehung
			case 3	:	OUTPUT = pattern[2];	break;		// 3 Umdrehung
			case 4	:	OUTPUT = pattern[3];	break;		// 4 Umdrehung
			case 5	:	OUTPUT = pattern[4];	break;		// 5 Umdrehung
			case 6	:	OUTPUT = pattern[5];	break;		// 6 Umdrehung
			case 7	:	OUTPUT = pattern[6];	break;		// 7 Umdrehung
			case 8	:	OUTPUT = pattern[7];	break;		// 8 Umdrehung
			default	:	OUTPUT = LOW;			break;		// Anfangsbedingung
		}
    }
}
// Programmende

