//CPU_HAS_16_XCUs.v

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
 

module CPU_HAS_16_XCUs (
   CLK,
   RESET_IN,

   HTCK,  
   HTRSTn,
   HTMS,  
   HTDI,  
   HTDO,  

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
   DQ,    
   OE,    
   
   ready_q1,
   done,                                                            
   IRQ
   );

input  CLK;
input  RESET_IN;
input  HTCK;  
input  HTRSTn;
input  HTMS;
input  HTDI;  
output HTDO;  

output done;
input IRQ;
input ready_q1;

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
inout  [63:0] DQ;                                                 
output OE;   

                                                     
reg [63:0] XCU_monitorREADdata_q1;
reg [3:0] XCU_readSel_q1;


wire HTDO;  

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
wire [63:0] DQ;                                                 
wire OE; 

wire done;  


wire [63:0] XCU_CNTRL_REG ;                                     
wire [63:0] XCU_STATUS_REG;
wire        XCU_monitorREADreq;       //q0
wire        XCU_monitorWRITEreq;      //q0
wire        XCU_monitorWRITE_ALL_req; //q0
wire [31:0] XCU_monitorRWaddrs_q0;
wire [1:0]  XCU_monitorRWsize_q0;
wire [63:0] XCU_monitorWRITEdata_q1;


wire [63:0] XCU0_monitorREADdata_q1;
wire [63:0] XCU1_monitorREADdata_q1;
wire [63:0] XCU2_monitorREADdata_q1;
wire [63:0] XCU3_monitorREADdata_q1;
wire [63:0] XCU4_monitorREADdata_q1;
wire [63:0] XCU5_monitorREADdata_q1;
wire [63:0] XCU6_monitorREADdata_q1;
wire [63:0] XCU7_monitorREADdata_q1;
wire [63:0] XCU8_monitorREADdata_q1;
wire [63:0] XCU9_monitorREADdata_q1;
wire [63:0] XCU10_monitorREADdata_q1;
wire [63:0] XCU11_monitorREADdata_q1;
wire [63:0] XCU12_monitorREADdata_q1;
wire [63:0] XCU13_monitorREADdata_q1;
wire [63:0] XCU14_monitorREADdata_q1;
wire [63:0] XCU15_monitorREADdata_q1;

wire XCU0_forceReset;
wire XCU1_forceReset;
wire XCU2_forceReset;
wire XCU3_forceReset;
wire XCU4_forceReset;
wire XCU5_forceReset;
wire XCU6_forceReset;
wire XCU7_forceReset;
wire XCU8_forceReset;
wire XCU9_forceReset;
wire XCU10_forceReset;
wire XCU11_forceReset;
wire XCU12_forceReset;
wire XCU13_forceReset;
wire XCU14_forceReset;
wire XCU15_forceReset;

assign XCU0_forceReset  = XCU_CNTRL_REG[0];
assign XCU1_forceReset  = XCU_CNTRL_REG[1];
assign XCU2_forceReset  = XCU_CNTRL_REG[2];
assign XCU3_forceReset  = XCU_CNTRL_REG[3];
assign XCU4_forceReset  = XCU_CNTRL_REG[4];
assign XCU5_forceReset  = XCU_CNTRL_REG[5];
assign XCU6_forceReset  = XCU_CNTRL_REG[6];
assign XCU7_forceReset  = XCU_CNTRL_REG[7];
assign XCU8_forceReset  = XCU_CNTRL_REG[8];
assign XCU9_forceReset  = XCU_CNTRL_REG[9];
assign XCU10_forceReset = XCU_CNTRL_REG[10];
assign XCU11_forceReset = XCU_CNTRL_REG[11];
assign XCU12_forceReset = XCU_CNTRL_REG[12];
assign XCU13_forceReset = XCU_CNTRL_REG[13];
assign XCU14_forceReset = XCU_CNTRL_REG[14];
assign XCU15_forceReset = XCU_CNTRL_REG[15];

wire XCU0_forceBreak;
wire XCU1_forceBreak;
wire XCU2_forceBreak;
wire XCU3_forceBreak;
wire XCU4_forceBreak;
wire XCU5_forceBreak;
wire XCU6_forceBreak;
wire XCU7_forceBreak;
wire XCU8_forceBreak;
wire XCU9_forceBreak;
wire XCU10_forceBreak;
wire XCU11_forceBreak;
wire XCU12_forceBreak;
wire XCU13_forceBreak;
wire XCU14_forceBreak;
wire XCU15_forceBreak;

assign XCU0_forceBreak  = XCU_CNTRL_REG[16];
assign XCU1_forceBreak  = XCU_CNTRL_REG[17];
assign XCU2_forceBreak  = XCU_CNTRL_REG[18];
assign XCU3_forceBreak  = XCU_CNTRL_REG[19];
assign XCU4_forceBreak  = XCU_CNTRL_REG[20];
assign XCU5_forceBreak  = XCU_CNTRL_REG[21];
assign XCU6_forceBreak  = XCU_CNTRL_REG[22];
assign XCU7_forceBreak  = XCU_CNTRL_REG[23];
assign XCU8_forceBreak  = XCU_CNTRL_REG[24];
assign XCU9_forceBreak  = XCU_CNTRL_REG[25];
assign XCU10_forceBreak = XCU_CNTRL_REG[26];
assign XCU11_forceBreak = XCU_CNTRL_REG[27];
assign XCU12_forceBreak = XCU_CNTRL_REG[28];
assign XCU13_forceBreak = XCU_CNTRL_REG[29];
assign XCU14_forceBreak = XCU_CNTRL_REG[30];
assign XCU15_forceBreak = XCU_CNTRL_REG[31];

