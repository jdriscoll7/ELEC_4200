# Write address switches.
set_property -dict { PACKAGE_PIN J15   IOSTANDARD LVCMOS33 } [get_ports { w_addr[0] }];
set_property -dict { PACKAGE_PIN L16   IOSTANDARD LVCMOS33 } [get_ports { w_addr[1] }];


# Data in switches.
set_property -dict { PACKAGE_PIN H6    IOSTANDARD LVCMOS33 } [get_ports { data_in[0] }];
set_property -dict { PACKAGE_PIN U12   IOSTANDARD LVCMOS33 } [get_ports { data_in[1] }];
set_property -dict { PACKAGE_PIN U11   IOSTANDARD LVCMOS33 } [get_ports { data_in[2] }];
set_property -dict { PACKAGE_PIN V10   IOSTANDARD LVCMOS33 } [get_ports { data_in[3] }];

# Push button (w_enable).
set_property -dict { PACKAGE_PIN P17   IOSTANDARD LVCMOS33 } [get_ports { w_enable }];