/*
 * Tasterprellen_02.c
 * Author: GÄCHTER Raffael
 * Hardware: MEGACARD
 * Zweck: Detektion von Tasterereignissen
 *        OHNE Tasterentprellung
 */ 

#define F_CPU 12000000UL	// Taktfrequenz
#define TASTER PA3			// zu überprüfender Taster 
#define WAIT 10				// Zeit die gewartet werden soll			

#include <avr/io.h>
#include <util/delay.h>
 
                   
int main(void)
{
 
  DDRA=0x00;	// Datenrichtungsregister A auf Eingang setzen
  PORTA=0x0F;	// Pullups für Taster S0...3, unteres Nibble von PortA
  DDRC=0xFF;	// Datenrichtungsregister C auf Ausgang setzen
  PORTC=0x01;	// Led(0) ein, Rest aus (PORTC(0) auf HIGH (logisch 1) setzen)
  
  while(1) {								// Endlosschleife
    if (!(PINA & (1<<TASTER))) {			// Abfrage TASTER S0 (PA0) gedrückt wenn ja Code ausführen
		PORTC = (PORTC<<1) | (PORTC>>7);	// LED-Status um 1 Bit nach links rotieren
		_delay_ms(WAIT);						// Unterprogrammaufruf (20ms verzögert)
			while(!(PINA & (1<<TASTER)));	// Schleife solange S0 gedrückt
		_delay_ms(WAIT);						// Unterprogrammaufruf (20ms verzögert)
	}  	 
  } 
} 