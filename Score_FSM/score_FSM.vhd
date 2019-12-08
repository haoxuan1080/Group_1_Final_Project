library IEEE;
--use work.game_constant.all;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity score_FSM is

	port(
			clock 										: in std_logic;
			RESET											: in std_logic;
--			ENABLE										: in std_logic; -- align with the enable 
			trigger 										: in std_logic;
			
			score    									: out std_logic_vector(1 downto 0)		
--			PAUSE    									: out std_logic
		);
end entity score_FSM;

		
architecture behavioral of score_FSM is

type state_type is(score_0, score_1, score_2, score_3 );
signal curr_state, next_state: state_type;

signal score_reg, score_new: std_logic_vector(1 downto 0);	

begin

score <= score_reg;


sequ_proc: process(RESET, clock) is
begin
		if(RESET = '0') then
			curr_state <= score_0;
			score_reg <= "00";
		
		elsif(rising_edge(clock))then
			curr_state <= next_state;
			score_reg <= score_new;
		end if;
		
end process;
	
combinational : process(curr_state, trigger) is
begin
	next_state <= score_0;
	score_new <= "00";

	case curr_state is	
		when score_0 =>
			if (trigger = '1')then
				next_state <= score_1;
				score_new <= "01";
			else 
				next_state <= curr_state;
				score_new <= score_reg;
			end if;
		
		when score_1 => 
			if (trigger = '1')then
				next_state <= score_2;
				score_new <= "10";
			else 
				next_state <= curr_state;
				score_new <= score_reg;
			end if;

		when score_2 => 
			if (trigger = '1')then
				next_state <= score_3;
				score_new <= "11";
			else 
				next_state <= curr_state;
				score_new <= score_reg;
			end if;

		when score_3 => 
			next_state <= curr_state;
			score_new <= score_reg;
		
		when others=> 
			next_state <= curr_state;
			score_new <= score_reg;
end case;
end process;
end architecture behavioral;