wire XCU0_sstep;
wire XCU1_sstep;
wire XCU2_sstep;
wire XCU3_sstep;
wire XCU4_sstep;
wire XCU5_sstep;
wire XCU6_sstep;
wire XCU7_sstep;
wire XCU8_sstep;
wire XCU9_sstep;
wire XCU10_sstep;
wire XCU11_sstep;
wire XCU12_sstep;
wire XCU13_sstep;
wire XCU14_sstep;
wire XCU15_sstep;

assign XCU0_sstep  = XCU_CNTRL_REG[32];
assign XCU1_sstep  = XCU_CNTRL_REG[33];
assign XCU2_sstep  = XCU_CNTRL_REG[34];
assign XCU3_sstep  = XCU_CNTRL_REG[35];
assign XCU4_sstep  = XCU_CNTRL_REG[36];
assign XCU5_sstep  = XCU_CNTRL_REG[37];
assign XCU6_sstep  = XCU_CNTRL_REG[38];
assign XCU7_sstep  = XCU_CNTRL_REG[39];
assign XCU8_sstep  = XCU_CNTRL_REG[40];
assign XCU9_sstep  = XCU_CNTRL_REG[41];
assign XCU10_sstep = XCU_CNTRL_REG[42];
assign XCU11_sstep = XCU_CNTRL_REG[43];
assign XCU12_sstep = XCU_CNTRL_REG[44];
assign XCU13_sstep = XCU_CNTRL_REG[45];
assign XCU14_sstep = XCU_CNTRL_REG[46];
assign XCU15_sstep = XCU_CNTRL_REG[47];

wire XCU0_monitorREADreq;
wire XCU1_monitorREADreq;
wire XCU2_monitorREADreq;
wire XCU3_monitorREADreq;
wire XCU4_monitorREADreq;
wire XCU5_monitorREADreq;
wire XCU6_monitorREADreq;
wire XCU7_monitorREADreq;
wire XCU8_monitorREADreq;
wire XCU9_monitorREADreq;
wire XCU10_monitorREADreq;                       
wire XCU11_monitorREADreq;
wire XCU12_monitorREADreq;
wire XCU13_monitorREADreq;
wire XCU14_monitorREADreq;
wire XCU15_monitorREADreq;

wire [3:0] XCU_readSel_q0;
wire [3:0] XCU_writeSel_q0;

