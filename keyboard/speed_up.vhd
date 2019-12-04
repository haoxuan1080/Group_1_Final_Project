LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity speed_up is

port(
keyboard_clk, keyboard_data, clock_50MHz, reset : in std_logic;--, read : in std_logic;
--ready :out std_logic;
shoot :out std_logic_vector(1 downto 0);
speed :out std_logic_vector(1 downto 0)

);
end entity speed_up;


architecture structural of speed_up is
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


--signal ready : std_logic;
signal speed_up, shoot_out : std_logic_vector(1 downto 0);
signal curr_code, disp_0, disp_1, disp_2, disp_3: std_logic_vector(7 downto 0);

begin 

key_out: ps2 port map(keyboard_clk, keyboard_data, clock_50MHz,reset, curr_code, ready, disp_3, disp_3, disp_1, disp_0);

speed <= speed_up;

speed_proc: process(curr_code)is --keep until next code in
begin
speed_up <= "00";
if(curr_code = "00011010")then --Z: 1A: tank1
	speed_up <= "01";
elsif (curr_code = "01001010")then --?/ : 4A: tank2
	speed_up <= "10";
else
	speed_up <= "00";
end if;
end process;

shoot <= shoot_out;

shoot_proc: process(curr_code)is --keep until next code in
begin
shoot_out <= "00";
if(curr_code = X"1C")then --A:: tank1
	shoot_out <= "01";
elsif (curr_code = X"52")then --"/ : 4A: tank2
	shoot_out <= "10";
else
	shoot_out <= "00";
end if;
end process;


end architecture;