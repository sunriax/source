--	------------------------------------
--	Diplomarbeit elmProject@HTL-Rankweil
--	GÄCHTER Raffael                     
--	elm-project@sunriax.at              
--	2AAELI | 2016/2017                  
--	------------------------------------
--	File: alu_tb.vhdl                    
--	Version: v1.0                       
--	------------------------------------

library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use UNISIM.VComponents.all;

entity alu_tb is
--  Port ( );
end alu_tb;

architecture Simulation of alu_tb is
component alu is
	Port(	EN			: in  STD_LOGIC;
			CLK			: in  STD_LOGIC;
			opA			: in  STD_LOGIC_VECTOR(7 downto 0);
			opB			: in  STD_LOGIC_VECTOR(7 downto 0);
			carryIN		: in  STD_LOGIC;
			MODE		: in  STD_LOGIC;
			CMD			: in  STD_LOGIC_VECTOR(3 downto 0);
			carryOUT	: out STD_LOGIC;
			zeroFLAG	: out STD_LOGIC;
			overFLOW	: out STD_LOGIC;
			DATA		: out STD_LOGIC_VECTOR(7 downto 0));
	end component alu;

	signal simEN, simCLK							: STD_LOGIC;
	signal simopA, simopB, simDATA					: STD_LOGIC_VECTOR(7 downto 0);
	signal simCMD									: STD_LOGIC_VECTOR(3 downto 0);
	signal simcI, simCo, simZERO, simoV, simMODE	: STD_LOGIC;

	constant CLK_period : time := 200 ns;    -- 20 MHz
	constant WIDTH : INTEGER := 8;
begin

UUT: alu port map	(
					EN			=> simEN,
					CLK			=> simCLK,
					opA			=> simopA,
					opB			=> simopB, 
					carryIN		=> simcI,
					MODE		=> simMODE,
					CMD			=> simCMD,
					carryOUT	=> simCo,
					zeroFLAG	=> simZERO,
					overFLOW	=> simoV,
					DATA		=> simDATA
					);

CLK_process: process
	begin
		simCLK <= '0';	wait for CLK_period/2;
		simCLK <= '1';	wait for CLK_period/2;
end process;

process
	begin
		simEN <= '0';	simMODE	<= '0';	simCMD <= x"0";	simopA <= x"00";
						  simcI <= '0';					simopB <= x"00";	wait for CLK_period*4;
		simEN <= '1';	simMODE	<= '0';	simCMD <= x"0";	simopA <= x"0F";
						  simcI <= '1';					simopB <= x"0B";	wait for CLK_period*2;
		simEN <= '1';	simMODE	<= '0';	simCMD <= x"0";	simopA <= x"0D";
						  simcI <= '0';					simopB <= x"A9";	wait for CLK_period*2;
		simEN <= '1';	simMODE	<= '1';	simCMD <= x"0";	simopA <= x"C5";
						  simcI <= '0';					simopB <= x"8A";	wait for CLK_period*2;
		simEN <= '0';	simMODE	<= '0';	simCMD <= x"0";	simopA <= x"00";
						  simcI <= '0';					simopB <= x"00";	wait;
end process;

end Simulation;

