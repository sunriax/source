/*
 * SUNriaX Technology!
 * GÄCHTER Raffael
 * Version: 1.0
 *
 * Entwicklungskit: MEGACARD, STK500
 * Tasterabfrage mit Aktivierung eines Ausgangs
 */ 

//#define F_CPU 12000000UL

#define DDRIN DDRA		// Input Register
#define DDROUT DDRC		// Output Register
#define INPUT PINA		// Input Port
#define PULLUP PORTA	// Pullup Port
#define OUTPUT PORTC	// Output Port

#include <avr/io.h>
#include <util/delay.h>

int main(void)
{
	// ######### INIT ########
	// Register einstellen
	DDROUT |= 0xFF;		// DDRx auf HIGH (BIT 0-7) (Ausgang)
	DDRIN &= 0xF0;		// DDRx auf LOW  (BIT 0-3) (Eingang)

	// Pullup am Eingang
	PULLUP |= 0x0F;		// PORTX auf HIGH (BIT 0-3) (Pullup aktiv)
	
	// Ausgänge auf Low
	OUTPUT &= 0x00;		// PORTx auf LOW  (BIT 0-7) (Ausgang) 

	// ######### RUN #########
    while (1) 
    {
		if(!(INPUT & (0x01)))		// Abfrage ob Taster S0 gedrückt
			OUTPUT |= 0x01;			// PortX(0) HIGH = LED ein
		else if(!(INPUT & (0x02)))	// Abfrage ob Taster S1 gedrückt
			OUTPUT &= 0x00;			// PortX(0) LOW = LED aus
    }
}
