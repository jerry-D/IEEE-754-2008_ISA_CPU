 // integer_MUL.v
 `timescale 1ns/100ps
// Author:  Jerry D. Harthcock
// Version:  1.03  June 17, 2018
// Copyright (C) 2018.  All rights reserved.
 

  module integer_MUL(
      CLK,
//      RESET,
      Sext_SrcA_q2,
      Sext_SrcB_q2,
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
input Sext_SrcA_q2;
input Sext_SrcB_q2;
input wren;
input [3:0] wraddrs;
input [31:0] oprndA;
input [31:0] oprndB;
input C;
input V;
input rdenA;
input [3:0] rdaddrsA;
output [67:0] rddataA;
input rdenB;
input [3:0] rdaddrsB;
output [67:0] rddataB;
output ready;

wire signed [32:0] oprndAq;
wire signed [32:0] oprndBq;

wire signed [63:0] A_X_B;
wire z_flag;
wire n_flag;

wire [67:0] rddataA;
wire [67:0] rddataB;
wire [65:0] rddataAq;
wire [65:0] rddataBq;


reg ready;

always @(posedge CLK) ready <= wren && (rdenA || rdenB) ? 1'b0 : 1'b1;

assign A_X_B = oprndAq * oprndBq;
assign z_flag = ~|A_X_B;
assign n_flag = oprndAq[32] ^ oprndBq[32];
assign rddataA = {C, V, rddataAq};    
assign rddataB = {C, V, rddataBq};    

RAM_func #(.ADDRS_WIDTH(4), .DATA_WIDTH(66))
    ram32_integer_MUL(
    .CLK        (CLK      ),
    .wren       (wren     ),
    .wraddrs    (wraddrs  ),
    .wrdata     ({n_flag, z_flag, A_X_B[63:0]}),
    .rdenA      (rdenA    ),
    .rdaddrsA   (rdaddrsA ),
    .rddataA    (rddataAq ),
    .rdenB      (rdenB    ),
    .rdaddrsB   (rdaddrsB ),
    .rddataB    (rddataBq ));

assign oprndAq = {(Sext_SrcA_q2 && oprndA[31]), oprndA[31:0]};
assign oprndBq = {(Sext_SrcB_q2 && oprndB[31]), oprndB[31:0]};


endmodule