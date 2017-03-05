--	------------------------------------
--	Diplomarbeit elmProject@HTL-Rankweil
--	GÄCHTER Raffael                     
--	elm-project@sunriax.at              
--	2AAELI | 2016/2017                  
--	------------------------------------
--	File: uart_tb.vhdl                    
--	Version: v1.0                       
--	------------------------------------

library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use UNISIM.VComponents.all;

entity uart_tb is
--  Port ( );
end uart_tb;

architecture Simulation of uart_tb is
	component uart is
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
	end component uart;

signal simCLK, simEN, simRX, simRXbusy, simTX, simTXrun, simTXbusy	: STD_LOGIC;
signal simRXdata, simTXdata											: STD_LOGIC_VECTOR(7 downto 0);

constant CLK_period : time := 10 ns;    -- 100 MHz
begin

UUT: uart port map	(
					CLK		=>	simCLK,
					EN		=>	simEN,
					RX		=>	simRX,
					RX_data	=>	simRXdata,
					RX_busy	=>	simRXbusy,
					TX		=>	simTX,
					TX_data	=>	simTXdata,
					TX_run	=>	simTXrun,
					TX_busy	=>	simTXbusy
					);

CLK_process: process
begin
	simCLK <= '0';	wait for CLK_period/2;
	simCLK <= '1';	wait for CLK_period/2;
end process;

process
begin
	simEN <= '1';	simTXrun <= '1'; simRX <= '0';	simTXdata <= x"0F";		wait for CLK_period * 9600;
	
	simEN <= '1';	simTXrun <= '0'; simRX <= '1';	simTXdata <= x"0F";		wait for CLK_period * 9600;
	simEN <= '1';	simTXrun <= '0'; simRX <= '1';	simTXdata <= x"0F";		wait for CLK_period * 9600;
	simEN <= '1';	simTXrun <= '0'; simRX <= '0';	simTXdata <= x"0F";		wait for CLK_period * 9600;
	simEN <= '1';	simTXrun <= '0'; simRX <= '0';	simTXdata <= x"0F";		wait for CLK_period * 9600;
	simEN <= '1';	simTXrun <= '0'; simRX <= '0';	simTXdata <= x"0F";		wait for CLK_period * 9600;
	simEN <= '1';	simTXrun <= '0'; simRX <= '0';	simTXdata <= x"0F";		wait for CLK_period * 9600;
	simEN <= '1';	simTXrun <= '0'; simRX <= '0';	simTXdata <= x"0F";		wait for CLK_period * 9600;
	simEN <= '1';	simTXrun <= '0'; simRX <= '1';	simTXdata <= x"0F";		wait for CLK_period * 9600;
	--simEN <= '1';	simTXrun <= '0'; simRX <= '1';	simTXdata <= x"0F";		wait for CLK_period * 9600;
	
	simEN <= '1';	simTXrun <= '1'; simRX <= '0';	simTXdata <= x"F0";		wait;
end process;
end Simulation;
