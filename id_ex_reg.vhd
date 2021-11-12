----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:05:11 04/18/2018 
-- Design Name: 
-- Module Name:    id_ex_reg - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity id_ex_reg is
    port ( reset           : in  std_logic;
           clk             : in  std_logic;
           alu_src_in      : in  std_logic;
           alu_src_out     : out std_logic;
           alu_ctrl_in      : in  std_logic_vector(3 downto 0);
           alu_ctrl_out     : out std_logic_vector(3 downto 0);
			  beq_in				: in  std_logic;
			  beq_out			: out std_logic;
           mem_write_in    : in  std_logic;
           mem_write_out   : out std_logic;
           mem_to_reg_in   : in  std_logic;
           mem_to_reg_out  : out std_logic;
		   reg_write_in    : in  std_logic;
  		   reg_write_out    : out  std_logic;
	       write_register_in : in std_logic_vector(3 downto 0);
       	   write_register_out : out std_logic_vector(3 downto 0);
           read_data_a_in  : in  std_logic_vector(7 downto 0);
           read_data_b_in  : in  std_logic_vector(7 downto 0);
           read_data_a_out : out std_logic_vector(7 downto 0);
           read_data_b_out : out std_logic_vector(7 downto 0);
           sig_ext_in      : in  std_logic_vector(7 downto 0);
           sig_ext_out     : out std_logic_vector(7 downto 0);
           next_pc_in      : in std_logic_vector(7 downto 0);
           next_pc_out     : out std_logic_vector(7 downto 0);
           read_register_a_in  : in   std_logic_vector(3 downto 0);
           read_register_a_out : out   std_logic_vector(3 downto 0);
           read_register_b_in  : in  std_logic_vector(3 downto 0);
           read_register_b_out : out  std_logic_vector(3 downto 0);
           insert_stall        : in std_logic;
           beq_flush           : in std_logic);
end id_ex_reg;

architecture behavioral of id_ex_reg is
begin

    update_process: process ( reset, 
                              clk ) is
    begin
       if (reset = '1') then
           alu_src_out      <= '0';
           mem_write_out    <= '0';
           mem_to_reg_out   <= '0';
           alu_ctrl_out     <= (others => '0');
			  beq_out			 <= '0';
			  reg_write_out    <= '0';
			  write_register_out <= (others => '0');
           read_data_a_out  <= (others => '0');
           read_data_b_out  <= (others => '0');
           sig_ext_out      <= (others => '0');
           next_pc_out      <= (others => '0');
           read_register_a_out <= (others => '0');
           read_register_b_out <= (others => '0');     
       elsif (rising_edge(clk) and (insert_stall = '1' or beq_flush = '1')) then
           alu_src_out      <= '0';
           mem_write_out    <= '0';
           mem_to_reg_out   <= '0';
           alu_ctrl_out     <= (others => '0');
			  beq_out			 <= '0';
			  reg_write_out    <= '0';
			  write_register_out <= (others => '0');
           read_data_a_out  <= (others => '0');
           read_data_b_out  <= (others => '0');
           sig_ext_out      <= (others => '0');
           next_pc_out      <= (others => '0');
           read_register_a_out <= (others => '0');
           read_register_b_out <= (others => '0');    
       elsif (rising_edge(clk) and insert_stall = '0') then
           alu_ctrl_out    <= alu_ctrl_in;
           alu_src_out     <= alu_src_in;
			  beq_out			<= beq_in;
           mem_write_out   <= mem_write_in;
           mem_to_reg_out  <= mem_to_reg_in;
			  reg_write_out   <= reg_write_in;
			  write_register_out <= write_register_in;
           read_data_a_out <= read_data_a_in;
           read_data_b_out <= read_data_b_in;
           sig_ext_out     <= sig_ext_in;
           next_pc_out     <= next_pc_in;
           read_register_a_out <= read_register_a_in;
           read_register_b_out <= read_register_b_in;
       end if;
       
    end process;
end behavioral;

