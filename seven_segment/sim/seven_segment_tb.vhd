library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

library STD;
use std.env.all;

library uvvm_util;
context uvvm_util.uvvm_util_context;

library work;
use work.seven_segment_pkg.all;

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
	-- Constants and Signals
	-------------------------------
	constant C_SCOPE              : string := C_TB_SCOPE_DEFAULT;
	constant C_CLK_PERIOD         : time := 10 ns;
	signal clock_ena              : boolean := false;
	signal clk                    : std_logic := '0';
	signal hex_value              : std_logic_vector(3 downto 0) := (others=>'0');
	signal seven_seg              : seven_seg_t;

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
	clock_generator(clk, clock_ena, C_CLK_PERIOD, "Seven Seg TB clock");

	-------------------------------
	-- Testbench Main Control Process
	-------------------------------
	main: process
		--function seven_seg_encode(
	begin
		report_global_ctrl(VOID);
		report_msg_id_panel(VOID);

		enable_log_msg(ALL_MESSAGES);
		--disable_log_msg(ALL_MESSAGES);
		--enable_log_msg(ID_LOG_HDR);

		log(ID_LOG_HDR, "Start Simulation of TB for Seven Segment", C_SCOPE);

                clock_ena <= true;                  -- to start clock generator

		wait_num_rising_edge(clk, 4);

		for num in 0 to 15 loop
			report "num = " & to_string(num) & LF & 
			to_string(SEVEN_SEGMENT_ENCODINGS(num)) & LF;
		end loop;
		check_no_metavalue(pack_seven_seg(seven_seg));
		-- Assert that everything out of the encoder is always a valid seven-segment value
		-- Directed table-driven test
		-- Randomized test

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
		seven_seg     => seven_seg
	);
		
end tb;

