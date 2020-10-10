vcom RAM_static_tb.vhd RAM_static.vhd
vsim -gui work.ram_static_tb(behav) -voptargs=+acc 

add wave -position insertpoint sim:/ram_static_tb/*
add wave -position insertpoint sim:/ram_static_tb/UUT/*

run 100 ns

wave zoom full