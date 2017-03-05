--	------------------------------------
--	Diplomarbeit elmProject@HTL-Rankweil
--	GÄCHTER Raffael                     
--	elm-project@sunriax.at              
--	2AAELI | 2016/2017                  
--	------------------------------------
--	File: uart.vhdl                    
--	Version: v1.0                       
--	------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;	--niemals beide NUMERIC_STD und STD_LOGIC_ARITH verwenden!!!
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity uart is
	Generic	(
			TAKT	: integer := 100000000;		-- 100 MHz
			BAUD	: integer := 9600			-- 9600 BITs/s
			);
	Port	(
			CLK		: in STD_LOGIC;
			EN		: in STD_LOGIC;
			-- Empfänger
			RX		: in STD_LOGIC;
			RX_data	: out STD_LOGIC_VECTOR(7 downto 0);
			RX_busy	: out STD_LOGIC;
			-- Sender
			TX 		: out STD_LOGIC;
			TX_data	: in STD_LOGIC_VECTOR(7 downto 0);
			TX_run	: in STD_LOGIC;
			TX_busy	: out STD_LOGIC
			);
end uart;

architecture Behavioral of uart is
	signal txstart	: STD_LOGIC := '0';
	signal txsr		: STD_LOGIC_VECTOR(9 downto 0) := (others => '1');	-- Startbit, 8 Datenbits, Stopbit
	signal txcount	: integer range 0 to 10 := 10;
	signal txscale	: integer range 0 to (TAKT/BAUD) - 1;
	
	signal rxrise	: STD_LOGIC_VECTOR(3 downto 0) := "1111";
	signal rxsr		: STD_LOGIC_VECTOR(7 downto 0) := (others => '0');	-- 8 Datenbits
	signal rxcount	: integer range 0 to 9 :=9;
	signal rxscale	: integer range 0 to (TAKT/BAUD) - 1; 
	signal rxauto	: STD_LOGIC := '0';
begin

	-- Daten senden
	process(EN, CLK) begin
		if (EN='1' and rising_edge(CLK)) then
				txstart <= TX_run;
			if (TX_run='1' and txstart='0') then	-- steigende Flanke, los gehts
				txscale <= 0;							-- Zähler initialisieren
         		txcount <= 0;
				   txsr <= '1' & TX_Data & '0';			-- Stopbit, 8 Datenbits, Startbit, rechts gehts los
			else
				if(txscale < (TAKT/BAUD) - 1) then
					txscale <= txscale + 1;
				else	-- nächstes Bit ausgeben  
					if (txcount < 10) then
						txscale <= 0;
						txcount <= txcount + 1;
						   txsr <= '1' & txsr(txsr'left downto 1);
					end if;
				end if;
			end if;
		end if;
	end process;

		     TX <= txsr(0);  -- LSB first
		TX_busy <= '1' when (TX_run = '1' or txcount < 10) else '0';

	-- Daten empfangen
	process(EN, CLK) begin
		if rising_edge(CLK) then
				rxrise <= rxrise(rxrise'left - 1 downto 0) & RX;
			if (rxcount < 9) then	-- Empfang läuft
				if(rxscale < (TAKT/BAUD) - 1) then 
					rxscale <= rxscale + 1;
				else
					rxscale <= 0; 
					rxcount <= rxcount + 1;
					rxsr    <= rxrise(rxrise'left - 1) & rxsr(rxsr'left downto 1);	-- rechts schieben, weil LSB first
				end if;
			else	-- warten auf Startbit
					if (rxrise(3 downto 2) = "10") then		-- fallende Flanke Startbit
					rxscale <= ((TAKT/BAUD) - 1) / 2;		-- halbe Bitzeit abwarten
					rxcount <= 0;
				end if;
			end if;
		end if;
	end process;

		RX_data <= rxsr;
		RX_busy <= '1' when (rxcount < 9) else '0';

end Behavioral;
