----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:03:56 04/25/2018 
-- Design Name: 
-- Module Name:    alu_8b - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

entity alu_8b is
    Port ( src_a 		: in  std_logic_vector(7 downto 0);
           src_b 		: in  std_logic_vector(7 downto 0);
           alu_ctrl 	: in  std_logic_vector(3 downto 0);
           result 	: out  std_logic_vector(7 downto 0);
           zero 		: out  std_logic);
end alu_8b;

architecture Behavioral of alu_8b is

signal sig_sum 	: std_logic_vector(8 downto 0);
signal sig_and 	: std_logic_vector(8 downto 0);
signal sig_xor 	: std_logic_vector(8 downto 0);
--signal shft_a		: std_logic_vector(7 downto 0);
--signal shft_b		: std_logic_vector(2 downto 0);
signal sig_shift 	: std_logic_vector(7 downto 0);

begin

    sig_sum    <= ('0' & src_a) - ('0' & src_b) when alu_ctrl(3) = '1' else
						('0' & src_a) + ('0' & src_b);
    
    sig_xor		<= ('0' & src_a) xor ('0' & src_b);
	 sig_and		<= ('0' & src_a) and ('0' & src_b);
	 
	 --shft_a		<= to_bitvector(src_a);
	 --shft_b		<= to_integer(src_b);
	 sig_shift	<= shr(src_a, src_b) when alu_ctrl(2) = '1' else
						shl(src_a, src_b);
	
						
	 result <= sig_xor(7 downto 0) when alu_ctrl(1 downto 0) = "00" else
						sig_sum(7 downto 0) when alu_ctrl(1 downto 0) = "10" else
						sig_and(7 downto 0) when alu_ctrl(1 downto 0) = "01" else
						sig_shift;


	 zero <= '1' when src_a = src_b else
						'0';
			
end Behavioral;

