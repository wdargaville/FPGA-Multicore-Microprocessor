-- Authenticated Encryption Processor
-- Will Gilbert, Will Dargeville, James Slack Smith
-- April 2018

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ae_core is
    port ( reset 		: in  STD_LOGIC;
			  clk 		: in  STD_LOGIC;
           insn_addr : out STD_LOGIC_VECTOR (7 downto 0);
           insn_in   : in  STD_LOGIC_VECTOR (15 downto 0);
           c_in 		: in  STD_LOGIC_VECTOR (7 downto 0);
           c_out 		: out  STD_LOGIC_VECTOR (7 downto 0);
           wr 			: out  STD_LOGIC;
           rd 			: out  STD_LOGIC;
           valid_wr 	: in  STD_LOGIC;
           valid_rd 	: in  STD_LOGIC);
end ae_core;

architecture structural of ae_core is

component hazard_unit is
    port (
        read_register_a_id : in  std_logic_vector(3 downto 0);
        read_register_b_id : in  std_logic_vector(3 downto 0);   
	     write_register_ex  : in  std_logic_vector(3 downto 0);
		  mem_to_reg         : in  std_logic;		  
		  stall              : out std_logic
        );
end component;

component mux_3to1_8b is
    port (
        reg_in            : in  std_logic_vector(7 downto 0); 
        alu_result_in     : in  std_logic_vector(7 downto 0);
        reg_file_in       : in  std_logic_vector(7 downto 0);
        forward           : in  std_logic_vector(1 downto 0);
        alu_data          : out std_logic_vector(7 downto 0) );
end component;

component and_2_1 is
    port ( beq        		: in  std_logic;
           alu_zero      	: in  std_logic;
           output          : out std_logic );
end component;


component forward_unit is
    port ( read_register_a_ex : in std_logic_vector(3 downto 0);
           read_register_b_ex : in std_logic_vector(3 downto 0);
           write_register_mem : in std_logic_vector(3 downto 0);
           write_register_wb  : in std_logic_vector(3 downto 0); 
           reg_write_mem      : in std_logic;
           reg_write_wb       : in std_logic;
           forward_a          : out std_logic_vector( 1 downto 0);
           forward_b          : out std_logic_vector( 1 downto 0) );
end component;
        
component if_id_reg is
    port ( reset             : in  std_logic;
           clk               : in  std_logic;
           insn_in           : in  std_logic_vector(15 downto 0);
           insn_out          : out std_logic_vector(15 downto 0);
           next_pc_in        : in  std_logic_vector(7 downto 0);
           next_pc_out       : out std_logic_vector(7 downto 0);
           insert_stall      : in  std_logic;
           flush             : in  std_logic;
           beq_flush         : in  std_logic);
end component;

component id_ex_reg is
    port ( reset           : in  std_logic;
           clk             : in  std_logic;
           alu_src_in      : in  std_logic;
           alu_src_out     : out std_logic;
			  beq_in				: in  std_logic;
			  beq_out			: out std_logic;
           mem_write_in    : in  std_logic;
           mem_write_out   : out std_logic;
           mem_to_reg_in   : in  std_logic;
           mem_to_reg_out  : out std_logic;
           reg_write_in   : in  std_logic;
           reg_write_out  : out std_logic;
           alu_ctrl_in   : in  std_logic_vector(3 downto 0);
           alu_ctrl_out  : out std_logic_vector(3 downto 0);
		     write_register_in : in std_logic_vector(3 downto 0);
		     write_register_out : out std_logic_vector(3 downto 0);
           read_data_a_in  : in  std_logic_vector(7 downto 0);
           read_data_b_in  : in  std_logic_vector(7 downto 0);
           read_data_a_out : out  std_logic_vector(7 downto 0);
           read_data_b_out : out  std_logic_vector(7 downto 0);
           sig_ext_in      : in  std_logic_vector(7 downto 0);
           sig_ext_out     : out std_logic_vector(7 downto 0);
           next_pc_in      : in  std_logic_vector(7 downto 0);
           next_pc_out     : out std_logic_vector(7 downto 0);
           read_register_a_in  : in   std_logic_vector(3 downto 0);
           read_register_a_out : out  std_logic_vector(3 downto 0);
           read_register_b_in  : in   std_logic_vector(3 downto 0);
           read_register_b_out : out  std_logic_vector(3 downto 0);
           insert_stall        : in   std_logic;
           beq_flush         : in  std_logic);
