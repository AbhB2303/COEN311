library IEEE;
use IEEE.std_logic_1164.all;

entity datapath is
	port(
	clk: in std_logic;
	reset: in std_logic;
	rs_out, rt_out : out std_logic_vector(31 downto 0);

	pc_out: out std_logic_vector(31 downto 0);
	overflow, zero: out std_logic);
end datapath;

architecture datapath_arch of datapath is

component PC 
port(	clk, reset: in std_logic; 
	d: in std_logic_vector(31 downto 0); 
	q: out std_logic_vector(31 downto 0));
end component;

component Icache
port(	address_input: in std_logic_vector(4 downto 0); 
	address_output: out std_logic_vector(31 downto 0));
end component;

component Dcache
port(	addr: in std_logic_vector(4 downto 0);
	reset, data_write, clk: in std_logic;
	din: in std_logic_vector(31 downto 0);
	dout: out std_logic_vector(31 downto 0));
end component;

component SignExtender
port(	func: in std_logic_vector(1 downto 0);
	input: in std_logic_vector(15 downto 0); 
	output: out std_logic_vector(31 downto 0)
);
end component;

component RegFile
port(	read_a, read_b, write_address: in std_logic_vector(4 downto 0); 
	din: in std_logic_vector(31 downto 0);
	reset, clk, write: in std_logic;
	out_a, out_b: out std_logic_vector(31 downto 0));
end component;

component ALU
port(	x, y: in std_logic_vector(31 downto 0);
	add_sub: in std_logic;
	func, logic_func: in std_logic_vector(1 downto 0);
	output: out std_logic_vector(31 downto 0);
	overflow, zero: out std_logic);
end component;

component Next_Address
port(	pc, rs, rt: in std_logic_vector(31 downto 0);
	target_address: in std_logic_vector(25 downto 0);
	branch_type, pc_sel: in std_logic_vector(1 downto 0);
	next_pc: out std_logic_vector(31 downto 0));
end component;


--signal declaration
signal din, qout, Icache_out, Dcache_out, SignExtender_out, RegInSrc_mux_out, outputA, outputB, alusrc_mux_out, alu_out: std_logic_vector(31 downto 0);
signal func_ctrl, ALUlogicfunc_ctrl, branchtype_ctrl, PCsel_ctrl: std_logic_vector(1 downto 0);
signal alusrc_ctrl, regdst_ctrl, RegInSrc_ctrl, AddSub_ctrl, regwrite_ctrl, DcacheDataWrite_ctrl, overflow_out, zero_out: std_logic;
signal writeaddr_mux_out: std_logic_vector(4 downto 0);
signal opcode, func: std_logic_vector(5 downto 0);
--configuration specification
for u1: Next_Address use entity WORK.next_address(next_address_arch);
for u2: ALU use entity WORK.alu(alu_arch);
for u3: RegFile use entity WORK.regfile(regfile_arch);
for u4: SignExtender use entity WORK.signextender(sign_arch);
for u5: Dcache use entity WORK.datacache(dcache_arch);
for u6: Icache use entity WORK.instructioncache(icache_arch);
for u7: PC use entity WORK.pc(pc_arch);


begin

--control unit process
process(opcode, func)

