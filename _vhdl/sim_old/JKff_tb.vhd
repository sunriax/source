----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.09.2016 16:56:50
-- Design Name: 
-- Module Name: jkFF_tb - Simulation
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use UNISIM.VComponents.all;

entity jkFF_tb is
--  Port ( );
end jkFF_tb;

architecture Simulation of jkFF_tb is

component jkFF is
  port (  CLK   :   in STD_LOGIC;
          J		:   in STD_LOGIC;
          K     :   in STD_LOGIC;
          Q 	:   out STD_LOGIC;
          nQ 	:   out STD_LOGIC
        );
end component jkFF;

signal simCLK, simJ, simK	: STD_LOGIC;
signal simQ, simnQ			: STD_LOGIC;

constant CLK_period : time := 1 us;    -- 1 MHz
begin
UUT: jkFF port map ( CLK	=> simCLK,
                     J		=> simJ,
                     K		=> simK,
                     Q 		=> simQ,
                     nQ		=> simnQ );

CLK_process: process
  begin
      simCLK <= '0';
      wait for CLK_period/2;
      simCLK <= '1';
      wait for CLK_period/2;
end process;

process
  begin
      wait for 1 us;
      simJ <= '0';	simK <= '0';	wait for 3 us;
      simJ <= '0';	simK <= '1';	wait for 3 us;
      simJ <= '0';	simK <= '0';	wait for 3 us;
      simJ <= '1';	simK <= '0';	wait for 3 us;
      simJ <= '0';	simK <= '0';	wait for 3 us;
      simJ <= '1';	simK <= '1';	wait for 3 us;
      simJ <= '0';	simK <= '0';	wait for 3 us;
      wait;
end process;

end Simulation;
