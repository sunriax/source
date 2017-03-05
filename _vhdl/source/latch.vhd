
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity latch is
    Port ( CLK	: in STD_LOGIC;
           D	: in STD_LOGIC;
           Q	: out STD_LOGIC);
end latch;

architecture Behavioral of latch is

begin
	process(CLK, D)
		begin
			if rising_edge(CLK) then
				Q <= D;
			else
				Q <= '0';
			end if;
	end process;
end Behavioral;
