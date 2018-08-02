 // logic_ENDI.v
 `timescale 1ns/100ps
 
// Author:  Jerry D. Harthcock
// Version:  1.03  June 17, 2018
// Copyright (C) 2018.  All rights reserved.
//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                  //
//                                                Open-Source                                                       //
//                                        SYMPL 64-Bit OpCodeless CPU                                               //
//                                Evaluation and Product Development License                                        //
//                                                                                                                  //
//                                                                                                                  //
// Open-source means that this source code may be freely downloaded, copied, modified, distributed and used in      //
// accordance with the terms and conditons of the licenses provided herein.                                         //
//                                                                                                                  //
// Provided that you comply with all the terms and conditions set forth herein, Jerry D. Harthcock ("licensor"),    //
// the original author and exclusive copyright owner of this SYMPL 64-Bit OpCodeless CPU and related development    //
// software ("this IP") hereby grants recipient of this IP ("licensee"), a world-wide, paid-up, non-exclusive       //
// license to implement this IP within the programmable fabric of Xilinx, Intel, MicroSemi or Lattice               //
// Semiconductor brand FPGAs only and used only for the purposes of evaluation, education, and development of end   //
// products and related development tools.  Furthermore, limited to the purposes of prototyping, evaluation,        //
// characterization and testing of implementations in a hard, custom or semi-custom ASIC, any university or         //
// institution of higher education may have their implementation of this IP produced for said limited purposes at   //
// any foundary of their choosing provided that such prototypes do not ever wind up in commercial circulation,      //
// with such license extending to said foundary and is in connection with said academic pursuit and under the       //
// supervision of said university or institution of higher education.                                               //            
//                                                                                                                  //
// Any copying, distribution, customization, modification, or derivative work of this IP must include an exact copy //
// of this license and original copyright notice at the very top of each source file and any derived netlist, and,  //
// in the case of binaries, a printed copy of this license and/or a text format copy in a separate file distributed //
// with said netlists or binary files having the file name, "LICENSE.txt".  You, the licensee, also agree not to    //
// remove any copyright notices from any source file covered or distributed under this Evaluation and Product       //
// Development License.                                                                                             //
//                                                                                                                  //
// LICENSOR DOES NOT WARRANT OR GUARANTEE THAT YOUR USE OF THIS IP WILL NOT INFRINGE THE RIGHTS OF OTHERS OR        //
// THAT IT IS SUITABLE OR FIT FOR ANY PURPOSE AND THAT YOU, THE LICENSEE, AGREE TO HOLD LICENSOR HARMLESS FROM      //
// ANY CLAIM BROUGHT BY YOU OR ANY THIRD PARTY FOR YOUR SUCH USE.                                                   //
//                                                                                                                  //
//                                               N O T I C E                                                        //
//                                                                                                                  //
// Certain implementations of this IP involving certain floating-point operators may comprise IP owned by certain   //
// contributors and developers at FloPoCo.  FloPoCo's licensing terms can be found at this website:                 //
//                                                                                                                  //
//    http://flopoco.gforge.inria.fr                                                                                //
//                                                                                                                  //
// Licensor reserves all his rights, including, but in no way limited to, the right to change or modify the terms   //
// and conditions of this Evaluation and Product Development License anytime without notice of any kind to anyone.  //
// By using this IP for any purpose, you agree to all the terms and conditions set forth in this Evaluation and     //
// Product Development License.                                                                                     //
//                                                                                                                  //
// This Evaluation and Product Development License does not include the right to sell products that incorporate     //
// this IP or any IP derived from this IP. If you would like to obtain such a license, please contact Licensor.     //           
//                                                                                                                  //
// Licensor can be contacted at:  SYMPL.gpu@gmail.com                                                               //
//                                                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 

  module logic_ENDI(
      CLK,
      RESET,
      wren,
      Size_Dest_q1,
      wraddrs,     
      oprndA,
      oprndB,
      C,
      V,
      rdenA,
      Size_SrcA_q1,
      rdaddrsA,    
      rddataA,
      rdenB,
      rdaddrsB,    
      rddataB,
      ready
      );

input CLK;
input RESET;
input wren;
input [1:0] Size_Dest_q1;
input [3:0] wraddrs;
input [63:0] oprndA;
input [31:0] oprndB;
input C;
input V;
input rdenA;
input [1:0] Size_SrcA_q1;
input [3:0] rdaddrsA;
output [67:0] rddataA;
input rdenB;
input [3:0] rdaddrsB;
output [67:0] rddataB;
output ready;

wire [63:0] oprndAq;
wire [31:0] oprndBq;
reg [63:0] ENDI;
reg [3:0] ENDI_SELq2;

wire [3:0] ENDI_SELq1;

wire n_flag;
wire z_flag;

wire [67:0] rddataA;
wire [67:0] rddataB;
wire [65:0] rddataAq;
wire [65:0] rddataBq;
wire [3:0] ENDI_SEL;

reg ready;

always @(posedge CLK) ready <= wren && (rdenA || rdenB) ? 1'b0 : 1'b1;

assign ENDI_SELq1 = {Size_Dest_q1, Size_SrcA_q1}; 

assign n_flag = ENDI[63];
assign z_flag = ~|ENDI;

assign rddataA = {C, V, rddataAq};     
assign rddataB = {C, V, rddataBq};     

RAM_func #(.ADDRS_WIDTH(4), .DATA_WIDTH(66))
    ram32_logic_ENDI(
    .CLK        (CLK      ),
    .wren       (wren     ),
    .wraddrs    (wraddrs  ),
    .wrdata     ({n_flag, z_flag, ENDI}),
    .rdenA      (rdenA    ),
    .rdaddrsA   (rdaddrsA ),
    .rddataA    (rddataAq ),
    .rdenB      (rdenB    ),
    .rdaddrsB   (rdaddrsB ),
    .rddataB    (rddataBq ));

always @(*)
    if (wren) 
        case(ENDI_SELq2)
           4'b0101 : ENDI = {48'h0000_0000_0000, oprndAq[7:0], oprndAq[15:8]};  //upper and lower bytes of single half-word (16 bits)
           4'b1001 : ENDI = {32'h0000_0000, oprndBq[7:0], oprndBq[15:8], oprndAq[7:0], oprndAq[15:8]}; 
           4'b1010 : ENDI = {32'h0000_0000, oprndAq[7:0], oprndAq[15:8], oprndAq[23:16], oprndAq[31:24]};
           4'b1101 : ENDI = {32'h0000_0000, oprndBq[7:0], oprndBq[15:8], oprndAq[7:0], oprndAq[15:8]}; 
           4'b1110 : ENDI = {oprndBq[7:0], oprndBq[15:8], oprndBq[23:16], oprndBq[31:24]   ,oprndAq[7:0], oprndAq[15:8],  oprndAq[23:16], oprndAq[31:24]};
           4'b1111 : ENDI = {oprndAq[7:0], oprndAq[15:8], oprndAq[23:16], oprndAq[31:24], oprndAq[39:32], oprndAq[47:40], oprndAq[55:48], oprndAq[63:56]};
           default : ENDI = 64'hFFFF_FFFF_FFFF_FFFF;
        endcase    
    else  ENDI = 64'hFFFF_FFFF_FFFF_FFFF;

assign oprndAq = oprndA;           
assign oprndBq = oprndB;  

always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        ENDI_SELq2 <= 4'b0;
     end
    else begin
        ENDI_SELq2 <= ENDI_SELq1;
    end    
end            


endmodule