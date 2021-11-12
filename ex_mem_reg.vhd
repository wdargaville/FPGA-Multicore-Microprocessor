----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:56:01 04/18/2018 
-- Design Name: 
-- Module Name:    ex_mem_reg - Behavioral 
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

entity ex_mem_reg is
    port ( reset           : in  std_logic;
           clk             : in  std_logic;
           mem_write_in    : in  std_logic;
           mem_write_out   : out std_logic;
           mem_to_reg_in   : in  std_logic;
           mem_to_reg_out  : out std_logic;
			  beq_in				: in  std_logic;
			  beq_out			: out  std_logic;
       	  reg_write_in    : in  std_logic;
  	        reg_write_out   : out  std_logic;
			  write_register_in : in std_logic_vector(3 downto 0);
           write_register_out : out std_logic_vector(3 downto 0);
           read_data_b_in  : in  std_logic_vector(7 downto 0);
           read_data_b_out : out std_logic_vector(7 downto 0);
           alu_result_in   : in  std_logic_vector(7 downto 0);
           alu_result_out  : out std_logic_vector(7 downto 0);
			  alu_zero_in		: in  std_logic;
			  alu_zero_out		: out std_logic;
           beq_flush         : in  std_logic;
			  beq_pc_in       :  in std_logic_vector(7 downto 0);
			  beq_pc_out      :  out std_logic_vector(7 downto 0)
           --alu_carry_in    : in  std_logic;
           --alu_carry_out   : out std_logic; 
           --alu_ctrl_in     : in std_logic;
           --alu_ctrl_out    : out std_logic
           );
end ex_mem_reg;

architecture behavioral of ex_mem_reg is
begin

    update_process: process ( reset, 
                              clk ) is
    begin
       if (reset = '1') then
           mem_write_out    <= '0';
           mem_to_reg_out   <= '0';
           --alu_carry_out    <= '0';
			  reg_write_out    <= '0';
           --alu_ctrl_out     <= '0';
			  beq_out			 <= '0';
			  write_register_out <= (others => '0');
           read_data_b_out  <= (others => '0');
           alu_result_out   <= (others => '0');
			  alu_zero_out		 <= '0';
			  beq_pc_out  		 <= (others => '0');
       elsif (rising_edge(clk) and beq_flush = '1') then
           mem_write_out    <= '0';
           mem_to_reg_out   <= '0';
           --alu_carry_out    <= '0';
			  reg_write_out    <= '0';
           --alu_ctrl_out     <= '0';
			  beq_out			 <= '0';
			  write_register_out <= (others => '0');
           read_data_b_out  <= (others => '0');
           alu_result_out   <= (others => '0');
			  alu_zero_out		 <= '0';
			  beq_pc_out		 <= (others => '0');
			  
       elsif (rising_edge(clk)) then
           --alu_ctrl_out     <= alu_ctrl_in;
           mem_write_out    <= mem_write_in;
           mem_to_reg_out   <= mem_to_reg_in;
           read_data_b_out  <= read_data_b_in;
			  reg_write_out    <= reg_write_in;
			  write_register_out <= write_register_in;
           alu_result_out   <= alu_result_in;
           --alu_carry_out    <= alu_carry_in;
			  alu_zero_out		 <= alu_zero_in;
			  beq_out          <= beq_in;
			  beq_pc_out       <= beq_pc_in;
       end if;
       
    end process;
end behavioral;


