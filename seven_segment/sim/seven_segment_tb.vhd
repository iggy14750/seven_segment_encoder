library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

library STD;
use std.env.all;

library uvvm_util;
context uvvm_util.uvvm_util_context;

entity seven_segment_tb is
end entity seven_segment_tb;

-------------------------------
-- Seven-Segment Encoder Testbench
--
-- +A+
-- F B
-- +G+
-- E C
-- +D+
-------------------------------
architecture tb of seven_segment_tb is
	-------------------------------
	-- DUT Component
	-------------------------------
	component seven_segment is
		port (
			clk           : in  std_logic;
			hex_value     : in  std_logic_vector(3 downto 0);
			seven_seg_A   : out std_logic;
			seven_seg_B   : out std_logic;
			seven_seg_C   : out std_logic;
			seven_seg_D   : out std_logic;
			seven_seg_E   : out std_logic;
			seven_seg_F   : out std_logic;
			seven_seg_G   : out std_logic
		);
	end component;

	-------------------------------
	-- Constants and Signals
	-------------------------------
	constant C_SCOPE              : string := C_TB_SCOPE_DEFAULT;
	constant C_CLK_PERIOD         : time := 10 ns;
	signal clock_ena              : boolean := false;
	signal clk                    : std_logic := '0';
	signal hex_value              : std_logic_vector(3 downto 0) := (others=>'0');
	signal seven_seg_packed       : std_logic_vector(6 downto 0) := (others=>'0');

	-------------------------------
	-- Global Procedures and Functions
	-------------------------------
	-- I could have check_no_metavalue just constantly checking in the background
	procedure check_no_metavalue(
		sig            : in  std_logic_vector
	) is
		variable thisbit : std_logic := '0';
		variable is_meta : boolean := false;
	begin
		for bitno in sig'range loop
			thisbit := sig(bitno);
			-- The old assert method - deprecated
			-- assert thisbit = '1' or thisbit = '0' severity failure;
			-- New assert - from UVVM
			is_meta := not (thisbit = '1' or thisbit = '0');
			check_value(is_meta, false, TB_ERROR,
				"Check that all output bit are 1 or 0"
			);
		end loop;
	end procedure;

begin

	-------------------------------
	-- Clock Generator
	-------------------------------
	clock_generator(clk, clock_ena, C_CLK_PERIOD, "IRQC TB clock");

	-------------------------------
	-- Testbench Main Control Process
	-------------------------------
	main: process
	begin
		report_global_ctrl(VOID);
		report_msg_id_panel(VOID);

		enable_log_msg(ALL_MESSAGES);
		--disable_log_msg(ALL_MESSAGES);
		--enable_log_msg(ID_LOG_HDR);

		log(ID_LOG_HDR, "Start Simulation of TB for Seven Segment", C_SCOPE);

                clock_ena <= true;                  -- to start clock generator

		wait_num_rising_edge(clk, 4);
		check_no_metavalue(seven_seg_packed);

		-- Stop simulation
    		std.env.stop;
		wait;
	end process;

	-------------------------------
	-- Instance the DUT
	-------------------------------
	dut: seven_segment
	port map (
		clk           => clk,
		hex_value     => hex_value,
		seven_seg_A   => seven_seg_packed(0),
		seven_seg_B   => seven_seg_packed(1),
		seven_seg_C   => seven_seg_packed(2),
		seven_seg_D   => seven_seg_packed(3),
		seven_seg_E   => seven_seg_packed(4),
		seven_seg_F   => seven_seg_packed(5),
		seven_seg_G   => seven_seg_packed(6)
	);
		
end tb;

