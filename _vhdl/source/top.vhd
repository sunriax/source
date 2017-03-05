--	------------------------------------
--	Diplomarbeit elmProject@HTL-Rankweil
--	GÄCHTER Raffael
--	elm-project@sunriax.at
--	2AAELI | 2016/2017
--	------------------------------------
--	File: top.vhdl
--	Version: v1.0
--	------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity top is
	Generic (
			divide		: integer range 0 to 1000000000 := 1000000;
			-- VGA Einstellungen
			h_display	: integer := 1280;
			v_display	: integer := 1024;
			rgbWIDTH	: integer := 4;
			vramWIDTH	: integer := 8
			);
	Port	(
			CLK		: in STD_LOGIC;
			EN		: in STD_LOGIC;
			ZERO	: in STD_LOGIC;
			TEST	: in STD_LOGIC;
			
			RX     : in STD_LOGIC;
			RX_data : out STD_LOGIC_VECTOR(7 downto 0);
			RX_busy : out STD_LOGIC;
			TX     : out STD_LOGIC;
			TX_run  : in STD_LOGIC;
			TX_data : in STD_LOGIC_VECTOR(7 downto 0);
			TX_busy : out STD_LOGIC;
			
			LED     : out STD_LOGIC_VECTOR(7 downto 0);
			
			SEGMENT	: out STD_LOGIC_VECTOR(7 downto 0);
			DIGIT	: out STD_LOGIC_VECTOR(3 downto 0);
			
			R		: out STD_LOGIC_VECTOR((rgbWIDTH - 1) downto 0);
			G		: out STD_LOGIC_VECTOR((rgbWIDTH - 1) downto 0);
			B		: out STD_LOGIC_VECTOR((rgbWIDTH - 1) downto 0);
			h_sync	: out STD_LOGIC;
			v_sync	: out STD_LOGIC
			);
end top;

architecture Structure of top is
	signal stcEN	: STD_LOGIC := '0';
	signal stcWE	: STD_LOGIC := '0';
	signal stcCOUNT	: STD_LOGIC;
	signal stcDATA	: STD_LOGIC_VECTOR(3 downto 0);
	signal stcBCD	: STD_LOGIC_VECTOR(4 downto 0);
	signal stcPOS	: STD_LOGIC_VECTOR(3 downto 0);
	signal vgaR, vgaG, vgaB : STD_LOGIC_VECTOR(3 downto 0);
	signal vgaPOSX, vgaPOSY	: INTEGER := 0;
	signal vramR, vramG, vramB	: STD_LOGIC_VECTOR(7 downto 0) := (others => '0');

	component divider
		Port	(
				EN : in STD_LOGIC;
				CLK : in STD_LOGIC;
				scale : in INTEGER range 0 to 1000000000;
				CLK_scale : out STD_LOGIC
				);
	end component;

	component control
		Port	(
				EN, CLK, COUNT,	ZERO	: in STD_LOGIC;
				DATA, DIGIT				: out STD_LOGIC_VECTOR(3 downto 0)
				);
	end component;

	component bcd7seg
		Port	(
				EN, CLK	: in STD_LOGIC;
				BCD		: in STD_LOGIC_VECTOR (4 downto 0);
				POS		: in STD_LOGIC_VECTOR (3 downto 0);
				DIGIT	: out STD_LOGIC_VECTOR (3 downto 0);
				SEGMENT	: out STD_LOGIC_VECTOR (7 downto 0)
				);
	end component;

    component uart
    	Port	(
            CLK        : in STD_LOGIC;
            EN         : in STD_LOGIC;
            -- Empfänger
            RX          : in STD_LOGIC;
            RX_data     : out STD_LOGIC_VECTOR(7 downto 0);
            RX_busy     : out STD_LOGIC;
            -- Sender
            TX          : out STD_LOGIC;
            TX_data     : in STD_LOGIC_VECTOR(7 downto 0);
            TX_run      : in STD_LOGIC;
            TX_busy     : out STD_LOGIC
            );
    end component;

