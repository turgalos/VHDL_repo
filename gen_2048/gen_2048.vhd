library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity gen_2048 is
  Port(
      clk100MHz 	: in std_logic ;
      enable 		: in std_logic ;
      fout 			: out std_logic 
  );
end gen_2048;

architecture behav of gen_2048 is
	signal wyj  : std_logic :='0';
	signal cntr : integer   :=0;

	
begin   
	fout <= wyj;
--generator zegara
cntr_process: process (clk100MHz)
 begin
	if rising_edge(clk100MHz)then
		if enable='0' then
		cntr<=0;
		else 
			if enable='1' then
				if cntr>=0 and cntr<=22 then
				wyj<='0';
				cntr<=cntr+1;
				elsif cntr>22 and cntr<=46  then
				wyj<='1';
				cntr<=cntr+1;
				elsif cntr>46 then
				wyj<='0';
				cntr<=0;
				end if;
			end if;
		end if;
	end if;

end process cntr_process;

end behav;
