library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bram_2p is
	port(
		r_addr: in std_logic_vector (18 downto 0);
    		w_addr: in std_logic_vector (18 downto 0);
		clk: in std_logic;
		we: in std_logic;
		d: in std_logic_vector (2 downto 0);
		q: out std_logic_vector (2 downto 0)	
	);
end bram_2p;

architecture rtl of bram_2p is
	type mem_type is array (0 to 307199) of std_logic_vector (2 downto 0);
	signal mem: mem_type;
	signal rd_addr: std_logic_vector (18 downto 0);
begin
	q<=mem(to_integer(unsigned(rd_addr)));
	process (clk)
	begin
		if rising_edge(clk) then
			rd_addr<=r_addr;
			if (we='1') then
				mem(to_integer(unsigned(w_addr)))<=d;
			end if;
		end if;
	end process;
end rtl;
