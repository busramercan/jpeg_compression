
set_property PACKAGE_PIN Y9 [get_ports clk];
create_clock -name my_clock -period 100

set_property IOSTANDARD LVCMOS33 [get_ports -of_object [get_iobanks 13]];
set_property IOSTANDARD LVCMOS33 [get_ports -of_object [get_iobanks 33]];
set_property IOSTANDARD LVCMOS18 [get_ports -of_object [get_iobanks 34]];
set_property IOSTANDARD LVCMOS18 [get_ports -of_object [get_iobanks 35]];