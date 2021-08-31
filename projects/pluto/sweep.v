// This source file was added as part of the plutoprimed modifications.
//
// Copyright 2021 Ústav jaderné fyziky AV ČR, v.v.i
//
// Distributed under terms of the 3-clause BSD license, see LICENSE_BSD.

`timescale 1 ns / 1 ps

module sweep
	(
		input wire enable,
		output reg [15:0] i,
		output reg [15:0] q,
		input wire clk,
		input wire reset,
		input wire valid,
		input wire [15:0] increment,
		output reg check
	);
	reg [31:0] freq;
	reg [31:0] phase;
	wire [15:0] i_;
	wire [15:0] q_;
	cossin cs(.z(phase[31:14]), .x(i_), .y(q_), .clk(clk));

	always @(posedge clk) begin
		i <= i_;
		q <= q_;

		if (reset) begin
			freq <= {1'b1, {31{1'b0}}};
			phase <= 0;
		end
		else begin
			if (enable && valid) begin
				phase <= phase + freq;
				freq <= freq + {{16{increment[15]}}, increment};
			end
		end

		check <= freq[31] && (freq[30:0] < 352046499);
	end
endmodule

module iq_switch
	(
		input wire control,
		output wire [15:0] i,
		output wire [15:0] q,
		input wire [15:0] i0,
		input wire [15:0] q0,
		input wire [15:0] i1,
		input wire [15:0] q1
	);
	assign i = control ? i1 : i0;
	assign q = control ? q1 : q0;
endmodule
