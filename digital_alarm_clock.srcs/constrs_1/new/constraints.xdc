## This file is a general .xdc for the Basys3 rev B board
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

# Clock signal
set_property PACKAGE_PIN W5 [get_ports clk]							
	set_property IOSTANDARD LVCMOS33 [get_ports clk]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]
 
# Switches
set_property PACKAGE_PIN V17 [get_ports {sw}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sw}]
 

# LEDs
set_property PACKAGE_PIN U16 [get_ports {LED}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {LED}]
set_property PACKAGE_PIN L1 [get_ports {pm}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {pm}]


##Buttons
set_property PACKAGE_PIN U18 [get_ports btnC]						
	set_property IOSTANDARD LVCMOS33 [get_ports btnC]
set_property PACKAGE_PIN T18 [get_ports btnU]						
	set_property IOSTANDARD LVCMOS33 [get_ports btnU]
set_property PACKAGE_PIN W19 [get_ports btnL]						
	set_property IOSTANDARD LVCMOS33 [get_ports btnL]
set_property PACKAGE_PIN T17 [get_ports btnR]						
	set_property IOSTANDARD LVCMOS33 [get_ports btnR]
 


##Pmod Header JA
##Sch name = JA1
set_property PACKAGE_PIN J1 [get_ports {als[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {als[0]}]
##Sch name = JA3
set_property PACKAGE_PIN J2 [get_ports {als[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {als[1]}]
##Sch name = JA4
set_property PACKAGE_PIN G2 [get_ports {als[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {als[2]}]

##Pmod Header JB
##Sch name = JB1
set_property PACKAGE_PIN A14 [get_ports {en}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {en}]
##Sch name = JB3
set_property PACKAGE_PIN B15 [get_ports {rs}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {rs}]
##Sch name = JB4
set_property PACKAGE_PIN B16 [get_ports {led_en}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {led_en}]
##Sch name = JB7
set_property PACKAGE_PIN A15 [get_ports {audio_out}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {audio_out}]
##Sch name = JB8
set_property PACKAGE_PIN A17 [get_ports {audio_gain}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {audio_gain}]
##Sch name = JB10 
set_property PACKAGE_PIN C16 [get_ports {audio_off}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {audio_off}]
 


##Pmod Header JC
##Sch name = JC1
set_property PACKAGE_PIN K17 [get_ports {lcd[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {lcd[0]}]
##Sch name = JC2
set_property PACKAGE_PIN M18 [get_ports {lcd[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {lcd[1]}]
##Sch name = JC3
set_property PACKAGE_PIN N17 [get_ports {lcd[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {lcd[2]}]
##Sch name = JC4
set_property PACKAGE_PIN P18 [get_ports {lcd[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {lcd[3]}]
##Sch name = JC7
set_property PACKAGE_PIN L17 [get_ports {lcd[4]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {lcd[4]}]
##Sch name = JC8
set_property PACKAGE_PIN M19 [get_ports {lcd[5]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {lcd[5]}]
##Sch name = JC9
set_property PACKAGE_PIN P17 [get_ports {lcd[6]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {lcd[6]}]
##Sch name = JC10
set_property PACKAGE_PIN R18 [get_ports {lcd[7]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {lcd[7]}]


#Pmod Header JXADC
#Sch name = XA3_P
set_property PACKAGE_PIN M2 [get_ports {scl}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {scl}]
#Sch name = XA4_P
set_property PACKAGE_PIN N2 [get_ports {sda}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {sda}]