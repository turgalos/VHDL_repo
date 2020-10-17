library ieee;
use ieee.std_logic_1164.all;
use IEEE.MATH_REAL.all;

-- integrator Eulera w przód

entity adc is 
	generic (initial_log : std_logic:='0';
			 adc_threshold: real:=0.0
		);
	port(input: in real;
		output: out std_logic:=initial_log
		);

end entity adc;

architecture behav of adc is

begin 
--konwersja real na std_logic

process (input)
begin
	if (input>=adc_threshold) then
		output<='1';
	elsif (input<adc_threshold) then
		output<='0';
	end if;
end process;
end architecture;