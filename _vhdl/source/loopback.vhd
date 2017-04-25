--	-------------------------------------
--	Diplomarbeit elmProject@HTL-Rankweil
--	GÄCHTER Raffael
--	elm-project@hotmail.com
--	2AAELI | 2016/2017
--	-------------------------------------
--	File: loopback.vhd
--	Version: v1.0
--	-------------------------------------
--	Loopback Schnittstelle für Busse und
--	degleichen
--	-------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- niemals beide NUMERIC_STD und STD_LOGIC_ARITH verwenden!!!
use IEEE.NUMERIC_STD.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;

entity loopback is
	Generic	(
			constant SYS_CLK	: integer range 0 to 100000000 := 100000000;	-- 100 MHz Systemtakt
			constant DATASIZE	: integer range 0 to 128		:= 8			-- Datenbit Länge
			);
		Port(
			EN		:	in	STD_LOGIC;
			CLK		:	in	STD_LOGIC;
			WRITE	:	out	STD_LOGIC := '0';												-- Daten auf UART schreiben
			READ	:	out	STD_LOGIC := '0';												-- Daten von UART lesen
			dataWR	:	out	STD_LOGIC_VECTOR(DATASIZE - 1 downto 0):= (others => '0');	-- Daten über UART Senden
			dataRD	:	in	STD_LOGIC_VECTOR(DATASIZE - 1 downto 0);						-- Daten über UART Empfangen
			FREG	:	in	STD_LOGIC_VECTOR (7 downto 0) := (others => '0')				-- Flagregister	
			);
end loopback;

architecture Behavioral of loopback is

	signal txtPROJECT	: STRING(1 to 23)	:= "elmProject 2016/2017" & LF & CR & CR;
--	signal txtTITLE		: STRING(1 to 380)	:=	CR & LF &	
--												"-------------------------------------------------------------" & CR & LF &  
--											  	"This program is free software: you can redistribute it and/or" & CR & LF &
--											   	"modify it under the terms of the GNU General Public License  " & CR & LF & 
--											   	"as published by the Free Software Foundation, either Ver.3 of" & CR & LF &
--											   	"the License, or (at your option) any later version.          " & CR & LF &
--											   	"-------------------------------------------------------------" & CR & LF;

	type txt40CHAR is array(natural range <>) of STRING(1 to 40);
	type txt60CHAR is array(natural range <>) of STRING(1 to 80);
	type txt80CHAR is array(natural range <>) of STRING(1 to 80);

		constant txtVERSION : txt40CHAR:=	(
											"FPGA Version: V1.00 Beta Stable       " & CR & LF,
											" -> UART Version: V1.00 Release Stable" & CR & LF,
											" -> FIFO Version: V1.00 Releas  Stable" & CR & LF,
											" -> xRAM Version: v1.00 Alpha   Stable" & CR & LF,
											"(c) 2016 All rights reserved!        " & LF & CR & CR
											);

	signal txtTITLE : STRING(1 to (txtPROJECT'length + txtVERSION(0)'length + txtVERSION(1)'length + txtVERSION(2)'length + txtVERSION(3)'length) + txtVERSION(4)'length);
	
	signal intREAD		: STD_LOGIC := '0';
	signal intWRITE		: STD_LOGIC := '0';
	signal intdataWR	: STD_LOGIC_VECTOR(7 downto 0) := (others => '0');


--	-- Funktion um einen String in ASCII Code umzuwandeln
--	function string2slv( data : string )
--		return std_logic_vector
--			is
--				variable returnSLV : std_logic_vector(data'length * 8 - 1 downto 0) ;
--			begin
--				for i in 1 to data'high loop
--					returnSLV(i * 8 - 1 downto (i - 1) * 8) := std_logic_vector(to_unsigned(character'pos(data(i)), 8));
--				end loop;
--		return returnSLV;
--	end function;

begin

	-- Loopback initialisierungstext
	txtTITLE <= txtPROJECT & txtVERSION(0) & txtVERSION(1) & txtVERSION(2) & txtVERSION(3) & txtVERSION(4);

			WRITE	<= '0' WHEN EN = '0' ELSE intWRITE;
			READ	<= '0' WHEN EN = '0' ELSE intREAD;
			dataWR	<= (others => '0') WHEN EN = '0' ELSE intdataWR;

	process(CLK, EN, dataRD, FREG)
			variable CYCLE			: boolean := false;
			variable WRITE_CYCLE	: boolean := false;
			variable INIT			: boolean := false;
			variable WRITE_DEC		: boolean := false;
			variable cntINIT		: integer := 1;
		begin
			if(rising_edge(CLK) and EN = '1') Then
				
				if(init = false) Then
				
					if(FREG(4) = '0') Then

							intWRITE <= '1';

							if(cntINIT = (txtTITLE'high + 1)) Then
								init := true;
								intWRITE <= '0';
								intdataWR <= (others => '0');
							else
								intdataWR <= std_logic_vector(to_unsigned(character'pos(txtTITLE(cntINIT)), 8));
							end if;
							
							cntINIT := cntINIT + 1;
							WRITE_DEC := false;
					else
						
						if(WRITE_DEC = false) Then
							cntINIT := cntINIT - 2;
							WRITE_DEC := true;
						end if;
						
						intWRITE <= '0';
				
					end if;
				
				else
				
					intWRITE <= '0';
					intdataWR <= (others => '0');
					
					-- Wenn Empfangsbuffer nicht leer
					if(FREG(1) = '0' or CYCLE = true) Then
						if(CYCLE = false) Then
						
							intREAD <= '1';
							CYCLE := true;
						
						else
							
							intREAD <= '1';
							
							CYCLE := false;
							WRITE_CYCLE := true;
							
						end if;
					end if;
					
					if(WRITE_CYCLE = true) Then
						intdataWR <= dataRD;
						intWRITE <= '1';
						WRITE_CYCLE := false;
					
					else
						intdataWR <= dataRD;
						intWRITE <= '0';
					
					end if;
				end if;
			
			end if;			
	end process;

end Behavioral;
