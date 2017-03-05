/*
 * PWM_01.c
 * G.Raf@2AAELI
 * PWM_01
 * Ausgabe der Frequenz über Lautsprecher/LED
 *
 * Board: Megacard
 * Version: 1.0
 */ 

// Systemdefinitionen
//#define F_CPU 12000000UL		// bereits in Project properities definiert
#include <avr/io.h>				// Globale I/O konfiguration

// Generelle Definnitionen
#define HIGH 0xFF				// HIGH Byte
#define LOW 0x00				// LOW Byte

// Portkonfiguration
#define DDRIN  DDRA		// Datenrichtungsregister für PortA
#define DDRTIM DDRB		// Datenrichtungsregister für PortB
#define DDROUT DDRC		// Datenrichtungsregister für PortC
#define INPUT  PINA		// Input Pin
#define INPULL PORTA	// Pullup für PinA
#define OUTPUT PORTC	// Output Port


int main(void)
{
	DDRTIM = (1<<PB3);	// PORTx auf Ausgang (OC0 Pin auf Ausgang)
	DDROUT = HIGH;		// PORTx auf Ausgang (LED Port auf Ausgang)
	DDRIN  = LOW;		// PORTx auf Eingang (Taster Port auf Eingang)

	INPULL = HIGH;		// PORTx (Tasterport) Pullups aktiv

	TCCR0 = (1<<WGM00) | (1<<COM01);	// Timer Betriebsart Phasenrichtig PWM;
	OCR0 = 128;							// Tastverhältnis auf 50% Setzen

    while (1) 
    {
		if(!(INPUT & (1<<PA0)))		// Prüfen ob Taster S0 gedrückt
		{
			TCCR0 |= (1<<CS01);						// Zähler mit Teilungsfaktor 8 (2941 Hz) Starten
			TCCR0 &= ~((1<<CS00) | (1<<CS02));		// Timer Register Position CS00/CS02 mit logisch 0 beschreiben
													// 12000000 / (8 * 255 * 2) = 2941,17 
			
			OUTPUT |= (1<<PC7);						// Wenn Teilungsfaktor 8 aktiv LED 7 HIGH
			OUTPUT &= ~((1<<PC6) | (1<<PC5));		// Wenn Teilungsfaktor 8 aktiv LED 5/6 LOW
			/*	Mit Analog Discovery gemessen
				T: 2,94us ~2,94 kHz				*/
		}
		else
		{
			if(!(INPUT & (1<<PA1)))	// Prüfen ob Taster S1 gedrückt
			{
				TCCR0 |= (1<<CS02);					// Zähler mit Teilungsfaktor 256 (92 Hz) Starten
				TCCR0 &= ~((1<<CS00) | (1<<CS01));	// Timer Register Position CS00/CS01 mit logisch 0 beschreiben
													// 12000000 / (256 * 255 * 2) = 91,55
				
				OUTPUT |= (1<<PC6);					// Wenn Teilungsfaktor 256 aktiv LED 6 HIGH
				OUTPUT &= ~((1<<PC7) | (1<<PC5));	// Wenn Teilungsfaktor 256 aktiv LED 5/7 LOW
			/*	Mit Analog Discovery gemessen
				T: 10,89ms ~91,91 Hz ~ 92 Hz				*/
			}
			else									// Default bei Drücken von keiner Taste
			{
				TCCR0 |= (1<<CS01) | (1<<CS00);		// Zähler mit Teilungsfaktor 64 (368 Hz) Starten (default)
				TCCR0 &= ~(1<<CS02);				// Timer Register Position CS02 mit logisch 0 beschreiben
													// 12000000 / (64 * 255 * 2) = 367,64
													
				OUTPUT |= (1<<PC5);					// Wenn Teilungsfaktor 64 aktiv LED 5 HIGH
				OUTPUT &= ~((1<<PC7) | (1<<PC6));	// Wenn Teilungsfaktor 64 aktiv LED 6/7 LOW
			/*	Mit Analog Discovery gemessen
				T: 2,72ms ~367,66 Hz ~ 368 Hz				*/
			}
			
		}
		
		if(!(INPUT & (1<<PA2)))		// Prüfen ob Taster S2 gedrückt
		{
		OCR0 = 26;					// Tastverhältnis auf 10% ((10/256) * 100%) = 26
		/*	Mit Analog Discovery gemessen
			T: 2,72ms (280us HIGH) ~367,66 Hz		10,29% Pulsweite				*/
		}
		else
		{
			if(!(INPUT & (1<<PA3)))	// Prüfen ob Taster S3 gedrückt
			{
				OCR0 = 230;			// Tastverhältnis auf 10% ((90/256) * 100%) = 230
			/*	Mit Analog Discovery gemessen
				T: 2,72ms (2,45ms HIGH) ~367,66 Hz	90,07% Pulsweite		*/
			}
			else
			{
				OCR0 = 128;			// Tastverhältnis auf 50% ((50/256) * 100%) = 128
			/*	Mit Analog Discovery gemessen
				T: 2,72ms (1,37ms HIGH) ~367,66 Hz	50,37% Pulsweite		*/
			}
		}
    }
}

