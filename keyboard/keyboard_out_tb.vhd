library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity keyboard_out_tb is

end keyboard_out_tb;

architecture structural of keyboard_out_tb is
	component keyboard_out is

	port(
		--keyboard_clk, keyboard_data, 
		clock_50MHz, reset : in std_logic;
		--, read : in std_logic;
		scan_code: in std_logic_vector (7 downto 0);
		scan2: in std_logic;
		--ready :out std_logic;
		speed_up1_out, speed_up2_out, shoot_1_out, shoot_2_out : out std_logic

	);
	end component keyboard_out;
	signal clk, rst_n, scan2, sp1, sp2, sh1, sh2: std_logic;
	signal scan_code: std_logic_vector (7 downto 0);
begin
	dut: keyboard_out port map (clk, rst_n, scan_code, scan2, sp1, sp2, sh1, sh2);
	clk_proc: process
	begin
		clk<='1';
		wait for 5 ns;
		clk<='0';
		wait for 5 ns;
	end process;

	tb_proc: process
	begin
		rst_n<='0';
		scan_code<=x"00";
		scan2 <= '0';
		wait for 6 ns;
		rst_n<='1';
		wait for 20 ns;
		wait until rising_edge(clk);
		scan_code<=x"F0";
		scan2<='1';
		wait for 20 ns;
		scan2<='0';
		wait for 26 ns;
		--wait until rising_edge(clk);
		scan_code<=x"42";
		wait until rising_edge(clk);
		scan2<='1';
		wait for 20 ns;
		scan2<='0';
		wait;
	end process;
end structural;
