vcom sine_package.vhd sine_wave.vhd s_and_hold.vhd z_delay.vhd lin_comb.vhd int2.vhd adc.vhd dac.vhd sigma_delta.vhd sigma_delta_tb.vhd
vsim -gui work.sigma_delta_tb(bench)


add wave -position insertpoint sim:/sigma_delta_tb/clock
add wave -position insertpoint sim:/sigma_delta_tb/clock2
add wave -position insertpoint -format analog -radix time -height 60 -min -140 -max 140 sim:/sigma_delta_tb/SHcomp/input
add wave -position insertpoint -format analog -radix time -height 60 -min -1.5 -max 1.5 sim:/sigma_delta_tb/SHcomp/output
add wave -position insertpoint -format analog -radix time -height 60 -min -1.5 -max 1.5 sim:/sigma_delta_tb/uut/output_LC
add wave -position insertpoint -format analog -radix time -height 60 -min -2 -max 2 sim:/sigma_delta_tb/uut/output_int
add wave -position insertpoint sim:/sigma_delta_tb/uut/output_adc
add wave -position insertpoint -format analog -radix time -min -1.5 -max 1.5 sim:/sigma_delta_tb/uut/output_dac


run 1 ms

wave zoom full