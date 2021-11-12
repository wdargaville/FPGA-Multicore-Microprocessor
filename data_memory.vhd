---------------------------------------------------------------------------
-- data_memory.vhd - Implementation of A Single-Port, 16 x 16-bit Data
--                   Memory.
-- 
--
-- Copyright (C) 2006 by Lih Wen Koh (lwkoh@cse.unsw.edu.au)
-- All Rights Reserved. 
--
-- The single-cycle processor core is provided AS IS, with no warranty of 
-- any kind, express or implied. The user of the program accepts full 
-- responsibility for the application of the program and the use of any 
-- results. This work may be downloaded, compiled, executed, copied, and 
-- modified solely for nonprofit, educational, noncommercial research, and 
-- noncommercial scholarship purposes provided that this notice in its 
-- entirety accompanies all copies. Copies of the modified software can be 
-- delivered to persons who use it solely for nonprofit, educational, 
-- noncommercial research, and noncommercial scholarship purposes provided 
-- that this notice in its entirety accompanies all copies.
--
---------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity data_memory is
    port ( reset        : in  std_logic;
           clk          : in  std_logic;
           write_enable : in  std_logic;
           write_data   : in  std_logic_vector(7 downto 0);
           addr_in      : in  std_logic_vector(7 downto 0);
           data_out     : out std_logic_vector(7 downto 0) );
end data_memory;

architecture behavioral of data_memory is

type mem_array is array(0 to 255) of std_logic_vector(7 downto 0);
signal sig_data_mem : mem_array;

