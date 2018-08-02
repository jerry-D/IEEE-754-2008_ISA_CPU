 //extMemIF.v
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
 

module extMemIF(
    CLK,
    SrcA_addrs_q0,
    Dest_addrs_q2,
    wrcycl,
    Sext_Dest_q2,
    Size_Dest_q2,
    Size_SrcA_q0,
    wrsrcAdataSext,
    ext_rddata,
    ext_rddataq,
    DOUTq,
    ext_write_q3,
    ext_read_q1,
    
    CEN,   
    CE123, 
    WE,    
    BWh,   
    BWg,   
    BWf,   
    BWe,   
    BWd,   
    BWc,   
    BWb,   
    BWa,   
    adv_LD,
    A, 
    OE
    );

input         CLK;
input  [31:0] SrcA_addrs_q0;
input  [31:0] Dest_addrs_q2;
input         wrcycl;
input         Sext_Dest_q2;
input  [1:0]  Size_Dest_q2;
input  [1:0]  Size_SrcA_q0;
input  [63:0] wrsrcAdataSext;
input  [63:0] ext_rddata;
output [63:0] ext_rddataq;
output [63:0] DOUTq;
output        ext_read_q1;
output        ext_write_q3;



output CEN;   
output CE123; 
output WE;    
output BWh;   
output BWg;   
output BWf;   
output BWe;   
output BWd;   
output BWc;   
output BWb;   
output BWa;   
output adv_LD;
output [31:0] A;     
output OE;    

   
reg OE;
reg [63:0] DOUT;
reg [63:0] DOUTq;
reg ext_write_q3;
reg [4:0] word_rdA_sel;
reg [63:0] ext_rddataq;   //right justified read data
reg ext_read_q1;
reg [7:0] byte_sel;

wire CEN;   
wire CE123; 
wire WE;    
wire BWh;   
wire BWg;   
wire BWf;   
wire BWe;   
wire BWd;   
wire BWc;   
wire BWb;   
wire BWa;   
wire adv_LD;
wire [31:0] A;     

wire [4:0] word_wr_sel;
wire ext_write;
wire ext_read;

assign word_wr_sel = {Size_Dest_q2[1:0],  Dest_addrs_q2[2:0]};
assign ext_write = ~Dest_addrs_q2[31] && ~|Dest_addrs_q2[30:21] && Dest_addrs_q2[20] && wrcycl; 
assign ext_read  = ~SrcA_addrs_q0[31] && ~|SrcA_addrs_q0[30:21] && SrcA_addrs_q0[20];
assign A = ext_write ? Dest_addrs_q2 : (ext_read ? SrcA_addrs_q0 : 32'b0);
assign CEN = ~(ext_write || ext_read);
assign CE123 = (ext_write || ext_read);
assign WE = ~ext_write;
assign adv_LD = CEN;

assign BWh = Sext_Dest_q2 ? (byte_sel[0] && ext_write) : (byte_sel[7] && ext_write);
assign BWg = Sext_Dest_q2 ? (byte_sel[1] && ext_write) : (byte_sel[6] && ext_write);
assign BWf = Sext_Dest_q2 ? (byte_sel[2] && ext_write) : (byte_sel[5] && ext_write);
assign BWe = Sext_Dest_q2 ? (byte_sel[3] && ext_write) : (byte_sel[4] && ext_write);
assign BWd = Sext_Dest_q2 ? (byte_sel[4] && ext_write) : (byte_sel[3] && ext_write);
assign BWc = Sext_Dest_q2 ? (byte_sel[5] && ext_write) : (byte_sel[2] && ext_write);
assign BWb = Sext_Dest_q2 ? (byte_sel[6] && ext_write) : (byte_sel[1] && ext_write);
assign BWa = Sext_Dest_q2 ? (byte_sel[7] && ext_write) : (byte_sel[0] && ext_write);


always @(posedge CLK) begin
    OE <= ~ext_read;
    ext_read_q1 <= ext_read;   // v--- reverse endian-ness if Sext_Dest_q2 is set.
    DOUTq <= Sext_Dest_q2 ? {DOUT[7:0],  DOUT[15:8],  DOUT[23:16],  DOUT[31:24],  DOUT[39:32],  DOUT[47:40],  DOUT[55:48],  DOUT[63:56]} : DOUT;
    ext_write_q3 <= ext_write;
    word_rdA_sel <= {Size_SrcA_q0[1:0],  SrcA_addrs_q0[2:0]};
end 

always@(*)                                                                                           
    case(word_rdA_sel)                                                                                
        5'b00_000 : ext_rddataq = {56'h0000_0000_0000_00, ext_rddata[7:0]};       //bytes                    
        5'b00_001 : ext_rddataq = {56'h0000_0000_0000_00, ext_rddata[15:8]};                           
        5'b00_010 : ext_rddataq = {56'h0000_0000_0000_00, ext_rddata[23:16]};  
        5'b00_011 : ext_rddataq = {56'h0000_0000_0000_00, ext_rddata[31:24]};   
        5'b00_100 : ext_rddataq = {56'h0000_0000_0000_00, ext_rddata[39:32]}; 
        5'b00_101 : ext_rddataq = {56'h0000_0000_0000_00, ext_rddata[47:40]};
        5'b00_110 : ext_rddataq = {56'h0000_0000_0000_00, ext_rddata[55:48]};
        5'b00_111 : ext_rddataq = {56'h0000_0000_0000_00, ext_rddata[63:56]};
        
        5'b01_000, 
        5'b01_001 : ext_rddataq = {48'h0000_0000_0000, ext_rddata[15:0]};         //half-words
        5'b01_010,   
        5'b01_011 : ext_rddataq = {48'h0000_0000_0000, ext_rddata[31:16]};       
        5'b01_100,  
        5'b01_101 : ext_rddataq = {48'h0000_0000_0000, ext_rddata[47:32]};
        5'b01_110,
        5'b01_111 : ext_rddataq = {48'h0000_0000_0000, ext_rddata[63:48]};
        
        5'b10_000,       
        5'b10_001,
        5'b10_010,       
        5'b10_011 : ext_rddataq = {32'h000_0000, ext_rddata[31:0]};               //words
        5'b10_100,       
        5'b10_101,       
        5'b10_110,
        5'b10_111 : ext_rddataq = {32'h000_0000, ext_rddata[63:32]}; 
        
        5'b11_000,
        5'b11_001,
        5'b11_010,       
        5'b11_011,                 
        5'b11_100,
        5'b11_101,
        5'b11_110,        
        5'b11_111 : ext_rddataq = ext_rddata[63:0];                                 //double-words
    endcase


