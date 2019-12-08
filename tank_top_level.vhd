library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
--use work.decoder.all;
use work.Game_constant.all;

entity tank_top_level is
	port(
		clock: in std_logic;
    	reset: in std_logic;	
		keyboard_clk, keyboard_data: in std_logic;

		HEX0, HEX7 :  out std_logic_vector(6 downto 0); 
		
		VGA_RED, VGA_GREEN, VGA_BLUE 					: out std_logic_vector(7 downto 0); 
		HORIZ_SYNC, VERT_SYNC, VGA_BLANK, VGA_CLK		: out std_logic;
		
		LCD_RS, LCD_E, LCD_ON, RESET_LED, SEC_LED		: OUT	STD_LOGIC;
		LCD_RW						: BUFFER STD_LOGIC;
		DATA_BUS				: INOUT	STD_LOGIC_VECTOR(7 DOWNTO 0)
);

end entity tank_top_level;

architecture structual of tank_top_level is

component freq_div is
	port(
		clk: in std_logic;
    	rst_n: in std_logic;
		en_out: out std_logic	
	);
end component freq_div;

component tank is
	port(
			clock 										: in std_logic;
			RESET											: in std_logic;
			ENABLE										: in std_logic;
			PAUSE    									: in std_logic;
			Speed_up			    						: in std_logic; -- must be less than 2 enable( speed up two levels)	
			x					: out std_logic_vector(9 downto 0);
			y 					: out std_logic_vector(9 downto 0)
		);

end component tank;

component bullet is
	port (
		clk, rst_n, en : in std_logic;
   	shoot				: in std_logic;
		collision		: in std_logic;
		PAUSE				: in std_logic; -- add a port 
		Trow_in, Tcol_in: in std_logic_vector (9 downto 0);
		row_out, col_out: out std_logic_vector (9 downto 0)
	);
end component bullet;

component bullet_2 is
	port (
		clk, rst_n, en : in std_logic;
   	shoot				: in std_logic;
		collision		: in std_logic;
		PAUSE				: in std_logic; -- add a port 
		Trow_in, Tcol_in: in std_logic_vector (9 downto 0);
		row_out, col_out: out std_logic_vector (9 downto 0)
	);
end component bullet_2;

component collision is
	port(
			clock	 									   : in std_logic;
			RESET_sys									: in std_logic;
			x_tank, y_tank 					      : in std_logic_vector(9 downto 0);
			x_bullet, y_bullet 					   : in std_logic_vector(9 downto 0);
			trigger										: out  std_logic
		);
end component collision;

component score_FSM is

	port(
			clock 										: in std_logic;
			RESET											: in std_logic;
			trigger 										: in std_logic;
			
			score    									: out std_logic_vector(1 downto 0)	
--			PAUSE    									: out std_logic
		);
end component score_FSM;

component WinDec is
   port(
		clk, rst_n: in std_logic;
		P1Score, P2Score: in std_logic_vector (1 downto 0);	
		pause_out: out std_logic;
		game_state_out: out std_logic_vector (1 downto 0)
	);
end component WinDec;

component VGA_test is
	port(
			CLOCK_50 										: in std_logic;
			RESET_N											: in std_logic;
--			en													: in std_logic;
			
			game_state: in std_logic_vector (1 downto 0);
			
			T1x, T1y, T2x, T2y, B1x, B1y, B2x, B2y			: in std_logic_vector (9 downto 0);
	
			--VGA 
			VGA_RED, VGA_GREEN, VGA_BLUE 					: out std_logic_vector(7 downto 0); 
			HORIZ_SYNC, VERT_SYNC, VGA_BLANK, VGA_CLK		: out std_logic

		);
end component VGA_test;

component de2lcd IS
	PORT(
		reset, clk_50Mhz				: IN	STD_LOGIC;
		game_state						: IN 	std_logic_vector(1 downto 0);
		LCD_RS, LCD_E, LCD_ON, RESET_LED, SEC_LED		: OUT	STD_LOGIC;
		LCD_RW						: BUFFER STD_LOGIC;
		DATA_BUS				: INOUT	STD_LOGIC_VECTOR(7 DOWNTO 0));
END component de2lcd;

