library IEEE;
use work.game_constant.all;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity tank is
	port(
			clock 										: in std_logic;
			RESET											: in std_logic;
			ENABLE										: in std_logic;
			PAUSE    									: in std_logic;
			Speed_up			    							: in std_logic; -- must be less than 2 enable( speed up two levels)
			
			x					: out std_logic_vector(9 downto 0);
			y 					: out std_logic_vector(9 downto 0)
		);

end entity tank;


architecture behavioral of tank is

type state_type is (stop, low_speed_left, medium_speed_left, high_speed_left, low_speed_right, medium_speed_right, high_speed_right);
signal curr_state, next_state: state_type;

signal x_reg, x_new :unsigned(9 downto 0);
signal y_reg, y_new : unsigned(9 downto 0);  

constant speed1: unsigned := "1";	
constant speed2: unsigned := "10";
constant speed3: unsigned := "100";	  

begin 
x <= std_logic_vector(x_reg);
y <= std_logic_vector(y_reg);

sequential: process(RESET, clock) is
begin
		if((RESET = '0')) then
			curr_state <= low_speed_right;
			x_reg <= to_unsigned(Tank_Width/2 ,x_reg'length); 
			y_reg <= to_unsigned(Tank_Hight/2 ,y_reg'length); 
			
		elsif(rising_edge(clock))then
--		elsif(rising_edge(ENABLE))then
			if(ENABLE = '1')then
			curr_state <= next_state;
			x_reg <= x_new;
			y_reg <= y_new;			
			end if;
		end if;
end process;
	
combinational : process(Speed_up,PAUSE, curr_state, x_reg, y_reg) is
begin
	next_state <= stop;
	x_new <= x_reg;
	y_new <= y_reg ;
	

	case curr_state is	
		
		when low_speed_right =>
				x_new <= x_reg + speed1;
				y_new <= y_reg;
				
			if(PAUSE = '1')then
				next_state <= stop;
			elsif ((Speed_up = '1') and (x_reg + speed1 < to_unsigned(Screen_Width-Tank_Width/2, x_reg'length))) then
				next_state <= medium_speed_right;
			elsif ((Speed_up = '1') and (x_reg + speed1 >= to_unsigned(Screen_Width-Tank_Width/2, x_reg'length))) then
				next_state <= medium_speed_left;
			elsif ((Speed_up = '0') and (x_reg + speed1 < to_unsigned(Screen_Width-Tank_Width/2, x_reg'length))) then
				next_state <= low_speed_right;
			elsif ((Speed_up = '0') and (x_reg + speed1 >= to_unsigned(Screen_Width-Tank_Width/2, x_reg'length))) then
				next_state <= low_speed_left;
			end if;
			
			
		when low_speed_left =>
				x_new <= x_reg - speed1;
				y_new <= y_reg;
				
			if(PAUSE = '1')then
				next_state <= stop;
			elsif ((Speed_up = '1') and (x_reg - speed1 > to_unsigned(Tank_Width/2, x_reg'length))) then
				next_state <= medium_speed_left;
			elsif ((Speed_up = '1') and (x_reg - speed1 <= to_unsigned(Tank_Width/2, x_reg'length))) then
				next_state <= medium_speed_right;
			elsif ((Speed_up = '0') and (x_reg - speed1 > to_unsigned(Tank_Width/2, x_reg'length))) then
				next_state <= low_speed_left;
			elsif ((Speed_up = '0') and (x_reg - speed1 <= to_unsigned(Tank_Width/2, x_reg'length))) then
				next_state <= low_speed_right;
			end if;
			
			
		when medium_speed_right =>
				x_new <= x_reg + speed2;
				y_new <= y_reg;
				
			if(PAUSE = '1')then
				next_state <= stop;
			elsif ((Speed_up = '1') and (x_reg + speed2 < to_unsigned(Screen_Width-Tank_Width/2, x_reg'length))) then
				next_state <= high_speed_right;
			elsif ((Speed_up = '1') and (x_reg + speed2 >= to_unsigned(Screen_Width-Tank_Width/2, x_reg'length))) then
				next_state <= high_speed_left;
			elsif ((Speed_up = '0') and (x_reg + speed2 < to_unsigned(Screen_Width-Tank_Width/2, x_reg'length))) then
				next_state <= medium_speed_right;
			elsif ((Speed_up = '0') and (x_reg + speed2 >= to_unsigned(Screen_Width-Tank_Width/2, x_reg'length))) then
				next_state <= medium_speed_left;
			end if;

			
		when medium_speed_left =>
				x_new <= x_reg - speed2;
				y_new <= y_reg;
				
			if(PAUSE = '1')then
				next_state <= stop;
			elsif ((Speed_up = '1') and (x_reg - speed2 > to_unsigned(Tank_Width/2, x_reg'length))) then
				next_state <= high_speed_left;
			elsif ((Speed_up = '1') and (x_reg - speed2 <= to_unsigned(Tank_Width/2, x_reg'length))) then
				next_state <= high_speed_right;
			elsif ((Speed_up = '0') and (x_reg - speed2 > to_unsigned(Tank_Width/2, x_reg'length))) then
				next_state <= medium_speed_left;
			elsif ((Speed_up = '0') and (x_reg - speed2 <= to_unsigned(Tank_Width/2, x_reg'length))) then
				next_state <= medium_speed_right;
			end if;	
		
		
		
		when high_speed_right =>
				x_new <= x_reg + speed3;
				y_new <= y_reg;
				
			if(PAUSE = '1')then
				next_state <= stop;
			elsif ((Speed_up = '1') and (x_reg + speed3 < to_unsigned(Screen_Width-Tank_Width/2, x_reg'length))) then
				next_state <= low_speed_right;
			elsif ((Speed_up = '1') and (x_reg + speed3 >= to_unsigned(Screen_Width-Tank_Width/2, x_reg'length))) then
				next_state <= low_speed_left;
			elsif ((Speed_up = '0') and (x_reg + speed3 < to_unsigned(Screen_Width-Tank_Width/2, x_reg'length))) then
				next_state <= high_speed_right;
			elsif ((Speed_up = '0') and (x_reg + speed3 >= to_unsigned(Screen_Width-Tank_Width/2, x_reg'length))) then
				next_state <= high_speed_left;
			end if;
			
			
		when high_speed_left =>
				x_new <= x_reg - speed3;
				y_new <= y_reg;
				
			if(PAUSE = '1')then
				next_state <= stop;
			elsif ((Speed_up = '1') and (x_reg - speed3 > to_unsigned(Tank_Width/2, x_reg'length))) then
				next_state <= low_speed_left;
			elsif ((Speed_up = '1') and (x_reg - speed3 <= to_unsigned(Tank_Width/2, x_reg'length))) then
				next_state <= low_speed_right;
			elsif ((Speed_up = '0') and (x_reg - speed3 > to_unsigned(Tank_Width/2, x_reg'length))) then
				next_state <= high_speed_left;
			elsif ((Speed_up = '0') and (x_reg - speed3 <= to_unsigned(Tank_Width/2, x_reg'length))) then
				next_state <= high_speed_right;
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
