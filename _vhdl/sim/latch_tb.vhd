--	------------------------------------
--	Diplomarbeit elmProject@HTL-Rankweil
--	GÄCHTER Raffael                     
--	elm-project@sunriax.at              
--	2AAELI | 2016/2017                  
--	------------------------------------
--	File: latch_tb.vhdl                    
--	Version: v1.0                       
--	------------------------------------

library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use UNISIM.VComponents.all;

entity latch_tb is
--  Port ( );
end latch_tb;

architecture Simulation of latch_tb is
	component latch is
		Port	(	
				CLK	: in STD_LOGIC;
				D	: in STD_LOGIC;
				Q	: out STD_LOGIC
				);
	end component latch;

	signal simCLK, simD, simQ	: STD_LOGIC;

	constant CLK_period : time := 200 ns;    -- 20 MHz
	constant WIDTH : INTEGER := 8;
begin

UUT: latch port map	(
					CLK	=>	simCLK,
					D	=>	simD,
					Q	=>	simQ
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