begin
case opcode is
	when "001111" =>
		regwrite_ctrl <= '1';
		regdst_ctrl <= '0';
		RegInSrc_ctrl <= '1';
		alusrc_ctrl <= '1';
		addsub_ctrl <= '0';
		dcachedatawrite_ctrl <= '0';
		alulogicfunc_ctrl <= "00";
		func_ctrl <= "00";
		branchtype_ctrl <= "00";
		pcsel_ctrl <= "00";
	when "001000" =>
                regwrite_ctrl <= '1';
                regdst_ctrl <= '0';
                RegInSrc_ctrl <= '1';
                alusrc_ctrl <= '1';
                addsub_ctrl <= '0';
                dcachedatawrite_ctrl <=	'0';
                alulogicfunc_ctrl <= "00";                      
                func_ctrl <= "10";
                branchtype_ctrl	<= "00";
                pcsel_ctrl <= "00";
	when "001010" =>
                regwrite_ctrl <= '1';
                regdst_ctrl <= '0';
                RegInSrc_ctrl <= '1';
                alusrc_ctrl <= '0';
                addsub_ctrl <= '1';
                dcachedatawrite_ctrl <=	'0';
                alulogicfunc_ctrl <= "00";                      
                func_ctrl <= "01";
                branchtype_ctrl	<= "00";
                pcsel_ctrl <= "00";
	when "001100" =>
                regwrite_ctrl <= '1';
                regdst_ctrl <= '0';
                RegInSrc_ctrl <= '1';
                alusrc_ctrl <= '0';
                addsub_ctrl <= '0';
                dcachedatawrite_ctrl <=	'0';
                alulogicfunc_ctrl <= "00";                      
                func_ctrl <= "11";
                branchtype_ctrl	<= "00";
                pcsel_ctrl <= "00";
	when "001101" =>
                regwrite_ctrl <= '1';
                regdst_ctrl <= '0';
                RegInSrc_ctrl <= '1';
                alusrc_ctrl <= '0';
                addsub_ctrl <= '0';
                dcachedatawrite_ctrl <=	'0';
                alulogicfunc_ctrl <= "01";                      
                func_ctrl <= "11";
                branchtype_ctrl	<= "00";
                pcsel_ctrl <= "00";
	when "001110" =>
		regwrite_ctrl <= '1';
                regdst_ctrl <= '0';
                RegInSrc_ctrl <= '1';
                alusrc_ctrl <= '0';
                addsub_ctrl <= '0';
                dcachedatawrite_ctrl <=	'0';
                alulogicfunc_ctrl <= "10";                      
                func_ctrl <= "11";
                branchtype_ctrl	<= "00";
                pcsel_ctrl <= "00";
	when "100011" =>
                regwrite_ctrl <= '1';
                regdst_ctrl <= '0';
                RegInSrc_ctrl <= '0';
                alusrc_ctrl <= '1';
                addsub_ctrl <= '0';
                dcachedatawrite_ctrl <=	'0';
                alulogicfunc_ctrl <= "10";                      
                func_ctrl <= "10";
                branchtype_ctrl	<= "00";
                pcsel_ctrl <= "00";
	when "101011" =>
                regwrite_ctrl <= '0';
                regdst_ctrl <= '1';
                RegInSrc_ctrl <= '0';
                alusrc_ctrl <= '1';
                addsub_ctrl <= '0';
                dcachedatawrite_ctrl <=	'1';
                alulogicfunc_ctrl <= "00";                      
                func_ctrl <= "00";
                branchtype_ctrl	<= "00";
                pcsel_ctrl <= "00";
	when "000010" =>
                regwrite_ctrl <= '0';
                regdst_ctrl <= '0';
                RegInSrc_ctrl <= '1';
                alusrc_ctrl <= '1';
                addsub_ctrl <= '0';
                dcachedatawrite_ctrl <=	'0';
                alulogicfunc_ctrl <= "00";                      
                func_ctrl <= "00";
                branchtype_ctrl	<= "00";
                pcsel_ctrl <= "01";
	when "000001" =>
                regwrite_ctrl <= '0';
                regdst_ctrl <= '0';
                RegInSrc_ctrl <= '1';
                alusrc_ctrl <= '1';
                addsub_ctrl <= '0';
                dcachedatawrite_ctrl <=	'0';
                alulogicfunc_ctrl <= "00";                      
                func_ctrl <= "00";
                branchtype_ctrl	<= "11";
                pcsel_ctrl <= "00";
	when "000100" =>
		regwrite_ctrl <= '0';
                regdst_ctrl <= '0';
                RegInSrc_ctrl <= '0';
                alusrc_ctrl <= '0';
                addsub_ctrl <= '0';
                dcachedatawrite_ctrl <=	'0';
                alulogicfunc_ctrl <= "00";                      
                func_ctrl <= "00";
                branchtype_ctrl	<= "01";
                pcsel_ctrl <= "00";
	when "000101" =>
                regwrite_ctrl <= '0';
                regdst_ctrl <= '0';
                RegInSrc_ctrl <= '1';
                alusrc_ctrl <= '1';
                addsub_ctrl <= '0';
                dcachedatawrite_ctrl <=	'0';
                alulogicfunc_ctrl <= "00";                      
                func_ctrl <= "00";
                branchtype_ctrl	<= "10";
                pcsel_ctrl <= "00";
	when others =>
		case func is
			when "100000" =>
	        	        regwrite_ctrl <= '1';
        	                regdst_ctrl <= '1';
                		RegInSrc_ctrl <= '1';
                		alusrc_ctrl <= '0';
                		addsub_ctrl <= '0';
                		dcachedatawrite_ctrl <=	'0';
                		alulogicfunc_ctrl <= "00";                      
                		func_ctrl <= "10";
                		branchtype_ctrl	<= "00";
                		pcsel_ctrl <= "00";
			when "100010" =>
                                regwrite_ctrl <= '1';
                                regdst_ctrl <= '1';
                                RegInSrc_ctrl <= '1';
                                alusrc_ctrl <= '0';
                                addsub_ctrl <= '1';
                                dcachedatawrite_ctrl <= '0';
                                alulogicfunc_ctrl <= "00";
                                func_ctrl <= "10";
                                branchtype_ctrl <= "00";
                                pcsel_ctrl <= "00";
			when "101010" =>
                                regwrite_ctrl <= '1';
                                regdst_ctrl <= '1';
                                RegInSrc_ctrl <= '1';
                                alusrc_ctrl <= '0';
                                addsub_ctrl <= '1';
                                dcachedatawrite_ctrl <= '0';
                                alulogicfunc_ctrl <= "00";
                                func_ctrl <= "01";
                                branchtype_ctrl <= "00";
                                pcsel_ctrl <= "00";
			when "100100" =>
                                regwrite_ctrl <= '1';
                                regdst_ctrl <= '1';
                                RegInSrc_ctrl <= '1';
                                alusrc_ctrl <= '0';
                                addsub_ctrl <= '1';
                                dcachedatawrite_ctrl <= '0';
                                alulogicfunc_ctrl <= "00";
                                func_ctrl <= "11";
                                branchtype_ctrl <= "00";
                                pcsel_ctrl <= "00";
			when "100101" =>
                                regwrite_ctrl <= '1';
                                regdst_ctrl <= '1';
                                RegInSrc_ctrl <= '1';
                                alusrc_ctrl <= '0';
                                addsub_ctrl <= '0';
                                dcachedatawrite_ctrl <= '0';
                                alulogicfunc_ctrl <= "01";
                                func_ctrl <= "11";
                                branchtype_ctrl <= "00";
                                pcsel_ctrl <= "00";
			when "100110" =>
                                regwrite_ctrl <= '1';
                                regdst_ctrl <= '1';
                                RegInSrc_ctrl <= '1';
                                alusrc_ctrl <= '0';
                                addsub_ctrl <= '0';
                                dcachedatawrite_ctrl <= '0';
                                alulogicfunc_ctrl <= "10";
                                func_ctrl <= "11";
                                branchtype_ctrl <= "00";
                                pcsel_ctrl <= "00";
			when "100111" =>
                                regwrite_ctrl <= '1';
                                regdst_ctrl <= '1';
                                RegInSrc_ctrl <= '1';
                                alusrc_ctrl <= '0';
                                addsub_ctrl <= '0';
                                dcachedatawrite_ctrl <= '0';
                                alulogicfunc_ctrl <= "11";
                                func_ctrl <= "11";
                                branchtype_ctrl <= "00";
                                pcsel_ctrl <= "00";
			when "001000" =>
                                regwrite_ctrl <= '0';
                                regdst_ctrl <= '1';
                                RegInSrc_ctrl <= '1';
                                alusrc_ctrl <= '1';
                                addsub_ctrl <= '0';
                                dcachedatawrite_ctrl <= '0';
                                alulogicfunc_ctrl <= "00";
                                func_ctrl <= "00";
                                branchtype_ctrl <= "00";
                                pcsel_ctrl <= "10";
			when others =>
	                        regwrite_ctrl <= '0';
                                regdst_ctrl <= '0';
                                RegInSrc_ctrl <= '0';
                                alusrc_ctrl <= '0';
                                addsub_ctrl <= '0';
                                dcachedatawrite_ctrl <= '0';
                                alulogicfunc_ctrl <= "00";
                                func_ctrl <= "00";
                                branchtype_ctrl <= "00";
                                pcsel_ctrl <= "00";
			end case;
