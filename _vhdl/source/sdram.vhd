--	-------------------------------------
--	Diplomarbeit elmProject@HTL-Rankweil
--	G�CHTER Raffael
--	elm-project@hotmail.com
--	2AAELI | 2016/2017
--	-------------------------------------
--	File: sdram.vhd
--	Version: v1.0
--	-------------------------------------
--	SDRAM Controller, ohne integrierten
--	refresh zyklus. Muss alle 8192 Zyklen
--	ausgef�hrt werden. siehe Datenblatt
--	-------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- niemals beide NUMERIC_STD und STD_LOGIC_ARITH verwenden!!!
use IEEE.NUMERIC_STD.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;

entity sdram is
	Generic	(
			-- Systemkonstanten
			constant SYS_CLK	: integer range 0 to 400000000 := 167000000;	-- 167 MHz Systemtakt (5,988 ns)
	
			-- SDRAM Systemkonstanten
			constant CMD_range		:	integer := 4;			-- Befehlsbreite
			constant ADDR_range		:	integer := 13;			-- Addressbreite
			constant BANK_range		:	integer := 2;			-- Bankbreite
			constant DIR_range		:	integer := 2;			-- DQM Breite
			constant DATA_range		:	integer := 16;			-- Datenbreite
			constant MEMORY_size	:	integer := 4194303;	-- Speichergr��e
			constant ROW_size		:	integer := 8192;		-- Reihengr��e
			constant COL_size		:	integer := 512;		-- Spaltengr��e
			
			-- SDRAM I/O konstanten
			constant PIN_PRECHARGE	:	integer := 10;			-- Precharge PIN (A10)
			
			-- SDRAM Verz�gerungskonstanten
			constant delayINIT		:	integer := 16700;		-- Takte bis SDRAM initialisiert (100us)
			constant delayPRECHARGE	:	integer := 3;			-- Takte bis PRECHARGE Befehl ausgef�hrt (18ns)
			constant delayREFRESH	:	integer := 10;			-- Tatke bis AUTO REFRESH Befehl ausgef�hrt (66ns)
			
			-- SDRAM Zyklischekonstanten
			constant cycleREFRESH	:	integer := 8192;		-- Takte bis Refresh ausgef�hrt werden muss.
			
			
			-- SDRAM Kommandos | CS# | RAS# | CAS# | WE# |
			constant CMD_INHIBIT		:	STD_LOGIC_VECTOR(3 downto 0) := b"1" & "XXX";	-- Inhibit (NOP)
			constant CMD_NOP			:	STD_LOGIC_VECTOR(3 downto 0) := b"0111";			-- No Operation (NOP)
			constant CMD_ACTIVE			:	STD_LOGIC_VECTOR(3 downto 0) := b"0011";			-- ACTIVE (select band an activate row)
			constant CMD_READ			:	STD_LOGIC_VECTOR(3 downto 0) := b"0101";			-- READ (select bank an column, ans start READ burst)
			constant CMD_WRITE			:	STD_LOGIC_VECTOR(3 downto 0) := b"0100";			-- WRITE (select bank and column, and start WRITE burst)
			constant CMD_TERMINATE		:	STD_LOGIC_VECTOR(3 downto 0) := b"0110";			-- Burst Terminate
			constant CMD_PRECHARGE		:	STD_LOGIC_VECTOR(3 downto 0) := b"0010";			-- (Deaktivate row in bank or banks)
			constant CMD_REFRESH		:	STD_LOGIC_VECTOR(3 downto 0) := b"0001";			-- AUTO/SELF REFRESH (enter self refresh mode)
			constant CMD_MODE			:	STD_LOGIC_VECTOR(3 downto 0) := b"0000";			-- No Operation
			
			
			-- Richtungsregister (Output /  HIGH-Z)
			constant WRITE_ENABLE		:	STD_LOGIC_VECTOR(1 downto 0) := b"00";	-- DQM (Output ENABLE)
			constant WRITE_INHIBIT		:	STD_LOGIC_VECTOR(1 downto 0) := b"11";	-- DQM (Output HIGH-Z)
			
			-- Systemkonstanten
			constant BLOCK_size		:	integer := 512;		-- Blockgr��e
			constant PAGE_size		:	integer := 8192;		-- Seitengr��e
			constant MODE_range		:	integer := 4;			-- Modusbreite
			constant FREG_range		:	integer := 7;			-- Statusbreite
			
			-- Systemmodis
			constant CMD_SINGLE		:	STD_LOGIC_VECTOR(3 downto 0) := b"1001";
			constant CMD_BLOCK		:	STD_LOGIC_VECTOR(3 downto 0) := b"1010";
			constant CMD_PAGE		:	STD_LOGIC_VECTOR(3 downto 0) := b"1100"
			);
		Port(
			-- Standard I/Os
			EN				:	in	STD_LOGIC;
			CLK				:	in	STD_LOGIC;
			FLUSH			:	in	STD_LOGIC;
			
			-- SDRAM Steuer I/Os
			ENABLE			:	out	STD_LOGIC;										-- SDRAM CKE Signal
			COMMAND			:	out	STD_LOGIC_VECTOR(CMD_range  - 1 downto 0);	-- Kommando Ausgabe
			ADDRESS			:	out	STD_LOGIC_VECTOR(ADDR_range - 1 downto 0);	-- Adress Ausgabe
			BANK			:	out	STD_LOGIC_VECTOR(BANK_range - 1 downto 0);	-- Bank Ausgabe
			DIRECTION		:	out	STD_LOGIC_VECTOR(DIR_range  - 1 downto 0);	-- Datenflussrichtung Ausgabe
			
			-- SDRAM Daten I/Os
			DATA			:	inout STD_LOGIC_VECTOR(DATA_range - 1 downto 0);
			
			-- Schreib/Lese I/Os
			ADDR_POINTER	:	in	STD_LOGIC_VECTOR(ADDR_range - 1 downto 0);
			BANK_POINTER 	:	in	STD_LOGIC_VECTOR(BANK_range - 1 downto 0);
			
			WRITE			:	in	STD_LOGIC;
			READ			:	in	STD_LOGIC;
			inDATA			:	in  STD_LOGIC_VECTOR(DATA_range - 1 downto 0);
			outDATA			:	out STD_LOGIC_VECTOR(DATA_range - 1 downto 0);
			
			MODE_COMMAND	:	in	STD_LOGIC_VECTOR(MODE_range - 1 downto 0);
			
			FREG			:	out STD_LOGIC_VECTOR(FREG_range downto 0)
			);
