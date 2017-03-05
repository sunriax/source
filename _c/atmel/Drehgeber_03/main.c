/* G.Raf@2AAELI
 * uC1_c (Drehgeber_01) LCD Display
 * Inkrementaldrehgeberdaten softwarem‰ﬂige Flankenerkennung Einlesen und Auswerten
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
#define INPUT  PIND			// Input Pin
#define INPULL PORTD		// Input Pullup Port
#define OUTPUT PORTC		// Output Port

// Pindefinitionen (I/O)
#define CLK PIND3			// Drehgeber Taktsignal Pin
#define DIR PIND4			// Drehgeber richtungs Pin

// Header Dateien (*.h)
#include <avr/io.h>			// Globale I/O definitionen einbinden
#include <avr/interrupt.h>	// Interrupt definitionen einbinden
#include "lcd_4.h"			// LCD definitionen einbinden

// Globale Variablen
static unsigned char pos;		// Positionsvariable 0-255
static unsigned char disp;		// Displayvariable True = LCD aktualisieren
static unsigned char run;		// Flankenerkennung

int main(void)
{
	// I/O Einstellungen
	DDRINT  = LOW;	// Richtungsregister (DDR*(D)) auf Eingang
	DDROUT  = HIGH;	// Richtungsregister (DDR*(C)) auf Ausgang
	INPULL = HIGH;	// Pullup an (PORT*(D)) auf HIGH
	OUTPUT  = LOW;	// Ausgang (PORT(*C)) LOW, alle LEDs aus

	// LCD Display Grundeinstellung
	lcd_init();				// LCD initialisieren
	lcd_pos(0,0);			// LCD Zeigerposition (Zeile/Spalte (0,0))
	printf("ENCODER");		// LCD Ausgabe (encoder)

    while (1)
    {
		if((INPUT & (1<<CLK)) && (run == 1))			// ‹berpr¸fen ob CLK gesetzt und Flanke bereits durchlaufen
		{
			disp = 0xFF;								// Displayausgabe aktivieren
					
			if(INPUT & (1<<DIR))						// ‹berpr¸fen ob Linksdrehung
				pos--;									// Hochz‰hlen
			else if(!(INPUT & (1<<DIR)))				// ‹berpr¸fen ob Rechtsdrehung
				pos++;									// Runterz‰hlen
			
			run = 0;									// Flankendurchlauf erfolgt
		}
		else if((!(INPUT & (1<<CLK))) && (run == 0))	// ‹berpr¸fen ob CLK nicht gesetzt und Flanke bereits durchlaufen
		{
			run = 1;									// Flankendurchlauf r¸cksetzen
		}
		
		if(disp & (0xFF))	// ‹berpr¸fen ob Displayaktualiserung notwendig (disp == 0xFF)
		{
			// Variable pos auf LCD Display ausgeben
			lcd_pos(1,0);			// LCD Zeigerposition (Zeile/Spalte (1,0))
			printf("C=%5u",pos);	// LCD Ausgabe (Variable pos(int))
			OUTPUT = pos;		// Ausgabe der Variable pos(int)/256=unsigned char auf Ausgang(LEDs)
			
			disp = 0x00;			// Display Variable r¸cksetzen
		}
    }
}
// Programmende

