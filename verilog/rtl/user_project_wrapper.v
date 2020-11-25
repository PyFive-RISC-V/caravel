`default_nettype none

`define MPRJ_IO_PADS 38

module user_project_wrapper (
`ifdef USE_POWER_PINS
    inout vdda1,	// User area 1 3.3V supply
    inout vdda2,	// User area 2 3.3V supply
    inout vssa1,	// User area 1 analog ground
    inout vssa2,	// User area 2 analog ground
    inout vccd1,	// User area 1 1.8V supply
    inout vccd2,	// User area 2 1.8v supply
    inout vssd1,	// User area 1 digital ground
    inout vssd2,	// User area 2 digital ground
`endif

	// Wishbone Slave ports (WB MI A)
	input  wire        wb_clk_i,
	input  wire        wb_rst_i,
	input  wire        wbs_stb_i,
	input  wire        wbs_cyc_i,
	input  wire        wbs_we_i,
	input  wire  [3:0] wbs_sel_i,
	input  wire [31:0] wbs_dat_i,
	input  wire [31:0] wbs_adr_i,
	output wire        wbs_ack_o,
	output wire [31:0] wbs_dat_o,

	// Logic Analyzer Signals
	input  wire [127:0] la_data_in,
	output wire [127:0] la_data_out,
	input  wire [127:0] la_oen,

	// IOs
	input  wire [`MPRJ_IO_PADS-1:0] io_in,
	output wire [`MPRJ_IO_PADS-1:0] io_out,
	output wire [`MPRJ_IO_PADS-1:0] io_oeb,

	// Analog (direct connection to GPIO pad---use with caution)
	// Note that analog I/O is not available on the 7 lowest-numbered
	// GPIO pads, and so the analog_io indexing is offset from the
	// GPIO indexing by 7.
	inout [`MPRJ_IO_PADS-8:0] analog_io,

	// Independent clock (on independent integer divider)
	input   user_clock2
);

	wire zero;
	wire one;

	pyfive_top mprj (
`ifdef USE_POWER_PINS
		.VPWR      (vccd1),
		.VGND      (vssd1),
`endif
		.wb_clk_i  (wb_clk_i),
		.wb_rst_i  (wb_rst_i),
		.wbs_cyc_i (wbs_cyc_i),
		.wbs_stb_i (wbs_stb_i),
		.wbs_we_i  (wbs_we_i),
		.wbs_sel_i (wbs_sel_i),
		.wbs_adr_i (wbs_adr_i),
		.wbs_dat_i (wbs_dat_i),
		.wbs_ack_o (wbs_ack_o),
		.wbs_dat_o (wbs_dat_o),
		.io_in     (io_in [26:11]),
		.io_out    (io_out[26:11]),
		.io_oeb    (io_oeb[26:11]),
		.zero      (zero),
		.one       (one)
	);

	assign io_out[37:27] = { 11{one} };
	assign io_oeb[37:27] = { 11{one} };
	assign io_out[10: 0] = { 11{one} };
	assign io_oeb[10: 0] = { 11{one} };
	assign la_data_out  = { 128{zero} };

endmodule	// user_project_wrapper
`default_nettype wire
