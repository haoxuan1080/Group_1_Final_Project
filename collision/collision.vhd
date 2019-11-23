library IEEE;
use work.Game_constant.all;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity collision is
	port(
			clock_sys 									: in std_logic;
			RESET_sys									: in std_logic;
			x_tank, y_tank 					      : in natural;
			x_bullet, y_bullet 					   : in natural;
			
			trigger										: out  std_logic
		);
end entity collision;

architecture behavioral of collision is

signal counter : unsigned (3 downto 0);    --- default???????

begin

score <= std_logic_vector(counter);

process (RESET_sys,clock_sys) is
begin
	if(RESET_sys = '0')then 
		counter <= (others =>'0');

	elsif((rising_edge(clock_sys)) and (x_bullet = x_tank ) and (y_bullet = y_tank))then  ----should be the length of the tank, bullet reset?
		counter <= counter + 1;
		
		
	else 
		counter <= counter;

	end if;
end process;


end architecture behavioral;