// exc_capture.v
 
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

module exc_capture (     // exception quasi-trace buffer
    CLK,
    RESET,
    srcA_q1,
    srcB_q1,
    Size_SrcA_q1,
    Size_SrcB_q1,
    dest_q2,
    pc_q1,
    rdSrcAdata,
    rdSrcBdata,
    exc_codeA,
    exc_codeB,
    rdenA,
    rdenB,
    fp_ready_q1,
    enAltImmInexactHandl  ,
    enAltImmUnderflowHandl,
    enAltImmOverflowHandl ,
    enAltImmDivByZeroHandl,
    enAltImmInvalidHandl  ,
    invalid_in_service,
    divby0_in_service, 
    overflow_in_service, 
    underflow_in_service,
    inexact_in_service,    
    TrapInexact_q1   ,
    TrapUnderflow_q1 ,
    TrapOverflow_q1  ,
    TrapDivX0_q1     ,
    TrapInvalid_q1   ,
    capt_dataA,
    capt_dataB,
    writeAbort
);

input  CLK;
input  RESET;
input  [31:0] srcA_q1;
input  [31:0] srcB_q1;
input  [1:0] Size_SrcA_q1;
input  [1:0] Size_SrcB_q1;
input  [31:0] dest_q2;
input  [`PCWIDTH-1:0] pc_q1;
input  [63:0] rdSrcAdata;
input  [63:0] rdSrcBdata;
input  [1:0]  exc_codeA;
input  [1:0]  exc_codeB;
input  rdenA;
input  rdenB;
input  fp_ready_q1;

input enAltImmInexactHandl  ;
input enAltImmUnderflowHandl;
input enAltImmOverflowHandl ;
input enAltImmDivByZeroHandl;
input enAltImmInvalidHandl  ;

input  invalid_in_service;
input  divby0_in_service; 
input  overflow_in_service; 
input  underflow_in_service;
input  inexact_in_service;

output TrapInexact_q1  ;
output TrapUnderflow_q1;
output TrapOverflow_q1 ;
output TrapDivX0_q1    ;
output TrapInvalid_q1 ; 
 
output [63:0] capt_dataA;
output [63:0] capt_dataB;
output writeAbort;

              
// exception codes for two MSBs [18:17] of result
parameter _no_excpt_   = 2'b00;  
parameter _overflow_   = 2'b01;  
parameter _invalid_    = 2'b01;  
parameter _underFlowExact_ = 2'b01;
parameter _underFlowInexact_  = 2'b10;  
parameter _div_x_0_    = 2'b10;  
parameter _inexact_    = 2'b11;                     

parameter DP = 2'b11;
parameter SP = 2'b10;
parameter HP = 2'b01; 

reg [63:0] rdSrcAdata_capt;
reg [63:0] rdSrcBdata_capt;
reg [31:0] srcA_q1_capt;
reg [31:0] srcB_q1_capt;
reg [31:0] dest_q2_capt;
reg [`PCWIDTH-1:0] pc_q1_capt;
reg [1:0]  state;
reg writeAbort;

reg rdenA_q1, rdenB_q1;

reg [63:0] capt_dataA;
reg [63:0] capt_dataB;

reg [10:0] Xe; //X exponent
reg [10:0] Ye; //Y exponent
reg X_sign;
reg Y_sign;
reg [51:0] X_fraction;
reg [51:0] Y_fraction;

reg invalid_q1;  
reg divby0_q1;   
reg overflow_q1; 
reg underflow_q1;
reg inexact_q1;  
reg ExcSource_q1;

wire TrapInexact_q1  ;
wire TrapUnderflow_q1;
wire TrapOverflow_q1 ;                                 
wire TrapDivX0_q1    ;
wire TrapInvalid_q1  ;

wire capture_enable;

wire [9:0] exc_sel;

wire [1:0] selA;
wire [1:0] selB;

assign selA = srcA_q1[4:3]; 
assign selB = srcB_q1[4:3]; 

