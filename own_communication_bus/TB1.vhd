LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all;
USE ieee.math_real.all;
USE std.textio.all;

entity tb_1 is
end;

architecture bench of tb_1 is

component UE1
  generic (
		clk_period : time 
			);
	port(
	    clk       : OUT    STD_LOGIC ;
		reset	  : OUT    STD_LOGIC ;
	    data      : IN  STD_LOGIC_VECTOR (7 DOWNTO 0)                                          
			);
end component;

component master
	port(
    	clk       : IN    STD_LOGIC;
		reset     : IN    STD_LOGIC;
		slave_in  : IN    STD_LOGIC;
		master_out: OUT   STD_LOGIC;
    	data      : OUT   STD_LOGIC_VECTOR (7 DOWNTO 0);
		reset_out : OUT   STD_LOGIC;
		clk_out   : OUT   STD_LOGIC   
			);
end component;

component slave
	port(
    	clk       : IN    STD_LOGIC;
		master_in : IN    STD_LOGIC;
		reset     : IN    STD_LOGIC;
   		data      : IN    STD_LOGIC_VECTOR (7 DOWNTO 0); 
		enable	  : OUT   STD_LOGIC;
		slave_out : OUT   STD_LOGIC; 
		clk_out   : OUT   STD_LOGIC   
			);
end component;


component temp_sensor
  generic (
		input_value  : real
			);
	port(
		clk         :   in 		std_logic;                          
        enable      :   in 		std_logic;                          
        data        :   out 	std_logic_vector(7 DOWNTO 0)                                         
			);
end component;

  

  constant clk_period : time := 100 ns;
  constant input_value : real :=25.56;

  signal ul_clk, ul_reset : std_logic; --UL
  signal clk, reset, enable, master_in, slave_out, s_clk_out : std_logic; --SLAVE
  signal m_clk_out, m_rst_out : std_logic;			--MASTER
  signal data : STD_LOGIC_VECTOR(7 DOWNTO 0);
  signal recived_data : STD_LOGIC_VECTOR(7 DOWNTO 0);
  signal data_out : STD_LOGIC_VECTOR(7 DOWNTO 0);
                       
  

    	

begin
   comp0: UE1
					   generic map (100 ns)
					   port map (
						clk=>ul_clk,                         
       					reset=>ul_reset,                        
      					data=>data_out                         
								);
	

  comp1: master
					   port map (
					    clk=>ul_clk,
						reset=>ul_reset,
						slave_in=>slave_out,
						master_out=>master_in,
					    data=>recived_data,
						reset_out=>m_rst_out,
						clk_out=>m_clk_out
								);

  comp2: slave
					   port map (
						clk=>m_clk_out,                          
       					master_in=>master_in,                        
      					reset=>m_rst_out,                         
        				data=>data,                          
						enable=>enable,
						slave_out=>slave_out,
						clk_out=>s_clk_out  
								);
   comp3: temp_sensor
					   generic map ( input_value)
					   port map (
						clk=>s_clk_out,                         
       					enable=>enable,                        
      					data=>data                         
								);
	
	
end;

