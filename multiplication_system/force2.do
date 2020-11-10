vcom -explicit  -93 "sum_1b.vhd" 
vcom -explicit  -93 "mnoznik_Nbit.vhd"
vsim -gui work.mnoznik_nbit(behavioral) -gN=6

add wave -height 30 -radix decimal *
view wave
view structure
view signals

run 100 ns
force A 2#001011
force B 2#000011

run 100 ns
force A 2#000010
force B 2#011111

run 100 ns
force A 2#001110
force B 2#011001

run 100 ns
 

wave zoom full