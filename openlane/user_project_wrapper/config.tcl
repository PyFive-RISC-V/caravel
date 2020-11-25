set script_dir [file dirname [file normalize [info script]]]

set ::env(DESIGN_NAME) user_project_wrapper
set ::env(FP_PIN_ORDER_CFG) $script_dir/pin_order.cfg

set ::env(CLOCK_PORT) "wb_clk_i"

set ::env(CLOCK_PERIOD) "10"

set ::env(FP_PDN_HOFFSET) 11.885
set ::env(FP_PDN_HPITCH) 131.1
set ::env(FP_PDN_CORE_RING) 1
set ::env(PDN_CFG) $script_dir/pdn.tcl

set ::env(FP_SIZING) absolute
set ::env(DIE_AREA) "0 0 2920 3520"
set ::env(PL_OPENPHYSYN_OPTIMIZATIONS) 0
set ::env(DIODE_INSERTION_STRATEGY) 0
set ::env(MAGIC_DRC_USE_GDS) 0

set ::env(VERILOG_FILES) "\
	$script_dir/../../verilog/rtl/defines.v \
	$script_dir/../../verilog/rtl/user_project_wrapper.v"

set ::env(VERILOG_FILES_BLACKBOX) "\
	$script_dir/../../verilog/rtl/defines.v \
	$script_dir/../../verilog/rtl/pyfive_top.v"

set ::env(EXTRA_LEFS) "\
	$script_dir/../../lef/pyfive_top.lef"

set ::env(EXTRA_GDS_FILES) "\
	$script_dir/../../gds/pyfive_top.gds"
