library IEEE;
use IEEE.std_logic_1164.all;

entity signextender is
	port(
		func: in std_logic_vector(1 downto 0);
		input: in std_logic_vector(15 downto 0);
		output: out std_logic_vector(31 downto 0)
);
end signextender;

architecture sign_arch of signextender is

begin

process(func)

begin
case func is 
	when "00" =>
	output <= input & "0000000000000000";
	when "01"|"10" =>
		output <= (others => input(15)); 
		output(15 downto 0) <= input;
	when others =>
		output <= "0000000000000000" & input;

end case;

end process;

end sign_arch;
