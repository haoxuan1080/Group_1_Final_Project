LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity keyboard_out is

	port(
		--keyboard_clk, keyboard_data, 
		clock_50MHz, reset: in std_logic;
		--, read : in std_logic;
		scan_code: in std_logic_vector (7 downto 0);
		scan2: in std_logic;
		--ready :out std_logic;
		speed_up1_out, speed_up2_out, shoot_1_out, shoot_2_out : out std_logic

	);
end entity keyboard_out;


architecture structural of keyboard_out is
--component ps2 is
--	port( 	keyboard_clk, keyboard_data, clock_50MHz ,
--			reset 		: in std_logic;--, read : in std_logic;
--			
--			scan_code 	: out std_logic_vector( 7 downto 0 );
--			scan_readyo : out std_logic;
--			hist3 : out std_logic_vector(7 downto 0);
--			hist2 : out std_logic_vector(7 downto 0);
--			hist1 : out std_logic_vector(7 downto 0);
--			hist0 : out std_logic_vector(7 downto 0)
--		);
--end component ps2;
signal  delay_code: std_logic_vector(7 downto 0);
--signal scan2: std_logic;

constant speed1: std_logic_vector (7 downto 0):= x"1A";
constant shoot1: std_logic_vector (7 downto 0):= x"1C";
constant speed2: std_logic_vector (7 downto 0):= x"3A";
constant shoot2: std_logic_vector (7 downto 0):= x"42";

signal speed_up1, speed_up2, shoot_1, shoot_2: std_logic;
signal sp1_tr, sp2_tr, sh1_tr, sh2_tr: std_logic;
signal sp1_tr_dly, sp2_tr_dly, sh1_tr_dly, sh2_tr_dly: std_logic;

begin

	speed_up1_out<=speed_up1;
	speed_up2_out<=speed_up2;
	shoot_1_out<=shoot_1;
	shoot_2_out<=shoot_2;
	--ps2_map: ps2 port map (keyboard_clk=>keyboard_clk, 
	--		       keyboard_data=>keyboard_data,
	--		       clock_50MHz=>clock_50MHz,
	--		       reset=>reset,
	--		       scan_code=>scan_code,
	--		       scan_readyo=>scan2,
	--		       hist3=>open,
	--		       hist2=>open,
	--		       hist1=>open,
	--		       hist0=>open
	--		      );

	paulse_proc: process (clock_50MHz, reset)
	begin
		if (reset='0') then
			speed_up1<='0';
			speed_up2<='0';
			shoot_1<='0';
			shoot_2<='0';
			sp1_tr_dly<='0';
			sp2_tr_dly <='0';
			sh1_tr_dly<='0';
			sh2_tr_dly<='0';
		elsif (rising_edge(clock_50MHz)) then
			sp1_tr_dly<=sp1_tr;
			sp2_tr_dly<=sp2_tr;
			sh1_tr_dly<=sh1_tr;
			sh2_tr_dly<=sh2_tr;
			if (sp1_tr_dly='0' and sp1_tr='1') then
				speed_up1<='1';
			else
				speed_up1<='0';
			end if;

			if (sp2_tr_dly='0' and sp2_tr='1') then
				speed_up2<='1';
			else
				speed_up2<='0';
			end if;

			if (sh1_tr_dly='0' and sh1_tr='1') then
				shoot_1<='1';
			else
				shoot_1<='0';
			end if;

			if (sh2_tr_dly='0' and sh2_tr='1') then
				shoot_2<='1';
			else
				shoot_2<='0';
			end if;
		end if;
	end process;

	delay_proc1: process (scan2, reset)
	begin
		if (reset='0') then
			delay_code<=  x"00"; --after 1 ns;
		elsif(rising_edge(scan2)) then
			delay_code<=  scan_code; -- after 1 ns;
		end if;
	end process;

	tirgger_proc: process (scan2, reset)
        begin
                if (reset='0') then
                        		sp1_tr<='0';
					sp2_tr<='0';
					sh1_tr<='0';
					sh2_tr<='0';
                elsif(rising_edge(scan2)) then
                        if (delay_code=x"F0") then
                               if scan_code=speed1 then
					sp1_tr<='1';
					sp2_tr<='0';
					sh1_tr<='0';
					sh2_tr<='0';	
				elsif scan_code=speed2 then
                                	sp1_tr<='0';
					sp2_tr<='1';
					sh1_tr<='0';
					sh2_tr<='0';
				elsif scan_code=shoot1 then
					sp1_tr<='0';
					sp2_tr<='0';
					sh1_tr<='1';
					sh2_tr<='0';
				elsif scan_code=shoot2 then
					sp1_tr<='1';
					sp2_tr<='0';
					sh1_tr<='0';
					sh2_tr<='0';
				end if;
                        else
                                sp1_tr<='0';
				sp2_tr<='0';
				sh1_tr<='0';
				sh2_tr<='0';
                        end if;
                end if;
        end process;

end structural;
--signal ready : std_logic;
--type state_type is(idle, speed1,speed2, shoot1, shoot2);
--signal curr_state, next_state: state_type;
--signal trigger, speed_reg1, shoot_reg1, speed_reg2, shoot_reg2, speed_reg1_c, shoot_reg1_c, speed_reg2_c, shoot_reg2_c : std_logic;
--signal curr_code_reg,curr_code, disp_0, disp_1, disp_2, disp_3: std_logic_vector(7 downto 0);

--begin 

--key_out: ps2 port map(keyboard_clk, keyboard_data, clock_50MHz,reset, curr_code, ready, disp_3, disp_3, disp_1, disp_0);

