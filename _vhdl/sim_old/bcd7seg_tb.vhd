--	------------------------------------
--	Diplomarbeit elmProject@HTL-Rankweil
--	GÄCHTER Raffael                     
--	elm-project@sunriax.at              
--	2AAELI | 2016/2017                  
--	------------------------------------
--	File: bcd7seg_tb.vhdl                    
--	Version: v1.0                       
--	------------------------------------

library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use UNISIM.VComponents.all;

entity bcd7seg_tb is
--  Port ( );
end bcd7seg_tb;

architecture Simulation of bcd7seg_tb is
	constant CLK_period : time := 200 ns;    -- 20 MHz
	constant nDIGIT : INTEGER := 4;

component bcd7seg is
	Port	(
			EN, CLK	: in STD_LOGIC;
			BCD		: in STD_LOGIC_VECTOR(4 downto 0);
			POS		: in STD_LOGIC_VECTOR(nDIGIT - 1 downto 0);
			DIGIT	: out STD_LOGIC_VECTOR(nDIGIT - 1 downto 0);
			SEGMENT	: out STD_LOGIC_VECTOR(7 downto 0)
			);
end component bcd7seg;

	signal simEN, simCLK	: STD_LOGIC;
	signal simBCD			: STD_LOGIC_VECTOR(4 downto 0);
	signal simPOS, simDIGIT	: STD_LOGIC_VECTOR(nDIGIT - 1 downto 0);
	signal simSEGMENT		: STD_LOGIC_VECTOR(7 downto 0);

begin

UUT: bcd7seg port map	(
						CLK		=>	simCLK,
						EN		=>	simEN,
						BCD		=> simBCD,
						POS		=> simPOS,
						DIGIT	=> simDIGIT,
						SEGMENT	=> simSEGMENT
						);

CLK_process: process
	begin
		simCLK <= '0';	wait for CLK_period/2;
		simCLK <= '1';	wait for CLK_period/2;
end process;

process
	begin

end process;
end Simulation;