wire [31-`PCWIDTH:0] pcPad;
assign pcPad = 0;

wire X_Invalid  ;
wire X_DivX0    ;
wire X_Overflow ;
wire X_Underflow;
wire X_inexact  ;

wire Y_Invalid  ;
wire Y_DivX0    ;
wire Y_Overflow ;
wire Y_Underflow;
wire Y_inexact  ;

wire X_Subnormal;
wire X_Infinite;
wire X_NaN;

wire Y_Subnormal;     
wire Y_Infinite;
wire Y_NaN;     

assign X_Subnormal    = (Xe==11'b0) && |X_fraction;    
assign X_Infinite     = (Xe==11'b111_1111_1111) && ~|X_fraction;    
assign X_NaN          = (Xe==11'b111_1111_1111) &&  |X_fraction[50:0]; 
    
assign Y_Subnormal   = (Ye==11'b0) && |Y_fraction;    
assign Y_Infinite    = (Ye==11'b111_1111_1111) && ~|Y_fraction;    
assign Y_NaN         = (Ye==11'b111_1111_1111) &&  |Y_fraction[50:0];     

assign X_Invalid   = X_NaN && (exc_codeA==_invalid_) && fp_ready_q1;
assign X_DivX0     = X_Infinite && (exc_codeA==_div_x_0_) && fp_ready_q1;
assign X_Overflow  = X_Infinite && (exc_codeA==_overflow_) && fp_ready_q1;
assign X_Underflow = X_Subnormal && (((exc_codeA==_underFlowExact_) && enAltImmUnderflowHandl) || (exc_codeA==_underFlowInexact_)) && fp_ready_q1;
assign X_inexact   = ((exc_codeA==_inexact_) || X_Overflow || (exc_codeA==_underFlowInexact_)) && fp_ready_q1; //under default exc handling, Underflow is not signaled unless it is also inexact
                                                   
assign Y_Invalid   = Y_NaN && (exc_codeB==_invalid_) && fp_ready_q1;
assign Y_DivX0     = Y_Infinite && (exc_codeB==_div_x_0_) && fp_ready_q1;
assign Y_Overflow  = Y_Infinite && (exc_codeB==_overflow_) && fp_ready_q1;
assign Y_Underflow = Y_Subnormal && (((exc_codeB==_underFlowExact_) && enAltImmUnderflowHandl) || (exc_codeB==_underFlowInexact_)) && fp_ready_q1;
assign Y_inexact   = ((exc_codeB==_inexact_) || Y_Overflow || (exc_codeB==_underFlowInexact_)) && fp_ready_q1; //under default exc handling, Underflow is not signaled unless it is also inexact

always @(*)
    if (Size_SrcA_q1==DP) {X_sign, Xe, X_fraction} =  rdSrcAdata[63:0];  // convert to DP
    else if (Size_SrcA_q1==SP) begin   
        X_sign     = rdSrcAdata[31];
        Xe[10:0]   = &rdSrcAdata[30:23] ? {3'b111, rdSrcAdata[30:23]} : (rdSrcAdata[30:23] + 10'h380);
        X_fraction = {rdSrcAdata[22:0], 32'b0};
    end    
    else begin   
        X_sign     = rdSrcAdata[15];
        Xe[10:0]   = &rdSrcAdata[14:10] ? {6'b111111, rdSrcAdata[14:10]} : (rdSrcAdata[14:10] + 10'h3F0);
        X_fraction = {rdSrcAdata[9:0], 48'b0};
    end    

always @(*)
    if (Size_SrcB_q1==DP) {Y_sign, Ye, Y_fraction} =  rdSrcBdata[63:0];  // convert to DP
    else if (Size_SrcB_q1==SP) begin   
        Y_sign     = rdSrcBdata[31];
        Ye[10:0]   = &rdSrcBdata[30:23] ? {3'b111, rdSrcBdata[30:23]} : (rdSrcBdata[30:23] + 10'h380);
        Y_fraction = {rdSrcBdata[22:0], 32'b0};
    end    
    else begin  
        Y_sign     = rdSrcBdata[15];
        Ye[10:0]   = &rdSrcBdata[14:10] ? {6'b111111, rdSrcBdata[14:10]} : (rdSrcBdata[14:10] + 10'h3F0);
        Y_fraction = {rdSrcBdata[9:0], 48'b0};
    end    

assign exc_sel = {X_Invalid, X_DivX0, X_Overflow, X_Underflow, X_inexact, Y_Invalid, Y_DivX0, Y_Overflow, Y_Underflow, Y_inexact}; 


always @(*)
    casex(exc_sel)
        10'b1xxxx_xxxxx : begin
                              invalid_q1   =  1'b1;
                              divby0_q1    =  1'b0;
                              overflow_q1  =  1'b0;
                              underflow_q1 =  1'b0;
                              inexact_q1   =  1'b0;
                              ExcSource_q1 =  1'b0;
                          end   
        10'b01xxx_xxxxx : begin
                              invalid_q1   =  1'b0;
                              divby0_q1    =  1'b1;
                              overflow_q1  =  1'b0;
                              underflow_q1 =  1'b0;
                              inexact_q1   =  1'b0;
                              ExcSource_q1 =  1'b0;
                          end   
        10'b001xx_xxxxx : begin
                              invalid_q1   =  1'b0;
                              divby0_q1    =  1'b0;
                              overflow_q1  =  1'b1;
                              underflow_q1 =  1'b0;
                              inexact_q1   =  1'b1;
                              ExcSource_q1 =  1'b0;
                          end   
        10'b0001x_xxxxx : begin
                              invalid_q1   =  1'b0;
                              divby0_q1    =  1'b0;
                              overflow_q1  =  1'b0;
                              underflow_q1 =  1'b1;
                              inexact_q1   =  X_inexact;
                              ExcSource_q1 =  1'b0;
                          end   
        10'b00001_xxxxx : begin
                              invalid_q1   =  1'b0;
                              divby0_q1    =  1'b0;
                              overflow_q1  =  1'b0;
                              underflow_q1 =  1'b0;
                              inexact_q1   =  1'b1;
                              ExcSource_q1 =  1'b0;
                          end   
                              
                              
        10'b00000_1xxxx : begin                                                
                              invalid_q1   =  1'b1;                            
                              divby0_q1    =  1'b0;                            
                              overflow_q1  =  1'b0;                            
                              underflow_q1 =  1'b0;                            
                              inexact_q1   =  1'b0;                            
                              ExcSource_q1 =  1'b1;                            
                          end                                                 
        10'b00000_01xxx : begin                                                
                              invalid_q1   =  1'b0;                            
                              divby0_q1    =  1'b1;                            
                              overflow_q1  =  1'b0;                            
                              underflow_q1 =  1'b0;                            
                              inexact_q1   =  1'b0;                            
                              ExcSource_q1 =  1'b1;                            
                          end                                                 
        10'b00000_001xx : begin                                                
                              invalid_q1   =  1'b0;                            
                              divby0_q1    =  1'b0;                            
                              overflow_q1  =  1'b1;                            
                              underflow_q1 =  1'b0;                            
                              inexact_q1   =  1'b1;                            
                              ExcSource_q1 =  1'b1;                            
                          end                                                 
        10'b00000_0001x : begin                                                
                              invalid_q1   =  1'b0;                            
                              divby0_q1    =  1'b0;                            
                              overflow_q1  =  1'b0;                            
                              underflow_q1 =  1'b1;                            
                              inexact_q1   =  Y_inexact;                            
                              ExcSource_q1 =  1'b1;                            
                           end                                                 
        10'b00000_00001 : begin                                                
                              invalid_q1   =  1'b0;                            
                              divby0_q1    =  1'b0;                                  
                              overflow_q1  =  1'b0;                                  
                              underflow_q1 =  1'b0;
                              inexact_q1   =  1'b1;
                              ExcSource_q1 =  1'b1;
                          end
                default : begin
                              invalid_q1   =  1'b0;                            
                              divby0_q1    =  1'b0;                                  
                              overflow_q1  =  1'b0;                                  
                              underflow_q1 =  1'b0;
                              inexact_q1   =  1'b0;
                              ExcSource_q1 =  1'b0;
                          end         
    endcase

assign TrapInvalid_q1   = invalid_q1   && enAltImmInvalidHandl   && ~invalid_in_service  ;
assign TrapDivX0_q1     = divby0_q1    && enAltImmDivByZeroHandl && ~divby0_in_service   ;
assign TrapOverflow_q1  = overflow_q1  && enAltImmOverflowHandl  && ~overflow_in_service ;
assign TrapUnderflow_q1 = underflow_q1 && enAltImmUnderflowHandl && ~underflow_in_service;
assign TrapInexact_q1   = inexact_q1   && enAltImmInexactHandl   && ~inexact_in_service  ;


assign capture_enable = TrapInexact_q1   ||
                        TrapUnderflow_q1 || 
                        TrapOverflow_q1  ||
                        TrapDivX0_q1     ||
                        TrapInvalid_q1  ;
always@(*) begin
    if (rdenA_q1) 
        case (selA)
            2'b00 : capt_dataA = {rdSrcAdata_capt[63:0]};
            2'b01 : capt_dataA = {rdSrcBdata_capt[63:0]};
            2'b10 : capt_dataA = {srcB_q1_capt, srcA_q1_capt};
            2'b11 : capt_dataA = {pcPad, pc_q1_capt, dest_q2_capt};
        endcase
    else capt_dataA = 64'b0;    
end

always@(*) begin
    if (rdenB_q1) 
        case (selB)
            2'b00 : capt_dataB = rdSrcAdata_capt[63:0];
            2'b01 : capt_dataB = rdSrcBdata_capt[63:0];
            2'b10 : capt_dataB = {srcB_q1_capt, srcA_q1_capt};
            2'b11 : capt_dataB = {pcPad, pc_q1_capt, dest_q2_capt};
        endcase
    else capt_dataB = 64'b0;    
end

always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        rdenA_q1 <= 1'b0;
        rdenB_q1 <= 1'b0;
    end
    else begin
        rdenA_q1 <= rdenA;
        rdenB_q1 <= rdenB;
    end
end    
    
always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        rdSrcAdata_capt    <= 64'b0;
        rdSrcBdata_capt    <= 64'b0;
        srcA_q1_capt       <= 32'b0;
        srcB_q1_capt       <= 32'b0;
        dest_q2_capt       <= 32'b0;
        pc_q1_capt         <= 0;
        state              <= 2'b00;
        writeAbort         <= 1'b0;
    end
    else begin
        case (state)
            2'b00 : if (capture_enable && fp_ready_q1) begin
                        rdSrcAdata_capt <= rdSrcAdata;
                        rdSrcBdata_capt <= rdSrcBdata;
                        srcA_q1_capt <= srcA_q1;
                        srcB_q1_capt <= srcB_q1;
                        pc_q1_capt <= pc_q1; 
                        state <= 2'b01;
                        writeAbort <= 1'b1;
                    end
            2'b01 : begin
                        dest_q2_capt <= dest_q2;
                        state <= 2'b10;
                        writeAbort <= 1'b0;
                    end
            2'b10,            
            2'b11 : if (rdenA_q1 || rdenB_q1) state <= 2'b00;
        endcase             
    end
end    
    
endmodule
