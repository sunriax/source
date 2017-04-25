--	------------------------------------
--	Diplomarbeit elmProject@HTL-Rankweil
--	GÄCHTER Raffael
--	elm-project@sunriax.at
--	2AAELI | 2016/2017
--	------------------------------------
--	File: ram.vhdl
--	Version: v1.0
--	------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
-- use IEEE.STD_LOGIC_ARITH.ALL; // niemals beide NUMERIC_STD und STD_LOGIC_ARITH verwenden!!!
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ram is
	Generic	(
			nADDR_WIDTH	:	INTEGER := 8;		-- Adressbreite
			nWORD_WIDTH	:	INTEGER := 8;		-- Wortbreite
			tDELAY	:	time := 4 ns
			);		-- Gatter Laufzeiten
	Port (	EN, CLK, WE	: in  STD_LOGIC;									-- Enable/Clock
			inADDR		: in  STD_LOGIC_VECTOR(nADDR_WIDTH - 1 downto 0);	-- Operand A
			outADDR		: in  STD_LOGIC_VECTOR(nADDR_WIDTH - 1 downto 0);	-- Operand A
			inDATA		: in  STD_LOGIC_VECTOR(nWORD_WIDTH - 1 downto 0);	-- Operand B
			outDATA		: out STD_LOGIC_VECTOR(nWORD_WIDTH - 1 downto 0));	-- Data Out
end ram;

architecture Behavioral of ram is
	type DATA is array(0 to (2**nADDR_WIDTH) - 1) of unsigned(nWORD_WIDTH - 1 downto 0);
	signal RAM : DATA;
begin
	process(EN, CLK, WE, inADDR, outADDR, inDATA)
		begin
			if(EN = '0') then
				outDATA <= (others => '0');
			else
				if rising_edge(CLK) then
					if(WE = '1') then
						RAM(to_integer(unsigned(inADDR))) <= unsigned(inDATA);
					end if;
					
					outDATA <= std_logic_vector(RAM(to_integer(unsigned(outADDR)))); 
				end if;
			end if;	
	end process;
end Behavioral;
