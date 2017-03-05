/*
 * Felder_01.c
 *
 * Created: 2.12.2016 16:15:57
 * Author: Harry
 *
 * Zweck: Speicherbelegung von Feldern untersuchen
 *        Verwendung des AVR-Simulators
 *
 * Einstellungen: Compiler Optimization Properties: "None (-O0)"
 *                Solution Explorer: "Set as StartUp Project"
 */ 

#include <avr/io.h> //I/O-Systembibliothek einbinden
#define N 4 //Feldgr��e �ber Symbolkonstante definieren

unsigned int tabelle[N]; //eindimensionale Feldvariable ohne Anfangswerte
unsigned char vector[]={1,2,3,4,5};	//eindimensionale Feldvariable mit Initialisierung
unsigned char string[]="1,2,3,4,5";	//String (9 Zeichen und abschlie�ende 0)		
unsigned char matrix[2][3] = \
 { {0x11,0x22,0x33},{0x44,0x55,0x66} }; //zweidimensionale Feldvariable vereinbaren und vorbelegen
int main(void) 
{
  for (unsigned char i=0; i<N; i++) //Z�hlschleife f�r Index
    tabelle[i]=0xFFFF-i; //Feldelement belegen

  PORTA=sizeof(tabelle); //Feldgr��e=4x2=8Byte
  PORTB=tabelle[1]; //LSByte ins Datenregister f�r PortB schreiben
  PORTC=tabelle[1]>>8; //MSByte ins Datenregister f�r PortC schreiben   
  
  vector[0]='H';  //Zeichen 'H' = ACSII Code 0x48 
  string[0]=0x7A; //ASCII Code 0x7A = Zeichen 'z'
  vector[4]=sizeof(string); //Stringl�nge=10 (einschlie�lich abschlie�ende 0)
  
  PORTD=sizeof(matrix); //Feldgr��e=2x3=6Byte
  for (unsigned char i=0;i<2;i++)   //Zeilenindex
    for (unsigned char j=0;j<3;j++) //Spaltenindex 
	   matrix[i][j]=i+j; //Matrixelement neu belegen
  
  while(1) {;} //verhindert hinauslaufen aus main
} 
