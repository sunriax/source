/* G.Raf@2AAELI
 * Gruppe B1
 * uC3_d (DigitalAnalog_03) Messung
 * Erzeugung einer Sinusspannung
 *
 * Board: Megacard
 * Hardware: Megacard, Analog Disovery
 * Version: 1.0
 * Datum: 2017/02/09
 */

// Systemdefinitionen
#define F_CPU 12000000UL	// Systemtakt definieren
#define PI 3.1415926		// PI
#define	 HIGH 0xFF			// HIGH Byte
#define   LOW 0x00			// LOW Byte

// Portdefinitionen (Register)
#define DDROUT DDRB			// Output Register

// Portdefinitionen (I/O)
#define  OUTPUT PORTB		// Output Port

// Header Dateien (*.h)
#include <avr/io.h>			// Globale I/O definitionen einbinden
#include <avr/interrupt.h>	// Interrupt definitionen einbinden
#include <math.h>			// Mathematische Funktionen einbinden

volatile unsigned char sinus[360];	// Sinusarray mit 360 Werten anlegen
volatile unsigned int counter = 0;	// Z�hhlvariable anlegen

// ISR bei Timer0 �berlauf
ISR(TIMER0_OVF_vect)	{

// �berpr�fen ob Z�hler kleiner 360 ist
if(counter < 360)
	OCR0 = sinus[counter];		// OCR Register mit aktuelle Wert
								// aus Sinustabelle beschreiben
else
	counter = 0;				// Z�hler r�cksetzten
counter++;						// Z�hlvariable erh�hen

}

int main(void)
{
	// Erzeugen einer Sinustabelle mit 360 Werten
	for(unsigned int i=0; i < sizeof(sinus); i++)
	{
		sinus[i]=127+127*sin((M_PI*i)/180);	// Berechnungsformel zur Erzeugung der Sinustabelle
	}
	
	DDROUT = HIGH;	// PORTC als Ausgang definieren
	OUTPUT = LOW;	// Alle Ausg�nge auf LOW

	TCCR0 |= (1<<CS00);								// Vorteiler 1 Einstellen
	TCCR0 |= (1<<COM01);							// OC0 bei Vergleich setzen und bei Endwert r�cksetzen
	TCCR0 |= (1<<WGM01) | (1<<WGM00);				// Einstellung auf FAST PWM
	
	TIMSK |= (1<<TOIE0);							// Timer0 �berlauf Interrupt freigeben
	sei();											// Interrupt Individuell Freigeben

	while (1)
	{
	}
}
// Programmende
