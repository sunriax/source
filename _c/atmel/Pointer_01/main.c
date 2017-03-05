/*
 * Pointer_01.c
 *
 * Created: 20.11.2016 17:54:56
 * Author: Harry
 * Zweck: Simulation des Pointerverhaltens mit AVR-Simulator
 * Einstellungen: Compiler Optimization Properties: "None (-O0)"
 *                Compiler Warnings Properties: "Warning as errors" NICHT aktivieren
 *                Solution Explorer: "Set as StartUp Project"
 */ 

#include <avr/io.h>

volatile unsigned char *px, x; // Pointer px und Variable x vereinbaren
volatile unsigned int *ptri;   // Pointer für direkte Adressierung vereinbaren
volatile unsigned char *ptr;   // Pointer für SFR vereinbaren

int main(void)
{
	DDRC=0xFF; // LED-Port (PortC) als Ausgang konfigurieren
	ptri = 0x0070;	// Pointer direkt initialisieren (Inhalt = Adresse 0x70 im SRAM)
                    // nur für Demo-Zwecke - MIT VORSICHT VERWENDEN!!!
   while(1)
   {
	  px = &x; // Pointer px auf variable x setzen  (Referenzierung) 
	           // -> px referenziert auf Adresse der Variable x 
			     //    oder einfacher: px "zeigt" auf x
	  
	  *px = 0xBA;  // Wert von x über Pointer px ändern (Dereferenzierung)
	  PORTC = *px;	// Wert von x auf PortC ausgeben

	  ptr = &PORTC; // Pointer auf Portvariable (SFR) setzen
	  *ptr = 0xCC;	 // Ausgabe des Wertes 0xCC auf PortC

	  *ptri=0xFEDC; // SRAM Adressen 0x70/0x71 mit Wert 0xFEDC beschreiben
	  ptri++;		 // Pointer auf nächste Integer-Speicherstelle setzen 
	                // (-> Adresse wird um 2 erhöht)	
   }
}