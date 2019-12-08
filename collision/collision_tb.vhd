library IEEE;
use work.Game_constant.all;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity collision_tb is

end entity;


architecture structural of collision_tb is

component collision is
	port(
			clock	 									: in std_logic;
--			enable										: in std_logic;
			RESET_sys									: in std_logic;
			x_tank, y_tank 					      : in std_logic_vector(9 downto 0);
			x_bullet, y_bullet 					   : in std_logic_vector(9 downto 0);
			
			trigger										: out  std_logic
		);
end component collision;

signal clk, rst, trig : std_logic;
signal x_t, y_t, x_b, y_b : std_logic_vector(9 downto 0);

begin

uut: collision port map(clk, rst, x_t, y_t, x_b, y_b, trig);

	clk_proc: process 
	begin
		clk<='1';
		wait for 5 ns;
		clk<='0';
		wait for 5 ns;
	end process;

	rst_proc: process
	begin
		rst<='0';
		wait for 21 ns;
		rst<='1';
		wait;
	end process;


	posi_proc: process
	begin 
		x_b <= std_logic_vector(to_unsigned(15 ,10)); 
		y_b <= std_logic_vector(to_unsigned(10 ,10)); 
		x_t <= std_logic_vector(to_unsigned(625 ,10)); 
		y_t <= std_logic_vector(to_unsigned(470 ,10)); 
		wait for 20 ns;

		x_b <= std_logic_vector(to_unsigned(50 ,10)); 
		y_b <= std_logic_vector(to_unsigned(400 ,10)); 
		x_t <= std_logic_vector(to_unsigned(540 ,10)); 
		y_t <= std_logic_vector(to_unsigned(400 ,10)); 
		wait for 20 ns;

		
		x_b <= std_logic_vector(to_unsigned(140 ,10)); 
		y_b <= std_logic_vector(to_unsigned(300 ,10)); 
		x_t <= std_logic_vector(to_unsigned(150 ,10)); 
		y_t <= std_logic_vector(to_unsigned(300 ,10)); 
		wait for 20 ns;

		x_b <= std_logic_vector(to_unsigned(300 ,10)); 
		y_b <= std_logic_vector(to_unsigned(10 ,10)); 
		x_t <= std_logic_vector(to_unsigned(450 ,10)); 
		y_t <= std_logic_vector(to_unsigned(50 ,10)); 
		wait for 20 ns;
	end process;

end architecture structural;

