// XCUfpmath.v
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
 
 
 
module XCUfpmath ( 
    RESET,
    CLK,
    Dam_q1,
    OPsrcA_q1,
    OPsrcB_q1,
    OPsrc32_q1,                                                              
    wren,
    wraddrs,
    Ind_SrcA_q1,
    Sext_Dest_q2,
    Size_SrcA_q2,                          
    Size_SrcA_q1,                          
    Sext_SrcA_q1,
    Sext_SrcA_q2,                              
    rdSrcAdata,
    Size_SrcB_q2,
    Size_SrcB_q1,
    Sext_SrcB_q1,
    Sext_SrcB_q2,
    rdSrcBdata,
    rdenA,
    rdaddrsA,
    rddataA,
    rdenB,
    rdaddrsB,
    rddataB,
    exc_codeA,
    exc_codeB,
        
    ready,
    
    round_mode_q1,
    Away
    
    );

input RESET, CLK, wren, rdenA, rdenB;
input [8:0] wraddrs;
input [8:0] rdaddrsA, rdaddrsB;
input Ind_SrcA_q1;
input [1:0] Size_SrcA_q2, Size_SrcB_q2;
input [1:0] Size_SrcA_q1, Size_SrcB_q1;
input Sext_Dest_q2;
input Sext_SrcA_q1;
input Sext_SrcA_q2;
input Sext_SrcB_q1;
input Sext_SrcB_q2;
input [1:0] Dam_q1;
input [15:0] OPsrcA_q1;
input [15:0] OPsrcB_q1;
input [31:0] OPsrc32_q1;

input [63:0] rdSrcAdata, rdSrcBdata;
input [1:0] round_mode_q1;
input Away;

output [63:0]rddataA, rddataB;
output [1:0] exc_codeA;    //msb is div_by_0
output [1:0] exc_codeB;


output ready;

//precision (size) encodings
parameter DP = 2'b11;
parameter SP = 2'b10;
parameter HP = 2'b01;

//FP operator base address preceded by 0_E
parameter FADD = 7'b1110_1_xx;
parameter FSUB = 7'b1110_0_xx;
parameter FMUL = 7'b1101_1_xx;
parameter ITOF = 7'b1101_0_xx;
parameter FTOI = 7'b1100_1_xx;
parameter FDIV = 7'b1100_0_xx;                               
parameter SQRT = 7'b1011_1_xx;
parameter FMA  = 7'b1011_0_xx;
parameter LOG  = 7'b1010_1_xx;
parameter EXP  = 7'b1010_0_xx;
parameter CONV = 7'b1001_1_xx;  // convert binary format
parameter RTOI = 7'b1001_0_xx;  // round to nearest integral 
parameter SCAL = 7'b1000_1_xx;  // scaleB
parameter LOGB = 7'b1000_0_xx;  // logB
parameter REM  = 7'b0111_1_xx;  // remainder
                          
