
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity divider is
    Port ( EN		: in STD_LOGIC;
           CLK		: in STD_LOGIC;
           SCALE	: in INTEGER range 0 to 100000000;
           CLK2SH	: out STD_LOGIC;
           CLK2SQ	: out STD_LOGIC	);
end divider;

architecture Behavioral of divider is
	signal CLOCK_slow : STD_LOGIC;
	signal CLOCK_fast : STD_LOGIC;
begin
	process(EN, CLK)
			variable temp   : integer range 0 to 255;
			variable factor : integer range 0 to 255;
		begin
			if (EN = '0') then
				temp := 1;
				CLOCK_slow <= '0';
				CLOCK_fast <= '0';
			elsif rising_edge(CLK) then
				if (temp = SCALE) then
					CLOCK_slow <= NOT(CLOCK_slow);
					CLOCK_fast <= NOT(CLOCK_fast);
					temp := 1;
				else
					if (temp = SCALE / 2) then
						CLOCK_fast <= NOT(CLOCK_fast);
					end if;
				
					temp := temp + 1;
				end if;
			end if;

		CLK2SQ <= CLOCK_slow;
		CLK2SH <= CLOCK_fast;

	end process;
end Behavioral;
