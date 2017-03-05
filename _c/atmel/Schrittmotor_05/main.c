/* G.Raf@2AAELI
 * uC2_f (Schrittmotor_05) LCD Display
 * Schrittmotor durch Softwaredelay anstueren Halb/Vollschrittmodus
 *
 * Board: Megacard
 * Hardware: Megacard, Display, Drehgeber
 * Version: 1.0
 * Datum: 2017/01/19
 */

// Systemdefinitionen
#define F_CPU 12000000UL	// Systemtakt definieren
#define	 HIGH 0xFF			// HIGH Byte
#define   LOW 0x00			// LOW Byte

// Portdefinitionen (Register)
#define DDRIN  DDRA			// Input Register
#define DDRINT DDRD			// Interrupt Register
#define DDROUT DDRC			// Output Register

// Portdefinitionen (I/O)
#define INPUT   PINA		// Input Pin Register
#define INPULL	PORTA		// Input Port
#define INTPUT  PIND		// Interrupt Input Register
#define INTPULL PORTD		// Interrupt Port
#define  OUTPUT PORTC		// Output Port

// Pindefinitionen (I/O)
#define S0 PINA0			// Taster S0
#define S1 PINA1			// Taster S1
#define S2 PINA2			// Taster S2
#define S3 PINA3			// Taster S3

// Schrittmotordefinitionen
//#define HALBSCHRITTE		// Zur Halbschrittansteuerung setzten

#define ENA PC6				// Enable A Pin
#define ENB	PC3				// Enable B Pin

#define IN1 PC7				// Schrittmotor Channel 1
#define IN2 PC5				// Schrittmotor Channel 2
#define IN3 PC4				// Schrittmotor Channel 3
#define IN4	PC2				// Schrittmotor Channel 4

// Anschlussdefinition
// Anschluss:  1 A 2 3 B 4 X X
// Port C:     7 6 5 4 3 2 1 0

// Präprozessoranweisungen
#define _IN(INBIT) (!(INPUT & (1<<INBIT)))		// INPUT Bit Überprüfung
#define _NIN(NINBIT) (~(INPUT & (1<<NINBIT)))	// INPUT Bit Überprüfung

// Header Dateien (*.h)
#include <avr/io.h>			// Globale I/O definitionen/funktionen einbinden
#include <avr/interrupt.h>	// Interrupt definitionen/funktionen einbinden
#include <util/delay.h>		// Delay definitionen/funktionen einbinden
#include "lcd_4.h"			// LCD definitionen einbinden

// Globale Variablen
const unsigned char steps = 200;			// Schritte pro Umdrehung
volatile unsigned int sw_count = 0;			// Softwarezähler
volatile unsigned char position_fwd = 0;	// Pattern Position
volatile unsigned char position_rev = 0;	// Pattern Position
volatile unsigned char speed = 18;			// Geschwindigkeit

#ifdef HALBSCHRITTE  // Präprozessoranweisung wenn Halbschritte definiert
	unsigned char pattern[] =	{	// Muster zur Ansteuerung der Halbschritte
								0b11011000,
								0b11001000,
								0b11001100,
								0b01001100,
								0b01101100,
								0b01101000,
								0b01111000,
								0b01011000
								};
#else
	unsigned char pattern[] =	{	// Muster zur Ansteuerung der Vollschritte (doppelt vorhanden)
								0b11001000,
								0b01011000,
								0b01101000,
								0b01001100,
								0b11001000,
								0b01011000,
								0b01101000,
								0b01001100
								};
#endif


ISR(TIMER0_OVF_vect)
{
	sw_count++;
	
	if(sw_count == speed)
	{	
		if(position_rev == 0)
			position_rev = 8;
		
		position_rev--;
		position_fwd++;
		sw_count = 0;

		if(position_fwd > 7)
			position_fwd = 0;
	}
}


int main(void)
{
	// I/O Einstellungen
	DDRIN   = LOW;	// Richtungsregister (DDR*(A)) auf Eingang
	DDROUT  = HIGH;	// Richtungsregister (DDR*(C)) auf Ausgang
	INPULL  = HIGH;	// Pullup an (PORT*(A)) auf HIGH
	OUTPUT  = LOW;	// Ausgang (PORT(*C)) LOW, Schrittmotor aus

	// LCD Display Grundeinstellung
	lcd_init();				// LCD initialisieren
	lcd_pos(0,0);			// LCD Zeigerposition (Zeile/Spalte (0,0))
	printf("uc2_e");		// LCD Ausgabe (Stepper)

	// Interrupt Einstellungen
	TCCR0 |= (1<<CS01);
	TIMSK |= (1<<TOIE0);

	sei();					// Globale Interruptfreigabe

    while (1)
    {
		
		if (_IN(S0) && _NIN(S1)) 	// Bei Taster S0 gedrück läuft Motor im Linkslauf
		{
			_delay_ms(500);
			if(speed < 18)
			{
				speed++;
			}
		}
		else if (_IN(S1) && _NIN(S0))	// Bei Taster S1 gedrück läuft Motor im Rechtslauf
		{
			_delay_ms(500);
			if(speed > 2)
			{
				speed--;
			}
		}
		else
		{
			OUTPUT = pattern[position_fwd];
		}
    }
}
// Programmende

