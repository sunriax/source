--	------------------------------------
--	Diplomarbeit elmProject@HTL-Rankweil
--	GÄCHTER Raffael                     
--	elm-project@sunriax.at              
--	2AAELI | 2016/2017                  
--	------------------------------------
--	File: vga.vhdl                    
--	Version: v1.0                       
--	------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
-- use IEEE.STD_LOGIC_ARITH.ALL; // niemals beide NUMERIC_STD und STD_LOGIC_ARITH verwenden!!!
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity vga is
	Generic	(
			-- Auflösung 1280x1024@60Hz
			nCLK			: INTEGER := 108000000;	--108 MHz
			-- Data Width
			nWIDTH			: INTEGER := 4;
			
			-- Horizontal (Komplette Linie 1584)
			h_porchFRONT	: INTEGER := 48;		-- Pixel 48
			h_porchBACK		: INTEGER := 248;		-- Pixel 248
			h_syncPULSE		: INTEGER := 112;		-- Pixel 112
			h_display		: INTEGER := 1280;		-- Pixel 1280
			--Vertikal (Komplette Zeilen 1056)
			v_porchFRONT	: INTEGER := 1;			-- Pixel
			v_porchBACK		: INTEGER := 38;		-- Pixel
			v_syncPULSE		: INTEGER := 3;			-- Pixel
			v_display		: INTEGER := 1024;		-- Pixel
			-- Logik Type (n=0/p=1)
			h_syncTYPE		: STD_LOGIC := '1';		-- Positive Logik (p)
			v_syncTYPE		: STD_LOGIC := '1'		-- Positive Logik (p)

			);
	Port	(
			EN			: in STD_LOGIC;
			vgaCLK		: in STD_LOGIC;
			vgaTEST		: in STD_LOGIC;
			dataR		: in STD_LOGIC_VECTOR((nWIDTH - 1) downto 0);
			dataG		: in STD_LOGIC_VECTOR((nWIDTH - 1) downto 0);
			dataB		: in STD_LOGIC_VECTOR((nWIDTH - 1) downto 0);
			h_sync		: out STD_LOGIC;
			v_sync		: out STD_LOGIC;
			R			: out STD_LOGIC_VECTOR((nWIDTH - 1) downto 0) := (others => '0');
			G			: out STD_LOGIC_VECTOR((nWIDTH - 1) downto 0) := (others => '0');
			B			: out STD_LOGIC_VECTOR((nWIDTH - 1) downto 0) := (others => '0')
			
			);
end vga;

architecture Behavioral of vga is
	signal h_LINE, v_LINE	: INTEGER := 0;
	signal x, y				: INTEGER := 0;
begin
	process(EN, vgaCLK, vgaTEST, dataR, dataG, dataB, h_LINE, v_LINE, x, y)
		begin
		  if(EN = '0') then
             h_sync <= not(h_syncTYPE);    -- LOW
             v_sync <= not(v_syncTYPE);    -- LOW
             h_LINE <= 0;                -- Horizontalzähler rücksetzen
             v_LINE <= 0;                -- Vertikalzähler rücksetzen

                  x <= 0;                -- Pixelzähler Horizontal rücksetzten
                  y <= 0;                -- Pixelzähler Vertikal rücksetzen
             
             R <= (others =>  '0');
             G <= (others =>  '0');
             B <= (others =>  '0');
		 
		  elsif (rising_edge(vgaCLK)) then
			h_LINE <= h_LINE + 1;

				-- Pixel Zähler Horizontal
					if (h_LINE = h_porchFRONT + h_porchBACK + h_syncPULSE + h_display) then
						h_LINE <= 0;
						v_LINE <= v_LINE + 1;
					end if;

				-- Pixel Zähler Vertikal
					if(v_LINE = v_porchFRONT + v_porchBACK + v_syncPULSE + v_display) then
						v_LINE <= 0;
					end if;

				-- Hsync Signal
					if(h_LINE > (h_display + h_porchFRONT) and h_LINE < (h_display + h_porchFRONT + h_syncPULSE)) then
						h_sync <= not(h_syncTYPE);
					else
						h_sync <= h_syncTYPE;
					end if;

				-- Vsync Signal
					if(v_LINE > (v_display + v_porchFRONT) and v_LINE < (v_display + v_porchFRONT + v_syncPULSE)) then
						v_sync <= not(v_syncTYPE);
					else
						v_sync <= v_syncTYPE;
					end if;

				if((h_LINE < h_display) and (v_LINE < v_display)) then
					if(vgaTEST = '0') Then
						R <= dataR;
						G <= dataG;
						B <= dataB;
					else
					
						-- Hintergrundfarbe Gelb
						R <= (others =>  '1');
						G <= (others =>  '1');
						B <= (others =>  '0');
						
						-- Weißes Fadenkreuz
						if(	(h_LINE >= ((h_display / 2) - 5) and h_LINE <= ((h_display / 2) + 5)) or
							(v_LINE >= ((v_display / 2) - 5) and v_LINE <= ((v_display / 2) + 5))	) then
								R <= (others =>  '1');
								G <= (others =>  '1');
								B <= (others =>  '1');
	
						-- Farbpalette
						elsif(	(h_LINE >= 1  and h_LINE <= ((h_display / 2) - 5)) and
								(v_LINE >= 1  and v_LINE <= ((v_display / 2) - 5))	) then
	
							R <= x"F";
							G <= (others => '0');
							B <= (others => '0');
	
						elsif(	(h_LINE >= ((h_display / 2) + 5) and h_LINE <= h_display) and
								(v_LINE >= 1 and v_LINE <= ((v_display / 2) - 5))	) then
	
							R <= (others => '0');
							G <= x"F";
							B <= (others => '0');
						
						elsif(	(h_LINE >= 0 and h_LINE <= ((h_display / 2) - 5)) and
								(v_LINE >= ((v_display / 2) + 5) and v_LINE <= v_display)	) then
														
							R <= (others => '0');
							G <= (others => '0');
							B <= x"F";
						
						elsif(	(h_LINE >= ((h_display / 2) + 5) and h_LINE <= h_display) and
								(v_LINE >= ((v_display / 2) + 5) and v_LINE <= v_display)	) then
														
							R <= x"A";
							G <= x"A";
							B <= x"A";
						
						end if;
                 end if;
          else
            R <= (others => '0');
            G <= (others => '0');
            B <= (others => '0');
         end if;
        end if;
	end process;
	
end Behavioral;
