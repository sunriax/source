--	------------------------------------
--	Diplomarbeit elmProject@HTL-Rankweil
--	G.Raf@elmProject
--	2AAELI | 2016/2017
--	------------------------------------
--	File: databus.vhd
--	Version: v1.0
--	------------------------------------
--	FTDI FTXXX FIFO Empfangs und Sende-
--	einheit. Das Modul kann bezüglich
--	Datenpufferung eingestellt werden.
--	------------------------------------

library IEEE;
--library UNISIM;

use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
-- niemals beide NUMERIC_STD und STD_LOGIC_ARITH verwenden!!!
--use IEEE.STD_LOGIC_ARITH.ALL;
--use UNISIM.VComponents.all;

entity databus is
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
end databus;
                                              
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

architecture Behavioral of databus is

	-- Systemvariablen
	signal setDATA		:	STD_LOGIC_VECTOR(DATASIZE - 1 downto 0) := (others => 'Z');
	signal getDATA		:	STD_LOGIC_VECTOR(DATASIZE - 1 downto 0) := (others => 'Z');
	signal intREAD		:	STD_LOGIC := '1';
	signal intWRITE		:	STD_LOGIC := '1';

	-- TX FIFO Signals
	signal FifoTX_RD	:	STD_LOGIC := '0';
	signal FifoTX_FULL	:	STD_LOGIC;
	signal FifoTX_EMPTY	:	STD_LOGIC;
	signal FifoTX_OUT	:	STD_LOGIC_VECTOR(7 downto 0);

	-- RX FIFO Signals
	signal FifoRX_WR	:	STD_LOGIC := '0';
	signal FifoRX_FULL	:	STD_LOGIC;
	signal FifoRX_EMPTY	:	STD_LOGIC;
	signal FifoRX_IN	:	STD_LOGIC_VECTOR(7 downto 0);

-- FIFO Komponente deklarieren
component Fifo is
	Generic	(
		constant SYS_CLK	: integer;
		constant FIFO_ADDR	: integer;
		constant FIFO_DATA	: integer
		);
	Port(
		EN, CLK, FLUSH	: in  STD_LOGIC;
		writeEN, readEN	: in  STD_LOGIC;
		dataIN			: in  STD_LOGIC_VECTOR (DATASIZE - 1 downto 0);
		dataOUT			: out STD_LOGIC_VECTOR (DATASIZE - 1 downto 0);
		FULL, EMPTY		: out STD_LOGIC
		);
end component Fifo;

begin

	-- Einbinden des Sende Fifo
	txFIFO:	Fifo	generic map	(
					 			SYS_CLK		=>	SYS_CLK,
					 			FIFO_ADDR	=>	FIFO_DEPTH,
					 			FIFO_DATA	=>	DATASIZE
					 			)
						port map(
								EN		=>	EN,
								CLK		=>	CLK,
								FLUSH	=>	FLUSH,
								writeEN	=>	txWRITE,
								readEN	=>	FifoTX_RD,
								dataIN	=>	txDATA,
								dataOUT	=>	FifoTX_OUT,
								FULL	=>	FifoTX_FULL,
								EMPTY	=>	FifoTX_EMPTY
								);

	-- Einbinden des Empfangs Fifo
	rxFIFO:	Fifo	generic map	(
								SYS_CLK		=>	SYS_CLK,
								FIFO_ADDR	=>	FIFO_DEPTH,
								FIFO_DATA	=>	DATASIZE
								)
						port map(
								EN		=>	EN,
								CLK		=>	CLK,
								FLUSH	=>	FLUSH,
								writeEN	=>	FifoRX_WR,
								readEN	=>	rxREAD,
								dataIN	=>	FifoRX_IN,
								dataOUT	=>	rxDATA,
								FULL	=>	FifoRX_FULL,
								EMPTY	=>	FifoRX_EMPTY
								);

	-- Setzten des FLAG Registers
	FREG <= "00" & FifoTX_EMPTY & FifoTX_FULL & "00" & FifoRX_EMPTY & FifoRX_FULL WHEN EN = '1' ELSE (others => '0');

	-- Empfangs / Sendedatenregister
	DATA <= setDATA WHEN TXE = '0' AND FLUSH = '0' ELSE (others => 'Z');
	getDATA <= DATA WHEN TXE = '1' AND FLUSH = '0' ELSE (others => 'Z');

	-- Lese/Schreib Befehle
	READ  <= intREAD  WHEN EN = '1' ELSE '1';
	WRITE <= intWRITE WHEN EN = '1' ELSE '1';

