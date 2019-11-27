library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.game_constant.all;

entity freq_div_tb is

end freq_div_tb;

architecture structural of freq_div_tb is
component freq_div is
        port(
                clk: in std_logic;
                rst_n: in std_logic;
                en_out: out std_logic        
        );
end component freq_div;
	signal clk, rst_n, en_out: std_logic;
begin
	dut: freq_div port map (clk, rst_n, en_out);
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
		wait for 6 ns;
		rst_n<='1';
		wait;
	end process;

end structural;
