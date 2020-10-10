library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use STD.TEXTIO.all;
use IEEE.STD_LOGIC_TEXTIO.all;
use IEEE.math_real.all;

entity RAM_STATIC is 

generic(
	constant n_address: integer := 7; --number of address lines 0..7
	constant m_data: integer := 7 --number of data lines 0..7
		);
port(
	CSn, WEn, OEn: in std_logic;
	Address: in std_logic_vector(n_address+1 downto 0);
	Data: inout std_logic_vector (m_data downto 0) := "ZZZZZZZZ"
	);

end entity RAM_STATIC;

architecture behav of RAM_STATIC is


type data_arr is array ( 0 to 255) of std_logic_vector (m_data downto 0);
signal data_array : data_arr ;

signal adress_int : integer;
begin
adress_int<= to_integer(unsigned(Address));


process (CSn, WEn, OEn)

begin 	
	if CSn='1' then								--STANDBY
		Data<="ZZZZZZZZ";
	end if;

	if CSn='0' and WEn='0' then					--WRITE
		data_array(adress_int)<=Data;
	end if;

	if CSn='0' and WEn='0' and OEn='1' then		--READ
		Data<=data_array(adress_int);
	end if;

	if CSn='0' and WEn='1' and OEn='1' then		--READ "Z"
		Data<="ZZZZZZZZ";
	end if;


end process;

end behav;
