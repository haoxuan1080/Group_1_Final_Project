library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.game_constant.all;

entity freq_div is
	port(
		clk: in std_logic;
    		rst_n: in std_logic;
		en_out: out std_logic	
	);
end freq_div;

architecture behavioral of freq_div is
	signal counter: unsigned (21 downto 0);
	signal en: std_logic;
begin
	en_out<=en;
	process (clk, rst_n)
	begin
		if( rst_n='0') then
			en<='0';
			counter<=to_unsigned(0, counter'length);
		elsif (rising_edge(clk)) then
			if (std_logic_vector(counter)=(counter'range=>'1')) then
				counter<=to_unsigned(0, counter'length);
				en<='1';
			else
				counter<=counter+1;
				en<='0';
			end if;
		end if;
	end process;
end behavioral;
