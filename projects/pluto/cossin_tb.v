// This source file was added as part of the plutoprimed modifications.
//
// Copyright 2021 Ústav jaderné fyziky AV ČR, v.v.i
//
// Distributed under terms of the 3-clause BSD license, see LICENSE_BSD.

`timescale 1ns/1ps
`default_nettype none

module tb_system;
    reg clk24;

    always
        #21 clk24 = ~clk24;
    
    initial
    begin
        phase <= 0;
        clk24 = 1'b0;
		#210000 $finish;
    end


    wire signed [15:0] i_;
    wire signed [15:0] q_;
    reg [31:0] phase;

    cossin cs(.z(phase[31:14]), .x(i_), .y(q_), .sys_clk(clk24));

    initial
    begin
        forever begin
            @(posedge clk24) phase <= phase+32'h00800000;
        end
    end

    initial
    begin
        forever begin
            @(negedge clk24);
            $display("%d %d %d", phase, i_, q_);
        end
    end
endmodule