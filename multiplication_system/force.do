vcom -explicit  -93 "sum_1b.vhd" 
vcom -explicit  -93 "mnoznik_Nbit.vhd"
vsim -gui work.mnoznik_nbit(behavioral) -gN=4

add wave -height 30 -radix decimal *
view wave
view structure
view signals

run 100 ns
force A 2#0011
force B 2#0011

run 100 ns
force A 2#0110
force B 2#0110

run 100 ns
force A 2#0100
force B 2#0011

run 100 ns


wave zoom full