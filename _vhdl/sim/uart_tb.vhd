--	------------------------------------
--	Diplomarbeit elmProject@HTL-Rankweil
--	G.Raf@elmProject
--	2AAELI | 2016/2017
--	------------------------------------
--	File: display_tb.vhd
--	Version: v1.0
--	------------------------------------
--	Testbench zur display IP mit
--	Standardparametern.
--	------------------------------------

library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
use UNISIM.VComponents.all;

entity uart_tb is
--  Port ( );
end uart_tb;

architecture Simulation of uart_tb is

	-- Deklaration
	constant CLK_period : time := 10 ns;	-- Simulationstakt (100 MHz)
	constant UART_DATA	: positive := 8;
	
	signal simEN, simCLK, simFLUSH	: STD_LOGIC;
	signal simWRITE, simREAD		: STD_LOGIC;
	signal simdataWR, simdataRD		: STD_LOGIC_VECTOR(UART_DATA - 1 downto 0);
	signal simRxD, simTxD			: STD_LOGIC;
	signal simFREG					: STD_LOGIC_VECTOR(7 downto 0);

	-- Komponentendeklaration
	component uart is
			Port(
				EN		:	in	STD_LOGIC;											-- Modul aktiv
				CLK		:	in	STD_LOGIC;											-- Systemtakt
				FLUSH	:	in	STD_LOGIC;
				WRITE	:	in	STD_LOGIC;											-- Daten auf UART schreiben
				READ	:	in 	STD_LOGIC;											-- Daten von UART lesen
				dataWR	:	in	STD_LOGIC_VECTOR(7 downto 0);						-- Daten über UART Senden
				dataRD	:	out	STD_LOGIC_VECTOR(7 downto 0);						-- Daten über UART Empfangen
				RxD		:	in	STD_LOGIC;											-- Recieve Data
				TxD		:	out	STD_LOGIC	:= '1';									-- Transmit Data
				FREG	:	out	STD_LOGIC_VECTOR (7 downto 0) := (others => '0')	-- Flagregister	
				);
	end component uart;

begin

-- Clock Singal erzeugen
CLK_process:	process
					begin
						simCLK <= '1';	wait for CLK_period/2;
						simCLK <= '0';	wait for CLK_period/2;
				end process CLK_process;

UUT:	uart port map	(
						EN		=>	simEN,
						CLK		=>	simCLK,
						FLUSH	=>	simFLUSH,
						WRITE	=>	simWRITE,
						READ	=>	simREAD,
						dataWR	=>	simdataWR,
						dataRD	=>	simdataRD,
						RxD		=>	simRxD,
						TxD		=>	simTxD,
						FREG	=>	simFREG
						);


