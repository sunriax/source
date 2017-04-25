--	------------------------------------
--	Diplomarbeit elmProject@HTL-Rankweil
--	GÄCHTER Raffael                     
--	elm-project@sunriax.at              
--	2AAELI | 2016/2017                  
--	------------------------------------
--	File: clock_tb.vhdl                    
--	Version: v1.0                       
--	------------------------------------

library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use UNISIM.VComponents.all;

entity clock_tb is
--  Port ( );
end clock_tb;

architecture Simulation of clock_tb is
component clock is
	Port	(
			sysCLK		: in STD_LOGIC;
			ENable		: out STD_LOGIC
			);
end component clock;

	signal simEN, simCLK	: STD_LOGIC;

	constant CLK_period : time := 200 ns;    -- 20 MHz
begin

UUT: clock port map	(
					sysCLK		=>	simCLK,
					ENable		=>	simEN
					);

CLK_process: process
	begin
		simCLK <= '0';	wait for CLK_period/2;
		simCLK <= '1';	wait for CLK_period/2;
end process;

process
	begin
		wait for CLK_period * 100;
end process;
end Simulation;
