--	------------------------------------
--	Diplomarbeit elmProject@HTL-Rankweil
--	GÄCHTER Raffael                     
--	elm-project@sunriax.at              
--	2AAELI | 2016/2017                  
--	------------------------------------
--	File: shiftreg_tb.vhdl                    
--	Version: v1.0                       
--	------------------------------------

library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use UNISIM.VComponents.all;

entity shiftreg_tb is
--  Port ( );
end shiftreg_tb;

architecture Simulation of shiftreg_tb is
	component shiftreg is
		Port (	CLK		: in STD_LOGIC;
				RESET	: in STD_LOGIC;
				DSR		: in STD_LOGIC;
				DSL		: in STD_LOGIC;
				S		: in STD_LOGIC_VECTOR (1 downto 0);
				P		: in STD_LOGIC_VECTOR (3 downto 0);
				Q		: out STD_LOGIC_VECTOR (3 downto 0));
	end component shiftreg;

	signal simCLK, simRESET, simDSR, simDSL	: STD_LOGIC;
	signal simS								: STD_LOGIC_VECTOR(1 DOWNTO 0);
	signal simP								: STD_LOGIC_VECTOR(3 downto 0);
	signal simQ								: STD_LOGIC_VECTOR(3 downto 0);

	constant CLK_period : time := 200 ns;    -- 20 MHz
begin
UUT: shiftreg port map	(
						CLK		=> simCLK,
   	                 	RESET	=> simRESET,
       	            	S		=> simS,
           	         	P 		=> simP,
               	     	DSR		=> simDSR,
                   	 	DSL		=> simDSL,
                   		Q		=> simQ
                   		);

CLK_process: process
	begin
		simCLK <= '0';	wait for CLK_period/2;
		simCLK <= '1';	wait for CLK_period/2;
end process;

process
	begin
		simRESET <= '0';	simS <= "00";	simP <= x"0";		simDSL <= '0';		simDSR <= '0';		wait for CLK_period;
		simRESET <= '1';	simS <= "11";	simP <= x"5";												wait for CLK_period;
		simRESET <= '1';	simS <= "01";	simP <= x"0";		simDSR <= '0';							wait for CLK_period;
		simRESET <= '1';	simS <= "01";						simDSR <= '0';							wait for CLK_period;
		simRESET <= '1';	simS <= "01";						simDSR <= '1';							wait for CLK_period;
		simRESET <= '1';	simS <= "01";						simDSR <= '1';							wait for CLK_period;
		simRESET <= '0';	simS <= "00";						simDSR <= '0';							wait;
end process;
end Simulation;
