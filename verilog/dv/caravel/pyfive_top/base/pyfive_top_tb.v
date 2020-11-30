`default_nettype none

`timescale 1 ns / 1 ps

`include "caravel.v"
`include "spiflash.v"

module pyfive_top_tb;
	reg clock;
	reg clk_samp;
	reg RSTB;
	reg power1, power2;

	wire gpio;
	wire [37:0] mprj_io;
	wire [15:0] checkbits;

	assign checkbits = mprj_io[31:16];

	always #10.416 clock <= (clock === 1'b0);
	always #3.247 clk_samp <= (clk_samp == 1'b0);

	initial begin
		clock = 0;
		clk_samp = 0;
	end

	initial begin
		$dumpfile("pyfive_top_tb.vcd");
		$dumpvars(0, pyfive_top_tb);

//		// Repeat cycles of 1000 clock edges as needed to complete testbench
//		repeat (150) begin
//			repeat (1000) @(posedge clock);
//			// $display("+1000 cycles");
//		end
//		$display("%c[1;31m",27);
//		$display ("Monitor: Timeout, Test Mega-Project IO (RTL) Failed");
//		$display("%c[0m",27);

	//	$finish;
	end

	initial begin
		wait(checkbits == 16'h AB60);
		$display("Monitor: Test 2 MPRJ-Logic Analyzer Started");
		wait(checkbits == 16'h AB61);
		$display("Monitor: Test 2 MPRJ-Logic Analyzer Passed");
		$finish;
	end

	initial begin
		RSTB <= 1'b0;
		#1000;
		RSTB <= 1'b1;	    // Release reset
		#2000;
	end

	initial begin		// Power-up sequence
		power1 <= 1'b0;
		power2 <= 1'b0;
		#200;
		power1 <= 1'b1;
		#200;
		power2 <= 1'b1;
	end

	wire flash_csb;
	wire flash_clk;
	wire flash_io0;
	wire flash_io1;

	wire VDD1V8;
	wire VDD3V3;
	wire VSS;

	assign VDD3V3 = power1;
	assign VDD1V8 = power2;
	assign VSS = 1'b0;

	caravel uut (
		.vddio	  (VDD3V3),
		.vssio	  (VSS),
		.vdda	  (VDD3V3),
		.vssa	  (VSS),
		.vccd	  (VDD1V8),
		.vssd	  (VSS),
		.vdda1    (VDD3V3),
		.vdda2    (VDD3V3),
		.vssa1	  (VSS),
		.vssa2	  (VSS),
		.vccd1	  (VDD1V8),
		.vccd2	  (VDD1V8),
		.vssd1	  (VSS),
		.vssd2	  (VSS),
		.clock	  (clock),
		.gpio     (gpio),
		.mprj_io  (mprj_io),
		.flash_csb(flash_csb),
		.flash_clk(flash_clk),
		.flash_io0(flash_io0),
		.flash_io1(flash_io1),
		.resetb	  (RSTB)
	);

	spiflash #(
		.FILENAME("pyfive_top.hex")
	) spiflash (
		.csb(flash_csb),
		.clk(flash_clk),
		.io0(flash_io0),
		.io1(flash_io1),
		.io2(),
		.io3()
	);

	// MIDI loopback
	reg midi_del;

	always #10 midi_del <= mprj_io[15];

	assign mprj_io[16] = midi_del;


	// Read file
	wire usb_pu;
	wire usb_dp;
	wire usb_dn;

	assign usb_pu = mprj_io[13];

	assign mprj_io[12] = usb_dp;
	assign mprj_io[11] = usb_dn;

    reg  [7:0] in_file_data;
    reg  in_file_valid;
    reg  in_file_done;

	integer fh_in, rv;

	initial
		fh_in = $fopen("capture_usb_raw_short.dat", "rb");

	always @(posedge clk_samp)
	begin
		if (RSTB) begin
			if (usb_pu === 1'bz) begin
				in_file_data  <= 8'h00;
				in_file_valid <= 1'b0;
				in_file_done  <= 1'b0;
			end else begin
				if (!in_file_done) begin
					rv = $fread(in_file_data, fh_in);
					in_file_valid <= (rv == 1);
					in_file_done  <= (rv != 1);
				end else begin
					in_file_data  <= 8'h00;
					in_file_valid <= 1'b0;
					in_file_done  <= 1'b1;
					$finish;
				end
			end
		end
	end

    // Input
    assign usb_dp = (uut.mprj.mprj.io_oeb[1] == 1'b1) ? (in_file_valid ? in_file_data[1] : 1'b0) : 1'bz;
    assign usb_dn = (uut.mprj.mprj.io_oeb[0] == 1'b1) ? (in_file_valid ? in_file_data[0] : 1'b0) : 1'bz;

endmodule
`default_nettype wire
