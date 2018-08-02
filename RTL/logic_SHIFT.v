 // logic_SHIFT.v
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
 

  module logic_SHIFT(
      CLK,
//      RESET,
      wren,
      wraddrs,     
      oprndA,
      oprndB_shiftype,
      oprndB_shiftamount,
      C,
      V,
      rdenA,
      rdaddrsA,    
      rddataA,
      rdenB,
      rdaddrsB,    
      rddataB,
      ready
      );

input CLK;
//input RESET;
input wren;
input [3:0] wraddrs;
input [63:0] oprndA;
input [2:0] oprndB_shiftype;
input [4:0] oprndB_shiftamount;
input C;
input V;
input rdenA;
input [3:0] rdaddrsA;
output [67:0] rddataA;
input rdenB;
input [3:0] rdaddrsB;
output [67:0] rddataB;
output ready;

parameter LEFT_  = 3'b000;
parameter LSL_   = 3'b001;
parameter ASL_   = 3'b010;
parameter ROL_   = 3'b011;
parameter RIGHT_ = 3'b100;
parameter LSR_   = 3'b101;
parameter ASR_   = 3'b110;
parameter ROR_   = 3'b111;          

wire [67:0] rddataA;
wire [67:0] rddataB;

wire [66:0] rddataAq;
wire [66:0] rddataBq;

reg [2:0] shiftype;
reg [4:0] shiftamount;    //32-bit max shift
reg [5:0] shiftamount1;

reg [63:0] brlshft_ROR;
reg [63:0] brlshft_ROL;
reg [31:0] shiftbucket;
reg [63:0] shiftin;
reg [63:0] shiftout;

reg Cout;

wire z_flag;
wire n_flag;

reg ready;

always @(posedge CLK) ready <= wren && (rdenA || rdenB) ? 1'b0 : 1'b1;

assign z_flag = ~|shiftin;
assign n_flag = shiftin[63];
 
assign rddataA = {rddataAq[66], V,  rddataAq[65:0]};    
assign rddataB = {rddataBq[66], V,  rddataBq[65:0]};    

RAM_func #(.ADDRS_WIDTH(4), .DATA_WIDTH(67))
    ram32_logic_SHIFT(
    .CLK        (CLK      ),
    .wren       (wren     ),
    .wraddrs    (wraddrs  ),
    .wrdata     ({Cout, n_flag, z_flag, shiftout}),
    .rdenA      (rdenA    ),
    .rdaddrsA   (rdaddrsA ),
    .rddataA    (rddataAq   ),
    .rdenB      (rdenB    ),
    .rdaddrsB   (rdaddrsB ),
    .rddataB    (rddataBq  ));
    
always @(*) begin
    case (shiftamount)
        5'h00 : brlshft_ROR = {shiftin[0],    shiftin[63:1]} ;
        5'h01 : brlshft_ROR = {shiftin[1:0],  shiftin[63:2]} ;
        5'h02 : brlshft_ROR = {shiftin[2:0],  shiftin[63:3]} ;
        5'h03 : brlshft_ROR = {shiftin[3:0],  shiftin[63:4]} ;
        5'h04 : brlshft_ROR = {shiftin[4:0],  shiftin[63:5]} ;
        5'h05 : brlshft_ROR = {shiftin[5:0],  shiftin[63:6]} ;
        5'h06 : brlshft_ROR = {shiftin[6:0],  shiftin[63:7]} ;
        5'h07 : brlshft_ROR = {shiftin[7:0],  shiftin[63:8]} ;
        5'h08 : brlshft_ROR = {shiftin[8:0],  shiftin[63:9]} ;
        5'h09 : brlshft_ROR = {shiftin[9:0],  shiftin[63:10]};
        5'h0A : brlshft_ROR = {shiftin[10:0], shiftin[63:11]};
        5'h0B : brlshft_ROR = {shiftin[11:0], shiftin[63:12]};
        5'h0C : brlshft_ROR = {shiftin[12:0], shiftin[63:13]};
        5'h0D : brlshft_ROR = {shiftin[13:0], shiftin[63:14]};
        5'h0E : brlshft_ROR = {shiftin[14:0], shiftin[63:15]};
        5'h0F : brlshft_ROR = {shiftin[15:0], shiftin[63:16]};
        5'h10 : brlshft_ROR = {shiftin[16:0], shiftin[63:17]};
        5'h11 : brlshft_ROR = {shiftin[17:0], shiftin[63:18]};
        5'h12 : brlshft_ROR = {shiftin[18:0], shiftin[63:19]};
        5'h13 : brlshft_ROR = {shiftin[19:0], shiftin[63:20]};
        5'h14 : brlshft_ROR = {shiftin[20:0], shiftin[63:21]};
        5'h15 : brlshft_ROR = {shiftin[21:0], shiftin[63:22]};
        5'h16 : brlshft_ROR = {shiftin[22:0], shiftin[63:23]};
        5'h17 : brlshft_ROR = {shiftin[23:0], shiftin[63:24]};
        5'h18 : brlshft_ROR = {shiftin[24:0], shiftin[63:25]};
        5'h19 : brlshft_ROR = {shiftin[25:0], shiftin[63:26]};
        5'h1A : brlshft_ROR = {shiftin[26:0], shiftin[63:27]};
        5'h1B : brlshft_ROR = {shiftin[27:0], shiftin[63:28]};
        5'h1C : brlshft_ROR = {shiftin[28:0], shiftin[63:29]};
        5'h1D : brlshft_ROR = {shiftin[29:0], shiftin[63:30]};
        5'h1E : brlshft_ROR = {shiftin[30:0], shiftin[63:31]};
        5'h1F : brlshft_ROR = {shiftin[31:0], shiftin[63:32]};
    endcase                                      
