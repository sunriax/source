--	------------------------------------
--	Diplomarbeit elmProject@HTL-Rankweil
--	G.Raf@elmProject
--	2AAELI | 2016/2017
--	------------------------------------
--	File: display_tb.vhd
--	Version: v1.0
--	------------------------------------
--	Testbench zur display IP mit
--	Standardparametern.
--	------------------------------------

library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use UNISIM.VComponents.all;

entity display_tb is
--  Port ( );
end display_tb;

architecture Simulation of display_tb is

	-- Simulationskonstanten
	constant CLK800x600_period		: time := 25 ns;		-- Systemtakt 40 MHz
	constant CLK1024x768_period		: time := 15 ns;		-- Systemtakt ca. 65 MHz
	constant CLK1280x1024_period	: time := 9 ns;			-- Systemtakt ca. 108 MHz
	constant nCHANNEL	: integer := 1;			-- Anzahl der Wählbaren Kanäle 2^nCHANNEL
	constant pxDATASIZE	: integer := 4;			-- Pixel Auflösung in Bit pro Kanal
	constant pxMAX		: integer := 12;		-- max. Anzahl an Pixeln (horizontal/vertikal) 2^pxMAX

	-- Simulations I/O Signale
	signal simEN			: STD_LOGIC;
	signal simCLK1280x1024	: STD_LOGIC;
	signal simCLK1024x768	: STD_LOGIC;
	signal simCLK800x600	: STD_LOGIC;
	signal simvgaMODE		: STD_LOGIC_VECTOR((2**nCHANNEL) - 1 downto 0);
	signal simpixelDATA		: STD_LOGIC_VECTOR((pxDATASIZE * 3) - 1 downto 0);
	signal simh_SYNC		: STD_LOGIC;
	signal simv_SYNC		: STD_LOGIC;
	signal simvgaR			: STD_LOGIC_VECTOR(pxDATASIZE - 1 downto 0);
	signal simvgaG			: STD_LOGIC_VECTOR(pxDATASIZE - 1 downto 0);
	signal simvgaB			: STD_LOGIC_VECTOR(pxDATASIZE - 1 downto 0);
	signal simpixelX		: STD_LOGIC_VECTOR(pxMAX - 1 downto 0);
	signal simpixelY		: STD_LOGIC_VECTOR(pxMAX - 1 downto 0);

	-- Komponentendeklaration
	component display is
		Port	(
				EN				:  in STD_LOGIC;
				CLK1280x1024	:  in STD_LOGIC;
				CLK1024x768		:  in STD_LOGIC;
				CLK800x600		:  in STD_LOGIC;
				vgaMODE			:  in STD_LOGIC_VECTOR((2**nCHANNEL) - 1 downto 0);
				pixelDATA		:  in STD_LOGIC_VECTOR((pxDATASIZE * 3) - 1 downto 0);
				h_SYNC			: out STD_LOGIC;
				v_SYNC			: out STD_LOGIC;
				vgaR			: out STD_LOGIC_VECTOR(pxDATASIZE - 1 downto 0);
				vgaG			: out STD_LOGIC_VECTOR(pxDATASIZE - 1 downto 0);
				vgaB			: out STD_LOGIC_VECTOR(pxDATASIZE - 1 downto 0);
				pixelX			: out STD_LOGIC_VECTOR(pxMAX - 1 downto 0);
				pixelY			: out STD_LOGIC_VECTOR(pxMAX - 1 downto 0)
				);
	end component display;

begin

-- Clock Singal erzeugen
simCLK1280x1024_PROC:	process
							begin
							simCLK1280x1024 <= '0';	wait for CLK1280x1024_period/2;
							simCLK1280x1024 <= '1';	wait for CLK1280x1024_period/2;
						end process simCLK1280x1024_PROC;

simCLK1024x768_PROC:	process
							begin
							simCLK1024x768 <= '0';	wait for CLK1024x768_period/2;
							simCLK1024x768 <= '1';	wait for CLK1024x768_period/2;
						end process simCLK1024x768_PROC;

simCLK800x600_PROC:		process
							begin
							simCLK800x600 <= '0';	wait for CLK800x600_period/2;
							simCLK800x600 <= '1';	wait for CLK800x600_period/2;
						end process simCLK800x600_PROC;

-- Unit under Test
UUT: display port map(
					EN				=> simEN,
					CLK1280x1024	=> simCLK1280x1024,
					CLK1024x768		=> simCLK1024x768,
					CLK800x600		=> simCLK800x600,
					vgaMODE			=> simvgaMODE,
					pixelDATA		=> simpixelDATA,
					h_SYNC			=> simh_SYNC,
					v_SYNC			=> simv_SYNC,
					vgaR			=> simvgaR,
					vgaG			=> simvgaG,
					vgaB			=> simvgaB,
					pixelX			=> simpixelX,
					pixelY			=> simpixelY
					);

-- Testbench Input Signale
process
	begin
		simEN <= '0';	simpixelDATA <= (others => '0');	simvgaMODE <= (others => '0');	wait for CLK1280x1024_period * 2;
		simEN <= '1';	simpixelDATA <= (others => '1');	simvgaMODE <= "01";				wait for CLK800x600_period	 * 8000;
						simpixelDATA <= (others => '1');	simvgaMODE <= "10";				wait for CLK1024x768_period  * 10000;
						simpixelDATA <= (others => '1');	simvgaMODE <= "11";				wait for CLK1280x1024_period * 10000;
		simEN <= '0';	simpixelDATA <= (others => '0');	simvgaMODE <= (others => '0');	wait for CLK1280x1024_period * 2;
		wait;
end process;

end Simulation;
