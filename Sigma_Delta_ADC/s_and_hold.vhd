library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity s_and_hold is
	generic (
		initial : real;
		vec_length : integer
			);
	port(
		input: in std_logic_vector(vec_length-1 downto 0);
		clk: in std_logic;
		output: out real:= initial
			);
end entity s_and_hold;

architecture behav of s_and_hold is

begin

   process(clk)
  begin
    if rising_edge(clk) then
    	--output<=real(to_integer(signed(input)));
    	output<=(real(to_integer(signed(input)))/127.0);
    end if;
  end process;


end architecture;