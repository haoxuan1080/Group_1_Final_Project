library ieee;
use ieee.std_logic_1164.all;

entity score_FSM_tb is

end score_FSM_tb;

architecture structural of score_FSM_tb is
component score_FSM is
	port(
			clock 										: in std_logic;
			RESET											: in std_logic;
--			ENABLE											: in std_logic;
			trigger 										: in std_logic;
			
			score    									: out std_logic_vector(1 downto 0)
	);
end component score_FSM;

signal clk, rst, trig: std_logic;
signal num: std_logic_vector(1 downto 0);

begin
	dut: score_FSM port map (clk, rst, trig, num);
	clk_proc: process 
	begin
		clk<='0';
		wait for 5 ns;
		clk<='1';
		wait for 5 ns;
	end process;



	rst_proc: process
	begin
		rst<='0';
		wait for 21 ns;
		rst<='1';
		wait;
	end process;


	speed_proc: process
	begin
		trig<='0';
		wait for 75 ns;
		trig<='1';
		wait for 10 ns;
		trig<='0';
		wait for 35 ns;
		trig<='1';
		wait for 10 ns;
		trig<='0';
		wait for 75 ns;
		trig<='1';
		wait for 10 ns;
		trig<='0';
		wait for 35 ns;
		trig<='1';
		wait for 10 ns;
		--wait;

	end process;
-- wait until? 
end structural;
