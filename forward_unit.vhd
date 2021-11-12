----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:51:50 04/24/2018 
-- Design Name: 
-- Module Name:    forward_unit - Behavioral 
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

entity forward_unit is
    port  (
        read_register_a_ex : in std_logic_vector(3 downto 0);
        read_register_b_ex : in std_logic_vector(3 downto 0);
        write_register_mem : in std_logic_vector(3 downto 0);
        write_register_wb  : in std_logic_vector(3 downto 0); 
        reg_write_mem      : in std_logic;
        reg_write_wb       : in std_logic;
        forward_a          : out std_logic_vector( 1 downto 0);
        forward_b          : out std_logic_vector( 1 downto 0)
        );
end forward_unit;

architecture behavioral of forward_unit is
begin
        --EX HAZARD
        forward_a(0) <= '1' when (reg_write_mem = '1'
                                and write_register_mem /= "0000" 
                                and write_register_mem = read_register_a_ex) else
                        '0';

        forward_b(0) <= '1' when (reg_write_mem = '1'
                                and write_register_mem /= "0000" 
                                and write_register_mem = read_register_b_ex) else
                        '0';                    
        
        
        --MEM HAZARD
        forward_a(1) <= '1' when (reg_write_wb = '1'
                                and write_register_wb /= "0000" 
								--		  and not(reg_write_mem = '1' and (write_register_mem /= "0000")
								--	         and (write_register_mem /= read_register_a_ex))
                                and write_register_wb = read_register_a_ex) else
                        '0';        
        
        
        forward_b(1) <= '1' when (reg_write_wb = '1'
                                and write_register_wb /= "0000" 
								--		  and not(reg_write_mem = '1' and (write_register_mem /= "0000")
								--	         and (write_register_mem /= read_register_b_ex))
                                and write_register_wb = read_register_b_ex) else
                        '0';                                        

--if (MEM/WB.RegWrite SIGNAL
--	and (MEM/WB.RegisterRd ? 0) REGISTER
--	and not(EX/MEM.RegWrite and (EX/MEM.RegisterRd ? 0) SIGNAL, REGISTER
	--	and (EX/MEM.RegisterRd ? ID/EX.RegisterRs))   REGISTER, REGISRTER
--	and (MEM/WB.RegisterRd = ID/EX.RegisterRs)) ForwardA = 01

--if (MEM/WB.RegWrite
--	and (MEM/WB.RegisterRd ? 0)
--	and not(EX/MEM.RegWrite and (EX/MEM.RegisterRd ? 0)
    --	and (EX/MEM.RegisterRd ? ID/EX.RegisterRt))
--	and (MEM/WB.RegisterRd = ID/EX.RegisterRt)) ForwardB = 01

end behavioral;

