
LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

ENTITY colorDecoder IS
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		q		: OUT STD_LOGIC_VECTOR (23 downto 0)
	);
END colorDecoder;

architecture dataflow of colorDecoder is
--signal q_out : STD_LOGIC_VECTOR (23 downto 0);
begin

q <= "111111110000000000000000" when address = "000" else
	  "000000001111111100000000" when address = "001" else 
	  "000000000000000011111111" when address = "010" else
     "111111111111111100000000" when address = "011" else
     "111111110000000011111111" when address = "100" else
     "000000001111111111111111" when address = "101" else
     "000000000000000000000000" when address = "110" else
     "111111111111111111111111" when address = "111" else
     "000000000000000000000000";

end architecture dataflow;
