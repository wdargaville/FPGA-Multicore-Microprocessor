----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:09:44 04/25/2018 
-- Design Name: 
-- Module Name:    sign_extend_4to8 - Behavioral 
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

entity sign_extend_4to8 is
    Port ( data_in : in  STD_LOGIC_VECTOR (3 downto 0);
           data_out : out  STD_LOGIC_VECTOR (7 downto 0));
end sign_extend_4to8;

architecture Behavioral of sign_extend_4to8 is

begin
    
    sign_extend : process ( data_in ) is
    begin
        data_out(3 downto 0) <= data_in(3 downto 0);

        -- the extended bits take on the value of the most significant
        -- bit (MSB) of data_in
        for i in 7 downto 4 loop
            data_out(i) <= data_in(3);
        end loop;

    end process;
    
end behavioral;

