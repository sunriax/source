--	------------------------------------
--	Diplomarbeit elmProject@HTL-Rankweil
--	GÄCHTER Raffael                     
--	elm-project@sunriax.at              
--	2AAELI | 2016/2017                  
--	------------------------------------
--	File: divider_tb.vhdl                    
--	Version: v1.0                       
--	------------------------------------

library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use UNISIM.VComponents.all;

entity divider_tb is
--  Port ( );
end divider_tb;

architecture Simulation of divider_tb is
component divider is
	Port	(
			EN,CLK : in STD_LOGIC
			);
end component divider;

	signal simEN, simCLK	: STD_LOGIC;

	constant CLK_period : time := 200 ns;    -- 20 MHz
	constant WIDTH : INTEGER := 8;
begin

UUT: divider port map	(
						CLK	=>	simCLK,
						EN	=>	simEN
						);

CLK_process: process
	begin
		simCLK <= '0';	wait for CLK_period/2;
		simCLK <= '1';	wait for CLK_period/2;
end process;

process
	begin

end process;
end Simulation;
