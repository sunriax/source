--	------------------------------------
--	Diplomarbeit elmProject@HTL-Rankweil
--	G.Raf@elmProject
--	2AAELI | 2016/2017
--	------------------------------------
--	File: master.vhd
--	Version: v1.0
--	------------------------------------
--	UART Schnittstelle zum FPGA
--	VOLLDUPLEX mit Lese/Schreib Buffer,
--	Parit�tsbit und 2 Stoppbit.
--	Software Handshake XON/XOFF auf
--	Remotesystem m�glich.
--	
--	!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
--	Parit�tsfehler werden erkannt jedoch
--	nicht behandelt. Erneute Sendeanfrage
--	muss extern durchgef�hrt werden
--	!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
--	
--	8E1 |A|D0|D1|D2|D3|D4|D5|D6|D7|P|E|E|
--	-------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart is
	Generic	(
			constant SYS_CLK	: integer range 0 to 200000000	:= 100000000;	-- 100 MHz Systemtakt	
			constant BAUD		: integer range 0 to 921600		:= 921600;		-- Bits / Sekunde (BAUD)
			constant QUANTIL	: integer range 0 to 16			:= 12;			-- Abtastungen / Bit
			constant DATASIZE	: integer range 0 to 9			:= 8;			-- Datenbit L�nge
			constant PARITY		: integer range 0 to 1			:= 1;			-- Parity Bit Length
			constant STOPBIT	: integer range 0 to 2			:= 2;			-- Anzahl der Stoppbits
			constant PARITYBIT	: STD_LOGIC						:= '0';			-- 0=Even/1=Odd (unwirksam wenn PARITY auf 0)
			constant HANDSHAKE	: STD_LOGIC						:= '1';			-- Software Handschake XON/XOFF (nur f�r Remotesystem)
																				-- Uart sendet kein XON/XOFF da normalerweise nicht notwendig
			constant FIFO_DEPTH	: integer range 0 to 128		:= 80			-- max. Anzahl m�glicher Zeichen (f�r Befehlscoder/decoder)
			);
		Port(
			EN		:	in	STD_LOGIC;													-- Modul aktiv
			CLK		:	in	STD_LOGIC;													-- Systemtakt
			FLUSH	:	in	STD_LOGIC;													-- Alles leeren
			WRITE	:	in	STD_LOGIC;													-- Daten auf UART schreiben
			READ	:	in 	STD_LOGIC;													-- Daten von UART lesen
			dataWR	:	in	STD_LOGIC_VECTOR(DATASIZE - 1 downto 0);					-- Daten �ber UART Senden
			dataRD	:	out	STD_LOGIC_VECTOR(DATASIZE - 1 downto 0):= (others => '0');	-- Daten �ber UART Empfangen
			RxD		:	in	STD_LOGIC;													-- Recieve Data
			TxD		:	out	STD_LOGIC	:= '1';											-- Transmit Data
			FREG	:	out	STD_LOGIC_VECTOR (7 downto 0) := (others => '0')			-- Flagregister	
			);
end uart;

----------------------------------------------
--	>FREG	REFL | BUFE | BUFF | REDA |		--
--		Initialisierungswert 0x00			--
--		LSB	-> REBF	Receive Buffer full		--
--			-> REBE Receive Buffer empty	--
--			-> REFF	Receive Frame fault		--
--			-> REFP	Receive Parity fault	--
--			-> TRBF	Transmit Buffer full	--
--			-> TRBE	Transmit Buffer empty	--
--			-> N.C.							--
--		MSB	-> N.C.							--
----------------------------------------------

