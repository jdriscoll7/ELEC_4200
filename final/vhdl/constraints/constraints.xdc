# Clock signal.
set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports {clk}];
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports {clk}];


# Input data switch.
set_property -dict { PACKAGE_PIN J15   IOSTANDARD LVCMOS33 } [get_ports {data_bit}];


# Send button.
set_property -dict { PACKAGE_PIN P17   IOSTANDARD LVCMOS33 } [get_ports {send_bit}];


# 7 segment display

set_property -dict { PACKAGE_PIN T10   IOSTANDARD LVCMOS33 } [get_ports {display_value[0]}];
set_property -dict { PACKAGE_PIN R10   IOSTANDARD LVCMOS33 } [get_ports {display_value[1]}];
set_property -dict { PACKAGE_PIN K16   IOSTANDARD LVCMOS33 } [get_ports {display_value[2]}];
set_property -dict { PACKAGE_PIN K13   IOSTANDARD LVCMOS33 } [get_ports {display_value[3]}];
set_property -dict { PACKAGE_PIN P15   IOSTANDARD LVCMOS33 } [get_ports {display_value[4]}];
set_property -dict { PACKAGE_PIN T11   IOSTANDARD LVCMOS33 } [get_ports {display_value[5]}];
set_property -dict { PACKAGE_PIN L18   IOSTANDARD LVCMOS33 } [get_ports {display_value[6]}];

set_property -dict { PACKAGE_PIN J17   IOSTANDARD LVCMOS33 } [get_ports {display_select[0]}];
set_property -dict { PACKAGE_PIN J18   IOSTANDARD LVCMOS33 } [get_ports {display_select[1]}];
set_property -dict { PACKAGE_PIN T9    IOSTANDARD LVCMOS33 } [get_ports {display_select[2]}];
set_property -dict { PACKAGE_PIN J14   IOSTANDARD LVCMOS33 } [get_ports {display_select[3]}];
set_property -dict { PACKAGE_PIN P14   IOSTANDARD LVCMOS33 } [get_ports {display_select[4]}];
set_property -dict { PACKAGE_PIN T14   IOSTANDARD LVCMOS33 } [get_ports {display_select[5]}];
set_property -dict { PACKAGE_PIN K2    IOSTANDARD LVCMOS33 } [get_ports {display_select[6]}];
set_property -dict { PACKAGE_PIN U13   IOSTANDARD LVCMOS33 } [get_ports {display_select[7]}];