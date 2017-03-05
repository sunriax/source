/*
 * Bitoperationen.c
 * Created: 13.10.2016 14:00:31
 * Author: Harry
 * Zweck: Demonstration des AVR-Simulators
 * Einstellungen: Project Properties - Optimization "None (-O0)"
 *                Solution Explorer: "Set as StartUp Project"
 */ 

#include <avr/io.h> //I/O-Bibliothek einbinden

volatile unsigned char x,y; //globale Variablen; Speicherklasse "volatile"
volatile signed char z=-10; // (in SRAM angelegt, nicht wegoptimierbar)
                          
int main(void) {
    // Vorbelegung der Variablenwerte (Defaultwerte=0)
	DDRA = 0xF0; //SFR-Register
	x=0xAB;
	y=0x01;
	
	while(1) { //Endlosschleife
    DDRA ^= 0xff;   // 1-komplement (Alle Pinrichtungen von PortA umkehren)
	x ^= 0xff;		// 1-komplement (bitweises invertieren)
	y <<= 1;		// 1 bit logisch nach links schieben
	z >>= 1;        // 1 bit arithmetisch nach rechts schieben
	} 
}