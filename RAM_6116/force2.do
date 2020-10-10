vcom RAM_static_tb2.vhd RAM_static.vhd
vsim -gui work.ram_static_tb2(behav) -voptargs=+acc -fsmdebug

add wave -position insertpoint sim:/ram_static_tb2/*
add wave -position insertpoint sim:/ram_static_tb2/UUT/*

run 16 us

wave zoom full