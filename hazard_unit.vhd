----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:34:55 05/15/2018 
-- Design Name: 
-- Module Name:    hazard_unit - Behavioral 
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

entity hazard_unit is
    port (
        read_register_a_id : in  std_logic_vector(3 downto 0);
        read_register_b_id : in  std_logic_vector(3 downto 0);   
	     write_register_ex  : in  std_logic_vector(3 downto 0);
		  mem_to_reg         : in  std_logic;		  
		  stall              : out std_logic
        );
end hazard_unit;

architecture Behavioral of hazard_unit is
begin
		stall <= '1' when (mem_to_reg = '1' and (read_register_a_id = write_register_ex or read_register_b_id = write_register_ex)) else
				   '0';
		

end Behavioral;