end case;



end process;


--define multiplexer for alusrc
with alusrc_ctrl select
	alusrc_mux_out <= outputB when '0',
			  SignExtender_out when others;

--define multiplexer for write_address
with regdst_ctrl select
	writeaddr_mux_out <= Icache_out(20 downto 16) when '0',
			     Icache_out(15 downto 11) when others;
--define multiplexer for Reg_In_Src
with RegInSrc_ctrl select
	RegInSrc_mux_out <= Dcache_out when '0',
			    alu_out when others;

u1: Next_Address port map (qout, outputA, outputB, Icache_out(25 downto 0), branchtype_ctrl, PCsel_ctrl, din);
u2: ALU port map (outputA, alusrc_mux_out, AddSub_ctrl, func_ctrl, ALUlogicfunc_ctrl, ALU_out, overflow_out, zero_out);
u3: RegFile port map ( Icache_out(25 downto 21), Icache_out(20 downto 16), writeaddr_mux_out, RegInSrc_mux_out, reset, clk, regwrite_ctrl, outputa, outputb);
u4: SignExtender port map (func_ctrl, Icache_out(15 downto 0), SignExtender_out);
u5: Dcache port map (alu_out(4 downto 0), reset, DcacheDataWrite_ctrl, clk, outputB, Dcache_out);
u6: Icache port map (qout(4 downto 0), Icache_out);
u7: PC port map (clk, reset, din, qout);

rs_out <= outputA;
rt_out <= outputB;
overflow <= overflow_out;
zero <= zero_out;
pc_out <= qout;
opcode <= Icache_out(31 downto 26);
func <= Icache_out(5 downto 0);

end datapath_arch;
