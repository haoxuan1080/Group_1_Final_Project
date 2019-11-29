library IEEE;

use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity VGA_test is
	port(
			CLOCK_50 										: in std_logic;
			RESET_N											: in std_logic;
	
			--VGA 
			VGA_RED, VGA_GREEN, VGA_BLUE 					: out std_logic_vector(7 downto 0); 
			HORIZ_SYNC, VERT_SYNC, VGA_BLANK, VGA_CLK		: out std_logic

		);
end entity VGA_test;

architecture structural of VGA_test is

component VGA_SYNC is
	port(
			clock_50Mhz										: in std_logic;
			horiz_sync_out, vert_sync_out, 
			video_on, pixel_clock, eof						: out std_logic;												
			pixel_row, pixel_column						    : out std_logic_vector(9 downto 0)
		);
end component VGA_SYNC;

component freq_div is
	port(
		clk: in std_logic;
    		rst_n: in std_logic;
		en_out: out std_logic
	);
end component freq_div;


--Signals for VGA sync
signal pixel_row_int 										: std_logic_vector(9 downto 0);
signal pixel_column_int 									: std_logic_vector(9 downto 0);
signal video_on_int											: std_logic;
signal VGA_clk_int											: std_logic;
signal eof													: std_logic;
signal T1x, T1y, T2x, T2y, B1x, B1y, B2x, B2y : std_logic_vector(9 downto 0);
signal en: std_logic;

component pixelGenerator is
		port(
			clk,  rst_n: in std_logic;
			T1x, T1y, T2x, T2y, B1x, B1y, B2x, B2y: std_logic_vector (9 downto 0);
			pixel_row, pixel_column : in std_logic_vector(9 downto 0);
			red_out, green_out, blue_out : out std_logic_vector(7 downto 0)
		);
end component pixelGenerator;

begin

	div: freq_div port map (CLOCK_50 , RESET_N, en);
--------------------------------------------------------------------------------------------

	videoGen : pixelGenerator
		port map(CLOCK_50 , RESET_N, T1x, T1y, T2x, T2y, B1x, B1y, B2x, B2y, pixel_row_int, pixel_column_int, VGA_RED, VGA_GREEN, VGA_BLUE);

--------------------------------------------------------------------------------------------
--This section should not be modified in your design.  This section handles the VGA timing signals
--and outputs the current row and column.  You will need to redesign the pixelGenerator to choose
--the color value to output based on the current position.

	videoSync : VGA_SYNC
		port map(CLOCK_50, HORIZ_SYNC, VERT_SYNC, video_on_int, VGA_clk_int, eof, pixel_row_int, pixel_column_int);

	VGA_BLANK <= video_on_int;

	VGA_CLK <= VGA_clk_int;

	proc: process(CLOCK_50 , RESET_N	) 
	begin
		if (RESET_N	= '0') then
			T1x<=std_logic_vector(to_unsigned(0, 10));
			T1y<=std_logic_vector(to_unsigned(100, 10));
			
			T2x<=std_logic_vector(to_unsigned(640, 10));
			T2y<=std_logic_vector(to_unsigned(300, 10));
			
			B1x<=std_logic_vector(to_unsigned(0, 10));
			B1y<=std_logic_vector(to_unsigned(150, 10));
			
			B2x<=std_logic_vector(to_unsigned(640, 10));
			B2y<=std_logic_vector(to_unsigned(250, 10));
		elsif (rising_edge(CLOCK_50 )) then
			if(en='1') then
				if(T1x=std_logic_vector(to_unsigned(640, 10))) then
					T1x<=std_logic_vector(to_unsigned(0, 10));
				else 
					T1x<=std_logic_vector(unsigned(T1x)+2);
				end if;
				if(T2x=std_logic_vector(to_unsigned(640, 10))) then
					T2x<=std_logic_vector(to_unsigned(0, 10));
				else 
					T2x<=std_logic_vector(unsigned(T1x)+2);
				end if;
				B1x<=T1x;
				B2x<=T2x;
			end if;
		end if;

	end process;

--------------------------------------------------------------------------------------------	

end architecture structural;
