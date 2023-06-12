library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

library STD;
use std.env.all;

library uvvm_util;
context uvvm_util.uvvm_util_context;

-------------------------------
-- Seven-Segment Encoder Package
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

package seven_segment_pkg is

	type seven_seg_t is record
		A : std_logic;
		B : std_logic;
		C : std_logic;
		D : std_logic;
		E : std_logic;
		F : std_logic;
		G : std_logic;
	end record;

	-------------------------------
	-- DUT Component
	-------------------------------
	component seven_segment is
		port (
			clk           : in  std_logic;
			hex_value     : in  std_logic_vector(3 downto 0);
			seven_seg     : out seven_seg_t
		);
	end component;

	type seven_seg_vector is array (natural range <>) of seven_seg_t;

	constant SEVEN_SEGMENT_ENCODINGS : seven_seg_vector(0 to 15) := (
		('1', '1', '1', '1', '1', '1', '0'), -- 0
		('0', '1', '1', '0', '0', '0', '0'), -- 1
		('1', '1', '0', '1', '1', '0', '1'), -- 2
		('1', '1', '1', '1', '0', '0', '1'), -- 3
		('0', '1', '1', '0', '0', '1', '1'), -- 4
		('1', '0', '1', '1', '0', '1', '1'), -- 5
		('1', '0', '1', '1', '1', '1', '1'), -- 6
		('1', '1', '1', '0', '0', '0', '0'), -- 7
		('1', '1', '1', '1', '1', '1', '1'), -- 8
		('1', '1', '1', '0', '0', '1', '1'), -- 9
		('1', '1', '1', '0', '1', '1', '1'), -- A
		('0', '0', '1', '1', '1', '1', '1'), -- b
		('1', '0', '0', '1', '1', '1', '0'), -- C
		('0', '1', '1', '1', '1', '0', '1'), -- d
		('1', '0', '0', '1', '1', '1', '1'), -- E
		('1', '0', '0', '0', '1', '1', '1')  -- F
	);

	function pack_seven_seg(seven_seg : seven_seg_t)
	return std_logic_vector;

	function to_string(val: seven_seg_t)
	return string;

end package;

package body seven_segment_pkg is

	function pack_seven_seg(seven_seg : seven_seg_t)
	return std_logic_vector is
		variable slv : std_logic_vector(6 downto 0) := (others=>'0');
	begin
		slv(0) := seven_seg.A;
		slv(1) := seven_seg.B;
		slv(2) := seven_seg.C;
		slv(3) := seven_seg.D;
		slv(4) := seven_seg.E;
		slv(5) := seven_seg.F;
		slv(6) := seven_seg.G;
		return slv;
	end function;

	function to_string(val: seven_seg_t)
	return string is
		-- TODO: Hmm... string-builder code...
		-- +A+
		-- F B
		-- +G+
		-- E C
		-- +D+
		constant chars_per_line : natural := 4;
		variable char_str : string(1 to 6*chars_per_line) := (others => ' ');
	begin

		-- TODO: Check metavalues?
		if val.A = '1' then
			char_str(1 to 3) := "===";
		else
			char_str(1 to 3) := "   ";
		end if;
		if val.G = '1' then
			char_str(2*chars_per_line+1 to 2*chars_per_line+3) := "===";
		else
			char_str(2*chars_per_line+1 to 2*chars_per_line+3) := "   ";
		end if;
		if val.D = '1' then
			char_str(4*chars_per_line+1 to 4*chars_per_line+3) := "===";
		else
			char_str(4*chars_per_line+1 to 4*chars_per_line+3) := "   ";
		end if;
		if val.B = '1' then
			char_str(chars_per_line+3) := '|';
		end if;
		if val.C = '1' then
			char_str(3*chars_per_line+3) := '|';
		end if;
		if val.F = '1' then
			char_str(chars_per_line+1) := '|';
		end if;
		if val.E = '1' then
			char_str(3*chars_per_line+1) := '|';
		end if;
		for lineno in 0 to 5 loop
			char_str(lineno*chars_per_line+4) := LF;
		end loop;
		return to_string(char_str);
	end function;

end package body seven_segment_pkg;
