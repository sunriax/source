--	------------------------------------
--	Diplomarbeit elmProject@HTL-Rankweil
--	G.Raf@elmProject
--	2AAELI | 2016/2017
--	------------------------------------
--	File: control.vhd
--	Version: v1.0
--	------------------------------------
--	Datenflusssteuerung (Steuerwerk) des
--	gesamten Hardwaremodells
--	------------------------------------

-- Standardbibliotheken einbinden
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity control is
 Generic(
 		constant uartDATASIZE	: integer range 1 to 9 := 8;
 		constant uartFREGSIZE	: integer range 1 to 9 := 8;
 		constant pxDATASIZE		: integer range 1 to 8 := 4
 		);
	Port(
		EN			:  in STD_LOGIC;
		CLK			:  in STD_LOGIC;
		RESET		:  in STD_LOGIC;
		
		-- UART Signale
		uartWRITE	: out STD_LOGIC;
		uartREAD	: out STD_LOGIC;
		uartINDATA	:  in STD_LOGIC_VECTOR(uartDATASIZE - 1 downto 0);
		uartOUTDATA	: out STD_LOGIC_VECTOR(uartDATASIZE - 1 downto 0);
		uartFREG	:  in STD_LOGIC_VECTOR(uartFREGSIZE - 1 downto 0);
		
		-- VGA Signale
		vgaTEST		: out STD_LOGIC;
		vgaMODE		: out STD_LOGIC_VECTOR(1 downto 0);
		vgaPIXEL	: out STD_LOGIC_VECTOR((pxDATASIZE * 3) - 1 downto 0)
		
		-- Analog Signale
--		analogREAD		: out STD_LOGIC;
--		analogWRITE		: out STD_LOGIC;
--		analogADDR		: out STD_LOGIC_VECTOR(6 downto 0);
--		analogCHANNEL	:  in STD_LOGIC_VECTOR(5 downto 0);
--		analogINDATA	: out STD_LOGIC_VECTOR(15 downto 0);
--		analogOUTDATA	:  in STD_LOGIC_VECTOR(15 downto 0);
--		analogALARM		:  in STD_LOGIC_VECTOR(7 downto 0);
--		analogFREG		:  in STD_LOGIC_VECTOR(7 downto 0)
		
		-- Speicher Signale
		);
end control;

architecture Behavioral of control is
	-- Texte
	signal txtTITLE		: STRING(1 to 25)	:= "elmProject 2016/2017 V1.0" & CR & LF;
	signal txtINIT		: STRING(1 to 6)	:= "[INIT]";
	signal txtREGVGA	: STRING(1 to 6)	:= "[XVGA]";

	-- interne UART Signale
	signal intuartREAD		: STD_LOGIC := '0';
	signal intuartWRITE		: STD_LOGIC := '0';
	signal intuartINDATA	: STD_LOGIC_VECTOR(uartDATASIZE - 1 downto 0);
	signal intuartOUTDATA	: STD_LOGIC_VECTOR(uartDATASIZE - 1 downto 0);

	-- intere Systemsignale
	signal setSTRING		: boolean := false;
	signal selectSTRING		: integer range 0 to 24 := 0;
	signal getSTRING		: boolean := false;
	signal getDATA			: STD_LOGIC_VECTOR(31 downto 0);

	signal registerRESET	: boolean := false;
	signal systemINIT		: boolean := false;
	signal controlINIT		: boolean := false;
	signal vgaINIT			: boolean := false;
	signal adcINIT			: boolean := false;
	signal gpioINIT			: boolean := false;
	
begin

	uartWRITE	<= '0' WHEN EN = '0' ELSE intuartWRITE;
	uartREAD	<= '0' WHEN EN = '0' ELSE intuartREAD;
	uartOUTDATA	<= (others => '0') WHEN EN = '0' ELSE intuartOUTDATA;


