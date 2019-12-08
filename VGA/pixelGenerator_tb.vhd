library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity pixelGenerator_tb is

end pixelGenerator_tb;

architecture structural of pixelGenerator_tb is
	component pixelGenerator is
	port(
		clk, rst_n: in std_logic;
		game_state: in std_logic_vector (1 downto 0);
		T1x, T1y, T2x, T2y, B1x, B1y, B2x, B2y: std_logic_vector (9 downto 0);
		pixel_row, pixel_column : in std_logic_vector(9 downto 0);
		color_addr: out std_logic_vector (2 downto 0)
		--red_out, green_out, blue_out : out std_logic_vector(7 downto 0)
	);
	end component pixelGenerator;
	component colorDecoder is
	port
	(
		address		: in std_logic_vector (2 downto 0);
		q			: out std_logic_vector (23 downto 0)
	);
	end component colorDecoder;
	signal clk,  rst_n : std_logic;
	signal row, col, T1x, T1y, T2x, T2y,B1x,B1y, B2x, B2y: std_logic_vector (9 downto 0);
	signal red_out, green_out, blue_out: std_logic_vector (7 downto 0);
	SIGNAL COLOR_ADDR: STD_LOGIC_VECTOR(2 DOWNTO 0);	
	constant color_red 	 	 : std_logic_vector(2 downto 0) := "000";
	SIGNAL COLOR: STD_LOGIC_VECTOR (23 DOWNTO 0);
	constant color_green	 : std_logic_vector(2 downto 0) := "001";
	constant color_blue 	 : std_logic_vector(2 downto 0) := "010";
	constant color_yellow 	 : std_logic_vector(2 downto 0) := "011";
	constant color_magenta 	 : std_logic_vector(2 downto 0) := "100";
	constant color_cyan 	 : std_logic_vector(2 downto 0) := "101";
	constant color_black 	 : std_logic_vector(2 downto 0) := "110";
	constant color_white	 : std_logic_vector(2 downto 0) := "111";
begin
	dut: pixelGenerator
        port map(
                clk, rst_n,
		"00",
                T1x, T1y, T2x, T2y, B1x, B1y, B2x, B2y,
                row, col,
		cOLOR_ADDR);
                --red_out, green_out, blue_out);
	colors : colorDecoder
		port map(color_Addr, color);
	red_out <= color(23 downto 16);
	green_out <= color(15 downto 8);
	blue_out <= color(7 downto 0);
	clk_proc: process
	begin
		clk<='0';
		wait for 5 ns;
		clk<='1';
		wait for 5 ns;
	end process;

	tb_process: process
	begin
		T1x<=std_logic_vector(to_unsigned(100, 10));
		T1y<=std_logic_vector(to_unsigned(90, 10));
		T2x<=std_logic_vector(to_unsigned(300, 10));
		T2y<=std_logic_vector(to_unsigned(310, 10));
		B1x<=std_logic_vector(to_unsigned(100, 10));
		B1y<=std_logic_vector(to_unsigned(200, 10));
		B2x<=std_logic_vector(to_unsigned(300, 10));
		B2y<=std_logic_vector(to_unsigned(200, 10));
		row<=std_logic_vector(to_unsigned(50, 10));
		col<=std_logic_vector(to_unsigned(50, 10));
		rst_n<='0';
		wait for 10 ns;
		rst_n<='1';
		wait until rising_edge(clk);
		wait for 1 ns;
		if red_out="00000000" and green_out="00000000" and blue_out="00000000" then
			report "the first location is correct";
		else
			report "Wrong, the color should be black but it is "& integer'image(to_integer(unsigned(red_out))) & integer'image(to_integer(unsigned(green_out))) & integer'image(to_integer(unsigned(blue_out)));
		end if;
		wait for 1 ns;
		row<=std_logic_vector(to_unsigned(100, 10));
                col<=std_logic_vector(to_unsigned(90, 10));
		wait until rising_edge(clk);
		wait for 1 ns;
		if red_out=("11111111") and green_out=("00000000") and blue_out=("00000000") then
                        report "the first location is correct";
                else
			report "Wrong, the color should be red but it is "& integer'image(to_integer(unsigned(red_out))) & integer'image(to_integer(unsigned(green_out))) & integer'image(to_integer(unsigned(blue_out)));
		end if;
		wait for 1 ns;
		row<=std_logic_vector(to_unsigned(200, 10));
                col<=std_logic_vector(to_unsigned(100, 10));
		wait until rising_edge(clk);
		wait for 1 ns;
		if red_out=("11111111") and green_out=("11111111") and blue_out=("00000000") then
                        report "the first location is correct";
                else
			report "Wrong, the color should be Yellow but it is "& integer'image(to_integer(unsigned(red_out))) & integer'image(to_integer(unsigned(green_out))) & integer'image(to_integer(unsigned(blue_out)));
		end if;
		wait;
	end process;

end structural;
