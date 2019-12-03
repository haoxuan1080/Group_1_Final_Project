library ieee;

use ieee.std_logic_1164.all;

entity Win_Dec_tb is

end Win_Dec_tb;

architecture structure of Win_Dec_tb is
	component WinDec is
		port (
		clk, rst_n: in std_logic;
                P1Score, P2Score: in std_logic_vector (1 downto 0);
                pause_out: out std_logic;
                game_state_out: out std_logic_vector (1 downto 0)
     
		);
	end component WinDec;
	signal clk, rst_n: std_logic;
	signal P1Score, P2Score: std_logic_vector (1 downto 0);
	signal pause_out: std_logic;
	signal game_state_out: std_logic_vector (1 downto 0);
begin
	dut: WinDec port map (clk, rst_n, P1Score, P2Score, pause_out, game_state_out);

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
		P1Score<="00";
		P2Score<="00";
		wait for 6 ns;
		rst_n<='1';
		wait for 10 ns;
		P1Score<="11";
		wait for 10 ns;
		P1Score<="00";
		rst_n<='0';
		wait for 6 ns;
		rst_n<='1';
		wait for 10 ns;
		P2Score<="11";
		wait for 10 ns;
		wait;
		
	end process;
end structure;
