-- 32 x 32 register file
-- two read ports, one write port with write enable
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity regfile is
port(   din : in std_logic_vector(31 downto 0);
        reset : in std_logic;
        clk : in std_logic;
        write : in std_logic;
        read_a : in std_logic_vector(4 downto 0);
        read_b : in std_logic_vector(4 downto 0);
        write_address : in std_logic_vector(4 downto 0);
        out_a : out std_logic_vector(31 downto 0);
        out_b : out std_logic_vector(31 downto 0));
end regfile ;

architecture regfile_arch of regfile is

type RegArray is array (31 downto 0) of std_logic_vector(31 downto 0);
signal Registers: RegArray;

begin

process(reset, clk)

begin
if (reset = '1') then
        for i in 0 to 31 loop
                Registers(i) <= (others => '0');
        end loop;
elsif (clk'event and clk = '1') then
        if(write = '1') then
        Registers(conv_integer(write_address)) <= din;
	end if;
end if;

end process;

out_a <= Registers(conv_integer(read_a));
out_b <= Registers(conv_integer(read_b));


end architecture;


