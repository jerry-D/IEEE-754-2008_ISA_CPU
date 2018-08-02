//CPU_HAS_4_XCUs.v

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
 

module CPU_HAS_4_XCUs (
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

                                                     
reg [3:0] XCU_readSel_q1;
reg [63:0] XCU_monitorREADdata_q1;


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

wire XCU0_forceReset;
wire XCU1_forceReset;
wire XCU2_forceReset;
wire XCU3_forceReset;

assign XCU0_forceReset  = XCU_CNTRL_REG[0];
assign XCU1_forceReset  = XCU_CNTRL_REG[1];
assign XCU2_forceReset  = XCU_CNTRL_REG[2];
assign XCU3_forceReset  = XCU_CNTRL_REG[3];

wire XCU0_forceBreak;
wire XCU1_forceBreak;
wire XCU2_forceBreak;
wire XCU3_forceBreak;

assign XCU0_forceBreak  = XCU_CNTRL_REG[16];
assign XCU1_forceBreak  = XCU_CNTRL_REG[17];
assign XCU2_forceBreak  = XCU_CNTRL_REG[18];
assign XCU3_forceBreak  = XCU_CNTRL_REG[19];

wire XCU0_sstep;
wire XCU1_sstep;
wire XCU2_sstep;
wire XCU3_sstep;

assign XCU0_sstep  = XCU_CNTRL_REG[32];
assign XCU1_sstep  = XCU_CNTRL_REG[33];
assign XCU2_sstep  = XCU_CNTRL_REG[34];
assign XCU3_sstep  = XCU_CNTRL_REG[35];

wire XCU0_monitorREADreq;
wire XCU1_monitorREADreq;
wire XCU2_monitorREADreq;
wire XCU3_monitorREADreq;

wire [3:0] XCU_readSel_q0;
wire [3:0] XCU_writeSel_q0;

assign XCU0_monitorREADreq  = XCU_monitorREADreq && (XCU_readSel_q0[3:0]==4'h0);
assign XCU1_monitorREADreq  = XCU_monitorREADreq && (XCU_readSel_q0[3:0]==4'h1);
assign XCU2_monitorREADreq  = XCU_monitorREADreq && (XCU_readSel_q0[3:0]==4'h2);
assign XCU3_monitorREADreq  = XCU_monitorREADreq && (XCU_readSel_q0[3:0]==4'h3);

wire XCU0_monitorWRITEreq;
wire XCU1_monitorWRITEreq;
wire XCU2_monitorWRITEreq;
wire XCU3_monitorWRITEreq;

assign XCU0_monitorWRITEreq  = (XCU_monitorWRITEreq && (XCU_writeSel_q0[3:0]==4'h0)) || XCU_monitorWRITE_ALL_req;
assign XCU1_monitorWRITEreq  = (XCU_monitorWRITEreq && (XCU_writeSel_q0[3:0]==4'h1)) || XCU_monitorWRITE_ALL_req;
assign XCU2_monitorWRITEreq  = (XCU_monitorWRITEreq && (XCU_writeSel_q0[3:0]==4'h2)) || XCU_monitorWRITE_ALL_req;
assign XCU3_monitorWRITEreq  = (XCU_monitorWRITEreq && (XCU_writeSel_q0[3:0]==4'h3)) || XCU_monitorWRITE_ALL_req;


wire XCU0_broke;
wire XCU1_broke;
wire XCU2_broke;
wire XCU3_broke;

wire XCU0_skip_cmplt;
wire XCU1_skip_cmplt;
wire XCU2_skip_cmplt;
wire XCU3_skip_cmplt;

wire XCU0_int_in_service;
wire XCU1_int_in_service;
wire XCU2_int_in_service;
wire XCU3_int_in_service;

wire XCU0_done;
wire XCU1_done;
wire XCU2_done;
wire XCU3_done;

wire XCU0_Preempt;
wire XCU1_Preempt;
wire XCU2_Preempt;
wire XCU3_Preempt;

assign XCU0_Preempt  = XCU_CNTRL_REG[48];
assign XCU1_Preempt  = XCU_CNTRL_REG[49];
assign XCU2_Preempt  = XCU_CNTRL_REG[50];
assign XCU3_Preempt  = XCU_CNTRL_REG[51];

wire XCU0_swbreakDetect;
wire XCU1_swbreakDetect;
wire XCU2_swbreakDetect;
wire XCU3_swbreakDetect;

assign XCU_STATUS_REG[63:0] = {1'b0, 
                               1'b0,
                               1'b0,
                               1'b0,
                               1'b0,
                               1'b0,
                               1'b0,
                               1'b0,
                               1'b0,
                               1'b0,
                               1'b0,
                               1'b0,
                               XCU3_done,
                               XCU2_done,
                               XCU1_done,
                               XCU0_done,
                               1'b0,
                               1'b0,
                               1'b0,
                               1'b0,
                               1'b0,
                               1'b0,
                               1'b0,
                               1'b0,
                               1'b0,
                               1'b0,
                               1'b0,
                               1'b0,
                               XCU3_swbreakDetect,
                               XCU2_swbreakDetect,
                               XCU1_swbreakDetect,
                               XCU0_swbreakDetect,
                               1'b0,
                               1'b0,
                               1'b0,
                               1'b0,
                               1'b0,
                               1'b0,
                               1'b0,
                               1'b0,
                               1'b0,
                               1'b0,                  
                               1'b0,                  
                               1'b0,
                               XCU3_broke,
                               XCU2_broke,
                               XCU1_broke,
                               XCU0_broke,
                               1'b0,
                               1'b0,
                               1'b0,
                               1'b0,
                               1'b0,
                               1'b0,
                               1'b0,
                               1'b0,
                               1'b0,
                               1'b0,                  
                               1'b0,                  
                               1'b0,
                               XCU3_int_in_service,
                               XCU2_int_in_service,
                               XCU1_int_in_service,
                               XCU0_int_in_service
                               };
                               

always @(posedge CLK) XCU_readSel_q1 <= XCU_readSel_q0;

always @(*)
    case(XCU_readSel_q1)
        4'h0 : XCU_monitorREADdata_q1 = XCU0_monitorREADdata_q1;
        4'h1 : XCU_monitorREADdata_q1 = XCU1_monitorREADdata_q1;
        4'h2 : XCU_monitorREADdata_q1 = XCU2_monitorREADdata_q1;
        4'h3 : XCU_monitorREADdata_q1 = XCU3_monitorREADdata_q1;
     default : XCU_monitorREADdata_q1 = 64'b0;   
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
   
   .int_in_service         (XCU0_int_in_service    ),
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
   
   .int_in_service         (XCU1_int_in_service    ),
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
   
   .int_in_service         (XCU2_int_in_service    ),
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
   
   .int_in_service         (XCU3_int_in_service    ),
   .IRQ                    (XCU3_Preempt           )         
   );


endmodule
