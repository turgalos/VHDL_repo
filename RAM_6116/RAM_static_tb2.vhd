library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use STD.TEXTIO.all;
use IEEE.STD_LOGIC_TEXTIO.all;

entity RAM_static_tb2 is
end RAM_static_tb2;

architecture behav of RAM_static_tb2 is
	constant n_address: integer := 7; --number of address lines 0..7
	constant m_data: integer := 7; --number of data lines 0..7
	signal 	CSn 	:  std_logic;
	signal  WEn 	:  std_logic;
	signal  OEn		:  std_logic;
	signal  Address :  std_logic_vector(n_address+1 downto 0); --aby nie uzywa? pierwszego bitu odpowiedzialnego za znak
	signal  Data	:  std_logic_vector (m_data downto 0);
	signal  Data_out	:  std_logic_vector (m_data downto 0):="00000000";
	signal 	Data_index 	:  integer; 										--values: 0-255
	signal  clk		:  std_logic :='0';

	type state_type is (start,address_inc,address_conv, write_d,read_d, address_inc2,address_conv2);
    signal p_state, n_state: state_type;

begin
--deklaracja jednostki testowanej
UUT: entity work.RAM_STATIC(behav)
	generic map(
	 n_address=>n_address,
	 m_data=>m_data
    )
	port map (
     CSn=>CSn,
     WEn=>WEn,
	 OEn=>OEn,
     Address=>Address,
	 Data=>Data
    );
       

proc_fsm: process(p_state) 
begin

   case p_state is
       when start => 			--and reset 
			CSn<='1';
		    OEn<='0';	
			Data_index<=0;
			--Data	<="11111111";
            n_state <= write_d;

       when write_d => 
		 	CSn<='0';			--WRITE 
			
			WEn<='0';
				if Data_index<255 and Data_index>=0 then
                        n_state <= address_inc;
                else
						Data_index<=0;
                        n_state <= read_d;
                end if;

       when address_inc =>
			CSn<='1';	
            Data_index<=Data_index+1;
            n_state <= address_conv;
			
	   when address_conv =>
			Address<=std_logic_vector(to_unsigned(Data_index,9));
			n_state <= write_d;



       when read_d => 
		   CSn<='0';			--READ 
		   OEn<='0';
 		   WEn<='1';
	       Data_out<=Data;

				if Data_index<255 and Data_index>=0 then
                        n_state <= address_inc2;
                else
                        n_state <= start;
                end if;
       when address_inc2 => 
			CSn<='1';	
            Data_index<=Data_index+1;
			Data_out<=Data;
            n_state <= address_conv2;
			
	   when address_conv2 =>
			Address<=std_logic_vector(to_unsigned(Data_index,9));
			n_state <= read_d;
   end case;
end process;

 proc_memory: process (clk)
    begin
        if rising_edge(clk) then
            p_state <= n_state;
        end if;
    end process;

 int_clk: process 
    begin
  	wait for 5 ns;
	clk<=not clk;
  end process;

data_change: process  (p_state) 
    begin
		if Data_index>=0 and Data_index<85 then 
		Data	<="11111111";
		end if;
		if Data_index>=85 and Data_index<168 then 
		Data	<="11110000";
		end if;
		if Data_index>=168 and Data_index<254 then 
		Data	<="00001111";
		end if;
    end process;


end architecture behav;