end sdram;

architecture Behavioral of sdram is

		-- Interne Signale zum Ausf�hren von Befehlen
		signal intINIT			:	boolean := false;													-- Initialisation abgeschlossen
		signal intREFRESH		:	boolean := false;
		
		-- Interne Flag Register zur Status�bergabe an Prozesse
		signal intFLAG_REFRESH	:	boolean := false;
		signal intFLAG_EXECUTE	:	boolean := false;
		
		signal intCKE		:	STD_LOGIC	:= '0';													-- Takt aktivieren
		signal intADDRESS	:	STD_LOGIC_VECTOR(ADDR_range - 1 downto 0) := (others => '1');		-- interne Adressvariable 
		signal intCOMMAND	:	STD_LOGIC_VECTOR(CMD_range  - 1 downto 0) := (others => '1');		-- interne Kommandovariable
		signal intBANK		:	STD_LOGIC_VECTOR(BANK_range - 1 downto 0) := (others => '0');		-- interne Bankvariable
		signal intDATA		:	STD_LOGIC_VECTOR(DATA_range - 1 downto 0) := (others => 'Z');		-- interne Datenvariable
		signal intWRITE		:	STD_LOGIC := '0';
		signal intREAD		:	STD_LOGIC := '0';	
		
		signal lastCOMMAND	:	STD_LOGIC_VECTOR(CMD_range - 1 downto 0)	:= (others => '0');		-- zuletzt ausgef�hrtes Kommando abspeichern
		
	begin

