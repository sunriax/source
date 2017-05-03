--	------------------------------------
--	Diplomarbeit elmProject@HTL-Rankweil
--	G.Raf@elmProject
--	2AAELI | 2016/2017
--	------------------------------------
--	File: vga.vhd
--	Version: v1.0
--	------------------------------------
--	VGA Ausgabemodul zum erzeugen der
--	benötigten Horizontal/Vertikalen
--	Synchronisierungssignale sowie zur
--	Einstellung der Auflösung und der
--	anzeige der Pixelposition
--	------------------------------------

-- Standardbibliotheken einbinden
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity display is
	Generic	(
			-- Auflösung 1280x1024@60Hz
			nCLK1280x1024	: integer := 108000000;	--108 MHz @ 60 Hz
			nCLK1024x768	: integer := 65000000;	-- 65 MHz @ 60 Hz
			nCLK800x600		: integer := 40000000;	-- 40 MHz @ 60 Hz
			
			-- Wählbare auflösungen
			nCHANNEL		: integer := 1;			-- 2^nCHANNEL Anzahl möglicher Auflösungen
			
			-- Pixel Einstellungen
			pxDATASIZE		: integer := 4;			-- Pixel Auflösung in Bit pro Kanal
			pxMAX			: integer := 12			-- max. Anzahl an Pixeln (horizontal/vertikal) 2^pxMAX
			);
		Port(
			EN				:  in STD_LOGIC;
			
			-- VGA Taktfrequenzen
			CLK1280x1024	:  in STD_LOGIC;
			CLK1024x768		:  in STD_LOGIC;
			CLK800x600		:  in STD_LOGIC;
			
			-- VGA Einstellungen
			vgaMODE			:  in STD_LOGIC_VECTOR((2**nCHANNEL) - 1 downto 0);
			
			-- Rot/Grün/Blau Daten für aktuellen Pixel
			pixelDATA		:  in STD_LOGIC_VECTOR((pxDATASIZE * 3) - 1 downto 0);
			
			-- Horizontal/Vertikal Synchronisierungssignal
			h_SYNC			: out STD_LOGIC;
			v_SYNC			: out STD_LOGIC;
			
			-- Ausgabedaten für Pixel auf welchen der Pixelzeiger referenziert ist
			vgaR			: out STD_LOGIC_VECTOR(pxDATASIZE - 1 downto 0);
			vgaG			: out STD_LOGIC_VECTOR(pxDATASIZE - 1 downto 0);
			vgaB			: out STD_LOGIC_VECTOR(pxDATASIZE - 1 downto 0);
			
			-- Positionsdaten des Pixelzeigers
			pixelX			: out STD_LOGIC_VECTOR(pxMAX - 1 downto 0);
			pixelY			: out STD_LOGIC_VECTOR(pxMAX - 1 downto 0)
			);
end display;

