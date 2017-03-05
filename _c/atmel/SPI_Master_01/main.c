/* G.Raf@2AAELI
 * SPI_MASTER_01
 * SPI Kommunikation mit Loopback
 *
 * Board: Megacard
 * Version: 1.0
 */ 

#define F_CPU 12000000UL				// Systemtakt
#define DOUBLESPEED						// Abtastungs aktivieren

// Standardbibliotheken
#include <avr/io.h>						// SFR Register und Bitdefinitionen
#include <avr/interrupt.h>				// Interrupt Definitionen einbinden

// Standardwerte
#define HIGH 0xFF						// HIGH Byte
#define LOW 0x00						// LOW Byte

// Timer0 Einstellungen
#define DDRIN  DDRA						// Datenrichtungsregister für Eingabe
#define DDRSPI DDRB						// Datenrichtungsregister für SPI Register
#define DDROUT DDRC						// Datenrichtungsregister für Ausgabe
#define INPUT  PINA
#define INPORT PORTA					// Eingabe Port
#define SPIPUT PORTB					// SPI Port
#define OUTPUT PORTC					// Ausgabe Port

// SPI Pins
#define MOSI PB5						// Master-Out-Slave-In
#define MISO PB6						// Master-In-Slave-Out
#define SCK	 PB7						// SPI Taktsignal
#define SS	 PB4						// Slave Select

// SPI Interruptroutine
ISR(SPI_STC_vect)
{
	OUTPUT = SPDR;										// Daten aus SPI Datenregister ausgeben
	SPDR = (0xF0 & ~(INPUT<<4)) | (0x0F & ~(INPUT));	// Daten in SPI Datenregister schreiebn
}

// SPI Initialisierungsroutine
void SPI_MasterInit()
{
	DDRSPI = (1<<MOSI) | (1<<SCK);	// SCK, MOSI als Ausgang
	SPIPUT = (1<<MISO) | (1<<SS);	// MISO, SS Pullup aktivieren

	SPCR = (1<<MSTR) | (1<<SPR1);	// Interrupt individuell freigeben,
									// Masterbetrieb aktivieren
									// Vorteiler auf 64
	
	SPCR |= (1<<SPE);				// SPI einschalten
}

// Hauptprogramm
int main(void)
{
	DDRIN = LOW;		// Datenrichtungsregister auf Eingang
	INPORT = HIGH;		// Pullups an Eingang einschalten
	
	DDROUT = HIGH;		// Datenrichtungsregister auf Ausgang
	OUTPUT = LOW;		// Alle LEDs ausschalten
	
	SPI_MasterInit();	// SPI Initialisierung
	
	SPCR |= (1<<SPIE);	// Interrupt Individuell freigeben
	SPDR = LOW;			// Dummy Schreibforgang auf SPI Datenregister
	
	sei();				// Interrupt global freigeben
	
    while (1) 
    {
    }
}
// Programmende

