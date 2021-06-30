library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
entity datacache is
	port(
	addr: in std_logic_vector(4 downto 0);
	reset: in std_logic;
	data_write: in std_logic;
	clk: in std_logic;
	din: in std_logic_vector(31 downto 0);
	dout: out std_logic_vector(31 downto 0)
	);
end datacache;

architecture dcache_arch of datacache is
type RegArray is array (31 downto 0) of std_logic_vector(31 downto 0); 
signal Registers: RegArray;

begin

process(reset, clk)

begin
if(reset = '1') then
	for i in 0 to 31 loop
		Registers(i) <= (others => '0');
	end loop;\
elsif(clk'event and clk = '1') then
	if(data_write = '1') then
		Registers(conv_integer(addr)) <= din;
	end if;
end if;
end process;

dout <= Registers(conv_integer(addr));
end;
}
