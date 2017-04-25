--	------------------------------------
--	Diplomarbeit elmProject@HTL-Rankweil
--	GÄCHTER Raffael
--	elm-project@hotmail.com
--	2AAELI | 2016/2017
--	------------------------------------
--	File: fifo2uart.vhd
--	Version: v1.0
--	------------------------------------
--	Sendet über UART Empfangene Daten
--	weiter an das FIFO. Sendet über das
--  FIFO empfangene DATEN weiter über
--	UART. Dient zum Verbindungstest!
--	------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
-- niemals beide NUMERIC_STD und STD_LOGIC_ARITH verwenden!!!
--use IEEE.STD_LOGIC_ARITH.ALL;

entity fifo2uart is
	Generic	(
			-- Systemkonstanten
			constant SYS_CLK	: integer := 100000000;	-- 100 MHz Systemtakt
			constant DATASIZE	: integer := 8				-- Datenbit Länge
			);
	Port(
					-- Standard I/Os
			EN		:	in	STD_LOGIC;		-- Modul aktiv
			CLK		:	in	STD_LOGIC;		-- Systemtakt
			FLUSH	:	in	STD_LOGIC;		-- Alles leeren
	
			-- FTDI Hardware FIFO
			FIFO_READ	:	out	STD_LOGIC;									-- Data in sende Buffer schreiben
			FIFO_rdDATA	:	in	STD_LOGIC_VECTOR(DATASIZE - 1 downto 0);	-- Transmit FIFO
			FIFO_WRITE	:	out	STD_LOGIC := '0';							-- Data aus empfangs Buffer lesen
			FIFO_wrDATA	:	out	STD_LOGIC_VECTOR(DATASIZE - 1 downto 0);	-- Receive FIFO
			-- Sende/Empfangs FIFO Systemregister
			FIFO_FREG	:	in	STD_LOGIC_VECTOR(7 downto 0);
			
			UART_WRITE	:	out	STD_LOGIC;									-- Daten auf UART schreiben
			UART_READ	:	out	STD_LOGIC;									-- Daten von UART lesen
			UART_wrDATA	:	out	STD_LOGIC_VECTOR(DATASIZE - 1 downto 0);	-- Daten über UART Senden
			UART_rdDATA	:	in	STD_LOGIC_VECTOR(DATASIZE - 1 downto 0);	-- Daten über UART Empfangen
			UART_FREG	:	in	STD_LOGIC_VECTOR (7 downto 0)				-- Flagregister	
			);
end fifo2uart;

----------------------------------------------
--	>FREG	REFL | BUFE | BUFF | REDA |		--      
--		Initialisierungswert 0x00			--            
--		LSB	-> REBF	Receive Buffer full		--       
--			-> REBE Receive Buffer empty	--          
--			-> N.C.							--         
--			-> N.C.							--        
--			-> TRBF	Transmit Buffer full	--          
--			-> TRBE	Transmit Buffer empty	--         
--			-> N.C.							--                         
--		MSB	-> N.C.							--                      
----------------------------------------------

architecture Behavioral of fifo2uart is

begin

FIFO2UART:	process(CLK)
					variable fifoCYCLE	: boolean := false;
					variable readCYCLE	: boolean := false;
					variable uartCYCLE	: boolean := false;
					variable fifoDATA	: STD_LOGIC_VECTOR(DATASIZE - 1 downto 0);
				begin
					if(rising_edge(CLK) and EN = '1') Then
						-- Wenn Daten in FIFO Empfangsbuffer
						if((FIFO_FREG(1) = '0' and UART_FREG(4) = '0') or fifoCYCLE = true or uartCYCLE = true) Then
						
							-- Wenn Lese / Schreibzyklus noch nicht ausgeführt
							if(fifoCYCLE = false) Then
							
								FIFO_READ <= '1';	-- Daten aus FIFO Empfangsbuffer lesen aktivieren
								fifoCYCLE := true;	-- Status auf Zyklus aktiv
							
							else
							
								if(readCYCLE = false) Then
							
									FIFO_READ <= '0';
									
									readCYCLE := true;
								
								else
								
								
									if(uartCYCLE = false) Then
										
										UART_WRITE <= '1';			-- schreiben in UART Sendebuffer aktivieren
										UART_wrDATA <= FIFO_rdDATA;	-- Daten aus FIFO Empfangsbuffer auf UART Sendebuffer schreiben
										
										uartCYCLE := true;	-- Status auf Zyklus aktiv
										
									else
									
										UART_WRITE <= '0';			-- schreibvogang Rücksetzten
									
										fifoCYCLE := false;
										readCYCLE := false;
										uartCYCLE := false;
									
									end if;
							
								end if;
							
							end if;
						end if;
					end if;
				
			end process FIFO2UART;

UART2FIFO:	process(CLK)
					variable fifoCYCLE	: boolean := false;
					variable readCYCLE	: boolean := false;
					variable uartCYCLE	: boolean := false;
					variable fifoDATA	: STD_LOGIC_VECTOR(DATASIZE - 1 downto 0);
				begin
					if(rising_edge(CLK) and EN = '1') Then
						-- Wenn Daten in FIFO Empfangsbuffer
						if((UART_FREG(1) = '0' and FIFO_FREG(4) = '0') or fifoCYCLE = true or uartCYCLE = true) Then
						
							-- Wenn Lese / Schreibzyklus noch nicht ausgeführt
							if(uartCYCLE = false) Then
							
								UART_READ <= '1';	-- Daten aus FIFO Empfangsbuffer lesen aktivieren
								uartCYCLE := true;	-- Status auf Zyklus aktiv
							
							else
							
								if(readCYCLE = false) Then
							
									UART_READ <= '0';
									readCYCLE := true;
								
								else
								
								
									if(fifoCYCLE = false) Then
										
										FIFO_WRITE <= '1';			-- schreiben in UART Sendebuffer aktivieren
										FIFO_wrDATA <= UART_rdDATA;	-- Daten aus FIFO Empfangsbuffer auf UART Sendebuffer schreiben
										
										fifoCYCLE := true;	-- Status auf Zyklus aktiv
										
									else
									
										FIFO_WRITE <= '0';			-- schreibvogang Rücksetzten
									
										uartCYCLE := false;
										readCYCLE := false;
										fifoCYCLE := false;
									
									end if;
							
								end if;
							
							end if;
						end if;
					end if;
				
			end process UART2FIFO;


end Behavioral;