end component;

component ex_mem_reg is
    port ( reset           : in  std_logic;
           clk             : in  std_logic;
           mem_write_in    : in  std_logic;
           mem_write_out   : out std_logic;
           mem_to_reg_in   : in  std_logic;
           mem_to_reg_out  : out std_logic;
			  beq_in				: in  std_logic;
			  beq_out			: out std_logic;
           reg_write_in   : in  std_logic;
           reg_write_out  : out std_logic;
			  write_register_in : in std_logic_vector(3 downto 0);
		     write_register_out : out std_logic_vector(3 downto 0);
           read_data_b_in  : in  std_logic_vector(7 downto 0);
           read_data_b_out : out  std_logic_vector(7 downto 0);
           alu_result_in   : in  std_logic_vector(7 downto 0);
           alu_result_out  : out std_logic_vector(7 downto 0);
			  alu_zero_in		: in  std_logic;
			  alu_zero_out		: out std_logic;
           beq_flush       : in  std_logic;
			  beq_pc_in       :  in std_logic_vector(7 downto 0);
			  beq_pc_out      :  out std_logic_vector(7 downto 0));
           --alu_carry_in    : in  std_logic;--slightly confusing names
           --alu_carry_out   : out std_logic; UNUSED
           --alu_ctrl_in     : in  std_logic;
           --alu_ctrl_out    : out std_logic
			  
end component;

component mem_wb_reg is
    port ( reset           : in  std_logic;
           clk             : in  std_logic;
           mem_to_reg_in   : in  std_logic;
           mem_to_reg_out  : out std_logic;
           reg_write_in   : in  std_logic;
           reg_write_out  : out std_logic;
			  write_register_in : in std_logic_vector(3 downto 0);
			  write_register_out : out std_logic_vector(3 downto 0);
           alu_result_in   : in  std_logic_vector(7 downto 0);
           alu_result_out  : out std_logic_vector(7 downto 0);
           data_mem_in     : in  std_logic_vector(7 downto 0);
           data_mem_out    : out std_logic_vector(7 downto 0) );
end component;

component program_counter is
    port ( reset    : in  std_logic;
           clk      : in  std_logic;
           addr_in  : in  std_logic_vector(7 downto 0);
           addr_out : out std_logic_vector(7 downto 0);
           insert_stall : in std_logic);
end component;

component instruction_memory is
    port ( reset    : in  std_logic;
           clk      : in  std_logic;
           addr_in  : in  std_logic_vector(7 downto 0);
           insn_out : out std_logic_vector(15 downto 0);
           insert_stall : in std_logic;
           flush        : in std_logic;
           beq_flush    : in  std_logic);
end component;

component sign_extend_4to8 is
    port ( data_in  : in  std_logic_vector(3 downto 0);
           data_out : out std_logic_vector(7 downto 0) );
end component;

component mux_2to1_4b is
    port ( mux_select : in  std_logic;
           data_a     : in  std_logic_vector(3 downto 0);
           data_b     : in  std_logic_vector(3 downto 0);
           data_out   : out std_logic_vector(3 downto 0) );
end component;

component mux_2to1_4b_2c is --2 controls
    port ( mux_select_a : in  std_logic;
			  mux_select_b : in  std_logic;
           data_a       : in  std_logic_vector(3 downto 0);
           data_b       : in  std_logic_vector(3 downto 0);
           data_out     : out std_logic_vector(3 downto 0) );
end component;

component mux_2to1_8b is
    port ( mux_select : in  std_logic;
           data_a     : in  std_logic_vector(7 downto 0);
           data_b     : in  std_logic_vector(7 downto 0);
           data_out   : out std_logic_vector(7 downto 0) );
end component;

component control_unit is
    port ( opcode     : in  std_logic_vector(3 downto 0);
           --reg_dst    : out std_logic; -- No longer needed
           reg_write  : out std_logic;
           alu_src    : out std_logic;
			  beq			 : out std_logic;
           mem_write  : out std_logic;
           alu_ctrl   : out std_logic_vector(3 downto 0);
           mem_to_reg : out std_logic; 
			  jmp        : out std_logic);
end component;

