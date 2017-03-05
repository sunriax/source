/* G.Raf@2AAELI
 * Interrupt_01
 * Interrupt INT1 durch Tastendruck PA0..3 aufrufen
 *
 * Board: Megacard
 * Version: 1.0
 */ 

//	#define F_CPU 12000000UL		// bereits in Project properities definiert
#include <avr/io.h>					// SFR Register und Bitdefinitionen
#include <avr/interrupt.h>
//	#include <util/delay.h>			// Delay-Funktionen

#define HIGH 0xFF		// HIGH Byte
#define LOW 0x00		// LOW Byte
#define NLOW 0x0F		// Low Nibble HIGH
#define NHIGH 0xF0		// High Nibble HIGH

#define DDRIN DDRA		// Input Register
#define DDRINT DDRD		// Interrupt Register
#define DDROUT DDRC		// Output Register
#define INPUT PINA		// Input Port
#define INTERRUPT PORTD	// Interrupt Port
#define PULLUP PORTA	// Pullup Port
#define OUTPUT PORTC	// Output Port

ISR(INT1_vect)			// Externer Interrupt INT1
{
	OUTPUT++;			// Ausgang um 1 erhöhen
}

int main(void)
{
	// Portkonfiguration
	DDRIN  &= NHIGH;	// DDRIN unteres Nibble auf (BIT 0-3) Eingang
	PULLUP |= NHIGH;	// PULLUP aus (BIT 0-3) (Pullup an Taster(S0/1/2/3 aktiv)

	OUTPUT  = LOW;		// LEDs an OUTPUT auf Eingang
	DDROUT  = HIGH;		// Datenrichtungsregister OUTPUT auf Ausgang

	DDRINT &= HIGH;		// DDRINT auf auf Eingang
	INTERRUPT |= 0x08;	// PULLUP ein (Bit 3) (Pullup an INT1)
	
	// Externe Interrupts Register
	MCUCR |= (1<<ISC11);	// Interrupt INT1 in MCUCR auf auslösen durch fallende Flanke setzen
	GICR  |= (1<<INT1);		// Interrupt INT1 freigeben

	sei();					// Interrupts Global Freigeben

    while (1) 
    {	
	//	if(INPUT & (1<<0))		// Abfrage ob Taster S0/1/2/3 nicht gedrückt
	//		OUTPUT = 0x0F;
    }
}