architecture Behavioral of uart is
	-- Systemkonstanten
	constant BIT_SIZE	: natural := (SYS_CLK/BAUD) - 1;
	constant FRAME_SIZE	: natural := 1 + DATASIZE + PARITY + STOPBIT;
	constant XON		: STD_LOGIC_VECTOR(7 downto 0) := x"11";	-- XON (Sendefreigabe/Empfangsfreigabe)
	constant XOFF		: STD_LOGIC_VECTOR(7 downto 0) := x"13";	-- XOFF (Sendestopp/Empfangsstopp)
	
	-- Systemvariablen
	signal intCTS	:	STD_LOGIC := '1';
	signal intRTS	:	STD_LOGIC := '1';
	signal intRXD	:	STD_LOGIC := '1';
	signal intTXD	:	STD_LOGIC := '1';

	-- Interne Flageregister Signale
	signal REFF	:	STD_LOGIC := '0';
	signal REBF	:	STD_LOGIC := '0';
	signal REBE	:	STD_LOGIC := '0';
	signal REFP	:	STD_LOGIC := '0';
	signal TRDA	:	STD_LOGIC := '0';
	signal TRBF	:	STD_LOGIC := '0';
	signal TRBE	:	STD_LOGIC := '0';
	signal TRFL	:	STD_LOGIC := '0';

	-- TX FIFO Signals
	signal FifoTX_RD	:	STD_LOGIC := '0';
	signal FifoTX_FULL	:	STD_LOGIC;
	signal FifoTX_EMPTY	:	STD_LOGIC;
	signal FifoTX_OUT	:	STD_LOGIC_VECTOR(7 downto 0);

	-- RX FIFO Signals
	signal FifoRX_WR	:	STD_LOGIC := '0';
	signal FifoRX_RD	:	STD_LOGIC := '0';
	signal FifoRX_FULL	:	STD_LOGIC;
	signal FifoRX_EMPTY	:	STD_LOGIC;
	signal FifoRX_IN	:	STD_LOGIC_VECTOR(7 downto 0);

-- FIFO Komponente deklarieren
component fifo is
	Generic	(
		constant SYS_CLK	: integer;
		constant FIFO_ADDR	: integer;
		constant FIFO_DATA	: integer
		);
	Port(
		EN				: in  STD_LOGIC;
		CLK				: in  STD_LOGIC;
		FLUSH			: in  STD_LOGIC;
		writeEN			: in  STD_LOGIC;
		readEN			: in  STD_LOGIC;
		dataIN			: in  STD_LOGIC_VECTOR(DATASIZE - 1 downto 0);
		dataOUT			: out STD_LOGIC_VECTOR(DATASIZE - 1 downto 0) := (others => '0');
		FULL			: out STD_LOGIC := '0';
		EMPTY			: out STD_LOGIC := '0'
		);
end component fifo;

begin

	-- Einbinden des Sende FIFO (16 Byte Speicherpl�tze)
	txFIFO:	fifo	generic map	(
					 			SYS_CLK		=>	SYS_CLK,
					 			FIFO_ADDR	=>	FIFO_DEPTH,
					 			FIFO_DATA	=>	DATASIZE
					 			)
						port map(
								EN		=>	EN,
								CLK		=>	CLK,
								FLUSH	=>	FLUSH,
								writeEN	=>	WRITE,
								readEN	=>	FifoTX_RD,
								dataIN	=>	dataWR,
								dataOUT	=>	FifoTX_OUT,
								FULL	=>	FifoTX_FULL,
								EMPTY	=>	FifoTX_EMPTY
								);

	-- Einbinden des Empangs FIFO (16 Byte Speicherpl�tze)
	rxFIFO:	fifo 	generic map	(
					 			SYS_CLK		=>	SYS_CLK,
					 			FIFO_ADDR	=>	FIFO_DEPTH,
					 			FIFO_DATA	=>	DATASIZE
					 			)
						port map(
								EN		=>	EN,
								CLK		=>	CLK,
								FLUSH	=>	FLUSH,
								writeEN	=>	FifoRX_WR,
								readEN	=>	READ,
								dataIN	=>	FifoRX_IN,
								dataOUT	=>	dataRD,
								FULL	=>	FifoRX_FULL,
								EMPTY	=>	FifoRX_EMPTY
								);

	-- Setzten des FLAG Registers
	FREG <=  "00" & TRBE & TRBF & REFP & REFF & REBE & REBF WHEN EN = '1' ELSE (others => '0');
	
	-- Setzen der einzelen Flags
	TRBE <= FifoTX_EMPTY;
	TRBF <= FifoTX_FULL;
	
	REBE <= FifoRX_EMPTY;
	REBF <= FifoRX_FULL;

	TXD <= intTXD WHEN EN = '1' ELSE '1';
	intRXD <= RXD WHEN EN = '1' ELSE '1';