always@(*)          
        case(word_wr_sel)
            5'b00_000 : byte_sel = 8'b00000001;        //bytes
            5'b00_001 : byte_sel = 8'b00000010;
            5'b00_010 : byte_sel = 8'b00000100;
            5'b00_011 : byte_sel = 8'b00001000;
            5'b00_100 : byte_sel = 8'b00010000;
            5'b00_101 : byte_sel = 8'b00100000;
            5'b00_110 : byte_sel = 8'b01000000;
            5'b00_111 : byte_sel = 8'b10000000;
            
            5'b01_000, 
            5'b01_001 : byte_sel = 8'b00000011;        //half-words
            5'b01_010,  
            5'b01_011 : byte_sel = 8'b00001100;
            5'b01_100,  
            5'b01_101 : byte_sel = 8'b00110000;
            5'b01_110,
            5'b01_111 : byte_sel = 8'b11000000;
            
            5'b10_000,  
            5'b10_001,
            5'b10_010,  
            5'b10_011 : byte_sel = 8'b00001111;       //words
            5'b10_100,  
            5'b10_101,  
            5'b10_110,
            5'b10_111 : byte_sel = 8'b11110000;
            
            5'b11_000,
            5'b11_001,
            5'b11_010,  
            5'b11_011,   
            5'b11_100,
            5'b11_101,
            5'b11_110,  
            5'b11_111 : byte_sel = 8'b11111111;     //double words
        endcase
        

always@(*)                                                                                           
    case(word_wr_sel)                                                                                
        5'b00_000 : DOUT = {56'h0000_0000_0000_00, wrsrcAdataSext[7:0]};      //bytes                    
        5'b00_001 : DOUT = {48'h0000_0000_0000, wrsrcAdataSext[7:0], 8'h00};                          
        5'b00_010 : DOUT = {40'h0000_0000_00, wrsrcAdataSext[7:0], 16'h0000}; 
        5'b00_011 : DOUT = {32'h0000_0000, wrsrcAdataSext[7:0], 24'h00_0000};  
        5'b00_100 : DOUT = {24'h0000_00, wrsrcAdataSext[7:0], 32'h0000_0000};
        5'b00_101 : DOUT = {16'h0000, wrsrcAdataSext[7:0], 40'h00_0000_0000};
        5'b00_110 : DOUT = {8'h00, wrsrcAdataSext[7:0], 48'h0000_0000_0000};
        5'b00_111 : DOUT = {wrsrcAdataSext[7:0], 56'h00_0000_0000_0000};         
        
        5'b01_000, 
        5'b01_001 : DOUT = {48'h0000_0000_0000, wrsrcAdataSext[15:0]};       //half-words
        5'b01_010, 
        5'b01_011 : DOUT = {32'h0000_0000, wrsrcAdataSext[15:0], 16'h0000};      
        5'b01_100, 
        5'b01_101 : DOUT = {16'h0000, wrsrcAdataSext[15:0], 32'h0000_0000};
        5'b01_110,
        5'b01_111 : DOUT = {wrsrcAdataSext[15:0], 48'h0000_0000_0000};
        
        5'b10_000,       
        5'b10_001,
        5'b10_010,       
        5'b10_011 : DOUT = {32'h000_0000_0000, wrsrcAdataSext[31:0]};             //words
        5'b10_100,  
        5'b10_101,  
        5'b10_110,
        5'b10_111 : DOUT = {wrsrcAdataSext[31:0], 32'h000_0000_0000};   
        
        5'b11_000,
        5'b11_001,
        5'b11_010,       
        5'b11_011,                 
        5'b11_100,
        5'b11_101,
        5'b11_110,        
        5'b11_111 : DOUT = wrsrcAdataSext[63:0];                                 //double-words
    endcase

endmodule
