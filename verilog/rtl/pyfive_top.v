`default_nettype none

(* blackbox *)
module pyfive_top (
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

	// IOs
	input  wire [15:0] io_in,
	output wire [15:0] io_out,
	output wire [15:0] io_oeb,

	// Constants
	output wire zero,
	output wire one
);
endmodule	// pyfive_top
