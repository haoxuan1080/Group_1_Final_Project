library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Bullet_tb is

end Bullet_tb;

architecture structural of Bullet_tb is
	component bullet is
	port (
		clk, rst_n, en: in std_logic;
   		shoot: in std_logic;
		collision: in std_logic;
		Trow_in, Tcol_in: in std_logic_vector (9 downto 0);
		row_out, col_out: out std_logic_vector (9 downto 0)
	);
	end component bullet;
	signal clk, rst_n, en, shoot, collision: std_logic;
	signal Trow_in, Tcol_in: std_logic_vector (9 downto 0);
	signal row_out, col_out: std_logic_vector (9 downto 0);
begin
	dut: bullet port map (clk, rst_n, en, shoot, collision, Trow_in, Tcol_in, row_out, col_out);
	clk_proc: process 
	begin
		clk<='1';
		wait for 5 ns;
		clk<='0';
		wait for 5 ns;
	end process;

	en_proc: process
	begin
		en<='0';
		wait for 100 ns;
		en<='1';
wait for 5 ns;
en<='0';
wait for 5 ns;
en<='1';
wait for 50 ns;
en<='0';
wait for 50 ns;
en<='1';
		wait for 500 ns;
		--en<='0';
		wait for 100 ns;
		en<='1';
		wait;
	end process;

	Tank_proc: process
	begin
		Trow_in<=std_logic_vector(to_unsigned(100, 10));
		Tcol_in<=std_logic_vector(to_unsigned(50, 10));
		loop
			if en='1'  then
				if unsigned(Tcol_in)>640 then
					Tcol_in<=std_logic_vector(to_unsigned(100, 10));
				else
					Tcol_in<=std_logic_vector(unsigned(Tcol_in)+to_unsigned(10,10));
				end if;
			end if;	
			wait until rising_edge(clk);
		end loop;
	end process;

	tb_proc: process
	begin
		rst_n<='0';
		shoot<='0';
		collision<='0';
		wait for 6 ns;
		rst_n<='1';
		wait for 100 ns;
		shoot<='1';
		wait for 10 ns;
		shoot<='0';
		wait until row_out=Trow_in;
		wait for 10 ns;
		shoot<='1';
		wait for 10 ns;
		shoot<='0';
		wait for 50 ns;
		collision<='1';
		wait for 10 ns;
		collision<='0';
		wait;



	end process;
end structural;
