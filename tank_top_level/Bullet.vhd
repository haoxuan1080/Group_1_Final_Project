library IEEE;
use work.game_constant.all;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity bullet is
	port (
		clk, rst_n, en: in std_logic;
   	shoot: in std_logic;
		collision: in std_logic;
		pause: in std_logic;
		Trow_in, Tcol_in: in std_logic_vector (9 downto 0);
		row_out, col_out: out std_logic_vector (9 downto 0)
	);
end bullet;

architecture behavioral of bullet is
	type state is (idle, not_fired, fired);
	constant speed: unsigned:="0000001010";
	signal row, col, row_c, col_c: unsigned (9 downto 0);
	signal curr_state, next_state: state;
begin
	row_out<=std_logic_vector(row);
	col_out<=std_logic_vector(col);

	syn_proc: process (clk, rst_n)
	begin
		if (rst_n='0') then
			row<=unsigned(Trow_in);
			col<=unsigned(Tcol_in);
			curr_state<=idle;
		elsif (rising_edge(clk) and en='1') then
			--if(en='1') then
				row<=row_c;
				col<=col_c;
				curr_state<=next_state;
			--end if;
		end if;
	end process;

	asyn_proc: process (Trow_in, Tcol_in, collision, shoot, curr_state, row, col)
	begin
		case curr_state is
			when idle =>
				row_c<=unsigned(Trow_in);
				col_c<=unsigned(Tcol_in);
				next_state<=not_fired;
			when not_fired =>
				row_c<=unsigned(Trow_in);
				col_c<=unsigned(Tcol_in);
				next_state<=not_fired;
				if(shoot='1') then
					next_state<=fired;
				end if;
				if (pause='1') then
					next_state<=not_fired;
				end if;
			when fired => 
				row_c<=row+speed;
				col_c<=col;
				next_state<=fired;
				if(row>=Screen_Height or collision='1') then
					next_state<=not_fired;
				end if;
				if (pause='1') then
					next_state<=not_fired;
				end if;
		end case;
	end process;
end behavioral;