assign XCU0_monitorREADreq  = XCU_monitorREADreq && (XCU_readSel_q0[3:0]==4'h0);
assign XCU1_monitorREADreq  = XCU_monitorREADreq && (XCU_readSel_q0[3:0]==4'h1);
assign XCU2_monitorREADreq  = XCU_monitorREADreq && (XCU_readSel_q0[3:0]==4'h2);
assign XCU3_monitorREADreq  = XCU_monitorREADreq && (XCU_readSel_q0[3:0]==4'h3);
assign XCU4_monitorREADreq  = XCU_monitorREADreq && (XCU_readSel_q0[3:0]==4'h4);
assign XCU5_monitorREADreq  = XCU_monitorREADreq && (XCU_readSel_q0[3:0]==4'h5);
assign XCU6_monitorREADreq  = XCU_monitorREADreq && (XCU_readSel_q0[3:0]==4'h6);
assign XCU7_monitorREADreq  = XCU_monitorREADreq && (XCU_readSel_q0[3:0]==4'h7);
assign XCU8_monitorREADreq  = XCU_monitorREADreq && (XCU_readSel_q0[3:0]==4'h8);
assign XCU9_monitorREADreq  = XCU_monitorREADreq && (XCU_readSel_q0[3:0]==4'h9);
assign XCU10_monitorREADreq = XCU_monitorREADreq && (XCU_readSel_q0[3:0]==4'hA);
assign XCU11_monitorREADreq = XCU_monitorREADreq && (XCU_readSel_q0[3:0]==4'hB);
assign XCU12_monitorREADreq = XCU_monitorREADreq && (XCU_readSel_q0[3:0]==4'hC);
assign XCU13_monitorREADreq = XCU_monitorREADreq && (XCU_readSel_q0[3:0]==4'hD);
assign XCU14_monitorREADreq = XCU_monitorREADreq && (XCU_readSel_q0[3:0]==4'hE);
assign XCU15_monitorREADreq = XCU_monitorREADreq && (XCU_readSel_q0[3:0]==4'hF);

wire XCU0_monitorWRITEreq;
wire XCU1_monitorWRITEreq;
wire XCU2_monitorWRITEreq;
wire XCU3_monitorWRITEreq;
wire XCU4_monitorWRITEreq;
wire XCU5_monitorWRITEreq;
wire XCU6_monitorWRITEreq;
wire XCU7_monitorWRITEreq;
wire XCU8_monitorWRITEreq;
wire XCU9_monitorWRITEreq;
wire XCU10_monitorWRITEreq;
wire XCU11_monitorWRITEreq;
wire XCU12_monitorWRITEreq;
wire XCU13_monitorWRITEreq;                          
wire XCU14_monitorWRITEreq;                            
wire XCU15_monitorWRITEreq;

assign XCU0_monitorWRITEreq  = (XCU_monitorWRITEreq && (XCU_writeSel_q0[3:0]==4'h0)) || XCU_monitorWRITE_ALL_req;
assign XCU1_monitorWRITEreq  = (XCU_monitorWRITEreq && (XCU_writeSel_q0[3:0]==4'h1)) || XCU_monitorWRITE_ALL_req;
assign XCU2_monitorWRITEreq  = (XCU_monitorWRITEreq && (XCU_writeSel_q0[3:0]==4'h2)) || XCU_monitorWRITE_ALL_req;
assign XCU3_monitorWRITEreq  = (XCU_monitorWRITEreq && (XCU_writeSel_q0[3:0]==4'h3)) || XCU_monitorWRITE_ALL_req;
assign XCU4_monitorWRITEreq  = (XCU_monitorWRITEreq && (XCU_writeSel_q0[3:0]==4'h4)) || XCU_monitorWRITE_ALL_req;
assign XCU5_monitorWRITEreq  = (XCU_monitorWRITEreq && (XCU_writeSel_q0[3:0]==4'h5)) || XCU_monitorWRITE_ALL_req;
assign XCU6_monitorWRITEreq  = (XCU_monitorWRITEreq && (XCU_writeSel_q0[3:0]==4'h6)) || XCU_monitorWRITE_ALL_req;
assign XCU7_monitorWRITEreq  = (XCU_monitorWRITEreq && (XCU_writeSel_q0[3:0]==4'h7)) || XCU_monitorWRITE_ALL_req;
assign XCU8_monitorWRITEreq  = (XCU_monitorWRITEreq && (XCU_writeSel_q0[3:0]==4'h8)) || XCU_monitorWRITE_ALL_req;
assign XCU9_monitorWRITEreq  = (XCU_monitorWRITEreq && (XCU_writeSel_q0[3:0]==4'h9)) || XCU_monitorWRITE_ALL_req;
assign XCU10_monitorWRITEreq = (XCU_monitorWRITEreq && (XCU_writeSel_q0[3:0]==4'hA)) || XCU_monitorWRITE_ALL_req;
assign XCU11_monitorWRITEreq = (XCU_monitorWRITEreq && (XCU_writeSel_q0[3:0]==4'hB)) || XCU_monitorWRITE_ALL_req;
assign XCU12_monitorWRITEreq = (XCU_monitorWRITEreq && (XCU_writeSel_q0[3:0]==4'hC)) || XCU_monitorWRITE_ALL_req;
assign XCU13_monitorWRITEreq = (XCU_monitorWRITEreq && (XCU_writeSel_q0[3:0]==4'hD)) || XCU_monitorWRITE_ALL_req;
assign XCU14_monitorWRITEreq = (XCU_monitorWRITEreq && (XCU_writeSel_q0[3:0]==4'hE)) || XCU_monitorWRITE_ALL_req;
assign XCU15_monitorWRITEreq = (XCU_monitorWRITEreq && (XCU_writeSel_q0[3:0]==4'hF)) || XCU_monitorWRITE_ALL_req;


wire XCU0_broke;
wire XCU1_broke;
wire XCU2_broke;
wire XCU3_broke;
wire XCU4_broke;
wire XCU5_broke;
wire XCU6_broke;
wire XCU7_broke;
wire XCU8_broke;
wire XCU9_broke;
wire XCU10_broke;
wire XCU11_broke;
wire XCU12_broke;
wire XCU13_broke;
wire XCU14_broke;
wire XCU15_broke;

wire XCU0_skip_cmplt;
wire XCU1_skip_cmplt;
wire XCU2_skip_cmplt;
wire XCU3_skip_cmplt;
wire XCU4_skip_cmplt;
wire XCU5_skip_cmplt;
wire XCU6_skip_cmplt;
wire XCU7_skip_cmplt;
wire XCU8_skip_cmplt;
wire XCU9_skip_cmplt;
wire XCU10_skip_cmplt;
wire XCU11_skip_cmplt;
wire XCU12_skip_cmplt;
wire XCU13_skip_cmplt;
wire XCU14_skip_cmplt;
wire XCU15_skip_cmplt;

wire XCU0_done;
wire XCU1_done;
wire XCU2_done;
wire XCU3_done;
wire XCU4_done;
wire XCU5_done;
wire XCU6_done;
wire XCU7_done;
wire XCU8_done;
wire XCU9_done;
wire XCU10_done;
wire XCU11_done;
wire XCU12_done;
wire XCU13_done;
wire XCU14_done;
wire XCU15_done;

wire XCU0_Preempt;
wire XCU1_Preempt;
wire XCU2_Preempt;
wire XCU3_Preempt;
wire XCU4_Preempt;
wire XCU5_Preempt;
wire XCU6_Preempt;
wire XCU7_Preempt;
wire XCU8_Preempt;
wire XCU9_Preempt;
wire XCU10_Preempt;
wire XCU11_Preempt;
wire XCU12_Preempt;
wire XCU13_Preempt;
wire XCU14_Preempt;
wire XCU15_Preempt;

assign XCU0_Preempt  = XCU_CNTRL_REG[48];
assign XCU1_Preempt  = XCU_CNTRL_REG[49];
assign XCU2_Preempt  = XCU_CNTRL_REG[50];
assign XCU3_Preempt  = XCU_CNTRL_REG[51];
assign XCU4_Preempt  = XCU_CNTRL_REG[52];
assign XCU5_Preempt  = XCU_CNTRL_REG[53];
assign XCU6_Preempt  = XCU_CNTRL_REG[54];
assign XCU7_Preempt  = XCU_CNTRL_REG[55];
assign XCU8_Preempt  = XCU_CNTRL_REG[56];
assign XCU9_Preempt  = XCU_CNTRL_REG[57];
assign XCU10_Preempt = XCU_CNTRL_REG[58];
assign XCU11_Preempt = XCU_CNTRL_REG[59];
assign XCU12_Preempt = XCU_CNTRL_REG[60];
assign XCU13_Preempt = XCU_CNTRL_REG[61];
assign XCU14_Preempt = XCU_CNTRL_REG[62];
assign XCU15_Preempt = XCU_CNTRL_REG[63];

wire XCU0_swbreakDetect;
wire XCU1_swbreakDetect;
wire XCU2_swbreakDetect;
wire XCU3_swbreakDetect;
wire XCU4_swbreakDetect;
wire XCU5_swbreakDetect;
wire XCU6_swbreakDetect;
wire XCU7_swbreakDetect;
wire XCU8_swbreakDetect;
wire XCU9_swbreakDetect;
wire XCU10_swbreakDetect;
wire XCU11_swbreakDetect;
wire XCU12_swbreakDetect;
wire XCU13_swbreakDetect;
wire XCU14_swbreakDetect;
wire XCU15_swbreakDetect;

assign XCU_STATUS_REG[63:0] = {XCU15_done, 
                               XCU14_done,
                               XCU13_done,
                               XCU12_done,
                               XCU11_done,
                               XCU10_done,
                               XCU9_done,
                               XCU8_done,
                               XCU7_done,
                               XCU6_done,
                               XCU5_done,
                               XCU4_done,
                               XCU3_done,
                               XCU2_done,
                               XCU1_done,
                               XCU0_done,
                               XCU15_swbreakDetect,
                               XCU14_swbreakDetect,
                               XCU13_swbreakDetect,
                               XCU12_swbreakDetect,
                               XCU11_swbreakDetect,
                               XCU10_swbreakDetect,
                               XCU9_swbreakDetect,
                               XCU8_swbreakDetect,
                               XCU7_swbreakDetect,
                               XCU6_swbreakDetect,
                               XCU5_swbreakDetect,
                               XCU4_swbreakDetect,
                               XCU3_swbreakDetect,
                               XCU2_swbreakDetect,
                               XCU1_swbreakDetect,
                               XCU0_swbreakDetect,
                               XCU15_broke,
                               XCU14_broke,
                               XCU13_broke,
                               XCU12_broke,
                               XCU11_broke,
                               XCU10_broke,
                               XCU9_broke,
                               XCU8_broke,
                               XCU7_broke,
                               XCU6_broke,                  
                               XCU5_broke,                  
                               XCU4_broke,
                               XCU3_broke,
                               XCU2_broke,
                               XCU1_broke,
                               XCU0_broke,
                               XCU15_skip_cmplt,
                               XCU14_skip_cmplt,
                               XCU13_skip_cmplt,
                               XCU12_skip_cmplt,
                               XCU11_skip_cmplt,
                               XCU10_skip_cmplt,
                               XCU9_skip_cmplt,
                               XCU8_skip_cmplt,
                               XCU7_skip_cmplt,
                               XCU6_skip_cmplt,                  
                               XCU5_skip_cmplt,                  
                               XCU4_skip_cmplt,
                               XCU3_skip_cmplt,
                               XCU2_skip_cmplt,
                               XCU1_skip_cmplt,
                               XCU0_skip_cmplt
                               };
                               

always @(posedge CLK) XCU_readSel_q1 <= XCU_readSel_q0;

always @(*)
    case(XCU_readSel_q1)
        4'h0 : XCU_monitorREADdata_q1 = XCU0_monitorREADdata_q1;
        4'h1 : XCU_monitorREADdata_q1 = XCU1_monitorREADdata_q1;
        4'h2 : XCU_monitorREADdata_q1 = XCU2_monitorREADdata_q1;
        4'h3 : XCU_monitorREADdata_q1 = XCU3_monitorREADdata_q1;
        4'h4 : XCU_monitorREADdata_q1 = XCU4_monitorREADdata_q1;
        4'h5 : XCU_monitorREADdata_q1 = XCU5_monitorREADdata_q1;
        4'h6 : XCU_monitorREADdata_q1 = XCU6_monitorREADdata_q1;
        4'h7 : XCU_monitorREADdata_q1 = XCU7_monitorREADdata_q1;
        4'h8 : XCU_monitorREADdata_q1 = XCU8_monitorREADdata_q1;
        4'h9 : XCU_monitorREADdata_q1 = XCU9_monitorREADdata_q1;
        4'hA : XCU_monitorREADdata_q1 = XCU10_monitorREADdata_q1;
        4'hB : XCU_monitorREADdata_q1 = XCU11_monitorREADdata_q1;
        4'hC : XCU_monitorREADdata_q1 = XCU12_monitorREADdata_q1;
        4'hD : XCU_monitorREADdata_q1 = XCU13_monitorREADdata_q1;
        4'hE : XCU_monitorREADdata_q1 = XCU14_monitorREADdata_q1;
        4'hF : XCU_monitorREADdata_q1 = XCU15_monitorREADdata_q1;
    endcase                       
                           
        
                               
CPU CPU(
    .CLK   (CLK    ),
    .RESET_IN(RESET_IN),
    .HTCK  (HTCK   ),
    .HTRSTn(HTRSTn ),
    .HTMS  (HTMS   ),
    .HTDI  (HTDI   ),
    .HTDO  (HTDO   ),

    .CEN   (CEN   ),
    .CE123 (CE123 ),
    .WE    (WE    ),
    .BWh   (BWh   ),
    .BWg   (BWg   ),
    .BWf   (BWf   ),
    .BWe   (BWe   ),
    .BWd   (BWd   ),
    .BWc   (BWc   ),
    .BWb   (BWb   ),
    .BWa   (BWa   ),
    .adv_LD(adv_LD),
    .A     (A     ),
    .DQ    (DQ    ),                
    .OE    (OE    ),
                      
    .ready_q1(ready_q1),    
    .done  (done  ),
    .IRQ   (IRQ   ),
    
    .XCU_CNTRL_REG           (XCU_CNTRL_REG           ), //preEmptReq_SSTEP_forceBreak_forceReset
    .XCU_STATUS_REG          (XCU_STATUS_REG          ), //{XCU_DONE[15:0], XCU_SWBRKDET[15:0], XCU_BROKE[15:0], XCU_SKIPCMPLT[15:0]}
    .XCU_readSel_q0          (XCU_readSel_q0          ),
    .XCU_writeSel_q0         (XCU_writeSel_q0         ),
    .XCU_monitorREADreq      (XCU_monitorREADreq      ),
    .XCU_monitorWRITEreq     (XCU_monitorWRITEreq     ),
    .XCU_monitorWRITE_ALL_req(XCU_monitorWRITE_ALL_req),
    .XCU_monitorRWaddrs_q0   (XCU_monitorRWaddrs_q0   ),
    .XCU_monitorRWsize_q0    (XCU_monitorRWsize_q0    ),
    .XCU_monitorREADdata_q1  (XCU_monitorREADdata_q1  ),   //comes from selected XCU rdSrcBdata  
    .XCU_monitorWRITEdata_q1 (XCU_monitorWRITEdata_q1 )                                                     
    );


XCU XCU_0(
   .CLK                    (CLK                    ),
   .RESET_IN               (XCU0_forceReset || RESET_IN),
   
   .swbreakDetect          (XCU0_swbreakDetect     ),                                                
   .forceBreak             (XCU0_forceBreak        ),     
   .sstep                  (XCU0_sstep             ),     
   
   .XCU_monitorREADreq     (XCU0_monitorREADreq    ), 
   .XCU_monitorWRITEreq    (XCU0_monitorWRITEreq   ), 
   .XCU_monitorRWaddrs_q0  (XCU_monitorRWaddrs_q0  ),
   .XCU_monitorRWsize_q0   (XCU_monitorRWsize_q0   ),
   .XCU_monitorREADdata_q1 (XCU0_monitorREADdata_q1),   //comes from selected XCU rdSrcBdata  
   .XCU_monitorWRITEdata_q1(XCU_monitorWRITEdata_q1),   //goes to selected XCU wrSrcAdata
   
   .broke                  (XCU0_broke             ),     
   .skip_cmplt             (XCU0_skip_cmplt        ),     
   
   .ready_q1               (1'b1                   ),

   .done                   (XCU0_done              ),                                              
   
   .IRQ                    (XCU0_Preempt           )         
   );


XCU XCU_1(
   .CLK                    (CLK                    ),
   .RESET_IN               (XCU1_forceReset || RESET_IN),
                                                   
   .swbreakDetect          (XCU1_swbreakDetect     ),                                                
   .forceBreak             (XCU1_forceBreak        ),     
   .sstep                  (XCU1_sstep             ),     
   
   .XCU_monitorREADreq     (XCU1_monitorREADreq    ), 
   .XCU_monitorWRITEreq    (XCU1_monitorWRITEreq   ), 
   .XCU_monitorRWaddrs_q0  (XCU_monitorRWaddrs_q0  ),
   .XCU_monitorRWsize_q0   (XCU_monitorRWsize_q0   ),
   .XCU_monitorREADdata_q1 (XCU1_monitorREADdata_q1),    
   .XCU_monitorWRITEdata_q1(XCU_monitorWRITEdata_q1),  
   
   .broke                  (XCU1_broke             ),     
   .skip_cmplt             (XCU1_skip_cmplt        ),     
   
   .ready_q1               (1'b1                   ),

   .done                   (XCU1_done              ),                                              
   
   .IRQ                    (XCU1_Preempt           )         
   );


XCU XCU_2(
   .CLK                    (CLK                    ),
   .RESET_IN               (XCU2_forceReset || RESET_IN),
                                                   
   .swbreakDetect          (XCU2_swbreakDetect     ),                                                
   .forceBreak             (XCU2_forceBreak        ),     
   .sstep                  (XCU2_sstep             ),     
   
   .XCU_monitorREADreq     (XCU2_monitorREADreq    ), 
   .XCU_monitorWRITEreq    (XCU2_monitorWRITEreq   ), 
   .XCU_monitorRWaddrs_q0  (XCU_monitorRWaddrs_q0  ),
   .XCU_monitorRWsize_q0   (XCU_monitorRWsize_q0   ),
   .XCU_monitorREADdata_q1 (XCU2_monitorREADdata_q1),    
   .XCU_monitorWRITEdata_q1(XCU_monitorWRITEdata_q1),  
   
   .broke                  (XCU2_broke             ),     
   .skip_cmplt             (XCU2_skip_cmplt        ),     
   
   .ready_q1               (1'b1                   ),

   .done                   (XCU2_done              ),                                              
   
   .IRQ                    (XCU2_Preempt           )         
   );

XCU XCU_3(
   .CLK                    (CLK                    ),
   .RESET_IN               (XCU3_forceReset || RESET_IN),
                                                   
   .swbreakDetect          (XCU3_swbreakDetect     ),                                                
   .forceBreak             (XCU3_forceBreak        ),     
   .sstep                  (XCU3_sstep             ),     
   
   .XCU_monitorREADreq     (XCU3_monitorREADreq    ), 
   .XCU_monitorWRITEreq    (XCU3_monitorWRITEreq   ), 
   .XCU_monitorRWaddrs_q0  (XCU_monitorRWaddrs_q0  ),
   .XCU_monitorRWsize_q0   (XCU_monitorRWsize_q0   ),
   .XCU_monitorREADdata_q1 (XCU3_monitorREADdata_q1),    
   .XCU_monitorWRITEdata_q1(XCU_monitorWRITEdata_q1),  
   
   .broke                  (XCU3_broke             ),     
   .skip_cmplt             (XCU3_skip_cmplt        ),     
   
   .ready_q1               (1'b1                   ),

   .done                   (XCU3_done              ),                                              
   
   .IRQ                    (XCU3_Preempt           )         
   );

XCU XCU_4(
   .CLK                    (CLK                    ),
   .RESET_IN               (XCU4_forceReset || RESET_IN),
                                                   
   .swbreakDetect          (XCU4_swbreakDetect     ),                                                
   .forceBreak             (XCU4_forceBreak        ),     
   .sstep                  (XCU4_sstep             ),     
   
   .XCU_monitorREADreq     (XCU4_monitorREADreq    ), 
   .XCU_monitorWRITEreq    (XCU4_monitorWRITEreq   ), 
   .XCU_monitorRWaddrs_q0  (XCU_monitorRWaddrs_q0  ),
   .XCU_monitorRWsize_q0   (XCU_monitorRWsize_q0   ),
   .XCU_monitorREADdata_q1 (XCU4_monitorREADdata_q1),    
   .XCU_monitorWRITEdata_q1(XCU_monitorWRITEdata_q1),  
   
   .broke                  (XCU4_broke             ),     
   .skip_cmplt             (XCU4_skip_cmplt        ),     
   
   .ready_q1               (1'b1                   ),

   .done                   (XCU4_done              ),                                              
   
   .IRQ                    (XCU4_Preempt           )         
   );

XCU XCU_5(
   .CLK                    (CLK                    ),
   .RESET_IN               (XCU5_forceReset || RESET_IN),
                                                   
   .swbreakDetect          (XCU5_swbreakDetect     ),                                                
   .forceBreak             (XCU5_forceBreak        ),     
   .sstep                  (XCU5_sstep             ),     
   
   .XCU_monitorREADreq     (XCU5_monitorREADreq    ), 
   .XCU_monitorWRITEreq    (XCU5_monitorWRITEreq   ), 
   .XCU_monitorRWaddrs_q0  (XCU_monitorRWaddrs_q0  ),
   .XCU_monitorRWsize_q0   (XCU_monitorRWsize_q0   ),
   .XCU_monitorREADdata_q1 (XCU5_monitorREADdata_q1),    
   .XCU_monitorWRITEdata_q1(XCU_monitorWRITEdata_q1),  
   
   .broke                  (XCU5_broke             ),     
   .skip_cmplt             (XCU5_skip_cmplt        ),     
   
   .ready_q1               (1'b1                   ),

   .done                   (XCU5_done              ),                                              
   
   .IRQ                    (XCU5_Preempt           )         
   );
   

XCU XCU_6(
   .CLK                    (CLK                    ),
   .RESET_IN               (XCU6_forceReset || RESET_IN),
                                                   
   .swbreakDetect          (XCU6_swbreakDetect     ),                                                
   .forceBreak             (XCU6_forceBreak        ),     
   .sstep                  (XCU6_sstep             ),     
   
   .XCU_monitorREADreq     (XCU6_monitorREADreq    ), 
   .XCU_monitorWRITEreq    (XCU6_monitorWRITEreq   ), 
   .XCU_monitorRWaddrs_q0  (XCU_monitorRWaddrs_q0  ),
   .XCU_monitorRWsize_q0   (XCU_monitorRWsize_q0   ),
   .XCU_monitorREADdata_q1 (XCU6_monitorREADdata_q1),    
   .XCU_monitorWRITEdata_q1(XCU_monitorWRITEdata_q1),  
   
   .broke                  (XCU6_broke             ),     
   .skip_cmplt             (XCU6_skip_cmplt        ),     
   
   .ready_q1               (1'b1                   ),

   .done                   (XCU6_done              ),                                              
   
   .IRQ                    (XCU6_Preempt           )         
   );


XCU XCU_7(
   .CLK                    (CLK                    ),
   .RESET_IN               (XCU7_forceReset || RESET_IN),
                                                   
   .swbreakDetect          (XCU7_swbreakDetect     ),                                                
   .forceBreak             (XCU7_forceBreak        ),     
   .sstep                  (XCU7_sstep             ),     
   
   .XCU_monitorREADreq     (XCU7_monitorREADreq    ), 
   .XCU_monitorWRITEreq    (XCU7_monitorWRITEreq   ), 
   .XCU_monitorRWaddrs_q0  (XCU_monitorRWaddrs_q0  ),
   .XCU_monitorRWsize_q0   (XCU_monitorRWsize_q0   ),
   .XCU_monitorREADdata_q1 (XCU7_monitorREADdata_q1),    
   .XCU_monitorWRITEdata_q1(XCU_monitorWRITEdata_q1),  
   
   .broke                  (XCU7_broke             ),     
   .skip_cmplt             (XCU7_skip_cmplt        ),     
   
   .ready_q1               (1'b1                   ),

   .done                   (XCU7_done              ),                                              
   
   .IRQ                    (XCU7_Preempt           )         
   );


XCU XCU_8(
   .CLK                    (CLK                    ),
   .RESET_IN               (XCU8_forceReset || RESET_IN),
                                                   
   .swbreakDetect          (XCU8_swbreakDetect     ),                                                
   .forceBreak             (XCU8_forceBreak        ),     
   .sstep                  (XCU8_sstep             ),     
   
   .XCU_monitorREADreq     (XCU8_monitorREADreq    ), 
   .XCU_monitorWRITEreq    (XCU8_monitorWRITEreq   ), 
   .XCU_monitorRWaddrs_q0  (XCU_monitorRWaddrs_q0  ),
   .XCU_monitorRWsize_q0   (XCU_monitorRWsize_q0   ),
   .XCU_monitorREADdata_q1 (XCU8_monitorREADdata_q1),    
   .XCU_monitorWRITEdata_q1(XCU_monitorWRITEdata_q1),  
   
   .broke                  (XCU8_broke             ),     
   .skip_cmplt             (XCU8_skip_cmplt        ),     
   
   .ready_q1               (1'b1                   ),

   .done                   (XCU8_done              ),                                              
   
   .IRQ                    (XCU8_Preempt           )         
   );
   
   
XCU XCU_9(
   .CLK                    (CLK                    ),
   .RESET_IN               (XCU9_forceReset || RESET_IN),
                                                   
   .swbreakDetect          (XCU9_swbreakDetect     ),                                                
   .forceBreak             (XCU9_forceBreak        ),     
   .sstep                  (XCU9_sstep             ),     
   
   .XCU_monitorREADreq     (XCU9_monitorREADreq    ), 
   .XCU_monitorWRITEreq    (XCU9_monitorWRITEreq   ), 
   .XCU_monitorRWaddrs_q0  (XCU_monitorRWaddrs_q0  ),
   .XCU_monitorRWsize_q0   (XCU_monitorRWsize_q0   ),
   .XCU_monitorREADdata_q1 (XCU9_monitorREADdata_q1),    
   .XCU_monitorWRITEdata_q1(XCU_monitorWRITEdata_q1),  
   
   .broke                  (XCU9_broke             ),     
   .skip_cmplt             (XCU9_skip_cmplt        ),     
   
   .ready_q1               (1'b1                   ),

   .done                   (XCU9_done              ),                                              
   
   .IRQ                    (XCU9_Preempt           )         
   );
   

XCU XCU_10(
   .CLK                    (CLK                    ),
   .RESET_IN               (XCU10_forceReset || RESET_IN),
                                                   
   .swbreakDetect          (XCU10_swbreakDetect     ),                                                
   .forceBreak             (XCU10_forceBreak        ),     
   .sstep                  (XCU10_sstep             ),     
   
   .XCU_monitorREADreq     (XCU10_monitorREADreq    ), 
   .XCU_monitorWRITEreq    (XCU10_monitorWRITEreq   ), 
   .XCU_monitorRWaddrs_q0  (XCU_monitorRWaddrs_q0  ),
   .XCU_monitorRWsize_q0   (XCU_monitorRWsize_q0   ),
   .XCU_monitorREADdata_q1 (XCU10_monitorREADdata_q1),    
   .XCU_monitorWRITEdata_q1(XCU_monitorWRITEdata_q1),  
   
   .broke                  (XCU10_broke             ),     
   .skip_cmplt             (XCU10_skip_cmplt        ),     
   
   .ready_q1               (1'b1                   ),

   .done                   (XCU10_done              ),                                              
   
   .IRQ                    (XCU10_Preempt           )         
   );
   
   
XCU XCU_11(
   .CLK                    (CLK                    ),
   .RESET_IN               (XCU11_forceReset || RESET_IN),
                                                   
   .swbreakDetect          (XCU11_swbreakDetect     ),                                                
   .forceBreak             (XCU11_forceBreak        ),     
   .sstep                  (XCU11_sstep             ),     
   
   .XCU_monitorREADreq     (XCU11_monitorREADreq    ), 
   .XCU_monitorWRITEreq    (XCU11_monitorWRITEreq   ), 
   .XCU_monitorRWaddrs_q0  (XCU_monitorRWaddrs_q0  ),
   .XCU_monitorRWsize_q0   (XCU_monitorRWsize_q0   ),
   .XCU_monitorREADdata_q1 (XCU11_monitorREADdata_q1),    
   .XCU_monitorWRITEdata_q1(XCU_monitorWRITEdata_q1),  
   
   .broke                  (XCU11_broke             ),     
   .skip_cmplt             (XCU11_skip_cmplt        ),     
   
   .ready_q1               (1'b1                   ),

   .done                   (XCU11_done              ),                                              
   
   .IRQ                    (XCU11_Preempt           )         
   );
   

XCU XCU_12(
   .CLK                    (CLK                    ),
   .RESET_IN               (XCU12_forceReset || RESET_IN),
                                                   
   .swbreakDetect          (XCU12_swbreakDetect     ),                                                
   .forceBreak             (XCU12_forceBreak        ),     
   .sstep                  (XCU12_sstep             ),     
   
   .XCU_monitorREADreq     (XCU12_monitorREADreq    ), 
   .XCU_monitorWRITEreq    (XCU12_monitorWRITEreq   ), 
   .XCU_monitorRWaddrs_q0  (XCU_monitorRWaddrs_q0  ),
   .XCU_monitorRWsize_q0   (XCU_monitorRWsize_q0   ),
   .XCU_monitorREADdata_q1 (XCU12_monitorREADdata_q1),    
   .XCU_monitorWRITEdata_q1(XCU_monitorWRITEdata_q1),  
   
   .broke                  (XCU12_broke             ),     
   .skip_cmplt             (XCU12_skip_cmplt        ),     
   
   .ready_q1               (1'b1                   ),

   .done                   (XCU12_done              ),                                              
   
   .IRQ                    (XCU12_Preempt           )         
   );
   
XCU XCU_13(
   .CLK                    (CLK                    ),
   .RESET_IN               (XCU13_forceReset || RESET_IN),
                                                   
   .swbreakDetect          (XCU13_swbreakDetect     ),                                                
   .forceBreak             (XCU13_forceBreak        ),     
   .sstep                  (XCU13_sstep             ),     
   
   .XCU_monitorREADreq     (XCU13_monitorREADreq    ), 
   .XCU_monitorWRITEreq    (XCU13_monitorWRITEreq   ), 
   .XCU_monitorRWaddrs_q0  (XCU_monitorRWaddrs_q0  ),
   .XCU_monitorRWsize_q0   (XCU_monitorRWsize_q0   ),
   .XCU_monitorREADdata_q1 (XCU13_monitorREADdata_q1),    
   .XCU_monitorWRITEdata_q1(XCU_monitorWRITEdata_q1),  
   
   .broke                  (XCU13_broke             ),     
   .skip_cmplt             (XCU13_skip_cmplt        ),     
   
   .ready_q1               (1'b1                   ),

   .done                   (XCU13_done              ),                                              
   
   .IRQ                    (XCU13_Preempt           )         
   );
   

XCU XCU_14(
   .CLK                    (CLK                    ),
   .RESET_IN               (XCU14_forceReset || RESET_IN),
                                                   
   .swbreakDetect          (XCU14_swbreakDetect     ),                                                
   .forceBreak             (XCU14_forceBreak        ),     
   .sstep                  (XCU14_sstep             ),     
   
   .XCU_monitorREADreq     (XCU14_monitorREADreq    ), 
   .XCU_monitorWRITEreq    (XCU14_monitorWRITEreq   ), 
   .XCU_monitorRWaddrs_q0  (XCU_monitorRWaddrs_q0  ),
   .XCU_monitorRWsize_q0   (XCU_monitorRWsize_q0   ),
   .XCU_monitorREADdata_q1 (XCU14_monitorREADdata_q1),    
   .XCU_monitorWRITEdata_q1(XCU_monitorWRITEdata_q1),  
   
   .broke                  (XCU14_broke             ),     
   .skip_cmplt             (XCU14_skip_cmplt        ),     
   
   .ready_q1               (1'b1                   ),

   .done                   (XCU14_done              ),                                              
   
   .IRQ                    (XCU14_Preempt           )         
   );
   
XCU XCU_15(
   .CLK                    (CLK                    ),
   .RESET_IN               (XCU15_forceReset || RESET_IN),
                                                   
   .swbreakDetect          (XCU15_swbreakDetect     ),                                                
   .forceBreak             (XCU15_forceBreak        ),     
   .sstep                  (XCU15_sstep             ),     
   
   .XCU_monitorREADreq     (XCU15_monitorREADreq    ), 
   .XCU_monitorWRITEreq    (XCU15_monitorWRITEreq   ), 
   .XCU_monitorRWaddrs_q0  (XCU_monitorRWaddrs_q0  ),
   .XCU_monitorRWsize_q0   (XCU_monitorRWsize_q0   ),
   .XCU_monitorREADdata_q1 (XCU15_monitorREADdata_q1),    
   .XCU_monitorWRITEdata_q1(XCU_monitorWRITEdata_q1),  
   
   .broke                  (XCU15_broke             ),     
   .skip_cmplt             (XCU15_skip_cmplt        ),     
   
   .ready_q1               (1'b1                   ),

   .done                   (XCU15_done              ),                                              
   
   .IRQ                    (XCU15_Preempt           )         
   );
   

endmodule
