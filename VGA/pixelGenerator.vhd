library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.game_constant.all;

entity pixelGenerator is
	port(
			clk,  rst_n: in std_logic;
			T1x, T1y, T2x, T2y, B1x, B1y, B2x, B2y: std_logic_vector (9 downto 0);
			pixel_row, pixel_column : in std_logic_vector(9 downto 0);
			red_out, green_out, blue_out : out std_logic_vector(7 downto 0)
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

function InTank (row_int: integer; col_int: integer; T_x: std_logic_vector; T_y: std_logic_vector) return boolean is
	variable IsTank: boolean;
	variable T_x_int, T_y_int: integer;
begin
	IsTank:=False;
	T_x_int:=to_integer(unsigned(T_x));
	T_y_int:=to_integer(unsigned(T_y));
	if abs(T_x_int-col_int)<Tank_width/2 and abs(T_y_int-row_int)<Tank_Hight/2 then
		IsTank:=True;
	end if;
	return IsTank;
end function InTank;

function InBullet (row_int: integer; col_int: integer; B_x: std_logic_vector; B_y: std_logic_vector) return boolean is
	variable IsB: boolean;
	variable B_x_int, B_y_int: integer;
begin
	IsB:=False;
	B_x_int:=to_integer(unsigned(B_x));
	B_y_int:=to_integer(unsigned(B_y));
	if (row_int-B_y_int)*(row_int-B_y_int)+(col_int-B_x_int)*(col_int-B_x_int)<Bullet_Radius*Bullet_Radius then
                IsB:=True;
        end if;
	return IsB;
end function InBullet;
begin

--------------------------------------------------------------------------------------------
	
	red_out <= color(23 downto 16);
	green_out <= color(15 downto 8);
	blue_out <= color(7 downto 0);


	pixel_row_int <= to_integer(unsigned(pixel_row));
	pixel_column_int <= to_integer(unsigned(pixel_column));
	
--------------------------------------------------------------------------------------------	

	colors : colorDecoder
		port map(colorAddress, color);
--------------------------------------------------------------------------------------------	

	pixelDraw : process(clk, rst_n) is
	
	begin
	
		if (rst_n = '0')then
			colorAddress <= color_white; 
			
		elsif (rising_edge(clk)) then
			if (InTank(pixel_row_int, pixel_column_int, T1x, T1y)) then
				colorAddress<=color_magenta;
			elsif(InTank(pixel_row_int, pixel_column_int, T2x, T2y)) then
				colorAddress<=color_cyan;
			elsif(InBullet(pixel_row_int, pixel_column_int, B1x, B1y)) then
				colorAddress<=color_black;
			elsif(InBullet(pixel_row_int, pixel_column_int, B2x, B2y)) then
				colorAddress<=color_white;
			else
				colorAddress<=color_red;
			end if;	
		end if;
		
	end process pixelDraw;	

--------------------------------------------------------------------------------------------
	
end architecture behavioral;		