component register_file is
    port ( reset           : in  std_logic;
           clk             : in  std_logic;
           read_register_a : in  std_logic_vector(3 downto 0);
           read_register_b : in  std_logic_vector(3 downto 0);
           write_enable    : in  std_logic;
           write_register  : in  std_logic_vector(3 downto 0);
           write_data      : in  std_logic_vector(7 downto 0);
           read_data_a     : out std_logic_vector(7 downto 0);
           read_data_b     : out std_logic_vector(7 downto 0) );
end component;

component adder_8b is
    port ( src_a     : in  std_logic_vector(7 downto 0);
           src_b     : in  std_logic_vector(7 downto 0);
           sum       : out std_logic_vector(7 downto 0);
           carry_out : out std_logic );
end component;

component alu_8b is
    port ( src_a     : in  std_logic_vector(7 downto 0);
           src_b     : in  std_logic_vector(7 downto 0);
           alu_ctrl  : in  std_logic_vector(3 downto 0);
			  result		: out std_logic_vector(7 downto 0);
           zero	 	: out std_logic );
end component;

component data_memory is
    port ( reset        : in  std_logic;
           clk          : in  std_logic;
           write_enable : in  std_logic;
           write_data   : in  std_logic_vector(7 downto 0);
           addr_in      : in  std_logic_vector(7 downto 0);
           data_out     : out std_logic_vector(7 downto 0) );
end component;

--unchanged signals - no pipelines needed

signal sig_curr_pc              : std_logic_vector(7 downto 0);
signal sig_one_8b               : std_logic_vector(7 downto 0);
signal sig_pc_carry_out         : std_logic;
signal sig_reg_dst              : std_logic;
signal sig_write_data           : std_logic_vector(7 downto 0);----
signal sig_alu_src_b            : std_logic_vector(7 downto 0);

signal sig_beq_id					  : std_logic;
signal sig_beq_ex					  : std_logic;
signal sig_beq_mem				  : std_logic;
signal sig_alu_zero_ex			  : std_logic;
signal sig_alu_zero_mem			  : std_logic;
signal sig_beq_ctrl             : std_logic;

signal sig_alu_data_a_in        : std_logic_vector(7 downto 0);
signal sig_alu_data_b_in        : std_logic_vector(7 downto 0);

signal sig_beq_pc_ex            : std_logic_vector(7 downto 0);
signal sig_beq_pc_mem           : std_logic_vector(7 downto 0);

signal sig_read_register_a_ex      : std_logic_vector(3 downto 0);
signal sig_read_register_b_ex      : std_logic_vector(3 downto 0);

signal sig_forward_a               : std_logic_vector(1 downto 0);
signal sig_forward_b               : std_logic_vector(1 downto 0);

--signal sig_next_pc              : std_logic_vector(7 downto 0);
signal sig_next_pc_if              : std_logic_vector(7 downto 0);
signal sig_next_pc_id              : std_logic_vector(7 downto 0);
signal sig_next_pc_ex              : std_logic_vector(7 downto 0);
signal sig_next_pc_def             : std_logic_vector(7 downto 0); --Input to PC reg, output from mux

signal sig_next_pc_beq             : std_logic_vector(7 downto 0);

signal sig_alu_ctrl_id              : std_logic_vector(3 downto 0);
signal sig_alu_ctrl_ex              : std_logic_vector(3 downto 0);
signal sig_alu_ctrl_mem             : std_logic_vector(3 downto 0);

--signal sig_reg_write            : std_logic; SPLIT UP TO GO THROUGH PIPELINES REGISTERS
signal sig_reg_write_id            : std_logic;
signal sig_reg_write_ex            : std_logic;
signal sig_reg_write_mem            : std_logic;
signal sig_reg_write_wb            : std_logic;

--signal sig_write_register       : std_logic_vector(3 downto 0);
--signal sig_write_register_id       : std_logic_vector(3 downto 0);
signal sig_write_register_ex       : std_logic_vector(3 downto 0);
signal sig_write_register_mem       : std_logic_vector(3 downto 0);
signal sig_write_register_wb       : std_logic_vector(3 downto 0);

--signal sig_data_mem_out         : std_logic_vector(15 downto 0);
signal sig_data_mem_out_mem        : std_logic_vector(7 downto 0);
signal sig_data_mem_out_wb         : std_logic_vector(7 downto 0);

