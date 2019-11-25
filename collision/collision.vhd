library IEEE;
use work.Game_constant.all;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity collision is
	port(
			--clock_sys 									: in std_logic;
			enable										: in std_logic;
			RESET_sys									: in std_logic;
			x_tank, y_tank 					      : in std_logic_vector(9 downto 0);
			x_bullet, y_bullet 					   : in std_logic_vector(9 downto 0);
			
			trigger										: out  std_logic
		);
end entity collision;

architecture behavioral of collision is
signal trigger_reg : std_logic;

begin

trigger <= trigger_reg;

process (RESET_sys,enable) is
begin
	if(RESET_sys = '0')then 
		trigger_reg <= '0';

	elsif((enable = '1') and (((unsigned(x_bullet) - unsigned(x_tank)) < Tank_Width/2)or((unsigned(x_tank) - unsigned(x_bullet)) < Tank_Width/2)) and (((unsigned(y_bullet) - unsigned(y_tank)) < Tank_Hight/2)or((unsigned(y_tank) - unsigned(y_bullet)) < Tank_Hight/2))) then
			trigger_reg <= '1'; --only one clock?	
		
	else 
		trigger_reg <= '0';
		
	end if;
	
end process;


end architecture behavioral;