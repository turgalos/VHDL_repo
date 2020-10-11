library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use STD.TEXTIO.all;
use IEEE.STD_LOGIC_TEXTIO.all;

entity gen_2048_tb is
Generic (
      outfile : string
		);
end gen_2048_tb;

architecture bench of gen_2048_tb is
 signal fout       : std_logic :='0';
 signal enable     : std_logic :='0';
 signal clk        : std_logic :='0';
 file file_output  : text;
 signal gen_err 	   : time ;


begin
--deklaracja jednostki testowanej
UUT: entity work.gen_2048(behav)
	port map (
     clk100MHz=>clk,
     enable=>enable,
	 fout=>fout
    );
    
--enable
enable_process: process 
 begin
    wait for 5 ns;    
    enable  <= '1';
end process;
   
--generator zegara
clk_process: process 
 begin
    wait for 5 ns;    
    clk <= not clk;
end process clk_process;

--zliczanie bledu 
fout_error_process: process (fout)
	variable t_1, t_2,error : time;
	constant target : integer :=2048000;
	variable error_int : integer;
 	variable  score :integer;
	variable error_f, error_real :real ;
begin
	if rising_edge(fout) then
	 t_1 := now;
	end if; 
	
	if falling_edge(fout) then
	 t_2 := now;	
	 error:=(t_2-t_1)*2; --500 ns		time
	 error_int:=(error/1 ns); --500		int
	 error_real:=(real(error_int))/1000000000.0; --real
	 error_f:=1.0/error_real; --f in Hz 	real
	 score:=abs(target-integer(error_f));
	report "Blad bezwzgladny wynosi " & integer'image(score) & " Hz" severity Warning;
	gen_err<=error;
	end if; 
	
end process fout_error_process;

--zapis wyj?ciowych wyników zliczania
output: process 
       variable o_outline     : line;
begin
     wait for 5 us;
     write(o_outline, gen_err, right, 2);
     writeline(file_output, o_outline);
	 wait ;
end process;

--zapis pliku wyj?ciowego
save: process
begin
	file_open(file_output, outfile, write_mode);
	wait for 15 us;
	file_close(file_output); 
	wait;
end process;

end architecture bench;
