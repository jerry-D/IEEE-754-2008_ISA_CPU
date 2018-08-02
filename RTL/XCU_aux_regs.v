 // aux_regs.v
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
                                                                                                                     

module XCU_DATA_ADDRS(
    CLK,
    RESET,
    q2_sel,
    wrcycl,
    wrsrcAdata,
    Dam_q0,                  
    Dam_q1,                  
    Dam_q2,                
    Ind_Dest_q0,
    Ind_Dest_q1,
    Ind_SrcA_q0,
    Ind_SrcB_q0,
    Imod_Dest_q2,
    Imod_SrcA_q0,
    Imod_SrcB_q0,
    OPdest_q0,
    OPdest_q1,
    OPdest_q2,
    OPsrcA_q0,
    OPsrcB_q0,
    OPsrc32_q0,            
    Ind_Dest_q2,
    Dest_addrs_q2,
    SrcA_addrs_q0,
    SrcB_addrs_q0,
    AR0,
    AR1,
    AR2,
    AR3,
    AR4,
    AR5,
    AR6,
    SP,
    discont,
    ind_mon_read_q0, 
    ind_mon_write_q2,
    rewind_PC
    );

input         CLK;
input         RESET;
input         q2_sel;
input         wrcycl;
input [31:0]  wrsrcAdata;
input [1:0]   Dam_q0;      
input [1:0]   Dam_q1;      
input [1:0]   Dam_q2;      
input         Ind_Dest_q0;
input         Ind_Dest_q1;
input         Ind_SrcA_q0;
input         Ind_SrcB_q0;
input         Imod_Dest_q2;
input         Imod_SrcA_q0;
input         Imod_SrcB_q0;
input [15:0]  OPdest_q0;
input [15:0]  OPdest_q1;
input [15:0]  OPdest_q2;
input [15:0]  OPsrcA_q0;
input [15:0]  OPsrcB_q0;
input [31:0]  OPsrc32_q0;
input         Ind_Dest_q2;
output [31:0] Dest_addrs_q2;
output [31:0] SrcA_addrs_q0;
output [31:0] SrcB_addrs_q0;
output [31:0] AR0;
output [31:0] AR1;
output [31:0] AR2;
output [31:0] AR3;
output [31:0] AR4;
output [31:0] AR5;
output [31:0] AR6;
output [31:0] SP;
input         discont;
input ind_mon_read_q0; 
input ind_mon_write_q2;
input         rewind_PC;

parameter     ROM_ADDRS  = 'b1111111xxxxxxxxxxx; //rom in this implementation is only 32k bytes (4k x 64), shared by all threads
parameter     RAM_ADDRS  = 'b0000xxxxxxxxxxxxxx; //first 32k bytes (since data memory is byte-addressable and smallest RAM for this in Kintex 7 is 2k x 64 bits using two blocks next to each other
parameter     SP_ADDRS   = 'h0FFE8;
parameter    AR6_ADDRS   = 'h0FFE0;
parameter    AR5_ADDRS   = 'h0FFD8;
parameter    AR4_ADDRS   = 'h0FFD0;
parameter    AR3_ADDRS   = 'h0FFC8;
parameter    AR2_ADDRS   = 'h0FFC0;
parameter    AR1_ADDRS   = 'h0FFB8;
parameter    AR0_ADDRS   = 'h0FFB0;
parameter     PC_ADDRS   = 'h0FFA8;
parameter      PC_COPY   = 'h0FF90;
parameter     ST_ADDRS   = 'h0FF88;
parameter LPCNT1_ADDRS   = 'h0FF78;
parameter LPCNT0_ADDRS   = 'h0FF70;
parameter  TIMER_ADDRS   = 'h0FF68;
parameter   CREG_ADDRS   = 'h0FF60;
parameter  CAPT3_ADDRS   = 'h0FF58;
parameter  CAPT2_ADDRS   = 'h0FF50;
parameter  CAPT1_ADDRS   = 'h0FF48;
parameter  CAPT0_ADDRS   = 'h0FF40;

reg [31:0] DEST_ind; 
reg [31:0] SRC_A_ind; 
reg [31:0] SRC_B_ind;

