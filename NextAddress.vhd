library ieee;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_SIGNED.ALL;
use IEEE.numeric_std.all;

entity next_address is
port(rt, rs : in std_logic_vector(31 downto 0);
 -- two register inputs
 pc : in std_logic_vector(31 downto 0);
 target_address : in std_logic_vector(25 downto 0);
 branch_type : in std_logic_vector(1 downto 0);
 pc_sel : in std_logic_vector(1 downto 0);
 next_pc : out std_logic_vector(31 downto 0));
end next_address ;

architecture next_address_arch of next_address is
signal branch_out, target_address_padded, beq_out, bne_out, bltz_out : std_logic_vector(31 downto 0);



begin

	--pc_sel process
	process(pc_sel, target_address, rs, branch_out)

	begin
	case PC_sel is
		when "01" =>
			next_pc <= "000000" & target_address;
		when "10" =>
			next_pc <= rs;
		when others =>
			--branch_type values
			next_pc <= branch_out;		
			
	end case;
	end process;	

	--branch_type process
	process(branch_type, pc, beq_out, bne_out, bltz_out)
	
	begin
	case branch_type is
		when "00" =>
			branch_out <= std_logic_vector(signed(pc) + "00000000000000000000000000000001");
		when "01" =>
			branch_out <= beq_out;
		when "10" =>
			branch_out <= bne_out;
		when others =>
			branch_out <= bltz_out;
	end case;
	end process;

	--bne process
	process(target_address, target_address_padded, pc, rs, rt)

	begin
	target_address_padded <= "000000" & target_address;
	if(signed(rs) /= signed(rt)) then
	bne_out <= std_logic_vector(signed(pc) + "00000000000000000000000000000001" + signed(target_address_padded));
	else
		bne_out <= std_logic_vector(signed(pc) + "00000000000000000000000000000001");
        end if;
	end process;

	--beq process
	process(target_address, target_address_padded, pc, rs, rt)

        begin
        target_address_padded <= "000000" & target_address;
        if(signed(rs) = signed(rt))then
        	beq_out <= std_logic_vector(signed(pc) + "00000000000000000000000000000001" + signed(target_address_padded));
        else
                beq_out <= std_logic_vector(pc + "00000000000000000000000000000001");      
        end if;
        end process;

	--bltz process
        process(rs, target_address, target_address_padded, pc)

        begin
        target_address_padded <= "000000" & target_address;
	if(signed(rs) < "00000000000000000000000000000000") then
        	bltz_out <= std_logic_vector(signed(pc) + "00000000000000000000000000000001" + signed(target_address_padded));
        else
                bltz_out <= std_logic_vector(signed(pc) + "00000000000000000000000000000001");      
        end if;
        end process;



end;


  
