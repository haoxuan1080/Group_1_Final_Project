library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity tank is
	port(
			clock 										: in std_logic;
			RESET											: in std_logic;
			ENABLE										: in std_logic;
			PAUSE    									: in std_logic;
			SPEED			    							: in std_logic;
			
			x					: out std_logic_vector(8 downto 0);
			y 					: out std_logic_vector(7 downto 0)

		);
end entity tank;


architecture behavioral of tank is

type state_type is (stop, low_speed, medium_speed,high_speed);
signal curr_state, next_state: state_type;

signal x_reg, x_new :std_logic_vector(8 downto 0);
signal y_reg, y_new : std_logic_vector(7 downto 0);    


begin 
x <= x_reg;
y <= y_reg;

position: process(clock) is
	begin
		
		if(RESET = '0')then
			curr_state <= stop;
			x_reg <= 60;
			y_reg <= 120;
		elsif(rising_edge(clock))then
			curr_state <= next_state;
			x_reg <= x_new;
			y_reg <= y_new;			
		end if;
	end process;
	
	
	
	
	
end architecture behavioral;		
