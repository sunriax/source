/* G.Raf@2AAELI
 * Interrupt_02
 * Polling von INT1 der durch Tastendruck PA0..3 aufgerufen
 *
 * Board: Megacard
 * Version: 1.0
 */ 

//#define F_CPU 12000000UL		// bereits in Project properities definiert
#include <avr/io.h>				// Globale I/O konfiguration

#define HIGH 0xFF				// HIGH Byte
#define LOW 0x00				// LOW Byte

#define DDRIN  DDRA		// Input Register
#define DDRINT DDRD		// Interrupt Register
#define DDROUT DDRC		// Output Register

#define INPUT  PINA		// Input Port
#define INTPULL PORTD	// Interrupt Port
#define OUTPUT PORTC	// Output Port

int main(void)
{
	// Register Einstellungen
	DDRIN = LOW;	// Datenrichtungsregister auf Eingang (PORTA)
	DDRINT  = LOW;	// Interruptregister auf Eingang (PORTD)
	DDROUT = HIGH;	// Datenrichtungsregister auf Ausgang (PORTC)

	// I/O Einstellungen
	INTPULL = HIGH;	// Pullups an Interrupteingang (PORTD) aktiv
	OUTPUT = LOW;	// Alles LEDs an PORTC auf LOW

	// Externe Interrupts Register
	MCUCR |= (1<<ISC11);	// Interrupt INT1 in MCUCR auf auslösen durch fallende Flanke setzen
	GICR  |= (1<<INT1);		// Interrupt INT1 freigeben

	// Globale freigabe der Interrupts wird
	// nicht benötigt da ISR nicht ausgeführt wird!
	// sei();					// Interrupts Global Freigeben

    while (1) 
    {
		if(GIFR & (1<<INTF1))	// Überprüfen ob INTERRUPT Flag INTF1 gesetzt
		{
			OUTPUT++;			// Ausgang (PORTC) um 1 erhöhen
			GIFR = (1<<INTF1);	// INT1 Flag rücksetzen (Rücksetzen erfolgt durch schreiben von HIGH auf GIFR)
		}
	}
}

