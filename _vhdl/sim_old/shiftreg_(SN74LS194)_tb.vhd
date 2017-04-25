
library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use UNISIM.VComponents.all;

entity SN74LS194_tb is
--  Port ( );
end SN74LS194_tb;

architecture Simulation of SN74LS194_tb is

component SN74LS194 is
 Port ( CLK		: in STD_LOGIC;
        RESET	: in STD_LOGIC;
        DSR		: in STD_LOGIC;
        DSL		: in STD_LOGIC;
        S		: in STD_LOGIC_VECTOR (1 downto 0);
        P		: in STD_LOGIC_VECTOR (3 downto 0);
        Q		: out STD_LOGIC_VECTOR (3 downto 0));
end component SN74LS194;

signal simCLK, simRESET, simDSR, simDSL	: STD_LOGIC;
signal simS								: STD_LOGIC_VECTOR(1 DOWNTO 0);
signal simP								: STD_LOGIC_VECTOR(3 downto 0);
signal simQ								: STD_LOGIC_VECTOR(3 downto 0);

constant CLK_period : time := 1 us;    -- 1 MHz
begin

UUT: SN74LS194 port map (	CLK		=> simCLK,
                     		RESET	=> simRESET,
                    		S		=> simS,
                     		P 		=> simP,
                     		DSR		=> simDSR,
                     		DSL		=> simDSL,
                     		Q		=> simQ );

CLK_process: process
  begin
      simCLK <= '0';
      wait for CLK_period/2;
      simCLK <= '1';
      wait for CLK_period/2;
end process;

process
  begin
	simRESET <= '0';	simS <= "00";	simP <= "0000";		simDSL <= '0';		simDSR <= '0';		wait for CLK_period;
	simRESET <= '1';	simS <= "11";	simP <= "0101";												wait for CLK_period;
	simRESET <= '1';	simS <= "01";	simP <= "0000";		simDSR <= '0';							wait for CLK_period;
	simRESET <= '1';	simS <= "01";						simDSR <= '0';							wait for CLK_period;
  	simRESET <= '1';	simS <= "01";						simDSR <= '1';							wait for CLK_period;
	simRESET <= '1';	simS <= "01";						simDSR <= '1';							wait for CLK_period;
	simRESET <= '0';	simS <= "00";						simDSR <= '0';		
  
      --wait for 2 us;
      --simRESET <= '0';										wait for 4 us;
      --simRESET <= '1';	simS <= "00";						wait for 2 us;
      --simRESET <= '1';	simS <= "10";	simDSL <= '0';		wait for 2 us;
      --simRESET <= '1';	simS <= "10";	simDSL <= '1';		wait for 2 us;
      --simRESET <= '1';	simS <= "10";	simDSL <= '0';		wait for 2 us;
      --simRESET <= '1';	simS <= "10";	simDSL <= '0';		wait for 2 us;
      --simRESET <= '1';	simS <= "10";	simDSL <= '0';		wait for 2 us;
      
      --simRESET <= '0';										wait for 4 us;
      --simRESET <= '1';	simS <= "00";						wait for 2 us;
      --simRESET <= '1';	simS <= "01";	simDSR <= '0';		wait for 2 us;
      --simRESET <= '1';	simS <= "01";	simDSR <= '1';		wait for 2 us;
      --simRESET <= '1';	simS <= "01";	simDSR <= '0';		wait for 2 us;
      --simRESET <= '1';	simS <= "01";	simDSR <= '0';		wait for 2 us;
      --simRESET <= '1';	simS <= "01";	simDSR <= '0';		wait for 2 us;
      
      --simRESET <= '0';										wait for 4 us;
      --simRESET <= '1';	simS <= "11";	simP <= "0000";		wait for 2 us;
      --simRESET <= '1';	simS <= "11";	simP <= "0001";		wait for 2 us;
      --simRESET <= '1';	simS <= "11";	simP <= "0010";		wait for 2 us;
      --simRESET <= '1';	simS <= "11";	simP <= "0011";		wait for 2 us;
      --simRESET <= '1';	simS <= "11";	simP <= "0100";		wait for 2 us;
      --simRESET <= '1';	simS <= "11";	simP <= "1000";		wait for 2 us;
      --simRESET <= '1';	simS <= "11";	simP <= "1100";		wait for 2 us;
      --simRESET <= '1';	simS <= "11";	simP <= "1111";		wait for 2 us;
      
      
      --simRESET <= '0';	simS <= "00";	simP <= "0000";		wait for 2 us;
      wait;
end process;

end Simulation;
