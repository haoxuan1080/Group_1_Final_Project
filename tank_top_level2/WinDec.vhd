library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity WinDec is
        port(
		clk, rst_n: in std_logic;
		P1Score, P2Score: in std_logic_vector (1 downto 0);	
		pause_out: out std_logic;
		game_state_out: out std_logic_vector (1 downto 0)
	);
end WinDec;

architecture behavioral of WinDec is
	type state is (In_Proc, P1Win, P2Win);
	signal current_state, next_state: state;
	signal game_state, game_state_c: std_logic_vector (1 downto 0);
	signal pause, pause_c: std_logic;	
begin

	pause_out<=pause;
	game_state_out<=game_state;

	sync_proc: process (clk, rst_n)
	begin
		if(rst_n='0') then
			current_state<=In_Proc;	
			pause<='0';
			game_state<="00";
		elsif (rising_edge(clk)) then
			current_state<=next_state;
			pause<=pause_c;
			game_state<=game_state_c;
		end if;		
	end process;

	comb_proc: process (current_state, P1Score, P2Score)
	begin
		case current_state is
			when In_proc =>
				if (P1Score="11") then
					next_state<=P1Win;
					game_state_c<="01";
					pause_c<='1';
				elsif (P2Score="11") then
					next_state<=P2Win;
					game_state_c<="10";
					pause_c<='1';
				else
					next_state<=In_proc;
					game_state_c<="00";
					pause_c<='0';
				end if;
			when P1Win => 
				next_state<=P1Win;
				game_state_c<="01";
				pause_c<='1';
			when P2Win =>
				next_state<=P2Win;
				game_state_c<="10";
				pause_c<='1';
		end case;
	end process;
end behavioral;
