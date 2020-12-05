/* Generated by Yosys 0.9+3710 (git sha1 2116c585, gcc 9.2.1-9ubuntu2 -fPIC -Os) */

module user_project_wrapper(wb_clk_i, wb_rst_i, wbs_stb_i, wbs_cyc_i, wbs_we_i, wbs_sel_i, wbs_dat_i, wbs_adr_i, wbs_ack_o, wbs_dat_o, la_data_in, la_data_out, la_oen, io_in, io_out, io_oeb, analog_io, user_clock2);
  inout [30:0] analog_io;
  input [37:0] io_in;
  output [37:0] io_oeb;
  output [37:0] io_out;
  input [127:0] la_data_in;
  output [127:0] la_data_out;
  input [127:0] la_oen;
  wire one;
  input user_clock2;
  input wb_clk_i;
  input wb_rst_i;
  output wbs_ack_o;
  input [31:0] wbs_adr_i;
  input wbs_cyc_i;
  input [31:0] wbs_dat_i;
  output [31:0] wbs_dat_o;
  input [3:0] wbs_sel_i;
  input wbs_stb_i;
  input wbs_we_i;
  wire zero;
  pyfive_top mprj (
    .io_in(io_in[26:11]),
    .io_oeb(io_oeb[26:11]),
    .io_out(io_out[26:11]),
    .one(one),
    .wb_clk_i(wb_clk_i),
    .wb_rst_i(wb_rst_i),
    .wbs_ack_o(wbs_ack_o),
    .wbs_adr_i(wbs_adr_i),
    .wbs_cyc_i(wbs_cyc_i),
    .wbs_dat_i(wbs_dat_i),
    .wbs_dat_o(wbs_dat_o),
    .wbs_sel_i(wbs_sel_i),
    .wbs_stb_i(wbs_stb_i),
    .wbs_we_i(wbs_we_i),
    .zero(zero)
  );
  assign io_oeb[10:0] = { one, one, one, one, one, one, one, one, one, one, one };
  assign io_oeb[37:27] = { one, one, one, one, one, one, one, one, one, one, one };
  assign io_out[10:0] = { one, one, one, one, one, one, one, one, one, one, one };
  assign io_out[37:27] = { one, one, one, one, one, one, one, one, one, one, one };
  assign la_data_out = { zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero };
endmodule
