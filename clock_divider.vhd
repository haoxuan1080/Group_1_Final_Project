library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity clock_divider is
	port(
			sys_clock		: in std_logic;
			sys_rst			: in std_logic;
			speed_level    : in std_logic_vector(1 downto 0);
			
			
			clock_tank				: out std_logic;
			clock_bullet			: out std_logic
			);
end entity clock_divider;
		
architecture behavioral of clock_divider is

constant small: natural := 2E6;
constant medium: natural := 2E6;
constant large: natural := 2E9;

signal clock_tank_low,clock_tank_medium,clock_tank_high : std_logic;

begin 


clock_bullet <= clock_tank_medium;

process(speed_level,clock_tank_low,clock_tank_medium, clock_tank_high)is 
begin

	if (speed_level = "00") then
		clock_tank <= clock_tank_low;
	elsif (speed_level = "01") then
		clock_tank <= clock_tank_high;
	else 
		clock_tank <= clock_tank_medium;
	end if;
	
end process;


process (sys_clock,sys_rst) is
variable counter1 : natural;
--variable counter1,counter2,counter3,counter4 : natural; -- defaut
begin
	
	if(sys_rst = '0')then
			counter1 := 0;
			clock_tank_low <= '0';
			clock_tank_medium <= '0';
			clock_tank_high <= '0';
			--counter2 := 0;
			--counter3 := 0;
			--counter4 := 0;
	elsif (rising_edge(sys_clock))then
	
			counter1 := counter1 + 1;
			
			if(counter1 = small)then
				counter1 := counter1 + 1;
				clock_tank_high <= not clock_tank_high;
				clock_tank_medium <= clock_tank_medium;
				clock_tank_high <= clock_tank_high;
				
			elsif (counter1 = medium)then
				counter1 := counter1 + 1;
				clock_tank_high <= not clock_tank_high;
				clock_tank_medium <= not clock_tank_medium;
				clock_tank_high <= clock_tank_high;			
			elsif (counter1 = large)then
				counter1 := 0;
				clock_tank_high <= not clock_tank_high;
				clock_tank_medium <= not clock_tank_medium;
				clock_tank_high <= not clock_tank_high;	
			else
			 	counter1 := counter1 + 1;
				clock_tank_high <= clock_tank_high;
				clock_tank_medium <= clock_tank_medium;
				clock_tank_high <= clock_tank_high;	
			end if;
			
	else 
			counter1 := counter1;
			clock_tank_high <= clock_tank_high;
			clock_tank_medium <= clock_tank_medium;
			clock_tank_high <= clock_tank_high;	
	end if;
end process;

end architecture behavioral;