--trig_proc: process(clock_50MHz, reset)
--begin
--if(reset = '1')then
--	trigger <= '0';
--	curr_code_reg <= (others=> '0');
--elsif(rising_edge(clock_50MHz))then
--	curr_code_reg <= curr_code;
--	if ((disp_1 = X"F0") and (ready = '1')) then
--		trigger <= '1';		
--	else
--		trigger <= '0';
--	end if;
--end if;
--end process;


--speed_up1 <= speed_reg1;
--speed_up2 <= speed_reg2;
--shoot_out1 <= shoot_reg1;
--shoot_out2 <= shoot_reg2;

--sequ_proc: process(RESET, clock_50MHz) is
--begin
--		if(RESET = '0') then
--			speed_reg1 <= '0';
--			shoot_reg1 <= '0';
--			speed_reg2 <= '0';
--			shoot_reg2 <= '0';
--		
--		elsif(rising_edge(clock_50MHz))then
--			speed_reg1 <= '0';
--			shoot_reg1 <= '0';
--			speed_reg2 <= '0';
--			shoot_reg2 <= '0';
--			if (disp_1 = X"F0") then
--				if (curr_code_reg = x"1A") then
--					speed_reg1 <= '1';
--				elsif (curr_code_reg = x"4A") then
--					speed_reg2 <= '1';
--				elsif (curr_code_reg = x"1C") then
--					shoot_reg1 <= '1';
--				elsif (curr_code_reg = x"52") then
--					shoot_reg2 <= '1';
--				end if;
--			end if;
--		end if;
--end process;
	
--	combinational : process(curr_state, curr_code_reg,trigger) is
--	begin
--		next_state <= idle;
--	
--		case curr_state is	
--		when idle =>	
--				speed_reg1_c <= '0';
--				speed_reg2_c <= '0';
--				shoot_reg1_c <= '0';
--				shoot_reg2_c <= '0';
--			if ((trigger = '1') and (curr_code_reg = x"1A")) then
--				next_state <= speed1;
--			elsif ((trigger = '1') and (curr_code_reg = x"4A")) then
--				next_state <= speed2;
--			elsif ((trigger = '1') and (curr_code_reg = x"1C")) then
--				next_state <= shoot1;
--			elsif ((trigger = '1') and (curr_code_reg = x"52")) then
--				next_state <= shoot2;
--			else 
--				next_state <= idle;
--			end if;
--			
--		when speed1 =>
--				speed_reg1_c <= '1';
--				speed_reg2_c <= '0';
--				shoot_reg1_c <= '0';
--				shoot_reg2_c <= '0';
--			if ((trigger = '1') and (curr_code_reg = x"1A")) then
--				next_state <= speed1;
--			elsif ((trigger = '1') and (curr_code_reg = x"4A")) then
--				next_state <= speed2;
--			elsif ((trigger = '1') and (curr_code_reg = x"1C")) then
--				next_state <= shoot1;
--			elsif ((trigger = '1') and (curr_code_reg = x"52")) then
--				next_state <= shoot2;
--			else 
--				next_state <= idle;
--			end if;
--				
--		when speed2 =>
--				speed_reg1_c <= '0';
--				speed_reg2_c <= '1';
--				shoot_reg1_c <= '0';
--				shoot_reg2_c <= '0';
--			if ((trigger = '1') and (curr_code_reg = x"1A")) then
--				next_state <= speed1;
--			elsif ((trigger = '1') and (curr_code_reg = x"4A")) then
--				next_state <= speed2;
--			elsif ((trigger = '1') and (curr_code_reg = x"1C")) then
--				next_state <= shoot1;
--			elsif ((trigger = '1') and (curr_code_reg = x"52")) then
--				next_state <= shoot2;
--			else 
--				next_state <= idle;
--			end if;
--							
--		when shoot1 =>
--				speed_reg1_c <= '0';
--				speed_reg2_c <= '0';
--				shoot_reg1_c <= '1';
--				shoot_reg2_c <= '0';
--			if ((trigger = '1') and (curr_code_reg = x"1A")) then
--				next_state <= speed1;
--			elsif ((trigger = '1') and (curr_code_reg = x"4A")) then
--				next_state <= speed2;
--			elsif ((trigger = '1') and (curr_code_reg = x"1C")) then
--				next_state <= shoot1;
--			elsif ((trigger = '1') and (curr_code_reg = x"52")) then
--				next_state <= shoot2;
--			else 
--				next_state <= idle;
--			end if;
--				
--		when shoot2 =>
--				speed_reg1_c <= '0';
--				speed_reg2_c <= '0';
--				shoot_reg1_c <= '0';
--				shoot_reg2_c <= '1';
--			if ((trigger = '1') and (curr_code_reg = x"1A")) then
--				next_state <= speed1;
--			elsif ((trigger = '1') and (curr_code_reg = x"4A")) then
--				next_state <= speed2;
--			elsif ((trigger = '1') and (curr_code_reg = x"1C")) then
--				next_state <= shoot1;
--			elsif ((trigger = '1') and (curr_code_reg = x"52")) then
--				next_state <= shoot2;
--			else 
--				next_state <= idle;
--			end if;
--		
--		when others =>
--				speed_reg1_c <= '0';
--				speed_reg2_c <= '0';
--				shoot_reg1_c <= '0';
--				shoot_reg2_c <= '0';
--	
--				next_state <= idle;
--		end case;
--		
--	end process;

--end architecture;
