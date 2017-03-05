--	------------------------------------
--	Diplomarbeit elmProject@HTL-Rankweil
--	GÄCHTER Raffael                     
--	elm-project@sunriax.at              
--	2AAELI | 2016/2017                  
--	------------------------------------
--	File: ram_tb.vhdl                    
--	Version: v1.0                       
--	------------------------------------

library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use UNISIM.VComponents.all;

entity ram_tb is
--  Port ( );
end ram_tb;

architecture Simulation of ram_tb is
component ram is
	Port	(
			EN, CLK, WE	: in  STD_LOGIC;
			inADDR		: in  STD_LOGIC_VECTOR(7 downto 0);
			outADDR		: in  STD_LOGIC_VECTOR(7 downto 0);
			inDATA		: in  STD_LOGIC_VECTOR(7 downto 0);
			outDATA		: out STD_LOGIC_VECTOR(7 downto 0)
			);
end component ram;

signal simEN, simCLK, simWE							: STD_LOGIC;
signal siminADDR, simoutADDR, siminDATA, simoutDATA	: STD_LOGIC_VECTOR(7 downto 0);

constant CLK_period : time := 200 ns;    -- 20 MHz
begin
UUT: ram port map	(
					EN		=> simEN,
					CLK		=> simCLK,
					WE		=> simWE,
					inADDR	=> siminADDR,
					outADDR	=> simoutADDR,
					inDATA	=> siminDATA,
					outDATA	=> simoutDATA
					);

CLK_process: process
	begin
		simCLK <= '0';	wait for CLK_period/2;
		simCLK <= '1';	wait for CLK_period/2;
end process;

process
	begin
		simEN <= '0';	simWE <= '0';	siminADDR <= x"00";	siminDATA <= x"00";
										simoutADDR <= x"00";						wait for CLK_period*2;
		
		-- Write
		simEN <= '1';	simWE <= '1';	siminADDR <= x"00";	siminDATA <= x"AA";
										simoutADDR <= x"00";						wait for CLK_period*2;

		simEN <= '1';	simWE <= '1';	siminADDR <= "00000001";	siminDATA <= "11111111";	simoutADDR <= "00000000";	wait for CLK_period*2;
		simEN <= '1';	simWE <= '1';	siminADDR <= "00000010";	siminDATA <= "00001111";	simoutADDR <= "00000000";	wait for CLK_period*2;
		simEN <= '1';	simWE <= '1';	siminADDR <= "00000011";	siminDATA <= "11110000";	simoutADDR <= "00000000";	wait for CLK_period*2;
		
		-- Read
		simEN <= '1';	simWE <= '0';	siminADDR <= "00000000";	siminDATA <= "00000000";	simoutADDR <= "00000000";	wait for CLK_period*2;
		simEN <= '1';	simWE <= '0';	siminADDR <= "00000000";	siminDATA <= "00000000";	simoutADDR <= "00000001";	wait for CLK_period*2;
		simEN <= '1';	simWE <= '0';	siminADDR <= "00000000";	siminDATA <= "00000000";	simoutADDR <= "00000010";	wait for CLK_period*2;
		simEN <= '1';	simWE <= '0';	siminADDR <= "00000000";	siminDATA <= "00000000";	simoutADDR <= "00000011";	wait for CLK_period*2;
		
		-- Read/Write
		simEN <= '1';	simWE <= '1';	siminADDR <= "00000100";	siminDATA <= "11001100";	simoutADDR <= "00000000";	wait for CLK_period*2;
		simEN <= '1';	simWE <= '1';	siminADDR <= "00000101";	siminDATA <= "11111100";	simoutADDR <= "00000011";	wait for CLK_period*2;
		simEN <= '1';	simWE <= '1';	siminADDR <= "00000110";	siminDATA <= "11111110";	simoutADDR <= "00000001";	wait for CLK_period*2;
		simEN <= '1';	simWE <= '1';	siminADDR <= "00000111";	siminDATA <= "00000001";	simoutADDR <= "00000101";	wait for CLK_period*2;
		
		wait;
end process;
end Simulation;
