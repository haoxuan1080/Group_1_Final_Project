library IEEE;
use work.game_constant.all;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity bullet_2 is
	port (
		clk, rst_n, en: in std_logic;
   	shoot: in std_logic;
		collision: in std_logic;
		pause: in std_logic;
		Trow_in, Tcol_in: in std_logic_vector (9 downto 0);
		row_out, col_out: out std_logic_vector (9 downto 0)
	);
end bullet_2;

architecture behavioral of bullet_2 is
	type state is (idle, not_fired, fired);
	constant speed: unsigned:="0000011010";
	signal row, col, row_c, col_c: unsigned (9 downto 0);
	signal curr_state, next_state: state;
begin
	row_out<=std_logic_vector(row);
	col_out<=std_logic_vector(col);

	syn_proc: process (clk, rst_n)
	begin
		if (rst_n='0') then
			row<= (others => '0');
			col<= (others => '0');
			curr_state<=idle;
		elsif (rising_edge(clk)) then
				row<=row_c;
				col<=col_c;
				curr_state<=next_state;
		end if;
	end process;

	asyn_proc: process (Trow_in, Tcol_in, en, collision, shoot, curr_state, row, col, pause)
	begin
		row_c <= row;
		col_c<= col;
		next_state <= curr_state;
		case curr_state is
			when idle =>
				row_c<=unsigned(Trow_in);
				col_c<=unsigned(Tcol_in);
				if(shoot='1' and pause = '0')  then
					next_state<=fired;
			
				end if;
				
			when fired => 
				if(en = '1' and pause = '0')then
					row_c<=row-speed;
					col_c<=col;
					next_state<=fired;
				end if;
					if(row>=Screen_Height or collision='1') then
						next_state<=idle;
						row_c<=unsigned(Trow_in);
						col_c<=unsigned(Tcol_in);
					end if;
				
			
			when others =>
				next_state<=idle;
				row_c <= (others=> 'X');
				col_c <= (others=> 'X');
		end case;
	end process;
end behavioral;


--				next_state<=not_fired;
--			when not_fired =>
--				row_c<=unsigned(Trow_in);
--				col_c<=unsigned(Tcol_in);
--				next_state<=not_fired;
