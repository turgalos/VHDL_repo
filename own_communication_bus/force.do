vcom temp_sensor.vhd slave.vhd master.vhd UE1.vhd TB1.vhd

vsim -voptargs=+acc work.tb_1(bench)

add wave -position insertpoint sim:/tb_1/*
add wave -position insertpoint sim:/tb_1/comp1/*
add wave -position insertpoint sim:/tb_1/comp2/*
add wave -position insertpoint sim:/tb_1/comp3/*



run 50 us

wave zoom full