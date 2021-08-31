// This source file was added as part of the plutoprimed modifications.
//
// Copyright 2021 Ústav jaderné fyziky AV ČR, v.v.i
//
// Distributed under terms of the 3-clause BSD license, see LICENSE_BSD.

module triggered_latch
	(
		input rstn,
		input clk,
		input trigger_ch0, // two independent triggering channels
		input trigger_ch1,
		input [31:0] count,
		output [31:0] count_latched
	);

	(* ASYNC_REG = "TRUE" *) reg [1:0] trigger_ff1;
	(* ASYNC_REG = "TRUE" *) reg [1:0] trigger_ff2;
	always @(posedge clk)
	begin
		trigger_ff1 <= { trigger_ch1, trigger_ch0 };
		trigger_ff2 <= trigger_ff1;
	end

	wire [1:0] trigger = trigger_ff2;
	reg [1:0] trigger1;
	always @(posedge clk) trigger1 <= trigger;

	reg [17:0] cooldown;
	wire trigger_decision = |(trigger & (trigger ^ trigger1)) && (cooldown == 0);

	always @(posedge clk)
	begin
		if (~rstn)
			cooldown <= 0;
		else begin
			if (cooldown != 0)
				cooldown <= cooldown - 1;
			else if (trigger_decision)
				cooldown <= ~0;
		end
	end


	reg [31:0] count_latched_r;
	assign count_latched = count_latched_r;

	always @(posedge clk)
	begin
		if (~rstn)
			count_latched_r <= 0;
		else begin
			if (trigger_decision)
				count_latched_r <= count;
		end
	end
endmodule
