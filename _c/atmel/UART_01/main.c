/* G.Raf@2AAELI
 * Timer_01
 * Interrupt Timer0 durch Überlauf
 *
 * Board: Megacard
 * Version: 1.0
 */ 

//	#define F_CPU 12000000UL		// bereits in Project properities definiert
#define F_CPU 12000000UL

//#define SAMPLE

#ifdef SAMPLE						// Abtastrate Einstellen
	#define U2X 8					// Doppelte Baudrate (Standardeinstellung)
#else
	#define U2X 16					// langsammere Baudrate
#endif



#define BAUD 9600UL						// Übertragungsgeschwindigkeit
#define UBRR (F_CPU/(U2X*BAUD)) - 1U	// Registerinhalt für UBRR berechnen

#include <avr/io.h>						// SFR Register und Bitdefinitionen
#include <avr/interrupt.h>
#include <util/delay.h>					// Delay-Funktionen

#define HIGH 0xFF						// HIGH Byte
#define LOW 0x00						// LOW Byte

// Timer0 Einstellungen
#define DDROUT DDRC						// Output Register
#define DDRIN  DDRA						// Input Register
#define OUTPUT PORTC					// Output Port
#define INPUT  PINA						// Input Pin
#define INPULL PORTA					// Pullups an PORTA


// UART initialisieren
void uart_init()	{
	unsigned int setubrr = UBRR;
	
	UCSRC &= ~(1<<URSEL);
	UBRRH = (unsigned char)(setubrr>>8);	// Einstellung der Baudrate (Register High)
	UBRRL = (unsigned char)(setubrr);		// Einstellung der Baudrate (Register Low)

#ifndef SAMPLE
	UCSRA &= ~(1<<U2X);						// Double Speed Mode ausschalten
#endif

	UCSRC  = (1<<URSEL) | (1<<USBS);		// Setzen der Stoppbits
	UCSRC |= (1<<UCSZ1) | (1<<UCSZ0);		// Setzen der Datenbitanzahl
	UCSRB  = (1<<RXCIE);					// Receiver Intrerrpt Freigeben
	UCSRB |= (1<<RXEN) | (1<<TXEN);			// Transmitter und Receivcer einschalten
}

// UART Routine Daten senden
void uart_putchar(unsigned char data)	{
	while(!(UCSRA & (1<<UDRE)));			// Warten bis Empfangsbuffer leer
		UDR = data;											// Schreiben der Daten in Sendebuffer
}

// UART Routine Daten empfangen
void uart_getchar(unsigned char *address)	{
	if(UCSRA & (1<<RXC))	{				// Überprüfen ob Daten in Empfangsbuffer
		*address = UDR;						// Daten auf Addresse des adress pointers schreiben
	}
}

int main(void)
{	
	unsigned char out;					// Ausgabevariable für Empfangenes Zeichen
	
	DDRIN = LOW;						// Datenrichtungsregister auf Eingang
	INPULL = 0x0F;						// Pullup-Widerstände an Eingang aktivieren

	DDROUT = HIGH;						// Datenrichtungsregister auf Ausgang
	OUTPUT = LOW;						// PORTC Alle LEDs aus

	uart_init(UBRR);					// UART Initialisierungsroutine aufrufen

    while (1) 
    {
		uart_getchar(&out);				// UART Zeichen empfangen
		uart_putchar(0x0F & ~(INPUT));	// UART Zeichen senden
		OUTPUT = out;					// Empfangenes Zeichen auf PORTC ausgeben
	}
}

