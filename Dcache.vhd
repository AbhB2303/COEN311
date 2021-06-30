{\rtf1\ansi\ansicpg1252\cocoartf2580
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\margl1440\margr1440\vieww13440\viewh7800\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 library IEEE;\
use IEEE.std_logic_1164.all;\
use IEEE.std_logic_unsigned.all;\
entity datacache is\
	port(\
	addr: in std_logic_vector(4 downto 0);\
	reset: in std_logic;\
	data_write: in std_logic;\
	clk: in std_logic;\
	din: in std_logic_vector(31 downto 0);\
	dout: out std_logic_vector(31 downto 0)\
	);\
end datacache;\
\
architecture dcache_arch of datacache is\
type RegArray is array (31 downto 0) of std_logic_vector(31 downto 0); \
signal Registers: RegArray;\
\
begin\
\
process(reset, clk)\
\
begin\
if(reset = '1') then\
	for i in 0 to 31 loop\
		Registers(i) <= (others => '0');\
	end loop;\
elsif(clk'event and clk = '1') then\
	if(data_write = '1') then\
		Registers(conv_integer(addr)) <= din;\
	end if;\
end if;\
end process;\
\
dout <= Registers(conv_integer(addr));\
end;\
}