begin
    mem_process: process ( clk,
                           write_enable,
                           write_data,
                           addr_in ) is
  
    variable var_data_mem : mem_array;
    variable var_addr     : integer;
  
    begin
        var_addr := conv_integer(addr_in);
        
        if (reset = '1') then
            -- initial values of the data memory : reset to zero 
        var_data_mem(0) := X"61";
        var_data_mem(1) := X"62";
        var_data_mem(2) := X"63";
        var_data_mem(3) := X"64";
        var_data_mem(4) := X"31";
        var_data_mem(5) := X"32";
        var_data_mem(6) := X"33";
        var_data_mem(7) := X"34";
        var_data_mem(64) := X"21";
        var_data_mem(65) := X"22";
        var_data_mem(66) := X"23";
        var_data_mem(67) := X"24";
        var_data_mem(68) := X"25";
        var_data_mem(69) := X"26";
        var_data_mem(70) := X"27";
        var_data_mem(71) := X"28";
        var_data_mem(72) := X"29";
        var_data_mem(73) := X"2A";
        var_data_mem(74) := X"2B";
        var_data_mem(75) := X"2C";
        var_data_mem(76) := X"2D";
        var_data_mem(77) := X"2E";
        var_data_mem(78) := X"2F";
        var_data_mem(79) := X"30";
        var_data_mem(80) := X"31";
        var_data_mem(81) := X"32";
        var_data_mem(82) := X"33";
        var_data_mem(83) := X"34";
        var_data_mem(84) := X"35";
        var_data_mem(85) := X"36";
        var_data_mem(86) := X"37";
        var_data_mem(87) := X"38";
        var_data_mem(88) := X"39";
        var_data_mem(89) := X"3A";
        var_data_mem(90) := X"3B";
        var_data_mem(91) := X"3C";
        var_data_mem(92) := X"3D";
        var_data_mem(93) := X"3E";
        var_data_mem(94) := X"3F";
        var_data_mem(95) := X"40";
        var_data_mem(96) := X"41";
        var_data_mem(97) := X"42";
        var_data_mem(98) := X"43";
        var_data_mem(99) := X"44";
        var_data_mem(100) := X"45";
        var_data_mem(101) := X"46";
        var_data_mem(102) := X"47";
        var_data_mem(103) := X"48";
        var_data_mem(104) := X"49";
        var_data_mem(105) := X"4A";
        var_data_mem(106) := X"4B";
        var_data_mem(107) := X"4C";
        var_data_mem(108) := X"4D";
        var_data_mem(109) := X"4E";
        var_data_mem(110) := X"4F";
        var_data_mem(111) := X"50";
        var_data_mem(112) := X"51";
        var_data_mem(113) := X"52";
        var_data_mem(114) := X"53";
        var_data_mem(115) := X"54";
        var_data_mem(116) := X"55";
        var_data_mem(117) := X"56";
        var_data_mem(118) := X"57";
        var_data_mem(119) := X"58";
        var_data_mem(120) := X"59";
        var_data_mem(121) := X"5A";
        var_data_mem(122) := X"5B";
        var_data_mem(123) := X"5C";
        var_data_mem(124) := X"5D";
        var_data_mem(125) := X"5E";
        var_data_mem(126) := X"5F";
        var_data_mem(127) := X"60";
        var_data_mem(128) := X"54"; -- Start of text
        var_data_mem(129) := X"68";
        var_data_mem(130) := X"69";
        var_data_mem(131) := X"73";
        var_data_mem(132) := X"20";
        var_data_mem(133) := X"69";
        var_data_mem(134) := X"73";
        var_data_mem(135) := X"20";
        var_data_mem(136) := X"65";
        var_data_mem(137) := X"78";
        var_data_mem(138) := X"61";
        var_data_mem(139) := X"6d";
        var_data_mem(140) := X"70";
        var_data_mem(141) := X"6c";
        var_data_mem(142) := X"65";
        var_data_mem(143) := X"20";
        var_data_mem(144) := X"70";
        var_data_mem(145) := X"6c";
        var_data_mem(146) := X"61";
        var_data_mem(147) := X"69";
        var_data_mem(148) := X"6e";
        var_data_mem(149) := X"74";
        var_data_mem(150) := X"65";
        var_data_mem(151) := X"78";
        var_data_mem(152) := X"74";
        var_data_mem(153) := X"2c";
        var_data_mem(154) := X"20";
        var_data_mem(155) := X"31";
        var_data_mem(156) := X"32";
        var_data_mem(157) := X"33";
        var_data_mem(158) := X"34";
        var_data_mem(159) := X"2e";
        var_data_mem(192) := X"00";
        var_data_mem(193) := X"00";
        var_data_mem(194) := X"00";
        var_data_mem(195) := X"00";
        var_data_mem(196) := X"00";
        var_data_mem(197) := X"00";
        var_data_mem(198) := X"00";
        var_data_mem(199) := X"00";
        var_data_mem(200) := X"00";
        var_data_mem(201) := X"00";
        var_data_mem(202) := X"00";
        var_data_mem(203) := X"00";
        var_data_mem(204) := X"00";
        var_data_mem(205) := X"00";
        var_data_mem(206) := X"00";
        var_data_mem(207) := X"00";
        var_data_mem(208) := X"00";
        var_data_mem(209) := X"00";
        var_data_mem(210) := X"00";
        var_data_mem(211) := X"00";
        var_data_mem(212) := X"00";
        var_data_mem(213) := X"00";
        var_data_mem(214) := X"00";
        var_data_mem(215) := X"00";
        var_data_mem(216) := X"00";
        var_data_mem(217) := X"00";
        var_data_mem(218) := X"00";
        var_data_mem(219) := X"00";
        var_data_mem(220) := X"00";
        var_data_mem(221) := X"00";
        var_data_mem(222) := X"00";
        var_data_mem(223) := X"00";
        var_data_mem(224) := X"00";
        var_data_mem(225) := X"00";
        var_data_mem(226) := X"00";
        var_data_mem(227) := X"00";
        var_data_mem(228) := X"00";
        var_data_mem(229) := X"00";
        var_data_mem(230) := X"00";
        var_data_mem(231) := X"00";
        var_data_mem(232) := X"00";
        var_data_mem(233) := X"00";
        var_data_mem(234) := X"00";
        var_data_mem(235) := X"00";
        var_data_mem(236) := X"00";
        var_data_mem(237) := X"00";
        var_data_mem(238) := X"00";
        var_data_mem(239) := X"00";
        var_data_mem(240) := X"00";
        var_data_mem(241) := X"00";
        var_data_mem(242) := X"00";
        var_data_mem(243) := X"00";
        var_data_mem(244) := X"00";
        var_data_mem(245) := X"00";
        var_data_mem(246) := X"00";
        var_data_mem(247) := X"00";
        var_data_mem(248) := X"00";
        var_data_mem(249) := X"00";
        var_data_mem(250) := X"00";
        var_data_mem(251) := X"00";
        var_data_mem(252) := X"00";
        var_data_mem(253) := X"00";
        var_data_mem(254) := X"00";
        var_data_mem(255) := X"00";


        elsif (falling_edge(clk) and write_enable = '1') then
            -- memory writes on the falling clock edge
            var_data_mem(var_addr) := write_data;
        end if;
       
        -- continuous read of the memory location given by var_addr 
        data_out <= var_data_mem(var_addr);
 
        -- the following are probe signals (for simulation purpose) 
        sig_data_mem <= var_data_mem;

    end process;
  
end behavioral;
