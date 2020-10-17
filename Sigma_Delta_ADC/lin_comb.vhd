library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity lin_comb is
	generic (
		initial : real;
		coeffA : real;
		coeffB : real 
			);
	port(
		inputA: in real;
		inputB: in real;
		output: out real:= initial
		);
end entity lin_comb;

architecture behav of lin_comb is

begin
		output<=inputA*coeffA+inputB*coeffB;
end architecture;
