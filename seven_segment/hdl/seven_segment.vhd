library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

library STD;
use std.env.all;

library uvvm_util;
context uvvm_util.uvvm_util_context;

library work;
use work.seven_segment_pkg.all;

-------------------------------
-- Seven-Segment Encoder
--
-- A very simple IP / chip to test in UVVM.
-- A 4-bit hexadecimal value is input,
-- and the 7 bits which controls the seven-segment display
-- is output. The output bits are labelled A to G as
-- I have seen it from other examples.
-- The A-G physical layout of the display is shown
-- in this basic diagram below.
--
-- +A+
-- F B
-- +G+
-- E C
-- +D+
--
-- Inspired by a 74-hundred series seven segment decoder,
-- such as 74LS247,
-- but the difference here from 74-hundred classics is
-- that this IP supports hexidecimal values.
-------------------------------

entity seven_segment is
	port (
		clk           : in  std_logic;
		hex_value     : in  std_logic_vector(3 downto 0);
		seven_seg     : out seven_seg_t
	);
end entity seven_segment;

architecture rtl of seven_segment is
begin
end rtl;

