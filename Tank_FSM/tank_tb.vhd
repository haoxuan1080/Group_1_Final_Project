library ieee;

use ieee.std_logic_1164.all;

entity tank_tb is

end tank_tb;

architecture structural of tank_tb is
component tank is
	port(
			--clock 										: in std_logic;
			RESET											: in std_logic;
			ENABLE										: in std_logic;
			PAUSE    									: in std_logic;
			Speed_up			    							: in std_logic;
			
			x					: out std_logic_vector(9 downto 0);
			y 					: out std_logic_vector(8 downto 0)
		);
end component tank;

signal rst, en, stop, speed: std_logic;
signal x_wave : std_logic_vector(9 downto 0);
signal y_wave : std_logic_vector(8 downto 0);    

begin
	dut: tank port map (rst, en, stop, speed, x_wave, y_wave);

	en_proc: process 
	begin
		en<='0';
		wait for 50 ns;
		en<='1';
		wait for 5 ns;
	end process;

	rst_proc: process
	begin
		rst<='0';
		wait for 21 ns;
		rst<='1';
		wait;
	end process;

	pause_proc: process
	begin
		stop<='0';
		wait for 1000 ns;
		stop<='1';
		wait;
	end process;

	speed_proc: process
	begin
		speed<='0';
		wait for 150 ns;
		speed<='1';
		wait for 20 ns;
		speed<='0';
		wait for 200 ns;
		speed<='1';
		wait for 20 ns;
		speed<='0';
		wait for 250 ns;
		speed<='1';
		wait for 20 ns;
		speed<='0';
		wait;
	end process;

end structural;
