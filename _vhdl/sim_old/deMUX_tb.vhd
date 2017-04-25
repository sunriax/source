--	------------------------------------
--	Diplomarbeit elmProject@HTL-Rankweil
--	GÄCHTER Raffael                     
--	elm-project@sunriax.at              
--	2AAELI | 2016/2017                  
--	------------------------------------
--	File: demux_tb.vhdl                    
--	Version: v1.0                       
--	------------------------------------

library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use UNISIM.VComponents.all;

entity demux_tb is
--  Port ( );
end demux_tb;

architecture Simulation of demux_tb is
	component demux is
		Port	(
				CLK, EN, S	: in STD_LOGIC;
				A			: in STD_LOGIC_VECTOR(1 downto 0);
				P			: out STD_LOGIC_VECTOR(3 downto 0)
				);
	end component demux;

signal simEN, simCLK, simS	: STD_LOGIC;
signal simA					: STD_LOGIC_VECTOR(1 downto 0);
signal simP					: STD_LOGIC_VECTOR(3 downto 0);

constant CLK_period : time := 200 ns;    -- 20 MHz

begin
UUT: demux port map	(	
					CLK	=> simCLK,
					EN	=> simEN,
					A	=> simA,
					S	=> simS,
					P	=> simP
					);

CLK_process: process
	begin
		simCLK <= '0';	wait for CLK_period/2;
		simCLK <= '1';	wait for CLK_period/2;
end process;

process
	begin
		simEN <= '0';	simA <= "00";	simS <= '0';	wait for CLK_period * 2;
		
		simEN <= '1';	simA <= "00";	simS <= '1';	wait for CLK_period;
		simEN <= '1';	simA <= "01";	simS <= '0';	wait for CLK_period;
		simEN <= '1';	simA <= "10";	simS <= '1';	wait for CLK_period;
		simEN <= '1';	simA <= "11";	simS <= '0';	wait for CLK_period;
		
		simEN <= '0';	simA <= "00";	simS <= '0';	wait for CLK_period * 2;
		
		simEN <= '1';	simA <= "00";	simS <= '0';	wait for CLK_period;
		simEN <= '1';	simA <= "01";	simS <= '0';	wait for CLK_period;
		simEN <= '1';	simA <= "10";	simS <= '1';	wait for CLK_period;
		simEN <= '1';	simA <= "11";	simS <= '1';	wait for CLK_period;

		simEN <= '0';	simA <= "00";	simS <= '0';	wait for CLK_period * 2;
		
		simEN <= '1';	simA <= "00";	simS <= '1';	wait for CLK_period;
		simEN <= '1';	simA <= "01";	simS <= '0';	wait for CLK_period;
		simEN <= '1';	simA <= "10";	simS <= '0';	wait for CLK_period;
		simEN <= '1';	simA <= "11";	simS <= '1';	wait for CLK_period;

		simEN <= '0';	simA <= "00";	simS <= '0';	wait for CLK_period * 2;

		wait;
end process;

end Simulation;
