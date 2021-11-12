----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:32:34 04/25/2018 
-- Design Name: 
-- Module Name:    ae_core_testbench - Behavioral 
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
USE IEEE.STD_LOGIC_TEXTIO.ALL;
USE STD.TEXTIO.ALL;

ENTITY ae_core_testbench IS
END ae_core_testbench;

ARCHITECTURE testbench_arch OF ae_core_testbench IS
    FILE RESULTS: TEXT OPEN WRITE_MODE IS "results.txt";
    FILE PLAINTEXT: TEXT OPEN WRITE_MODE IS "text.txt";
    

    COMPONENT ae_multicore
        Port (   reset 		: in  STD_LOGIC;
                 clk 		: in  STD_LOGIC;
                 c_in 		: in  STD_LOGIC_VECTOR (7 downto 0);
                 c_out 		: out  STD_LOGIC_VECTOR (7 downto 0);
                 wr 			: out  STD_LOGIC;
                 rd 			: out  STD_LOGIC;
                 valid_wr 	: in  STD_LOGIC;
                 valid_rd 	: in  STD_LOGIC
              );
    END COMPONENT;

    SIGNAL reset  : std_logic := '1';
    SIGNAL clk    : std_logic := '0';
    SIGNAL TB_c_in   : std_logic_vector (7 downto 0);
    SIGNAL TB_c_out  : std_logic_vector (7 downto 0);
    SIGNAL TB_wr     : std_logic;
    SIGNAL TB_rd     : std_logic;
    SIGNAL TB_valid_wr  : std_logic := '1';
    SIGNAL TB_valid_rd  : std_logic := '1';

    SHARED VARIABLE TX_ERROR : INTEGER := 0;
    SHARED VARIABLE TX_OUT : LINE;

    constant PERIOD : time := 200 ns;
    constant DUTY_CYCLE : real := 0.5;
    constant OFFSET : time := 0 ns;

    BEGIN
        UUT : ae_multicore
        PORT MAP (
            reset    => reset,
            clk      => clk,
            c_in 		=> TB_c_in,
            c_out 	=> TB_c_out,
            wr 		=> TB_wr,
            rd 		=> TB_rd,
            valid_wr => TB_valid_wr,
            valid_rd => TB_valid_rd
        );

        PROCESS    -- clock process for clk
        BEGIN
            WAIT for OFFSET;
            CLOCK_LOOP : LOOP
                clk <= '0';
                WAIT FOR (PERIOD - (PERIOD * DUTY_CYCLE));
                clk <= '1';
                WAIT FOR (PERIOD * DUTY_CYCLE);
            END LOOP CLOCK_LOOP;
        END PROCESS;

        PROCESS    -- Input Stream
        BEGIN
            TEXT_LOOP : LOOP
               readline(stimuli_file, line_buf);
               hread(line_buf, data_buf); x <= data_buf;
               hread(line_buf, data_buf); y <= data_buf;
            END LOOP CLOCK_LOOP;
        END PROCESS;


        PROCESS
            BEGIN
                -- -------------  Current Time:  285ns
                WAIT FOR 285 ns;
                reset <= '0';
                -- -------------------------------------
                WAIT FOR 240750 ns;

                IF (TX_ERROR = 0) THEN
                    STD.TEXTIO.write(TX_OUT, string'("No errors or warnings"));
                    STD.TEXTIO.writeline(RESULTS, TX_OUT);
                    ASSERT (FALSE) REPORT
                      "Simulation successful (not a failure).  No problems detected."
                      SEVERITY FAILURE;
                ELSE
                    STD.TEXTIO.write(TX_OUT, TX_ERROR);
                    STD.TEXTIO.write(TX_OUT,
                        string'(" errors found in simulation"));
                    STD.TEXTIO.writeline(RESULTS, TX_OUT);
                    ASSERT (FALSE) REPORT "Errors found during simulation"
                         SEVERITY FAILURE;
                END IF;
            END PROCESS;

    END testbench_arch;

