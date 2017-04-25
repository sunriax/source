--	------------------------------------
--	Diplomarbeit elmProject@HTL-Rankweil
--	G.Raf@elmProject
--	2AAELI | 2016/2017
--	------------------------------------
--	File: vga_tb.vhd
--	Version: v1.0
--	------------------------------------
--	Testbench zur vga IP mit
--	Standardparametern.
--	------------------------------------

library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use UNISIM.VComponents.all;

entity vga_tb is
--  Port ( );
end vga_tb;

architecture Simulation of vga_tb is

	-- Simulationskonstanten
	constant CLK_period : time := 9259 ps;    -- Systemtakt 100 MHz
	constant pxDATASIZE	: integer := 4;			-- Pixel Auflösung in Bit pro Kanal
	constant pxMAX		: integer := 12;		-- max. Anzahl an Pixeln (horizontal/vertikal) 2^pxMAX

	-- Simulations I/O Signale
	signal simCLK		: STD_LOGIC;
	signal simEN		: STD_LOGIC;
	signal simpixelDATA	: STD_LOGIC_VECTOR((pxDATASIZE * 3) - 1 downto 0);
	signal simh_SYNC	: STD_LOGIC;
	signal simv_SYNC	: STD_LOGIC;
	signal simvgaR		: STD_LOGIC_VECTOR(pxDATASIZE - 1 downto 0);
	signal simvgaG		: STD_LOGIC_VECTOR(pxDATASIZE - 1 downto 0);
	signal simvgaB		: STD_LOGIC_VECTOR(pxDATASIZE - 1 downto 0);
	signal simpixelX	: integer range 0 to 2**pxMAX;
	signal simpixelY	: integer range 0 to 2**pxMAX;

	-- Komponentendeklaration
	component vga is
	Port	(
			EN				:  in STD_LOGIC;
			CLK				:  in STD_LOGIC;
			pixelDATA		:  in STD_LOGIC_VECTOR((pxDATASIZE * 3) - 1 downto 0);
			h_SYNC			: out STD_LOGIC;
			v_SYNC			: out STD_LOGIC;
			vgaR			: out STD_LOGIC_VECTOR(pxDATASIZE - 1 downto 0);
			vgaG			: out STD_LOGIC_VECTOR(pxDATASIZE - 1 downto 0);
			vgaB			: out STD_LOGIC_VECTOR(pxDATASIZE - 1 downto 0);
			pixelX			: out integer range 0 to 2**pxMAX;
			pixelY			: out integer range 0 to 2**pxMAX
			);
	end component vga;

begin

-- Clock Singal erzeugen
simCLK_PROC:	process
					begin
					simCLK <= '0';	wait for CLK_period/2;
					simCLK <= '1';	wait for CLK_period/2;
				end process simCLK_PROC;

-- Unit under Test
UUT: vga port map(
					EN			=> simEN,
					CLK			=> simCLK,
					pixelDATA	=> simpixelDATA,
					h_SYNC		=> simh_SYNC,
					v_SYNC		=> simv_SYNC,
					vgaR		=> simvgaR,
					vgaG		=> simvgaG,
					vgaB		=> simvgaB,
					pixelX		=> simpixelX,
					pixelY		=> simpixelY
					);

-- Testbench Input Signale
process
	begin
		simEN <= '0';	simpixelDATA <= (others => '0');	wait for CLK_period * 2;
		simEN <= '1';	simpixelDATA <= (others => '0');	wait for CLK_period * 10000;
		simEN <= '0';	simpixelDATA <= (others => '0');	wait for CLK_period * 2;
		simEN <= '1';	simpixelDATA <= (others => '1');	wait for CLK_period * 10000;
		wait;
end process;

end Simulation;
