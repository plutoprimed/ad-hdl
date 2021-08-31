// This source file was added as part of the plutoprimed modifications.
//
// Copyright 2021 Ústav jaderné fyziky AV ČR, v.v.i
//
// Distributed under terms of the 3-clause BSD license, see LICENSE_BSD.

module counter
	(
		input rstn,
		input clk,
		input chan_enable,
		input wr_en,
		input wr_overflow,
		output [31:0] out
	);

	reg chan_enable1;
	always @(posedge clk) chan_enable1 <= chan_enable;

	reg wr_en1;
	always @(posedge clk) wr_en1 <= wr_en;

	reg [31:0] count;
	assign out = count;

	always @(posedge clk)
	begin
		if (~rstn)
			count <= 0;
		else begin
			if (chan_enable && ~chan_enable1)
				count <= 0;
			else if (wr_en1 && ~wr_overflow)
				count <= count + 1;
		end
	end
endmodule
