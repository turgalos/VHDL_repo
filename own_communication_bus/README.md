# Own Communication Bus
Implementatnion in VHDL of invented communication bus to controll temperature sensor (scheme - circuit_diagram.png)
Communication bitsream via Master & Slave:

11xxxxxxxx0

Master "1" - ready to read

Slave "1" - ready to write

Slave "xxxxxxxx" - measured value of the temperature in binary notation

Master "0" - confirmation 

# Files:
- master.vhd
  (master module)
  
 - slave.vhd
  (slave module)
  
 - temp_sensor.vhd
  (tmperature sensor module)
  
 - UE1.vhd
  (user logic module)
 
 - TB1.vhd
  (testbench)
  
 - force.do
  (macro)
  
  # Comment
  It would be better to use FSM instead of cntr incrementation.