component keyboard_out is

	port(
		--keyboard_clk, keyboard_data, 
		clock_50MHz, reset: in std_logic;
		--, read : in std_logic;
		scan_code: in std_logic_vector (7 downto 0);
		scan2: in std_logic;
		--ready :out std_logic;
		speed_up1_out, speed_up2_out, shoot_1_out, shoot_2_out : out std_logic

	);
end component keyboard_out;

component ps2 is
	port( 	keyboard_clk, keyboard_data, clock_50MHz ,
			reset : in std_logic;--, read : in std_logic;
			scan_code : out std_logic_vector( 7 downto 0 );
			scan_readyo : out std_logic;
			hist3 : out std_logic_vector(7 downto 0);
			hist2 : out std_logic_vector(7 downto 0);
			hist1 : out std_logic_vector(7 downto 0);
			hist0 : out std_logic_vector(7 downto 0)
		);
end component ps2;

component leddcd is 
		port(
		data_in : in std_logic_vector(3 downto 0);
		segments_out : out std_logic_vector(6 downto 0)
		);
	end component;

	signal enable, trig1, trig2, pause, speed1, speed2, shoot1, shoot2,ready : std_logic;
	signal score1, score2, game_state, shoot_key, speed_key: std_logic_vector(1 downto 0);	
	signal x_t1, x_t2, y_t1, y_t2, x_b1, x_b2, y_b1, y_b2, x_t2_std, y_t2_std, x_b2_std, y_b2_std: std_logic_vector(9 downto 0);
	signal x_t2_unsigned, y_t2_unsigned, x_b2_unsigned, y_b2_unsigned: unsigned (9 downto 0);
	signal curr_code, disp_0, disp_1, disp_2, disp_3: std_logic_vector(7 downto 0);
	
begin

new_freq: freq_div port map(clock, reset, enable);
ps2_keyboard: ps2 port map(keyboard_clk, keyboard_data, clock,reset, curr_code, ready, disp_3, disp_3, disp_1, disp_0);
keyboard_control : keyboard_out port map(clock, reset, curr_code,ready, speed1,speed2,shoot1, shoot2); -- wrong output 
--keyboard_control : keyboard_out port map(enable, speed1,speed2,shoot1, shoot2); 
bullet1: bullet port map(clock, reset, enable, shoot1, trig1, pause, y_t1, x_t1, y_b1, x_b1); 
bullet2: bullet_2 port map(clock, reset, enable, shoot2, trig2, pause, y_t2, x_t2, y_b2, x_b2); 
tank1: tank port map(clock, reset, enable, pause, speed1, x_t1, y_t1);
tank2: tank port map(clock, reset, enable, pause, speed2, x_t2_std, y_t2_std);
collision_hit2: collision port map(clock, reset, x_t2, y_t2, x_b1, y_b1, trig1);
collision_hit1: collision port map(clock, reset, x_t1, y_t1, x_b2, y_b2, trig2);
score_1: score_FSM port map(clock, reset, trig1, score1);
score_2: score_FSM port map(clock, reset, trig2, score2);
winner: WinDec port map(clock, reset, score1, score2, pause, game_state);
VGA_disp: VGA_test port map(clock, reset, game_state, x_t1, y_t1, x_t2, y_t2, x_b1, y_b1, x_b2, y_b2, VGA_RED, VGA_GREEN, VGA_BLUE, HORIZ_SYNC, VERT_SYNC, VGA_BLANK, VGA_CLK );
led_disp1: leddcd port map(("00" & score1), HEX7); -- bit of score
led_disp2: leddcd port map(("00" & score2), HEX0); -- bit of score
lcd_disp: de2lcd port map(reset, clock, game_state, LCD_RS, LCD_E, LCD_ON, RESET_LED, SEC_LED, LCD_RW, DATA_BUS);

x_t2 <= std_logic_vector(x_t2_unsigned);
y_t2 <= std_logic_vector(y_t2_unsigned);

tank2_position: process(x_t2_std, y_t2_std)
begin	
	x_t2_unsigned <= to_unsigned(Screen_Width - to_integer(unsigned(x_t2_std)),x_t2_unsigned'length);
	y_t2_unsigned <= to_unsigned(Screen_Height - to_integer(unsigned(y_t2_std)),y_t2_unsigned'length);

end process;

end architecture structual;