--signal sig_alu_result            : std_logic_vector(15 downto 0); 
signal sig_alu_result_ex           : std_logic_vector(7 downto 0); 
signal sig_alu_result_mem          : std_logic_vector(7 downto 0); 
signal sig_alu_result_wb           : std_logic_vector(7 downto 0);
 
--signal sig_alu_carry_out         : std_logic;
signal sig_alu_carry_ex        		: std_logic;
signal sig_alu_carry_mem       		: std_logic;

--signal sig_insn                  : std_logic_vector(15 downto 0);
signal sig_insn_if                 : std_logic_vector(15 downto 0);
signal sig_insn_id                 : std_logic_vector(15 downto 0);

--signal sig_alu_src               : std_logic;
signal sig_alu_src_id              : std_logic;
signal sig_alu_src_ex              : std_logic;

--signal sig_sign_extended_offset  : std_logic_vector(15 downto 0);
signal sig_sign_extended_offset_id : std_logic_vector(7 downto 0);
signal sig_sign_extended_offset_ex : std_logic_vector(7 downto 0);

--signal sig_mem_write             : std_logic;
signal sig_mem_write_id            : std_logic;
signal sig_mem_write_ex            : std_logic;
signal sig_mem_write_mem           : std_logic;

--signal sig_mem_to_reg            : std_logic;
signal sig_mem_to_reg_id           : std_logic;
signal sig_mem_to_reg_ex           : std_logic;
signal sig_mem_to_reg_mem          : std_logic;
signal sig_mem_to_reg_wb           : std_logic;

--signal sig_read_data_a           : std_logic_vector(15 downto 0);
signal sig_read_data_a_id          : std_logic_vector(7 downto 0);
signal sig_read_data_a_ex          : std_logic_vector(7 downto 0);

--signal sig_read_data_b           : std_logic_vector(15 downto 0);
signal sig_read_data_b_id          : std_logic_vector(7 downto 0);
signal sig_read_data_b_ex          : std_logic_vector(7 downto 0);
signal sig_read_data_b_mem         : std_logic_vector(7 downto 0);

signal sig_jmp                     : std_logic;

signal sig_read_regfile_b          : std_logic_vector(3 downto 0);

signal sig_stall                   : std_logic;

