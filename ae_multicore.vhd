----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:58:05 05/22/2018 
-- Design Name: 
-- Module Name:    ae_multicore - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ae_multicore is
    Port ( reset 		: in  STD_LOGIC;
			  clk 		: in  STD_LOGIC;
           c_in 		: in  STD_LOGIC_VECTOR (7 downto 0);
           c_out 		: out  STD_LOGIC_VECTOR (7 downto 0);
           wr 			: out  STD_LOGIC;
           rd 			: out  STD_LOGIC;
           valid_wr 	: in  STD_LOGIC;
           valid_rd 	: in  STD_LOGIC);
end ae_multicore;

architecture Behavioral of ae_multicore is

component ae_core is
    port ( reset 		: in  STD_LOGIC;
			  clk 		: in  STD_LOGIC;
           insn_addr : out STD_LOGIC_VECTOR (7 downto 0);
           insn_in   : in  STD_LOGIC_VECTOR (15 downto 0);
           c_in 		: in  STD_LOGIC_VECTOR (7 downto 0);
           c_out 		: out  STD_LOGIC_VECTOR (7 downto 0);
           wr 			: out  STD_LOGIC;
           rd 			: out  STD_LOGIC;
           valid_wr 	: in  STD_LOGIC;
           valid_rd 	: in  STD_LOGIC);
end component;

component instruction_memory_enc1 is
    port ( reset    : in  std_logic;
           clk      : in  std_logic;
           addr_in  : in  std_logic_vector(7 downto 0);
           insn_out : out std_logic_vector(15 downto 0) );
end component;

component instruction_memory_enc2 is
    port ( reset    : in  std_logic;
           clk      : in  std_logic;
           addr_in  : in  std_logic_vector(7 downto 0);
           insn_out : out std_logic_vector(15 downto 0) );
end component;

component instruction_memory_tag is
    port ( reset    : in  std_logic;
           clk      : in  std_logic;
           addr_in  : in  std_logic_vector(7 downto 0);
           insn_out : out std_logic_vector(15 downto 0) );
end component;

component intercore_reg is
   port (   reset    : in  std_logic;
            clk      : in  std_logic;
            c_in     : in  std_logic_vector(7 downto 0);
            c_out    : out std_logic_vector(7 downto 0);
            wr       : in  std_logic;
            rd       : in  std_logic;
            valid    : out std_logic );
end component;

signal sig_pc_core1 	   : std_logic_vector(7 downto 0);
signal sig_insn_core1   : std_logic_vector(15 downto 0);
signal sig_c_in_core1   : std_logic_vector(7 downto 0);
signal sig_c_out_core1  : std_logic_vector(7 downto 0);
signal sig_wr_core1     : std_logic;
signal sig_rd_core1     : std_logic;

signal sig_pc_core2 	   : std_logic_vector(7 downto 0);
signal sig_insn_core2   : std_logic_vector(15 downto 0);
signal sig_c_in_core2   : std_logic_vector(7 downto 0);
signal sig_c_out_core2  : std_logic_vector(7 downto 0);
signal sig_wr_core2     : std_logic;
signal sig_rd_core2     : std_logic;

signal sig_pc_core3 	   : std_logic_vector(7 downto 0);
signal sig_insn_core3   : std_logic_vector(15 downto 0);
signal sig_c_in_core3   : std_logic_vector(7 downto 0);
signal sig_c_out_core3  : std_logic_vector(7 downto 0);
signal sig_wr_core3     : std_logic;
signal sig_rd_core3     : std_logic;

signal sig_pc_core4 	   : std_logic_vector(7 downto 0);
signal sig_insn_core4   : std_logic_vector(15 downto 0);
signal sig_c_in_core4   : std_logic_vector(7 downto 0);
signal sig_c_out_core4  : std_logic_vector(7 downto 0);
signal sig_wr_core4     : std_logic;
signal sig_rd_core4     : std_logic;

signal valid_12         : std_logic;
signal valid_23         : std_logic;
signal valid_34         : std_logic;
signal valid_rd_top     : std_logic;
signal valid_wr_top     : std_logic;


begin 

   insn_mem1 : instruction_memory_enc1
	port map (  reset    => reset,
               clk      => clk,
               addr_in  => sig_pc_core1,
               insn_out => sig_insn_core1 );
               
   ae_core1 : ae_core
   port map (  reset 	=> reset,
               clk 		=> clk,
               insn_addr   => sig_pc_core1,
               insn_in  => sig_insn_core1,
               c_in 		=> sig_c_in_core1,
               c_out 	=> sig_c_out_core1,
               wr 		=> sig_wr_core1,
               rd 		=> sig_rd_core1,
               valid_wr => valid_12,
               valid_rd => valid_rd_top );

   intercore_reg12 : intercore_reg
   port map (  reset    => reset,
               clk      => clk,
               c_in     => sig_c_out_core1,
               c_out    => sig_c_in_core2,
               wr       => sig_wr_core1,
               rd       => sig_rd_core2,
               valid    => valid_12 );

   insn_mem2 : instruction_memory_enc2
	port map (  reset    => reset,
               clk      => clk,
               addr_in  => sig_pc_core2,
               insn_out => sig_insn_core2 );

   ae_core2 : ae_core
   port map (  reset 	=> reset,
               clk 		=> clk,
               insn_addr   => sig_pc_core2,
               insn_in  => sig_insn_core2,
               c_in 		=> sig_c_in_core2,
               c_out 	=> sig_c_out_core2,
               wr 		=> sig_wr_core2,
               rd 		=> sig_rd_core2,
               valid_wr => valid_23,
               valid_rd => valid_12 );

   intercore_reg23 : intercore_reg
   port map (  reset    => reset,
               clk      => clk,
               c_in     => sig_c_out_core2,
               c_out    => sig_c_in_core3,
               wr       => sig_wr_core2,
               rd       => sig_rd_core3,
               valid    => valid_23 );

   insn_mem3 : instruction_memory_enc2
	port map (  reset    => reset,
               clk      => clk,
               addr_in  => sig_pc_core3,
               insn_out => sig_insn_core3 );

   ae_core3 : ae_core
   port map (  reset 	=> reset,
               clk 		=> clk,
               insn_addr   => sig_pc_core3,
               insn_in  => sig_insn_core3,
               c_in 		=> sig_c_in_core3,
               c_out 	=> sig_c_out_core3,
               wr 		=> sig_wr_core3,
               rd 		=> sig_rd_core3,
               valid_wr => valid_34,
               valid_rd => valid_23 );

   intercore_reg34 : intercore_reg
   port map (  reset    => reset,
               clk      => clk,
               c_in     => sig_c_out_core3,
               c_out    => sig_c_in_core4,
               wr       => sig_wr_core3,
               rd       => sig_rd_core4,
               valid    => valid_34 );
               
   insn_mem4 : instruction_memory_tag
	port map (  reset    => reset,
               clk      => clk,
               addr_in  => sig_pc_core4,
               insn_out => sig_insn_core4 );
               
   ae_core4 : ae_core
   port map (  reset 	=> reset,
               clk 		=> clk,
               insn_addr   => sig_pc_core4,
               insn_in  => sig_insn_core4,
               c_in 		=> sig_c_in_core4,
               c_out 	=> sig_c_out_core4,
               wr 		=> sig_wr_core4,
               rd 		=> sig_rd_core4,
               valid_wr => valid_wr_top,
               valid_rd => valid_34 );
end Behavioral;

