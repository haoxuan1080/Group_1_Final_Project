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

--type state_type is(score_0, score_1, score_2, score_3 );
--signal curr_state, next_state: state_type;

signal curr_state, next_state: std_logic_vector(1 downto 0);	
--signal pause_reg,pause_new: std_logic;
begin

score <= curr_state;
--pause <= pause_reg;

sequ_proc: process(RESET, clock) is
begin
		if(RESET = '0') then
			curr_state <= "00";
--			pause_reg <= '0';
		
		elsif(rising_edge(clock))then
--			if(enable = '1')then
			curr_state <= next_state;
--			pause_reg <= pause_new;
--			end if;
		end if;
		
end process;
	
combinational : process(curr_state, trigger) is
begin
	next_state <= "00";
--	pause_new <= '0';

	case curr_state is	
		when "00" =>
--			pause_new <= '0';
			if (trigger = '1')then
				next_state <= "01";
			else 
				next_state <= curr_state;
			end if;
		
		when "01" => 
--			pause_new <= '0';
			if (trigger = '1')then
				next_state <= "10";
			else 
				next_state <= curr_state;
			end if;

		when "10" => 
--			pause_new <= '0';
			if (trigger = '1')then
				next_state <= "11";
			else 
				next_state <= curr_state;
			end if;

		when "11" => 
--			pause_new <= '1';
			next_state <= curr_state;
		
		when others=> 
--			pause_new <= '1';
			next_state <= curr_state;
end case;
end process;
end architecture behavioral;