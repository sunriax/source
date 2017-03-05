/* G.Raf@2AAELI
 * uC1_c (Drehgeber_02) LCD Display
 * Inkrementaldrehgeberdaten Interruptgesteuert Einlesen und Auswerten (LCD Display)
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
#define DDRINT DDRD			// Interrupt Input Register
#define DDROUT DDRC			// Output Register

// Portdefinitionen (I/O)
#define INTPUT  PIND
#define INTPULL PORTD		// Interrupt Port
#define  OUTPUT PORTC		// Output Port

// Pindefinitionen (I/O)
#define DIR PIND4

// Header Dateien (*.h)
#include <avr/io.h>			// Globale I/O definitionen einbinden
#include <avr/interrupt.h>	// Interrupt definitionen einbinden
#include "lcd_4.h"			// LCD definitionen einbinden

// Globale Variablen
//volatile static unsigned int pos;		// Positionsvariable 0-65535
										// (nicht benötigt da max. Schrittzahl 250)
										
volatile static unsigned int pos;		// Positionsvariable 0-255
volatile static unsigned char disp;		// Displayvariable True = LCD aktualisieren

// INT1 ISR für Winkelcodierer (CLK=1)
ISR(INT1_vect)
{
	disp = 0xFF;
	
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
		if(disp & (0xFF))	// Überprüfen ob Displayaktualiserung notwendig (disp == 0xFF)
		{
			// Variable pos auf LCD Display ausgeben
			lcd_pos(1,0);			// LCD Zeigerposition (Zeile/Spalte (1,0))
			printf("C=%5u",pos);	// LCD Ausgabe (Variable pos(int))
			OUTPUT = pos / 256;		// Ausgabe der Variable pos(int)/256=unsigned char auf Ausgang(LEDs)
			
			disp = 0x00;			// Display Variable rücksetzen
		}
    }
}
// Programmende

