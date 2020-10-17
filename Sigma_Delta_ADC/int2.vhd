library ieee;
use ieee.std_logic_1164.all;
use IEEE.MATH_REAL.all;

-- integrator Eulera w przód

entity int2 is 
	generic (initial : real:= 0.0);
	port(input: in real;
	 	   clk: in std_logic;
		output: out real:= initial);

end entity int2;

architecture behav of int2 is

component z_delay
  generic (
		initial : real;
		count : integer 
			);
	port(
		input: in real;
		clk: in std_logic;
		output: out real
			);
end component;

component lin_comb
  generic (
		initial : real;
		coeffA : real;
		coeffB : real
		);
	port(
		inputA: in real;
		inputB: in real;
		output: out real
		);
end component;


signal output_ZD: real;
signal output_LC: real;

begin 


comp1: lin_comb	
					   generic map ( initial, 1.0, 1.0)
					   port map (
							inputA=>input,
							inputB=>output_ZD,
							output=>output_LC
								);		

comp2: z_delay 
					   generic map (initial, 1)
					   port map (
							input=>output_LC,
							clk=>clk,
							output=>output_ZD
								);		
	
		output<=output_ZD;
end architecture;
