--	------------------------------------
--	Diplomarbeit elmProject@HTL-Rankweil
--	GÄCHTER Raffael
--	elm-project@hotmail.com
--	2AAELI | 2016/2017
--	------------------------------------
--	File: structure.vhd
--	Version: v1.0
--	------------------------------------
--	Strukturmodell zur Beschreibung
--	der einzelnen Verbindungen zwischen
--	den Komponenten.
--	------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
-- niemals beide NUMERIC_STD und STD_LOGIC_ARITH verwenden!!!
--use IEEE.STD_LOGIC_ARITH.ALL;

entity structure is
	Port(
		EN		:	in	STD_LOGIC;									-- Modul aktiv
		CLK		:	in	STD_LOGIC;									-- Systemtakt
		FLUSH	:	in	STD_LOGIC;									-- Alles leeren
		extRxD	:	in	STD_LOGIC;									-- Alles leeren
		extTxD	:	out STD_LOGIC;									-- Alles leeren
		FREG	:	out STD_LOGIC_VECTOR(7 downto 0);
		SIG		:	out STD_LOGIC_VECTOR(7 downto 0)
		);
end structure;

architecture Behavioral of structure is

-- Instanzierung der UART Komponente
component uart is
	Generic	(
			constant SYS_CLK	: integer range 0 to 100000000 := 100000000;	-- 100 MHz Systemtakt	
			constant BAUD		: integer range 0 to 921600	:= 921600;		-- Bits / Sekunde (BAUD)
			constant QUANTIL	: integer range 0 to 16		:= 12;			-- Abtastungen / Bit (Alle 58 Takte)
			constant DATASIZE	: integer range 0 to 9			:= 8;			-- Datenbit Länge
			constant PARITY		: integer range 0 to 1			:= 1;			-- Parity Bit Length
			constant STOPBIT	: integer range 0 to 2			:= 2;			-- Anzahl der Stoppbits
			constant PARITYBIT	: STD_LOGIC					:= '0';			-- 0=Even/1=Odd (unwirksam wenn PARITY auf 0)
			constant HANDSHAKE	: STD_LOGIC					:= '1';			-- Software Handschake XON/XOFF (nur für Remotesystem)
																				-- Uart sendet kein XON/XOFF da normalerweise nicht notwendig
			constant FIFO_DEPTH	: integer range 0 to 128		:= 80			-- max. Anzahl möglicher Zeichen (für Befehlscoder/decoder)
			);
		Port(
			EN		:	in	STD_LOGIC;														-- Modul aktiv
			CLK		:	in	STD_LOGIC;														-- Systemtakt
			FLUSH	:	in	STD_LOGIC;														-- Alles leeren
			WRITE	:	in	STD_LOGIC;														-- Daten auf UART schreiben
			READ	:	in 	STD_LOGIC;														-- Daten von UART lesen
			dataWR	:	in	STD_LOGIC_VECTOR(DATASIZE - 1 downto 0);						-- Daten über UART Senden
			dataRD	:	out	STD_LOGIC_VECTOR(DATASIZE - 1 downto 0):= (others => '0');	-- Daten über UART Empfangen
			RxD		:	in	STD_LOGIC;														-- Recieve Data
			TxD		:	out	STD_LOGIC	:= '1';												-- Transmit Data
			FREG	:	out	STD_LOGIC_VECTOR (7 downto 0) := (others => '0')				-- Flagregister	
			);
end component uart;

component loopback is
	Generic	(
		constant SYS_CLK	: integer range 0 to 100000000 := 100000000;	-- 100 MHz Systemtakt
		constant DATASIZE	: integer range 0 to 9			:= 8			-- Datenbit Länge
		);
	Port(
		EN		:	in	STD_LOGIC;
		CLK		:	in	STD_LOGIC;
		WRITE	:	out	STD_LOGIC;														-- Daten auf UART schreiben
		READ	:	out	STD_LOGIC;														-- Daten von UART lesen
		dataWR	:	out	STD_LOGIC_VECTOR(DATASIZE - 1 downto 0):= (others => '0');	-- Daten über UART Senden
		dataRD	:	in	STD_LOGIC_VECTOR(DATASIZE - 1 downto 0);						-- Daten über UART Empfangen
		FREG	:	in	STD_LOGIC_VECTOR (7 downto 0) := (others => '0')				-- Flagregister	
		);
end component loopback;

	signal intWRITE, intREAD	: STD_LOGIC := '0';
	signal intdataWR, intdataRD		: STD_LOGIC_VECTOR(7 downto 0);
	signal intFREG					: STD_LOGIC_VECTOR(7 downto 0);
begin

	-- Einbinden des UART Modules
	UUuart: uart	port map(
							EN		=>	EN,
							CLK		=>	CLK,
							FLUSH	=>	FLUSH,
							WRITE	=>	intWRITE,
							READ	=>	intREAD,
							dataWR	=>	intdataWR,
							dataRD	=>	intdataRD,
							RxD		=>	extRxD,
							TxD		=>	extTxD,
							FREG	=>	intFREG
							);

	UUloopback: loopback	port map(
									EN		=>	EN,
									CLK		=>	CLK,
									WRITE	=>	intWRITE,
									READ	=>	intREAD,
									dataWR	=>	intdataWR,
									dataRD	=>	intdataRD,
									FREG	=>	intFREG
									);

	FREG <= intFREG;
	SIG <= intdataRD;

end Behavioral;
