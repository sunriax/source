--	------------------------------------
--	Diplomarbeit elmProject@HTL-Rankweil
--	GÄCHTER Raffael                     
--	elm-project@sunriax.at              
--	2AAELI | 2016/2017                  
--	------------------------------------
--	File: address_tb.vhdl                    
--	Version: v1.0                       
--	------------------------------------

library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use UNISIM.VComponents.all;

entity address_tb is
--  Port ( );
end address_tb;

architecture Simulation of address_tb is

-- Definierte Konstanten
constant nWIDTH : integer := 16;			-- Buslänge
constant CLK_period : time := 200 ns;		-- Systemtakt 20 MHz

	component address is
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
	end component address;

signal simEN, simCLK, simZERO, simIpp, simImm	: STD_LOGIC;
signal simldADDR, simldSTOP, simADDR			: STD_LOGIC_VECTOR(nWIDTH - 1 downto 0);

begin
UUT: address port map	(
						EN		=>	simEN,
						CLK		=>	simCLK,
						ZERO	=>	simZERO,
						Ipp		=>	simIpp,
						Imm		=>	simImm,
						ldADDR	=>	simldADDR,
						ldSTOP	=>	simldSTOP,
						ADDR	=>	simADDR
						);

CLK_process: process
	begin
		simCLK <= '0';	wait for CLK_period/2;
		simCLK <= '1';	wait for CLK_period/2;
end process;

process
	begin
		-- Nullsetzen
		simEN <= '0';	simZERO <= '0';	simIpp <= '0';	simImm	<= '0';
						simldADDR <= x"0000";	simldSTOP <= x"0000";		wait for CLK_period * 4;
		-- Höchste Adresse laden 0xFF = 65535
		simEN <= '1';	simZERO <= '1';	simIpp <= '1';	simImm	<= '0';
						simldADDR <= x"0000";	simldSTOP <= x"FFFF";		wait for CLK_period * 20;
		-- Nullsetzen
		simEN <= '1';	simZERO <= '0';	simIpp <= '0';	simImm	<= '0';
						simldADDR <= x"0000";	simldSTOP <= x"0000";		wait for CLK_period * 4;
		-- Startadresse eingeben 0x000F = 16	-- Stopadresse eingeben 0x009F
		simEN <= '1';	simZERO <= '1';	simIpp <= '0';	simImm	<= '0';
						simldADDR <= x"0003";	simldSTOP <= x"000F";		wait for CLK_period * 2;
		simEN <= '1';	simZERO <= '1';	simIpp <= '1';	simImm	<= '0';
						simldADDR <= x"0003";	simldSTOP <= x"000F";		wait for CLK_period * 20;

	wait;
end process;
end Simulation;
