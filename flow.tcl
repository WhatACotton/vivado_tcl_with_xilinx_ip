# step#0: Define output directory location.
set top_module_name top
set outputDir ./impl
file mkdir $outputDir
set_part xc7z020clg400-1
 
# step#1: Setup design sources and constraints.
import_ip ./src/ip/clk_core.xci
upgrade_ip  -vlnv xilinx.com:ip:clk_wiz:6.0  [get_ips clk_core] 

generate_target all [get_ips clk_core]  -force

read_verilog -sv [ glob ./src/hdl/*.sv ]
read_verilog  [ glob .gen/sources_1/ip/clk_core/*.v ]
read_xdc [ glob ./src/constr/*.xdc]

set top_module_name "top"
set_property top $top_module_name [current_fileset]

# # step#2: Run synthesis, report utilization and timing estimates, write checkpoint design.

synth_design -top $top_module_name
write_checkpoint -force $outputDir/post_synth
report_timing_summary -file $outputDir/post_synth_timing_summary.rpt
report_power -file $outputDir/post_synth_power.rpt
report_clock_interaction -delay_type min_max -file $outputDir/post_synth_clock_interaction.rpt
report_high_fanout_nets -fanout_greater_than 200 -max_nets 50 -file $outputDir/post_synth_high_fanout_nets.rpt

# step#3: Run placement and logic optimization, report utilization and timing estimates, write checkpoint design.

opt_design
place_design
phys_opt_design
write_checkpoint -force $outputDir/post_place
report_timing_summary -file $outputDir/post_place_timing_summary.rpt


# step#4: Run router, report actual utilization and timing, write checkpoint design, run drc, write verilog and xdc out.


route_design
write_checkpoint -force $outputDir/post_route
report_timing_summary -file $outputDir/post_route_timing_summary.rpt
report_timing -max_paths 100 -path_type summary -slack_lesser_than 0 -file $outputDir/post_route_setup_timing_violations.rpt
report_clock_utilization -file $outputDir/clock_util.rpt
report_utilization -file $outputDir/post_route_util.rpt
report_power -file $outputDir/post_route_power.rpt
report_drc -file $outputDir/post_imp_drc.rpt
write_verilog -force $outputDir/top_impl_netlist.v
write_xdc -no_fixed_only -force $outputDir/top_impl.xdc

write_bitstream -force $outputDir/$top_module_name.bit
