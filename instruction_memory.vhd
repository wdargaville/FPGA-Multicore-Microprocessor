---------------------------------------------------------------------------
-- instruction_memory.vhd - Implementation of A Single-Port, 16 x 16-bit
--                          Instruction Memory.
-- 
-- Notes: refer to headers in single_cycle_core.vhd for the supported ISA.
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

entity instruction_memory is
    port ( reset    : in  std_logic;
           clk      : in  std_logic;
           addr_in  : in  std_logic_vector(7 downto 0);
           insn_out : out std_logic_vector(15 downto 0);
           insert_stall : in std_logic;
           flush        : in std_logic;
           beq_flush    : in  std_logic);
end instruction_memory;

architecture behavioral of instruction_memory is

type mem_array is array(0 to 255) of std_logic_vector(15 downto 0);
signal sig_insn_mem : mem_array;

begin
    mem_process: process ( clk,
                           addr_in ) is
  
    variable var_insn_mem : mem_array;
    variable var_addr     : integer;
  
    begin
        if (reset = '1') then

--            var_insn_mem(0)  := X"0000";
--            var_insn_mem(1)  := X"4301";
--            var_insn_mem(2)  := X"4201";
--            var_insn_mem(3)  := X"0000";
--            var_insn_mem(4)  := X"0000";
--            var_insn_mem(5)  := X"A237";
--            var_insn_mem(6)  := X"0000";
--            var_insn_mem(7)  := X"0000";
--            var_insn_mem(8)  := X"0000";
--            var_insn_mem(9)  := X"0000";
--            var_insn_mem(10) := X"0000";
--            var_insn_mem(11) := X"0000";
--            var_insn_mem(12) := X"0000";
--            var_insn_mem(13) := X"0000";
--            var_insn_mem(14) := X"0000";
--            var_insn_mem(15) := X"0000";


        var_insn_mem(0)  := X"B002"; --RESET????
        var_insn_mem(1)  := X"3100"; --START
        var_insn_mem(2)  := X"4204";
        var_insn_mem(3)  := X"9224";
        var_insn_mem(4)  := X"9321";
        var_insn_mem(5)  := X"3432";
        var_insn_mem(6)  := X"3500";
        var_insn_mem(7)  := X"3600";
        var_insn_mem(8)  := X"3700";
        --previous instructions function correctly
        var_insn_mem(9)  := X"5835"; --LOOP1
        var_insn_mem(10)  := X"0000"; 
        var_insn_mem(11)  := X"0000"; 
        var_insn_mem(12)  := X"A802";
        var_insn_mem(13)  := X"A002";
        var_insn_mem(14)  := X"B04B";
        var_insn_mem(15)  := X"3B00"; --$8 holds enchar???
        var_insn_mem(16)  := X"4E0F";
        var_insn_mem(17)  := X"7EE2";
        var_insn_mem(18)  := X"5C1B"; --loop2 (256 data memory)
        var_insn_mem(19)  := X"2D8C";
        var_insn_mem(20)  := X"0DDE";
        var_insn_mem(21)  := X"582D";
        var_insn_mem(22)  := X"4BB1";
        var_insn_mem(23)  := X"5C1B";
        var_insn_mem(24)  := X"2D8C";
        var_insn_mem(25)  := X"0DDE";
        var_insn_mem(26)  := X"582D";
        var_insn_mem(27)  := X"4BB1";
        var_insn_mem(28)  := X"5C1B";
        var_insn_mem(29)  := X"2D8C";
        var_insn_mem(30)  := X"0DDE";
        var_insn_mem(31)  := X"582D";
        var_insn_mem(32)  := X"4BB1";
        var_insn_mem(33)  := X"5C1B";
        var_insn_mem(34)  := X"2D8C";
        var_insn_mem(35)  := X"0DDE";
        var_insn_mem(36)  := X"582D";
        var_insn_mem(37)  := X"4BB1";
        var_insn_mem(38)  := X"5C1B";
        var_insn_mem(39)  := X"2D8C";
        var_insn_mem(40)  := X"0DDE";
        var_insn_mem(41)  := X"582D";
        var_insn_mem(42)  := X"4BB1";
        var_insn_mem(43)  := X"5C1B";
        var_insn_mem(44)  := X"2D8C";
        var_insn_mem(45)  := X"0DDE";
        var_insn_mem(46)  := X"582D";
        var_insn_mem(47)  := X"4BB1";
        var_insn_mem(48)  := X"5C1B";
        var_insn_mem(49)  := X"2D8C";
        var_insn_mem(50)  := X"0DDE";
        var_insn_mem(51)  := X"582D";
        var_insn_mem(52)  := X"4BB1";
        var_insn_mem(53)  := X"5C1B";
        var_insn_mem(54)  := X"2D8C";
        var_insn_mem(55)  := X"0DDE";
        var_insn_mem(56)  := X"582D";
        var_insn_mem(57)  := X"4B0F";
        var_insn_mem(58)  := X"7BB1";
        var_insn_mem(59)  := X"088B";
        var_insn_mem(60)  := X"3A45";
        var_insn_mem(61)  := X"0000";
        var_insn_mem(62)  := X"0000";
        var_insn_mem(63)  := X"68A0";
        var_insn_mem(64)  := X"7963";
        var_insn_mem(65)  := X"5C19";
        var_insn_mem(66)  := X"1A67";
        var_insn_mem(67)  := X"899A";
        var_insn_mem(68)  := X"1991";
        var_insn_mem(69)  := X"8989";
        var_insn_mem(70)  := X"2779";
        var_insn_mem(71)  := X"4661";
        var_insn_mem(72)  := X"066E";
        var_insn_mem(73)  := X"4551";
        var_insn_mem(74)  := X"B009";
        var_insn_mem(75)  := X"4F18"; --store tag after key in memory
        var_insn_mem(76)  := X"0000";
        var_insn_mem(77)  := X"0000";
        var_insn_mem(78)  := X"6718";
        var_insn_mem(79)  := X"0000";

--constant OP_ANDI  : std_logic_vector(3 downto 0) := "0001";1
--constant OP_XOR   : std_logic_vector(3 downto 0) := "0010";2
--constant OP_ADD   : std_logic_vector(3 downto 0) := "0011";3
--constant OP_ADDI  : std_logic_vector(3 downto 0) := "0100";4
--constant OP_LW    : std_logic_vector(3 downto 0) := "0101";5
--constant OP_SWI   : std_logic_vector(3 downto 0) := "0110";6
--constant OP_SRLI  : std_logic_vector(3 downto 0) := "0111";7
--constant OP_SRL   : std_logic_vector(3 downto 0) := "1000";8
--constant OP_SLLI  : std_logic_vector(3 downto 0) := "1001";9
--constant OP_BEQ   : std_logic_vector(3 downto 0) := "1010";A
--constant OP_JUMP  : std_logic_vector(3 downto 0) := "1011";B
----constant OP_SLT   : std_logic_vector(3 downto 0) := "1100";C
--constant OP_AND   : std_logic_vector(3 downto 0) := "1101";D
--constant OP_J     : std_logic_vector(3 downto 0) := "1110";E



				insn_out <= (others => '0');
        end if;
            var_addr := conv_integer(addr_in);
            insn_out <= var_insn_mem(var_addr);
        -- the following are probe signals (for simulation purpose)
        sig_insn_mem <= var_insn_mem;

    end process;
  
end behavioral;
