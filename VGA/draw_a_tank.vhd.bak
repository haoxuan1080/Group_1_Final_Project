library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity draw_a_tank is
	port(
			clock_tank 										: in std_logic;
			RESET_tank											: in std_logic;
	 
			x, y 					: out natural

		);
end entity draw_a_tank;


architecture behavioral of draw_a_tank is
signal x_new, y_new : natural;
begin 

x <= x_new;
y <= y_new;

	position: process(clock_tank) is
	variable counter1 : natural;
	begin
		counter1 := 0;

		if(RESET_tank = '0')then
			counter1 := 0;
			x_new <= 60;
			y_new <= 120;
		elsif(rising_edge(clock_tank))then
			if(counter1 < 1E6)then 
				counter1 := counter1+1;
				x_new <= x_new;
				y_new <= y_new;
			elsif (x_new < 630) then
				counter1 := 0;
				x_new <= x_new + 10;
				y_new <= y_new;
			else 
				counter1 := 0;
				x_new <= x_new;
				y_new <= y_new;
			end if;
		end if;
	end process;
	
end architecture behavioral;		