library ieee;

use ieee.std_logic_1164.all;

entity draw_a_tank_tb is

end draw_a_tank_tb;

architecture structural of draw_a_tank_tb is
	component draw_a_tank is
		port ( 
			clock_tank : in std_logic;
			reset_tank : in std_logic;
			x,y	: out natural
	);
	end component draw_a_tank;
	signal clk,rst: std_logic;
	signal x,y: natural;
begin
	dut: draw_a_tank port map (clk, rst, x, y);
	clk_proc: process 
	begin
		clk<='0';
		wait for 5 ns;
		clk<='1';
		wait for 5 ns;
	end process;

	tb_proc: process
	begin
		rst<='0';
		wait for 21 ns;
		rst<='1';
		wait;
	end process;
end structural;
