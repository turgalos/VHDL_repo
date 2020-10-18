LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all;
USE ieee.math_real.all;
USE std.textio.all;


ENTITY master IS
  PORT(
    clk       : IN    STD_LOGIC;
	reset     : IN    STD_LOGIC;
	slave_in  : IN    STD_LOGIC;
	master_out: OUT   STD_LOGIC;
    data      : OUT   STD_LOGIC_VECTOR (7 DOWNTO 0);
	reset_out : OUT   STD_LOGIC;
	clk_out   : OUT   STD_LOGIC
		);                
           
END master;

ARCHITECTURE behav OF master IS


SIGNAL recived_data     : std_logic_vector (7 DOWNTO 0)  := "00000000";

signal clk_cntr  : integer :=0;
signal data_cntr  : integer :=7;
signal transmit_flag  : std_logic :='1';
signal confirm_flag  : std_logic :='0';
signal nic  : std_logic :='0';
signal transmit_flag1  : std_logic :='1';
signal transmit_flag2  : std_logic :='0';


BEGIN
	

clk_out<=clk;
	

process (clk)
begin

if rising_edge(clk) then 
	if reset='1' then 	--reset
			clk_cntr<=0;
			data_cntr<=7;
			transmit_flag<='1';
			reset_out<='1';
		end if;
	
	if reset='0' and transmit_flag='1' then 	--send
		reset_out<='0';

		if clk_cntr>=1 and clk_cntr<2 then
			master_out<='1';

		end if;
		if clk_cntr>=2 and clk_cntr<3 then
			if slave_in='0' then 			
				transmit_flag1<='0';
			else transmit_flag1<='1';
			end if;
				
		end if;
		if clk_cntr>=3 and clk_cntr<4 then
			if slave_in='0' then 			
				transmit_flag2<='0';
			else transmit_flag2<='1';
			end if;
		end if;

		if clk_cntr>=4 and clk_cntr<12 then  --
			recived_data(data_cntr)<=slave_in;								
			data_cntr<=data_cntr-1;
		end if;

		if clk_cntr>=12 and clk_cntr<13 then		-- 1 - confirm
			data<=recived_data;

			if slave_in/='1' or slave_in/='0'  then 			--if slave = Z - no connection
				confirm_flag<='1';
			end if;
		end if;
		
		if clk_cntr>=13 and clk_cntr<14 then
			master_out<='0';
		end if;

		if transmit_flag1/=transmit_flag2 then
			transmit_flag<='1';
		end if;
	clk_cntr<=clk_cntr+1;
	
	end if;
		
	if clk_cntr>=14 then		--end of transmission
	clk_cntr<=1;
	data_cntr<=7;
	end if;

end if;

end process;
   
END ARCHITECTURE behav;
