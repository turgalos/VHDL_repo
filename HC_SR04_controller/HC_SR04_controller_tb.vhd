library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;
use ieee.math_real.all;
use std.env.all;

entity HC_SR04_controller_tb is
end HC_SR04_controller_tb;

architecture behav of HC_SR04_controller_tb is
   constant  F_CLK : positive:=100;  --[Mhz] 
   constant  T_CLK : time :=10ns;   --1000ns dla 1MHZ,     10ns dla 100MHZ
   constant  N : positive:=16; --liczba bitów na której zapisywana jest wyliczona odleg?o??
   constant  trig_lg : positive :=1000;   ------zmienna do zliczania impulsu trig:=10 dla 1MHZ	:=1000 dla 100MHZ	
   constant  Increment : delay_length:=10 us; -- output time interval
   constant  Line_nRand: boolean:=true; --false - losowa odleg?osc
   constant ResReal: real:=1.0e-12; 
   constant t_mm: real:=2.9e-3; --czas trwania jednego milimetra w ns
   signal clk : std_logic := '0';  --clk i reset
   signal rst : std_logic := '1'; 
   signal start_comp: std_logic:='0'; --pocz?tek dzia?ania kontorlera
   signal bin: std_logic_vector(N-1 downto 0); --binarna warto?? odleg?o?ci
   signal echo: std_logic; --echo czujnika
   signal trig: std_logic; --trig czujnika
   signal err: real:=0.0;   --wzgl?dny b??d pomiarowy[%]
   signal flag : integer := 0;
   signal echo_cnt : real :=0.0;   --licznik zegara
   signal echo_clk : std_logic :='0';
   signal echo_p : std_logic :='0';
   signal echo_t : std_logic :='0';


   component HC_SR04
	  generic(Increment: delay_length; -- output time interval
               Line_nRand: boolean); -- type of simulation 
      port(trig: in std_logic;
           echo: out std_logic);
	end component;


--procedura liczaca blad wzgledny 
procedure err_cntr(signal bin: in std_logic_vector; signal echo_cnt: in real; signal f: out real) is
    variable error: real:=0.0;
	variable s: real:=0.0;
    variable s_mm: real:=0.0;
	begin
		error:= 0.0;
		s:= real(to_integer(unsigned(bin)));
		s_mm:=echo_cnt/2900.0;
		error:= (abs(s_mm-s)/s_mm)*100.0;
        f<=error; 
 end procedure;



begin

uut_controller: entity work.HC_SR04_controller 
    generic map(
		  F_CLK => F_CLK,
		  N => N,
		  trig_lg => trig_lg
		  )
  port map(
	   clk => clk,
	   rst => rst,
	   start_comp => start_comp,
	   bin => bin,
  	   trig=>trig,
       echo => echo
  	   );

HC_SR04_intst: HC_SR04
    generic map(
       	  Increment => Increment,
    	  Line_nRand => Line_nRand
		  )
    port map(
	   trig=>trig,
       echo => echo
  	   );

--generacja zegara
clk_process: process begin
    wait for t_clk/2;    
    clk <= not clk;
end process clk_process;

--reset ukladu na poczatku symulacji
reset_process: process begin
   rst <= '1';
   wait for 10 ns;    
   rst <= '0';
   wait; 
end process reset_process;

--zalaczenia ukladu co 38ms
start_process: process 
begin
	rst<='1';
    wait for 15ns;
	rst<='0';
    start_comp<='1' ;
    wait for 20ns;   --dla 100MHz
	--wait for 2ms;		--dla 1MHz

	start_comp<='0' ;
	wait for 38ms;
end process;


error_cntr: process (bin)
    variable error: real:=0.0;
     begin
		if flag>1 then

			err_cntr(bin,echo_cnt,err);
			report "Blad wzgledny:" & to_string(integer(err)) & "%" severity Warning;
 
		end if;
			flag<= flag+1;
end process;

echo_cntr_process: process (echo_clk)
begin
	if rising_edge(echo_clk) then
	  if echo='1' then 
		echo_cnt<=echo_cnt+1.0; 
		echo_t<='1';
	  end if;
	  if echo='0' then 
		 echo_t<='0';
	  end if;
      if echo_p='0' and echo_t='1' then 
		 echo_cnt<=0.0;
	  end if;
	echo_p<=echo_t;
	end if; 

end process echo_cntr_process;

echo_clk_process: process begin
    wait for 0.5*1ns;    
    echo_clk <= not echo_clk;
end process echo_clk_process;


end architecture;