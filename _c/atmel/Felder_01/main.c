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
#define N 4 //Feldgröße über Symbolkonstante definieren

unsigned int tabelle[N]; //eindimensionale Feldvariable ohne Anfangswerte
unsigned char vector[]={1,2,3,4,5};	//eindimensionale Feldvariable mit Initialisierung
unsigned char string[]="1,2,3,4,5";	//String (9 Zeichen und abschließende 0)		
unsigned char matrix[2][3] = \
 { {0x11,0x22,0x33},{0x44,0x55,0x66} }; //zweidimensionale Feldvariable vereinbaren und vorbelegen
int main(void) 
{
  for (unsigned char i=0; i<N; i++) //Zählschleife für Index
    tabelle[i]=0xFFFF-i; //Feldelement belegen

  PORTA=sizeof(tabelle); //Feldgröße=4x2=8Byte
  PORTB=tabelle[1]; //LSByte ins Datenregister für PortB schreiben
  PORTC=tabelle[1]>>8; //MSByte ins Datenregister für PortC schreiben   
  
  vector[0]='H';  //Zeichen 'H' = ACSII Code 0x48 
  string[0]=0x7A; //ASCII Code 0x7A = Zeichen 'z'
  vector[4]=sizeof(string); //Stringlänge=10 (einschließlich abschließende 0)
  
  PORTD=sizeof(matrix); //Feldgröße=2x3=6Byte
  for (unsigned char i=0;i<2;i++)   //Zeilenindex
    for (unsigned char j=0;j<3;j++) //Spaltenindex 
	   matrix[i][j]=i+j; //Matrixelement neu belegen
  
  while(1) {;} //verhindert hinauslaufen aus main
} 