RECEIVE:	process(CLK, intRXD, FifoRX_FULL, FifoRX_IN, intCTS, intRTS)
					-- Emp�nger Prozesskonstanten
					constant rxBITEDGE1	: STD_LOGIC_VECTOR((BIT_SIZE / 2) + 1 downto (BIT_SIZE / 2)) := (others => '1');	-- Flankenerkennungskonstante HIGH Teil
					constant rxBITEDGE0	: STD_LOGIC_VECTOR((BIT_SIZE / 2) - 1 downto 0) := (others => '0');					-- Flankenerkennungskonstante LOW Teil
					
					-- Emp�nger Prozessvariablen
					variable rxBIT_CNT	: integer := 0;																		-- Bit Z�hler (0 bis SYS_CLK/BAUD)
					variable rxBIT_POS	: integer := 0;																		-- Bit Position (0 bis max. 13)
					variable rxSTARTBIT	: STD_LOGIC_VECTOR((BIT_SIZE / 2) + 1 downto 0) := (others => '1');					-- Flankenerkennung (Startbit)
					variable rxDATA		: STD_LOGIC_VECTOR(DATASIZE - 1 downto 0) := (others => '0');						-- Datenwort der seriellen �bertragung
					variable rxWATCH	: STD_LOGIC_VECTOR(2 downto 0);														-- Anzahl der zu vergleichnenden Bits bei Bitabtastung
					variable rxPARITY	: STD_LOGIC := PARITYBIT;															-- Paritybit (Even/Odd) im Header einzustellen
					variable rxCOMPLETE	: boolean := true;																	-- �bertragung abgeschlossen
				begin

					if(rising_edge(CLK)) Then
						
						-- Wenn System inaktiv oder FLUSH aktiviert
						if(EN = '0' or FLUSH = '1') Then
						
							rxBIT_CNT := 0;					-- Bitz�hlvariable (0 bis SYS_CLK/BAUD)
							rxBIT_POS := 0;					-- Bitpositionsvariable (0 bis max. 13) r�cksetzten
							rxSTARTBIT := (others => '1');	-- Startbiteintaktungsvariable r�cksetzen
							rxDATA := (others => '1');		-- Datenwort r�cksetzen
							rxCOMPLETE := true;				-- �bertragung abgeschlossen auf TRUE
							
							FifoRX_WR <= '0';				-- Buffer Daten schreiben auf LOW
							FifoRX_IN <= (others => '0');	-- Buffer Dateneingang auf LOW
							
							intRTS <= '1';					-- Request to Send auf HIGH
							
							REFP <= '0';					-- Empf�nger Parit�tsfehler auf 0
							REFF <= '0';					-- Empf�nger Rahmenfehler auf 0
							
						-- Wenn System aktiv
						else
						
							-- �berpr�fen ob Empfangsbuffer voll
							if(FifoRX_FULL = '0') Then
							
								-- Bereit zum Empfangen
								intRTS <= '1';
							
								-- Wenn �bertragung abgeschlossen
								if(rxCOMPLETE = true) Then
								
									-- Fifo Schreibvorgang abschlie�en
									if(FifoRX_WR='1') Then
										FifoRX_WR <= '0';	-- Schreibvorgang zur�cksetzten
	
									-- Fifo Schreibvorgang abgeschlossen
									else
										
										rxSTARTBIT := rxSTARTBIT((BIT_SIZE/2) downto 0) & intRXD;		-- Startbiteintaktung
										rxBIT_CNT  := 0;												-- Bitz�hlvariable (0 bis SYS_CLK/BAUD) r�cksetzen
										rxBIT_POS  := 0;												-- Bitpositionsvariable (0 bis max. 13) r�cksetzten
										rxDATA := (others => '0');										-- Datenwort r�cksetzten
										rxWATCH := (others => '0');										-- Beobachtungsbits r�cksetzten
									
										-- �berpr�fen auf neue �bertragung
										if(rxSTARTBIT = rxBITEDGE1 & rxBITEDGE0) Then
											rxCOMPLETE := false;										-- �bertragung auf FALSE (�bertragung erfolgt)
											
											REFP <= '0';												-- Parit�tsfehler r�cksetzen
											REFF <= '0';												-- Rahmenfehler r�cksetzten
										end if;
									
									end if;
								else						
	
										-- Abtastvariable mit Werten f�llen
										if(rxBIT_CNT > BIT_SIZE - 2 and rxBIT_CNT < BIT_SIZE + 2) Then
											rxWATCH := rxWATCH(1 downto 0) & intRXD;					-- Eingabgsdaten in rxWATCH schieben
										
										-- Abtastung �berpr�fen und speichern
										elsif(rxBIT_CNT >= BIT_SIZE + 2) Then
										
											-- Wenn Abtastung komplette (LOW oder HIGH)
											if(rxWATCH = "000" or rxWATCH = "111") Then
											
												-- Wenn Bitposition kleiner Datengr��e Datenwort beschreiben
												if(rxBIT_POS < DATASIZE) Then
													rxDATA(rxBIT_POS) := rxWATCH(0) and rxWATCH(1) and rxWATCH(2);	-- Daten in Datenwort schreiben
												else
													-- Parity und Stoppbits
													
													if(rxBIT_POS = (DATASIZE - 1 + PARITY) and PARITY = 1) Then
														
														-- Parit�ts Checksumme erzeugen
															rxPARITY := PARITYBIT;
														for I in rxDATA'RANGE loop
															rxPARITY := rxPARITY xor rxDATA(I);
														end loop;
													
															rxPARITY := rxPARITY xor (rxWATCH(0) and rxWATCH(1) and rxWATCH(2)) ;
													
														-- Parit�tsauswertung
														if(rxPARITY = '1') Then
															REFP <= '1';
														end if;
													
													-- Stoppbit erreicht
													elsif(rxBIT_POS >= (FRAME_SIZE - STOPBIT)) Then
														
														-- Rahmenfehler wenn Stoppbit nicht erkannt
														if(rxWATCH /= "111") Then
														
															REFF <= '1';	-- Rahmenfehler ausgeben
														
														end if;
														
															rxCOMPLETE := true;				-- �bertragung abgeschlossen
															rxSTARTBIT := (others => '1');	-- Flankenerkennung auf HIGH
														
														-- Empf�nger Buffer voll
														if(rxDATA = XOFF and HANDSHAKE = '1') Then
															
															intCTS <= '0';			-- Clear to Send auf Low
														
														-- Empf�nger Buffer bereit
														elsif(rxDATA = XON and HANDSHAKE = '1') Then
														
															intCTS <= '1';			-- Clear to Send auf HIGH
														
														-- Standard�bertragung
														else
														
															FifoRX_WR <= '1';		-- FIFO Daten schreiben aktivieren
															FifoRX_IN <= rxDATA;	-- Empfangsdaten auf FIFO Buffer legen
														
														end if;
														
													end if;
													
												end if;	
												
												rxBIT_POS := rxBIT_POS + 1;		-- Bitposition inkrementieren
											
											-- Wenn Abtastungsbits nicht identisch
											else
											
												REFF <= '1';					-- Rahmenfehler ausgeben
												
											end if;
										
											rxBIT_CNT := 2;						-- Bitz�hler auf 2 (da Abfrage auf rxBIT_CNT >= BIT_SIZE + 2)
										end if;
											
											rxBIT_CNT := rxBIT_CNT + 1;			-- Bitz�hler inkrementieren
											
								end if;
							
							else
							
								-- Interner Empfangsbuffer voll
								intRTS <= '0';
							
							end if;
						end if;
					end if;
			end process RECEIVE;

