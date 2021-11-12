----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:16:14 04/18/2018 
-- Design Name: 
-- Module Name:    mem_wb_reg - Behavioral 
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

entity mem_wb_reg is
    port ( reset           : in  std_logic;
           clk             : in  std_logic;
           mem_to_reg_in   : in  std_logic;
           mem_to_reg_out  : out std_logic;
			  reg_write_in    : in  std_logic;
  			  reg_write_out    : out  std_logic;
			  write_register_in : in std_logic_vector(3 downto 0);
			  write_register_out : out std_logic_vector(3 downto 0);
           alu_result_in   : in  std_logic_vector(7 downto 0);
           alu_result_out  : out std_logic_vector(7 downto 0);
           data_mem_in     : in  std_logic_vector(7 downto 0);
           data_mem_out    : out std_logic_vector(7 downto 0) );
end mem_wb_reg;

architecture behavioral of mem_wb_reg is
begin

    update_process: process ( reset, 
                              clk ) is
    begin
       if (reset = '1') then
           mem_to_reg_out   <= '0';
			  reg_write_out    <= '0';
			  write_register_out <= (others => '0');
           alu_result_out   <= (others => '0');
           data_mem_out     <= (others => '0');
       elsif (rising_edge(clk)) then
		     write_register_out <= write_register_in;
			  reg_write_out    <= reg_write_in;
           mem_to_reg_out   <= mem_to_reg_in;
           alu_result_out   <= alu_result_in;
           data_mem_out     <= data_mem_in;
       end if;
       
    end process;
end behavioral;


