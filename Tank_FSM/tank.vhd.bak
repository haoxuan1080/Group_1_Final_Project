library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity tank is
	port(
			--clock 										: in std_logic;
			RESET											: in std_logic;
			ENABLE										: in std_logic;
			PAUSE    									: in std_logic;
			Speed_up			    							: in std_logic; -- must be less than 2 enable( speed up two levels)
			
			x					: out std_logic_vector(9 downto 0);
			y 					: out std_logic_vector(8 downto 0)
		);
end entity tank;


architecture behavioral of tank is

type state_type is (stop, low_speed, medium_speed, high_speed);
signal curr_state, next_state: state_type;

signal x_reg, x_new :unsigned(9 downto 0);
signal y_reg, y_new : unsigned(8 downto 0);    


begin 
x <= std_logic_vector(x_reg);
y <= std_logic_vector(y_reg);

clock: process(ENABLE,RESET) is
begin
		if(RESET = '0')then
			curr_state <= low_speed; -- start with low speed
			x_reg <= to_unsigned(20,x_reg'length); 
			y_reg <= to_unsigned(40,y_reg'length); 
		elsif(ENABLE = '1')then
			curr_state <= next_state;
			x_reg <= x_new;
			y_reg <= y_new;			
		end if;
end process;
	
combinational : process(Speed_up,PAUSE, curr_state, x_reg, y_reg) is
begin

	next_state <= stop;
	x_new <= x_reg;
	y_new <= y_reg ;
	
		
	case curr_state is
		when low_speed =>
			x_new <= x_reg + "1";
			y_new <= y_reg;
			if(PAUSE = '1')then
				next_state <= stop;
			elsif(Speed_up = '1')then
				next_state <= medium_speed;
			else
				next_state <= low_speed;
			end if;
		
		
		when medium_speed =>
			x_new <= x_reg + "10";
			y_new <= y_reg;
			if(PAUSE = '1')then
				next_state <= stop;
			elsif(Speed_up = '1')then
				next_state <= high_speed;
			else
				next_state <= medium_speed;
			end if;		
		
		when high_speed =>
			x_new <= x_reg + "100";
			y_new <= y_reg ;
			if(PAUSE = '1')then
				next_state <= stop;
			elsif(Speed_up = '1')then
				next_state <= low_speed;
			else
				next_state <= high_speed;
			end if;		

		when stop =>
			x_new <= x_reg ;
			y_new <= y_reg ;
			next_state <= stop;		
		
		when others =>
			x_new <= x_reg ;
			y_new <= y_reg ;
			next_state <= stop;	
	end case;
	
end process;	
	
end architecture behavioral;		
