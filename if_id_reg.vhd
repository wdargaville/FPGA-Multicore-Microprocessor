----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:39:18 04/18/2018 
-- Design Name: 
-- Module Name:    if_id_reg - Behavioral 
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

entity if_id_reg is
    port ( reset    : in  std_logic;
           clk      : in  std_logic;
           insn_in  : in  std_logic_vector(15 downto 0);
           insn_out : out std_logic_vector(15 downto 0);
           next_pc_in : in std_logic_vector(7 downto 0);
           next_pc_out : out std_logic_vector(7 downto 0);
           insert_stall : in std_logic;
           flush : in std_logic;
           beq_flush : in std_logic);
end if_id_reg;

architecture behavioral of if_id_reg is
begin

    update_process: process ( reset, 
                              clk ) is
    begin
       if (reset = '1') then
           insn_out <= (others => '0'); 
           next_pc_out <= (others => '0');
       elsif (rising_edge(clk) and insert_stall = '0' and flush = '0' and beq_flush = '0') then
           insn_out <= insn_in;
           next_pc_out <= next_pc_in;
       elsif (rising_edge(clk) and (flush = '1' or beq_flush = '1')) then
           insn_out <= (others => '0');
           next_pc_out <= (others => '0');
       end if;
    end process;
end behavioral;

