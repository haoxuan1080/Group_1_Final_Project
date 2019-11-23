library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pixelGenerator is
	port(
			clk, ROM_clk, rst_n, video_on, eof 				: in std_logic;
	--		xx , yy													: in natural;
			T1x, T1y, T2x, T2y, B1x, B1y, B
	
			pixel_row, pixel_column						    : in std_logic_vector(9 downto 0);
		
			red_out, green_out, blue_out					: out std_logic_vector(7 downto 0)
		);
end entity pixelGenerator;

architecture behavioral of pixelGenerator is

constant color_red 	 	 : std_logic_vector(2 downto 0) := "000";
constant color_green	 : std_logic_vector(2 downto 0) := "001";
constant color_blue 	 : std_logic_vector(2 downto 0) := "010";
constant color_yellow 	 : std_logic_vector(2 downto 0) := "011";
constant color_magenta 	 : std_logic_vector(2 downto 0) := "100";
constant color_cyan 	 : std_logic_vector(2 downto 0) := "101";
constant color_black 	 : std_logic_vector(2 downto 0) := "110";
constant color_white	 : std_logic_vector(2 downto 0) := "111";
	
component colorDecoder is
	port
	(
		address		: in std_logic_vector (2 downto 0);
		q			: out std_logic_vector (23 downto 0)
	);
end component colorDecoder;


signal pixel_row_int, pixel_column_int 				: natural;
signal colorAddress : std_logic_vector (2 downto 0);
signal color        : std_logic_vector (23 downto 0);


begin

--------------------------------------------------------------------------------------------
	
	red_out <= color(23 downto 16);
	green_out <= color(15 downto 8);
	blue_out <= color(7 downto 0);


	pixel_row_int <= to_integer(unsigned(pixel_row));
	pixel_column_int <= to_integer(unsigned(pixel_column));
	
--------------------------------------------------------------------------------------------	

	colors : colorDecoder
		port map(colorAddress,color);
--------------------------------------------------------------------------------------------	

	pixelDraw : process(clk, rst_n) is
	
	begin
	
		if (rst_n = '0')then
			colorAddress <= color_white; 
			
		elsif (rising_edge(clk)) then
			if ((abs(pixel_row_int - yy) < 10) and (abs(pixel_column_int -xx) < 20)) then
			--if ((pixel_row_int < 60) and (pixel_row_int > 50)  and (pixel_column_int > 100) and (pixel_column_int < 120)) then
				colorAddress <= color_green;
			else
				colorAddress <= color_white;
			end if;
			
		end if;
		
	end process pixelDraw;	

--------------------------------------------------------------------------------------------
	
end architecture behavioral;		
