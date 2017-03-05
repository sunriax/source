/*
 * Tasterprellen_01.c
 * Author: G�CHTER Raffael
 * Hardware: MEGACARD
 * Zweck: Detektion von Tasterereignissen
 *        OHNE Tasterentprellung
 */ 

#include <avr/io.h>
#define TASTER PA3	// zu �berpr�fender Taster  
                   
int main(void)
{
 
  DDRA=0x00;	// Datenrichtungsregister A auf Eingang setzen
  PORTA=0x0F;	// Pullups f�r Taster S0...3, unteres Nibble von PortA
  DDRC=0xFF;	// Datenrichtungsregister C auf Ausgang setzen
  PORTC=0x01;	// Led(0) ein, Rest aus (PORTC(0) auf HIGH (logisch 1) setzen)
  
  while(1) {								// Endlosschleife
    if (!(PINA & (1<<TASTER))) {			// Abfrage TASTER S0 (PA0) gedr�ckt wenn ja Code ausf�hren
	  PORTC = (PORTC<<1) | (PORTC>>7);		// LED-Status um 1 Bit nach links rotieren
		while(!(PINA & (1<<TASTER)));			// Schleife solange S0 gedr�ckt
	}  	 
  } 
} 