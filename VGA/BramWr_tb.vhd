library IEEE;

use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use work.game_constant.all;

entity BramWr_tb is

end BramWr_tb;

architecture tb of BramWr_tb is 
	component BramWr is
	port (
		clk, rst_n: in std_logic;
		row: out std_logic_vector(9 downto 0);
   		col: out std_logic_vector(9 downto 0);
		we: out std_logic	
	);
	end component BramWr;
	signal clk, rst_n, en: std_logic;
	signal row, col: std_logic_vector(9 downto 0);
begin
	dut: BramWr port map (clk, rst_n, row, col, en);
	clk_proc: process 
	begin
		clk<='1';
		wait for 5 ns;
		clk<='0';
		wait for 5 ns;
	end process;

	rst_proc: process
	begin
		rst_n<='0';
		wait for 6 ns;
		rst_n<='1';
		wait;
	end process;

	tb_proc: process
	begin
		wait until col=std_logic_vector(to_unsigned(639, 10)) and rising_edge(clk);
		wait for 1 ns;
		report "the row after col= 639 is: "& integer'image(to_integer(unsigned(row)));
	end process;

	rep_row: process
	begin
		wait until row=std_logic_vector(to_unsigned(479, 10)) and rising_edge(clk);
		report "the row after row= 479 is: "& integer'image(to_integer(unsigned(row)));

	end process;
end tb;
