--	------------------------------------
--	Diplomarbeit elmProject@HTL-Rankweil
--	GÄCHTER Raffael                     
--	elm-project@sunriax.at              
--	2AAELI | 2016/2017                  
--	------------------------------------
--	File: rom.vhdl                    
--	Version: v1.0                       
--	------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL; -- niemals beide NUMERIC_STD und STD_LOGIC_ARITH verwenden!!!
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity rom is
	Generic	(
			nASCII_WIDTH	:	INTEGER := 8;		-- Wortbreite
			nCMD_WIDTH		:	INTEGER := 8;		-- Befehlsbreite (8 = 255 Befehle);
			tDELAY			:	time := 4 ns
			);
	Port	(
			EN		: in  STD_LOGIC;
			CLK		: in  STD_LOGIC;
			CALL	: in  STD_LOGIC;
			DONE	: out STD_LOGIC;
			callSTR	: in  STD_LOGIC_VECTOR(nCMD_WIDTH - 1 downto 0);
			dataSTR	: out STD_LOGIC_VECTOR(nASCII_WIDTH - 1 downto 0);
			FAULT	: out STD_LOGIC
			);
end rom;

architecture Behavioral of rom is
	type asciiDATA is array (integer range<>) of std_logic_vector(nASCII_WIDTH - 1 downto 0);
	constant asciiROM : asciiDATA := (	--	(0)NUL	(1)SOH	(2)STX	(3)ETX	(4)EOT	(5)ENQ	(6)ACK	(7)BEL	(8)BS	(9)TAB	(10)LF	(11)VT	(12)FF	(13)CR	(14)SO	(15)SI
											x"00",	x"01",	x"02",	x"03",	x"04",	x"05",	x"06",	x"07",	x"08",	x"09",	x"0A",	x"0B",	x"0C",	x"0D",	x"0E",	x"0F",
										--	(16)DLE	(17)DC1	(18)DC2	(19)DC3	(20)DC4	(21)NAK	(22)SYN	(23)ETB	(24)CAN	(25)EM	(26)SUB	(27)ESC	(28)FS	(29)GS	(30)RS	(31)US
											x"10",	x"11",	x"12",	x"13",	x"14",	x"15",	x"16",	x"17",	x"18",	x"19",	x"1A",	x"1B",	x"1C",	x"1D",	x"1E",	x"1F",
										--	(32)[_]	(33)!	(34)"	(35)#	(36)$	(37)%	(38)&	(39)'	(40)(	(41))	(42)*	(43)+	(44),	(45)-	(46).	(47)/
											x"20",	x"21",	x"22",	x"23",	x"24",	x"25",	x"26",	x"27",	x"28",	x"29",	x"2A",	x"2B",	x"2C",	x"2D",	x"2E",	x"2F",
										--	(48)0	(49)1	(50)2	(51)3	(52)4	(53)5	(54)6	(55)7	(56)8	(57)9	(58):	(59);	(60)<	(61)=	(62)>	(63)?
											x"30",	x"31",	x"32",	x"33",	x"34",	x"35",	x"36",	x"37",	x"38",	x"39",	x"3A",	x"3B",	x"3C",	x"3D",	x"3E",	x"3F",
										--	(64)@	(65)A	(66)B	(67)C	(68)D	(69)E	(70)F	(71)G	(72)H	(73)I	(74)J	(75)K	(76)L	(77)M	(78)N	(79)O
											x"40",	x"41",	x"42",	x"43",	x"44",	x"45",	x"46",	x"47",	x"48",	x"49",	x"4A",	x"4B",	x"4C",	x"4D",	x"4E",	x"4F",
										--	(80)P	(81)Q	(82)R	(83)S	(84)T	(85)U	(86)V	(87)W	(88)X	(89)Y	(90)Z	(91)[	(92)\	(93)]	(94)^	(95)_
											x"50",	x"51",	x"52",	x"53",	x"54",	x"55",	x"56",	x"57",	x"58",	x"59",	x"5A",	x"5B",	x"5C",	x"5D",	x"5E",	x"5F",
										--	(96)`	(97)a	(98)b	(99)c	(100)d	(101)e	(12)f	(103)g	(104)h	(105)i	(106)j	(107)k	(108)l	(109)m	(110)n	(111)o	
											x"60",	x"61",	x"62",	x"63",	x"64",	x"65",	x"66",	x"67",	x"68",	x"69",	x"6A",	x"6B",	x"6C",	x"6D",	x"6E",	x"6F",
										--	(112)p	(113)q	(114)r	(115)s	(116)t	(117)u	(118)v	(119)w	(120)x	(121)y	(122)z	(123){	(124)|	(125)}	(126)~	(127)DEL
											x"70",	x"71",	x"72",	x"73",	x"74",	x"75",	x"76",	x"77",	x"78",	x"79",	x"7A",	x"7B",	x"7C",	x"7D",	x"7E",	x"7F"	);

	constant HEADER : asciiDATA := (	asciiROM(13), 	--\r 
										asciiROM(101),  --e
										asciiROM(108), 	--l
										asciiROM(109), 	--m
										asciiROM(80), 	--P
										asciiROM(114), 	--r
										asciiROM(111), 	--o
										asciiROM(106), 	--j
										asciiROM(101), 	--e
										asciiROM(107), 	--k
										asciiROM(116), 	--t
										asciiROM(10), 	--\n
										asciiROM(13), 	--\r
										asciiROM(86), 	--V
										asciiROM(101), 	--e
										asciiROM(114), 	--r
										asciiROM(115), 	--s
										asciiROM(105), 	--i
										asciiROM(111), 	--o
										asciiROM(110), 	--n
										asciiROM(58), 	--:
										asciiROM(32), 	--SPACE
										asciiROM(49), 	--1
										asciiROM(46), 	--.
										asciiROM(48), 	--0
										asciiROM(64), 	--@
										asciiROM(70), 	--F
										asciiROM(121), 	--y
										asciiROM(110), 	--n
										asciiROM(110), 	--n
										asciiROM(13)); 	--\r

	constant COMMAND : asciiDATA := (	asciiROM(110), 	--n
										asciiROM(13), 	--\r 
										asciiROM(101),  --e
										asciiROM(108), 	--l
										asciiROM(109), 	--m
										asciiROM(80), 	--P
										asciiROM(114), 	--r
										asciiROM(111), 	--o
										asciiROM(106), 	--j
										asciiROM(101), 	--e
										asciiROM(107), 	--k
										asciiROM(116), 	--t
										asciiROM(64), 	--@
										asciiROM(70), 	--F
										asciiROM(80), 	--P
										asciiROM(71), 	--G
										asciiROM(65), 	--A
										asciiROM(58), 	--:
										asciiROM(32)); 	--SPACE

	

	signal stringPOS			: integer := 0;	-- Zeichenposition
	signal nextCHAR, endCHAR	: STD_LOGIC := '1';

begin

process(EN, CLK)
	begin
		if(EN = '0') then
			stringPOS <= 0;
		elsif(rising_edge(CLK)) then
			-- stringPOS bei Array ende rücksetzten
			if(endCHAR = '1') then
				stringPOS <= 0;
			end if;
		
			-- Wenn CALL = 1 stringPOS erhöhen
			if(nextCHAR = '1') then
				stringPOS <= stringPOS + 1;
			end if;

		end if;
end process;


process(EN, CLK)
	begin
		if(EN = '0') then
			DONE <= '0';
			FAULT <= '0';
			dataSTR <= (others => '0');
		elsif(rising_edge(CLK)) then
			case (callSTR) is
				-- COMMAND 0b00000000 noOperation
				when x"00"	=>	dataSTR <= (others => '0');

				-- COMMAND 0b00000001 call Kopfzeile
				when x"01"	=>	if(HEADER'LEFT < stringPOS) then
									endCHAR <= '1';
									dataSTR <= (others => '0');
								else
									dataSTR <= COMMAND(stringPOS);
								end if;

				-- COMMAND 0b00000001 call Kommandozeile
				when x"01"	=>	if(HEADER'LEFT < stringPOS) then
									endCHAR <= '1';
									dataSTR <= (others => '0');
								else
									dataSTR <= HEADER(stringPOS);
								end if;

				-- COMMAND 0b00000001 call HEADER
				when x"02"	=>	if(HEADER'LEFT < stringPOS) then
					endCHAR <= '1';
					dataSTR <= (others => '0');
				else
					dataSTR <= HEADER(stringPOS);
				end if;
				
				when others =>	dataSTR <= (others => '1');
			end case;
		end if;
end process;
end Behavioral;
