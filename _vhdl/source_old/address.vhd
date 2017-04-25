--	------------------------------------
--	Diplomarbeit elmProject@HTL-Rankweil
--	GÄCHTER Raffael                     
--	elm-project@sunriax.at              
--	2AAELI | 2016/2017                  
--	------------------------------------
--	File: address.vhdl                    
--	Version: v1.0                       
--	------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
-- use IEEE.STD_LOGIC_ARITH.ALL; // niemals beide NUMERIC_STD und STD_LOGIC_ARITH verwenden!!!
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity address is
	Generic	(
			nWIDTH	:	INTEGER := 16
			);
	Port	(
			EN		: in STD_LOGIC;
			CLK		: in STD_LOGIC;
			ZERO	: in STD_LOGIC;
			Ipp		: in STD_LOGIC;
			Imm		: in STD_LOGIC;
			ldADDR	: in STD_LOGIC_VECTOR(nWIDTH - 1 downto 0);
			ldSTOP	: in STD_LOGIC_VECTOR(nWIDTH - 1 downto 0);
			ADDR	: out STD_LOGIC_VECTOR(nWIDTH - 1 downto 0)
			);
end address;

architecture Behavioral of address is
	signal data, x00_data, xFF_data	: STD_LOGIC_VECTOR(nWIDTH - 1 downto 0);	
begin
	process(EN, CLK, ZERO, Ipp, Imm, ldADDR, ldSTOP)
		begin
			x00_data <= (others => '0');	-- LOW Zustand
			xFF_data <= (others => '1');	-- HIGH Zustand
		
			-- Adresszähler zurücksetzen wenn ZERO = LOW
			if(ZERO = '0') then
					data <= (others => '0');
			else
				if (EN = '1' and rising_edge(CLK)) then
					-- Wenn Ipp und Imm = HIGH Daten von ldADDR übernehmen
					if (Ipp = '0' and Imm = '0') then
						data <= ldADDR;
					elsif (Ipp = '1' and Imm = '0') then
						if(data >= ldSTOP) then
							data <= (others => '0');
						else
							data <= data + 1;
						end if;
					elsif (Ipp = '0' and Imm = '1') then
						if(data >= ldSTOP or data = x00_data) then
							data <= (others => '0');
						else
							data <= data - 1;
						end if;
					else
						ADDR <= (others => '1');
					end if;
				end if;
			end if;
		ADDR <= data;	-- Ergebnis ausgeben
	end process;
end Behavioral;
