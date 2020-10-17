-------------------------------------------------
-- CCE 2019
-- HC-SR04 ultrasonic sensor
-- v.1 VHDL-2008
-------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;
use ieee.math_real.all;
use std.env.all;

entity HC_SR04 is
  generic(Increment: delay_length; -- output time interval
          Line_nRand: boolean); -- type of simulation 
  port(trig: in std_logic;
       echo: out std_logic);
end;

architecture behav of HC_SR04 is
    -- sensor parameters
    constant SPEED: real:=344.0E3; -- wave mm/sec (~22C deg)
    constant ResReal: real:=1.0e-12; --ps : simulator resolution in real
    constant NO_OBSTACLE: delay_length:= 38 ms;
    constant OUT_OF_RANGE: real:=4.5*1000; -- mm (4m5)
    constant MIN_RANGE: real:= 2.0*10; -- mm (2cm)
    constant TOO_CLOSE: delay_length:= 1.0 sec * MIN_RANGE*2.0/SPEED;
    constant TOO_FAR: delay_length:= 1.0 sec * OUT_OF_RANGE*2.0/SPEED;
    constant MIN_TRIGER: delay_length:= 10 us;
    constant INC_SPACE: delay_length:= Increment;

    function time2real(t : time) return real is
     begin
        return real(t/resolution_limit) * ResReal;
    end;

    procedure Gen_Pulse(inc: time; last_space: inout delay_length; signal p:out std_logic) is
        begin
            last_space:=last_space+inc;
            if last_space<TOO_CLOSE then last_space:=TOO_CLOSE; end if;
            if last_space>TOO_FAR then last_space:=NO_OBSTACLE; end if; -- saturation
            p<= '1';
            wait for last_space;
            p<= '0';
            if last_space=NO_OBSTACLE then last_space:=TOO_CLOSE; end if; -- rotate
    end procedure;

    procedure Rand_Pulse(seed1,seed2: inout natural; inc: time; signal p:out std_logic) is
        variable rand: real:=0.0;
        variable last_space: delay_length;
        begin
            uniform(seed1,seed2,rand);
            last_space:=inc*rand;
            if last_space<TOO_CLOSE then last_space:=TOO_CLOSE; end if;
            if last_space>TOO_FAR then last_space:=NO_OBSTACLE; end if; -- saturation
            p<= '1';
            wait for last_space;
            p<= '0';
    end procedure;

    procedure Distance(signal s: in std_logic; signal f: out real; raport_on: boolean:=false) is
        variable firstRE, secondRE: delay_length := 1 ns;
        variable f_var: real:=0.0;
     begin
        f_var:=0.0;
        if s='1' then firstRE:=now; 
        wait until s='0'; secondRE:=now; 
        f_var:= (time2real(secondRE-firstRE) * SPEED/2.0)*1000.0;
        if raport_on then 
            if (secondRE-firstRE) >= NO_OBSTACLE then
                report "No obstacle!" severity Warning;
            elsif (f_var>OUT_OF_RANGE) or (f_var<MIN_RANGE) then
                report "Out of range!" severity Warning;
            else
                report "Estimated range [mm]= " & to_string(integer(f_var)) severity Note; 
            end if;
        end if;
        f<=f_var; 
        end if;
    end procedure;

 signal echo_tmp: std_logic:='0';
 signal estimated_range: real:=0.0;

begin
-- synthesis translate off

 SR_behav: process 
    variable last_space: delay_length:= 0 ns;
    variable seed1: positive:= 13;
    variable seed2: positive:= 13;
 begin
    wait until trig='1'; wait for MIN_TRIGER;
    if trig'last_event<MIN_TRIGER then 
        report "Trig pulse too short!" severity Warning;
    else 
        if Line_nRand then
            Gen_Pulse(INC_SPACE,last_space,echo_tmp); 
        else 
            Rand_Pulse(seed1,seed2,INC_SPACE,echo_tmp); 
        end if;
    end if;
 end process;

echo<=echo_tmp; -- output

-- check procedure
Distance(echo_tmp,estimated_range,true);

-- synthesis translate on 
end architecture;
