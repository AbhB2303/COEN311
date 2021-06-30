library ieee;
use ieee.std_logic_1164.all;

entity pc is
	port(
	d: in std_logic_vector(31 downto 0);
	q: out std_logic_vector(31 downto 0);
	reset: in std_logic;
	clk: in std_logic
	);
end pc;

architecture pc_arch of pc is
begin
	process(clk, reset)
	begin
		if(reset = '1') then
			q <= (others => '0');
		elsif (clk'event and clk = '1') then
			q <= d;
		end if;
	end process;
end pc_arch;
