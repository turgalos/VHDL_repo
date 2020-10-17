library ieee;
use ieee.std_logic_1164.all;
use IEEE.MATH_REAL.all;

-- integrator Eulera w przód

entity dac is 
	generic (initial : real:=0.0
		);
	port(input: in std_logic;
		output: out real:=initial
		);

end entity dac;

architecture behav of dac is


begin 
--konwersja std_logic na real o warto?ciach 1 i -1

process (input)
begin
	if (input='0') then
		output<=-1.0;
	elsif (input='1') then
		output<=1.0;
	end if;
end process;
end architecture;
