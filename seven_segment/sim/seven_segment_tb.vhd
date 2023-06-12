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
	constant C_RANDOM_ATTEMPTS    : natural := 1000;
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
		variable int_val : integer := 0;
	begin
		report_global_ctrl(VOID);
		report_msg_id_panel(VOID);
		set_alert_stop_limit(TB_ERROR, 0);

		enable_log_msg(ALL_MESSAGES);
		--disable_log_msg(ALL_MESSAGES);
		--enable_log_msg(ID_LOG_HDR);

		log(ID_LOG_HDR, "Start Simulation of TB for Seven Segment", C_SCOPE);

                clock_ena <= true;                  -- to start clock generator

		wait_num_rising_edge(clk, 4);


		-- TODO: Assert that everything out of the encoder is always a valid seven-segment value
		-- Directed test
		for i in 0 to 15 loop
			hex_value <= std_logic_vector(to_unsigned(i, 4));
			wait_num_rising_edge(clk, 1);
			check_no_metavalue(pack_seven_seg(seven_seg));
			check_value(
				pack_seven_seg(seven_seg),
				pack_seven_seg(SEVEN_SEGMENT_ENCODINGS(i)),
				TB_ERROR,
				"Check directed seven segment case " & to_string(i)
			);
			report "num = " & to_string(i) & LF &
				-- to_string(SEVEN_SEGMENT_ENCODINGS(i)) & LF;
				to_string(seven_seg);
		end loop;

		-- Randomized test
		for i in 0 to C_RANDOM_ATTEMPTS-1 loop
			hex_value <= random(hex_value'length);
			int_val := to_integer(unsigned(hex_value));
			wait_num_rising_edge(clk, 1);
			-- assert value in range
			check_value_in_range(int_val, 0, 15,
				"Check random value is in spec. case: " & 
				to_string(i) & " value: " & to_string(int_val) & 
				" / " & to_string(hex_value)
			);
			int_val := to_integer(unsigned(hex_value));
			check_value(
				pack_seven_seg(seven_seg),
				pack_seven_seg(SEVEN_SEGMENT_ENCODINGS(int_val)),
				TB_ERROR,
				"Check randomized seven segment case " & to_string(i)
				& " input: " & to_string(hex_value)
				& " input int: " & to_string(int_val)
				& " output: " & to_string(pack_seven_seg(seven_seg))
			);
			report "num = " & to_string(int_val) & LF &
				to_string(seven_seg);
		end loop;

		-- Report final counters and print conclusion for simulation (Success/Fail)
		report_alert_counters(FINAL);
		log(ID_LOG_HDR, "SIMULATION COMPLETED", C_SCOPE);

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

