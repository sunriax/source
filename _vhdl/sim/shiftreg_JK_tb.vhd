
library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use UNISIM.VComponents.all;

entity shiftreg_tb is
--  Port ( );
end shiftreg_tb;

architecture Simulation of shiftreg_tb is

component shiftreg is
  port (  CLK   :   in STD_LOGIC;
          EN    :   in STD_LOGIC;
          D     :   in STD_LOGIC;
          DATA  :   out STD_LOGIC_VECTOR(3 downto 0)
        );
end component shiftreg;

signal simCLK, simEN, simD	: STD_LOGIC;
signal simQ					: STD_LOGIC_VECTOR(3 downto 0);

constant CLK_period : time := 1 us;    -- 1 MHz
begin
UUT: shiftreg port map ( CLK	=> simCLK,
                         EN		=> simEN,
                         D		=> simD,
                         DATA	=> simQ );

CLK_process: process
  begin
      simCLK <= '0';
      wait for CLK_period/2;
      simCLK <= '1';
      wait for CLK_period/2;
end process;

process
  begin
      --simEN <= '0';	simD  <= '1'; wait for CLK_period/2;
      --simEN <= '1';	simD  <= '1'; wait for CLK_period/2;
      --simEN <= '1';	simD  <= '1'; wait for CLK_period;
      --simEN <= '1';	simD  <= '0'; wait for CLK_period;
      --simEN <= '1';	simD  <= '0'; wait for CLK_period;
      --simEN <= '1';	simD  <= '1'; wait for CLK_period;
      --simEN <= '1';	simD  <= '1'; wait for CLK_period;
      --simEN <= '1';	simD  <= '1'; wait for CLK_period;
      --simEN <= '1';	simD  <= '0'; wait;
      
      simEN <= '0';	simD  <= '1'; wait for CLK_period/2;
      simEN <= '1';	simD  <= '1'; wait for 20 us;
      
      wait;
      
end process;

end Simulation;
