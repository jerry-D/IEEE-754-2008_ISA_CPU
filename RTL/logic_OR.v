 // logic_OR.v
 `timescale 1ns/100ps

// Author:  Jerry D. Harthcock
// Version:  1.03  June 17, 2018
// Copyright (C) 2018.  All rights reserved.
 

  module logic_OR(
      CLK,
//     RESET,
      wren,
      wraddrs,     //includes thread#
      oprndA,
      oprndB,
      C,
      V,
      rdenA,
      rdaddrsA,    //includes thread#
      rddataA,
      rdenB,
      rdaddrsB,    //includes thread#
      rddataB,
      ready
      );

input CLK;
//input RESET;
input wren;
input [3:0] wraddrs;
input [63:0] oprndA;
input [63:0] oprndB;
input C;
input V;
input rdenA;
input [3:0] rdaddrsA;
output [67:0] rddataA;
input rdenB;
input [3:0] rdaddrsB;
output [67:0] rddataB;
output ready;


wire [63:0] oprndAq;
wire [63:0] oprndBq;

wire [63:0] A_OR_B;
wire n_flag;
wire z_flag;

wire [67:0] rddataA;
wire [67:0] rddataB;
wire [65:0] rddataAq;
wire [65:0] rddataBq;

reg ready;

always @(posedge CLK) ready <= wren && (rdenA || rdenB) ? 1'b0 : 1'b1;

assign A_OR_B = oprndAq | oprndBq;
assign n_flag = A_OR_B[63];
assign z_flag = ~|A_OR_B;
    
assign rddataA = {C, V, rddataAq};
assign rddataB = {C, V, rddataBq};

RAM_func #(.ADDRS_WIDTH(4), .DATA_WIDTH(66))
    ram32_logic_OR(
    .CLK        (CLK      ),
    .wren       (wren     ),
    .wraddrs    (wraddrs  ),
    .wrdata     ({n_flag, z_flag, A_OR_B}),
    .rdenA      (rdenA    ),
    .rdaddrsA   (rdaddrsA ),
    .rddataA    (rddataAq ),
    .rdenB      (rdenB    ),
    .rdaddrsB   (rdaddrsB ),
    .rddataB    (rddataBq ));

assign oprndAq = oprndA;
assign oprndBq = oprndB;


endmodule