--	------------------------------------
--	Diplomarbeit elmProject@HTL-Rankweil
--	GÄCHTER Raffael                     
--	elm-project@sunriax.at              
--	2AAELI | 2016/2017                  
--	------------------------------------
--	File: bcd7seg.vhdl                    
--	Version: v1.0                       
--	------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;	--niemals beide NUMERIC_STD und STD_LOGIC_ARITH verwenden!!!
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity bcd7seg is
	Generic(nDIGIT	:	INTEGER := 4;		-- BUS länge
			tDELAY	:	time := 4 ns	);	-- Gatter Laufzeiten
	Port	(
			EN, CLK	: in STD_LOGIC;
			BCD		: in STD_LOGIC_VECTOR (4 downto 0);
			POS		: in STD_LOGIC_VECTOR (nDIGIT - 1 downto 0);
			DIGIT	: out STD_LOGIC_VECTOR (nDIGIT - 1 downto 0);
			SEGMENT	: out STD_LOGIC_VECTOR (7 downto 0)
			);
end bcd7seg;

architecture Behavioral of bcd7seg is
	signal data	: 	STD_LOGIC_VECTOR(8 downto 0) := (others => '1');
begin
	process(CLK, EN, BCD, POS, data)
		begin
			if rising_edge(CLK) then
				if(EN = '1') then
					case (BCD(4 downto 1)) is
						when "0000"	=>	data(8 downto 1) <= x"40";	data(0) <= not(BCD(0));	-- 0
						when "0001"	=>	data(8 downto 1) <= x"79";	data(0) <= not(BCD(0));	-- 1
						when "0010"	=>	data(8 downto 1) <= x"24";	data(0) <= not(BCD(0));	-- 2	
						when "0011"	=>	data(8 downto 1) <= x"30";	data(0) <= not(BCD(0));	-- 3
						when "0100"	=>	data(8 downto 1) <= x"19";	data(0) <= not(BCD(0));	-- 4
						when "0101"	=>	data(8 downto 1) <= x"12";	data(0) <= not(BCD(0));	-- 5
						when "0110"	=>	data(8 downto 1) <= x"02";	data(0) <= not(BCD(0));	-- 6
						when "0111"	=>	data(8 downto 1) <= x"78";	data(0) <= not(BCD(0));	-- 7
						when "1000"	=>	data(8 downto 1) <= x"00";	data(0) <= not(BCD(0));	-- 8
						when "1001"	=>	data(8 downto 1) <= x"18";	data(0) <= not(BCD(0));	-- 9
						when "1010"	=>	data(8 downto 1) <= x"08";	data(0) <= not(BCD(0));	-- A
						when "1011"	=>	data(8 downto 1) <= x"03";	data(0) <= not(BCD(0));	-- B
						when "1100"	=>	data(8 downto 1) <= x"46";	data(0) <= not(BCD(0));	-- C
						when "1101"	=>	data(8 downto 1) <= x"21";	data(0) <= not(BCD(0));	-- D
						when "1110"	=>	data(8 downto 1) <= x"06";	data(0) <= not(BCD(0));	-- E
						when "1111"	=>	data(8 downto 1) <= x"0E";	data(0) <= not(BCD(0));	-- F
						when others =>	data <= x"FF";											-- LEER
					end case;
				else
					DIGIT <= (others => '1');
					 data <= (others => '1');
				end if;
			end if;
		  DIGIT <= not(POS); 
		SEGMENT <= data(7 downto 0);
	end process;
end Behavioral;