reg [31:0] AR0;
reg [31:0] AR1;
reg [31:0] AR2;
reg [31:0] AR3;
reg [31:0] AR4;
reg [31:0] AR5;
reg [31:0] AR6;
reg [31:0]  SP;

wire [2:0] DEST_ARn_sel;
wire [2:0] SRC_A_sel; 	
wire [2:0] SRC_B_sel; 

wire [31:0] Dest_addrs_q2;
wire [31:0] SrcA_addrs_q0;
wire [31:0] SrcB_addrs_q0;

	
assign DEST_ARn_sel[2:0] = OPdest_q2[2:0];
assign SRC_A_sel[2:0] 	 = OPsrcA_q0[2:0];
assign SRC_B_sel[2:0] 	 = OPsrcB_q0[2:0];

assign Dest_addrs_q2 = Ind_Dest_q2 ?  DEST_ind :  {15'b0, OPdest_q2[15:0]};
assign SrcA_addrs_q0 = Ind_SrcA_q0 ?  SRC_A_ind : {15'b0, OPsrcA_q0[15:0]};
assign SrcB_addrs_q0 = Ind_SrcB_q0 ?  SRC_B_ind : {15'b0, OPsrcB_q0[15:0]};

always @(*) begin
     case (DEST_ARn_sel) 
     	3'b000 : DEST_ind = (Imod_Dest_q2 && Ind_Dest_q2) ? (AR0[31:0] + {{20{OPdest_q2[14]}}, OPdest_q2[14:3]}) : AR0[31:0]; 
     	3'b001 : DEST_ind = (Imod_Dest_q2 && Ind_Dest_q2) ? (AR1[31:0] + {{20{OPdest_q2[14]}}, OPdest_q2[14:3]}) : AR1[31:0]; 
     	3'b010 : DEST_ind = (Imod_Dest_q2 && Ind_Dest_q2) ? (AR2[31:0] + {{20{OPdest_q2[14]}}, OPdest_q2[14:3]}) : AR2[31:0]; 
     	3'b011 : DEST_ind = (Imod_Dest_q2 && Ind_Dest_q2) ? (AR3[31:0] + {{20{OPdest_q2[14]}}, OPdest_q2[14:3]}) : AR3[31:0];
     	3'b100 : DEST_ind = (Imod_Dest_q2 && Ind_Dest_q2) ? (AR4[31:0] + {{20{OPdest_q2[14]}}, OPdest_q2[14:3]}) : AR4[31:0]; 
     	3'b101 : DEST_ind = (Imod_Dest_q2 && Ind_Dest_q2) ? (AR5[31:0] + {{20{OPdest_q2[14]}}, OPdest_q2[14:3]}) : AR5[31:0]; 
     	3'b110 : DEST_ind = (Imod_Dest_q2 && Ind_Dest_q2) ? (AR6[31:0] + {{20{OPdest_q2[14]}}, OPdest_q2[14:3]}) : AR6[31:0]; 
     	3'b111 : DEST_ind = (Imod_Dest_q2 && Ind_Dest_q2) ? ( SP[31:0] + {{20{OPdest_q2[14]}}, OPdest_q2[14:3]}) :  SP[31:0] + {{20{OPdest_q2[14]}}, OPdest_q2[14:3]}; 
     endcase
end

always @(*) begin
   case (SRC_A_sel) 
   	   3'b000 : SRC_A_ind = (Imod_SrcA_q0 && Ind_SrcA_q0) ? (AR0[31:0] + {{20{OPsrcA_q0[14]}}, OPsrcA_q0[14:3]}) : AR0[31:0]; 
   	   3'b001 : SRC_A_ind = (Imod_SrcA_q0 && Ind_SrcA_q0) ? (AR1[31:0] + {{20{OPsrcA_q0[14]}}, OPsrcA_q0[14:3]}) : AR1[31:0]; 
   	   3'b010 : SRC_A_ind = (Imod_SrcA_q0 && Ind_SrcA_q0) ? (AR2[31:0] + {{20{OPsrcA_q0[14]}}, OPsrcA_q0[14:3]}) : AR2[31:0]; 
   	   3'b011 : SRC_A_ind = (Imod_SrcA_q0 && Ind_SrcA_q0) ? (AR3[31:0] + {{20{OPsrcA_q0[14]}}, OPsrcA_q0[14:3]}) : AR3[31:0];
   	   3'b100 : SRC_A_ind = (Imod_SrcA_q0 && Ind_SrcA_q0) ? (AR4[31:0] + {{20{OPsrcA_q0[14]}}, OPsrcA_q0[14:3]}) : AR4[31:0]; 
   	   3'b101 : SRC_A_ind = (Imod_SrcA_q0 && Ind_SrcA_q0) ? (AR5[31:0] + {{20{OPsrcA_q0[14]}}, OPsrcA_q0[14:3]}) : AR5[31:0]; 
   	   3'b110 : SRC_A_ind = (Imod_SrcA_q0 && Ind_SrcA_q0) ? (AR6[31:0] + {{20{OPsrcA_q0[14]}}, OPsrcA_q0[14:3]}) : AR6[31:0]; 
   	   3'b111 : SRC_A_ind = (Imod_SrcA_q0 && Ind_SrcA_q0) ? ( SP[31:0] + {{20{OPsrcA_q0[14]}}, OPsrcA_q0[14:3]}) :  SP[31:0];
   endcase
end

always @(*) begin
   case (SRC_B_sel) 
   	   3'b000 : SRC_B_ind = (Imod_SrcB_q0 && Ind_SrcB_q0) ? (AR0[31:0] + {{20{OPsrcB_q0[14]}}, OPsrcB_q0[14:3]}) : AR0[31:0]; 
   	   3'b001 : SRC_B_ind = (Imod_SrcB_q0 && Ind_SrcB_q0) ? (AR1[31:0] + {{20{OPsrcB_q0[14]}}, OPsrcB_q0[14:3]}) : AR1[31:0]; 
   	   3'b010 : SRC_B_ind = (Imod_SrcB_q0 && Ind_SrcB_q0) ? (AR2[31:0] + {{20{OPsrcB_q0[14]}}, OPsrcB_q0[14:3]}) : AR2[31:0]; 
   	   3'b011 : SRC_B_ind = (Imod_SrcB_q0 && Ind_SrcB_q0) ? (AR3[31:0] + {{20{OPsrcB_q0[14]}}, OPsrcB_q0[14:3]}) : AR3[31:0];
   	   3'b100 : SRC_B_ind = (Imod_SrcB_q0 && Ind_SrcB_q0) ? (AR4[31:0] + {{20{OPsrcB_q0[14]}}, OPsrcB_q0[14:3]}) : AR4[31:0]; 
   	   3'b101 : SRC_B_ind = (Imod_SrcB_q0 && Ind_SrcB_q0) ? (AR5[31:0] + {{20{OPsrcB_q0[14]}}, OPsrcB_q0[14:3]}) : AR5[31:0]; 
   	   3'b110 : SRC_B_ind = (Imod_SrcB_q0 && Ind_SrcB_q0) ? (AR6[31:0] + {{20{OPsrcB_q0[14]}}, OPsrcB_q0[14:3]}) : AR6[31:0]; 
   	   3'b111 : SRC_B_ind = (Imod_SrcB_q0 && Ind_SrcB_q0) ? ( SP[31:0] + {{20{OPsrcB_q0[14]}}, OPsrcB_q0[14:3]}) :  SP[31:0];
   endcase
end        

always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
       AR0 <= 0;  
       AR1 <= 0; 
       AR2 <= 0; 
       AR3 <= 0;
       AR4 <= 0; 
       AR5 <= 0; 
       AR6 <= 0; 
       SP  <= 'h0FF8;             //initialize to middle of direct RAM
    end
    else begin
    
        //immediate loads of ARn occur during instruction fetch (state0) -- dest must be direct
        //direct write to ARn during newthreadq has priority over any update
        if (~discont &&  Dam_q0[1] && Dam_q0[0] && ~Ind_Dest_q0 && OPdest_q0==AR0_ADDRS[15:0]) AR0[31:0] <= OPsrc32_q0[31:0];     //immediate (up to 32 bits with Dam = 11) loads of ARn occur during instruction fetch (state0)
        if (~discont && ~Dam_q0[1] && Dam_q0[0] && ~Ind_Dest_q0 && OPdest_q0==AR0_ADDRS[15:0]) AR0[31:0] <= {2'b00, OPsrcB_q0[15:0]};   //immediate (up to 16 bits with Dam = 01) loads of ARn occur during instruction fetch (state0)
        //direct or table-read loads of ARn occur during usual write (state2)
        if (wrcycl && ~Ind_Dest_q2 && q2_sel && OPdest_q2[15:0]==AR0_ADDRS[15:0]) AR0[31:0] <= wrsrcAdata[31:0];                                                  
        
        if (~discont &&  Dam_q0[1] && Dam_q0[0] && ~Ind_Dest_q0 && OPdest_q0==AR1_ADDRS[15:0]) AR1[31:0] <= OPsrc32_q0[31:0];     //immediate (up to 32 bits with Dam = 11) loads of ARn occur during instruction fetch (state0)
        if (~discont && ~Dam_q0[1] && Dam_q0[0] && ~Ind_Dest_q0 && OPdest_q0==AR1_ADDRS[15:0]) AR1[31:0] <= {2'b00, OPsrcB_q0[15:0]};   //immediate (up to 16 bits with Dam = 01) loads of ARn occur during instruction fetch (state0)
        //direct or table-read loads of ARn occur during usual write (state2)
        if (wrcycl && ~Ind_Dest_q2 && q2_sel && OPdest_q2[15:0]==AR1_ADDRS[15:0]) AR1[31:0] <= wrsrcAdata[31:0];                                                  
    
        if (~discont &&  Dam_q0[1] && Dam_q0[0] && ~Ind_Dest_q0 && OPdest_q0==AR2_ADDRS[15:0]) AR2[31:0] <= OPsrc32_q0[31:0];     //immediate (up to 32 bits with Dam = 11) loads of ARn occur during instruction fetch (state0)
        if (~discont && ~Dam_q0[1] && Dam_q0[0] && ~Ind_Dest_q0 && OPdest_q0==AR2_ADDRS[15:0]) AR2[31:0] <= {2'b00, OPsrcB_q0[15:0]};   //immediate (up to 16 bits with Dam = 01) loads of ARn occur during instruction fetch (state0)
        //direct or table-read loads of ARn occur during usual write (state2)
        if (wrcycl && ~Ind_Dest_q2 && q2_sel && OPdest_q2[15:0]==AR2_ADDRS[15:0]) AR2[31:0] <= wrsrcAdata[31:0];                                                  
    
        if (~discont &&  Dam_q0[1] && Dam_q0[0] && ~Ind_Dest_q0 && OPdest_q0==AR3_ADDRS[15:0]) AR3[31:0] <= OPsrc32_q0[31:0];     //immediate (up to 32 bits with Dam = 11) loads of ARn occur during instruction fetch (state0)
        if (~discont && ~Dam_q0[1] && Dam_q0[0] && ~Ind_Dest_q0 && OPdest_q0==AR3_ADDRS[15:0]) AR3[31:0] <= {2'b00, OPsrcB_q0[15:0]};   //immediate (up to 16 bits with Dam = 01) loads of ARn occur during instruction fetch (state0)
        //direct or table-read loads of ARn occur during usual write (state2)
        if (wrcycl && ~Ind_Dest_q2 && q2_sel && OPdest_q2[15:0]==AR3_ADDRS[15:0]) AR3[31:0] <= wrsrcAdata[31:0];                                                  
    
        if (~discont &&  Dam_q0[1] && Dam_q0[0] && ~Ind_Dest_q0 && OPdest_q0==AR4_ADDRS[15:0]) AR4[31:0] <= OPsrc32_q0[31:0];     //immediate (up to 32 bits with Dam = 11) loads of ARn occur during instruction fetch (state0)
        if (~discont && ~Dam_q0[1] && Dam_q0[0] && ~Ind_Dest_q0 && OPdest_q0==AR4_ADDRS[15:0]) AR4[31:0] <= {2'b00, OPsrcB_q0[15:0]};   //immediate (up to 16 bits with Dam = 01) loads of ARn occur during instruction fetch (state0)
        //direct or table-read loads of ARn occur during usual write (state2)
        if (wrcycl && ~Ind_Dest_q2 && q2_sel && OPdest_q2[15:0]==AR4_ADDRS[15:0]) AR4[31:0] <= wrsrcAdata[31:0];                                                  
    
        if (~discont &&  Dam_q0[1] && Dam_q0[0] && ~Ind_Dest_q0 && OPdest_q0==AR5_ADDRS[15:0]) AR5[31:0] <= OPsrc32_q0[31:0];     //immediate (up to 32 bits with Dam = 11) loads of ARn occur during instruction fetch (state0)
        if (~discont && ~Dam_q0[1] && Dam_q0[0] && ~Ind_Dest_q0 && OPdest_q0==AR5_ADDRS[15:0]) AR5[31:0] <= {2'b00, OPsrcB_q0[15:0]};   //immediate (up to 16 bits with Dam = 01) loads of ARn occur during instruction fetch (state0)
        //direct or table-read loads of ARn occur during usual write (state2)
        if (wrcycl && ~Ind_Dest_q2 && q2_sel && OPdest_q2[15:0]==AR5_ADDRS[15:0]) AR5[31:0] <= wrsrcAdata[31:0];                                                  
    
        if (~discont &&  Dam_q0[1] && Dam_q0[0] && ~Ind_Dest_q0 && OPdest_q0==AR6_ADDRS[15:0]) AR6[31:0] <= OPsrc32_q0[31:0];     //immediate (up to 32 bits with Dam = 11) loads of ARn occur during instruction fetch (state0)
        if (~discont && ~Dam_q0[1] && Dam_q0[0] && ~Ind_Dest_q0 && OPdest_q0==AR6_ADDRS[15:0]) AR6[31:0] <= {2'b00, OPsrcB_q0[15:0]};   //immediate (up to 16 bits with Dam = 01) loads of ARn occur during instruction fetch (state0)
        //direct or table-read loads of ARn occur during usual write (state2)
        if (wrcycl && ~Ind_Dest_q2 && q2_sel && OPdest_q2[15:0]==AR6_ADDRS[15:0]) AR6[31:0] <= wrsrcAdata[31:0];                                                  
    
        if (~discont &&  Dam_q0[1] && Dam_q0[0] && ~Ind_Dest_q0 && OPdest_q0==SP_ADDRS[15:0])   SP[31:0] <= OPsrc32_q0[31:0];     //immediate (up to 32 bits with Dam = 11) loads of ARn occur during instruction fetch (state0)
        if (~discont && ~Dam_q0[1] && Dam_q0[0] && ~Ind_Dest_q0 && OPdest_q0==SP_ADDRS[15:0])   SP[31:0] <= {2'b00, OPsrcB_q0[15:0]};   //immediate (up to 16 bits with Dam = 01) loads of ARn occur during instruction fetch (state0)
        //direct or table-read loads of ARn occur during usual write (state2)
        if (wrcycl && ~Ind_Dest_q2 && q2_sel && OPdest_q2[15:0]==SP_ADDRS[15:0] )  SP[31:0] <= wrsrcAdata[31:0];
                                                          
//auto-post-modification section 
        //auto post modification of ARs and SP for read cycle occur after state 1
        if (~discont && ~ind_mon_read_q0 && (OPsrcA_q0[2:0]==3'b000) && Ind_SrcA_q0 && ~&Dam_q0[1:0] && ~Imod_SrcA_q0) AR0[31:0] <= AR0[31:0] +  {{20{OPsrcA_q0[14]}}, OPsrcA_q0[14:3]};
        if (~discont && ~ind_mon_read_q0 && (OPsrcB_q0[2:0]==3'b000) && Ind_SrcB_q0 && ~Dam_q0[0] && ~Imod_SrcB_q0) AR0[31:0] <= AR0[31:0] +  {{20{OPsrcB_q0[14]}}, OPsrcB_q0[14:3]};
        //auto post modification of ARs and SP for write cycle occur after state 2
        if (~ind_mon_write_q2 && (wrcycl && OPdest_q2[2:0]==3'b000) && q2_sel && Ind_Dest_q2 && ~Imod_Dest_q2) AR0[31:0] <= AR0[31:0] + {{20{OPdest_q2[14]}}, OPdest_q2[14:3]};

        //auto post modification of ARs and SP for read cycle occur after state 1
        if (~discont && ~ind_mon_read_q0 && (OPsrcA_q0[2:0]==3'b001) && Ind_SrcA_q0 && ~&Dam_q0[1:0] && ~Imod_SrcA_q0) AR1[31:0] <= AR1[31:0] +  {{20{OPsrcA_q0[14]}},  OPsrcA_q0[14:3]};
        if (~discont && ~ind_mon_read_q0 && (OPsrcB_q0[2:0]==3'b001) && Ind_SrcB_q0 && ~Dam_q0[0] && ~Imod_SrcB_q0) AR1[31:0] <= AR1[31:0] +  {{20{OPsrcB_q0[14]}},  OPsrcB_q0[14:3]};
        //auto post modification of ARs and SP for write cycle occur after state 2
        if (~ind_mon_write_q2 && (wrcycl && OPdest_q2[2:0]==3'b001) && q2_sel && Ind_Dest_q2 && ~Imod_Dest_q2) AR1[31:0] <= AR1[31:0] + {{20{OPdest_q2[14]}}, OPdest_q2[14:3]};

        //auto post modification of ARs and SP for read cycle occur after state 1
        if (~discont && ~ind_mon_read_q0 && (OPsrcA_q0[2:0]==3'b010) && Ind_SrcA_q0 && ~&Dam_q0[1:0] && ~Imod_SrcA_q0) AR2[31:0] <= AR2[31:0] +  {{20{OPsrcA_q0[14]}},  OPsrcA_q0[14:3]};
        if (~discont && ~ind_mon_read_q0 && (OPsrcB_q0[2:0]==3'b010) && Ind_SrcB_q0 && ~Dam_q0[0] && ~Imod_SrcB_q0) AR2[31:0] <= AR2[31:0] +  {{20{OPsrcB_q0[14]}},  OPsrcB_q0[14:3]};
        //auto post modification of ARs and SP for write cycle occur after state 2
        if (~ind_mon_write_q2 && (wrcycl && OPdest_q2[2:0]==3'b010) && q2_sel && Ind_Dest_q2 && ~Imod_Dest_q2) AR2[31:0] <= AR2[31:0] + {{20{OPdest_q2[14]}}, OPdest_q2[14:3]};

        //auto post modification of ARs and SP for read cycle occur after state 1
        if (~discont && ~ind_mon_read_q0 && (OPsrcA_q0[2:0]==3'b011) && Ind_SrcA_q0 && ~&Dam_q0[1:0] && ~Imod_SrcA_q0) AR3[31:0] <= AR3[31:0] +  {{20{OPsrcA_q0[14]}},  OPsrcA_q0[14:3]};
        if (~discont && ~ind_mon_read_q0 && (OPsrcB_q0[2:0]==3'b011) && Ind_SrcB_q0 && ~Dam_q0[0] && ~Imod_SrcB_q0) AR3[31:0] <= AR3[31:0] +  {{20{OPsrcB_q0[14]}},  OPsrcB_q0[14:3]};
        //auto post modification of ARs and SP for write cycle occur after state 2
        if (~ind_mon_write_q2 && (wrcycl && OPdest_q2[2:0]==3'b011) && q2_sel && Ind_Dest_q2 && ~Imod_Dest_q2) AR3[31:0] <= AR3[31:0] + {{20{OPdest_q2[14]}}, OPdest_q2[14:3]};

        //auto post modification of ARs and SP for read cycle occur after state 1
        if (~discont && ~ind_mon_read_q0 && (OPsrcA_q0[2:0]==3'b100) && Ind_SrcA_q0 && ~&Dam_q0[1:0] && ~Imod_SrcA_q0) AR4[31:0] <= AR4[31:0] +  {{20{OPsrcA_q0[14]}},  OPsrcA_q0[14:3]};
        if (~discont && ~ind_mon_read_q0 && (OPsrcB_q0[2:0]==3'b100) && Ind_SrcB_q0 && ~Dam_q0[0] && ~Imod_SrcB_q0) AR4[31:0] <= AR4[31:0] +  {{20{OPsrcB_q0[14]}},  OPsrcB_q0[14:3]};
        //auto post modification of ARs and SP for write cycle occur after state 2
        if (~ind_mon_write_q2 && (wrcycl && OPdest_q2[2:0]==3'b100) && q2_sel && Ind_Dest_q2 && ~Imod_Dest_q2) AR4[31:0] <= AR4[31:0] + {{20{OPdest_q2[14]}}, OPdest_q2[14:3]};

        //auto post modification of ARs and SP for read cycle occur after state 1
        if (~discont && ~ind_mon_read_q0 && (OPsrcA_q0[2:0]==3'b101) && Ind_SrcA_q0 && ~&Dam_q0[1:0] && ~Imod_SrcA_q0) AR5[31:0] <= AR5[31:0] +  {{20{OPsrcA_q0[14]}},  OPsrcA_q0[14:3]};
        if (~discont && ~ind_mon_read_q0 && (OPsrcB_q0[2:0]==3'b101) && Ind_SrcB_q0 && ~Dam_q0[0] && ~Imod_SrcB_q0) AR5[31:0] <= AR5[31:0] +  {{20{OPsrcB_q0[14]}},  OPsrcB_q0[14:3]};
        //auto post modification of ARs and SP for write cycle occur after state 2
        if (~ind_mon_write_q2 && (wrcycl && OPdest_q2[2:0]==3'b101) && q2_sel && Ind_Dest_q2 && ~Imod_Dest_q2) AR5[31:0] <= AR5[31:0] + {{20{OPdest_q2[14]}}, OPdest_q2[14:3]};

        //auto post modification of ARs and SP for read cycle occur after state 1
        if (~discont && ~ind_mon_read_q0 && (OPsrcA_q0[2:0]==3'b110) && Ind_SrcA_q0 && ~&Dam_q0[1:0] && ~Imod_SrcA_q0) AR6[31:0] <= AR6[31:0] +  {{20{OPsrcA_q0[14]}},  OPsrcA_q0[14:3]};
        if (~discont && ~ind_mon_read_q0 && (OPsrcB_q0[2:0]==3'b110) && Ind_SrcB_q0 && ~Dam_q0[0] && ~Imod_SrcB_q0) AR6[31:0] <= AR6[31:0] +  {{20{OPsrcB_q0[14]}},  OPsrcB_q0[14:3]};
        //auto post modification of ARs and SP for write cycle occur after state 2
        if (~ind_mon_write_q2 && (wrcycl && OPdest_q2[2:0]==3'b110) && q2_sel && Ind_Dest_q2 && ~Imod_Dest_q2) AR6[31:0] <= AR6[31:0] + {{20{OPdest_q2[14]}}, OPdest_q2[14:3]};

        //auto post modification of ARs and SP for read cycle occur after state 1
        if (~discont && ~ind_mon_read_q0 && (OPsrcA_q0[2:0]==3'b111) && Ind_SrcA_q0 && ~&Dam_q0[1:0] && ~Imod_SrcA_q0)  SP[31:0] <=  SP[31:0] +  {{20{OPsrcA_q0[14]}},  OPsrcA_q0[14:3]};
        if (~discont && ~ind_mon_read_q0 && (OPsrcB_q0[2:0]==3'b111) && Ind_SrcB_q0 && ~Dam_q0[0] && ~Imod_SrcB_q0)  SP[31:0] <=  SP[31:0] +  {{20{OPsrcB_q0[14]}},  OPsrcB_q0[14:3]};
        //auto post modification of ARs and SP for write cycle occur after state 2
        if (~ind_mon_write_q2 && (wrcycl && OPdest_q2[2:0]==3'b111) && q2_sel && Ind_Dest_q2 && ~Imod_Dest_q2)  SP[31:0] <=  SP[31:0] + {{20{OPdest_q2[14]}}, OPdest_q2[14:3]};
       
    end
end 

   
endmodule   
