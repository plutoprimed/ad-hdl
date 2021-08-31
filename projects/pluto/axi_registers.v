// This source file was added as part of the plutoprimed modifications.
//
// Copyright 2021 Ústav jaderné fyziky AV ČR, v.v.i
//
// Distributed under terms of the 3-clause BSD license, see LICENSE_BSD.

`define ADDRLEN 8
`define WIDTH 32

module axi_registers(
	input S_AXI_ACLK, S_AXI_ARESETN,
	input S_AXI_AWVALID, input [`ADDRLEN-1:0] S_AXI_AWADDR,
	output S_AXI_AWREADY,
	input S_AXI_WVALID, input [`WIDTH-1:0] S_AXI_WDATA,
	output S_AXI_WREADY,
	output S_AXI_BVALID, output [1:0] S_AXI_BRESP,
	input S_AXI_BREADY,
	input S_AXI_ARVALID, input [`ADDRLEN-1:0] S_AXI_ARADDR,
	output S_AXI_ARREADY,
	output S_AXI_RVALID, output [`WIDTH-1:0] S_AXI_RDATA, 
	output S_AXI_RRESP,
	input S_AXI_RREADY,

	input [`WIDTH-1:0] reg1,
	input [`WIDTH-1:0] reg2,
	input [`WIDTH-1:0] reg3
);
	wire clk = S_AXI_ACLK;
	wire resetn = S_AXI_ARESETN;

	wire bconsumed = S_AXI_BVALID && S_AXI_BREADY;
	wire wconsumed = S_AXI_WVALID && S_AXI_WREADY;
	wire awconsumed = S_AXI_AWVALID && S_AXI_AWREADY;

	reg write;
	assign S_AXI_WREADY = write;
	assign S_AXI_AWREADY = write;
	always @(posedge clk)
	begin
		if (resetn) begin
			write <= ~write && S_AXI_WVALID && S_AXI_AWVALID && ~S_AXI_BVALID;
		end else begin
			write <= 0;
		end
	end

	reg [`WIDTH-1:0] reg4;

	always @(posedge clk)
	begin
		if (resetn) begin
			if (write) begin
				case (S_AXI_AWADDR)
					16: reg4 <= S_AXI_WDATA;
				endcase
			end
		end
	end

	reg bresp_flag;
	assign S_AXI_BRESP = 2'b0;
	assign S_AXI_BVALID = bresp_flag;
	always @(posedge clk)
	begin
		if (resetn) begin
			if (write)
				bresp_flag <= 1;
			else if (bconsumed)
				bresp_flag <= 0;
		end else begin
			bresp_flag <= 0;
		end
	end

	wire arconsumed = S_AXI_ARVALID && S_AXI_ARREADY;
	wire rconsumed = S_AXI_RVALID && S_AXI_RREADY;
	assign S_AXI_ARREADY = ~rvalid;
	reg rvalid;
	reg [`WIDTH-1:0] rdata;
	assign S_AXI_RVALID = rvalid;
	assign S_AXI_RRESP = 2'b0;
	assign S_AXI_RDATA = rdata;

	always @(posedge clk)
	begin
		if (resetn) begin
			if (arconsumed) begin
				rvalid <= 1;
				case (S_AXI_ARADDR)
					0: 		 rdata <= 32'hf00ba000;
					4: 		 rdata <= reg1;
					8:		 rdata <= reg2;
					12:		 rdata <= reg3;
					16:		 rdata <= reg4;
					default: rdata <= 32'h00000000;
				endcase
			end else if (rconsumed) begin
				rvalid <= 0;
			end
		end else begin
			rvalid <= 0;
			rdata <= 0;
		end
	end
endmodule
