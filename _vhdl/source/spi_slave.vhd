--	-------------------------------------
--	Diplomarbeit elmProject@HTL-Rankweil
--	G.Raf@elmProjekt
--	elm-project@hotmail.com
--	2AAELI | 2016/2017
--	-------------------------------------
--	File: spi_slave.vhd
--	Version: v1.0
--	-------------------------------------
--	SPI Slave Modul zum empfangen von
--	Daten über die Megacard
--	-------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity spi_slave is
	Generic	(
			constant SPI_MODE	:  STD_LOGIC := '0'
			);
		Port(
			EN		:  in STD_LOGIC;
			SCK		:  in STD_LOGIC;
			SS		:  in STD_LOGIC;
			MOSI	:  in STD_LOGIC;
			MISO	: out STD_LOGIC := '0';
			DATA	: out STD_LOGIC_VECTOR(7 downto 0) := (others => '0')
			);
end spi_slave;

architecture Behavioral of spi_slave is
	signal LATCH	: STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
begin

MISO <= '0';

FF:	process(SCK, EN)
		begin
			-- Asynchrones rücksetzten
			if(EN = '0') Then
			
				LATCH <= (others => '0');
			
					-- Wenn steigende Taktflanke
			elsif(rising_edge(SCK)) Then
						
						-- Schiebeoperation
						LATCH <= LATCH(6 downto 0) & MOSI;

			end if;
	end process FF;

CS:	process(SS, EN)
		begin
			-- Asynchrones rücksetzten
			if(EN = '0') Then
		
				DATA <= (others => '0');
				
			-- Wenn steigende Taktflanke
			elsif(rising_edge(SS)) Then
			
				-- Schiebeoperation
				DATA <= LATCH;
			
			end if;	
	end process CS;

end Behavioral;

