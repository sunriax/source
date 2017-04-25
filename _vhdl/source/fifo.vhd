--	------------------------------------
--	Diplomarbeit elmProject@HTL-Rankweil
--	GÄCHTER Raffael
--	elm-project@hotmail.com
--	2AAELI | 2016/2017
--	------------------------------------
--	File: fifo.vhd
--	Version: v1.0
--	------------------------------------
--	First in First out Schnittstelle
--	mit wählbarer Speichertife und
--  FLAG Register! Standardspeichertife
--	(2^4) - 1 = 0 -- 15, Datenbreite
--	8 Bits = 1 Byte 

 
--	------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
-- niemals beide NUMERIC_STD und STD_LOGIC_ARITH verwenden!!!
--use IEEE.STD_LOGIC_ARITH.ALL;

entity fifo is
	Generic	(
			constant SYS_CLK	: integer range 0 to 100000000 := 100000000;	-- 100 MHz Systemtakt
			constant FIFO_ADDR	: integer range 0 to 1024		:= 128;			-- Speicherbreite in Byte
			constant FIFO_DATA	: integer range 0 to 8			:= 8			-- Datenbreite
			);
		Port(
			EN, CLK, FLUSH	: in  STD_LOGIC;														-- System Signale
			writeEN, readEN	: in  STD_LOGIC;														-- Lese/Schreib aktivierung
			dataIN			: in  STD_LOGIC_VECTOR (FIFO_DATA - 1 downto 0);						-- Daten eingabe
			dataOUT			: out STD_LOGIC_VECTOR (FIFO_DATA - 1 downto 0) := (others => '0');	-- Daten ausgabe
			FULL, EMPTY		: out STD_LOGIC														-- VOLL / LEER rückgabe
			);
end fifo;

architecture Behavioral of fifo is
	-- Standardsignale
	signal pointerHEAD	: integer range 0 to FIFO_ADDR := 0;	-- Schreibzähler
	signal pointerTAIL	: integer range 0 to FIFO_ADDR	:= 0;	-- Lesezähler
	signal intFULL	: STD_LOGIC := '0';	-- FIFO voll (intern)
	signal intEMPTY	: STD_LOGIC := '0';	-- FIFO leer (intern)

	type memory is array(0 to FIFO_ADDR) of STD_LOGIC_VECTOR((FIFO_DATA - 1) downto 0);	-- Datenarray mit ((2^FIFO_ADDR) - 1) Speicherplätzen
	signal FIFO : memory := (others => (others => '0'));											-- FIFO mit 0 initialisieren
begin

	
	EMPTY <= intEMPTY;
	FULL <= intFULL;

	-- FIFO Lese/Schreibzyklus
	process(CLK, EN, FLUSH, writeEN, readEN, dataIN, pointerHEAD, pointerTAIL, intFULL, intEMPTY)
			variable cycle : boolean := false;
		begin
			if(rising_edge(CLK)) Then
				-- FIFO Rücksetzen und Leeren
				if(EN = '0' or FLUSH = '1') Then
					FIFO		<= (others => (others => '0'));		-- Komplettes Array leeren
					dataOUT		<= (others => '0');					-- Datenausgang auf LOW
					pointerHEAD	<= 0;								-- Schreib Zähler auf 0
					pointerTAIL	<= 0;								-- Lese Zähler auf 0
					intFULL		<= '0';								-- Voll FLAG auf 0
					intEMPTY	<= '1';								-- Leer FLAG auf 1
					cycle		:= false;							-- Durchlauf auf false
				else
					-- Lese Zyklus
					if(pointerHEAD = pointerTAIL) Then				-- Wenn Schreibzähler = Lesezähler
						dataOUT <= (others => '0');					-- Datenausgang auf LOW
						intEMPTY <= '1';							-- Leer FLAG auf 1 (keine Daten in FIFO)
						intFULL <= '0';
					else
						if(readEN = '1' and intEMPTY = '0') Then	-- Wenn Lesen auf 1 und FIFO nicht leer
							dataOUT <= FIFO(pointerTAIL);			-- Datenausgabe aus Block-Ram
							
							if(pointerTAIL = FIFO_ADDR) Then		-- wenn Lesezähler auf höchsten Speicherplatz
								pointerTAIL <= 0;					-- Lesezähler auf 0 setzen
								cycle := false;						-- Durchlaufvariable auf false
							else
								pointerTAIL <= pointerTAIL + 1;		-- Lesezähler um 1 erhöhen
							end if;
						else
							dataOUT <= (others => '0');				-- Datenausgabe auf LOW
						end if;
	
							intEMPTY <= '0';						-- Leer FLAG auf 0 (Daten in FIFO)
					end if;
					
					-- Schreib Zyklus
					if(writeEN = '1') Then
						if(	(cycle = false and (pointerHEAD - pointerTAIL) = FIFO_ADDR) or
							(cycle = true and (pointerHEAD = (pointerTAIL - 1)))) Then
								intFULL <= '1';
								intEMPTY <= '0';
						else
							FIFO(pointerHEAD) <= dataIN;
						
							if(pointerHEAD = FIFO_ADDR) Then
								cycle := true;
								pointerHEAD <= 0;
							else
								pointerHEAD <= pointerHEAD + 1;
							end if;

							intFULL <= '0';
						end if;
					end if;
				end if;

			end if;
	end process;

end Behavioral;
