/* G.Raf@2AAELI
 * Gruppe B1
 * uC4_a (DC_Motor_02) Messung
 * Erzeugung einer Sinusspannung
 *
 * Board: Megacard
 * Hardware: Megacard, Analog Disovery
 * Version: 1.0
 * Datum: 2017/02/09
 */

/*	Anschl�sse Treiberkarte:
|
|	PC2 Input4 (Halbbr�cke B rechts)
|	PC3 Enable B
|	PC4 Input3 (Halbbr�cke B links)
|	PC5 Input2 (Halbbr�cke A rechts)
|	PC6 Enable A
|	PC7 Input1 (Halbbr�cke A links)
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

// Portdefinitionen (I/O)
#define  OUTPUT PORTC		// Output Port

// Pindefinitionen (I/O)
#define ENA PC6
#define IN1 PC7
#define IN2 PC5

#define ENB PC3
#define IN3 PC4
#define IN4	PC2

#define PWM_FORWARD //hier Bitmuster f�r "Vorw�rtsbetrieb" eintragen!

#define PWM_REVERSE //hier Bitmuster f�r "R�ckw�rtsbetrieb" eintragen!

#define PWM_STOP    //hier Bitmuster f�r "Bremsbetrieb" eintragen!

// Header Dateien (*.h)
#include <avr/io.h>			// Globale I/O definitionen einbinden
#include <avr/interrupt.h>	// Interrupt definitionen einbinden
#include <util/delay.h>

// ISR bei Timer0 �berlauf
//ISR(TIMER0_OVF_vect)
//{
//}

// Hauptprogramm
int main(void)
{
	DDROUT = HIGH;		// Datenrichtungsregister auf Ausgang

    while (1) 
    {
		OUTPUT = (1<<ENA) | (1<<IN1);	// Br�cke A Einschalten und PIN1 auf HIGH	
		_delay_us(600);
		OUTPUT &= ~(1<<IN1);			// Br�cke A IN1 auf LOW
		_delay_us(400);
	}
}
//Programmende






