--	------------------------------------
--	Diplomarbeit elmProject@HTL-Rankweil
--	GÄCHTER Raffael
--	elm-project@hotmail.com
--	2AAELI | 2016/2017
--	------------------------------------
--	File: spi_slave_tb.vhd
--	Version: v1.0
--	------------------------------------
--	SPI Slave Testbench
--	Stellt die Funktionsweise des
--	SPI Slaves dar
--	------------------------------------

library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use UNISIM.VComponents.all;

entity spi_slave_tb is
--  Port ( );
end spi_slave_tb;

architecture Simulation of spi_slave_tb is

-- Deklaration
constant CLK_period : time := 10 ns;	-- Simulationstakt (100 MHz)

signal simEN, simSCK, simSS, simMOSI, simMISO	: STD_LOGIC;
signal simDATA									: STD_LOGIC_VECTOR(7 downto 0);

-- Komponentendeklaration
component spi_slave is
		Port(
			EN		:  in STD_LOGIC;
			SCK		:  in STD_LOGIC;
			SS		:  in STD_LOGIC;
			MOSI	:  in STD_LOGIC;
			MISO	: out STD_LOGIC;
			DATA	: out STD_LOGIC_VECTOR(7 downto 0)
			);
end component spi_slave;

begin

UUT: spi_slave	 port map	(
							EN			=>	simEN,
							SCK			=>	simSCK,
							SS			=>	simSS,
							MOSI		=>	simMOSI,
							MISO		=>	simMISO,
							DATA		=>	simDATA
							);

-- Clock Singal erzeugen
CLK_process:	process
						variable simCOUNTER : integer := 0;
					begin
							--simSCK <= '0';	wait for CLK_period/2;
							--simSCK <= '1';	wait for CLK_period/2;
						
						if(simCOUNTER >= 9 or simEN = '0') Then
							simSCK <= '0'; wait for CLK_period * 2;
							simCOUNTER := 0;
						else
						
							simSCK <= '0';	wait for CLK_period/2;
							simSCK <= '1';	wait for CLK_period/2;
						
						end if;
						
						simCOUNTER := simCOUNTER + 1;
				end process CLK_process;

-- Simulationsprozess
process
	begin
		-- Initialisierung
		simEN <= '0';	simSS <= '1';	simMOSI <= '0';	wait for CLK_PERIOD;
		simEN <= '1';	simSS <= '1';	simMOSI <= '0';	wait for CLK_PERIOD * 2;
						simSS <= '0';	simMOSI <= '1';	wait for CLK_PERIOD * 4;	
										simMOSI <= '0';	wait for CLK_PERIOD * 5;
						simSS <= '1';	simMOSI <= '0';	wait for CLK_PERIOD;
		wait;
end process;


end Simulation;
