--	------------------------------------
--	Diplomarbeit elmProject@HTL-Rankweil
--	G�CHTER Raffael
--	elm-project@sunriax.at
--	2AAELI | 2016/2017
--	------------------------------------
--	File: shiftreg.vhdl
--	Version: v1.0
--	------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity shiftreg is
    Port (  CLK   :   in STD_LOGIC;
            EN    :   in STD_LOGIC;
            D     :   in STD_LOGIC;
            DATA  :   out STD_LOGIC_VECTOR(3 downto 0));
end shiftreg;

architecture Behavioral of shiftreg is
    signal Q1, nQ1, Q2, nQ2, Q3, nQ3, Q4, nQ4	: STD_LOGIC;
    signal nCLK									: STD_LOGIC;
begin
	process (CLK)
		variable temp: STD_LOGIC_VECTOR(3 downto 0);
	begin
		if EN='1' then
			if falling_edge(CLK) then
				for i in 3 downto 0 loop
					if i=0 then
						temp(0) := D;
					else
						temp(i) := temp(i-1);
					end if;
				end loop;
			end if;
		else
			temp := "0000";
		end if;

	DATA <= temp;

	end process;

end Behavioral;
