library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity bram_2p_tb is

end bram_2p_tb;

architecture strctural of bram_2p_tb is
	component bram_2p is
        port(
                r_addr: in std_logic_vector (18 downto 0);
                w_addr: in std_logic_vector (18 downto 0);
                clk: in std_logic;
                we: in std_logic;
                d: in std_logic_vector (2 downto 0);
                q: out std_logic_vector (2 downto 0)
        );
	end component bram_2p;
	signal raddr, waddr: std_logic_vector (18 downto 0);
	signal clk, we: std_logic;
	signal d, q: std_logic_vector (2 downto 0);
begin	
	dut: bram_2p port map (raddr, waddr, clk, we, d , q);
	clk_proc: process
	begin
		clk<='1';
		wait for 5 ns;
		clk<='0';
		wait for 5 ns;
	end process;

	tb_proc: process
	begin
		we<='0';
		d<="101";
		waddr<=std_logic_vector(to_unsigned(0, 19));
		raddr<=std_logic_vector(to_unsigned(0, 19));
		wait until rising_edge(clk);
		we<='1';
		wait until rising_edge(clk);
		waddr<=std_logic_vector(to_unsigned(1, 19));
		d<="001";
	        wait until rising_edge(clk);
		waddr<=std_logic_vector(to_unsigned(2, 19));
		d<="010";
		raddr<=std_logic_vector(to_unsigned(1, 19));
		wait until rising_edge(clk);
                waddr<=std_logic_vector(to_unsigned(3, 19));
                d<="011";
                --raddr<=std_logic_vector(to_unsigned(1, 19));
		wait until rising_edge(clk);
                waddr<=std_logic_vector(to_unsigned(4, 19));
                d<="100";
                raddr<=std_logic_vector(to_unsigned(2, 19));
		wait;
	end process;
end strctural;