-- Simulationsprozess
process
		variable simFIFO_DEPTH : positive := 4;
		variable simDATA_WRITE : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
	begin
		-- Initialisierung
		simEN <= '0';	simFLUSH <= '0';	simRXD <= '1';	simREAD <='0';	simWRITE <= '0';	simdataWR <= (others => '0');	wait for CLK_PERIOD*2;
		simEN <= '1'; 										simWRITE <= '1';	simdataWR <= x"F0";				wait for CLK_PERIOD;
					 										simWRITE <= '1';	simdataWR <= x"0F";				wait for CLK_PERIOD;
					 										simWRITE <= '1';	simdataWR <= x"F0";				wait for CLK_PERIOD;
					 										simWRITE <= '1';	simdataWR <= x"0F";				wait for CLK_PERIOD;
					 										simWRITE <= '1';	simdataWR <= x"F0";				wait for CLK_PERIOD;
					 										simWRITE <= '1';	simdataWR <= x"0F";				wait for CLK_PERIOD;
					 										simWRITE <= '1';	simdataWR <= x"F0";				wait for CLK_PERIOD;
					 										simWRITE <= '1';	simdataWR <= x"0F";				wait for CLK_PERIOD;
					 										simWRITE <= '0';	simdataWR <= x"00";				wait for CLK_PERIOD;
					 										
					 	simRXD <= '0';										wait for CLK_PERIOD * 109;
					 	simRXD <= '1';										wait for CLK_PERIOD * 109;
					 	simRXD <= '1';										wait for CLK_PERIOD * 109;
					 	simRXD <= '0';										wait for CLK_PERIOD * 109;
					 	simRXD <= '0';										wait for CLK_PERIOD * 109;
					 	simRXD <= '1';										wait for CLK_PERIOD * 109;
					 	simRXD <= '0';										wait for CLK_PERIOD * 109;
					 	simRXD <= '0';										wait for CLK_PERIOD * 109;
					 	simRXD <= '0';										wait for CLK_PERIOD * 109;
					 	simRXD <= '1';										wait for CLK_PERIOD * 109;
					 	simRXD <= '1';										wait for CLK_PERIOD * 109;
					 	simRXD <= '1';										wait for CLK_PERIOD * 109;
					 														wait for CLK_PERIOD * 4000;

						simRXD <= '0';										wait for CLK_PERIOD * 109;
						simRXD <= '1';										wait for CLK_PERIOD * 109;
						simRXD <= '0';										wait for CLK_PERIOD * 109;
						simRXD <= '0';										wait for CLK_PERIOD * 109;
						simRXD <= '0';										wait for CLK_PERIOD * 109;
						simRXD <= '1';										wait for CLK_PERIOD * 109;
						simRXD <= '0';										wait for CLK_PERIOD * 109;
						simRXD <= '0';										wait for CLK_PERIOD * 109;
						simRXD <= '0';										wait for CLK_PERIOD * 109;
						simRXD <= '0';										wait for CLK_PERIOD * 109;
						simRXD <= '1';										wait for CLK_PERIOD * 109;
						simRXD <= '1';										wait for CLK_PERIOD * 109;
					 	
					 										
					 										simWRITE <= '0';	simdataWR <= x"00";				wait for CLK_PERIOD*60000;
															simWRITE <= '1';	simdataWR <= x"33";				wait for CLK_PERIOD;			 	
															simWRITE <= '1';	simdataWR <= x"77";				wait for CLK_PERIOD;
															simWRITE <= '0';	simdataWR <= x"00";				wait for CLK_PERIOD;
						
						
						
						simRXD <= '0';										wait for CLK_PERIOD * 109;
						simRXD <= '1';										wait for CLK_PERIOD * 109;
						simRXD <= '1';										wait for CLK_PERIOD * 109;
						simRXD <= '1';										wait for CLK_PERIOD * 109;
						simRXD <= '1';										wait for CLK_PERIOD * 109;
						simRXD <= '1';										wait for CLK_PERIOD * 109;
						simRXD <= '1';										wait for CLK_PERIOD * 109;
						simRXD <= '1';										wait for CLK_PERIOD * 109;
						simRXD <= '1';										wait for CLK_PERIOD * 109;
						simRXD <= '1';										wait for CLK_PERIOD * 109;
						simRXD <= '1';										wait for CLK_PERIOD * 109;
						simRXD <= '1';										wait for CLK_PERIOD * 109;
						
						simRXD <= '0';										wait for CLK_PERIOD * 109;
						simRXD <= '1';										wait for CLK_PERIOD * 109;
						simRXD <= '1';										wait for CLK_PERIOD * 109;
						simRXD <= '0';										wait for CLK_PERIOD * 109;
						simRXD <= '0';										wait for CLK_PERIOD * 109;
						simRXD <= '1';										wait for CLK_PERIOD * 109;
						simRXD <= '1';										wait for CLK_PERIOD * 109;
						simRXD <= '1';										wait for CLK_PERIOD * 109;
						simRXD <= '0';										wait for CLK_PERIOD * 109;
						simRXD <= '0';										wait for CLK_PERIOD * 109;
						simRXD <= '1';										wait for CLK_PERIOD * 109;
						simRXD <= '1';										wait for CLK_PERIOD * 109;
						
						simRXD <= '0';										wait for CLK_PERIOD * 109;
						simRXD <= '0';										wait for CLK_PERIOD * 109;
						simRXD <= '1';										wait for CLK_PERIOD * 109;
						simRXD <= '0';										wait for CLK_PERIOD * 109;
						simRXD <= '1';										wait for CLK_PERIOD * 109;
						simRXD <= '0';										wait for CLK_PERIOD * 109;
						simRXD <= '1';										wait for CLK_PERIOD * 109;
						simRXD <= '1';										wait for CLK_PERIOD * 109;
						simRXD <= '1';										wait for CLK_PERIOD * 109;
						simRXD <= '1';										wait for CLK_PERIOD * 109;
						simRXD <= '1';										wait for CLK_PERIOD * 109;
						simRXD <= '1';										wait for CLK_PERIOD * 109;
			
						simRXD <= '0';										wait for CLK_PERIOD * 109;
						simRXD <= '0';										wait for CLK_PERIOD * 109;
						simRXD <= '0';										wait for CLK_PERIOD * 109;
						simRXD <= '0';										wait for CLK_PERIOD * 109;
						simRXD <= '1';										wait for CLK_PERIOD * 109;
						simRXD <= '0';										wait for CLK_PERIOD * 109;
						simRXD <= '0';										wait for CLK_PERIOD * 109;
						simRXD <= '0';										wait for CLK_PERIOD * 109;
						simRXD <= '1';										wait for CLK_PERIOD * 109;
						simRXD <= '0';										wait for CLK_PERIOD * 109;
						simRXD <= '1';										wait for CLK_PERIOD * 109;
						simRXD <= '1';										wait for CLK_PERIOD * 109;			
						
						simRXD <= '1';										wait for CLK_PERIOD * 109;
						simRXD <= '1';										wait for CLK_PERIOD * 109;
						simRXD <= '1';										wait for CLK_PERIOD * 109;
						
						
						simRXD <= '0';										wait for CLK_PERIOD * 109;
						simRXD <= '0';										wait for CLK_PERIOD * 109;
						simRXD <= '0';										wait for CLK_PERIOD * 109;
						simRXD <= '0';										wait for CLK_PERIOD * 109;
						simRXD <= '1';										wait for CLK_PERIOD * 109;
						simRXD <= '0';										wait for CLK_PERIOD * 109;
						simRXD <= '0';										wait for CLK_PERIOD * 109;
						simRXD <= '0';										wait for CLK_PERIOD * 109;
						simRXD <= '1';										wait for CLK_PERIOD * 109;
						simRXD <= '0';										wait for CLK_PERIOD * 109;
						simRXD <= '1';										wait for CLK_PERIOD * 109;
						simRXD <= '1';										wait for CLK_PERIOD * 109 * 15;
						simREAD <= '1';										wait for CLK_PERIOD * 20;
						simRXD <= '1';										wait for CLK_PERIOD * 109 * 2;

						simRXD <= '0';										wait for CLK_PERIOD * 109;
						simRXD <= '0';										wait for CLK_PERIOD * 109;
						simRXD <= '0';										wait for CLK_PERIOD * 109;
						simRXD <= '0';										wait for CLK_PERIOD * 109;
						simRXD <= '1';										wait for CLK_PERIOD * 109;
						simRXD <= '0';										wait for CLK_PERIOD * 109;
						simRXD <= '0';										wait for CLK_PERIOD * 109;
						simRXD <= '0';										wait for CLK_PERIOD * 109;
						simRXD <= '1';										wait for CLK_PERIOD * 109;
						simRXD <= '0';										wait for CLK_PERIOD * 109;
						simRXD <= '1';										wait for CLK_PERIOD * 109;
						simRXD <= '1';										wait for CLK_PERIOD * 109;						
						
						simRXD <= '1';										wait for CLK_PERIOD * 108;
						simRXD <= '1';										wait for CLK_PERIOD * 400;
						
						
		wait;
		
end process;



end Simulation;
