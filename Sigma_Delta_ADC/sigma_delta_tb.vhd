library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;
use work.sine_package.all;

entity sigma_delta_tb is
end;

architecture bench of sigma_delta_tb is

component sine_wave
  port( clock, reset, enable: in std_logic;
        wave_out: out sine_vector_type);
end component;

component sigma_delta
  generic (
		initial : real;
		vec_length : integer;
		initial_log : std_logic
			);
	port(
		input: in real;
		clk: in std_logic;
		output: out std_logic
			);
end component;

component s_and_hold
  generic (
		vec_length : integer;
		initial : real 
			);
	port(
		input: in std_logic_vector(vec_length-1 downto 0);
		clk: in std_logic;
		output: out real
			);
end component;

  signal clock, reset, enable: std_logic;
  signal wave_out: sine_vector_type;
  constant clock_period: time := 10 ns; --10ns
  signal stop_the_clock: boolean;

  signal clock2: std_logic;
  constant clock2_period: time := 40 ns; 
  
  signal output_SH: real;  
  signal output_SD: std_logic;

  
  constant initial : real:=0.0;
  constant vec_length: integer:= 8;
  constant initial_log: std_logic:='0';
  constant adc_threshold : real:=0.0;

begin

  sine_gen: sine_wave port map ( clock, reset, enable, wave_out );

  SHcomp: s_and_hold	
					   generic map ( vec_length, initial)
					   port map (
							input=>wave_out,
							clk=>clock2,
							output=>output_SH
								);	
	uut: sigma_delta 
					   generic map ( initial, vec_length, initial_log)
					   port map (
							input=>output_SH,
							clk=>clock2,
							output=>output_SD
								);
	 
 stimulus: process
  begin
    enable <= '0';
    reset <= '1';
    wait for 5 ns;
    reset <= '0';
	wait for 10 ns;
    enable <= '1';
    wait for 1 ms;
    stop_the_clock <= true;
    wait;
  end process;

  clocking: process
  begin
    while not stop_the_clock loop
      clock <= '1', '0' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;

  clocking2: process
  begin
    while not stop_the_clock loop
      clock2 <= '1', '0' after clock2_period / 2;
      wait for clock2_period;
    end loop;
    wait;
  end process;

end;