architecture Structure of display is

	component vga is
		Generic	(
				-- Systemtakt
				nCLK			: integer;
				nPATTERN		: integer;
				h_DISPLAY		: integer;
				h_porchFRONT	: integer;
				h_porchBACK		: integer;
				h_syncPULSE		: integer;
				h_POLARITY		: STD_LOGIC;
				v_DISPLAY		: integer;
				v_porchFRONT	: integer;
				v_porchBACK		: integer;
				v_syncPULSE		: integer;
				v_POLARITY		: STD_LOGIC;
				pxDATASIZE		: integer;
				pxMAX			: integer
				);
		Port	(
				EN				:  in STD_LOGIC;
				CLK				:  in STD_LOGIC;
				pixelDATA		:  in STD_LOGIC_VECTOR((pxDATASIZE * 3) - 1 downto 0);
				h_SYNC			: out STD_LOGIC;
				v_SYNC			: out STD_LOGIC;
				vgaR			: out STD_LOGIC_VECTOR(pxDATASIZE - 1 downto 0);
				vgaG			: out STD_LOGIC_VECTOR(pxDATASIZE - 1 downto 0);
				vgaB			: out STD_LOGIC_VECTOR(pxDATASIZE - 1 downto 0);
				pixelX			: out integer range 0 to (2**pxMAX - 1);
				pixelY			: out integer range 0 to (2**pxMAX - 1)
				);
	end component vga;

	-- Mögliche Addressen
	--signal intADDR		: STD_LOGIC_VECTOR(((2**nCHANNEL) * 2)- 1 downto 0);

	-- Interne Signale für Auflösung 1280x1024
	signal intEN1280x1024		: STD_LOGIC := '0';
	signal intpixelX1280x1024	: integer range 0 to (2**pxMAX - 1) := 0;
	signal intpixelY1280x1024	: integer range 0 to (2**pxMAX - 1) := 0;
	signal intvgaR1280x1024		: STD_LOGIC_VECTOR(pxDATASIZE - 1 downto 0) := (others => '0');
	signal intvgaG1280x1024		: STD_LOGIC_VECTOR(pxDATASIZE - 1 downto 0) := (others => '0');
	signal intvgaB1280x1024		: STD_LOGIC_VECTOR(pxDATASIZE - 1 downto 0) := (others => '0');
	signal inthSYNC1280x1024	: STD_LOGIC := '0';
	signal intvSYNC1280x1024	: STD_LOGIC := '0';
	
	-- Interne Signale für Auflösung 1024x768
	signal intEN1024x768		: STD_LOGIC := '0';
	signal intpixelX1024x768	: integer range 0 to (2**pxMAX - 1) := 0;
	signal intpixelY1024x768	: integer range 0 to (2**pxMAX - 1) := 0;
	signal intvgaR1024x768		: STD_LOGIC_VECTOR(pxDATASIZE - 1 downto 0) := (others => '0');
	signal intvgaG1024x768		: STD_LOGIC_VECTOR(pxDATASIZE - 1 downto 0) := (others => '0');
	signal intvgaB1024x768		: STD_LOGIC_VECTOR(pxDATASIZE - 1 downto 0) := (others => '0');
	signal inthSYNC1024x768		: STD_LOGIC := '0';
	signal intvSYNC1024x768		: STD_LOGIC := '0';

	-- Interne Signale für Auflösung 800x600
	signal intEN800x600			: STD_LOGIC := '0';
	signal intpixelX800x600		: integer range 0 to (2**pxMAX - 1) := 0;
	signal intpixelY800x600		: integer range 0 to (2**pxMAX - 1) := 0;
	signal intvgaR800x600		: STD_LOGIC_VECTOR(pxDATASIZE - 1 downto 0) := (others => '0');
	signal intvgaG800x600		: STD_LOGIC_VECTOR(pxDATASIZE - 1 downto 0) := (others => '0');
	signal intvgaB800x600		: STD_LOGIC_VECTOR(pxDATASIZE - 1 downto 0) := (others => '0');
	signal inthSYNC800x600		: STD_LOGIC := '0';
	signal intvSYNC800x600		: STD_LOGIC := '0';

begin

-- VGA Synchronsierungssignale
h_SYNC <= (inthSYNC800x600 or inthSYNC1024x768 or inthSYNC1280x1024) WHEN EN = '1' ELSE '0';
v_SYNC <= (intvSYNC800x600 or intvSYNC1024x768 or intvSYNC1280x1024) WHEN EN = '1' ELSE '0';

-- VGA Datensignale (Farbkanäle)
vgaR <= (intvgaR800x600 or intvgaR1024x768 or intvgaR1280x1024) WHEN EN = '1' ELSE (others => '0');
vgaG <= (intvgaG800x600 or intvgaG1024x768 or intvgaG1280x1024) WHEN EN = '1' ELSE (others => '0');
vgaB <= (intvgaB800x600 or intvgaB1024x768 or intvgaB1280x1024) WHEN EN = '1' ELSE (others => '0');

pixelX <= STD_LOGIC_VECTOR(to_unsigned(intpixelX800x600,  pxMAX)) or STD_LOGIC_VECTOR(to_unsigned(intpixelX1024x768,   pxMAX)) or STD_LOGIC_VECTOR(to_unsigned(intpixelX1280x1024,   pxMAX)) WHEN EN = '1' ELSE (others => '0');
pixelY <= STD_LOGIC_VECTOR(to_unsigned(intpixelY800x600,  pxMAX)) or STD_LOGIC_VECTOR(to_unsigned(intpixelY1024x768,   pxMAX)) or STD_LOGIC_VECTOR(to_unsigned(intpixelY1280x1024,   pxMAX)) WHEN EN = '1' ELSE (others => '0');

-- Anwahl des VGA Moduls
--process(vgaMODE)
--	begin
--		case(vgaMODE) is
--			when "01"	=>	intADDR <= "0010";	-- Anwahl Auflösung 800x600
--			when "10"	=>	intADDR <= "0100";	-- Anwahl Auflösung 1024x768
--			when "11"	=>	intADDR <= "1000";	-- Anwahl Auflösung 1280x1024
--			when others	=>	intADDR <= "0001";	-- Anwahl Standardauflösung 640x480
--		end case;
--end process;

