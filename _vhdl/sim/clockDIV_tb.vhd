
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
  Port ( EN		: in STD_LOGIC;
         CLK	: in STD_LOGIC;
         SCALE	: in INTEGER range 0 to 1000000000;
         CLK2SH	: out STD_LOGIC;
         CLK2SQ	: out STD_LOGIC	);
end component divider;

signal simEN, simCLK		: STD_LOGIC;
signal simSCALE				: INTEGER range 0 to 1000000000;
signal simCLK2SH, simCLK2SQ	: STD_LOGIC;

constant CLK_period : time := 1 us;    -- 1 MHz
begin
UUT: divider port map ( EN		=> simEN,
                     	CLK		=> simCLK,
                    	SCALE	=> simSCALE,
                     	CLK2SH	=> simCLK2SH,
                     	CLK2SQ	=> simCLK2SQ );

CLK_process: process
  begin
      simCLK <= '0';
      wait for CLK_period/2;
      simCLK <= '1';
      wait for CLK_period/2;
end process;

process
	begin
		simSCALE <= 10;
		
		wait for 1 us;
      
		simEN <= '0';	wait for 2 us;
		simEN <= '1';	wait for 60 us;
		simEN <= '0';	wait for 2 us;
     
		wait;
end process;

end Simulation;
