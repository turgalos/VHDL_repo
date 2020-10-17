vcom -2008 HC_SR04.vhd HC_SR04_controller.vhd HC_SR04_controller_tb.vhd

vsim -voptargs=+acc -fsmdebug work.hc_sr04_controller_tb(behav)

add wave -position insertpoint sim:/hc_sr04_controller_tb/*
add wave -position insertpoint sim:/hc_sr04_controller_tb/uut_controller/*
add wave -position insertpoint sim:/hc_sr04_controller_tb/HC_SR04_intst/*



run 100 ms