parameter NEXT = 7'b0111_0_xx;
// eight result buffers each
parameter nextUp    = {7'b0111_0, 1'b1, 1'bx};    // 18'b00_1110_0101_01xx_xxxx   = 0_E77F to 0_E740 
parameter nextDown  = {7'b0111_0, 1'b0, 1'bx};    // 18'b00_1110_0101_00xx_xxxx   = 0_E73F to 0_E700

parameter MINMAX  = 7'b0110_1_xx;
// four result buffers each
parameter maxNumMag = {7'b0110_1, 1'b1, 1'b1};   // 18'b00_1110_0110_111x_xxxx   = 0_E6FF to 0_E6E0         
parameter minNumMag = {7'b0110_1, 1'b1, 1'b0};   // 18'b00_1110_0110_110x_xxxx   = 0_E6DF to 0_E6C0         
parameter maxNum    = {7'b0110_1, 1'b0, 1'b1};   // 18'b00_1110_0110_101x_xxxx   = 0_E6BF to 0_E6A0      
parameter minNum    = {7'b0110_1, 1'b0, 1'b0};   // 18'b00_1110_0110_100x_xxxx   = 0_E69F to 0_E680      

parameter CNACS     = 7'b0110_0_xx;
// four result buffers each
parameter copy      = {7'b0110_0, 1'b1, 1'b1};   // 18'b00_1110_0110_011x_xxxx   = 0_E67F to 0_E660
parameter negate    = {7'b0110_0, 1'b1, 1'b0};   // 18'b00_1110_0110_010x_xxxx   = 0_E65F to 0_E640
parameter abs       = {7'b0110_0, 1'b0, 1'b1};   // 18'b00_1110_0110_001x_xxxx   = 0_E63F to 0_E620
parameter copySign  = {7'b0110_0, 1'b0, 1'b0};   // 18'b00_1110_0110_000x_xxxx   = 0_E61F to 0_E600

parameter TRIG_     = 7'b0101_1_xx;
// four result buffers each
parameter SIN       = {7'b0101_1, 1'b1, 1'b1};   // 18'b00_1110_0101_111x_xxxx   = 0_E5FF to 0_E5E0
parameter COS       = {7'b0101_1, 1'b1, 1'b0};   // 18'b00_1110_0101_110x_xxxx   = 0_E5DF to 0_E5C0
parameter TAN       = {7'b0101_1, 1'b0, 1'b1};   // 18'b00_1110_0101_101x_xxxx   = 0_E5BF to 0_E5A0
parameter COT       = {7'b0101_1, 1'b0, 1'b0};   // 18'b00_1110_0101_100x_xxxx   = 0_E59F to 0_E580

//convert from decimal char sequence 
parameter CNVFDCS   = 7'b0101_0_xx;              // 18'b00_1110_0101_0xxx_xxxx   = 0_E57F to 0_E500
//convert to decimal char sequence 
parameter CNVTDCS   = 7'b0100_1_xx;              // 18'b00_1110_0100_1xxx_xxxx   = 0_E4FF to 0_E480
//convert from hex char sequence
parameter CNVFHCS   = 7'b0100_0_xx;              // 18'b00_1110_0100_0xxx_xxxx   = 0_E47F to 0_E400
//convert to hex char sequence
parameter CNVTHCS   = 7'b0011_1_xx;              // 18'b00_1110_0011_1xxx_xxxx   = 0_E3FF to 0_E380

parameter POW       = 7'b0011_0_xx;              // 18'b00_1110_0011_0xxx_xxxx   = 0_E37F to 0_E300


reg [17:0] rddataA_out, rddataB_out;  //2-bit exception code included.   
reg rdenA_q1, rdenB_q1;

reg [63:0] fwrsrcAdata;
reg [63:0] fwrsrcBdata;

reg readyA;
reg readyB;

reg [1:0] round_mode_q2;

reg [1:0] round_mode_q2_del_0,
          round_mode_q2_del_1,
          round_mode_q2_del_2,
          round_mode_q2_del_3,
          round_mode_q2_del_4,
          round_mode_q2_del_5,
          round_mode_q2_del_6,
          round_mode_q2_del_7,
          round_mode_q2_del_8,
          round_mode_q2_del_9,
          round_mode_q2_del_10,
          round_mode_q2_del_11;
           
reg [9:0] NaN_del_1,
          NaN_del_2,
          NaN_del_3,
          NaN_del_4,
          NaN_del_5,
          NaN_del_6,
          NaN_del_7,
          NaN_del_8,
          NaN_del_9,
          NaN_del_10,
          NaN_del_11;

reg [4:0] wraddrs_del_0, 
          wraddrs_del_1,
          wraddrs_del_2,
          wraddrs_del_3,
          wraddrs_del_4,
          wraddrs_del_5,
          wraddrs_del_6,
          wraddrs_del_7,
          wraddrs_del_8,
          wraddrs_del_9,
          wraddrs_del_10,
          wraddrs_del_11,
          wraddrs_del_12;

reg A_sign_del_1 ,
    A_sign_del_2 ,
    A_sign_del_3 ,
    A_sign_del_4 ,
    A_sign_del_5 ,
    A_sign_del_6 ,
    A_sign_del_7 ,
    A_sign_del_8 ,
    A_sign_del_9 ,
    A_sign_del_10,
    A_sign_del_11;
    
reg A_invalid_del_1 ,
    A_invalid_del_2 ,
    A_invalid_del_3 ,
    A_invalid_del_4 ,
    A_invalid_del_5 ,
    A_invalid_del_6 ,
    A_invalid_del_7 ,
    A_invalid_del_8 ,
    A_invalid_del_9 ,
    A_invalid_del_10,
    A_invalid_del_11;
    
reg A_is_zero_del_1 ,
    A_is_zero_del_2 ,
    A_is_zero_del_3 ,
    A_is_zero_del_4 ,
    A_is_zero_del_5 ,
    A_is_zero_del_6 ;
    
reg A_inexact_del_1 ,
    A_inexact_del_2 ,
    A_inexact_del_3 ,
    A_inexact_del_4 ,
    A_inexact_del_5 ,
    A_inexact_del_6 ,
    A_inexact_del_7 ,
    A_inexact_del_8 ,
    A_inexact_del_9 ,
    A_inexact_del_10,
    A_inexact_del_11;

reg B_sign_del_1 ,
    B_sign_del_2 ,
    B_sign_del_3 ,
    B_sign_del_4 ,
    B_sign_del_5 ;
    
reg B_invalid_del_1 ,
    B_invalid_del_2 ,
    B_invalid_del_3 ,
    B_invalid_del_4 ,
    B_invalid_del_5 ,
    B_invalid_del_6 ,
    B_invalid_del_7 ,
    B_invalid_del_8 ,
    B_invalid_del_9 ,
    B_invalid_del_10,
    B_invalid_del_11;
    
reg B_is_zero_del_1 ,
    B_is_zero_del_2 ,
    B_is_zero_del_3 ,
    B_is_zero_del_4 ,
    B_is_zero_del_5 ,
    B_is_zero_del_6 ,
    B_is_zero_del_7 ,
    B_is_zero_del_8 ,
    B_is_zero_del_9 ,
    B_is_zero_del_10;

reg B_inexact_del_1 ,
    B_inexact_del_2 ,
    B_inexact_del_3 ,
    B_inexact_del_4 ,
    B_inexact_del_5 ,
    B_inexact_del_6 ,
    B_inexact_del_7 ,
    B_inexact_del_8 ,
    B_inexact_del_9 ,
    B_inexact_del_10,
    B_inexact_del_11;
    
reg Away_del_0 ,  
    Away_del_1 ,
    Away_del_2 ,
    Away_del_3 ,
    Away_del_4 ,
    Away_del_5 ,
    Away_del_6 ,
    Away_del_7 ,
    Away_del_8 ,
    Away_del_9 ,
    Away_del_10,
    Away_del_11;

reg A_is_infinite_del_1,  
    A_is_infinite_del_2,  
    A_is_infinite_del_3,  
    A_is_infinite_del_4,  
    A_is_infinite_del_5,  
    A_is_infinite_del_6,  
    A_is_infinite_del_7,  
    A_is_infinite_del_8,
    A_is_infinite_del_9,  
    A_is_infinite_del_10;  
    
reg B_is_infinite_del_1,  
    B_is_infinite_del_2,  
    B_is_infinite_del_3,  
    B_is_infinite_del_4,  
    B_is_infinite_del_5,  
    B_is_infinite_del_6,  
    B_is_infinite_del_7,  
    B_is_infinite_del_8,
    B_is_infinite_del_9,  
    B_is_infinite_del_10,  
    B_is_infinite_del_11;  
    
reg A_is_normal_del_1,   
    A_is_normal_del_2,   
    A_is_normal_del_3,   
    A_is_normal_del_4,   
    A_is_normal_del_5,   
    A_is_normal_del_6,   
    A_is_normal_del_7,   
    A_is_normal_del_8,  
    A_is_normal_del_9,   
    A_is_normal_del_10,  
    A_is_normal_del_11; 
     
reg A_is_subnormal_del_1,   
    A_is_subnormal_del_2,   
    A_is_subnormal_del_3,   
    A_is_subnormal_del_4,   
    A_is_subnormal_del_5,   
    A_is_subnormal_del_6,   
    A_is_subnormal_del_7,   
    A_is_subnormal_del_8,  
    A_is_subnormal_del_9,   
    A_is_subnormal_del_10,  
    A_is_subnormal_del_11;  

reg A_is_NaN_del_1,   
    A_is_NaN_del_2,   
    A_is_NaN_del_3,   
    A_is_NaN_del_4,   
    A_is_NaN_del_5,   
    A_is_NaN_del_6,   
    A_is_NaN_del_7,   
    A_is_NaN_del_8,  
    A_is_NaN_del_9,   
    A_is_NaN_del_10;  

reg B_is_NaN_del_1,   
    B_is_NaN_del_2,   
    B_is_NaN_del_3,   
    B_is_NaN_del_4,   
    B_is_NaN_del_5,   
    B_is_NaN_del_6,   
    B_is_NaN_del_7,   
    B_is_NaN_del_8,  
    B_is_NaN_del_9,   
    B_is_NaN_del_10;  
    
reg A_overflow_del_0;    
reg A_underflow_del_0;
    
reg wren_mul,
    wren_sub,
    wren_add,
    wren_div,
    wren_sqrt,
    wren_fma,
    wren_log,
    wren_exp,
    wren_itof,
    wren_ftoi,
    wren_scal,
    wren_logb,
    wren_conv,
    wren_rtoi,
    wren_rem,
    wren_minmax,
    wren_next,
    wren_cnacs,
    wren_sin,
    wren_cos,
    wren_tan,
    wren_cot,
    wren_cnvfdcs,
    wren_cnvtdcs,
    wren_cnvfhcs,
    wren_cnvthcs,
    wren_pow;
    
reg rdenA_mul,
    rdenA_add,
    rdenA_sub,
    rdenA_div,
    rdenA_sqrt,
    rdenA_fma,
    rdenA_log,
    rdenA_exp,
    rdenA_itof,
    rdenA_ftoi,
    rdenA_scal,
    rdenA_logb,
    rdenA_conv,
    rdenA_rtoi,
    rdenA_rem,
    rdenA_minmax,
    rdenA_next,
    rdenA_cnacs,
    rdenA_sin,
    rdenA_cos,
    rdenA_tan,
    rdenA_cot,
    rdenA_cnvfdcs,
    rdenA_cnvtdcs,
    rdenA_cnvfhcs,
    rdenA_cnvthcs,
    rdenA_pow;
    
    
reg rdenB_mul,
    rdenB_add,
    rdenB_sub,
    rdenB_div,
    rdenB_sqrt,
    rdenB_fma,
    rdenB_log,
    rdenB_exp,
    rdenB_itof,
    rdenB_ftoi,
    rdenB_scal,   
    rdenB_logb,   
    rdenB_conv,
    rdenB_rtoi,
    rdenB_rem,                                                             
    rdenB_minmax,                                                          
    rdenB_next,                                                            
    rdenB_cnacs,                                                           
    rdenB_sin,                                                             
    rdenB_cos,                                                             
    rdenB_tan,
    rdenB_cot,
    rdenB_cnvfdcs,
    rdenB_cnvtdcs,
    rdenB_cnvfhcs,
    rdenB_cnvthcs,
    rdenB_pow;
       
reg [6:0] rdAfunc_sel_q1;
reg [6:0] rdBfunc_sel_q1;

reg [1:0] exc_codeA;
reg [1:0] exc_codeB;

reg [63:0] rddataA, rddataB;

wire ready_mul,
     ready_add,
     ready_div,
     ready_sqrt,
     ready_fma,
     ready_log,
     ready_exp,
     ready_itof,
     ready_ftoi,
     ready_scal,
     ready_logb,
     ready_conv,
     ready_rtoi,
     ready_rem,                                                                
     ready_minmax,                                                             
     ready_next,                                                               
     ready_cnacs,                                                             
     ready_sin,                                                                
     ready_cos,                                                               
     ready_tan,
     ready_cot,
     ready_cnvfdcs,
     ready_cnvtdcs,
     ready_cnvfhcs,
     ready_cnvthcs,
     ready_pow;

wire ready;   

wire [6:0] wrfunc_sel;
wire [6:0] rdAfunc_sel;
wire [6:0] rdBfunc_sel;

wire [18:0] wrdataA_FP, wrdataB_FP;

wire [17:0] rddataB_FP_mul;
wire [17:0] rddataB_FP_add;
wire [17:0] rddataB_FP_div;
wire [17:0] rddataB_FP_sqrt;
wire [17:0] rddataB_FP_fma;                                                                          
wire [17:0] rddataB_FP_log;
wire [17:0] rddataB_FP_exp;                                                                          
wire [17:0] rddataB_INT_itof;
wire [17:0] rddataB_FP_ftoi;                                                                         
wire [17:0] rddataB_FP_scal;                                                                    
wire [17:0] rddataB_FP_logb;                                                                         
wire [17:0] rddataB_FP_conv;                                                                    
wire [17:0] rddataB_FP_rtoi;                                                                        
wire [17:0] rddataB_FP_rem;
wire [17:0] rddataB_FP_minmax;                                                                       
wire [17:0] rddataB_FP_next;    
wire [17:0] rddataB_FP_cnacs;                                                                        
wire [17:0] rddataB_FP_sin;
wire [17:0] rddataB_FP_cos;                                                                        
wire [17:0] rddataB_FP_tan;
wire [17:0] rddataB_FP_cot;                                                                        
wire [17:0] rddataB_FP_cnvfdcs;                                                                        
wire [65:0] rddataB_FP_cnvtdcs;                                                                        
wire [17:0] rddataB_FP_cnvfhcs;                                                                        
wire [65:0] rddataB_FP_cnvthcs;                                                                        
wire [17:0] rddataB_FP_pow;                                                                        

wire [17:0] rddataA_FP_mul;
wire [17:0] rddataA_FP_add;
wire [17:0] rddataA_FP_div;
wire [17:0] rddataA_FP_sqrt;
wire [17:0] rddataA_FP_fma;
wire [17:0] rddataA_FP_log;
wire [17:0] rddataA_FP_exp;
wire [17:0] rddataA_INT_itof;
wire [17:0] rddataA_FP_ftoi;
wire [17:0] rddataA_FP_scal;
wire [17:0] rddataA_FP_logb;
wire [17:0] rddataA_FP_conv;
wire [17:0] rddataA_FP_rtoi;             
wire [17:0] rddataA_FP_rem;
wire [17:0] rddataA_FP_minmax;
wire [17:0] rddataA_FP_next;
wire [17:0] rddataA_FP_cnacs;
wire [17:0] rddataA_FP_sin;
wire [17:0] rddataA_FP_cos;
wire [17:0] rddataA_FP_tan;
wire [17:0] rddataA_FP_cot;
wire [17:0] rddataA_FP_cnvfdcs;                                                                        
wire [65:0] rddataA_FP_cnvtdcs;                                                                        
wire [17:0] rddataA_FP_cnvfhcs;                                                                        
wire [65:0] rddataA_FP_cnvthcs;                                                                        
wire [17:0] rddataA_FP_pow;                                                                        

wire A_is_NaN;
wire A_is_invalid;
wire A_is_infinite;
wire A_is_overflow;
wire A_is_underflow;
wire A_is_inexact;  

wire B_is_NaN;
wire B_is_invalid;
wire B_is_infinite;
wire B_is_overflow;
wire B_is_underflow;
wire B_is_inexact;  

wire intermA_is_zero;
wire intermA_is_infinity;
wire intermA_is_NaN;
wire intermA_is_0_inf_or_NaN;

wire intermB_is_zero;
wire intermB_is_infinity;
wire intermB_is_NaN;
wire intermB_is_0_inf_or_NaN;

wire [10:0] DP_intermA_exp;

wire [7:0] SP_intermA_exp;


wire [10:0] DP_intermB_exp;

wire [7:0] SP_intermB_exp;

wire [63:0] DP_intermA;
wire [63:0] SP_intermA;
wire [63:0] HP_intermA;

wire [63:0] DP_intermB;
wire [63:0] SP_intermB;
wire [63:0] HP_intermB;

wire [9:0] NaN_payload;

assign NaN_payload = A_is_NaN ? wrdataA_FP[9:0] : wrdataB_FP[9:0] ;

assign wrfunc_sel = wraddrs[8:2];
assign rdAfunc_sel = rdaddrsA[8:2];
assign rdBfunc_sel = rdaddrsB[8:2];
                     
assign ready = readyA && readyB;      


assign intermA_is_zero = ~|rddataA_out[14:0];
assign intermA_is_infinity = &rddataA_out[14:10] && ~|rddataA_out[9:0];
assign intermA_is_NaN = &rddataA_out[14:10] && |rddataA_out[8:0];
assign intermA_is_0_inf_or_NaN = intermA_is_zero || intermA_is_infinity || intermA_is_NaN;

assign intermB_is_zero = ~|rddataB_out[14:0];
assign intermB_is_infinity = &rddataB_out[14:10] && ~|rddataB_out[9:0];
assign intermB_is_NaN = &rddataB_out[14:10] && |rddataB_out[8:0];
assign intermB_is_0_inf_or_NaN = intermB_is_zero || intermB_is_infinity || intermB_is_NaN;

assign DP_intermA_exp = rddataA_out[14:10] + 10'h3F0; // 1023 - 15 = 1008 = 10'h3F0
assign DP_intermB_exp = rddataB_out[14:10] + 10'h3F0; // 1023 - 15 = 1008 = 10'h3F0
assign SP_intermA_exp = rddataA_out[14:10] + 7'h70; // 127 - 15 = 112 = 7'h70
assign SP_intermB_exp = rddataB_out[14:10] + 7'h70; // 127 - 15 = 112 = 7'h70

assign DP_intermA = {rddataA_out[15], (intermA_is_0_inf_or_NaN ? {11{rddataA_out[14]}} : DP_intermA_exp), rddataA_out[9:0], 42'b0}; 
assign SP_intermA = {32'b0, rddataA_out[15], (intermA_is_0_inf_or_NaN ? {8{rddataA_out[14]}} : SP_intermA_exp), rddataA_out[9:0], 13'b0};
assign HP_intermA = {48'b0, rddataA_out[15:0]}; 

assign DP_intermB = {rddataB_out[15], (intermB_is_0_inf_or_NaN ? {11{rddataB_out[14]}} : DP_intermB_exp), rddataB_out[9:0], 42'b0}; 
assign SP_intermB = {32'b0, rddataB_out[15], (intermB_is_0_inf_or_NaN ? {8{rddataB_out[14]}} : SP_intermB_exp), rddataB_out[9:0], 13'b0};
assign HP_intermB = {48'b0, rddataB_out[15:0]}; 


Univ_IEEE754_To_FP610_filtered opA_in(
    .CLK                (CLK  ),
    .RESET              (RESET),
    .wren               (wren && ~(wrfunc_sel[6:2]==ITOF[6:2]) && ~(wrfunc_sel[6:2]==TRIG_[6:2])),
    .X                  (fwrsrcAdata),
    .R                  (wrdataA_FP),
    .round_mode         (round_mode_q2),
    .Away               (Away),
    .Src_Size_q2        (Size_SrcA_q2),
    .input_is_infinite  (A_is_infinite),
    .input_is_normal    (A_is_normal),
    .input_is_NaN       (A_is_NaN),
    .input_is_zero      (A_is_zero),
    .input_is_subnormal (A_is_subnormal),
    .input_is_invalid   (A_is_invalid),
    .conv_overflow      (A_is_overflow),  
    .conv_underflow     (A_is_underflow),  
    .conv_inexact       (A_is_inexact)   
    );

Univ_IEEE754_To_FP610_filtered opB_in(
    .CLK                (CLK  ),
    .RESET              (RESET),
    .wren               (wren && ~(wrfunc_sel[6:2]==ITOF[6:2]) && ~(wrfunc_sel[6:2]==TRIG_[6:2])),
    .X                  (fwrsrcBdata),
    .R                  (wrdataB_FP),
    .round_mode         (round_mode_q2),
    .Away               (Away),
    .Src_Size_q2        (Size_SrcB_q2),
    .input_is_infinite  (B_is_infinite),
    .input_is_normal    (B_is_normal),
    .input_is_NaN       (B_is_NaN),
    .input_is_zero      (B_is_zero),
    .input_is_subnormal (B_is_subnormal),
    .input_is_invalid   (B_is_invalid),
    .conv_overflow      (B_is_overflow),  
    .conv_underflow     (B_is_underflow),  
    .conv_inexact       (B_is_inexact)   
    );

func_mul mul(             
    .RESET    (RESET         ),                                         
    .CLK      (CLK           ),                                         
    .NaN_del (NaN_del_1),                                               
    .wren     (wren_mul      ),                                         
    .round_mode_del(round_mode_q2_del_1 ),                              
    .Away_del      (Away_del_1          ),                              
    .A_sign_del    (A_sign_del_1        ),                              
    .A_invalid_del (A_invalid_del_1     ),                              
    .A_is_zero_del (A_is_zero_del_1     ),                              
    .A_inexact_del (A_inexact_del_1     ),                              
    .A_is_infinite_del(A_is_infinite_del_1),                              
    .B_sign_del    (B_sign_del_1        ),                              
    .B_invalid_del (B_invalid_del_1     ),                              
    .B_is_zero_del (B_is_zero_del_1     ),                              
    .B_inexact_del (B_inexact_del_1     ),                              
    .B_is_infinite_del(B_is_infinite_del_1),                              
    .wraddrs (wraddrs[3:0]),                               
    .wraddrs_del  (wraddrs_del_2[3:0]),              
    .wrdataA  (wrdataA_FP   ),                                          
    .wrdataB  (wrdataB_FP   ),                                          
    .rdenA    (rdenA_mul     ),                                         
    .rdaddrsA (rdaddrsA[3:0]),                                
    .rddataA  (rddataA_FP_mul),                                        
    .rdenB    (rdenB_mul     ),                                        
    .rdaddrsB (rdaddrsB[3:0]),                                
    .rddataB  (rddataB_FP_mul),                                         
    .ready    (ready_mul     )                                          
                                                                        
    );
    
func_add add(             
    .RESET     (RESET         ),
    .CLK       (CLK           ),
    .NaN_del   (NaN_del_2),
    .wren      (wren_add || wren_sub),
    .Add_Sub   (~wraddrs_del_0[4]),
    .wraddrs (wraddrs[4:0]),
    .wraddrs_del   (wraddrs_del_3[4:0]),
    .round_mode_del(round_mode_q2_del_2 ),
    .Away_del (Away_del_2),
    .A_sign_del    (A_sign_del_2        ),
    .A_invalid_del (A_invalid_del_2     ),
    .A_inexact_del (A_inexact_del_2     ),
    .A_is_infinite_del (A_is_infinite_del_2 ),
    .B_sign_del    (B_sign_del_2        ),
    .B_invalid_del (B_invalid_del_2     ),
    .B_inexact_del (B_inexact_del_2     ),
    .B_is_infinite_del (B_is_infinite_del_2 ),
    .wrdataA   (wrdataA_FP    ),
    .wrdataB   (wrdataB_FP    ),
    .rdenA     (rdenA_add || rdenA_sub),
    .rdaddrsA  (rdaddrsA[4:0]),
    .rddataA   (rddataA_FP_add),
    .rdenB     (rdenB_add || rdenB_sub),
    .rdaddrsB  (rdaddrsB[4:0]),
    .rddataB   (rddataB_FP_add),
    .ready     (ready_add     )
     );


func_ftoi ftoi(
    .RESET    (RESET     ),
    .CLK      (CLK       ),
    .wren     (wren_ftoi ),
    .A_inexact (A_is_inexact),
    .A_is_infinite (A_is_infinite  ),
    .wraddrs (wraddrs[3:0]),    
    .wraddrs_del  (wraddrs_del_1[3:0]),
    .wrdataA   (wrdataA_FP),
    .fwrsrcBdata (fwrsrcBdata[4:0]),
    .rdenA    (rdenA_ftoi),
    .rdaddrsA (rdaddrsA[3:0]),
    .rddataA  (rddataA_FP_ftoi),
    .rdenB    (rdenB_ftoi ),
    .rdaddrsB (rdaddrsB[3:0]),
    .rddataB  (rddataB_FP_ftoi),
    .ready    (ready_ftoi)
    );  
 
func_itof itof(
    .RESET    (RESET     ),
    .CLK      (CLK       ),
    .Sext_SrcA_q2(Sext_SrcA_q2),
    .round_mode(round_mode_q2),
    .Away (Away),
    .wren     ((wrfunc_sel[6:2]==ITOF[6:2]) && wren ),
    .wraddrs (wraddrs[3:0]),   
    .wraddrs_del  (wraddrs_del_0[3:0]),
    .wrdata   (fwrsrcAdata[63:0]),    
    .rdenA    (rdenA_itof),
    .rdaddrsA (rdaddrsA[3:0]),
    .rddataA  (rddataA_INT_itof),
    .rdenB    (rdenB_itof ),
    .rdaddrsB (rdaddrsB[3:0]),
    .rddataB  (rddataB_INT_itof),
    .ready    (ready_itof)
    );    

`ifdef XCU_HAS_DIVISION     
func_div div(              
    .RESET    (RESET         ),
    .CLK      (CLK           ),
    .NaN_del (NaN_del_5),
    .wren     (wren_div      ),
    .round_mode_del (round_mode_q2_del_5),
    .Away_del (Away_del_5),
    .A_sign_del    (A_sign_del_5        ),
    .A_is_zero_del (A_is_zero_del_5     ),                              
    .A_invalid_del (A_invalid_del_5     ),
    .A_inexact_del (A_inexact_del_5     ),
    .A_is_infinite_del (A_is_infinite_del_5),
    .B_sign_del    (B_sign_del_5        ),
    .B_is_zero_del (B_is_zero_del_5     ),                              
    .B_invalid_del (B_invalid_del_5     ),
    .B_inexact_del (B_inexact_del_5     ),
    .B_is_infinite_del (B_is_infinite_del_5),
    .wraddrs (wraddrs[3:0]),
    .wraddrs_del  (wraddrs_del_6[3:0]),
    .wrdataA  (wrdataA_FP   ),
    .wrdataB  (wrdataB_FP   ),
    .rdenA    (rdenA_div     ),
    .rdaddrsA (rdaddrsA[3:0]),
    .rddataA  (rddataA_FP_div),
    .rdenB    (rdenB_div     ),
    .rdaddrsB (rdaddrsB[3:0]),
    .rddataB  (rddataB_FP_div),
    .ready    (ready_div     )
    );
`else 
    assign rddataA_FP_div = 18'b0;
    assign rddataB_FP_div = 18'b0;
    assign ready_div = 1'b1;
`endif
    

`ifdef XCU_HAS_SQRT     
    func_sqrt sqrt(              
        .RESET    (RESET          ),
        .CLK      (CLK            ),
        .NaN_del (NaN_del_3),
        .wren     (wren_sqrt      ),
        .round_mode_del(round_mode_q2_del_3 ),
        .Away_del (Away_del_3),
        .A_sign_del    (A_sign_del_3        ),
        .A_is_zero_del (A_is_zero_del_3     ),                              
        .A_invalid_del (A_invalid_del_3     ),
        .A_inexact_del (A_inexact_del_3     ),
        .A_is_infinite_del (A_is_infinite_del_3),
        .wraddrs (wraddrs[3:0]),    
        .wraddrs_del  (wraddrs_del_4[3:0]),
        .wrdataA  (wrdataA_FP    ),
        .rdenA    (rdenA_sqrt     ),
        .rdaddrsA (rdaddrsA[3:0]),
        .rddataA  (rddataA_FP_sqrt),
        .rdenB    (rdenB_sqrt     ),
        .rdaddrsB (rdaddrsB[3:0]),
        .rddataB  (rddataB_FP_sqrt),
        .ready    (ready_sqrt     )
        );
`else 
    assign rddataA_FP_sqrt = 18'b0;
    assign rddataB_FP_sqrt = 18'b0;
    assign ready_sqrt = 1'b1;
`endif

`ifdef XCU_HAS_FMA
    func_fma fma(             
        .RESET    (RESET         ),
        .CLK      (CLK           ),
        .NaN_del (NaN_del_3),
        .Sext_Dest_q2(Sext_Dest_q2),
        .wren     (wren_fma      ),
        .round_mode_del(round_mode_q2_del_3 ),
        .Away_del      (Away_del_3          ),
        .A_sign_del    (A_sign_del_3        ),
        .A_is_zero_del (A_is_zero_del_3     ),                                  
        .A_invalid_del (A_invalid_del_3     ),
        .A_inexact_del (A_inexact_del_3     ),
        .A_is_infinite_del (A_is_infinite_del_3       ),
        .B_sign_del    (B_sign_del_3        ),
        .B_is_zero_del (B_is_zero_del_3     ),                              
        .B_invalid_del (B_invalid_del_3     ),
        .B_inexact_del (B_inexact_del_3     ),
        .B_is_infinite_del (B_is_infinite_del_3),
        .wraddrs (wraddrs[3:0]),
        .wraddrs_del  (wraddrs_del_4[3:0]),
        .wrdataA  (wrdataA_FP   ),
        .wrdataB  (wrdataB_FP   ),
        .rdenA    (rdenA_fma     ),
        .rdaddrsA (rdaddrsA[3:0]),                        
        .rddataA  (rddataA_FP_fma),                                 
        .rdenB    (rdenB_fma     ),                                 
        .rdaddrsB (rdaddrsB[3:0]),                        
        .rddataB  (rddataB_FP_fma),
        .ready    (ready_fma     )
        );
`else
    assign rddataA_FP_fma = 18'b0;    
    assign rddataB_FP_fma = 18'b0;
    assign ready_fma = 1'b1;
`endif    

`ifdef XCU_HAS_LOG    
    func_log log(              
        .RESET    (RESET         ),
        .CLK      (CLK           ),
        .NaN_del (NaN_del_6),
        .wren     (wren_log      ),
        .round_mode_del(round_mode_q2_del_6 ),
        .Away_del (Away_del_6),
        .A_sign_del    (A_sign_del_6        ),
        .A_is_zero_del (A_is_zero_del_6     ),                              
        .A_invalid_del (A_invalid_del_6     ),
        .A_inexact_del (A_inexact_del_6     ),
        .wraddrs (wraddrs[3:0]),
        .wraddrs_del  (wraddrs_del_7[3:0]),
        .wrdataA  (wrdataA_FP   ),
        .rdenA    (rdenA_log     ),
        .rdaddrsA (rdaddrsA[3:0]),
        .rddataA  (rddataA_FP_log),
        .rdenB    (rdenB_log     ),
        .rdaddrsB (rdaddrsB[3:0]),
        .rddataB  (rddataB_FP_log),
        .ready    (ready_log     )
        );
`else
    assign rddataA_FP_log = 18'b0;
    assign rddataB_FP_log = 18'b0;
    assign ready_log =1'b1;
`endif

`ifdef XCU_HAS_EXP
    func_exp exp(              
        .RESET    (RESET         ),
        .CLK      (CLK           ),
        .NaN_del (NaN_del_2),
        .wren     (wren_exp      ),
        .round_mode_del(round_mode_q2_del_2 ),
        .Away_del (Away_del_2),
        .A_sign_del    (A_sign_del_3        ),
        .A_invalid_del (A_invalid_del_2     ),
        .A_inexact_del (A_inexact_del_2     ),
        .A_is_infinite_del (A_is_infinite_del_3),
        .wraddrs (wraddrs[3:0]),
        .wraddrs_del  (wraddrs_del_3[3:0]),
        .wrdataA  (wrdataA_FP   ),
        .rdenA    (rdenA_exp     ),
        .rdaddrsA (rdaddrsA[3:0]),
        .rddataA  (rddataA_FP_exp),
        .rdenB    (rdenB_exp     ),
        .rdaddrsB (rdaddrsB[3:0]),
        .rddataB  (rddataB_FP_exp),
        .ready    (ready_exp     )
        );
`else
    assign rddataA_FP_exp = 18'b0;
    assign rddataB_FP_exp = 18'b0;
    assign ready_exp = 1'b1;
`endif
    
FPconv conv(
    .RESET        (RESET    ),
    .CLK          (CLK      ),
    .wren         (wren_conv),
    .NaN_del      (NaN_payload),
    
    .A_overflow_del(A_is_overflow),
    .A_underflow_del(A_is_underflow),
    .A_invalid_del (A_is_invalid),
    .A_inexact_del (A_is_inexact),
    
    .wraddrs      (wraddrs[3:0]),
    .wraddrs_del  (wraddrs_del_1[3:0]),
    .wrdata   (wrdataA_FP   ),
    .rdenA    (rdenA_conv   ),
    .rdaddrsA (rdaddrsA[3:0]),
    .rddataA  (rddataA_FP_conv),
    .rdenB    (rdenB_conv   ),
    .rdaddrsB (rdaddrsB[3:0]),
    .rddataB  (rddataB_FP_conv),
    .ready    (ready_conv   )
    );
    
func_scaleB scaleB(
    .RESET         (RESET          ),
    .CLK           (CLK            ),
    .Size_SrcA_q2   (Size_SrcA_q2  ),
    .round_mode_del(round_mode_q2_del_1),
    .Away_del      (Away_del_1     ),
    .NaN_del       (NaN_del_1      ),
    .wren          (wren_scal      ),
    .A_invalid_del (A_invalid_del_1),
    .A_inexact_del (A_inexact_del_1),
    .B_invalid_del (B_invalid_del_1),
    .B_inexact_del (B_inexact_del_1),
    .wraddrs       (wraddrs[3:0]   ),
    .wraddrs_del   (wraddrs_del_2[3:0]),
    .wrdataA       (fwrsrcAdata[63:0]),
    .wrdataB       (wrdataB_FP     ),
    .rdenA         (rdenA_scal     ),
    .rdaddrsA      (rdaddrsA[3:0]  ),
    .rddataA       (rddataA_FP_scal),
    .rdenB         (rdenB_scal     ),
    .rdaddrsB      (rdaddrsB[3:0]  ),
    .rddataB       (rddataB_FP_scal),
    .ready         (ready_scal     )
    );
    
func_logb logb(
    .RESET          (RESET            ),
    .CLK            (CLK              ),
    .Size_SrcA_q2   (Size_SrcA_q2     ),
    .NaN_del        (NaN_del_1        ),
    .A_invalid_del  (A_invalid_del_1  ),
    .A_inexact_del  (A_inexact_del_1  ),
    .B_invalid_del  (B_invalid_del_1  ),
    .B_inexact_del  (B_inexact_del_1  ),
    .wren           (wren_logb        ),
    .wraddrs        (wraddrs[3:0]     ),
    .wraddrs_del    (wraddrs_del_2[3:0]), 
    .wrdataA        (fwrsrcAdata[63:0]),
    .rdenA          (rdenA_logb       ),
    .rdaddrsA       (rdaddrsA[3:0]    ),
    .rddataA        (rddataA_FP_logb  ),
    .rdenB          (rdenB_logb       ),
    .rdaddrsB       (rdaddrsB[3:0]    ), 
    .rddataB        (rddataB_FP_logb  ),
    .ready          (ready_logb       )
    );
    
func_rtoi rtoi(  
    .RESET(RESET),
    .CLK(CLK),
    .round_mode_del(round_mode_q2_del_0),
    .Away_del (Away_del_0),
    .NaN_del(NaN_payload),                                             
    .wren(wren_rtoi),
    .A_is_inexact_del(A_inexact_del_0),
    .A_is_infinite_del(A_is_infinite_del_0),
    .wraddrs_del(wraddrs_del_1[3:0]),
    .wraddrs(wraddrs[3:0]),
    .wrdataA(wrdataA_FP),
    .fwrsrcBdata (fwrsrcBdata[4:0]),
    .rdenA(rdenA_rtoi),
    .rdaddrsA(rdaddrsA[3:0]),
    .rddataA(rddataA_FP_rtoi),
    .rdenB(rdenB_rtoi),
    .rdaddrsB(rdaddrsB[3:0]),
    .rddataB(rddataB_FP_rtoi),
    .ready(ready_rtoi)
    );
                  
`ifdef XCU_HAS_REMAINDER
    func_rem rem(
        .RESET(RESET),
        .CLK(CLK),
        .NaN_del(NaN_del_10),
        .wren(wren_rem),
        .A_sign_del(A_sign_del_11),
        .A_invalid_del(A_invalid_del_10),
        .A_is_infinite_del(A_is_infinite_del_10), 
        .A_is_NaN_del (A_is_NaN_del_10),
        .A_is_normal_del (A_is_normal_del_11),
        .A_is_subnormal_del (A_is_subnormal_del_11),
        .B_invalid_del(B_invalid_del_10),
        .B_is_infinite_del(B_is_infinite_del_11),
        .B_is_zero_del(B_is_zero_del_10),         
        .B_is_NaN_del (B_is_NaN_del_10),
        .wraddrs(wraddrs[3:0]),
        .wraddrs_del(wraddrs_del_11[3:0]),
        .wrdataA(wrdataA_FP),
        .wrdataB(wrdataB_FP),
        .rdenA(rdenA_rem),
        .rdaddrsA(rdaddrsA[3:0]),
        .rddataA(rddataA_FP_rem),
        .rdenB(rdenB_rem),
        .rdaddrsB(rdaddrsA[3:0]),
        .rddataB(rddataB_FP_rem),
        .ready(ready_rem)
        );
`else
    assign rddataA_FP_rem = 18'b0;
    assign rddataB_FP_rem = 18'b0;
    assign ready_rem = 1'b1;
`endif

func_minmax minmax(
    .RESET(RESET),
    .CLK(CLK),
    .NaN_del(NaN_payload),
    .wren(wren_minmax),
    .wraddrs(wraddrs[3:0]),
    .wraddrs_del(wraddrs_del_1[3:0]),
    .wrdataA(wrdataA_FP),
    .wrdataB(wrdataB_FP),
    .rdenA(rdenA_minmax),
    .rdaddrsA(rdaddrsA[3:0]),
    .rddataA(rddataA_FP_minmax),
    .rdenB(rdenB_minmax),
    .rdaddrsB(rdaddrsB[3:0]),
    .rddataB(rddataB_FP_minmax),
    .ready(ready_minmax)
    );     
    
func_next next(
    .RESET       (RESET),
    .CLK         (CLK),
    .NaN_del     (NaN_payload),
    .wren        (wren_next),
    .wraddrs     (wraddrs[3:0]),
    .wraddrs_del (wraddrs_del_1[3:0]),
    .wrdataA     (wrdataA_FP),
    .rdenA       (rdenA_next),
    .rdaddrsA    (rdaddrsA[3:0]),
    .rddataA     (rddataA_FP_next),
    .rdenB       (rdenB_next),
    .rdaddrsB    ( rdaddrsB[3:0]),
    .rddataB     (rddataB_FP_next),
    .ready       (ready_next)                                 
    );           
                
func_cnacs cnacs(
    .RESET(RESET),
    .CLK(CLK),
    .NaN_del(NaN_payload),
    .wren(wren_cnacs),
    .wraddrs( wraddrs[3:0]),
    .wraddrs_del(wraddrs_del_1[3:0]),
    .wrdataA(wrdataA_FP),
    .wrdataB(wrdataB_FP),
    .rdenA(rdenA_cnacs),
    .rdaddrsA(rdaddrsA[3:0]),
    .rddataA(rddataA_FP_cnacs),
    .rdenB(rdenB_cnacs),
    .rdaddrsB(rdaddrsB[3:0]),
    .rddataB(rddataB_FP_cnacs),
    .ready(ready_cnacs)
    );

`ifdef XCU_HAS_TRIG         
    func_trig trig(                                   
        .CLK         (CLK     ),  
        .RESET       (RESET   ),    
        .SIN_wren    (wren_sin),       
        .COS_wren    (wren_cos),       
        .TAN_wren    (wren_tan),       
        .COT_wren    (wren_cot), 
        .round_mode  (round_mode_q2_del_0), 
        .Away        (Away_del_0),     
        .wraddrs     (wraddrs[1:0]),                      
        .wrdataA     (fwrsrcAdata[9:0]),         
        .SIN_rdenA   (rdenA_sin),        
        .COS_rdenA   (rdenA_cos),        
        .TAN_rdenA   (rdenA_tan),        
        .COT_rdenA   (rdenA_cot),        
        .rdaddrsA    (rdaddrsA[1:0]),        
        .SIN_rddataA (rddataA_FP_sin), 
        .COS_rddataA (rddataA_FP_cos), 
        .TAN_rddataA (rddataA_FP_tan), 
        .COT_rddataA (rddataA_FP_cot), 
        .SIN_rdenB   (rdenB_sin),        
        .COS_rdenB   (rdenB_cos),        
        .TAN_rdenB   (rdenB_tan),        
        .COT_rdenB   (rdenB_cot),        
        .rdaddrsB    (rdaddrsB[1:0]),        
        .SIN_rddataB (rddataB_FP_sin),
        .COS_rddataB (rddataB_FP_cos),
        .TAN_rddataB (rddataB_FP_tan),
        .COT_rddataB (rddataB_FP_cot),
        .SIN_ready   (ready_sin),
        .COS_ready   (ready_cos),
        .TAN_ready   (ready_tan),
        .COT_ready   (ready_cot)
        );                                                             
`else
    assign rddataA_FP_sin = 18'b0;
    assign rddataA_FP_cos = 18'b0;
    assign rddataA_FP_tan = 18'b0;
    assign rddataA_FP_cot = 18'b0;
    assign rddataB_FP_sin = 18'b0;
    assign rddataB_FP_cos = 18'b0;
    assign rddataB_FP_tan = 18'b0;
    assign rddataB_FP_cot = 18'b0;
    assign ready_sin      = 1'b1;
    assign ready_cos      = 1'b1;
    assign ready_tan      = 1'b1;
    assign ready_cot      = 1'b1;
`endif 

`ifdef XCU_HAS_DEC_CHAR_BIN
    func_decBin decBin(      //convert from decimal char string
       .RESET        (RESET        ),
       .CLK          (CLK          ),
       .round_mode_q2(round_mode_q2),
       .Away_q2      (Away         ),
       .wren         (wren_cnvfdcs ),
       .wraddrs      (wraddrs[3:0]),
       .wrdataA      (fwrsrcAdata[63:0]),
       .wrdataB      (fwrsrcBdata[63:0]),
       .rdenA        (rdenA_cnvfdcs),
       .rdaddrsA     (rdaddrsA[3:0]),
       .rddataA      (rddataA_FP_cnvfdcs),
       .rdenB        (rdenB_cnvfdcs),
       .rdaddrsB     (rdaddrsB[3:0]),
       .rddataB      (rddataB_FP_cnvfdcs),
       .ready        (ready_cnvfdcs)
        );
`else    
    assign rddataA_FP_cnvfdcs = 18'b0;
    assign rddataB_FP_cnvfdcs = 18'b0;
    assign ready_cnvfdcs = 1'b1;                
`endif

`ifdef XCU_HAS_BIN_DEC_CHAR
    func_binDec binDec(      //convert to decimal char string
        .RESET        (RESET        ),
        .CLK          (CLK          ),
        .round_mode_q2(round_mode_q2),
        .Away_q2      (Away         ),
        .Src_Size_q2  (Size_SrcA_q2 ),
        .Sext_SrcA_q1 (Sext_SrcA_q1 ),
        .Sext_SrcB_q1 (Sext_SrcB_q1 ),      
        .wren         (wren_cnvtdcs ),
        .wraddrs      (wraddrs[3:0]),
        .wrdata       (fwrsrcAdata[63:0]),
        .rdenA        (rdenA_cnvtdcs),
        .rdaddrsA     (rdaddrsA[3:0]),
        .rddataA      (rddataA_FP_cnvtdcs),
        .rdenB        (rdenB_cnvtdcs),
        .rdaddrsB     (rdaddrsB[3:0]),
        .rddataB      (rddataB_FP_cnvtdcs),
        .ready        (ready_cnvtdcs)
        );
`else
    assign rddataA_FP_cnvtdcs = 66'b0;
    assign rddataB_FP_cnvtdcs = 66'b0;
    assign ready_cnvtdcs = 1'b1;
`endif

`ifdef XCU_HAS_HEX_CHAR_BIN
func_hexBin hexBin(   //convert from hex char string
   .RESET        (RESET        ),
   .CLK          (CLK          ),
   .round_mode_q2(round_mode_q2),
   .Away_q2      (Away         ),
   .wren         (wren_cnvfhcs ),
   .wraddrs      (wraddrs[3:0]),
   .wrdataA      (fwrsrcAdata[63:0]),
   .wrdataB      (fwrsrcBdata[63:0]),
   .rdenA        (rdenA_cnvfhcs),
   .rdaddrsA     (rdaddrsA[3:0]),
   .rddataA      (rddataA_FP_cnvfhcs),
   .rdenB        (rdenB_cnvfhcs),
   .rdaddrsB     (rdaddrsB[3:0]),
   .rddataB      (rddataB_FP_cnvfhcs),
   .ready        (ready_cnvfhcs)
    );            
`else
    assign rddataA_FP_cnvfhcs = 18'b0;
    assign rddataB_FP_cnvfhcs = 18'b0;
    assign ready_cnvfhcs = 1'b1;
`endif

`ifdef XCU_HAS_BIN_HEX_CHAR                  
    func_binHex binHex(     //convert from hex char string
        .RESET        (RESET        ),
        .CLK          (CLK          ),
        .round_mode_q2(round_mode_q2),
        .Away_q2      (Away         ),
        .Src_Size_q2  (Size_SrcA_q2 ),
        .Sext_SrcA_q1 (Sext_SrcA_q1 ),
        .Sext_SrcB_q1 (Sext_SrcB_q1 ),       
        .wren         ( wren_cnvthcs),             
        .wraddrs      (wraddrs[3:0]),             
        .wrdata       (fwrsrcAdata[63:0]),             
        .rdenA        (rdenA_cnvthcs),
        .rdaddrsA     (rdaddrsA[3:0]),
        .rddataA      (rddataA_FP_cnvthcs),
        .rdenB        (rdenB_cnvthcs),
        .rdaddrsB     (rdaddrsB[3:0]),
        .rddataB      (rddataB_FP_cnvthcs),
        .ready        (ready_cnvthcs)
        );   
`else 
    assign rddataA_FP_cnvthcs = 66'b0;
    assign rddataB_FP_cnvthcs = 66'b0;
    assign ready_cnvthcs = 1'b1;
`endif

`ifdef XCU_HAS_POWER    
    func_pow pow(
        .RESET         (RESET     ),
        .CLK           (CLK       ),
        .wren          (wren_pow  ),
        .Sext_SrcB_q2  (Sext_SrcB_q2),
        .Sext_SrcA_q2  (Sext_SrcA_q2),
        .round_mode_del(round_mode_q2_del_11),
        .Away_del      (Away_del_11),
        .NaN_del       (NaN_del_11),
        .A_sign_del    (A_sign_del_11),
        .A_invalid_del (A_invalid_del_11),
        .B_invalid_del (B_invalid_del_11),
        .A_inexact_del (A_inexact_del_11),
        .B_inexact_del (B_inexact_del_11),
        .wraddrs_del   (wraddrs_del_12[3:0]),
        .wraddrs       (wraddrs[3:0]),
        .wrdataA       (wrdataA_FP),
        .wrdataB       (wrdataB_FP),
        .rdenA         (rdenA_pow),
        .rdaddrsA      (rdaddrsA[3:0]),
        .rddataA       (rddataA_FP_pow),
        .rdenB         (rdenB_pow),
        .rdaddrsB      (rdaddrsB[3:0]),
        .rddataB       (rddataB_FP_pow),
        .ready         (ready_pow )
        );
`else
    assign rddataA_FP_pow = 18'b0;
    assign rddataB_FP_pow = 18'b0;
    assign ready_pow = 1'b1;
`endif              

always@(posedge CLK) begin
    if (RESET) begin
        wraddrs_del_0  <= 5'b0;
        wraddrs_del_1  <= 5'b0;
        wraddrs_del_2  <= 5'b0;
        wraddrs_del_3  <= 5'b0;
        wraddrs_del_4  <= 5'b0;
        wraddrs_del_5  <= 5'b0;
        wraddrs_del_6  <= 5'b0;
        wraddrs_del_7  <= 5'b0;
        wraddrs_del_8  <= 5'b0;
        wraddrs_del_9  <= 5'b0;
        wraddrs_del_10 <= 5'b0;
        wraddrs_del_11 <= 5'b0;
        wraddrs_del_12 <= 5'b0;
    end
    else begin
        wraddrs_del_0  <= wraddrs[4:0]; 
        wraddrs_del_1  <= wraddrs_del_0; 
        wraddrs_del_2  <= wraddrs_del_1; 
        wraddrs_del_3  <= wraddrs_del_2; 
        wraddrs_del_4  <= wraddrs_del_3; 
        wraddrs_del_5  <= wraddrs_del_4; 
        wraddrs_del_6  <= wraddrs_del_5; 
        wraddrs_del_7  <= wraddrs_del_6; 
        wraddrs_del_8  <= wraddrs_del_7; 
        wraddrs_del_9  <= wraddrs_del_8; 
        wraddrs_del_10 <= wraddrs_del_9; 
        wraddrs_del_11 <= wraddrs_del_10;
        wraddrs_del_12 <= wraddrs_del_11;
    end    
end    

// for propagating qNaN payloads where, as operands, they remain quiet without raising exceptions and are substituted for results
always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        NaN_del_1  <= 10'b0;
        NaN_del_2  <= 10'b0;
        NaN_del_3  <= 10'b0;
        NaN_del_4  <= 10'b0;
        NaN_del_5  <= 10'b0;
        NaN_del_6  <= 10'b0;
        NaN_del_7  <= 10'b0;
        NaN_del_8  <= 10'b0;
        NaN_del_9  <= 10'b0;
        NaN_del_10 <= 10'b0;
        NaN_del_11 <= 10'b0;
    end
    else begin
        NaN_del_1  <=  NaN_payload ;
        NaN_del_2  <= NaN_del_1 ;
        NaN_del_3  <= NaN_del_2 ;
        NaN_del_4  <= NaN_del_3 ;
        NaN_del_5  <= NaN_del_4 ;
        NaN_del_6  <= NaN_del_5 ;
        NaN_del_7  <= NaN_del_6 ;
        NaN_del_8  <= NaN_del_7 ;
        NaN_del_9  <= NaN_del_8 ;
        NaN_del_10 <= NaN_del_9 ;
        NaN_del_11 <= NaN_del_10;
    end
end 

always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        round_mode_q2_del_0 <= 2'b00;    
        round_mode_q2_del_1 <= 2'b00;
        round_mode_q2_del_2 <= 2'b00;
        round_mode_q2_del_3 <= 2'b00;
        round_mode_q2_del_4 <= 2'b00;
        round_mode_q2_del_5 <= 2'b00;
        round_mode_q2_del_6 <= 2'b00;
        round_mode_q2_del_7 <= 2'b00;
        round_mode_q2_del_8 <= 2'b00;
        round_mode_q2_del_9 <= 2'b00;
        round_mode_q2_del_10 <= 2'b00;
        round_mode_q2_del_11 <= 2'b00;
    end
    else begin
        round_mode_q2_del_0 <= round_mode_q2;
        round_mode_q2_del_1 <= round_mode_q2_del_0;
        round_mode_q2_del_2 <= round_mode_q2_del_1;
        round_mode_q2_del_3 <= round_mode_q2_del_2;
        round_mode_q2_del_4 <= round_mode_q2_del_3;
        round_mode_q2_del_5 <= round_mode_q2_del_4;
        round_mode_q2_del_6 <= round_mode_q2_del_5;
        round_mode_q2_del_7 <= round_mode_q2_del_6;
        round_mode_q2_del_8 <= round_mode_q2_del_7;
        round_mode_q2_del_9 <= round_mode_q2_del_8;
        round_mode_q2_del_10 <= round_mode_q2_del_9;
        round_mode_q2_del_11 <= round_mode_q2_del_10;
    end
end        


always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        A_sign_del_1  <= 1'b0;
        A_sign_del_2  <= 1'b0;
        A_sign_del_3  <= 1'b0;
        A_sign_del_4  <= 1'b0;
        A_sign_del_5  <= 1'b0;
        A_sign_del_6  <= 1'b0;
        A_sign_del_7  <= 1'b0;
        A_sign_del_8  <= 1'b0;
        A_sign_del_9  <= 1'b0;
        A_sign_del_10 <= 1'b0;
        A_sign_del_11 <= 1'b0;
    end    
    else begin
        A_sign_del_1  <= wrdataA_FP[16] ;
        A_sign_del_2  <= A_sign_del_1 ;
        A_sign_del_3  <= A_sign_del_2 ;
        A_sign_del_4  <= A_sign_del_3 ;
        A_sign_del_5  <= A_sign_del_4 ;
        A_sign_del_6  <= A_sign_del_5 ;
        A_sign_del_7  <= A_sign_del_6 ;
        A_sign_del_8  <= A_sign_del_7 ;
        A_sign_del_9  <= A_sign_del_8 ;
        A_sign_del_10 <= A_sign_del_9 ;
        A_sign_del_11 <= A_sign_del_10;
    end
 end
    
always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        A_invalid_del_1  <= 1'b0;
        A_invalid_del_2  <= 1'b0;
        A_invalid_del_3  <= 1'b0;
        A_invalid_del_4  <= 1'b0;
        A_invalid_del_5  <= 1'b0;
        A_invalid_del_6  <= 1'b0;
        A_invalid_del_7  <= 1'b0;
        A_invalid_del_8  <= 1'b0;
        A_invalid_del_9  <= 1'b0;
        A_invalid_del_10 <= 1'b0;
        A_invalid_del_11 <= 1'b0;
    end    
    else begin
        A_invalid_del_1  <= A_is_invalid ;
        A_invalid_del_2  <= A_invalid_del_1 ;
        A_invalid_del_3  <= A_invalid_del_2 ;
        A_invalid_del_4  <= A_invalid_del_3 ;
        A_invalid_del_5  <= A_invalid_del_4 ;
        A_invalid_del_6  <= A_invalid_del_5 ;
        A_invalid_del_7  <= A_invalid_del_6 ;
        A_invalid_del_8  <= A_invalid_del_7 ;
        A_invalid_del_9  <= A_invalid_del_8 ;
        A_invalid_del_10 <= A_invalid_del_9 ;
        A_invalid_del_11 <= A_invalid_del_10;
    end
end                                                                                
  
always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        A_overflow_del_0  <= 1'b0;
    end    
    else begin
        A_overflow_del_0  <= A_is_overflow;
    end
end

always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        A_underflow_del_0  <= 1'b0;
    end    
    else begin
        A_underflow_del_0  <= A_is_underflow;
    end
end
  
    
always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        A_inexact_del_1  <= 1'b0;
        A_inexact_del_2  <= 1'b0;
        A_inexact_del_3  <= 1'b0;
        A_inexact_del_4  <= 1'b0;
        A_inexact_del_5  <= 1'b0;
        A_inexact_del_6  <= 1'b0;
        A_inexact_del_7  <= 1'b0;
        A_inexact_del_8  <= 1'b0;
        A_inexact_del_9  <= 1'b0;
        A_inexact_del_10 <= 1'b0;
        A_inexact_del_11 <= 1'b0;
    end    
    else begin
        A_inexact_del_1  <= A_is_inexact ;
        A_inexact_del_2  <= A_inexact_del_1 ;
        A_inexact_del_3  <= A_inexact_del_2 ;
        A_inexact_del_4  <= A_inexact_del_3 ;
        A_inexact_del_5  <= A_inexact_del_4 ;
        A_inexact_del_6  <= A_inexact_del_5 ;
        A_inexact_del_7  <= A_inexact_del_6 ;
        A_inexact_del_8  <= A_inexact_del_7 ;
        A_inexact_del_9  <= A_inexact_del_8 ;
        A_inexact_del_10 <= A_inexact_del_9 ;
        A_inexact_del_11 <= A_inexact_del_10;
    end
 end   
    
always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        B_sign_del_1  <= 1'b0;
        B_sign_del_2  <= 1'b0;
        B_sign_del_3  <= 1'b0;
        B_sign_del_4  <= 1'b0;
        B_sign_del_5  <= 1'b0;
    end    
    else begin
        B_sign_del_1  <= wrdataB_FP[16] ;
        B_sign_del_2  <= B_sign_del_1 ;
        B_sign_del_3  <= B_sign_del_2 ;
        B_sign_del_4  <= B_sign_del_3 ;
        B_sign_del_5  <= B_sign_del_4 ;
    end
end
    
always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        B_invalid_del_1  <= 1'b0;
        B_invalid_del_2  <= 1'b0;
        B_invalid_del_3  <= 1'b0;
        B_invalid_del_4  <= 1'b0;
        B_invalid_del_5  <= 1'b0;
        B_invalid_del_6  <= 1'b0;
        B_invalid_del_7  <= 1'b0;
        B_invalid_del_8  <= 1'b0;
        B_invalid_del_9  <= 1'b0;
        B_invalid_del_10 <= 1'b0;
        B_invalid_del_11 <= 1'b0;
    end    
    else begin
        B_invalid_del_1  <= B_is_invalid ;
        B_invalid_del_2  <= B_invalid_del_1 ;
        B_invalid_del_3  <= B_invalid_del_2 ;
        B_invalid_del_4  <= B_invalid_del_3 ;
        B_invalid_del_5  <= B_invalid_del_4 ;
        B_invalid_del_6  <= B_invalid_del_5 ;
        B_invalid_del_7  <= B_invalid_del_6 ;
        B_invalid_del_8  <= B_invalid_del_7 ;
        B_invalid_del_9  <= B_invalid_del_8 ;
        B_invalid_del_10 <= B_invalid_del_9 ;
        B_invalid_del_11 <= B_invalid_del_10;
    end
end
    
always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        B_inexact_del_1  <= 1'b0;
        B_inexact_del_2  <= 1'b0;
        B_inexact_del_3  <= 1'b0;
        B_inexact_del_4  <= 1'b0;
        B_inexact_del_5  <= 1'b0;
        B_inexact_del_6  <= 1'b0;
        B_inexact_del_7  <= 1'b0;
        B_inexact_del_8  <= 1'b0;
        B_inexact_del_9  <= 1'b0;
        B_inexact_del_10 <= 1'b0;
        B_inexact_del_11 <= 1'b0;
    end    
    else begin
        B_inexact_del_1  <= B_is_inexact ;
        B_inexact_del_2  <= B_inexact_del_1 ;
        B_inexact_del_3  <= B_inexact_del_2 ;
        B_inexact_del_4  <= B_inexact_del_3 ;
        B_inexact_del_5  <= B_inexact_del_4 ;
        B_inexact_del_6  <= B_inexact_del_5 ;
        B_inexact_del_7  <= B_inexact_del_6 ;
        B_inexact_del_8  <= B_inexact_del_7 ;
        B_inexact_del_9  <= B_inexact_del_8 ;
        B_inexact_del_10 <= B_inexact_del_9 ;
        B_inexact_del_11 <= B_inexact_del_10;
    end
 end
 
always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        A_is_zero_del_1  <= 1'b0;
        A_is_zero_del_2  <= 1'b0;
        A_is_zero_del_3  <= 1'b0;
        A_is_zero_del_4  <= 1'b0;
        A_is_zero_del_5  <= 1'b0;
        A_is_zero_del_6  <= 1'b0;
    end    
    else begin
        A_is_zero_del_1  <= A_is_zero ;
        A_is_zero_del_2  <= A_is_zero_del_1 ;
        A_is_zero_del_3  <= A_is_zero_del_2 ;
        A_is_zero_del_4  <= A_is_zero_del_3 ;
        A_is_zero_del_5  <= A_is_zero_del_4 ;
        A_is_zero_del_6  <= A_is_zero_del_5 ;
    end
 end

always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        A_is_normal_del_1  <= 1'b0;
        A_is_normal_del_2  <= 1'b0;
        A_is_normal_del_3  <= 1'b0;
        A_is_normal_del_4  <= 1'b0;
        A_is_normal_del_5  <= 1'b0;
        A_is_normal_del_6  <= 1'b0;
        A_is_normal_del_7  <= 1'b0;
        A_is_normal_del_8  <= 1'b0;
        A_is_normal_del_9  <= 1'b0;
        A_is_normal_del_10 <= 1'b0;
        A_is_normal_del_11 <= 1'b0;
    end    
    else begin
        A_is_normal_del_1  <= A_is_normal ;
        A_is_normal_del_2  <= A_is_normal_del_1 ;
        A_is_normal_del_3  <= A_is_normal_del_2 ;
        A_is_normal_del_4  <= A_is_normal_del_3 ;
        A_is_normal_del_5  <= A_is_normal_del_4 ;
        A_is_normal_del_6  <= A_is_normal_del_5 ;
        A_is_normal_del_7  <= A_is_normal_del_6 ;
        A_is_normal_del_8  <= A_is_normal_del_7 ;
        A_is_normal_del_9  <= A_is_normal_del_8 ;
        A_is_normal_del_10 <= A_is_normal_del_9 ;
        A_is_normal_del_11 <= A_is_normal_del_10;
    end
 end

always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        A_is_subnormal_del_1  <= 1'b0;
        A_is_subnormal_del_2  <= 1'b0;
        A_is_subnormal_del_3  <= 1'b0;
        A_is_subnormal_del_4  <= 1'b0;
        A_is_subnormal_del_5  <= 1'b0;
        A_is_subnormal_del_6  <= 1'b0;
        A_is_subnormal_del_7  <= 1'b0;
        A_is_subnormal_del_8  <= 1'b0;
        A_is_subnormal_del_9  <= 1'b0;
        A_is_subnormal_del_10 <= 1'b0;
        A_is_subnormal_del_11 <= 1'b0;
    end    
    else begin
        A_is_subnormal_del_1  <= A_is_subnormal ;
        A_is_subnormal_del_2  <= A_is_subnormal_del_1 ;
        A_is_subnormal_del_3  <= A_is_subnormal_del_2 ;
        A_is_subnormal_del_4  <= A_is_subnormal_del_3 ;
        A_is_subnormal_del_5  <= A_is_subnormal_del_4 ;
        A_is_subnormal_del_6  <= A_is_subnormal_del_5 ;
        A_is_subnormal_del_7  <= A_is_subnormal_del_6 ;
        A_is_subnormal_del_8  <= A_is_subnormal_del_7 ;
        A_is_subnormal_del_9  <= A_is_subnormal_del_8 ;
        A_is_subnormal_del_10 <= A_is_subnormal_del_9 ;
        A_is_subnormal_del_11 <= A_is_subnormal_del_10;
    end
 end

always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        A_is_NaN_del_1  <= 1'b0;
        A_is_NaN_del_2  <= 1'b0;
        A_is_NaN_del_3  <= 1'b0;
        A_is_NaN_del_4  <= 1'b0;
        A_is_NaN_del_5  <= 1'b0;
        A_is_NaN_del_6  <= 1'b0;
        A_is_NaN_del_7  <= 1'b0;
        A_is_NaN_del_8  <= 1'b0;
        A_is_NaN_del_9  <= 1'b0;
        A_is_NaN_del_10 <= 1'b0;
    end    
    else begin
        A_is_NaN_del_1  <= A_is_NaN ;
        A_is_NaN_del_2  <= A_is_NaN_del_1 ;
        A_is_NaN_del_3  <= A_is_NaN_del_2 ;
        A_is_NaN_del_4  <= A_is_NaN_del_3 ;
        A_is_NaN_del_5  <= A_is_NaN_del_4 ;
        A_is_NaN_del_6  <= A_is_NaN_del_5 ;
        A_is_NaN_del_7  <= A_is_NaN_del_6 ;
        A_is_NaN_del_8  <= A_is_NaN_del_7 ;
        A_is_NaN_del_9  <= A_is_NaN_del_8 ;
        A_is_NaN_del_10 <= A_is_NaN_del_9 ;
    end
 end

always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        B_is_NaN_del_1  <= 1'b0;
        B_is_NaN_del_2  <= 1'b0;
        B_is_NaN_del_3  <= 1'b0;
        B_is_NaN_del_4  <= 1'b0;
        B_is_NaN_del_5  <= 1'b0;
        B_is_NaN_del_6  <= 1'b0;
        B_is_NaN_del_7  <= 1'b0;
        B_is_NaN_del_8  <= 1'b0;
        B_is_NaN_del_9  <= 1'b0;
        B_is_NaN_del_10 <= 1'b0;
    end    
    else begin
        B_is_NaN_del_1  <= B_is_NaN ;
        B_is_NaN_del_2  <= B_is_NaN_del_1 ;
        B_is_NaN_del_3  <= B_is_NaN_del_2 ;
        B_is_NaN_del_4  <= B_is_NaN_del_3 ;
        B_is_NaN_del_5  <= B_is_NaN_del_4 ;
        B_is_NaN_del_6  <= B_is_NaN_del_5 ;
        B_is_NaN_del_7  <= B_is_NaN_del_6 ;
        B_is_NaN_del_8  <= B_is_NaN_del_7 ;
        B_is_NaN_del_9  <= B_is_NaN_del_8 ;
        B_is_NaN_del_10 <= B_is_NaN_del_9 ;
    end
 end
    
always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        B_is_zero_del_1  <= 1'b0;
        B_is_zero_del_2  <= 1'b0;
        B_is_zero_del_3  <= 1'b0;
        B_is_zero_del_4  <= 1'b0;
        B_is_zero_del_5  <= 1'b0;
        B_is_zero_del_6  <= 1'b0;
        B_is_zero_del_7  <= 1'b0;
        B_is_zero_del_8  <= 1'b0;
        B_is_zero_del_9  <= 1'b0;
        B_is_zero_del_10 <= 1'b0;
    end    
    else begin
        B_is_zero_del_1  <= B_is_zero ;
        B_is_zero_del_2  <= B_is_zero_del_1 ;
        B_is_zero_del_3  <= B_is_zero_del_2 ;
        B_is_zero_del_4  <= B_is_zero_del_3 ;
        B_is_zero_del_5  <= B_is_zero_del_4 ;
        B_is_zero_del_6  <= B_is_zero_del_5 ;
        B_is_zero_del_7  <= B_is_zero_del_6 ;
        B_is_zero_del_8  <= B_is_zero_del_7 ;
        B_is_zero_del_9  <= B_is_zero_del_8 ;
        B_is_zero_del_10 <= B_is_zero_del_9 ;
    end
 end
    

always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        Away_del_0  <= 1'b0;
        Away_del_1  <= 1'b0;
        Away_del_2  <= 1'b0;
        Away_del_3  <= 1'b0;
        Away_del_4  <= 1'b0;
        Away_del_5  <= 1'b0;
        Away_del_6  <= 1'b0;
        Away_del_7  <= 1'b0;
        Away_del_8  <= 1'b0;
        Away_del_9  <= 1'b0;
        Away_del_10 <= 1'b0;
        Away_del_11 <= 1'b0;
    end
    else begin
        Away_del_0  <= Away;
        Away_del_1  <= Away_del_0 ;
        Away_del_1  <= Away_del_0 ;
        Away_del_2  <= Away_del_1 ;
        Away_del_3  <= Away_del_2 ;
        Away_del_4  <= Away_del_3 ;
        Away_del_5  <= Away_del_4 ;
        Away_del_6  <= Away_del_5 ;
        Away_del_7  <= Away_del_6 ;
        Away_del_8  <= Away_del_7 ;
        Away_del_9  <= Away_del_8 ;
        Away_del_10 <= Away_del_9 ;
        Away_del_11 <= Away_del_10;
   end
end        

always @(posedge CLK or posedge RESET) begin
    if (RESET) begin    
        A_is_infinite_del_1  <= 1'b0; 
        A_is_infinite_del_2  <= 1'b0; 
        A_is_infinite_del_3  <= 1'b0; 
        A_is_infinite_del_4  <= 1'b0; 
        A_is_infinite_del_5  <= 1'b0; 
        A_is_infinite_del_6  <= 1'b0; 
        A_is_infinite_del_7  <= 1'b0; 
        A_is_infinite_del_8  <= 1'b0;
        A_is_infinite_del_9  <= 1'b0; 
        A_is_infinite_del_10 <= 1'b0;  
    end
    else begin    
        A_is_infinite_del_1  <= A_is_infinite  ;
        A_is_infinite_del_2  <= A_is_infinite_del_1  ;
        A_is_infinite_del_3  <= A_is_infinite_del_2  ;
        A_is_infinite_del_4  <= A_is_infinite_del_3  ;
        A_is_infinite_del_5  <= A_is_infinite_del_4  ;
        A_is_infinite_del_6  <= A_is_infinite_del_5  ;
        A_is_infinite_del_7  <= A_is_infinite_del_6  ;
        A_is_infinite_del_8  <= A_is_infinite_del_7  ;
        A_is_infinite_del_9  <= A_is_infinite_del_8  ;
        A_is_infinite_del_10 <= A_is_infinite_del_9  ;
    end
end                                                     
 
always @(posedge CLK or posedge RESET) begin
    if (RESET) begin    
        B_is_infinite_del_1  <= 1'b0; 
        B_is_infinite_del_2  <= 1'b0; 
        B_is_infinite_del_3  <= 1'b0; 
        B_is_infinite_del_4  <= 1'b0; 
        B_is_infinite_del_5  <= 1'b0; 
        B_is_infinite_del_6  <= 1'b0; 
        B_is_infinite_del_7  <= 1'b0; 
        B_is_infinite_del_8  <= 1'b0;
        B_is_infinite_del_9  <= 1'b0; 
        B_is_infinite_del_10 <= 1'b0;  
        B_is_infinite_del_11 <= 1'b0; 
    end
    else begin    
        B_is_infinite_del_1  <= B_is_infinite  ;
        B_is_infinite_del_2  <= B_is_infinite_del_1  ;
        B_is_infinite_del_3  <= B_is_infinite_del_2  ;
        B_is_infinite_del_4  <= B_is_infinite_del_3  ;
        B_is_infinite_del_5  <= B_is_infinite_del_4  ;
        B_is_infinite_del_6  <= B_is_infinite_del_5  ;
        B_is_infinite_del_7  <= B_is_infinite_del_6  ;
        B_is_infinite_del_8  <= B_is_infinite_del_7  ;
        B_is_infinite_del_9  <= B_is_infinite_del_8  ;
        B_is_infinite_del_10 <= B_is_infinite_del_9  ;
        B_is_infinite_del_11 <= B_is_infinite_del_10 ;
    end
end
                                                                         
always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        fwrsrcAdata <= 16'b0;
        fwrsrcBdata <= 16'b0;
        round_mode_q2 <= 2'b0;                                     
    end
    else begin
        if (&Dam_q1) begin        // MOV immediate 32
            fwrsrcAdata <= {OPsrc32_q1};
            fwrsrcBdata <= rdSrcBdata; 
        end        
        else if (Dam_q1[0]) begin        // MOV immediate 8 or 16
            fwrsrcAdata <= (~Ind_SrcA_q1 && ~|OPsrcA_q1) ? {16'h0000, OPsrcB_q1} : rdSrcAdata;
            fwrsrcBdata <= {16'h0000, OPsrcB_q1}; 
        end        
        else begin     // any combination of direct or indirect
            fwrsrcAdata <= rdSrcAdata;             
            fwrsrcBdata <= rdSrcBdata; 
        end
        round_mode_q2 <= round_mode_q1;
    end 
end    
    
always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        rdenA_q1 <= 1'b0;
        rdenB_q1 <= 1'b0;
        rdAfunc_sel_q1 <= 5'b00000;
        rdBfunc_sel_q1 <= 5'b00000;        
    end
    else begin
        rdenA_q1 <= rdenA;
        rdenB_q1 <= rdenB;
        rdAfunc_sel_q1 <= rdAfunc_sel;
        rdBfunc_sel_q1 <= rdBfunc_sel;        
    end
end            
   
always @(*)
    if (rdenA_q1) begin
        if (rdAfunc_sel_q1[6:2]==CNVTDCS[6:2]) rddataA = rddataA_FP_cnvtdcs[63:0];
        else if (rdAfunc_sel_q1[6:2]==CNVTHCS[6:2]) rddataA = rddataA_FP_cnvthcs[63:0];
        else
            casex (Size_SrcA_q1)
                DP : rddataA = (rdAfunc_sel_q1[6:2]==FTOI[6:2]) ? {48'b0, rddataA_out[15:0]} : DP_intermA;    //to read FTOI, read as sh (signed half-word, not DP)
                SP : rddataA = (rdAfunc_sel_q1[6:2]==FTOI[6:2]) ? {48'b0, rddataA_out[15:0]} : SP_intermA;    //to read FTOI, read as sh (signed half-word, not SP)
                HP : rddataA = (rdAfunc_sel_q1[6:2]==FTOI[6:2]) ? {48'b0, rddataA_out[15:0]} : HP_intermA;    //to read FTOI, read as sh (signed half-word, not HP) 
           default : rddataA = {48'b0, rddataA_out[15:0]};
            endcase
    end
    else rddataA = {48'b0, rddataA_out[15:0]};

always @(*)
    if (rdenB_q1) begin
        if (rdBfunc_sel_q1[6:2]==CNVTDCS[6:2]) rddataB = rddataB_FP_cnvtdcs[63:0];
        else if (rdBfunc_sel_q1[6:2]==CNVTHCS[6:2]) rddataB = rddataB_FP_cnvthcs[63:0];
        else 
            casex (Size_SrcB_q1)
                DP : rddataB = (rdBfunc_sel_q1[6:2]==FTOI[6:2]) ? {48'b0, rddataB_out[15:0]} : DP_intermB;    //to read FTOI, read as sh (signed half-word, not DP)
                SP : rddataB = (rdBfunc_sel_q1[6:2]==FTOI[6:2]) ? {48'b0, rddataB_out[15:0]} : SP_intermB;    //to read FTOI, read as sh (signed half-word, not SP)
                HP : rddataB = (rdBfunc_sel_q1[6:2]==FTOI[6:2]) ? {48'b0, rddataB_out[15:0]} : HP_intermB;    //to read FTOI, read as sh (signed half-word, not HP) 
           default : rddataB = {48'b0, rddataB_out[15:0]};
          endcase
    end      
    else  rddataB = {48'b0, rddataB_out[15:0]};


always @(*)
    if (rdenA_q1) begin
        if (rdAfunc_sel_q1[6:2]==CNVTDCS[6:2]) exc_codeA = rddataA_FP_cnvtdcs[65:64];
        else if (rdAfunc_sel_q1[6:2]==CNVTHCS[6:2]) exc_codeA = rddataA_FP_cnvthcs[65:64];
        else if (rdAfunc_sel_q1[6:2]==FTOI[6:2]) exc_codeA = 2'b00;
        else exc_codeA = rddataA_out[17:16];
    end
    else exc_codeA = rddataA_out[17:16];    

always @(*)
    if (rdenB_q1) begin
        if (rdBfunc_sel_q1[6:2]==CNVTDCS[6:2]) exc_codeB = rddataB_FP_cnvtdcs[65:64];
        else if (rdBfunc_sel_q1[6:2]==CNVTHCS[6:2]) exc_codeB = rddataB_FP_cnvthcs[65:64];
        else if (rdBfunc_sel_q1[6:2]==FTOI[6:2]) exc_codeB = 2'b00;
        else exc_codeB = rddataB_out[17:16];
    end
    else exc_codeB = rddataB_out[17:16];   

   
always @(*) 
    if (rdenA_q1)                                                                                       
        casex (rdAfunc_sel_q1)                                                                          
            FADD : begin                                                                         
                      rddataA_out = rddataA_FP_add;
                      readyA = ready_add;
                   end   
            FSUB : begin
                      rddataA_out = rddataA_FP_add;
                      readyA = ready_add;
                   end  
            FMUL : begin
                      rddataA_out = rddataA_FP_mul; 
                      readyA = ready_mul;
                   end  
            FTOI : begin
                      rddataA_out = rddataA_FP_ftoi; 
                      readyA = ready_ftoi;
                   end  
                   
            ITOF : begin
                      rddataA_out = rddataA_INT_itof; 
                      readyA = ready_itof;
                   end  
            FDIV : begin
                      rddataA_out = rddataA_FP_div;
                      readyA = ready_div;
                   end  

            SQRT : begin
                      rddataA_out = rddataA_FP_sqrt; 
                      readyA = ready_sqrt;
                   end 
            LOG : begin                                                   
                     rddataA_out = rddataA_FP_log;                        
                     readyA = ready_log;                                  
                  end 
            EXP : begin
                     rddataA_out = rddataA_FP_exp; 
                     readyA = ready_exp;
                  end
            CONV : begin
                     rddataA_out = rddataA_FP_conv; 
                     readyA = ready_conv;
                  end 
                    
             FMA : begin                                                   
                      rddataA_out = rddataA_FP_fma;                       
                      readyA = ready_fma;                                 
                  end                                                     
            SCAL : begin
                     rddataA_out = rddataA_FP_scal; 
                     readyA = ready_scal;
                  end 
            LOGB : begin
                     rddataA_out = rddataA_FP_logb; 
                     readyA = ready_logb;
                  end 
            RTOI : begin
                     rddataA_out = rddataA_FP_rtoi; 
                     readyA = ready_rtoi;
                  end 
            REM : begin
                     rddataA_out = rddataA_FP_rem; 
                     readyA = ready_rem;                                                             
                  end                   
         MINMAX : begin
                     rddataA_out = rddataA_FP_minmax; 
                     readyA = ready_minmax;
                  end 
           NEXT : begin
                     rddataA_out = rddataA_FP_next; 
                     readyA = ready_next;
                  end 
          CNACS : begin
                     rddataA_out = rddataA_FP_cnacs; 
                     readyA = ready_cnacs;
                  end 
            SIN : begin
                     rddataA_out = rddataA_FP_sin;
                     readyA = ready_sin;
                  end   
            COS : begin
                     rddataA_out = rddataA_FP_cos;
                     readyA = ready_cos;
                  end   
            TAN : begin
                     rddataA_out = rddataA_FP_tan;
                     readyA = ready_tan;
                  end   
            COT : begin
                     rddataA_out = rddataA_FP_cot;
                     readyA = ready_cot;
                  end   
        CNVFDCS : begin
                     rddataA_out = rddataA_FP_cnvfdcs;
                     readyA = ready_cnvfdcs;
                  end   
        CNVFHCS : begin
                     rddataA_out = rddataA_FP_cnvfhcs;
                     readyA = ready_cnvfhcs;
                  end
        CNVTDCS : begin
                     rddataA_out = rddataA_FP_cnvtdcs[17:0];
                     readyA = ready_cnvtdcs;
                  end   
        CNVTHCS : begin
                     rddataA_out = rddataA_FP_cnvthcs[17:0];
                     readyA = ready_cnvthcs;
                  end                        
            POW : begin
                     rddataA_out = rddataA_FP_pow[17:0];
                     readyA = ready_pow;
                  end                        
        default : begin
                     rddataA_out = 18'b0;
                     readyA = 1'b1;
                  end
        endcase 
        else begin
           rddataA_out = 18'b0;
           readyA = 1'b1;
        end

                      
always @(*) 
    if (rdenB_q1)                                                                                       
        casex (rdBfunc_sel_q1)                                                                          
            FADD : begin                                                                         
                      rddataB_out = rddataB_FP_add;
                      readyB = ready_add;
                   end   
            FSUB : begin
                      rddataB_out = rddataB_FP_add;
                      readyB = ready_add;
                   end  
            FMUL : begin
                      rddataB_out = rddataB_FP_mul; 
                      readyB = ready_mul;
                   end  
            FTOI : begin
                      rddataB_out = rddataB_FP_ftoi; 
                      readyB = ready_ftoi;
                   end  
                   
            ITOF : begin
                      rddataB_out = rddataB_INT_itof; 
                      readyB = ready_itof;
                   end  
            FDIV : begin                                                      
                      rddataB_out = rddataB_FP_div;                           
                      readyB = ready_div;                                     
                   end                                                        
            SQRT : begin                                                      
                      rddataB_out = rddataB_FP_sqrt;                          
                      readyB = ready_sqrt;                                    
                   end  
            LOG : begin
                     rddataB_out = rddataB_FP_log; 
                     readyB = ready_log;
                  end 
            EXP : begin
                     rddataB_out = rddataB_FP_exp; 
                     readyB = ready_exp;
                  end 
            CONV : begin
                     rddataB_out = rddataB_FP_conv; 
                     readyB = ready_conv;
                  end 
            FMA : begin
                      rddataB_out = rddataB_FP_fma; 
                      readyB = ready_fma;
                  end  
            SCAL : begin
                     rddataB_out = rddataB_FP_scal; 
                     readyB = ready_scal;
                  end 
            LOGB : begin
                     rddataB_out = rddataB_FP_logb; 
                     readyB = ready_logb;
                  end 
            RTOI : begin
                     rddataB_out = rddataB_FP_rtoi; 
                     readyB = ready_rtoi;
                  end 
            REM : begin
                     rddataB_out = rddataB_FP_rem; 
                     readyB = ready_rem;
                  end 
         MINMAX : begin
                     rddataB_out = rddataB_FP_minmax; 
                     readyB = ready_minmax;
                  end 
           NEXT : begin
                     rddataB_out = rddataB_FP_next;                              
                     readyB = ready_next;
                  end 
          CNACS : begin
                     rddataB_out = rddataB_FP_cnacs; 
                     readyB = ready_cnacs;
                  end 
            SIN : begin
                     rddataB_out = rddataB_FP_sin;
                     readyB = ready_sin;
                  end   
            COS : begin
                     rddataB_out = rddataB_FP_cos;
                     readyB = ready_cos;
                  end   
            TAN : begin
                     rddataB_out = rddataB_FP_tan;
                     readyB = ready_tan;
                  end   
            COT : begin
                     rddataB_out = rddataB_FP_cot;
                     readyB = ready_cot;
                  end
        CNVFDCS : begin
                     rddataB_out = rddataB_FP_cnvfdcs;
                     readyB = ready_cnvfdcs;
                  end   
        CNVFHCS : begin
                     rddataB_out = rddataB_FP_cnvfhcs;
                     readyB = ready_cnvfhcs;
                  end   
        CNVTDCS : begin
                     rddataB_out = rddataB_FP_cnvtdcs[17:0];
                     readyB = ready_cnvtdcs;
                  end   
        CNVTHCS : begin
                     rddataB_out = rddataB_FP_cnvthcs[17:0];
                     readyB = ready_cnvthcs;
                  end   
            POW : begin
                     rddataB_out = rddataB_FP_pow[17:0];
                     readyB = ready_pow;
                  end                        
        default : begin
                     rddataB_out = 18'b0;
                     readyB = 1'b1;
                  end
        endcase 
        else begin
           rddataB_out = 18'b0;
           readyB = 1'b1;
        end


always @(*) begin
    if ((wrfunc_sel[6:2]==FADD[6:2]) && wren) wren_add  = 1'b1;      
    else wren_add = 1'b0;
    if ((wrfunc_sel[6:2]==FSUB[6:2]) && wren) wren_sub  = 1'b1;      
    else wren_sub = 1'b0;                                                        
    if ((wrfunc_sel[6:2]==FMUL[6:2]) && wren) wren_mul  = 1'b1;                            
    else wren_mul = 1'b0;        
    if ((wrfunc_sel[6:2]==ITOF[6:2]) && wren) wren_itof = 1'b1;
    else wren_itof = 1'b0;
    
    if ((wrfunc_sel[6:2]==FTOI[6:2]) && wren) wren_ftoi = 1'b1;                            
    else wren_ftoi = 1'b0;                                                       
    if ((wrfunc_sel[6:2]==FDIV[6:2]) && wren) wren_div  = 1'b1;
    else wren_div = 1'b0;
    if ((wrfunc_sel[6:2]==SQRT[6:2]) && wren) wren_sqrt = 1'b1;
    else wren_sqrt = 1'b0;
    if ((wrfunc_sel[6:2]==LOG[6:2]) && wren)  wren_log  = 1'b1;
    else wren_log = 1'b0;
    if ((wrfunc_sel[6:2]==EXP[6:2]) && wren)  wren_exp  = 1'b1;                                         
    else wren_exp = 1'b0;                                                                       
    if ((wrfunc_sel[6:2]==CONV[6:2]) && wren) wren_conv = 1'b1;                                         
    else wren_conv = 1'b0;                                                                       
    if ((wrfunc_sel[6:2]==FMA[6:2]) && wren)  wren_fma  = 1'b1;
    else wren_fma = 1'b0;   
    if ((wrfunc_sel[6:2]==SCAL[6:2]) && wren) wren_scal = 1'b1;                                         
    else wren_scal = 1'b0;                                                                       
    if ((wrfunc_sel[6:2]==LOGB[6:2]) && wren) wren_logb = 1'b1;                                         
    else wren_logb = 1'b0;                                                                       
    if ((wrfunc_sel[6:2]==RTOI[6:2]) && wren) wren_rtoi = 1'b1;                                         
    else wren_rtoi = 1'b0;                                                                        
    if ((wrfunc_sel[6:2]==REM[6:2]) && wren) wren_rem   = 1'b1;                                         
    else wren_rem = 1'b0;   
    if ((wrfunc_sel[6:2]==NEXT[6:2]) && wren) wren_next = 1'b1;                                         
    else wren_next = 1'b0;                                                                        
    if ((wrfunc_sel[6:2]==MINMAX[6:2]) && wren) wren_minmax  = 1'b1;                                         
    else wren_minmax = 1'b0;                                                                        
    if ((wrfunc_sel[6:2]==CNACS[6:2]) && wren) wren_cnacs  = 1'b1;                                         
    else wren_cnacs = 1'b0;  
    if ((wrfunc_sel[6:2]==POW[6:2]) && wren) wren_pow  = 1'b1;                                         
    else wren_pow = 1'b0;  
    
    if ((wrfunc_sel==SIN) && wren) wren_sin = 1'b1;                                         
    else wren_sin = 1'b0;    
    if ((wrfunc_sel==COS) && wren) wren_cos = 1'b1;                                         
    else wren_cos = 1'b0;    
    if ((wrfunc_sel==TAN) && wren) wren_tan = 1'b1;                                         
    else wren_tan = 1'b0;    
    if ((wrfunc_sel==COT) && wren) wren_cot = 1'b1;                                         
    else wren_cot = 1'b0;    
    if ((wrfunc_sel[6:2]==CNVFDCS[6:2]) && wren) wren_cnvfdcs = 1'b1;
    else wren_cnvfdcs = 1'b0;
    if ((wrfunc_sel[6:2]==CNVTDCS[6:2]) && wren) wren_cnvtdcs = 1'b1;
    else wren_cnvtdcs = 1'b0;
    if ((wrfunc_sel[6:2]==CNVFHCS[6:2]) && wren) wren_cnvfhcs = 1'b1;
    else wren_cnvfhcs = 1'b0;
    if ((wrfunc_sel[6:2]==CNVTHCS[6:2]) && wren) wren_cnvthcs = 1'b1;
    else wren_cnvthcs = 1'b0;
end


always @(*) begin
    if ((rdAfunc_sel[6:2]==FADD[6:2]) && rdenA) rdenA_add  = 1'b1;
    else rdenA_add = 1'b0;
    if ((rdAfunc_sel[6:2]==FSUB[6:2]) && rdenA) rdenA_sub  = 1'b1;                    
    else rdenA_sub = 1'b0;                                                  
    if ((rdAfunc_sel[6:2]==FMUL[6:2]) && rdenA) rdenA_mul  = 1'b1;                        
    else rdenA_mul = 1'b0; 
    if ((rdAfunc_sel[6:2]==FTOI[6:2]) && rdenA) rdenA_ftoi = 1'b1;                   
    else rdenA_ftoi = 1'b0;
    if ((rdAfunc_sel[6:2]==ITOF[6:2]) && rdenA) rdenA_itof = 1'b1;                   
    else rdenA_itof = 1'b0;                                                
    if ((rdAfunc_sel[6:2]==FDIV[6:2]) && rdenA) rdenA_div  = 1'b1;
    else rdenA_div = 1'b0;
    if ((rdAfunc_sel[6:2]==SQRT[6:2]) && rdenA) rdenA_sqrt = 1'b1;
    else rdenA_sqrt = 1'b0;
    if ((rdAfunc_sel[6:2]==LOG[6:2]) && rdenA) rdenA_log   = 1'b1;
    else rdenA_log = 1'b0;
    if ((rdAfunc_sel[6:2]==EXP[6:2]) && rdenA) rdenA_exp   = 1'b1;
    else rdenA_exp = 1'b0;
    if ((rdAfunc_sel[6:2]==CONV[6:2]) && rdenA) rdenA_conv = 1'b1;
    else rdenA_conv = 1'b0;
    if ((rdAfunc_sel[6:2]==FMA[6:2]) && rdenA) rdenA_fma   = 1'b1;
    else rdenA_fma = 1'b0;
    if ((rdAfunc_sel[6:2]==SCAL[6:2]) && rdenA) rdenA_scal = 1'b1;
    else rdenA_scal = 1'b0;
    if ((rdAfunc_sel[6:2]==LOGB[6:2]) && rdenA) rdenA_logb = 1'b1;
    else rdenA_logb = 1'b0;                                             
    if ((rdAfunc_sel[6:2]==RTOI[6:2]) && rdenA) rdenA_rtoi = 1'b1;
    else rdenA_rtoi = 1'b0;
    if ((rdAfunc_sel[6:2]==REM[6:2]) && rdenA) rdenA_rem   = 1'b1;
    else rdenA_rem = 1'b0;
    if ((rdAfunc_sel[6:2]==NEXT[6:2]) && rdenA) rdenA_next = 1'b1;
    else rdenA_next = 1'b0;
    if ((rdAfunc_sel[6:2]==MINMAX[6:2]) && rdenA) rdenA_minmax = 1'b1;
    else rdenA_minmax = 1'b0;
    if ((rdAfunc_sel[6:2]==CNACS[6:2]) && rdenA) rdenA_cnacs = 1'b1;
    else rdenA_cnacs = 1'b0;
    if ((rdAfunc_sel==SIN) && rdenA) rdenA_sin = 1'b1;
    else rdenA_sin = 1'b0;
    if ((rdAfunc_sel==COS) && rdenA) rdenA_cos = 1'b1;
    else rdenA_cos = 1'b0;
    if ((rdAfunc_sel==TAN) && rdenA) rdenA_tan = 1'b1;
    else rdenA_tan = 1'b0;
    if ((rdAfunc_sel==COT) && rdenA) rdenA_cot = 1'b1;
    else rdenA_cot = 1'b0;
    if ((rdAfunc_sel[6:2]==CNVFDCS[6:2]) && rdenA) rdenA_cnvfdcs = 1'b1;
    else rdenA_cnvfdcs = 1'b0;
    if ((rdAfunc_sel[6:2]==CNVTDCS[6:2]) && rdenA) rdenA_cnvtdcs = 1'b1;
    else rdenA_cnvtdcs = 1'b0;
    if ((rdAfunc_sel[6:2]==CNVFHCS[6:2]) && rdenA) rdenA_cnvfhcs = 1'b1;
    else rdenA_cnvfhcs = 1'b0;
    if ((rdAfunc_sel[6:2]==CNVTHCS[6:2]) && rdenA) rdenA_cnvthcs = 1'b1;
    else rdenA_cnvthcs = 1'b0;
    if ((rdAfunc_sel[6:2]==POW[6:2]) && rdenA) rdenA_pow = 1'b1;
    else rdenA_pow = 1'b0;
end    

always @(*) begin
    if ((rdBfunc_sel[6:2]==FADD[6:2]) && rdenB) rdenB_add = 1'b1;                    
    else rdenB_add = 1'b0;                                                 
    if ((rdBfunc_sel[6:2]==FSUB[6:2]) && rdenB) rdenB_sub = 1'b1;                    
    else rdenB_sub = 1'b0;                                                 
    if ((rdBfunc_sel[6:2]==FMUL[6:2]) && rdenB) rdenB_mul = 1'b1;                    
    else rdenB_mul = 1'b0;     
    if ((rdBfunc_sel[6:2]==ITOF[6:2]) && rdenB) rdenB_itof = 1'b1;                   
    else rdenB_itof = 1'b0;
    if ((rdBfunc_sel[6:2]==FTOI[6:2]) && rdenB) rdenB_ftoi = 1'b1;
    else rdenB_ftoi = 1'b0;
    if ((rdBfunc_sel[6:2]==FDIV[6:2]) && rdenB) rdenB_div = 1'b1;
    else rdenB_div = 1'b0;
    if ((rdBfunc_sel[6:2]==SQRT[6:2]) && rdenB) rdenB_sqrt = 1'b1;
    else rdenB_sqrt = 1'b0;
    if ((rdBfunc_sel[6:2]==LOG[6:2]) && rdenB) rdenB_log = 1'b1;
    else rdenB_log = 1'b0;
    if ((rdBfunc_sel[6:2]==EXP[6:2]) && rdenB) rdenB_exp = 1'b1;
    else rdenB_exp = 1'b0;
    if ((rdBfunc_sel[6:2]==CONV[6:2]) && rdenB) rdenB_conv = 1'b1;
    else rdenB_conv = 1'b0;
    if ((rdBfunc_sel[6:2]==FMA[6:2]) && rdenB) rdenB_fma = 1'b1;
    else rdenB_fma = 1'b0;
    if ((rdBfunc_sel[6:2]==SCAL[6:2]) && rdenB) rdenB_scal = 1'b1;                                                         
    else rdenB_scal = 1'b0;                                                                                               
    if ((rdBfunc_sel[6:2]==LOGB[6:2]) && rdenB) rdenB_logb = 1'b1;                                                         
    else rdenB_logb = 1'b0;
    if ((rdBfunc_sel[6:2]==RTOI[6:2]) && rdenB) rdenB_rtoi = 1'b1;                                                        
    else rdenB_rtoi = 1'b0;                                                                                                
    if ((rdBfunc_sel[6:2]==REM[6:2]) && rdenB) rdenB_rem = 1'b1;                                                          
    else rdenB_rem = 1'b0;                                                                                                 
    if ((rdBfunc_sel[6:2]==NEXT[6:2]) && rdenB) rdenB_next = 1'b1;                                                        
    else rdenB_next = 1'b0;                                                                                                
    if ((rdBfunc_sel[6:2]==MINMAX[6:2]) && rdenB) rdenB_minmax = 1'b1;                                                    
    else rdenB_minmax = 1'b0;                                                                                              
    if ((rdBfunc_sel[6:2]==CNACS[6:2]) && rdenB) rdenB_cnacs = 1'b1;
    else rdenB_cnacs = 1'b0;
    if ((rdBfunc_sel==SIN) && rdenB) rdenB_sin = 1'b1;
    else rdenB_sin = 1'b0;
    if ((rdBfunc_sel==COS) && rdenB) rdenB_cos = 1'b1;
    else rdenB_cos = 1'b0;
    if ((rdBfunc_sel==TAN) && rdenB) rdenB_tan = 1'b1;
    else rdenB_tan = 1'b0;
    if ((rdBfunc_sel==COT) && rdenB) rdenB_cot = 1'b1;
    else rdenB_cot = 1'b0;
    if ((rdBfunc_sel[6:2]==CNVFDCS[6:2]) && rdenB) rdenB_cnvfdcs = 1'b1;
    else rdenB_cnvfdcs = 1'b0;
    if ((rdBfunc_sel[6:2]==CNVTDCS[6:2]) && rdenB) rdenB_cnvtdcs = 1'b1;
    else rdenB_cnvtdcs = 1'b0;
    if ((rdBfunc_sel[6:2]==CNVFHCS[6:2]) && rdenB) rdenB_cnvfhcs = 1'b1;
    else rdenB_cnvfhcs = 1'b0;
    if ((rdBfunc_sel[6:2]==CNVTHCS[6:2]) && rdenB) rdenB_cnvthcs = 1'b1;
    else rdenB_cnvthcs = 1'b0;
    if ((rdBfunc_sel[6:2]==POW[6:2]) && rdenB) rdenB_pow = 1'b1;
    else rdenB_pow = 1'b0;
    
end    

endmodule
