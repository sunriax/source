/* G.Raf@2AAELI
 * SPI_3DRAHT_01
 * SPI Kommunikation mit Loopback und Master/Slave betrieb
 *
 * Board: Megacard
 * Version: 1.0
 */ 

#define F_CPU 12000000UL	// Systemtakt

// Standardbibliotheken
#include <avr/io.h>	
#include <util/delay.h> 

// Portdefinitionen
#define SPI_DDR   DDRB

#define SPI_PORT  PORTB	// SPI Kommunikationsport
#define SPI_PIN   PINB	// SPI Kommunikationspin

// Kommunikationspins
#define SPI_SS    PB4	// SPI Slave Select Pin
#define SPI_MOSI  PB5	// SPI Master-Out-Slave-In Pin
#define SPI_MISO  PB6	// SPI Master-In-Slave-Out Pin
#define SPI_SCK   PB7	// SPI Takt

// SPI Initialisierungsroutine
void SPI_Init(void)
{ 
	SPI_DDR |= (1<<SPI_SCK) | (1<<SPI_MOSI) | (1<<SPI_MISO);	// Clock, MOSI, MISO also Ausgang
	SPI_PORT = (1<<SPI_SS) | (1<<SPI_MISO);						// Pullup an Slave Select und MISO aktivieren
																// Wenn SS auf LOW System in Slave-Betriebsart
																// Wenn SS auf HIGH System in Master-Betriebsart

	SPSR = (1<<SPI2X);											// Double Speed Mode aktivieren
	SPCR = (1<<MSTR) | (1<<SPE) | (1<<SPR1);					// Master Betriebsart ein
}

// SPI Transferroutine
unsigned char SPI_Transfer (unsigned char Data_Tx)
{ 
	static unsigned char Data_Rx;								// Funktionsvariable anlegen
 
	if (SPCR & (1<<MSTR))										// Wenn Master aktiv
		_delay_ms(1);											// Verzögerung um 1ms

	SPDR = Data_Tx;												// Daten auf SPI Datenregister schreiben
 
	while (!(SPSR & (1<<SPIF)))									// Warten solange SPIF 0
		asm volatile ("nop");									// NO OPERATION

	if (SPSR & (1<<WCOL))										// Wenn Kollision aufgetreten
		Data_Rx |= 0x80;										// Sticky-Bit aktivieren
 
	Data_Rx = (Data_Rx&0x80) | (SPDR&0x7F);						// Empfangende Daten auf  in DatenRX speichern

	return Data_Rx;												// Rückgabe von Data RX
}

// Hauptprogramm
int main(void) 
{
	DDRC  = 0xFF;	// DDRC Ausgang
	PORTC = 0x00;	// PORTC auf LOW
	DDRA  = 0x00;	// DDRA als Eingang
	PORTA = 0x0F;	// Pullups aktivieren
	
	SPI_Init();		// Initialisierung aufrufen
 
	//Endlosschleife
	while(1)
	{
		PORTC = SPI_Transfer(~PINA&0x0F);	// Ausgabe von Empfangenen Daten und Senden von PINA
	} 
}
// Programmende