--	------------------------------------
--	Diplomarbeit elmProject@HTL-Rankweil
--	GÄCHTER Raffael
--	elm-project@sunriax.at
--	2AAELI | 2016/2017
--	------------------------------------
--	File: control.vhdl
--	Version: v1.0
--	------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
-- use IEEE.STD_LOGIC_ARITH.ALL; // niemals beide NUMERIC_STD und STD_LOGIC_ARITH verwenden!!!
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity control is
	Port	(
			EN, CLK, COUNT,	ZERO	: in STD_LOGIC;
			DATA, DIGIT				: out STD_LOGIC_VECTOR(3 downto 0)
			);
end control;

architecture Behavioral of control is
	signal E,Z,H,T	: STD_LOGIC_VECTOR(3 downto 0);
begin

process(EN, CLK, COUNT,	ZERO, E, Z, H, T)
		variable SLEW	:	integer range 0 to 100000000 := 0;
	begin
	
		if rising_edge(CLK) then
			if(SLEW <= 10000) then
				DATA <= E;	DIGIT <= "0001";
				SLEW := SLEW + 1;
			elsif(SLEW > 10000 and SLEW <= 20000) then
				DATA <= Z;	DIGIT <= "0010";
				SLEW := SLEW + 1;
			elsif(SLEW > 20000 and SLEW <= 30000) then
				DATA <= H;	DIGIT <= "0100";
				SLEW := SLEW + 1;
			elsif(SLEW > 30000 and SLEW <= 40000) then
				DATA <= T;	DIGIT <= "1000";
				SLEW := SLEW + 1;
			else
				SLEW := 0;
			end if;
		end if;
end process;

process(EN, CLK, COUNT, ZERO, E, Z, H, T)
	begin
		if ZERO = '0' then
			E <= (others => '0');
			Z <= (others => '0');
			H <= (others => '0');
			T <= (others => '0');
		elsif rising_edge(COUNT) then
			if(E = "1111") then
				Z <= (Z + 1);
				E <= (others => '0');
			else
				E <= (E + 1);
			end if;
			
			if(Z = "1111") then
				H <= (H + 1);
				Z <= (others => '0');
			end if;
			
			if(H = "1111") then
				T <= (T + 1);
				H <= (others => '0');
			end if;
			
			if(T = '1' & "0000") then
				E <= (others => '0');
				Z <= (others => '0');
				H <= (others => '0');
				T <= (others => '0');
			end if;
		end if;
end process;

end Behavioral;
