--	------------------------------------
--	Diplomarbeit elmProject@HTL-Rankweil
--	GÄCHTER Raffael                     
--	elm-project@sunriax.at              
--	2AAELI | 2016/2017                  
--	------------------------------------
--	File: control_tb.vhdl                    
--	Version: v1.0                       
--	------------------------------------

library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use UNISIM.VComponents.all;

entity control_tb is
--  Port ( );
end control_tb;

architecture Simulation of control_tb is
component control is
	Port	(
			EN, CLK, COUNT,	ZERO	: in STD_LOGIC;
			DATA, DIGIT				: out STD_LOGIC_VECTOR(3 downto 0)
			);
end component control;

	signal simEN, simCLK, simCOUNT, simZERO	: STD_LOGIC;
	signal simDATA, simDIGIT				: STD_LOGIC_VECTOR(3 downto 0);

	constant CLK_period : time := 200 ns;    -- 20 MHz
	constant COUNT_period : time := 100 us;    -- 20 MHz
begin

UUT: control port map	(
						CLK		=> simCLK,
						COUNT	=> simCOUNT,
						EN		=> simEN,
						ZERO	=> simZERO,
						DATA	=> simDATA,
						DIGIT	=> simDIGIT
						);

CLK_process: process
	begin
		simCLK <= '0';	wait for CLK_period/2;
		simCLK <= '1';	wait for CLK_period/2;
end process;

COUNT_process: process
	begin
		simCOUNT <= '0';	wait for COUNT_period/2;
		simCOUNT <= '1';	wait for COUNT_period/2;
end process;

process
	begin
		simEN <= '0';	simZERO <= '0'; wait for COUNT_period * 4;
		simEN <= '0';	simZERO <= '1'; wait;
end process;
end Simulation;
