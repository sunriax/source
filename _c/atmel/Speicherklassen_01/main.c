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
                           // => Zugriff au�erhalb der Programmkontrolle (ISR, Hardware) m�glich!

void test (void) // Deklaration der Funktion "test()"
{ // Beginn Block "test"
  static unsigned char x; // Z�hlvariable, lokal in Funktion test() g�ltig, 
  //unsigned char x=0; // Z�hlvariable, lokal in Funktion test() g�ltig, 
                        // statisch im SRAM angelegt, Startwert Null
                        // Inhalt von x bleibt nach Ausstieg aus test() erhalten

  a_global=0xee;   // globale Variable modifizieren und in SRAM ablegen
  PORTB = ++x;	   // Z�hlvariable inkrementieren und in SRAM ablegen (x lokal vereinbart!)
                   // Neuen Wert von x zus�tzlich in SFR "PORTB" ablegen
} // Ende Block "test"

int main(void)	// Beginn Block "main" 
{ 
  while(1) // Beginn Block "Arbeitschleife"
  { 
	
	a_global=1; // globale Variable �ndern
	
	test();		// Funktionsaufruf
	            // a_global ver�ndert (neuer Wert: 0xee); 
	            // globaler Wert von x unver�ndert
	
	x = a_global; // globale variable x:=0xee
	
	if (x == 0xee) PORTD=0x11; 
	else PORTD = 0xFF; // SPEICHERTEST f�r SRAM-Zellen "x" und "a_global"
		               // if ohne volatile x w�rde vom compiler wegoptimiert werden!!
	                   // Ergebnis wird �ber PORTD signalisiert
				       // 0x11: Speicherzelle ok, 0xFF:Speicherfehler
	
  } // Ende Block "Arbeitschleife"
} // Ende Block "main"
