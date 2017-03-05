/*
 * Speicherklassen_01.c
 *
 * Created: 17.11.2016 11:18:15
 *  Author: Harry
 *
 * Zweck: Untersuchung von lokalen u. globalen Variablen sowie
 *        unterschiedlicher Speicherklassen mittels AVR-Simulator
 * Einstellungen: Project Properties - Optimization "None (-O0)"
 *                Solution Explorer: "Set as StartUp Project"
 */ 

#include <avr/io.h>

unsigned char a_global;    // global, statisch im SRAM angelegt, Startwert=0 (default)
//volatile unsigned char x;  // global, statisch im SRAM angelegt, Startwert=0 (default)
unsigned char x;  // global, statisch im SRAM angelegt, Startwert=0 (default)
                           // wird vom Compiler nicht wegoptimiert 
                           // => Zugriff außerhalb der Programmkontrolle (ISR, Hardware) möglich!

void test (void) // Deklaration der Funktion "test()"
{ // Beginn Block "test"
  static unsigned char x; // Zählvariable, lokal in Funktion test() gültig, 
  //unsigned char x=0; // Zählvariable, lokal in Funktion test() gültig, 
                        // statisch im SRAM angelegt, Startwert Null
                        // Inhalt von x bleibt nach Ausstieg aus test() erhalten

  a_global=0xee;   // globale Variable modifizieren und in SRAM ablegen
  PORTB = ++x;	   // Zählvariable inkrementieren und in SRAM ablegen (x lokal vereinbart!)
                   // Neuen Wert von x zusätzlich in SFR "PORTB" ablegen
} // Ende Block "test"

int main(void)	// Beginn Block "main" 
{ 
  while(1) // Beginn Block "Arbeitschleife"
  { 
	
	a_global=1; // globale Variable ändern
	
	test();		// Funktionsaufruf
	            // a_global verändert (neuer Wert: 0xee); 
	            // globaler Wert von x unverändert
	
	x = a_global; // globale variable x:=0xee
	
	if (x == 0xee) PORTD=0x11; 
	else PORTD = 0xFF; // SPEICHERTEST für SRAM-Zellen "x" und "a_global"
		               // if ohne volatile x würde vom compiler wegoptimiert werden!!
	                   // Ergebnis wird über PORTD signalisiert
				       // 0x11: Speicherzelle ok, 0xFF:Speicherfehler
	
  } // Ende Block "Arbeitschleife"
} // Ende Block "main"
