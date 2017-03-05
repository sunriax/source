--	------------------------------------
--	Diplomarbeit elmProject@HTL-Rankweil
--	GÄCHTER Raffael                     
--	elm-project@sunriax.at              
--	2AAELI | 2016/2017                  
--	------------------------------------
--	File: fifo.vhdl                    
--	Version: v1.0                       
--	------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
-- use IEEE.STD_LOGIC_ARITH.ALL; // niemals beide NUMERIC_STD und STD_LOGIC_ARITH verwenden!!!
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity fifo is
	Generic	(
			constant nWIDTH	:	integer := 8;
			constant nDEPTH	:	integer := 1024
			);
	Port	(
			CLK		: in STD_LOGIC;
			RESET	: in STD_LOGIC;
			writeEN	: in STD_LOGIC;
			readEN	: in STD_LOGIC;
			dataIN	: in STD_LOGIC_VECTOR (7 downto 0);
			dataOUT	: out STD_LOGIC_VECTOR (7 downto 0);
			EMPTY	: out STD_LOGIC;
			FULL	: out STD_LOGIC);
end fifo;

architecture Behavioral of fifo is

begin
	process(CLK)
			type memTYPE is array (0 to nWIDTH - 1) of STD_LOGIC_VECTOR(nWIDTH - 1 downto 0);
			variable memFIFO : memTYPE;
			
			variable startFIFO, endFIFO	: integer range 0 to nDEPTH - 1;
			variable cycle : boolean := false;
		begin
			if(rising_edge(CLK)) then
				if RESET = '1' then
					startFIFO := 0;
					  endFIFO := 0;
				else
					if(readEN = '1') then
						if((cycle = true) or (startFIFO /= endFIFO)) then	-- /= auf ungleichheit prüfen ergebnis = boolean
							-- Daten auf Ausgang legen
							dataOUT <= memFIFO(endFIFO);
							
							-- pointer endFIFO aktualisieren
							if(endFIFO = nDEPTH - 1) then
								endFIFO := 0;
								  cycle := false;
							else
								endFIFO := endFIFO + 1;
							end if;
						end if;
					end if;
					
					if(writeEN = '1') then
						if((cycle = false) or (startFIFO /= endFIFO)) then	-- /= auf ungleichheit prüfen ergebnis = boolean
							-- Daten in FIFO schreiben
							memFIFO(startFIFO) := dataIN;
							
							-- pointer beginFIFO aktualisieren
							if(startFIFO = nDEPTH - 1) then
								startFIFO := 0;
								  cycle := true;
							else
								startFIFO := startFIFO + 1;
							end if;
						end if;
					end if;
					
					-- Voll und Leer Status setzen
					if(startFIFO = endFIFO) then
						if (cycle = true) then
							 FULL <= '1';
						else
							EMPTY <= '1';
						end if;
					else
						EMPTY <= '0';
						 FULL <= '0';
					end if;					
				end if;
			end if;
		end process;
end Behavioral;
