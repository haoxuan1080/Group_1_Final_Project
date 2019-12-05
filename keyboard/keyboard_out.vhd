LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity keyboard_out is

port(
keyboard_clk, keyboard_data, clock_50MHz, reset, enable : in std_logic;--, read : in std_logic;
--ready :out std_logic;
speed_up1, speed_up2, shoot_out1, shoot_out2 : out std_logic

);
end entity keyboard_out;


architecture structural of keyboard_out is
component ps2 is
	port( 	keyboard_clk, keyboard_data, clock_50MHz ,
			reset 		: in std_logic;--, read : in std_logic;
			
			scan_code 	: out std_logic_vector( 7 downto 0 );
			scan_readyo : out std_logic;
			hist3 : out std_logic_vector(7 downto 0);
			hist2 : out std_logic_vector(7 downto 0);
			hist1 : out std_logic_vector(7 downto 0);
			hist0 : out std_logic_vector(7 downto 0)
		);
end component ps2;


signal ready : std_logic;
type state_type is(idle, speed1,speed2, shoot1, shoot2);
signal curr_state, next_state: state_type;
signal trigger, speed_reg1, shoot_reg1, speed_reg2, shoot_reg2, speed_reg1_c, shoot_reg1_c, speed_reg2_c, shoot_reg2_c : std_logic;
signal curr_code, disp_0, disp_1, disp_2, disp_3: std_logic_vector(7 downto 0);

begin 

key_out: ps2 port map(keyboard_clk, keyboard_data, clock_50MHz,reset, curr_code, ready, disp_3, disp_3, disp_1, disp_0);

trig_proc: process(ready)
begin
	if(disp_1 = X"F0") then
		trigger <= '1';
	else
		trigger <= '0';
	end if;
end process;


speed_up1 <= speed_reg1;
speed_up2 <= speed_reg2;
shoot_out1 <= shoot_reg1;
shoot_out2 <= shoot_reg2;

sequ_proc: process(RESET, clock_50MHz) is
begin
		if(RESET = '0') then
			curr_state <= idle;
			speed_reg1 <= '0';
			shoot_reg1 <= '0';
			speed_reg2 <= '0';
			shoot_reg2 <= '0';
		
		elsif(rising_edge(clock_50MHz))then
			curr_state <= next_state;
			speed_reg1 <= speed_reg1_c;
			speed_reg2 <= speed_reg2_c;
			shoot_reg1 <= shoot_reg1_c;
			shoot_reg2 <= shoot_reg2_c;
		end if;
		
end process;
	
combinational : process(curr_state, curr_code,trigger ) is
begin
	next_state <= idle;

	case curr_state is	
	when idle =>	
			speed_reg1_c <= '0';
			speed_reg2_c <= '0';
			shoot_reg1_c <= '0';
			shoot_reg2_c <= '0';
		if ((trigger = '1') and (curr_code = x"1A")) then
			next_state <= speed1;
		elsif ((trigger = '1') and (curr_code = x"4A")) then
			next_state <= speed2;
		elsif ((trigger = '1') and (curr_code = x"1C")) then
			next_state <= shoot1;
		elsif ((trigger = '1') and (curr_code = x"52")) then
			next_state <= shoot2;
		else 
			next_state <= idle;
		end if;
		
	when speed1 =>
			speed_reg1_c <= '1';
			speed_reg2_c <= '0';
			shoot_reg1_c <= '0';
			shoot_reg2_c <= '0';
		if ((trigger = '1') and (curr_code = x"1A")) then
			next_state <= speed1;
		elsif ((trigger = '1') and (curr_code = x"4A")) then
			next_state <= speed2;
		elsif ((trigger = '1') and (curr_code = x"1C")) then
			next_state <= shoot1;
		elsif ((trigger = '1') and (curr_code = x"52")) then
			next_state <= shoot2;
		else 
			next_state <= idle;
		end if;
			
	when speed2 =>
			speed_reg1_c <= '0';
			speed_reg2_c <= '1';
			shoot_reg1_c <= '0';
			shoot_reg2_c <= '0';
		if ((trigger = '1') and (curr_code = x"1A")) then
			next_state <= speed1;
		elsif ((trigger = '1') and (curr_code = x"4A")) then
			next_state <= speed2;
		elsif ((trigger = '1') and (curr_code = x"1C")) then
			next_state <= shoot1;
		elsif ((trigger = '1') and (curr_code = x"52")) then
			next_state <= shoot2;
		else 
			next_state <= idle;
		end if;
						
	when shoot1 =>
			speed_reg1_c <= '0';
			speed_reg2_c <= '0';
			shoot_reg1_c <= '1';
			shoot_reg2_c <= '0';
		if ((trigger = '1') and (curr_code = x"1A")) then
			next_state <= speed1;
		elsif ((trigger = '1') and (curr_code = x"4A")) then
			next_state <= speed2;
		elsif ((trigger = '1') and (curr_code = x"1C")) then
			next_state <= shoot1;
		elsif ((trigger = '1') and (curr_code = x"52")) then
			next_state <= shoot2;
		else 
			next_state <= idle;
		end if;
			
	when shoot2 =>
			speed_reg1_c <= '0';
			speed_reg2_c <= '0';
			shoot_reg1_c <= '0';
			shoot_reg2_c <= '1';
		if ((trigger = '1') and (curr_code = x"1A")) then
			next_state <= speed1;
		elsif ((trigger = '1') and (curr_code = x"4A")) then
			next_state <= speed2;
		elsif ((trigger = '1') and (curr_code = x"1C")) then
			next_state <= shoot1;
		elsif ((trigger = '1') and (curr_code = x"52")) then
			next_state <= shoot2;
		else 
			next_state <= idle;
		end if;
	
	when others =>
			speed_reg1_c <= '0';
			speed_reg2_c <= '0';
			shoot_reg1_c <= '0';
			shoot_reg2_c <= '0';

			next_state <= idle;
	end case;
	
end process;

end architecture;
