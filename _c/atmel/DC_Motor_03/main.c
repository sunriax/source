/* G.Raf@2AAELI
 * Gruppe B1
 * uC4_c (DC_Motor_03) Messung
 *
 * Board: Megacard
 * Hardware: Megacard, Analog Disovery
 * Version: 1.0
 * Datum: 2017/03/02
 */

/*	Anschlüsse Treiberkarte:
|
|	PC2 Input4 (Halbbrücke B rechts)
|	PC3 Enable B
|	PC4 Input3 (Halbbrücke B links)
|	PC5 Input2 (Halbbrücke A rechts)
|	PC6 Enable A
|	PC7 Input1 (Halbbrücke A links)
|
|	Anschluss:  1 A 2 3 B 4 X X
|	Port C:     7 6 5 4 3 2 1 0
*/

// Systemdefinitionen
#define F_CPU 12000000UL	// Systemtakt definieren
#define	 HIGH 0xFF			// HIGH Byte
#define   LOW 0x00			// LOW Byte

// Portdefinitionen (Register)
#define DDROUT DDRC			// Output Register
#define DDRTIM DDRB			// Timer Output Register
#define DDRADC DDRA			// ADC Eingabe

// Portdefinitionen (I/O)
#define OUTPUT PORTC		// Output Port
#define TIMOUT PORTB		// Timer Ausgabe Port

// Pindefinitionen (I/O)
#define ENA PC6
#define IN1 PC7
#define IN2 PC5

#define ENB PC3
#define IN3 PC4
#define IN4	PC2

#define PWM_FORWARD	0b01101100	//hier Bitmuster für "Vorwärtsbetrieb" eintragen!
#define PWM_REVERSE	0b11011000	//hier Bitmuster für "Rückwärtsbetrieb" eintragen!
#define PWM_STOP	0b01001000	//hier Bitmuster für "Bremsbetrieb" eintragen!

// Header Dateien (*.h)
#include <avr/io.h>			// Globale I/O definitionen einbinden
#include <avr/interrupt.h>	// Interrupt definitionen einbinden
#include <util/delay.h>

// ISR bei Timer0 Überlauf
ISR(TIMER0_OVF_vect)
{
	OUTPUT = PWM_FORWARD;
}

ISR(TIMER0_COMP_vect)
{
	if(OCR0 < 255)
		OUTPUT = PWM_STOP;
}

ISR(ADC_vect)
{
	OCR0 = ADCH;
}

// Hauptprogramm
int main(void)
{
	DDROUT = HIGH;		// Datenrichtungsregister auf Ausgang
	DDRTIM = HIGH;		// Datenrichtungsregister PortB auf Ausgang
	DDRADC = LOW;		// Datenrichttungsregister auf Eingang

	// Timer0 Interrupt Einstellungen
	TCCR0 |= (1<<CS01)  | (1<<CS00);	// Timer0 Vorteiler auf 1
	TCCR0 |= (1<<WGM01) | (1<<WGM00);	// FastPWM einstellen
	TCCR0 |= (1<<COM01);				// OC0 bei überlauf setzten bei Vergleich rücksetzen 

	TIMSK |= (1<<TOIE0) | (1<<OCIE0);	// Timer0 Overflow freigeben	
	OCR0 = 154;							// Tastverhältnis auf 60%

	// Analog Einstellungen
	ADMUX = (1<<REFS0) | (1<<ADLAR) | (1<<MUX2) | (1<<MUX0);
	ADCSRA = (1<<ADEN) | (1<<ADSC) | (1<<ADATE) | (1<<ADIE) | (1<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);

	sei();								// Interrupts global freigeben

    while (1) 
    {
	}
}
//Programmende






