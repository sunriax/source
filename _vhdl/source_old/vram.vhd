--	------------------------------------
--	Diplomarbeit elmProject@HTL-Rankweil
--	GÄCHTER Raffael                     
--	elm-project@sunriax.at              
--	2AAELI | 2016/2017                  
--	------------------------------------
--	File: vram.vhdl                    
--	Version: v1.0                       
--	------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;	--niemals beide NUMERIC_STD und STD_LOGIC_ARITH verwenden!!!
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity vram is
	Generic	(
			-- Auflösung 1280x1024@60Hz
			h_display		: INTEGER := 10;		-- Pixel 1280
			v_display		: INTEGER := 10;		-- Pixel
			inWIDTH			: INTEGER := 8;			-- Datenbreite
			outWIDTH		: INTEGER := 4			-- Ausgangs Datenbreite
			);
	Port	(
			EN			: in STD_LOGIC;
			WE			: in STD_LOGIC;
			CLK			: in STD_LOGIC;
			TEST		: in STD_LOGIC;
			
			posX		: in INTEGER range 0 to (h_display - 1) := 0;
			posY		: in INTEGER range 0 to (v_display - 1) := 0;
			
			inR			: in STD_LOGIC_VECTOR((inWIDTH - 1) downto 0) := (others => '0');
			inG			: in STD_LOGIC_VECTOR((inWIDTH - 1) downto 0) := (others => '0');
			inB			: in STD_LOGIC_VECTOR((inWIDTH - 1) downto 0) := (others => '0');
			
			outR		: out STD_LOGIC_VECTOR((outWIDTH - 1) downto 0) := (others => '0');
			outG		: out STD_LOGIC_VECTOR((outWIDTH - 1) downto 0) := (others => '0');
			outB		: out STD_LOGIC_VECTOR((outWIDTH - 1) downto 0) := (others => '0')
			);
end vram;

architecture Behavioral of vram is

	type vram is array(0 to (v_display - 1), 0 to (h_display - 1)) of std_logic_vector((inWIDTH - 1) downto 0);

	signal vramR : vram;	-- create h_display * v_display * nWIDTH RAM for Red Color
	signal vramG : vram;	-- create h_display * v_display * nWIDTH RAM for Green Color
	signal vramB : vram;	-- create h_display * v_display * nWIDTH RAM for Blue Color
					
begin

-- read process
process(EN, CLK, WE, TEST, posX, posY, inR, inG, inB)
	begin
		if(EN = '0') then
			outR <= (others => '0');
			outG <= (others => '0');
			outB <= (others => '0');
		elsif rising_edge(CLK) then
--			if(TEST = '0') then
--				-- Daten aus VRAM(R/G/B) lesen
--				outR <= vramR(posY, posX)((inWIDTH - 1) to (inWIDTH - outWIDTH - 1));
--				outG <= vramG(posY, posX)((inWIDTH - 1) to (inWIDTH - outWIDTH - 1));
--				outB <= vramB(posY, posX)((inWIDTH - 1) to (inWIDTH - outWIDTH - 1));
--			else
				-- Test Speicherbild erzeugen
				outR <= std_logic_vector(to_unsigned(posX, outWIDTH));
				outG <= std_logic_vector(to_unsigned(posY, outWIDTH));
				outB <= std_logic_vector(to_unsigned(posX*posY, outWIDTH));
--			end if;
		end if;
end process;

-- write process
process(CLK)
	begin
		if(EN = '0' and WE='0') then
			if rising_edge(CLK) then
				for i in 0 to (v_display - 1) loop
					for j in 0 to (h_display - 1) loop
						-- VRAM(R/G/B) initialisieren (0)
						vramR(i, j) <= (others => '0');
						vramG(i, j) <= (others => '0');
						vramB(i, j) <= (others => '0');
					end loop;
				end loop;
			end if;
		elsif falling_edge(CLK) then
			-- Daten in VRAM(R/G/B) schreiben
			vramR(posY, posX) <= inR;
			vramG(posY, posX) <= inG;
			vramB(posY, posX) <= inB;
		end if;
end process;

end Behavioral;
