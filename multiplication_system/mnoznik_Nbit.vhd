
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity mnoznik_Nbit is
	 Generic (N : INTEGER :=4);
    Port ( A : in  STD_LOGIC_VECTOR (N-1 downto 0):= (others => '0');
		   B : in  STD_LOGIC_VECTOR (N-1 downto 0):= (others => '0');
           S : out  STD_LOGIC_VECTOR(2*N-1 downto 0):= (others => '0')
		  );
end mnoznik_Nbit;

architecture Behavioral of mnoznik_Nbit is

	type two_D_array is array (N-1 downto 0) of std_logic_vector(N-1 downto 0);
	signal multiply_array : two_D_array := (others => (others => '0'));

	signal in_bits_a  : STD_LOGIC_VECTOR (N-1 downto 0) := (others => '0');
	signal in_bits_b  : STD_LOGIC_VECTOR (N-1 downto 0) := (others => '0');
	signal out_bits : STD_LOGIC_VECTOR (2*N-1 downto 0)   := (others => '0');

	signal co_temp : STD_LOGIC_VECTOR ((N-1)*N downto 0)   := (others => '0');
	signal s_temp : STD_LOGIC_VECTOR ((N-1)*(N-2) downto 0)   := (others => '0');

	COMPONENT sum_1b
	PORT(
		a : IN std_logic;
		b : IN std_logic;
		ci : IN std_logic;          
		co : OUT std_logic;
		s : OUT std_logic
		);
	END COMPONENT;
	
begin
	multiplying_array: for x in 0 to (N-1) generate
    	and_process: for y in 0 to (N-1) generate
        multiply_array(x)(y) <= in_bits_a(x) and in_bits_b(y);
    	end generate and_process;
	end generate multiplying_array;

	in_bits_a<=A;
	in_bits_b<=B;
	

	MNOZOWNIK:for J in 0 to N-2 generate

	Dla_J_0: if J=0 generate
		Part_zero: for I in 0 to N generate

			one_sum_zero: if I=0 generate
			out_bits(0)<=multiply_array(0)(0); 
			end generate one_sum_zero;
		
			next_sum_zero: if I=1 generate
			sum_1_0: sum_1b PORT MAP(
				a =>multiply_array(1)(0),
				b =>multiply_array(0)(1),
				ci =>'0',
				co =>co_temp(0),
				s =>out_bits(1)); 
			end generate next_sum_zero;

			other_sum_zero: if I>1 and I<N generate
			sum_X_0: sum_1b PORT MAP(
				a =>multiply_array(I)(0),
				b =>multiply_array(I-1)(1),
				ci =>co_temp(I-2),
				co =>co_temp(I-1),
				s =>s_temp(I-2)); 
			end generate other_sum_zero;
		
			last_sum_zero: if I=N generate
			sum_N_0: sum_1b PORT MAP(
				a =>'0',
				b =>multiply_array(I-1)(1),
				ci =>co_temp(N-2),
				co =>co_temp(N-1),
				s =>s_temp(N-2)); 
			end generate last_sum_zero;

			end generate Part_zero;
		end generate Dla_J_0;

	Dla_J_X: if J>0 and J<N-2 generate
		Part_X: for I in 0 to N-1 generate
		-------------------------------------------------
			one_sum_X_0: if I=0 and J=1 generate
			sum_1_X: sum_1b PORT MAP(
				a =>s_temp(0),						
				b =>multiply_array(0)(2),			
				ci =>'0',							
				co =>co_temp(J*N),					
				s =>out_bits(J+1)); 				
			end generate one_sum_X_0;

			one_sum_X_X: if I=0 and J/=1 generate
			sum_1_X: sum_1b PORT MAP(
				a =>s_temp((J-1)*N-J+1),			
				b =>multiply_array(0)(J+1),			
				ci =>'0',							
				co =>co_temp(J*N),					
				s =>out_bits(J+1));  				
			end generate one_sum_X_X;
		-------------------------------------------------
			other_sum_X: if I>0 and I<N-1 generate
			sum_X_X: sum_1b PORT MAP(
				a =>s_temp((J-1)*N-J+1+I),			
				b =>multiply_array(I)(J+1),			
				ci =>co_temp(J*N+I-1),				
				co =>co_temp(J*N+I),				
				s =>s_temp(J*N-J+I-1));				
			end generate other_sum_X;
		
			last_sum_X: if I=N-1 generate
			sum_N_X: sum_1b PORT MAP(
				a =>co_temp(J*N-1),					
				b =>multiply_array(N-1)(J+1),		
				ci =>co_temp(J*N+I-1), 				
				co =>co_temp(J*N+I), 				
				s =>s_temp(J*N-J+I-1));  			
			end generate last_sum_X;

			end generate Part_X;
		end generate Dla_J_X;

	Dla_J_N: if J=N-2 generate
		Part_N: for I in 0 to N-1 generate

			one_sum_N: if I=0 generate
			sum_1_N: sum_1b PORT MAP(
				a =>s_temp((J-1)*N-J+1),			
				b =>multiply_array(0)(J+1),			
				ci =>'0',							
				co =>co_temp(J*N),					
				s =>out_bits(N-1)); 			
			end generate one_sum_N;

			other_sum_N: if I>0 and I<N-1 generate
			sum_X_N: sum_1b PORT MAP(
				a =>s_temp((J-1)*N-J+1+I),			
				b =>multiply_array(I)(J+1),			
				ci =>co_temp(J*N+I-1),				
				co =>co_temp(J*N+I),				
				s =>out_bits(N-1+I)); 				
			end generate other_sum_N;
		
			last_sum_N: if I=N-1 generate
			sum_N_N: sum_1b PORT MAP(
				a =>co_temp(J*N-1),					
				b =>multiply_array(N-1)(J+1),		
				ci =>co_temp(J*N+I-1), 				
				co =>out_bits(N-1+I+1),				
				s =>out_bits(N-1+I));  				
			end generate last_sum_N;

			end generate Part_N;
		end generate Dla_J_N;
	S<=out_bits;
	end generate MNOZOWNIK;

end Behavioral;

