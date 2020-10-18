LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all;
USE ieee.math_real.all;
USE std.textio.all;


ENTITY UE1 IS
  GENERIC (
	clk_period : time := 100 ns 
		  );
  PORT(
    clk       : OUT    STD_LOGIC :='0' ;
	reset	  : OUT    STD_LOGIC ;
    data      : IN  STD_LOGIC_VECTOR (7 DOWNTO 0)  
		);                
           
END UE1;

ARCHITECTURE behav OF UE1 IS


BEGIN
	
clocking: process 
begin
clk<='0';
wait for clk_period/2 ;
clk<='1';
wait for clk_period/2 ;
end process;

reseting: process 
begin
reset<='1';
wait for 2*clk_period ;
reset<='0';
wait;
end process;
   
END ARCHITECTURE behav;
