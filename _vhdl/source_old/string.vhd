--	------------------------------------
--	Diplomarbeit elmProject@HTL-Rankweil
--	GÄCHTER Raffael                     
--	elm-project@sunriax.at              
--	2AAELI | 2016/2017                  
--	------------------------------------
--	File: string.vhdl                    
--	Version: v1.0                       
--	------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
-- use IEEE.STD_LOGIC_ARITH.ALL; // niemals beide NUMERIC_STD und STD_LOGIC_ARITH verwenden!!!
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity string is
	Port	(
			EN : in STD_LOGIC;
			CLK : in STD_LOGIC;
			write : in STD_LOGIC_VECTOR (7 downto 0);
			read : in STD_LOGIC_VECTOR (7 downto 0);
			data_out : in STD_LOGIC_VECTOR (7 downto 0);
			data_in : out STD_LOGIC_VECTOR (7 downto 0);
			di : in  STD_LOGIC_VECTOR (3 downto 0); 
			do : out STD_LOGIC_VECTOR (7 downto 0)
			);
end string;

architecture Behavioral of string is
	type charROM is array (0 to 15) of std_logic_vector (7 downto 0);
	constant BCDRom : charROM :=	( 
									std_logic_vector(to_unsigned(character'pos('0'),8)),
									std_logic_vector(to_unsigned(character'pos('1'),8)),
									std_logic_vector(to_unsigned(character'pos('2'),8)),
									std_logic_vector(to_unsigned(character'pos('3'),8)),
									std_logic_vector(to_unsigned(character'pos('4'),8)),
									std_logic_vector(to_unsigned(character'pos('5'),8)),
									std_logic_vector(to_unsigned(character'pos('6'),8)),
									std_logic_vector(to_unsigned(character'pos('7'),8)),
									std_logic_vector(to_unsigned(character'pos('8'),8)),
									std_logic_vector(to_unsigned(character'pos('9'),8)),
									std_logic_vector(to_unsigned(character'pos('A'),8)),
									std_logic_vector(to_unsigned(character'pos('B'),8)),
									std_logic_vector(to_unsigned(character'pos('C'),8)),
									std_logic_vector(to_unsigned(character'pos('D'),8)),
									std_logic_vector(to_unsigned(character'pos('E'),8)),
									std_logic_vector(to_unsigned(character'pos('F'),8)));

	signal myvec	: std_logic_vector(7 downto 0) ;
	signal mychar	: character ;						-- This is your character 

begin
	myvec <= std_logic_vector(to_unsigned(natural(character'pos(mychar)), 8)) ; 

	do <= std_logic_vector(to_unsigned(character'pos('0')+to_integer(unsigned(di)),8));
	do <= x"3" & di;

end Behavioral;
