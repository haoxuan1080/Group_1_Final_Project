library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.decoder.all; 


entity tank_game is
	port(
			CLOCK 										: in std_logic;
			RESET											: in std_logic;
			
			disp_LED  								: out std_logic_vector (6 downto 0);
			VGA_R, VGA_G, VGA_B 					: out std_logic_vector(7 downto 0); 
			H_SYNC, V_SYNC, VGA_BLANK_CONTROL, VGA_CLOCK		: out std_logic
		);
end entity tank_game;


architecture structural of tank_game is

component clock_divider is
	port(
			sys_clock		: in std_logic;
			sys_rst			: in std_logic;
			speed_level    : in std_logic_vector(1 downto 0);
			
			clock_tank				: out std_logic;
			clock_bullet			: out std_logic
			);
end component clock_divider;

component draw_a_tank is
	port(
			clock_tank 										: in std_logic;
			RESET_tank											: in std_logic;	

			x, y 					: out natural
		);
end component draw_a_tank;

component VGA_top_level is
	port(
			CLOCK_50 										: in std_logic;
			RESET_N											: in std_logic;
			x_tank, y_tank, x_bullet, y_bullet 						: in natural;
	
			VGA_RED, VGA_GREEN, VGA_BLUE 					: out std_logic_vector(7 downto 0); 
			HORIZ_SYNC, VERT_SYNC, VGA_BLANK, VGA_CLK		: out std_logic

		);
end component VGA_top_level;

component bullet_generator is
	port(
			clock_bullet 									: in std_logic;
			RESET_bullet									: in std_logic;
			enable											: in std_logic;
			x_tank, y_tank 					         : in natural;
			
			x_bullet, y_bullet 					: out natural
		);
end component bullet_generator;

component collision is
	port(
			clock_sys 									: in std_logic;
			RESET_sys									: in std_logic;
			x_tank, y_tank 					      : in natural;
			x_bullet, y_bullet 					   : in natural;
			
			score											: out std_logic_vector (3 downto 0)
		);
end component collision;

component decoder is
port(
				data_in      : in std_logic_vector (3 downto 0); 
				segments_out : out std_logic_vector (6 downto 0)
				);
end component decoder;


signal clk_tank, clk_bullet : std_logic;
signal x_tank_pos, y_tank_pos : natural;
signal x_bul_pos, y_bul_pos   : natural;
signal score_disp : std_logic_vector (3 downto 0); 
signal enable : std_logic; -- from keyboard
signal speed : std_logic_vector(1 downto 0); -- from keyboard

begin
	enable <= '0'; -- input from the keyboard: shoot a bullet 
	speed <= "11"; -- input from the keyboard: tank speed
	

	tank : draw_a_tank
		port map(clk_tank, reset, x_tank_pos, y_tank_pos);
		
	bullet: bullet_generator
		port map(clk_bullet, reset, enable, x_tank_pos, y_tank_pos, x_bul_pos, y_bul_pos);
	
	draw  : VGA_top_level
		port map(clock, reset, x_tank_pos, y_tank_pos, x_bul_pos, y_bul_pos, VGA_R, VGA_G, VGA_B,H_SYNC, V_SYNC, VGA_BLANK_control, VGA_Clock);
	
	--draw2  : VGA_top_level
	--	port map(clock, reset, 480 - x_bul_pos, 640 - y_bul_pos, not VGA_R, not VGA_G, not VGA_B, H_SYNC, V_SYNC, VGA_BLANK_control, VGA_Clock);
	
	score_counter: collision
		port map(clock, reset, x_tank_pos, y_tank_pos, x_bul_pos, y_bul_pos, score_disp);
		
	disp_score: leddcd 
		port map(score_disp, disp_LED);
	
	clks: clock_divider
		port map(clock, reset, speed, clk_tank, clk_bullet); 
		
end architecture structural;