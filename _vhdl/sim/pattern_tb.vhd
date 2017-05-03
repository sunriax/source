--	------------------------------------
--	Diplomarbeit elmProject@HTL-Rankweil
--	G.Raf@elmProject
--	2AAELI | 2016/2017
--	------------------------------------
--	File: pattern_tb.vhd
--	Version: v1.0
--	------------------------------------
--	Testbench zur master IP mit
--	Standardparametern.
--	------------------------------------

library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use UNISIM.VComponents.all;

entity pattern_tb is
--  Port ( );
end pattern_tb;

architecture Simulation of pattern_tb is

	-- Simulationskonstanten
	constant CLK_period : time := 6 ns;    -- Systemtakt 166,66 MHz
	constant nCHANNEL	: integer := 1;
	constant pxDATASIZE	: integer := 4;
	constant pxMAX		: integer := 12;

	-- Simulations I/O Signale
	signal simCLK		: STD_LOGIC;
	signal simEN		: STD_LOGIC;
	signal simvgaTEST	: STD_LOGIC;
	signal simvgaMODE	: STD_LOGIC_VECTOR(nCHANNEL downto 0);
	signal simpixelX	: STD_LOGIC_VECTOR(pxMAX - 1 downto 0);
	signal simpixelY	: STD_LOGIC_VECTOR(pxMAX - 1 downto 0);
	signal simvgaDATA	: STD_LOGIC_VECTOR((pxDATASIZE * 3) - 1 downto 0);
	signal simpixelDATA	: STD_LOGIC_VECTOR((pxDATASIZE * 3) - 1 downto 0);

	-- Komponentendeklaration
	component pattern is
		Port(
			EN			:  in STD_LOGIC;
			CLK			:  in STD_LOGIC;
			vgaTEST		:  in STD_LOGIC;
			vgaMODE		:  in STD_LOGIC_VECTOR(nCHANNEL downto 0);
			pixelX		:  in STD_LOGIC_VECTOR(pxMAX - 1 downto 0);
			pixelY		:  in STD_LOGIC_VECTOR(pxMAX - 1 downto 0);
			vgaDATA		:  in STD_LOGIC_VECTOR((pxDATASIZE * 3) - 1 downto 0);
			pixelDATA	: out STD_LOGIC_VECTOR((pxDATASIZE * 3) - 1 downto 0)
			);
	end component pattern;

begin

-- Clock Singal erzeugen
simCLK_PROC:	process
					begin
					simCLK <= '0';	wait for CLK_period/2;
					simCLK <= '1';	wait for CLK_period/2;
				end process simCLK_PROC;

-- Unit under Test
UUT: pattern port map(
					EN			=> simEN,
					CLK			=> simCLK,
					vgaTEST		=> simvgaTEST,
					vgaMODE		=> simvgaMODE,
					pixelX		=> simpixelX,
					pixelY		=> simpixelY,
					vgaDATA		=> simvgaDATA,
					pixelDATA 	=> simpixelDATA
					);
-- Testbench Input Signale
process
	begin
		simEN <= '0';	simvgaTEST <= '0';	simvgaMODE <= (others => '0');	simpixelX <= (others => '0');	simpixelY <= (others => '0');	simvgaDATA <= (others => '0');		wait for CLK_period * 2;
		simEN <= '1';	simvgaTEST <= '1';	simvgaMODE <= "11";				simpixelX <= x"000"; 			simpixelY <= x"000"; 			simvgaDATA <= (others => '1');		wait for CLK_period * 100;
						simvgaTEST <= '1';	simvgaMODE <= "11";				simpixelX <= x"2BC"; 			simpixelY <= x"001"; 			simvgaDATA <= (others => '0');		wait for CLK_period * 100;
						simvgaTEST <= '1';	simvgaMODE <= "11";				simpixelX <= x"000"; 			simpixelY <= x"2BC"; 			simvgaDATA <= (others => '0');		wait for CLK_period * 100;
						simvgaTEST <= '1';	simvgaMODE <= "11";				simpixelX <= x"2BC"; 			simpixelY <= x"2BC"; 			simvgaDATA <= (others => '0');		wait for CLK_period * 100;
		wait;
end process;

end Simulation;