-- Schreiben interner Daten auf I/O Pins
ENABLE	<= intCKE     WHEN EN = '1' ELSE '0';
COMMAND <= intCOMMAND WHEN EN = '1' ELSE (others => '1');
ADDRESS <= intADDRESS WHEN EN = '1' ELSE (others => '1');
BANK	<= intBANK	  WHEN EN = '1' ELSE (others => '0');

DATA	<= intDATA    WHEN EN = '1' AND intWRITE = '1' AND intREAD = '0' ELSE (others => 'Z');
intDATA	<= DATA		  WHEN EN = '1' AND intREAD = '1' AND intWRITE = '0' ELSE (others => 'Z');

-- Einstellen interner Daten
intINIT <= false WHEN EN = '0' OR FLUSH = '1';

-- Anzeigen von Status
intFLAG_REFRESH	<= false WHEN EN = '0' OR FLUSH = '1';
intFLAG_EXECUTE	<= false WHEN EN = '0' OR FLUSH = '1';

-- Ausf�hren von Kommandos
intREFRESH <= false WHEN EN = '0' OR FLUSH = '1';

-- RAM Aktualisierungssignalisation (AUTO REFRESH)
COUNTER:	process(CLK)
					variable refreshCOUNTER	:	integer := 0;	-- Interner Aktualisierungsz�hler
				begin
					if(rising_edge(CLK) and EN = '1') Then
					
						-- Wenn Initialisierung abgeschlossen
						if(intINIT = true) Then
							
							-- Wenn Aktualisierungsz�hler - max. Schreib/Lesem�glichkeit pro Befehl 
							if(refreshCOUNTER >= cycleREFRESH - COL_size) Then
								
								intFLAG_REFRESH <= true;	-- Aktualisierung muss demn�chst erfolgen
							
							-- Wenn Aktualisierungsz�hler auf maximalwert
							elsif(refreshCOUNTER = cycleREFRESH - 1) Then
							
								intREFRESH <= true;			-- Aktualisierungsbefehl ausf�hren
							
							-- Aktualisierungsz�hler 
							else
							
								intFLAG_REFRESH <= false;	-- Aktualisierungsflag r�cksetzten
								
								refreshCOUNTER := 0;		-- Z�hler r�cksetzten und von vorne beginnen
								
							end if;
						
						-- Wenn Initialisierung nicht abgeschlossen
						else
							
							intREFRESH <= false;			-- Aktualisierungsrefresh r�cksezten
							intFLAG_REFRESH <= false;		-- Aktualisierungsflagge r�cksetzten
								
							refreshCOUNTER := 0;			-- Z�hler r�cksetzten und von vorne beginnen
						
						end if;
					end if;
			end process;


			-- AUTO REFRESH
AUTOREFRESH:	process(CLK)
						variable refreshEXECUTE		:	boolean := false;	-- Interne Ausf�hrungsvariable
						variable refreshPRECHARGE	:	boolean := false;	-- Interne PRECHARGE ausf�hrungs variable
						variable refreshRUN			:	boolean := false;	-- Interne REFRESH Befehl Ausf�hrungsvariable
						
						variable refreshCOUNT		:	integer := 0;		-- Interne Taktz�hlvariable
					begin
						if(rising_edge(CLK) and EN = '1') Then
							
							-- Wenn REFRESH Befehl aufgerufen oder REFRESH Befehl abgearbeitet wird
							if(intREFRESH = true or refreshEXECUTE = true) Then
							
								refreshEXECUTE := true;	-- Eingang in Refresh Befehl erfolgt
								
								-- Wenn kein Befehl ausgef�hrt wird dann REFRESH ausf�hren
								if(intFLAG_EXECUTE = false or refreshRUN = true) Then
									
									intFLAG_EXECUTE <= true;		-- Befehl wird ausgef�hrt
									refreshRUN := true;				-- Refresh Befehl ausf�hren
								
									if(refreshCOUNT = 0) Then
										
										intCOMMAND <= CMD_PRECHARGE;		-- Precharge Befehl ausf�hren
										intADDRESS <= (others => '0');		-- Addressen r�cksetzen
										intADDRESS(PIN_PRECHARGE) <= '1';	-- Precharge auf alle Banken anwenden
										intBANK <= (others => '0');			-- Banks auf LOW setzten (nicht notwendig)
									
									elsif(refreshCOUNT = 1) Then
										
										intCOMMAND <= CMD_NOP;				-- NOP Befehl ausf�hren
									
									elsif(refreshCOUNT <= 2 and refreshCOUNT < cycleREFRESH + 2) Then
																				
										intCOMMAND <= CMD_REFRESH;			-- AUTOREFRESH Befehl ausf�hren
																			
																			
									
									
									end if;
								
								
								end if;
							
							
							end if;
					
						end if;
				end process AUTOREFRESH;


		-- System Initialisation