readDATA:	process(CLK)
					variable readCYCLE	:	boolean := false;
					variable readDONE	:	boolean := false;
					variable readSTROBE	:	STD_LOGIC_VECTOR(STROBESIZE - 1 downto 0) := (others => '1');
					
				begin
					if(rising_edge(CLK) and EN = '1') Then
						
						-- Wenn Empfangen aktiv
						if(TXE = '1' or readCYCLE = true or readDONE = true) Then
							
								-- Empfangsregister für STROBE
								readSTROBE := readSTROBE(STROBESIZE - 2 downto 0) & STROBE;
							
							-- Wenn Empfangfifo schreibvorgang abgeschlossen
							if(readDONE = true) Then
							
								FifoRX_WR <= '0';				-- Empfangs FIFO Schreibzyklus rücksetzten
								FifoRX_IN <= (others => '0');	-- Empfangs FIFO Eingang auf LOW
								
								-- Wenn Empfangszyklus abgeschlossen 
								if(readSTROBE(0) = '1' and readSTROBE(1) = '1' and readSTROBE(2) = '1') Then
								
									readDONE := false;			-- Lesen abgeschlossen rücksetzten
								
								end if;
							
							else
								-- Wenn Empfangsregister Bit 0 und Bit 1 auf LOW Daten Speichern
								if((readSTROBE(0) = '0' and readSTROBE(1) = '0' and readSTROBE(2) = '0') or readCYCLE = true) Then
								
									-- Bei erstem Zyklus daten abspeichern und Empfangsfifo beschreiben
									if(readCYCLE = false) Then
									
										FifoRX_WR <= '1';				-- Datenschrebien in lokalen FIFO aktivieren
										FifoRX_IN <= getDATA;			-- Daten auf FifoRX_IN legen
									
										readCYCLE := true;				-- Lesezyklus auf True um rückkehr zu ermöglichen	
									
									else
									
										FifoRX_WR <= '0';				-- Empfangs FIFO Schreibzyklus rücksetzten
										FifoRX_IN <= (others => '0');	-- Empfangs FIFO Eingang auf LOW
										
										readCYCLE := false;				-- Lesezyklus von FIFO abgeschlossen Zyklusvariable rücksetzen
										readDONE := true;				-- Rückgabe das Lesen abgeschlossen
										
									end if;
								end if;
							end if;
						end if;
					end if;
			end process readDATA;


writeDATA:	process(CLK)
		
					variable writeCYCLE	:	boolean := false;
					variable writeCLOCK	:	integer := 0;
					variable writeDATA	:	STD_LOGIC_VECTOR(DATASIZE - 1 downto 0) := (others => 'Z');

				begin
					if(rising_edge(CLK) and EN = '1') Then
					
						-- Wenn senden aktiv und Daten im sende FIFO
						if(TXE = '0' and (FifoTX_EMPTY = '0' or writeCYCLE = true)) Then
						
							-- Wenn sende FIFO Lesezyklus noch nicht ausgeführt
							if(writeCYCLE = false) Then
							
								FifoTX_RD <= '1';				-- Datenlesen aus sende FIFO aktivieren
								
								--writeDATA := (others => 'Z');
								writeCYCLE := true;				-- Schreibzyklus aktiv (TRUE)
								
							-- Wenn sende FIFO Lesezyklus ausgeführt
							else
							
									FifoTX_RD <= '0';				-- Daten aus sende FIFO lesen deaktivieren
									writeCLOCK := writeCLOCK + 1;	-- Schreibtakt inkrementieren
		
								-- Wenn Schreibtakt kleiner gleich Systemtakt / halber Sendetakt
								if(writeCLOCK <= (SYS_CLK/ (2 * WRITE_CLK))) Then
								
									-- Wenn Schreibtakt gleich 2
									if(writeCLOCK = 2) Then
									
										writeDATA := FifoTX_OUT;	-- Daten aus sende FIFO auf datenWR legen
									
									end if;
								
									intWRITE <= '1';				-- FIFO WR auf HIGH
									setDATA <= writeDATA;			-- Daten auf FIFO Datenleitung schreiben
								
								-- Wenn Schreibtakt größer Systemtakt / halber Sendetakt und Schreibtakt kleiner Systemtakt / Sendetakt 
								elsif(writeCLOCK > (SYS_CLK/ (2 * WRITE_CLK)) and writeCLOCK < (SYS_CLK/ WRITE_CLK)) Then
							
									intWRITE <= '0';				-- FIFO WR auf LOW (Daten übernehmen)
									setDATA <= writeDATA;			-- Daten in FIFO schreiben
								
								-- nach abgeschlossener Übertragung
								else
	
									setDATA <= (others => 'Z');		-- Prozess Datenwort auf HIGH-Z
									intWRITE <= '1';				-- FIFO WR auf HIGH
									writeDATA := (others => 'Z');	-- Prozess Datenwort rücksetzten
									writeCLOCK := 0;				-- Prozess Zähler rücksetzten
									writeCYCLE := false;			-- Prozess schreib Zyklus auf FALSE
								
								end if;
								
							end if;
						
						-- Wenn Richtungswechsel Senden -> Empfangen
						elsif(TXE = '1') Then
						
							intWRITE <= '1';						-- FIFO WR auf HIGH
							setDATA <= (others => 'Z');				-- FIFO Datenwort auf HIGH-Z
							
							FifoTX_RD <= '0';						-- Daten lesen aus sende FIFO deaktivieren
							
							writeDATA := (others => 'Z');			-- Prozess Datenwort auf HIGH-Z
							writeCLOCK := 0;						-- Prozess Schreibtakt rücksetzten
							writeCYCLE := false;					-- Prozess Scheibzyklus inaktiv (FALSE)
						
						end if;
					end if;
			end process writeDATA;

end Behavioral;
