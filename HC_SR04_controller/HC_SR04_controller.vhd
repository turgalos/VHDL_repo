library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;
use ieee.math_real.all;


entity HC_SR04_controller is
  generic(
------interfejs uzytkownika
		  F_CLK: positive;
		  N: positive;
		  trig_lg: positive 
		  );
  port(
------interfejs uzytkownika
	   clk: in std_logic;
	   rst: in std_logic;
	   start_comp: in std_logic;
	   bin: inout std_logic_vector(N-1 downto 0);
	   
------interfejs czujnika
	   trig: inout std_logic;
       echo: inout std_logic
  	   );

end entity;

architecture behav of HC_SR04_controller is

 type state is (Setup,Triger_on,Triger_off,Measure,Save); --stany maszyny 
 signal fstate: state :=Setup; 
 signal dist_r: integer :=0; --obliczony dystans
 signal cntr: integer :=0; --licznik okresow zegara
 signal trig_cntr: integer:=1; --flaga pomiaru
 signal mm_flag: std_logic:='0'; --sygnal wewnetrzego clk
 constant Vd: real:=0.000344;
 signal mm_f_p: std_logic :='0';  --flaga do sprawdzania stanu wewnetrznego clk 
 signal mm_f_t: std_logic :='0';	--flaga do sprawdzania stanu wewnetrznego clk
 signal f_clk_cnt: integer ;	--licznik wewnetrznego clk


begin

fsm: process(clk,rst)

 begin  

if rst='1' then 
	fstate<=Setup;

elsif rising_edge(clk) then
  case fstate is
	when Setup => 
		cntr<=0;
		if start_comp ='1' then
		 fstate <= Triger_on;
		end if;
	when Triger_on=> 
		 trig<='1'; 
 		 trig_cntr<=trig_cntr+1;
			if trig_cntr>=trig_lg then
		 	fstate <= Triger_off;
			end if;
	when Triger_off=> 
		 trig<='0';
		 trig_cntr<=0;
		 fstate <= Measure; 
    when Measure => 
		if echo='1' then
				mm_f_t<=mm_flag;
 			if mm_f_p='0' and mm_f_t='1' then 
		 	cntr<=cntr+1;
	 		end if;
		end if;
		if echo='0' then 
		 fstate <= Save;
		end if;
		mm_f_p<=mm_f_t;
	when Save =>
 		 bin <= std_logic_vector(to_unsigned(cntr, N));
    	 fstate <= Setup;
  end case;
 end if;
end process;


prescaler: process(clk)
	variable presc_cntr: integer:=1;
 begin  
 if rising_edge(clk) then
 	presc_cntr:=presc_cntr+1;
		if presc_cntr>=f_clk_cnt then 
			mm_flag<= not mm_flag;
			presc_cntr:=1;
	end if;
 end if;
end process;

fclk_change: process (rst)
begin
 if f_clk=1 then
	 f_clk_cnt<=3;
 elsif f_clk=100 then
	 f_clk_cnt<=290;
 end if;
end process;



end architecture;