--	component vram
--		Port	(
--				EN			: in STD_LOGIC;
--				WE			: in STD_LOGIC;
--				CLK			: in STD_LOGIC;
--				TEST		: in STD_LOGIC;
				
--				posX		: in INTEGER range 0 to (h_display - 1) := 0;
--    			posY		: in INTEGER range 0 to (v_display - 1) := 0;
				
--				inR			: in STD_LOGIC_VECTOR((vramWIDTH - 1) downto 0) := (others => '0');
--				inG			: in STD_LOGIC_VECTOR((vramWIDTH - 1) downto 0) := (others => '0');
--				inB			: in STD_LOGIC_VECTOR((vramWIDTH - 1) downto 0) := (others => '0');
				
--				outR		: out STD_LOGIC_VECTOR((rgbWIDTH - 1) downto 0) := (others => '0');
--				outG		: out STD_LOGIC_VECTOR((rgbWIDTH - 1) downto 0) := (others => '0');
--				outB		: out STD_LOGIC_VECTOR((rgbWIDTH - 1) downto 0) := (others => '0')
--				);
--	end component;

	component vga
		Port	(
				EN			: in STD_LOGIC;
				vgaCLK		: in STD_LOGIC;
				vgaTEST		: in STD_LOGIC;
				dataR		: in STD_LOGIC_VECTOR(3 downto 0);
				dataG		: in STD_LOGIC_VECTOR(3 downto 0);
				dataB		: in STD_LOGIC_VECTOR(3 downto 0);
				h_sync		: out STD_LOGIC;
				v_sync		: out STD_LOGIC;
				R			: out STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
				G			: out STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
				B			: out STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
				x_pixel		: out INTEGER range 0 to (h_display - 1) := 0;
				y_pixel		: out INTEGER range 0 to (v_display - 1) := 0
				);
	end component;

	component startup
		Port	(
				sysCLK		: in STD_LOGIC;
				ENable		: out STD_LOGIC
				);
	end component;

	component clock
		Port	(
				CLK		: in STD_LOGIC;
				CLK108	: out STD_LOGIC
				);
	end component;

    signal CLK108 : STD_LOGIC := '0';

begin
	stcBCD <= stcDATA & '0';
	
	Display	:	bcd7seg
		PORT MAP	(
					EN => EN,
					CLK => CLK,
					BCD => stcBCD,
					POS => stcPOS,
					DIGIT => DIGIT,
					SEGMENT => SEGMENT
					);

	Count	:	control
		PORT MAP	(
					EN => EN,
					CLK => CLK,
					COUNT => stcCOUNT,
					ZERO => ZERO,
					DATA => stcDATA,
					DIGIT => stcPOS
					);
	
	Frequency	:	divider
		PORT MAP	(
					EN			=> stcEN,
					CLK			=> CLK,
					scale		=> divide,
					CLK_scale	=> stcCOUNT
					);

	Run	:	startup
		PORT MAP	(
					sysCLK	=> CLK,
					ENable	=> stcEN
					);

    omnibus :   uart
        PORT MAP	(
                    CLK => CLK,
                    EN => stcEN,
                    RX => RX,
                    RX_data => LED,
                    RX_busy => RX_busy,
                    TX => TX,
                    TX_data => TX_data,
                    TX_run => TX_run,
                    TX_busy => TX_busy 
                    );

    VGAclock	:	clock
		PORT MAP	(
					CLK	=> CLK,
					CLK108	=> CLK108
					);

	VGAdisplay	:	vga
		PORT MAP	(
					EN => stcEN,
					vgaCLK => CLK108,
					vgaTEST => TEST,
					dataR => vgaR,
					dataG => vgaG,
					dataB => vgaB,
					h_sync => h_sync,
					v_sync => v_sync,
					R => R,
					G => G,
					B => B,
					x_pixel => vgaPOSX,
					y_pixel => vgaPOSY
					);

--	VGAvram		:	vram
--		PORT MAP	(
--					EN => stcEN,
--					WE => stcWE,
--					CLK => CLK108,
--	       			TEST => TEST,
--					posX => vgaPOSX,
--					posY => vgaPOSY,
--					inR => vramR,
--					inG => vramG,
--					inB => vramB,
--					outR => vgaR,
--					outG => vgaG,
--					outB => vgaB
--					);

end Structure;