process(EN, CLK800x600, vgaMODE)
	begin
		if(EN = '0' or vgaMODE /= "01") Then
			intEN800x600 <= '0';
		elsif(rising_edge(CLK800x600) and EN = '1' and vgaMODE = "01") Then
			intEN800x600 <= '1';
		end if;
end process;

process(EN, CLK1024x768, vgaMODE)
	begin
		if(EN = '0' or vgaMODE /= "10") Then
			intEN1024x768 <= '0';
		elsif(rising_edge(CLK1024x768) and EN = '1' and vgaMODE = "10") Then
			intEN1024x768 <= '1';
		end if;
end process;

process(EN, CLK1280x1024, vgaMODE)
	begin
		if(EN = '0' or vgaMODE /= "11") Then
			intEN1280x1024 <= '0';
		elsif(rising_edge(CLK1280x1024) and EN = '1' and vgaMODE = "11") Then
			intEN1280x1024 <= '1';
		end if;
end process;

VGA800x600:		vga generic map	(
								nCLK			=>	nCLK800x600,
								nPATTERN		=>	4,
								h_DISPLAY		=>	800,
								h_porchFRONT	=>	40,
								h_porchBACK		=>	88,
								h_syncPULSE		=>	128,
								h_POLARITY		=>	'1',
								v_DISPLAY		=>	600,
								v_porchFRONT	=>	1,
								v_porchBACK		=>	23,
								v_syncPULSE		=>	4,
								v_POLARITY		=>	'1',
								pxDATASIZE		=>	pxDATASIZE,
								pxMAX			=>	pxMAX
								)
						port map(
								EN			=>	intEN800x600,
								CLK			=>	CLK800x600,
								pixelDATA	=>	pixelDATA,
								h_SYNC		=>	inthSYNC800x600,
								v_SYNC		=>	intvSYNC800x600,
								vgaR		=>	intvgaR800x600,
								vgaG		=>	intvgaG800x600,
								vgaB		=>	intvgaB800x600,
								pixelX		=>	intpixelX800x600,
								pixelY		=>	intpixelY800x600
								);

VGA1024x768:	vga generic map	(
								nCLK			=>	nCLK1024x768,
								nPATTERN		=>	4,
								h_DISPLAY		=>	1024,
								h_porchFRONT	=>	24,
								h_porchBACK		=>	160,
								h_syncPULSE		=>	136,
								h_POLARITY		=>	'0',
								v_DISPLAY		=>	768,
								v_porchFRONT	=>	3,
								v_porchBACK		=>	29,
								v_syncPULSE		=>	6,
								v_POLARITY		=>	'0',
								pxDATASIZE		=>	pxDATASIZE,
								pxMAX			=>	pxMAX
								)
						port map(
								EN			=>	intEN1024x768,
								CLK			=>	CLK1024x768,
								pixelDATA	=>	pixelDATA,
								h_SYNC		=>	inthSYNC1024x768,
								v_SYNC		=>	intvSYNC1024x768,
								vgaR		=>	intvgaR1024x768,
								vgaG		=>	intvgaG1024x768,
								vgaB		=>	intvgaB1024x768,
								pixelX		=>	intpixelX1024x768,
								pixelY		=>	intpixelY1024x768
								);

VGA1280x1024:	vga generic map	(
								nCLK			=>	nCLK1280x1024,
								nPATTERN		=>	4,
								h_DISPLAY		=>	1280,
								h_porchFRONT	=>	48,
								h_porchBACK		=>	248,
								h_syncPULSE		=>	112,
								h_POLARITY		=>	'1',
								v_DISPLAY		=>	1024,
								v_porchFRONT	=>	1,
								v_porchBACK		=>	38,
								v_syncPULSE		=>	3,
								v_POLARITY		=>	'1',
								pxDATASIZE		=>	pxDATASIZE,
								pxMAX			=>	pxMAX
								)
						port map(
								EN			=>	intEN1280x1024,
								CLK			=>	CLK1280x1024,
								pixelDATA	=>	pixelDATA,
								h_SYNC		=>	inthSYNC1280x1024,
								v_SYNC		=>	intvSYNC1280x1024,
								vgaR		=>	intvgaR1280x1024,
								vgaG		=>	intvgaG1280x1024,
								vgaB		=>	intvgaB1280x1024,
								pixelX		=>	intpixelX1280x1024,
								pixelY		=>	intpixelY1280x1024
								);

end Structure;
