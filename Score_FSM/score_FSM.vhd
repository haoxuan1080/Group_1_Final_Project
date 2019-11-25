library IEEE;
--use work.game_constant.all;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity score_FSM is

	port(
			--clock 										: in std_logic;
			RESET											: in std_logic;
			ENABLE										: in std_logic;
			trigger 										: in std_logic;
			
			PAUSE    									: out std_logic
		);
end entity score_FSM;

		
architecture behavioral of score_FSM is

type state_type is(score_0, score_1, score_2, score_3 );
signal curr_state, next_state: state_type;
signal pause_reg,pause_new: std_logic;
begin

pause <= pause_reg;

clock: process(ENABLE,RESET) is
begin
		if(RESET = '0') then
			curr_state <= score_0;
			pause_reg <= '0';
		
		elsif(ENABLE = '1')then
			curr_state <= next_state;
			pause_reg <= pause_new;
		end if;
		
end process;
	
combinational : process(curr_state, trigger) is
begin
	next_state <= score_0;
	pause_new <= '0';

	case curr_state is	
		when score_0 =>
			pause_new <= '0';
			if (trigger = '1')then
				next_state <= score_1;
			else 
				next_state <= score_0;
			end if;
		
		when score_1 => 
			pause_new <= '0';
			if (trigger = '1')then
				next_state <= score_2;
			else 
				next_state <= score_1;
			end if;

		when score_2 => 
			pause_new <= '0';
			if (trigger = '1')then
				next_state <= score_3;
			else 
				next_state <= score_2;
			end if;

		when score_3 => 
			pause_new <= '1';
			next_state <= score_3;

end case;
end process;
end architecture behavioral;