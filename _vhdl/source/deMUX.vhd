--	------------------------------------
--	Diplomarbeit elmProject@HTL-Rankweil
--	GÄCHTER Raffael
--	elm-project@sunriax.at
--	2AAELI | 2016/2017
--	------------------------------------
--	File: clock.vhdl
--	Version: v1.0
--	------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity demux is
    Port (	CLK, EN, S	: in STD_LOGIC;
    		A			: in STD_LOGIC_VECTOR(1 downto 0);
			P			: out STD_LOGIC_VECTOR(3 downto 0));
end demux;

architecture Behavioral of demux is
begin
	process (CLK, EN)
		begin
			if (EN = '1') then
				if rising_edge(CLK) then
					case (A) is
						when "00"	=>	P(0) <= S;	P(1) <= '0';	P(2) <= '0';	P(3) <= '0';
						when "01"	=>	P(1) <= S;	P(0) <= '0';	P(2) <= '0';	P(3) <= '0';
						when "10"	=>	P(2) <= S;	P(0) <= '0';	P(1) <= '0';	P(3) <= '0';
						when "11"	=>	P(3) <= S;	P(0) <= '0';	P(1) <= '0';	P(2) <= '0';
						when others =>	P    <= "0000";
					end case;
				end if;
			else
				P <= "0000";
			end if;
	end process;
end Behavioral;
