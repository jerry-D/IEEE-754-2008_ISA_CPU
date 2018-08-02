// func_cnvTHC.v
 
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


 `timescale 1ns/100ps

module func_cnvTHC (
    RESET,
    CLK,
    Sext_SrcA_q1,
    Sext_SrcB_q1,
    wren,
    wraddrs,
    oprndA,
    C,
    V,
    N,
    Z,
    rdenA,
    rdaddrsA,
    rddataA,
    rdenB,
    rdaddrsB,
    rddataB,
    ready
    );

input RESET, CLK, wren, rdenA, rdenB;
input [3:0] wraddrs, rdaddrsA, rdaddrsB;   // {thread, addrs}
input [63:0] oprndA;
input Sext_SrcA_q1;
input Sext_SrcB_q1;

output [67:0] rddataA, rddataB;
output ready;

input C;
input V;
input N;
input Z;

reg readyA;
reg readyB;

reg [15:0] semaphor;  // one for each memory location
reg [4:0] delay0;

reg [63:0] oprndAq;
reg [63:0] oprndBq;

reg Cin;
reg Vin;
reg Nin;
reg Zin;

wire wrenq;
wire [3:0] wraddrsq;

wire ready;

wire [67:0] rddataA, rddataB; 
wire [127:0] rddataA_, rddataB_; 

wire [127:0] R;

assign rddataA = Sext_SrcA_q1 ? {Cin, Vin, Nin, Zin, rddataA_[127:64]} : {Cin, Vin, Nin, Zin, rddataA_[63:0]};
assign rddataB = Sext_SrcB_q1 ? {Cin, Vin, Nin, Zin, rddataB_[127:64]} : {Cin, Vin, Nin, Zin, rddataB_[63:0]};

assign wrenq = delay0[4];
assign wraddrsq = delay0[3:0];

assign ready = readyA && readyB;

cnvTHC cnvTHC_15(
    .nybleIn(oprndAq[63:60]),
    .charOut(R[127:120])
    );

cnvTHC cnvTHC_14(
    .nybleIn(oprndAq[59:56]),
    .charOut(R[119:112])
    );

cnvTHC cnvTHC_13(
    .nybleIn(oprndAq[55:52]),
    .charOut(R[111:104])
    );

cnvTHC cnvTHC_12(
    .nybleIn(oprndAq[51:48]),
    .charOut(R[103:96])
    );

cnvTHC cnvTHC_11(
    .nybleIn(oprndAq[47:44]),
    .charOut(R[95:88])
    );

cnvTHC cnvTHC_10(
    .nybleIn(oprndAq[43:40]),
    .charOut(R[87:80])
    );

cnvTHC cnvTHC_9(
    .nybleIn(oprndAq[39:36]),
    .charOut(R[79:72])
    );

cnvTHC cnvTHC_8(
    .nybleIn(oprndAq[35:32]),
    .charOut(R[71:64])
    );

cnvTHC cnvTHC_7(
    .nybleIn(oprndAq[31:28]),
    .charOut(R[63:56])
    );

cnvTHC cnvTHC_6(
    .nybleIn(oprndAq[27:24]),
    .charOut(R[55:48])
    );

cnvTHC cnvTHC_5(
    .nybleIn(oprndAq[23:20]),
    .charOut(R[47:40])
    );

cnvTHC cnvTHC_4(
    .nybleIn(oprndAq[19:16]),
    .charOut(R[39:32])
    );

cnvTHC cnvTHC_3(
    .nybleIn(oprndAq[15:12]),
    .charOut(R[31:24])
    );

cnvTHC cnvTHC_2(
    .nybleIn(oprndAq[11:8]),
    .charOut(R[23:16])
    );

cnvTHC cnvTHC_1(
    .nybleIn(oprndAq[7:4]),
    .charOut(R[15:8])
    );

cnvTHC cnvTHC_0(
    .nybleIn(oprndAq[3:0]),
    .charOut(R[7:0])
    );


RAM_func #(.ADDRS_WIDTH(4), .DATA_WIDTH(128))
    ram64_cnvTHC(
    .CLK        (CLK      ),
    .wren       (wrenq    ),
    .wraddrs    (wraddrsq ),   
    .wrdata     ( R       ), 
    .rdenA      (rdenA    ),   
    .rdaddrsA   (rdaddrsA),
    .rddataA    (rddataA_ ),
    .rdenB      (rdenB    ),
    .rdaddrsB   (rdaddrsB ),
    .rddataB    (rddataB_ ));

always @(posedge CLK)
    if(rdenA || rdenB) begin                      
         Cin <= C;
         Vin <= V;
         Nin <= N;
         Zin <= Z;
    end 
    


always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        oprndAq <= 64'h0000_0000_0000_0000;
     end
    else begin
        if (wren) begin
           oprndAq <= oprndA;
        end    
        else begin
           oprndAq <= 64'h0000_0000_0000_0000;
        end    
    end    
end            

always@(posedge CLK or posedge RESET) begin
    if (RESET) begin
        delay0  <= 5'h00;
    end    
    else begin
        delay0  <= {wren, wraddrs};
    end 
end        

always @(posedge CLK or posedge RESET) begin
    if (RESET) semaphor <= 16'hFFFF;
    else begin
        if (wren) semaphor[wraddrs] <= 1'b0;
        if (wrenq) semaphor[wraddrsq] <= 1'b1;
    end
end

always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        readyA <= 1'b1;
        readyB <= 1'b1;
    end  
    else begin
         readyA <= rdenA ? semaphor[rdaddrsA] : 1'b1;
         readyB <= rdenB ? semaphor[rdaddrsB] : 1'b1;
    end   
end

endmodule
