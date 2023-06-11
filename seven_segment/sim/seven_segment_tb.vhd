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
begin

	main: process
	begin
		report "Hello world from the testbench!";
    		std.env.stop;
	end process;
end tb;

