----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:56:18 04/24/2018 
-- Design Name: 
-- Module Name:    mux_3to1_8b - Behavioral 
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

entity mux_3to1_8b is
    port  (
        reg_in            : in  std_logic_vector(7 downto 0); 
        alu_result_in     : in  std_logic_vector(7 downto 0);
        reg_file_in       : in  std_logic_vector(7 downto 0);
        forward           : in  std_logic_vector(1 downto 0);
        alu_data          : out std_logic_vector(7 downto 0) );
end mux_3to1_8b;
architecture Behavioral of mux_3to1_8b is
      
begin
    alu_data <= reg_in       when forward = "00" else
                alu_result_in   when forward = "01" or forward = "11" else -- dodgy fix
                reg_file_in  when forward = "10";

end Behavioral;