INIT:	process(CLK)
				variable initCOUNT	:	integer := 0;		-- interne Initialisierungs Z�hlvariable
			begin
				if(rising_edge(CLK)) Then
				
					-- Wenn Enable inaktiv
					if(EN = '0' or FLUSH = '1') Then
					
						initCOUNT := 0;		-- Z�hler zur�cksetzten
					
					else
				
						-- Wenn Initialisierung noch nicht durchgef�hrt
						if(intINIT = false) Then
							intCKE <= '1';						-- Takt Aktivieren
							intCOMMAND <= CMD_INHIBIT;			-- Befehl Inhibit/NOP ausf�hren
							
							-- �berpr�fen ob Initialisierungszyklus abgeschlossen
							if(initCOUNT < delayINIT) Then
								
								intCOMMAND <= CMD_NOP;			-- Befehl NOP ausf�hren
								
								initCOUNT := 0;					-- Initialisierungsz�hler r�cksezen
							
							-- Wenn Initialisierung abgeschlossen PRECHARGE ausf�hren
							elsif(initCOUNT <= delayINIT) Then
								
								intADDRESS(PIN_PRECHARGE) <= '1';	-- AUTO-Precharge Mode einstellen
								intCOMMAND <= CMD_PRECHARGE;	-- Befehl PRECHARGE ALL (Alle Banken) ausf�hren
							
							-- Wenn PRECHARGE ausgef�hrt NOP ausf�hren
							elsif(initCOUNT <= delayINIT + delayPRECHARGE + 1) Then
							
								intADDRESS(PIN_PRECHARGE) <= 'X';	-- AUTO-Precharge Mode einstellen
								intCOMMAND <= CMD_NOP;			-- Befehl NOP w�hrend PRECHARGE ausf�hren
							
							-- Wenn PRECHARGE ausgef�hrt AUTO REFRESH ausf�hren
							elsif(initCOUNT <= delayINIT + delayPRECHARGE + 2) Then
							
								intCOMMAND <= CMD_REFRESH;		-- Befehl REFRESH ausf�hren
							
							-- Wenn AUTO REFRESH ausgef�hrt NOP ausf�hren
							elsif(initCOUNT <= delayINIT + delayPRECHARGE + delayREFRESH + 2) Then
															
								intCOMMAND <= CMD_NOP;			-- Befehl REFRESH ausf�hren
							
							-- Wenn AUTO REFRESH ausgef�hrt erneut ausf�hren
							elsif(initCOUNT <= delayINIT + delayPRECHARGE + delayREFRESH + 3) Then
								
								intCOMMAND <= CMD_REFRESH;		-- Befehl REFRESH ausf�hren
							
							-- Wenn AUTO REFRESH ausgef�hrt NOP ausf�hren
							elsif(initCOUNT <= delayINIT + delayPRECHARGE + 2 * delayREFRESH + 3) Then
																						
								intCOMMAND <= CMD_NOP;			-- Befehl REFRESH ausf�hren
							
							else
							
								intCOMMAND <= CMD_NOP;			-- Kein Befehl ausf�hren
								lastCOMMAND <= intCOMMAND;		-- Leztes Kommando speichern
								intINIT <= true;				-- Initialisierung abgeschlossen
							
							end if;
							
								initCOUNT := initCOUNT + 1;		-- Initialisierungsz�hler erh�hen
							
						end if;
					end if;
				end if;
		end process INIT;


PRECHARGE:	process(CLK)
				begin
				
			
			
			end process PRECHARGE;





end Behavioral;
