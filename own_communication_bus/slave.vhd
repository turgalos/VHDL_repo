LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all;
USE ieee.math_real.all;
USE std.textio.all;


ENTITY slave IS
  PORT(
    clk       : IN    STD_LOGIC;
	master_in : IN    STD_LOGIC;
	reset     : IN    STD_LOGIC;
    data      : IN    STD_LOGIC_VECTOR (7 DOWNTO 0); 
	enable	  : OUT   STD_LOGIC;
	slave_out : OUT   STD_LOGIC;
	clk_out   : OUT   STD_LOGIC
		);                
           
END slave;

ARCHITECTURE behav OF slave IS


SIGNAL input_data     : std_logic_vector (7 DOWNTO 0)  := "00000000";

signal clk_cntr  : integer :=0;
signal data_cntr  : integer :=7;
signal transmit_flag  : std_logic :='1';
signal confirm_flag  : std_logic :='0';


BEGIN
clk_out<=clk;
input_data<=data;
	

process (clk)
begin

if rising_edge(clk) then 
	if reset='1' then 	--reset
			clk_cntr<=0;
			data_cntr<=7;
			transmit_flag<='1';
			enable<='1';
		end if;
	
	if reset='0' and transmit_flag='1' then 	--send
		enable<='0';
		if clk_cntr>=1 and clk_cntr<2 then
			if master_in='0' then 			--if master = 0 - no transmission
				transmit_flag<='0';
			end if;
		end if;
		if clk_cntr>=2 and clk_cntr<3 then
			slave_out<='1';
		end if;

		if clk_cntr>=3 and clk_cntr<11 then  --8 15
			slave_out<=input_data (data_cntr);			--temp(8bitow)		
			data_cntr<=data_cntr-1;
		end if;

		if clk_cntr>=11 and clk_cntr<12 then		-- 1 - confirm
			slave_out<='1';
		end if;
		
		if clk_cntr>=12 and clk_cntr<13 then
			slave_out<='0';
			if master_in='1' then 			
				confirm_flag<='1';				--after 1st cycle
			end if;
		end if;


	clk_cntr<=clk_cntr+1;
	end if;
	
	if clk_cntr>=13 then		--end of transmission
	clk_cntr<=0;	
	data_cntr<=7;
	end if;

end if;

end process;
   
END ARCHITECTURE behav;
