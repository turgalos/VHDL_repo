library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity z_delay is
	generic (
		initial : real;
		count : integer
			);
	port(
		input: in real;
		clk: in std_logic;
		output: out real:= initial
			);
end entity z_delay;

architecture behav of z_delay is
	type holds_array is array ( 0 to count ) of real;
	signal holds : holds_array := (others => initial);

begin
   process(clk)
  begin
    --if rising_edge(clk) then
    	holds(0)<=(input);
		for i in count downto 1 loop 
			holds(i)<=holds(i-1);
		end loop;
      --output<=holds(count-2);
	  output<=holds(count-1);

    --end if;


  end process;




end architecture;
