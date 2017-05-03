--	------------------------------------
--	Diplomarbeit elmProject@HTL-Rankweil
--	G.Raf@elmProject
--	2AAELI | 2016/2017
--	------------------------------------
--	File: multiplexer.vhd
--	Version: v1.0
--	------------------------------------
--	Signalmultiplexer zum wandeln von
--	parallellen zu seriellen Signalen
--	------------------------------------

-- Standardbibliotheken einbinden
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pattern is
Generic	(
		-- Wählbare auflösungen
		nCHANNEL		: integer := 1;			-- 2^nCHANNEL Anzahl möglicher Auflösungen
		
		-- Pixel Einstellungen
		pxDATASIZE		: integer := 4;			-- Pixel Auflösung in Bit pro Kanal
		pxMAX			: integer := 12			-- max. Anzahl an Pixeln (horizontal/vertikal) 2^pxMAX
		);
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
end pattern;

architecture Behavioral of pattern is
	-- Systemtakt
	signal nCLK			: integer;		-- VGA Systemtakt
	signal nPATTERN		: integer;				-- Mustergenerator Takt nCLK/nPATTERN
	
	-- Horizontale Einstellungen
	signal h_DISPLAY	: integer;	-- Sichtbarer Bereich in Pixel
	-- Vertiakle Einstellungen
	signal v_DISPLAY	: integer;	-- Sichtbarer Bereich in Pixel
	
	signal intpixelDATA	: STD_LOGIC_VECTOR((pxDATASIZE * 3) - 1 downto 0) := (others => '0');
	signal intPATTERN	: STD_LOGIC_VECTOR(pxDATASIZE - 1 downto 0) := (others => '0');
