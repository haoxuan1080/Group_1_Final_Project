library IEEE;

use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use work.game_constant.all;
entity BramWr is
	port (
		clk, rst_n: in std_logic;
		row: out std_logic_vector(9 downto 0);
   		col: out std_logic_vector(9 downto 0);
		we: out std_logic	
	);
end BramWr;

architecture behavioral of BramWr is
	signal row_cnt, col_cnt: std_logic_vector(9 downto 0);
begin
	we<='1';
	row<=row_cnt;
	col<=col_cnt;
	process (clk, rst_n)
	begin
		if (rst_n='0') then
			row_cnt<=(others=>'0');
			col_cnt<=(others=>'0');
		elsif (rising_edge(clk)) then
			if(row_cnt=std_logic_vector(to_unsigned(Screen_Height, 10))) then
				row_cnt<=(others=>'0');
			elsif (col_cnt=std_logic_vector(to_unsigned(Screen_Width-1, 10))) then
				row_cnt<=std_logic_vector(unsigned(row_cnt)+1);
			end if;

			if col_cnt=std_logic_vector(to_unsigned(Screen_Width-1, 10)) then
				col_cnt<=(others=>'0');
			else
				col_cnt<=std_logic_vector(unsigned(col_cnt)+1);
			end if;
		end if;
	end process; 
end behavioral;