UART_SET:	process(CLK, EN, RESET, uartFREG)
					variable dataCHAR	: STD_LOGIC_VECTOR(7 downto 0);
					variable stopFLAG	: boolean := false;
				begin
					if(EN = '0' or RESET ='0') Then
					
						dataCHAR := (others => '0');
					
					elsif(rising_edge(CLK)) Then
					
						if(setSTRING = true) Then
							
							case(selectSTRING) is
								when	1	=>
								when	2	=>
								when	3	=>
								when	4	=>
								when	5	=>
								when others =>
							end case;
							
						end if;
					
					end if;
			end process;

UART_GET:	process(CLK, EN, RESET, uartFREG)
					variable textCNT	: integer range 0 to 30 := 0;
					variable stopFLAG	: boolean := false;
				begin
			
			
			end process;

-- Initialisierungsprozess
UART_INIT:	process(CLK, EN, RESET, uartFREG)
					variable textCNT	: integer range 0 to 30 := 0;
					variable stopFLAG	: boolean := false;
				begin
					-- Asynchroner Reset
					if(EN = '0' or RESET = '0') Then
					
						-- Rücksetzten der Systemsignale
						setSTRING <= false;
						getSTRING <= false;
						
						systemINIT <= false;
						controlINIT <= false;
						vgaINIT <= false;
						adcINIT <= false;
						gpioINIT <= false;
					
					elsif(rising_edge(CLK)) Then
						if(systemINIT = false) Then
						
							-- Prüfen ob FIFO voll
							if(uartFREG(4) = '0') Then
							
								intuartWRITE <= '1';	-- UART Schreibvorgang aktivieren
								stopFLAG := false;		-- Rücksetzten der Stopflag
								
								-- Überprüfen ob Text Endmarke erreicht
								if(textCNT = (txtTITLE'high + 1)) Then
								
									systemINIT <= true;					-- System Initialisierung abgeschlossen
									intuartWRITE <= '0';				-- UART schreibvorgang deaktivieren
									intuartOUTDATA <= (others => '0');	-- FIFO Eingang auf 0
									
								-- Text in FIFO schreiben
								else
								
									intuartOUTDATA <= std_logic_vector(to_unsigned(character'pos(txtTITLE(textCNT)), 8));	-- Text auf FIFO Eingang legen
									textCNT := textCNT + 1;																	-- Textzähler inkrementieren
									
								end if;
							
							-- Wenn FIFO voll
							else
								intuartWRITE <= '0';		-- Schreibvorgang deaktivieren
								
								-- Prüfen ob Stop
								if(stopFLAG = false) Then
								
									textCNT := textCNT - 1;	-- Text Zähler dekrementieren
									stopFLAG := true;		-- Stopp dekrementation ausgeführt
									
								end if;
							end if;
						end if;
					end if;					
			end process;

-- Steuerprozess
SYS_CONTROL:	process(CLK, EN, RESET, uartFREG)
						variable looped			: boolean := false;
						variable dataEXECUTE	: boolean := false;
						variable dataREGISTER	: STD_LOGIC_VECTOR(7 downto 0);
					begin
						-- Asynchroner Reset
						if(EN = '0' or RESET = '0') Then
							
						elsif(rising_edge(CLK)) Then
						
							-- Überprüfen ob System Initialisierung abgeschlossen
							if(systemINIT = true) Then
							
								-- Überprüfen ob Empfangsbuffer leer
								if(uartFREG(1) = '0' and dataEXECUTE = false) Then
						
									if(looped = false) Then
									
										intuartREAD <= '1';
										
										looped := true;
										
									else
									
										intuartREAD <= '0';
										
										dataEXECUTE := true;
										dataREGISTER := uartinDATA;
										
									end if;
								end if;
								
								if(dataEXECUTE = true) Then
								
									case(dataREGISTER)
								
								end if;
								
							end if;
						end if;
				end process;

-- VGA Initialisierungsprozess
VGA_INIT:	process(CLK, EN, RESET, uartFREG)
				begin
					if(EN = '0' or RESET = '0') Then
					
					elsif(rising_edge(CLK)) Then
						if(systemINIT = true) Then
							
							
						
						end if;
					end if;
			end process;

end Behavioral;
