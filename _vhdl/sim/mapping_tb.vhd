--	------------------------------------
--	Diplomarbeit elmProject@HTL-Rankweil
--	GÄCHTER Raffael                     
--	elm-project@sunriax.at              
--	2AAELI | 2016/2017                  
--	------------------------------------
--	File: mapping_tb.vhdl                    
--	Version: v1.0                       
--	------------------------------------

library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use UNISIM.VComponents.all;

entity mapping_tb is
--  Port ( );
end mapping_tb;

architecture Simulation of mapping_tb is
	component mapping is
		Port	(
				EN		: in STD_LOGIC;
				RESET	: in STD_LOGIC;
				CLK		: in STD_LOGIC;
				Cup		: in STD_LOGIC;
				Cdown	: in STD_LOGIC;
				LIMIT	: in STD_LOGIC_VECTOR(3 downto 0);
				COUNT	: out STD_LOGIC_VECTOR(3 downto 0));
	end component mapping;

signal simEN, simRESET, simCLK, simCup, simCdown	: STD_LOGIC;
signal simLIMIT, simCOUNT							: STD_LOGIC_VECTOR(3 downto 0);

constant CLK_period : time := 200 ns;    -- 20 MHz

begin
UUT: mapping port map	(
						EN		=>	simEN,
						RESET	=>	simRESET,
						CLK		=>	simCLK,
						Cup		=>	simCup,
						Cdown	=>	simCdown,
						LIMIT	=>	simLIMIT,
						COUNT	=>	simCOUNT );

CLK_process: process
	begin
		simCLK <= '0';	wait for CLK_period/2;
		simCLK <= '1';	wait for CLK_period/2;
end process;

process
  begin
		simEN <= '0';	simRESET <= '0';	simCup	<=	'0';	simCdown <= '0';	simLIMIT <= "0100";	wait for CLK_period;
		simEN <= '0';	simRESET <= '1';	simCup	<=	'0';	simCdown <= '0';	simLIMIT <= "0100";	wait for CLK_period;
		simEN <= '1';	simRESET <= '1';	simCup	<=	'1';	simCdown <= '0';	simLIMIT <= "0100";	wait for CLK_period*10;
		simEN <= '0';	simRESET <= '0';	simCup	<=	'0';	simCdown <= '0';	simLIMIT <= "0100";	wait for CLK_period;
		simEN <= '0';	simRESET <= '1';	simCup	<=	'0';	simCdown <= '0';	simLIMIT <= "0100";	wait for CLK_period;
		simEN <= '1';	simRESET <= '1';	simCup	<=	'0';	simCdown <= '1';	simLIMIT <= "0100";	wait for CLK_period*10;
		simEN <= '0';	simRESET <= '0';	simCup	<=	'0';	simCdown <= '0';	simLIMIT <= "0100";
      wait;
end process;
end Simulation;
