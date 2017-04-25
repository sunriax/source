
library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use UNISIM.VComponents.all;

entity parreg_tb is
--  Port ( );
end parreg_tb;

architecture Simulation of parreg_tb is
component parreg is
  Port ( E	: in STD_LOGIC;
  		 D	: in STD_LOGIC;
         Q	: out STD_LOGIC;
         nQ	: out STD_LOGIC	);
end component parreg;

signal simE, simD	: STD_LOGIC;
signal simQ, simnQ	: STD_LOGIC;

constant CLK_period : time := 1 us;    -- 1 MHz
begin
UUT: parreg port map (	E	=> simE,
                    	D	=> simD,
                     	Q	=> simQ,
                     	nQ	=> simnQ );



process
	begin
		simE <= '1';	simD <= '0';	wait for 2 us;
		simE <= '0';	simD <= '0';	wait for 2 us;
		simE <= '0';	simD <= '1';	wait for 2 us;
		simE <= '1';	simD <= '0';	wait for 2 us;
		simE <= '1';	simD <= '1';	wait for 2 us;
		simE <= '0';	simD <= '0';	wait for 2 us;
		simE <= '0';	simD <= '1';	wait for 2 us;
		simE <= '1';	simD <= '0';	wait for 2 us;
		simE <= '1';	simD <= '1';	wait for 2 us;
		wait;
end process;
end Simulation;