begin
    sig_one_8b <= "00000001";

    --hzd_unit : hazard_unit
  --  port map (
        
        
  --  );
    hzd_unt : hazard_unit
    port map (
        read_register_a_id    => sig_insn_id(7 downto 4),     
        read_register_b_id    => sig_insn_id(3 downto 0),
	     write_register_ex     => sig_write_register_ex,
		  mem_to_reg            => sig_mem_to_reg_ex,
		  stall                 => sig_stall
        );


    alu_mux_a : mux_3to1_8b
    port map (
        reg_in         => sig_read_data_a_ex,
        alu_result_in  => sig_alu_result_mem,
        reg_file_in    => sig_write_data,
        forward        => sig_forward_a,
        alu_data       => sig_alu_data_a_in ); --straight to alu
 
    alu_mux_b : mux_3to1_8b
    port map (
        reg_in         => sig_read_data_b_ex,
        alu_result_in  => sig_alu_result_mem,
        reg_file_in    => sig_write_data,
        forward        => sig_forward_b,
        alu_data       => sig_alu_data_b_in );--to alu b mux
 
    fwd_unt : forward_unit
    port map (
        read_register_a_ex => sig_read_register_a_ex,
        read_register_b_ex => sig_read_register_b_ex,
        write_register_mem => sig_write_register_mem,
        write_register_wb  => sig_write_register_wb,
        reg_write_mem      => sig_reg_write_mem,
        reg_write_wb       => sig_reg_write_wb,
        forward_a          => sig_forward_a,
        forward_b          => sig_forward_b );

    --b = out when in = 1
	 -- THIS IS IN IF STAGE, has to go to 8 bit
    beq_mux : mux_2to1_8b
    port map (
           mux_select => sig_beq_ctrl,     
           data_a =>  sig_next_pc_beq, --default 
           data_b => sig_beq_pc_mem,
           data_out => sig_next_pc_def
           );    

    jmp_mux : mux_2to1_8b
    port map (
           mux_select => sig_jmp,     
           data_a =>  sig_next_pc_if,--default        
           data_b =>  sig_insn_id(7 downto 0),
           data_out => sig_next_pc_beq
           );   

    reg_mux : mux_2to1_4b_2c
    port map (
           mux_select_a => sig_mem_write_id,
           mux_select_b => sig_beq_id,
           data_a =>  sig_insn_id(3 downto 0),--default        
           data_b =>  sig_insn_id(11 downto 8),
           data_out => sig_read_regfile_b
           );  

    beq_and : and_2_1
    port map (
           beq 		=> sig_beq_mem,     
           alu_zero 	=> sig_alu_zero_mem,         
           output 	=> sig_beq_ctrl );     

         --no changes currently
			-- has to go to 8bit
    branch_pc : adder_8b 
    port map ( src_a     => sig_next_pc_ex, 
               src_b     => sig_sign_extended_offset_ex(7 downto 0),
               sum       => sig_beq_pc_ex   
               --carry_out => sig_pc_carry_out 
               );

    if_id_pipe : if_id_reg
    port map ( reset    => reset,
               clk      => clk,
               insn_in  => sig_insn_if,
               insn_out => sig_insn_id,
               next_pc_in      => sig_next_pc_if,
               next_pc_out     => sig_next_pc_id,
               insert_stall    => sig_stall,
               flush           => sig_jmp,
               beq_flush       => sig_beq_ctrl);

    id_ex_pipe : id_ex_reg
    port map ( reset           => reset,
               clk             => clk,
               alu_src_in      => sig_alu_src_id,
               alu_src_out     => sig_alu_src_ex,
					beq_in			 => sig_beq_id,
					beq_out			 => sig_beq_ex,
               alu_ctrl_in      => sig_alu_ctrl_id,
               alu_ctrl_out     => sig_alu_ctrl_ex,
					reg_write_in    => sig_reg_write_id,
					reg_write_out    => sig_reg_write_ex,
               mem_write_in    => sig_mem_write_id,
               mem_write_out   => sig_mem_write_ex,
               mem_to_reg_in   => sig_mem_to_reg_id,
               mem_to_reg_out  => sig_mem_to_reg_ex,
				   write_register_in => sig_insn_id(11 downto 8),
					write_register_out => sig_write_register_ex,
               read_data_a_in  => sig_read_data_a_id,
               read_data_b_in  => sig_read_data_b_id,
               read_data_a_out => sig_read_data_a_ex,
               read_data_b_out => sig_read_data_b_ex,
               sig_ext_in      => sig_sign_extended_offset_id,
               sig_ext_out     => sig_sign_extended_offset_ex, 
               next_pc_in      => sig_next_pc_id,
               next_pc_out     => sig_next_pc_ex,
               read_register_a_in  => sig_insn_id(7 downto 4), 
               read_register_a_out => sig_read_register_a_ex,
               read_register_b_in  => sig_insn_id(3 downto 0),
               read_register_b_out => sig_read_register_b_ex,   
               insert_stall        => sig_stall,
               beq_flush       => sig_beq_ctrl);

    ex_mem_pipe : ex_mem_reg
    port map ( reset           => reset,
               clk             => clk,
               mem_write_in    => sig_mem_write_ex,
               mem_write_out   => sig_mem_write_mem,
					reg_write_in    => sig_reg_write_ex,
					reg_write_out    => sig_reg_write_mem,
               mem_to_reg_in   => sig_mem_to_reg_ex,
               mem_to_reg_out  => sig_mem_to_reg_mem,
					beq_in			 => sig_beq_ex,
					beq_out			 => sig_beq_mem,
					write_register_in => sig_write_register_ex,
					write_register_out => sig_write_register_mem,
               read_data_b_in  => sig_read_data_b_ex,
               read_data_b_out => sig_read_data_b_mem,
               alu_result_in   => sig_alu_result_ex,
               alu_result_out  => sig_alu_result_mem,
					alu_zero_in	 	 => sig_alu_zero_ex,
					alu_zero_out	 => sig_alu_zero_mem,
               beq_flush       => sig_beq_ctrl,
					beq_pc_in       => sig_beq_pc_ex,
					beq_pc_out      => sig_beq_pc_mem
					);
               --alu_carry_in    => sig_alu_carry_ex,
               --alu_carry_out   => sig_alu_carry_mem,
               --alu_ctrl_in      => sig_alu_ctrl_ex,
               --alu_ctrl_out     => sig_alu_ctrl_mem 
					

    mem_wb_pipe : mem_wb_reg
    port map ( reset           => reset,
               clk             => clk,
               mem_to_reg_in   => sig_mem_to_reg_mem,
               mem_to_reg_out  => sig_mem_to_reg_wb,
					reg_write_in    => sig_reg_write_mem,
					reg_write_out    => sig_reg_write_wb,
					write_register_in => sig_write_register_mem,
					write_register_out => sig_write_register_wb,
               alu_result_in    => sig_alu_result_mem,
               alu_result_out   => sig_alu_result_wb,
               data_mem_in      => sig_data_mem_out_mem,
               data_mem_out     => sig_data_mem_out_wb );

    --no changes currently
    pc : program_counter
    port map ( reset    => reset,
               clk      => clk,
               addr_in  => sig_next_pc_def,
               addr_out => sig_curr_pc,
               insert_stall => sig_stall); 

    --no changes currently
    next_pc : adder_8b 
    port map ( src_a     => sig_curr_pc, 
               src_b     => sig_one_8b,
               sum       => sig_next_pc_if,   
               carry_out => sig_pc_carry_out );
 
    --needs changes to outputs, go to IF/ID reg
    insn_mem : instruction_memory
    port map ( reset    => reset,
               clk      => clk,
               addr_in  => sig_curr_pc,
               insn_out => sig_insn_if,
               insert_stall => sig_stall,
               flush        => sig_jmp,
               beq_flush       => sig_beq_ctrl);

    --changes, inputs and outsputs go to ID/EX
    sign_extend : sign_extend_4to8 
    port map ( data_in  => sig_insn_id(3 downto 0),
               data_out => sig_sign_extended_offset_id );

    --changes: some outputs ID/EX some not, input from IF/ID reg
    ctrl_unit : control_unit 
    port map ( opcode     => sig_insn_id(15 downto 12),
               --reg_dst    => sig_reg_dst,
               reg_write  => sig_reg_write_id,
               alu_src    => sig_alu_src_id,
					beq		  => sig_beq_id,
               alu_ctrl   => sig_alu_ctrl_id,
               mem_write  => sig_mem_write_id, -- Write EN
               mem_to_reg => sig_mem_to_reg_id,
				   jmp        => sig_jmp); --WB Src

    --changes: inputs from IF/ID reg
    --mux_reg_dst : mux_2to1_4b 
    --port map ( mux_select => sig_reg_dst,
    --           data_a     => sig_insn_id(7 downto 4),--
    --           data_b     => sig_insn_id(3 downto 0),--
    --           data_out   => sig_write_register_id );

    --changes: some inputs from IF/ID reg, outputs to ID/EX 
    reg_file : register_file 
    port map ( reset           => reset, 
               clk             => clk,
               read_register_a => sig_insn_id(7 downto 4),--
               read_register_b => sig_read_regfile_b,
               write_enable    => sig_reg_write_wb,
               write_register  => sig_write_register_wb,
               write_data      => sig_write_data,
               read_data_a     => sig_read_data_a_id,
               read_data_b     => sig_read_data_b_id );
    
    --inputs from from ID/EX reg
    mux_alu_src : mux_2to1_8b 
    port map ( mux_select => sig_alu_src_ex,
               data_a     => sig_alu_data_b_in,
               data_b     => sig_sign_extended_offset_ex,
               data_out   => sig_alu_src_b );

    --changes: some inputs from ID/EX, outputs to EX/MEM
    alu : alu_8b 
    port map ( src_a     => sig_alu_data_a_in,--
               src_b     => sig_alu_src_b,
					alu_ctrl  => sig_alu_ctrl_ex,
               result    => sig_alu_result_ex,
               zero 	    => sig_alu_zero_ex );--

    --changes: inputs from EX/MEM outputs to MEM/WB
    data_mem : data_memory 
    port map ( reset        => reset,
               clk          => clk,
               write_enable => sig_mem_write_mem,--????
               write_data   => sig_read_data_b_mem,--
               addr_in      => sig_alu_result_mem(7 downto 0),--makes sense
               data_out     => sig_data_mem_out_mem );--
               
    --changes: inputs from MEM/WB
    --changes for writeback bug
    mux_mem_to_reg : mux_2to1_8b 
    port map ( mux_select => sig_mem_to_reg_wb,--
               data_a     => sig_alu_result_wb,--
               data_b     => sig_data_mem_out_wb,--
               data_out   => sig_write_data );--

end structural;
