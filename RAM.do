set name RAMtb
#############Create work library#############
vlib work

#############Compile sources#############
vlog "../$name/*sv" 
vsim -voptargs=+acc work.$name

# Set the window types
view wave
view structure
view signals
#add wave
add wave -position insertpoint sim:/$name/dut/*
add wave -position insertpoint sim:/$name/pst/*
run -all
