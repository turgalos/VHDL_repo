library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use STD.TEXTIO.all;
use IEEE.STD_LOGIC_TEXTIO.all;

entity RAM_static_tb is
end RAM_static_tb;

architecture behav of RAM_static_tb is
	constant n_address: integer := 7; --number of address lines 0..7
	constant m_data: integer := 7; --number of data lines 0..7
	signal 	CSn 	:  std_logic;
	signal  WEn 	:  std_logic;
	signal  OEn		:  std_logic;
	signal  Address :  std_logic_vector(n_address+1 downto 0);
	signal  Data	:  std_logic_vector (m_data downto 0);
	signal  Data_out	:  std_logic_vector (m_data downto 0):="00000000";

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
       

enable: process 
 begin
CSn<='1';			--STANDBY
Address	<="000000001";
Data	<="11111111";
wait for 20 ns;
CSn<='0';			--WRITE 

WEn<='0';
wait for 20 ns;
CSn<='0';			--READ "Z"
OEn<='1';
WEn<='1';
Data	<="00000000";
wait for 20 ns;
CSn<='0';			--READ 
OEn<='0';
WEn<='1';

end process enable;

end architecture behav;