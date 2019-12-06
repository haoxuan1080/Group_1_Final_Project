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

-- type state_type is (stop, low_speed_left, medium_speed_left, high_speed_left, low_speed_right, medium_speed_right, high_speed_right);
-- signal curr_state, next_state: state_type;

type state_type is (idle, move1, move2, move3);
signal curr_state, next_state: state_type;


signal x_reg, x_new :unsigned(9 downto 0);
signal y_reg, y_new : unsigned(9 downto 0);  
signal dir, dir_new: std_logic_vector(9 downto 0);  

constant speed1: integer := 1;	
constant speed2: integer := 4;
constant speed3: integer := 16;	  

begin 
x <= std_logic_vector(x_reg);
y <= std_logic_vector(y_reg);

sequential: process(RESET, clock) is
begin
		if((RESET = '0')) then
			curr_state <= idle;
			x_reg <= (others=>'0');  -- to_unsigned(Tank_Width/2 ,x_reg'length); 
			y_reg <= (others=>'0');  -- to_unsigned(Tank_Hight/2 ,y_reg'length); 
			dir <= (others=>'0');
			
		elsif(rising_edge(clock))then
--			if(ENABLE = '1')then
			curr_state <= next_state;
			x_reg <= x_new;
			y_reg <= y_new;
			dir <= dir_new;
--			end if;
		end if;
end process;
	
combinational : process(Speed_up,PAUSE, curr_state, x_reg, y_reg, enable, dir) is
	constant pos_dir : std_logic_vector(9 downto 0) := std_logic_vector(to_signed(1,10));
	constant neg_dir : std_logic_vector(9 downto 0) := std_logic_vector(to_signed(-1,10));
begin
	next_state <= idle;
	x_new <= x_reg;
	y_new <= y_reg;
	dir_new <= pos_dir;
	
	case curr_state is	
	
		when idle =>
		x_new <= to_unsigned(Tank_Width/2 ,x_reg'length);
		y_new <= to_unsigned(Tank_Width/2 ,x_reg'length);		dir_new <= pos_dir;
		if(enable = '1' and pause = '0')then
			next_state <= move1;
		end if;
			
		when move1 =>
		if(enable = '1' and pause = '0')then
			x_new <= x_reg + (to_integer(signed(dir)) * speed1);
			if ( (x_reg >= (Screen_Width-Tank_Width/2)) and (dir = pos_dir) ) then
				dir_new <= neg_dir;
			elsif ( (x_reg <= Tank_Width/2) and (dir = neg_dir) ) then
				dir_new <= pos_dir;
			end if;
		end if;
		
			if(Speed_up = '1')then
				next_state <= move2;
			else
				next_state <= move1;
			end if;			

		
		
		when move2 =>
		if(enable = '1' and pause = '0')then
			x_new <= x_reg + (to_integer(signed(dir)) * speed2);
			if ( (x_reg >= (Screen_Width-Tank_Width/2)) and (dir = pos_dir) ) then
				dir_new <= neg_dir;
			elsif ( x_reg <= Tank_Width/2 and dir = neg_dir ) then
				dir_new <= pos_dir;
			end if;
		end if;	
		
			if(Speed_up = '1')then
				next_state <= move3;
			else
				next_state <= move2;
			end if;
		
		
		when move3 =>
		if(enable = '1' and pause = '0')then
			x_new <= x_reg + (to_integer(signed(dir)) * speed2);
			if ( (x_reg >= (Screen_Width-Tank_Width/2)) and (dir = pos_dir) ) then
				dir_new <= neg_dir;
			elsif ( x_reg <= Tank_Width/2 and dir = neg_dir ) then
				dir_new <= pos_dir;
			end if;
		end if;
		
			if(Speed_up = '1')then
				next_state <= move1;
			else
				next_state <= move3;
			end if;
		
		
		when others=>
			next_state <= idle;
			x_new <= x_reg;
			y_new <= y_reg;
			dir_new <= (others=>'0');
	end case;
	
end process;
end architecture;

----------------------------------------------	
		
--			when low_speed_right =>
--					x_new <= x_reg + speed1;
--					y_new <= y_reg;
--					
--				if(PAUSE = '1')then
--					next_state <= stop;
--				elsif ((Speed_up = '1') and (x_reg + speed1 < to_unsigned(Screen_Width-Tank_Width/2, x_reg'length))) then
--					next_state <= medium_speed_right;
--				elsif ((Speed_up = '1') and (x_reg + speed1 >= to_unsigned(Screen_Width-Tank_Width/2, x_reg'length))) then
--					next_state <= medium_speed_left;
--				elsif ((Speed_up = '0') and (x_reg + speed1 < to_unsigned(Screen_Width-Tank_Width/2, x_reg'length))) then
--					next_state <= low_speed_right;
--				elsif ((Speed_up = '0') and (x_reg + speed1 >= to_unsigned(Screen_Width-Tank_Width/2, x_reg'length))) then
--					next_state <= low_speed_left;
--				end if;
--				
--				
--			when low_speed_left =>
--					x_new <= x_reg - speed1;
--					y_new <= y_reg;
--					
--				if(PAUSE = '1')then
--					next_state <= stop;
--				elsif ((Speed_up = '1') and (x_reg - speed1 > to_unsigned(Tank_Width/2, x_reg'length))) then
--					next_state <= medium_speed_left;
--				elsif ((Speed_up = '1') and (x_reg - speed1 <= to_unsigned(Tank_Width/2, x_reg'length))) then
--					next_state <= medium_speed_right;
--				elsif ((Speed_up = '0') and (x_reg - speed1 > to_unsigned(Tank_Width/2, x_reg'length))) then
--					next_state <= low_speed_left;
--				elsif ((Speed_up = '0') and (x_reg - speed1 <= to_unsigned(Tank_Width/2, x_reg'length))) then
--					next_state <= low_speed_right;
--				end if;
--				
--				
--			when medium_speed_right =>
--					x_new <= x_reg + speed2;
--					y_new <= y_reg;
--					
--				if(PAUSE = '1')then
--					next_state <= stop;
--				elsif ((Speed_up = '1') and (x_reg + speed2 < to_unsigned(Screen_Width-Tank_Width/2, x_reg'length))) then
--					next_state <= high_speed_right;
--				elsif ((Speed_up = '1') and (x_reg + speed2 >= to_unsigned(Screen_Width-Tank_Width/2, x_reg'length))) then
--					next_state <= high_speed_left;
--				elsif ((Speed_up = '0') and (x_reg + speed2 < to_unsigned(Screen_Width-Tank_Width/2, x_reg'length))) then
--					next_state <= medium_speed_right;
--				elsif ((Speed_up = '0') and (x_reg + speed2 >= to_unsigned(Screen_Width-Tank_Width/2, x_reg'length))) then
--					next_state <= medium_speed_left;
--				end if;
--	
--				
--			when medium_speed_left =>
--					x_new <= x_reg - speed2;
--					y_new <= y_reg;
--					
--				if(PAUSE = '1')then
--					next_state <= stop;
--				elsif ((Speed_up = '1') and (x_reg - speed2 > to_unsigned(Tank_Width/2, x_reg'length))) then
--					next_state <= high_speed_left;
--				elsif ((Speed_up = '1') and (x_reg - speed2 <= to_unsigned(Tank_Width/2, x_reg'length))) then
--					next_state <= high_speed_right;
--				elsif ((Speed_up = '0') and (x_reg - speed2 > to_unsigned(Tank_Width/2, x_reg'length))) then
--					next_state <= medium_speed_left;
--				elsif ((Speed_up = '0') and (x_reg - speed2 <= to_unsigned(Tank_Width/2, x_reg'length))) then
--					next_state <= medium_speed_right;
--				end if;	
--			
--			
--			
--			when high_speed_right =>
--					x_new <= x_reg + speed3;
--					y_new <= y_reg;
--					
--				if(PAUSE = '1')then
--					next_state <= stop;
--				elsif ((Speed_up = '1') and (x_reg + speed3 < to_unsigned(Screen_Width-Tank_Width/2, x_reg'length))) then
--					next_state <= low_speed_right;
--				elsif ((Speed_up = '1') and (x_reg + speed3 >= to_unsigned(Screen_Width-Tank_Width/2, x_reg'length))) then
--					next_state <= low_speed_left;
--				elsif ((Speed_up = '0') and (x_reg + speed3 < to_unsigned(Screen_Width-Tank_Width/2, x_reg'length))) then
--					next_state <= high_speed_right;
--				elsif ((Speed_up = '0') and (x_reg + speed3 >= to_unsigned(Screen_Width-Tank_Width/2, x_reg'length))) then
--					next_state <= high_speed_left;
--				end if;
--				
--				
--			when high_speed_left =>
--					x_new <= x_reg - speed3;
--					y_new <= y_reg;
--					
--				if(PAUSE = '1')then
--					next_state <= stop;
--				elsif ((Speed_up = '1') and (x_reg - speed3 > to_unsigned(Tank_Width/2, x_reg'length))) then
--					next_state <= low_speed_left;
--				elsif ((Speed_up = '1') and (x_reg - speed3 <= to_unsigned(Tank_Width/2, x_reg'length))) then
--					next_state <= low_speed_right;
--				elsif ((Speed_up = '0') and (x_reg - speed3 > to_unsigned(Tank_Width/2, x_reg'length))) then
--					next_state <= high_speed_left;
--				elsif ((Speed_up = '0') and (x_reg - speed3 <= to_unsigned(Tank_Width/2, x_reg'length))) then
--					next_state <= high_speed_right;
--				end if;
--		
--			when stop =>
--				x_new <= x_reg ;
--				y_new <= y_reg ;
--				next_state <= stop;	
--			
--			when others =>
--				x_new <= x_reg ;
--				y_new <= y_reg ;
--				next_state <= stop;	
--		end case;
--		
--	end process;	
	
--  end architecture behavioral;		
