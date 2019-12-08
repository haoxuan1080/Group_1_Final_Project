library IEEE;

use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity VGA_test is
	port(
			CLOCK_50 										: in std_logic;
			RESET_N											: in std_logic;
--			en													: in std_logic;
			
			game_state: in std_logic_vector (1 downto 0);
			
			T1x, T1y, T2x, T2y, B1x, B1y, B2x, B2y: IN std_logic_vector (9 downto 0); --INPUT
	
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
--signal T1x, T1y, T2x, T2y, B1x, B1y, B2x, B2y : std_logic_vector(9 downto 0);
--signal en: std_logic;
component pixelGenerator is
		port(
			clk,  rst_n: in std_logic;
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

component BramWr is
	port (
		clk, rst_n: in std_logic;
		row: out std_logic_vector(9 downto 0);
   		col: out std_logic_vector(9 downto 0);
		we: out std_logic	
	);
end component BramWr;

component bram_2p is
	port(
		r_addr: in std_logic_vector (18 downto 0);
    		w_addr: in std_logic_vector (18 downto 0);
		clk: in std_logic;
		we: in std_logic;
		d: in std_logic_vector (2 downto 0);
		q: out std_logic_vector (2 downto 0)	
	);
end component bram_2p;

function Ord2addr (row: std_logic_vector; col: std_logic_vector) return std_logic_vector is
        variable addr: std_logic_vector (19 downto 0);
        variable addr_u: unsigned (19 downto 0);
begin
        addr_u:=unsigned(row)*640+unsigned(col);
        addr:=std_logic_vector(addr_u);
        return addr(18 downto 0);
end function Ord2addr;
signal d, q : std_logic_vector(2 downto 0);
signal raddr, waddr :std_logic_vector(18 downto 0);
signal we: std_logic;
signal w_row, w_col: std_logic_vector (9 downto 0);
signal color: std_logic_vector(23 downto 0);
begin
	VGA_RED<=color(23 downto 16);
	VGA_GREEN<=color(15 downto 8);
	VGA_BLUE<=color(7 downto 0);
	Bram_wr: BramWr port map (CLOCK_50, RESET_N, w_row, w_col, we);
	waddr<=Ord2addr(w_row, w_col);
	raddr<=Ord2addr(pixel_row_int, pixel_column_int);
	colors : colorDecoder
		port map(q, color);
	bram: bram_2p port map (raddr, waddr, CLOCK_50, we, d, q);	
--------------------------------------------------------------------------------------------

	videoGen : pixelGenerator
		port map(CLOCK_50 , RESET_N, game_state, T1x, T1y, T2x, T2y, B1x, B1y, B2x, B2y, w_row, w_col, d); --VGA_RED, VGA_GREEN, VGA_BLUE);
		
--------------------------------------------------------------------------------------------

	videoSync : VGA_SYNC
		port map(CLOCK_50, HORIZ_SYNC, VERT_SYNC, video_on_int, VGA_clk_int, eof, pixel_row_int, pixel_column_int);

	VGA_BLANK <= video_on_int;

	VGA_CLK <= VGA_clk_int;


--------------------------------------------------------------------------------------------	

end architecture structural;
