library ieee;
use ieee.std_logic_1164.all;
use IEEE.MATH_REAL.all;

entity sigma_delta is 
	generic (initial : real:= 0.0;
			vec_length : integer :=8;
			initial_log : std_logic:='0';
			adc_threshold : real:= 0.0
			);
	port(input: in real;
	 	   clk: in std_logic;
		  output: out std_logic:= initial_log
		);
end entity sigma_delta;

architecture behav of sigma_delta is


component int2
  generic (
		initial : real :=0.0
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



component adc
  generic (
		initial_log : std_logic;
 		adc_threshold : real
			);
	port(
		input: in real;
		output: out std_logic:=initial_log
			);
end component;

component dac
  generic (
		initial : real
			);
	port(
		input: in std_logic:=initial_log;
		output: out real
			);
end component;

signal output_int: real;
signal output_LC: real;
signal output_adc: std_logic;
signal output_dac: real;

begin 	

comp1: lin_comb	
					   generic map (initial, 1.0, -1.0)
					   port map (
							inputA=>input,
							inputB=>output_dac,
							output=>output_LC
								);		

comp2: int2 
					   generic map ( initial )
					   port map (
							input=>output_LC,
							clk=>clk,
							output=>output_int
								);	
comp3: adc 
					   generic map (initial_log, adc_threshold)
					   port map (
							input=>output_int,
							output=>output_adc
								);	

comp4: dac 
					   generic map (initial)
					   port map (
							input=>output_adc,
							output=>output_dac
								);
	
		

output<=output_adc;

end architecture;