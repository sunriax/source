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
		FREG	:	out STD_LOGIC_VECTOR(15 downto 0);
		
		-- FTDI FIFO I/O
		FIFO_RXF	:	in	STD_LOGIC;
		FIFO_TXE	:	in	STD_LOGIC;
		FIFO_WR		:	out	STD_LOGIC;
		FIFO_RD		:	out	STD_LOGIC;
		FIFO_STROBE	:	in	STD_LOGIC;
		FIFO_DATA	:	inout	STD_LOGIC_VECTOR(7 downto 0)
		
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


component databus is
	Generic	(
			-- Systemkonstanten
			constant SYS_CLK	: integer := 100000000;	-- 100 MHz Systemtakt
			constant WRITE_CLK	: integer := 1000000;		-- 1 MHz Systemtakt
			constant DATASIZE	: integer := 8;			-- Datenbit Länge
			constant STROBESIZE	: integer := 3;			-- Flankenerkennungslänge für Lesemodus
			constant FIFO_DEPTH	: integer := 512			-- max. Anzahl möglicher Zeichen (für Befehlscoder/decoder)
			);
		Port(
			-- Standard I/Os
			EN		:	in	STD_LOGIC;		-- Modul aktiv
			CLK		:	in	STD_LOGIC;		-- Systemtakt
			FLUSH	:	in	STD_LOGIC;		-- Alles leeren
			
			-- FTDI FIFO I/Os
    		STROBE	:	in	STD_LOGIC;		-- Empfangs Takt
    		RXF		:	in	STD_LOGIC;		-- FIFO RXF Kanal
    		TXE		:	in	STD_LOGIC;		-- FIFO TXE Kanal
    		READ	:	out STD_LOGIC;		-- FIFO READ Kanal
    		WRITE	:	out STD_LOGIC;		-- FIFO WRITE Kanal
    		--SIWU	:	out STD_LOGIC;		-- Pin steht nicht zur Verfügung
			DATA	: inout STD_LOGIC_VECTOR(DATASIZE - 1 downto 0);	-- FIFO Datenkanal
			
			-- Empfangs / Sendebuffer I/Os
			txWRITE	:	in	STD_LOGIC;									-- Data in sende Buffer schreiben
			txDATA	:	in	STD_LOGIC_VECTOR(DATASIZE - 1 downto 0);	-- Transmit FIFO
			rxREAD	:	in	STD_LOGIC := '0';							-- Data aus empfangs Buffer lesen
			rxDATA	:	out	STD_LOGIC_VECTOR(DATASIZE - 1 downto 0);	-- Receive FIFO
			
			-- Systemregister
			FREG	:	out	STD_LOGIC_VECTOR(7 downto 0)
			);
end component databus;


component fifo2uart is
	Generic	(
			-- Systemkonstanten
			constant SYS_CLK	: integer := 100000000;	-- 100 MHz Systemtakt
			constant DATASIZE	: integer := 8				-- Datenbit Länge
			);
	Port	(
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
end component fifo2uart;
	
	signal intUART_WRITE,	intUART_READ	:	STD_LOGIC := '0';
	signal intUART_wrDATA,	intUART_rdDATA	:	STD_LOGIC_VECTOR(7 downto 0);
	signal intUART_FREG						:	STD_LOGIC_VECTOR(7 downto 0);
	
	signal intFIFO_txWRITE, intFIFO_rxREAD	:	STD_LOGIC := '0';
	signal intFIFO_txDATA, intFIFO_rxDATA	:	STD_LOGIC_VECTOR(7 downto 0);
	signal intFIFO_FREG						:	STD_LOGIC_VECTOR(7 downto 0);
	
begin

	-- Einbinden des UART Modules
	UUuart: uart	port map(
							EN		=>	EN,
							CLK		=>	CLK,
							FLUSH	=>	FLUSH,
							WRITE	=>	intUART_WRITE,
							READ	=>	intUART_READ,
							dataWR	=>	intUART_wrDATA,
							dataRD	=>	intUART_rdDATA,
							RxD		=>	extRxD,
							TxD		=>	extTxD,
							FREG	=>	intUART_FREG
							);

	-- Einbinden des FTDI FIFO Modules
	UUfifo: databus	port map(
							EN		=>	EN,
							CLK		=>	CLK,
							FLUSH	=>	FLUSH,
							
							STROBE	=>	FIFO_STROBE,
							RXF		=>	FIFO_RXF,
							TXE		=>	FIFO_TXE,
							READ	=>	FIFO_RD,
							WRITE	=>	FIFO_WR,
							
							DATA	=>	FIFO_DATA,
							
							txWRITE	=>	intFIFO_txWRITE,
							txDATA	=>	intFIFO_txDATA,
							rxREAD	=>	intFIFO_rxREAD,
							rxDATA	=>	intFIFO_rxDATA,
							
							FREG	=>	intFIFO_FREG
							);

	-- Einbinden der FIFO 2 UART Brücke
	UUbridge: fifo2uart	port map(
								EN			=>	EN,
								CLK			=>	CLK,
								FLUSH		=>	FLUSH,
								
								FIFO_READ	=>	intFIFO_rxREAD,
								FIFO_rdDATA	=>	intFIFO_rxDATA,
								FIFO_WRITE	=>	intFIFO_txWRITE,
								FIFO_wrDATA	=>	intFIFO_txDATA,
								
								FIFO_FREG	=>	intFIFO_FREG,
								
								UART_WRITE	=>	intUART_WRITE,
								UART_READ	=>	intUART_READ,
								UART_wrDATA	=>	intUART_wrDATA,
								UART_rdDATA	=>	intUART_rdDATA,
								
								UART_FREG	=>	intUART_FREG
								
								);

	FREG <= intUART_FREG & intFIFO_FREG;

end Behavioral;
