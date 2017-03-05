--	------------------------------------
--	Diplomarbeit elmProject@HTL-Rankweil
--	GÄCHTER Raffael                     
--	elm-project@sunriax.at              
--	2AAELI | 2016/2017                  
--	------------------------------------
--	File: mux_tb.vhdl                    
--	Version: v1.0                       
--	------------------------------------

library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use UNISIM.VComponents.all;

entity mux_tb is
--  Port ( );
end mux_tb;

architecture Simulation of mux_tb is

	component mux is
		Port	(	CLK	: in STD_LOGIC;
					EN		: in STD_LOGIC;
					A		: in STD_LOGIC_VECTOR(1 downto 0);
					P		: in STD_LOGIC_VECTOR(3 downto 0);
					S		: out STD_LOGIC
				);
	end component mux;

signal simEN, simCLK	: STD_LOGIC;
signal simA				: STD_LOGIC_VECTOR(1 downto 0);
signal simP				: STD_LOGIC_VECTOR(3 downto 0);
signal simS				: STD_LOGIC;

constant CLK_period : time := 200 ns;    -- 20 MHz

begin
UUT: mux port map	(
					CLK	=> simCLK,
					EN	=> simEN,
					A	=> simA,
					P	=> simP,
					S	=> simS
					);

CLK_process: process
	begin
		simCLK <= '0';	wait for CLK_period/2;
		simCLK <= '1';	wait for CLK_period/2;
end process;

process
	begin
		simEN <= '0';	simA <= "00";	simP <=	x"0";	wait for CLK_period * 2;

		simEN <= '1';	simA <= "00";	simP <= x"5";	wait for CLK_period;
		simEN <= '1';	simA <= "01";	simP <= x"5";	wait for CLK_period;
		simEN <= '1';	simA <= "10";	simP <= x"5";	wait for CLK_period;
		simEN <= '1';	simA <= "11";	simP <= x"5";	wait for CLK_period;
		
		simEN <= '0';	simA <= "00";	simP <=	x"0";	wait for CLK_period * 2;
		
		simEN <= '1';	simA <= "00";	simP <= x"C";	wait for CLK_period;
		simEN <= '1';	simA <= "01";	simP <= x"C";	wait for CLK_period;
		simEN <= '1';	simA <= "10";	simP <= x"C";	wait for CLK_period;
		simEN <= '1';	simA <= "11";	simP <= x"C";	wait for CLK_period;

		simEN <= '0';	simA <= "00";	simP <=	x"0";	wait for CLK_period * 2;
     
     	simEN <= '1';	simA <= "00";	simP <= x"9";	wait for CLK_period;
		simEN <= '1';	simA <= "01";	simP <= x"9";	wait for CLK_period;
		simEN <= '1';	simA <= "10";	simP <= x"9";	wait for CLK_period;
		simEN <= '1';	simA <= "11";	simP <= x"9";	wait for CLK_period;
 
 		simEN <= '0';	simA <= "00";	simP <=	x"0";	wait for CLK_period * 2;
		wait;
end process;

end Simulation;
