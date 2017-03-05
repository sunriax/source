/* G.Raf@2AAELI
 * UART_02
 * UART Kommunikation mit Fehlerauswertung
 *
 * Board: Megacard
 * Version: 1.0
 */ 

#define F_CPU 12000000UL				// Systemtakt
#define DOUBLESPEED						// Abtastungs aktivieren

#ifdef DOUBLESPEED						// Abtastrate Einstellen
	#define U2XS 8						// Doppelte Baudrate (Standardeinstellung)
#else
	#define U2XS 16						// langsammere Baudrate
#endif

#define BAUD 19200UL					// Übertragungsgeschwindigkeit
#define UBRR (F_CPU/(U2XS*BAUD)) - 1	// Registerinhalt für UBRR berechnen

#include <avr/io.h>						// SFR Register und Bitdefinitionen
#include <avr/interrupt.h>				// Interrupt Definitionen einbinden

#define HIGH 0xFF						// HIGH Byte
#define LOW 0x00						// LOW Byte

// Timer0 Einstellungen
#define DDROUT DDRC						// Output Register
#define DDRIN  DDRA						// Input Register
#define OUTPUT PORTC					// Output Port
#define INPUT  PINA						// Input Pin
#define INPULL PORTA					// Pullups an PORTA

// Variablendeklaration
volatile unsigned char FAULT;

// UART Empangsroutine
ISR(USART_RXC_vect)
{
	FAULT = 0x00;						// Fehlervariable rücksetzten
	
	if(UCSRA & (1<<FE))					// Wenn Rahmenfehler vorhanden
		FAULT = 0b10000000;				// Rahmenfehler setzten
	if(UCSRA & (1<<PE))					// Wenn Paritätsfehler vorhandne
		FAULT |= FAULT | 0b01000000;	// Paritätsfehlerbit setzten

	PORTC = (UDR & 0x0F) | FAULT;		// Ausgabe auf PORTC
}

// UART Senderoutine
ISR(USART_UDRE_vect)
{
	UDR = 0x0F & ~(PINA);				// Tasterzustände in Übertragungsregister schreiben
}

// UART initialisieren
void uart_init(unsigned int setubrr)	{
	//unsigned int setubrr = UBRR;

	UBRRH  = (unsigned char)(setubrr>>8);		// Einstellung der Baudrate (Register High)
	UBRRL |= (unsigned char)setubrr;			// Einstellung der Baudrate (Register Low)

#ifndef DOUBLESPEED
	UCSRA &= ~(1<<U2X);							// Double Speed Mode ausschalten
#endif

	UCSRC  = (1<<URSEL) | (1<<UPM1) | (1<<USBS);				// Setzen der Stoppbits & Paritätsprüfung auf Even
	UCSRB |= (1<<RXCIE) | (1<<UDRIE) | (1<<RXEN) | (1<<TXEN);	// Receiver Intrerrpt Freigeben und Transmitter und Receivcer einschalten
}

int main(void)
{	
	DDRIN = LOW;						// Datenrichtungsregister auf Eingang
	INPULL = 0x0F;						// Pullup-Widerstände an Eingang aktivieren

	DDROUT = HIGH;						// Datenrichtungsregister auf Ausgang
	OUTPUT = LOW;						// PORTC Alle LEDs aus

	uart_init((unsigned int)(UBRR));	// UART Initialisierungsroutine aufrufen
	sei();

    while (1) 
    {
	}
}

