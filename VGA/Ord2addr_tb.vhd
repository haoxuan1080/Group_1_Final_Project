library IEEE;

use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity Ord2addr_tb is

end Ord2addr_tb;

architecture test of Ord2addr_tb is
function Ord2addr (row: std_logic_vector; col: std_logic_vector) return std_logic_vector is
	variable addr: std_logic_vector (19 downto 0);
	variable addr_u: unsigned (19 downto 0);
begin
	addr_u:=unsigned(row)*640+unsigned(col);
	addr:=std_logic_vector(addr_u);
	return addr(18 downto 0);
end function Ord2addr;
	signal row, col: std_logic_vector (9 downto 0);
	signal addr: std_logic_vector (18 downto 0);
begin
	addr<=Ord2addr(row, col);
	tb_proc: process
	begin
		row<=std_logic_vector(to_unsigned(10, 10));
		col<=std_logic_vector(to_unsigned(5, 10));
		wait;
	end process;
end test;
