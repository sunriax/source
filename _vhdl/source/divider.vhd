--	------------------------------------
--	Diplomarbeit elmProject@HTL-Rankweil
--	GÄCHTER Raffael                     
--	elm-project@sunriax.at              
--	2AAELI | 2016/2017                  
--	------------------------------------
--	File: divider.vhdl                    
--	Version: v1.0                       
--	------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;	--niemals beide NUMERIC_STD und STD_LOGIC_ARITH verwenden!!!
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity divider is
	Port	(
			EN : in STD_LOGIC;
			CLK : in STD_LOGIC;
			scale : in INTEGER range 0 to 1000000000;
			CLK_scale : out STD_LOGIC
			);
end divider;

architecture Behavioral of divider is
	signal CLOCK : STD_LOGIC;
begin
	process(CLK, EN, scale)
			variable count : integer range 0 to 1000000001 := 0;
		begin
			if rising_edge(CLK) then
				if(EN = '1') then
					if(count >= scale) then
						count := 0;             
						CLOCK <= not(CLOCK);
						CLK_scale <= CLOCK;
					else
						count := count + 1;
					end if;
				else
					CLK_scale <= '0';
					CLOCK <= '0';
				end if;
			end if;
	end process;
end Behavioral;
