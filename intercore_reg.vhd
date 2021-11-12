----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:59:01 05/23/2018 
-- Design Name: 
-- Module Name:    intercore_reg - Behavioral 
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

entity intercore_reg is
    Port ( reset  : in  STD_LOGIC;
           clk    : in  STD_LOGIC;
           c_in   : in  STD_LOGIC_VECTOR (7 downto 0);
           c_out  : out  STD_LOGIC_VECTOR (7 downto 0);
           wr     : in  STD_LOGIC;
           rd     : in  STD_LOGIC;
           valid  : out  STD_LOGIC);
end intercore_reg;

architecture Behavioral of intercore_reg is

signal sig_valid 	: std_logic;

begin
   
   update_process: process ( reset, 
                              clk ) is
   begin
      if (reset = '1') then
         c_out <= (others => '0'); 
         sig_valid <= '0';
      elsif (rising_edge(clk)) then
         if (sig_valid = '0' and wr = '1') then
            c_out <= c_in;
            sig_valid <= '1';
         elsif (sig_valid = '1' and rd = '1') then
            sig_valid <= '0';
         end if;
      end if;
   end process;
   
   valid <= sig_valid;

end Behavioral;

