
library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use UNISIM.VComponents.all;

entity alu_tb is
--  Port ( );
end alu_tb;

architecture Simulation of alu_tb is
component alu is
Port (	EN			: in  STD_LOGIC;
		CLK			: in  STD_LOGIC;
		opA			: in  STD_LOGIC_VECTOR(7 downto 0);
		opB			: in  STD_LOGIC_VECTOR(7 downto 0);
		carryIN		: in  STD_LOGIC;
		MODE		: in  STD_LOGIC;
		CMD			: in  STD_LOGIC_VECTOR(3 downto 0);
		carryOUT	: out STD_LOGIC;
		zeroFLAG	: out STD_LOGIC;
		overFLOW	: out STD_LOGIC;
		DATA		: out STD_LOGIC_VECTOR(7 downto 0));
end component alu;

signal simEN, simCLK							: STD_LOGIC;
signal simopA, simopB, simDATA					: STD_LOGIC_VECTOR(7 downto 0);
signal simCMD									: STD_LOGIC_VECTOR(3 downto 0);
signal simcI, simCo, simZERO, simoV, simMODE	: STD_LOGIC;

constant CLK_period : time := 1 us;    -- 1 MHz
constant WIDTH : INTEGER := 8;

begin
UUT: alu port map (	EN			=> simEN,
					CLK			=> simCLK,
					opA			=> simopA,
					opB			=> simopB, 
					carryIN		=> simcI,
					MODE		=> simMODE,
					CMD			=> simCMD,
					carryOUT	=> simCo,
					zeroFLAG	=> simZERO,
					overFLOW	=> simoV,
					DATA		=> simDATA	);

CLK_process: process
  begin
      simCLK <= '0';
      wait for CLK_period/2;
      simCLK <= '1';
      wait for CLK_period/2;
end process;

process
	begin
		simEN <= '0';	simMODE <= '0';	simCMD <= "0000";	simopA <= "00000000";	simcI <= '0';
															simopB <= "00000000";					wait for CLK_period*4;
		
		simEN <= '1';	simMODE <= '0';	simCMD <= "0000";	simopA <= "00001111";	simcI <= '1';
															simopB <= "00001011";					wait for CLK_period*2;

		simEN <= '1';	simMODE <= '0';	simCMD <= "0000";	simopA <= "00001101";	simcI <= '0';
															simopB <= "10101001";					wait for CLK_period*2;

		simEN <= '1';	simMODE <= '1';	simCMD <= "0000";	simopA <= "11000101";	simcI <= '0';
															simopB <= "10001010";					wait for CLK_period*2;



		simEN <= '1';	simMODE <= '0';	simCMD <= "0001";	simopA <= "00001111";	simcI <= '1';
															simopB <= "00001011";					wait for CLK_period*2;

		simEN <= '1';	simMODE <= '0';	simCMD <= "0001";	simopA <= "00001101";	simcI <= '0';
															simopB <= "10101001";					wait for CLK_period*2;

		simEN <= '1';	simMODE <= '1';	simCMD <= "0001";	simopA <= "11000101";	simcI <= '0';
															simopB <= "10001010";					wait for CLK_period*2;



		simEN <= '1';	simMODE <= '0';	simCMD <= "0010";	simopA <= "00001111";	simcI <= '1';
															simopB <= "00001011";					wait for CLK_period*2;

		simEN <= '1';	simMODE <= '0';	simCMD <= "0010";	simopA <= "00001101";	simcI <= '0';
															simopB <= "10101001";					wait for CLK_period*2;

		simEN <= '1';	simMODE <= '1';	simCMD <= "0010";	simopA <= "11000101";	simcI <= '0';
															simopB <= "10001010";					wait for CLK_period*2;



		simEN <= '1';	simMODE <= '0';	simCMD <= "0011";	simopA <= "00001111";	simcI <= '1';
															simopB <= "00001011";					wait for CLK_period*2;

		simEN <= '1';	simMODE <= '0';	simCMD <= "0011";	simopA <= "00001101";	simcI <= '0';
															simopB <= "10101001";					wait for CLK_period*2;

		simEN <= '1';	simMODE <= '1';	simCMD <= "0011";	simopA <= "11000101";	simcI <= '0';
															simopB <= "10001010";					wait for CLK_period*2;

		wait;
end process;


end Simulation;
