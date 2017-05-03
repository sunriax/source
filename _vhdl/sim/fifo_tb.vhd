--	------------------------------------
--	Diplomarbeit elmProject@HTL-Rankweil
--	G.Raf@elmProject
--	2AAELI | 2016/2017
--	------------------------------------
--	File: fifo_tb.vhd
--	Version: v1.0
--	------------------------------------
--	Testbench zur fifo IP mit
--	Standardparametern.
--	------------------------------------

library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
-- niemals beide NUMERIC_STD und STD_LOGIC_ARITH verwenden!!!
--use IEEE.STD_LOGIC_ARITH.ALL;
use UNISIM.VComponents.all;

entity fifo_tb is
--  Port ( );
end fifo_tb;

architecture Simulation of fifo_tb is

-- Deklaration
constant CLK_period : time := 10 ns;	-- Simulationstakt (100 MHz)
constant simFIFO_ADDR	: natural := 4;
constant simFIFO_DATA	: natural := 8;

signal simEN, simCLK, simFLUSH	: STD_LOGIC;
signal simdataIN, simdataOUT	: STD_LOGIC_VECTOR(simFIFO_DATA - 1 downto 0);
signal simwriteEN, simreadEN	: STD_LOGIC;
signal simFULL, simEMPTY		: STD_LOGIC;

-- Komponentendeklaration
component fifo is
	Generic	(
			constant SYS_CLK	: integer range 0 to 100000000 := 100000000;	-- 100 MHz Systemtakt
			constant FIFO_ADDR	: integer range 0 to 1024		:= 128;			-- Speicherbreite in Byte
			constant FIFO_DATA	: integer range 0 to 8			:= 8			-- Datenbreite
			);
		Port(
			EN, CLK, FLUSH	: in  STD_LOGIC;										-- System Signale
			writeEN, readEN	: in  STD_LOGIC;										-- Lese/Schreib aktivierung
			dataIN			: in  STD_LOGIC_VECTOR (simFIFO_DATA - 1 downto 0);	-- Daten eingabe
			dataOUT			: out STD_LOGIC_VECTOR (simFIFO_DATA - 1 downto 0);	-- Daten ausgabe
			FULL, EMPTY		: out STD_LOGIC										-- VOLL / LEER rückgabe
			);
end component fifo;

begin

UUT:	fifo generic map(
						SYS_CLK		=>	100000000,
						FIFO_ADDR	=>	simFIFO_ADDR,
						FIFO_DATA	=>	simFIFO_DATA
						)
				port map(
						EN		=>	simEN,
						CLK		=>	simCLK,
						FLUSH	=>	simFLUSH,
						writeEN	=>	simwriteEN,
						readEN	=>	simreadEN,
						dataIN	=>	simdataIN,
						dataOUT	=>	simdataOUT,
						FULL	=>	simFULL,
						EMPTY	=>	simEMPTY
						);

-- Clock Singal erzeugen
CLK_process:	process
					begin
						simCLK <= '0';	wait for CLK_period/2;
						simCLK <= '1';	wait for CLK_period/2;
				end process CLK_process;

-- Simulationsprozess
process
		variable simFIFO_DEPTH : natural := 5;
		variable simDATA_WRITE : STD_LOGIC_VECTOR(simFIFO_DATA - 1 downto 0) := (others => '0');
	begin
		-- Initialisierung
		simEN <= '0';	simFLUSH <= '0';	simreadEN <= '0';	simwriteEN <= '0'; simdataIN <= (others => '0');	wait for CLK_PERIOD;
		simEN <= '1'; 																								wait for CLK_PERIOD;
		simDATA_WRITE := simDATA_WRITE + 1;

			for I in 0 to 5 loop
				simwriteEN <= '1'; simdataIN <= simDATA_WRITE;	wait for CLK_PERIOD;
				simDATA_WRITE := simDATA_WRITE + 1;
			end loop;
			
			simdataIN  <= (others => '0');
			simwriteEN <= '0';

			for J in 0 to 5 loop
				simreadEN <= '1';	wait for CLK_PERIOD;
			end loop;

			simreadEN <= '0';

			for K in 0 to 20 loop
				simwriteEN <= '1'; simdataIN <= simDATA_WRITE;	wait for CLK_PERIOD;
				simreadEN <= '1';
				simDATA_WRITE := simDATA_WRITE + 1;
			end loop;
			
			simdataIN  <= (others => '0');
			simwriteEN <= '0';
			simreadEN <= '0';

			for I in 0 to 10 loop
				simwriteEN <= '1'; simdataIN <= simDATA_WRITE;	wait for CLK_PERIOD;
				simDATA_WRITE := simDATA_WRITE + 1;
			end loop;
			
			simdataIN  <= (others => '0');
			simwriteEN <= '0';
			
			--FLUSH complete FIFO
			simFLUSH <= '1';						wait for CLK_PERIOD * 2;
			simFLUSH <= '0';
		
		wait;
		
end process;


end Simulation;
