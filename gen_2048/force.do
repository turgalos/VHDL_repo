vcom -2008 gen_2048.vhd gen_2048_tb.vhd

vsim -gui work.gen_2048_tb(bench) -goutfile="plik_wyjsciowy.txt"

add wave -position insertpoint sim:/gen_2048_tb/*
add wave -position insertpoint sim:/gen_2048_tb/UUT/*

run 15 us

wave zoom full