begin

	-- Pixel Daten ausgeben
	pixelDATA <= intpixelDATA;

	-- Einstellung der Bildschirmauflösung
	process(EN, CLK, vgaTEST, vgaMODE)
		begin
			if(rising_edge(CLK) and EN = '1' and vgaTEST = '1') Then
				case(vgaMODE) is	
					when "01"	=>	nCLK <= 40000000;	nPATTERN <= 2;	h_DISPLAY <= 800;	v_DISPLAY <= 600;
					when "10"	=>	nCLK <= 65000000;	nPATTERN <= 4;	h_DISPLAY <= 1024;	v_DISPLAY <= 768;
					when others	=>	nCLK <= 108000000;	nPATTERN <= 6;	h_DISPLAY <= 1280;	v_DISPLAY <= 1024;
				end case;
			end if;
	end process;

	-- Mustergenerator
	process(EN, CLK, vgaMODE)
			variable patternCNT 	: integer range 0 to 20000000 := 0;
			variable patternDATA	: unsigned(pxDATASIZE - 1 downto 0) := (others => '0');
		begin
			if(EN = '0' or vgaMODE = "00") Then
				
				patternCNT  := 0;
				patternDATA := (others => '0');
				
			elsif(rising_edge(CLK)) Then
				
				-- Wenn Farbmusterzähler >= Systemtakt / Teiler
				if(patternCNT < (nCLK/nPATTERN)) Then
				
					-- Farbmusterzähler inkrementieren
					patternCNT := patternCNT + 1;

				else
					-- Farbmusterzähler rücksetzten
					patternCNT := 0;
					patternDATA :=  patternDATA + 1;
					
				end if;
			
			end if;
			
			intPATTERN <= STD_LOGIC_VECTOR(patternDATA);
			
	end process;

	-- Standardausgabe / Musterausgabe
	process(CLK, EN, vgaMODE)
		begin
			if(EN = '0' or vgaMODE = "00") Then
				
				intpixelDATA <= (others => '0');
				
			elsif(falling_edge(CLK)) Then
			
				if(vgaTEST = '0') Then
				
					-- Eingabedaten direkt auf Ausgabedaten legen
					intpixelDATA <= vgaDATA;
				
				else
				
					--Weißes Fadenkreuz erzeugen
					if(	(pixelX >= ((h_DISPLAY / 2) - 5) and (pixelX <= ((h_DISPLAY / 2) +5))) or
						(pixelY >= ((v_DISPLAY / 2) - 5) and (pixelY <= ((v_DISPLAY / 2) +5)))) Then
							intpixelDATA((pxDATASIZE * 3) - 1 downto pxDATASIZE * 2) <= (others => '1');
							intpixelDATA((pxDATASIZE * 2) - 1 downto pxDATASIZE)	 <= (others => '1');
							intpixelDATA(pxDATASIZE - 1 downto 0)					 <= (others => '1');
					end if;
					
					--	Das Testpattern besteht aus folgenden Bereichen
					--	+---------------+---------------+
					--	|	Bereich 1	|	Bereich 2	|
					--	+---------------+---------------+
					--	|	Bereich 3	|	Bereich 4	|
					--	+---------------+---------------+
					
					-- Farbmuster ROT in Bereich 1 erzeugen
					if(	(pixelX >= 0 and (pixelX < ((h_DISPLAY / 2) - 5))) and
						(pixelY >= 0 and (pixelY < ((v_DISPLAY / 2) - 5)))) Then
							
							-- Farbmuster ROT ausgeben
							intpixelDATA((pxDATASIZE * 3) - 1 downto pxDATASIZE * 2) <= intPATTERN;
							intpixelDATA((pxDATASIZE * 2) - 1 downto pxDATASIZE)	 <= (others => '0');
							intpixelDATA(pxDATASIZE - 1 downto 0)					 <= (others => '0');
							
					end if;
					
					-- Farbmuster GRÜN in Bereich 2 erzeugen
					if(	(pixelX >= ((h_DISPLAY / 2) + 5) and (pixelX < (h_DISPLAY - 1))) and
						(pixelY >= 0					 and (pixelY < ((v_DISPLAY / 2) - 5)))) Then
							
							-- Farbmuster GRÜN ausgeben
							intpixelDATA((pxDATASIZE * 3) - 1 downto pxDATASIZE * 2) <= (others => '0');
							intpixelDATA((pxDATASIZE * 2) - 1 downto pxDATASIZE)	 <= intPATTERN;
							intpixelDATA(pxDATASIZE - 1 downto 0)					 <= (others => '0');
					end if;
					
					-- Farbmuster BLAU in Bereich 3 erzeugen
					if(	(pixelX >= 0					 and (pixelX < ((h_DISPLAY / 2) - 5))) and
						(pixelY >= ((v_DISPLAY / 2) + 5) and (pixelY <= (v_DISPLAY - 1)))) Then
							
							-- Farbmuster BLAU ausgeben
							intpixelDATA((pxDATASIZE * 3) - 1 downto pxDATASIZE * 2) <= (others => '0');
							intpixelDATA((pxDATASIZE * 2) - 1 downto pxDATASIZE)	 <= (others => '0');
							intpixelDATA(pxDATASIZE - 1 downto 0)					 <= intPATTERN;
					end if;
					
					-- Farbmuster ROT/GRÜN/BLAU überlagert in Bereich 4 erzeugen
					if ((pixelX >= ((h_DISPLAY / 2) + 5) and (pixelX < (h_DISPLAY - 1))) and
						(pixelY >= ((v_DISPLAY / 2) + 5) and (pixelY <= (v_DISPLAY - 1)))) Then
							
							-- Farbmuster ROT/GRÜN/BLAU überlagert ausgeben
							intpixelDATA((pxDATASIZE * 3) - 1 downto pxDATASIZE * 2) <= intPATTERN;
							intpixelDATA((pxDATASIZE * 2) - 1 downto pxDATASIZE)	 <= intPATTERN;
							intpixelDATA(pxDATASIZE - 1 downto 0)					 <= intPATTERN;
					end if;
				end if;
			end if;

	end process;

end Behavioral;