end                                              

always @(*) begin
    case (shiftamount)
         5'h00 : brlshft_ROL = {shiftin[62:0], shiftin[63]}   ;
         5'h01 : brlshft_ROL = {shiftin[61:0], shiftin[63:62]};
         5'h02 : brlshft_ROL = {shiftin[60:0], shiftin[63:61]};
         5'h03 : brlshft_ROL = {shiftin[59:0], shiftin[63:60]};
         5'h04 : brlshft_ROL = {shiftin[58:0], shiftin[63:59]};
         5'h05 : brlshft_ROL = {shiftin[57:0], shiftin[63:58]};
         5'h06 : brlshft_ROL = {shiftin[56:0], shiftin[63:57]};
         5'h07 : brlshft_ROL = {shiftin[55:0], shiftin[63:56]};
         5'h08 : brlshft_ROL = {shiftin[54:0], shiftin[63:55]};
         5'h09 : brlshft_ROL = {shiftin[53:0], shiftin[63:54]};
         5'h0A : brlshft_ROL = {shiftin[52:0], shiftin[63:53]};
         5'h0B : brlshft_ROL = {shiftin[51:0], shiftin[63:52]};
         5'h0C : brlshft_ROL = {shiftin[50:0], shiftin[63:51]};
         5'h0D : brlshft_ROL = {shiftin[49:0], shiftin[63:50]};
         5'h0E : brlshft_ROL = {shiftin[48:0], shiftin[63:49]};
         5'h0F : brlshft_ROL = {shiftin[47:0], shiftin[63:48]};
         5'h10 : brlshft_ROL = {shiftin[46:0], shiftin[63:47]};
         5'h11 : brlshft_ROL = {shiftin[45:0], shiftin[63:46]};
         5'h12 : brlshft_ROL = {shiftin[44:0], shiftin[63:45]};
         5'h13 : brlshft_ROL = {shiftin[43:0], shiftin[63:44]};
         5'h14 : brlshft_ROL = {shiftin[42:0], shiftin[63:43]};
         5'h15 : brlshft_ROL = {shiftin[41:0], shiftin[63:42]};
         5'h16 : brlshft_ROL = {shiftin[40:0], shiftin[63:41]};
         5'h17 : brlshft_ROL = {shiftin[39:0], shiftin[63:40]};
         5'h18 : brlshft_ROL = {shiftin[38:0], shiftin[63:39]};
         5'h19 : brlshft_ROL = {shiftin[37:0], shiftin[63:38]};
         5'h1A : brlshft_ROL = {shiftin[36:0], shiftin[63:37]};
         5'h1B : brlshft_ROL = {shiftin[35:0], shiftin[63:36]};
         5'h1C : brlshft_ROL = {shiftin[34:0], shiftin[63:35]};
         5'h1D : brlshft_ROL = {shiftin[33:0], shiftin[63:34]};
         5'h1E : brlshft_ROL = {shiftin[32:0], shiftin[63:33]};
         5'h1F : brlshft_ROL = {shiftin[31:0], shiftin[63:32]};
    endcase
end        
    
always @(*) begin
    case (shiftype)
        LEFT_  : begin
                     shiftout = shiftin << shiftamount1;
                     Cout = C;
                  end

        LSL_   : begin
                     {Cout, shiftout} = {shiftin, 1'b0} << shiftamount1;
                 end
                                                     
        ASL_   : begin
                     shiftout = shiftin << shiftamount1;
                     Cout = C;
                 end
                                                     
        ROL_   : begin
                     shiftout =  brlshft_ROL;
                     Cout = C;
                 end
                 
        RIGHT_ : begin
                     shiftout = shiftin >> shiftamount1;
                     Cout = C;
                 end
                 
        LSR_   : begin
                     {shiftout, Cout} = {1'b0, shiftin} >> shiftamount1;
                 end
                 
        ASR_   : begin
                     {shiftbucket, shiftout[63:0]} = {{32{shiftin[63]}}, shiftin[63:0]} >> shiftamount1;
                     Cout = C;
                 end
                 
        ROR_   : begin
                     shiftout =  brlshft_ROR;
                     Cout = C;
                end
    endcase
end

always @(*) begin
    if (wren) begin
        shiftin   = oprndA;
        shiftype  = oprndB_shiftype[2:0];
        shiftamount = oprndB_shiftamount[4:0];
        shiftamount1 = oprndB_shiftamount[4:0] + 1'b1;
    end    
    else begin
        shiftin = 64'h0000_0000_0000_0000;    
        shiftype = 3'b000;
        shiftamount = 5'b00000;
        shiftamount1 = 6'b000000;
    end    
end            

endmodule