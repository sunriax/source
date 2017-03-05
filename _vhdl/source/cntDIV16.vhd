
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity CTRDIV16 is
    Port ( EN		: in STD_LOGIC;
           RESET	: in STD_LOGIC;
           CLK		: in STD_LOGIC;
           Cup		: in STD_LOGIC;
           Cdown	: in STD_LOGIC;
           LIMIT	: in STD_LOGIC_VECTOR(3 downto 0);
           COUNT	: out STD_LOGIC_VECTOR(3 downto 0));
end CTRDIV16;

architecture Behavioral of CTRDIV16 is
	signal data	: STD_LOGIC_VECTOR(3 downto 0);	
begin

	process(EN, CLK, RESET)
		begin
			if(RESET = '0') then
					DATA <= "0000";
					COUNT <= "0000";
			else
				if (EN = '1' and rising_edge(CLK)) then
					if (Cup = '1') then
						if (DATA < LIMIT) then
							COUNT <= DATA;
							DATA <= DATA + 1;
						else
							COUNT <= DATA;
							DATA <= "0000";
						end if;
					elsif (Cdown = '1') then
						if (DATA > "0000") then
							DATA <= DATA - 1;
							COUNT <= DATA;
						else
							DATA <= LIMIT;
							COUNT <= DATA;
						end if;
					end if;
				end if;
			end if;
	end process;

end Behavioral;