TRANSMIT:	process(EN, CLK, FifoTX_EMPTY, FifoTX_OUT, intCTS)
					-- Prozesskonstanten
					constant txSTOPBIT	: STD_LOGIC_VECTOR(STOPBIT - 1 downto 0) := (others => '1');
					-- Prozessvariablen
					variable txBAUD_CLK : integer := 0;
					variable txBIT_POS	: integer := 0;
					variable txDATA		: STD_LOGIC_VECTOR(DATASIZE - 1 downto 0)	:= (others => '0');
					variable txFRAME	: STD_LOGIC_VECTOR(FRAME_SIZE - 1 downto 0) := (others => '1');
					variable txPARITY	: STD_LOGIC := PARITYBIT;
					-- Prozess Sendevariablen
					variable txCOMPLETE	: boolean := false;
					variable txPAUSE	: boolean := false;
					variable txREADOUT	: boolean := false;
					variable txPROTECT	: boolean := false;
					
				begin
					if(rising_edge(CLK)) Then
					
						-- Wenn �bertragung abgeschlossen
						if(txCOMPLETE = true) Then
							
								intTXD <= '1';	-- TXD Signal auf HIGH

							-- Wenn Cleat to Send HIGH oder Leseschutz aktiv
							if(intCTS = '1' or txPROTECT = true) Then
							
								-- Wenn Buffer nicht leer und Auslesen False
								if(FifoTX_EMPTY = '0' and txREADOUT = false) Then
									
									FifoTX_RD <= '1';	-- Auslesen aktivieren
									txREADOUT := true;	-- Auslesevariable aktivieren
									txPROTECT := true;	-- Ausleseschutz aktivieren
							
								-- Wenn Auslesevariable aktiv
								elsif(txREADOUT = true) Then
								
									-- Wenn Buffer auslesen aktiv und Auslesevariable aktiv
									if(FifoTX_RD = '1' and txREADOUT = true) Then
									
										FifoTX_RD <= '0';	-- Auslesevariable r�cksetzten
							
									-- Wenn Daten aus Buffer entnommen
									else
									
										txDATA := FifoTX_OUT;	-- Daten in Variable schreiben
		
										-- Parit�ts Checksumme erzeugen
											txPARITY := PARITYBIT;
										for I in txDATA'RANGE loop
											txPARITY := txPARITY xor FifoTX_OUT(I);
										end loop;
		
										txFRAME := txSTOPBIT & txPARITY & txDATA & "0";	-- Datenframe erzeugen
										
										txCOMPLETE := false;	-- �bertragung abgeschlossen r�cksetzen (neue �bertragung steht an)
										txREADOUT  := false;	-- Auslesen r�cksetzten
										txPROTECT  := false;	-- Ausleseschutz r�cksetzten
									
									end if;
							
								end if;
							end if;
						
						-- Wenn Auselesen und Freigabe erfolgt �bertragung starten
						else
							
							-- Wenn UART Takt variable gr��er 1 Bit ((SYS_CLK/BAUD) - 1)
							if(txBAUD_CLK >= BIT_SIZE) Then
								
									intTXD <= txFRAME(0);									-- TXD Signal auf aktuelles Datenbit
									txFRAME := '0' & txFRAME((FRAME_SIZE - 1) downto 1);	-- n�chstes Datenbit rechts schieben
				
								-- Wenn Stopbit erreicht
								if(txBIT_POS = FRAME_SIZE - 1) Then
									
									txBIT_POS := 0;				-- Bitposition r�cksetzten
									txCOMPLETE := true;			-- �bertragung abgeschlossen
									txFRAME := (others => '1');	-- Rahmen r�cksetzten
								
								-- Wenn Stopbit nicht erreicht
								else
								
									txBIT_POS := txBIT_POS + 1;	-- Bitposition erh�hen
									txCOMPLETE := false;		-- �bertragung nicht abgeschlossen
								
								end if;	
							
									txBAUD_CLK := 0;			-- UART Takt r�cksetzten
							
							end if;
				
							txBAUD_CLK := txBAUD_CLK + 1;		-- UART Takt inkrementieren
						
						end if;
					end if;
			end process TRANSMIT;
end Behavioral;

