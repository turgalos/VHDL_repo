LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all;
USE ieee.math_real.all;
USE std.textio.all;


ENTITY temp_sensor IS
  GENERIC (
	input_value : REAL := 25.56
		  );
  PORT(
    clk       : IN    STD_LOGIC;
	enable	  : IN    STD_LOGIC;
    data      : OUT  STD_LOGIC_VECTOR (7 DOWNTO 0)  
		);                
           
END temp_sensor;

ARCHITECTURE behav OF temp_sensor IS


SIGNAL temperature      : std_logic_vector (7 DOWNTO 0)  := "00000000";



BEGIN

process (clk)
begin

if rising_edge(clk) then 
	if enable='1' then 	--reset
			temperature <= "00000000";
		end if;
	
	if enable='0' then 	--conv & sent
			temperature <= std_logic_vector(to_signed(integer(input_value), 8));
			data<=temperature;
		end if;
	

end if;

end process;
   
END ARCHITECTURE behav;
