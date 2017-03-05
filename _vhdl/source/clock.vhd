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
--use IEEE.STD_LOGIC_ARITH.ALL; 	--// niemals beide NUMERIC_STD und STD_LOGIC_ARITH verwenden!!!
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity startup is
	Generic	(
			cycleDELAY	: in INTEGER := 100
			);
	Port	(
			sysCLK		: in STD_LOGIC;
			ENable		: out STD_LOGIC
			);
end startup;

architecture Behavioral of startup is
begin
	process(sysCLK)
			variable init	: integer range 0 to 100 := cycleDELAY;
		begin
			-- init Wert größer 0		
			if(init > 0) then
				-- init Wert herunterzählen
				if rising_edge(sysCLK) then
					init := init - 1;
				end if;
				
				-- ENable Ausgang inaktiv
				ENable<= '0';
			else
				-- ENable Ausgang aktiv
				ENable <= '1';
			end if;
	end process;
end Behavioral;
