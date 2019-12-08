library ieee;

use ieee.std_logic_1164.all;

entity tank_tb is

end tank_tb;

architecture structural of tank_tb is
component tank is
	port(
			clock 										: in std_logic;
			RESET										: in std_logic;
			ENABLE										: in std_logic;
			PAUSE    									: in std_logic;
			Speed_up			    							: in std_logic;
			
			x					: out std_logic_vector(9 downto 0);
			y 					: out std_logic_vector(9 downto 0)
		);
end component tank;

signal clk, rst, en, stop, speed: std_logic;
signal x_wave : std_logic_vector(9 downto 0);
signal y_wave : std_logic_vector(9 downto 0);    

begin
	dut: tank port map ( clk, rst, en, stop, speed, x_wave, y_wave);

	clk_proc: process 
	begin
		clk<='1';
		wait for 5 ns;
		clk<='0';
		wait for 5 ns;
	end process;


	en_proc: process 
	begin
		en<='0';
		wait for 100 ns;
		en<='1';
		wait for 10 ns;
	end process;

	rst_proc: process
	begin
		rst<='0';
		wait for 18 ns;
		rst<='1';
		wait;
	end process;

	pause_proc: process
	begin
		stop<='0';
		wait for 16000 ns;
		stop<='1';
		wait;
	end process;

	speed_proc: process
	begin
		speed<='0';
		wait for 210 ns;
		speed<='1';
		wait for 10 ns;
		speed<='0';
		wait for 110 ns;
		speed<='1';
		wait for 10 ns;
		speed<='0';
		wait for 200 ns;
		speed<='1';
		wait for 10 ns;
		speed<='0';
		wait for 700 ns;
		speed<='1';
		wait for 10 ns;
		speed<='0';
		wait;


	end process;
-- wait until? 
end structural;
