library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity bullet_generator is
	port(
			clock_bullet 									: in std_logic;
			RESET_bullet									: in std_logic;
			enable											: in std_logic;
			x_tank, y_tank 					         : in natural;
			
			x_bullet, y_bullet 					: out natural
		);
end entity bullet_generator;

architecture behavioral of bullet_generator is

constant step : natural := 10;
signal x_new, y_new : natural; --- default???????

begin

x_bullet <= x_new;
y_bullet <= y_new;

	process (RESET_bullet,clock_bullet) is
	begin
		if(RESET_bullet = '0')then 
			x_new <= x_tank;
			y_new <= y_tank;
			
		elsif((rising_edge(clock_bullet)) and (enable = '1'))then
			x_new <= x_new;
			y_new <= y_new + step;
			
		else 
			x_new <= x_new;
			y_new <= y_new;

		end if;
	end process;
end architecture behavioral;		