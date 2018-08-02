 // CPU.v
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
 

`define PCWIDTH 20    //program counter width in bits
`define PSIZE 13      // (minimum of 13 = 64k bytes) program memory size in dwords 17-bit address = 128k x 64bit = 1M bytes of program memory
`define DSIZE 13      // indirect data memory size 16-bit address = 64k x 64bit = 512k bytes of byte-addressable triport data RAM 
`define RPTSIZE 16    // repeat counter size in bits
`define LPCNTRSIZE 16 // loop counter size in bits
`define DESIGN_ID 32'h0000_0012
`define CPU_HAS_DEBUG
`define CPU_HAS_FLOAT 
`define CPU_HAS_EXC_CAPTURE  // if you are not using alternate delayed exception handling, you probably should not define this

// ---- below are the largest of the floating point operators--if you will never use them and want to save resources
// ---- and increase clock rate as a result of reduced routing congestion, do not define them

`define CPU_HAS_FMA
`define CPU_HAS_TRIG
`define CPU_HAS_POWER
`define CPU_HAS_LOG
`define CPU_HAS_EXP
`define CPU_HAS_REMAINDER
`define CPU_HAS_DIVISION
`define CPU_HAS_SQRT
`define CPU_HAS_BIN_DEC_CHAR
`define CPU_HAS_DEC_CHAR_BIN
`define CPU_HAS_BIN_HEX_CHAR
`define CPU_HAS_HEX_CHAR_BIN


//:::::::::: these defines pertain to any XCU(s) included in the implementation ::::::::::::::::::::::::::

`define XPCWIDTH 20    // XCU program counter width in bits
`define XPSIZE 13      // XCU program memory size in dwords 12-bit address = 4k x 64bit = 32 kbytes
`define XDSIZE 13      // XCU indirect data memory size 12-bit address = 4k x 64bit = 32k bytes of byte-addressable triport data RAM per XCU
`define XCU_HAS_FLOAT 
`define XCU_HAS_EXC_CAPTURE  // if you are not using alternate delayed exception handling, you probably should not define this

// ---- below are the largest of the floating point operators--if you will never use them and want to save resources
// ---- and increase clock rate as a result of reduced routing congestion, do not define them

`define XCU_HAS_FMA
`define XCU_HAS_TRIG
//`define XCU_HAS_POWER
//`define XCU_HAS_LOG
//`define XCU_HAS_EXP
`define XCU_HAS_REMAINDER
`define XCU_HAS_DIVISION
`define XCU_HAS_SQRT
`define XCU_HAS_BIN_DEC_CHAR
//`define XCU_HAS_DEC_CHAR_BIN
//`define XCU_HAS_BIN_HEX_CHAR
//`define XCU_HAS_HEX_CHAR_BIN


module CPU (
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
   IRQ,

   XCU_CNTRL_REG,    
   XCU_STATUS_REG,    
   XCU_writeSel_q0,   //selects to which XCU a pushXCU will occur
   XCU_readSel_q0,    //selects to which XCU a pullXCU will occur
   XCU_monitorREADreq, 
   XCU_monitorWRITEreq,
   XCU_monitorWRITE_ALL_req,
   XCU_monitorRWaddrs_q0,
   XCU_monitorRWsize_q0,
   XCU_monitorREADdata_q1,  //comes from selected XCU rdSrcBdata  
   XCU_monitorWRITEdata_q1
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
output [63:0] XCU_CNTRL_REG ;                                     
input  [63:0] XCU_STATUS_REG;
output [3:0] XCU_writeSel_q0;
output [3:0] XCU_readSel_q0;
output XCU_monitorREADreq;   //q0
output XCU_monitorWRITEreq;  //q0
output XCU_monitorWRITE_ALL_req; //q0
output [31:0] XCU_monitorRWaddrs_q0;
output [1:0] XCU_monitorRWsize_q0;
input  [63:0] XCU_monitorREADdata_q1;
output [63:0] XCU_monitorWRITEdata_q1;

parameter     BRAL_ =  16'hFFF8;   // branch relative long
parameter     JMPA_ =  16'hFFA8;   // jump absolute long
parameter     BTBS_ =  16'hFFA0;   // bit test and branch if set
parameter     BTBC_ =  16'hFF98;   // bit test and branch if clear

parameter     BRAL_ADDRS = 32'h0000FFF8;   // branch relative long
parameter     JMPA_ADDRS = 32'h0000FFA8;   // jump absolute long
parameter     BTBS_ADDRS = 32'h0000FFA0;   // bit test and branch if set
parameter     BTBC_ADDRS = 32'h0000FF98;   // bit test and branch if clear

parameter  GLOB_RAM_ADDRS = 32'b0000_0000_0000_0001_0xxx_xxxx_xxxx_xxxx; //globabl RAM address (in bytes)
parameter        SP_ADDRS = 32'h0000FFE8;
parameter       AR6_ADDRS = 32'h0000FFE0;
parameter       AR5_ADDRS = 32'h0000FFD8;
parameter       AR4_ADDRS = 32'h0000FFD0;
parameter       AR3_ADDRS = 32'h0000FFC8;
parameter       AR2_ADDRS = 32'h0000FFC0;
parameter       AR1_ADDRS = 32'h0000FFB8;
parameter       AR0_ADDRS = 32'h0000FFB0;
parameter        PC_ADDRS = 32'h0000FFA8;
parameter   PC_COPY_ADDRS = 32'h0000FF90;
parameter        ST_ADDRS = 32'h0000FF88;
parameter    REPEAT_ADDRS = 32'h0000FF80;
parameter    LPCNT1_ADDRS = 32'h0000FF78;
parameter    LPCNT0_ADDRS = 32'h0000FF70;
parameter     TIMER_ADDRS = 32'h0000FF68;
parameter     CAPT3_ADDRS = 32'h0000FF58;
parameter     CAPT2_ADDRS = 32'h0000FF50;
parameter     CAPT1_ADDRS = 32'h0000FF48;
parameter     CAPT0_ADDRS = 32'h0000FF40;
parameter     CLASS_ADDRS = 32'h0000FF08;
parameter  SAVFLAGS_ADDRS = 32'h0000FF00;
parameter    RNDDIR_ADDRS = 32'h0000FE18;
parameter     RADIX_ADDRS = 32'h0000FE10;
parameter  SAVMODES_ADDRS = 32'h0000FE08;            //use direct addressing 

parameter       MON_ADDRS = 32'h0000FE00;
parameter     FLOAT_ADDRS = 32'b0000_0000_0000_0000_1110_xxxx_xxxx_xxxx;  //floating-point operator block
parameter    INTEGR_ADDRS = 32'b0000_0000_0000_0000_1101_xxxx_xxxx_xxxx;  // integer and logic operator block
parameter  PRIV_RAM_ADDRS = 32'b0000_0000_0000_0000_0xxx_xxxx_xxxx_xxxx;    //first 32k bytes (since data memory is byte-addressable and smallest RAM for this in Kintex 7 is 2k x 64 bits using two blocks next to each other
 
parameter  XCU_CNTRL_REG_ADDRS     =  16'hFDF8;
parameter  XCU_STATUS_REG_ADDRS    =  16'hFDF0;
parameter  XCU_MON_REQUEST_ADDRS   =  16'hFDEx;  //unique address for each target XCU
parameter  XCU_MON_POKE_ALL_ADDRS  =  16'hFDD8;  //one address for poking all XCUs simultaneously
                            
reg [`PCWIDTH-1:0] pc_q1;
reg [`PCWIDTH-1:0] pc_q2;

reg [63:0] wrsrcAdataSext;
reg [63:0] wrsrcBdataSext;
reg [63:0] wrsrcAdata;
reg [63:0] wrsrcBdata;

reg XCU_monitorREADreq_q1;

reg fp_ready_q2;
//reg fp_sel_q2;
//reg ready_integer_q2;
//reg integer_sel_q2;

reg [3:0]  STATE;
                                                                                           
reg [1:0]  RM_q1; 
reg [1:0]  Dam_q1; 
reg        Sext_Dest_q1;
reg [1:0]  Size_Dest_q1;  
reg        Ind_Dest_q1;
reg        Imod_Dest_q1; 
reg [15:0] OPdest_q1;
reg        Sext_SrcA_q1; 
reg [1:0]  Size_SrcA_q1;  
reg        Ind_SrcA_q1; 
//reg        Imod_SrcA_q1; 
reg [15:0] OPsrcA_q1; 
reg        Sext_SrcB_q1; 
reg  [1:0] Size_SrcB_q1;  
reg        Ind_SrcB_q1; 
//reg        Imod_SrcB_q1; 
reg [15:0] OPsrcB_q1; 
reg [31:0] OPsrc32_q1; 

//reg [1:0]   RM_q2; 
reg [1:0]  Dam_q2; 
reg        Sext_Dest_q2;
reg [1:0]  Size_Dest_q2;  
reg        Ind_Dest_q2;
reg        Imod_Dest_q2; 
reg [15:0] OPdest_q2;
reg        Sext_SrcA_q2; 
reg [1:0]  Size_SrcA_q2;  
reg        Ind_SrcA_q2; 
//reg        Imod_SrcA_q2; 
reg [15:0] OPsrcA_q2; 
reg        Sext_SrcB_q2; 
reg  [1:0] Size_SrcB_q2;  
reg        Ind_SrcB_q2; 
//reg        Imod_SrcB_q2; 
reg [15:0] OPsrcB_q2; 
reg [31:0] OPsrc32_q2;

reg [31:0] SrcA_addrs_q1;
reg [31:0] SrcB_addrs_q1;
//reg [31:0] SrcA_addrs_q2;
//reg [31:0] SrcB_addrs_q2;

reg RESET;
wire RESET_OUT;

reg C_q2;
reg V_q2;
reg N_q2;
reg Z_q2;
reg write_collision_os;
reg write_collision_os_q1;


wire HTDO;

wire break_q0;
wire break_q1;
wire break_q2;

wire [63:0] XCU_CNTRL_REG; 

wire [`PCWIDTH-1:0] pre_PC;

wire  [1:0] RM_q0;

wire [1:0] Dam_q0;
wire Ind_SrcA_q0;
wire Ind_SrcB_q0;
wire Ind_Dest_q0;
wire Imod_SrcA_q0;
wire Imod_SrcB_q0;
wire Imod_Dest_q0;
wire [1:0] Size_SrcA_q0;
wire [1:0] Size_SrcB_q0;
wire [1:0] Size_Dest_q0;
wire Sext_SrcA_q0;
wire Sext_SrcB_q0;
wire Sext_Dest_q0;
wire [31:0] OPsrc32_q0;
wire [15:0] OPsrcA_q0;
wire [15:0] OPsrcB_q0;
wire [15:0] OPdest_q0;

wire [3:0] sextA_sel;
wire [3:0] sextB_sel;

wire C_q1;
wire V_q1;
wire N_q1;
wire Z_q1;

wire fp_ready_q1;
wire fp_sel_q1;

wire [63:0] Instruction_q0;
wire [63:0] Instruction_q0_del;
wire [63:0] priv_RAM_rddataA;
wire [63:0] priv_RAM_rddataB;
wire [63:0] glob_RAM_rddataA;
wire [63:0] glob_RAM_rddataB;

wire [1:0] exc_codeA;
wire [1:0] exc_codeB;

wire int_in_service;

wire [`PCWIDTH-1:0] vector;

wire rdcycl;
wire wrcycl;

wire [63:0] float_rddataA;
wire [63:0] float_rddataB;                                                                                                           

wire [67:0] rddataA_integer;             
wire [67:0] rddataB_integer; 
wire ready_integer_q1;
wire integer_sel_q1;

wire [63:0] mon_write_reg;


wire write_collision;

wire [63:0] rdSrcAdata;
wire [63:0] core_rdSrcAdata;
wire [63:0] rdSrcBdata;
wire [63:0] core_rdSrcBdata;
wire [31:0] Dest_addrs_q2;
wire [31:0] Dest_addrs_q0;
wire [31:0] coreDest_addrs_q2;
wire [31:0] SrcA_addrs_q0;
wire [31:0] coreSrcA_addrs_q0;
wire [31:0] SrcB_addrs_q0;
wire [63:0] mon_read_reg;    
wire [`PCWIDTH-1:0] PC;
wire C;
wire V;
wire N;
wire Z;
wire IRQ;
wire done;
wire IRQ_IE;
wire RPT_not_z;
wire rewind_PC;
wire ld_vector;
wire discont;
wire RM_Attribute_on;
wire [1:0] RM;
wire Away;

wire statusRWcollision;
wire write_disable;      //from PC block
wire writeAbort;         //from FP exception capture

wire [31:0] mon_read_addrs; 
wire [31:0] mon_write_addrs;

wire XCU_monitorREADreq; 
wire XCU_monitorWRITEreq;
wire XCU_monitorWRITE_ALL_req;

wire ind_mon_read_q0; 
wire ind_mon_write_q2;


reg tableRead_q1;
wire tableRead_q0;
assign tableRead_q0 = SrcA_addrs_q0[31] || (Dam_q0[1:0]==2'b10);
wire tableWrite_q2;
assign tableWrite_q2 = wrcycl && Dest_addrs_q2[31];      
wire [63:0] tableReadData_q1;  


wire ext_read_q1;
wire [63:0] ext_rddata;
wire [63:0] ext_rddataq;
wire [63:0] DOUTq;
wire ext_write_q3;
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

wire [31:0] XCU_monitorRWaddrs_q0;
wire [1:0] XCU_monitorRWsize_q0;
wire [3:0] XCU_readSel_q0;
wire [3:0] XCU_writeSel_q0;


wire [63:0] XCU_monitorWRITEdata_q1;

assign ext_rddata = Sext_Dest_q1 ? {DQ[7:0], DQ[15:8], DQ[23:16], DQ[31:24], DQ[39:32], DQ[47:40], DQ[55:48], DQ[63:56]} : DQ;
assign DQ = ext_write_q3 ? DOUTq : 64'hz;


assign RM_q0[1:0] = RM_Attribute_on ? RM[1:0] : Instruction_q0_del[63:62];

assign rdSrcAdata = XCU_monitorREADreq_q1 ? XCU_monitorREADdata_q1 : (ext_read_q1 ? ext_rddataq : (tableRead_q1 ? tableReadData_q1 : core_rdSrcAdata));

assign rdSrcBdata = core_rdSrcBdata;
                                                               
assign XCU_monitorRWaddrs_q0 = SrcB_addrs_q0;
assign XCU_monitorRWsize_q0 = Size_SrcB_q0;
assign XCU_readSel_q0 = SrcA_addrs_q0[3:0];
assign XCU_writeSel_q0 = Dest_addrs_q0[3:0];

assign XCU_monitorWRITEdata_q1 = rdSrcAdata; //this is the actual data to be written to XCU during monitor write

assign Dest_addrs_q2 = ind_mon_write_q2 ? mon_write_addrs : coreDest_addrs_q2;
assign SrcA_addrs_q0 = ind_mon_read_q0 ? mon_read_addrs : coreSrcA_addrs_q0;

assign C_q1 = rddataA_integer[67];
assign V_q1 = rddataA_integer[66];
assign N_q1 = rddataA_integer[65];
assign Z_q1 = rddataA_integer[64];

assign sextA_sel = {Size_Dest_q2[1:0], Size_SrcA_q2[1:0]};       
assign sextB_sel = {Size_Dest_q2[1:0], Size_SrcB_q2[1:0]};

assign Dam_q0[1:0]       = Instruction_q0_del[61:60]; 
assign Sext_Dest_q0      = Instruction_q0_del[59];   
assign Size_Dest_q0[1:0] = Instruction_q0_del[58:57]; 
assign Ind_Dest_q0       = Instruction_q0_del[56]; 
assign Imod_Dest_q0      = Instruction_q0_del[55];   //borrows msb of destination operand
assign OPdest_q0[15:0]   = Instruction_q0_del[55:40]; 
assign Sext_SrcA_q0      = Instruction_q0_del[39]; 
assign Size_SrcA_q0[1:0] = Instruction_q0_del[38:37]; 
assign Ind_SrcA_q0       = Instruction_q0_del[36]; 
assign Imod_SrcA_q0      = Instruction_q0_del[35];   //borrows msb of SrcA operand
assign OPsrcA_q0[15:0]   = Instruction_q0_del[35:20];
assign Sext_SrcB_q0      = Instruction_q0_del[19]; 
assign Size_SrcB_q0[1:0] = Instruction_q0_del[18:17]; 
assign Ind_SrcB_q0       = Instruction_q0_del[16];   
assign Imod_SrcB_q0      = Instruction_q0_del[15];   //borrows msb of SrcB operand
assign OPsrcB_q0[15:0]   = Instruction_q0_del[15:0]; 
assign OPsrc32_q0[31:0]  = Instruction_q0_del[31:0]; 
     
assign fp_sel_q1 =      ((SrcA_addrs_q1[31:12]==20'h0000E) && ~Dam_q1[1]) || ((SrcB_addrs_q1[31:12]==20'h0000E) && ~Dam_q1[0]); 
assign integer_sel_q1 = ((SrcA_addrs_q1[31:12]==20'h0000D) && ~Dam_q1[1]) || ((SrcB_addrs_q1[31:12]==20'h0000D) && ~Dam_q1[0]);                                                                                

assign write_collision = ((SrcA_addrs_q1[31:0]==Dest_addrs_q2[31:0]) || (SrcB_addrs_q1[31:1]==Dest_addrs_q2[31:1]) || statusRWcollision) && ~write_collision_os && ~write_collision_os_q1 && ~break_q0 && ~break_q1 && wrcycl  && ~(Dam_q1[1:0]==2'b10) && ~SrcB_addrs_q1[31] && |Dest_addrs_q2[31:0];

assign rewind_PC = (~fp_ready_q1 || ~ready_integer_q1 || write_collision || ~ready_q1);
    
assign rdcycl = 1'b1;
assign wrcycl = (STATE[2] && ~write_disable && ~writeAbort) || break_q2;



`ifdef CPU_HAS_DEBUG 
       
debug debug(
       .CLK               (CLK               ),
       .RESET_IN          (RESET_IN          ),
       .RESET_OUT         (RESET_OUT         ),
       .HTCK              (HTCK              ),
       .HTRSTn            (HTRSTn            ),
       .HTMS              (HTMS              ),
       .HTDI              (HTDI              ),
       .HTDO              (HTDO              ),    
       .Instruction_q0    (Instruction_q0    ),
       .Instruction_q0_del(Instruction_q0_del),
       .pre_PC            (pre_PC            ),
       .PC                (PC                ),
       .pc_q2             (pc_q2             ),
       .discont           (discont           ),
       .break_q0          (break_q0          ),
       .break_q1          (break_q1          ),
       .break_q2          (break_q2          ),
       .ind_mon_read_q0   (ind_mon_read_q0   ),
       .ind_mon_write_q2  (ind_mon_write_q2  ),
       .mon_write_reg     (mon_write_reg     ),
       .mon_read_reg      (mon_read_reg      ),
       .mon_read_addrs    (mon_read_addrs    ),
       .mon_write_addrs   (mon_write_addrs   )
       ); 
`else
    assign Instruction_q0_del = Instruction_q0;
    assign debug_rddata = 64'b0;
    assign break_q0 = 1'b0;
    assign break_q1 = 1'b0;
    assign break_q2 = 1'b0;
    assign mon_write_reg = 64'b0;
    assign ind_mon_read_q0 = 1'b0; 
    assign ind_mon_write_q2 = 1'b0;
    assign mon_read_addrs = 32'b0; 
    assign mon_write_addrs = 32'b0;
    
    assign debug_wrdata  = 64'b0;
    assign debug_wren    = 1'b0;
    assign debug_wraddrs = 32'b0;
    assign debug_rden    = 1'b0;
    assign debug_rdaddrs = 32'b0;
    assign debug_rddata  = 64'b0;
    assign TDO = 1'bz;
    assign RESET = RESET_IN;
`endif

//external memory interface for 64-bit wide synchronous SRAM over bi-directional data bus
extMemIF extMemIF(
    .CLK           (CLK           ),
    .SrcA_addrs_q0 (SrcA_addrs_q0 ),
    .Dest_addrs_q2 (Dest_addrs_q2 ),
    .wrcycl        (wrcycl        ),
    .Sext_Dest_q2  (Sext_Dest_q2  ),
    .Size_Dest_q2  (Size_Dest_q2  ),
    .Size_SrcA_q0  (Size_SrcA_q0  ),
    .wrsrcAdataSext(wrsrcAdataSext),
    .ext_rddata    (ext_rddata    ),
    .ext_rddataq   (ext_rddataq   ),
    .DOUTq         (DOUTq         ),
    .ext_write_q3  (ext_write_q3  ),
    .ext_read_q1   (ext_read_q1   ),
    
    .CEN           (CEN           ),
    .CE123         (CE123         ),
    .WE            (WE            ),
    .BWh           (BWh           ),
    .BWg           (BWg           ),
    .BWf           (BWf           ),
    .BWe           (BWe           ),
    .BWd           (BWd           ),
    .BWc           (BWc           ),
    .BWb           (BWb           ),
    .BWa           (BWa           ),
    .adv_LD        (adv_LD        ),
    .A             (A             ),
    .OE            (OE            )
);                                


`ifdef CPU_HAS_FLOAT                       
    fpmath fpmath( 
      .RESET    (RESET),
      .CLK      (CLK ),
      .Dam_q1 (Dam_q1[1:0]),
      .OPsrcA_q1(OPsrcA_q1),
      .OPsrcB_q1(OPsrcB_q1),
      .OPsrc32_q1(OPsrc32_q1),
      .wren     (wrcycl && (Dest_addrs_q2[31:12]==20'h0000E)),  //float operator block select
      .wraddrs  (Dest_addrs_q2[11:3]),
      .Ind_SrcA_q1(Ind_SrcA_q1),
      .Sext_Dest_q2(Sext_Dest_q2),
      .Size_SrcA_q2(Size_SrcA_q2),
      .Size_SrcA_q1(Size_SrcA_q1),
      .Sext_SrcA_q1(Sext_SrcA_q1),
      .Sext_SrcA_q2(Sext_SrcA_q2),
      .rdSrcAdata (rdSrcAdata[63:0]),
      .Size_SrcB_q2(Size_SrcB_q2),
      .Size_SrcB_q1(Size_SrcB_q1),
      .Sext_SrcB_q1(Sext_SrcB_q1),
      .Sext_SrcB_q2(Sext_SrcB_q2),
      .rdSrcBdata (rdSrcBdata[63:0]),
      .rdenA    (~Dam_q0[1] && (SrcA_addrs_q0[31:12]==20'h0000E)),    //direct or indirect read
      .rdaddrsA (SrcA_addrs_q0[11:3]),
      .rddataA  (float_rddataA[63:0]),                                                                          
      .rdenB    (~Dam_q0[0] && (SrcB_addrs_q0[31:12]==20'h0000E)),                                             
      .rdaddrsB (SrcB_addrs_q0[11:3]),
      .rddataB  (float_rddataB[63:0]),
      .exc_codeA(exc_codeA ),         //exc codes are 2'b00 when FPmath is not being accessed
      .exc_codeB(exc_codeB ),
         
      .ready    (fp_ready_q1),
      
      .round_mode_q1(RM_q1    ),
      .Away (Away)
      );    
`else
    assign float_rddataA[63:0] = 64'b0;
    assign float_rddataB[63:0] = 64'b0;
    assign fp_ready_q1 = 1'b1;
    assign exc_codeA = 2'b00;
    assign exc_codeB = 2'b00;
`endif

core core (                                         
   .CLK            (CLK             ),                       
   .RESET          (RESET           ),                       
   .q1_sel         (STATE[1]        ),              
   .q2_sel         (STATE[2]        ),              
   .wrsrcAdata     (wrsrcAdata      ),                       
   .wrsrcBdata     (wrsrcBdata      ),                       
   .rdSrcAdata     (core_rdSrcAdata ),                       
   .rdSrcBdata     (core_rdSrcBdata ),                       
   .priv_RAM_rddataA (priv_RAM_rddataA[63:0]),                      
   .priv_RAM_rddataB (priv_RAM_rddataB[63:0]),                      
   .glob_RAM_rddataA (glob_RAM_rddataA[63:0]),                      
   .glob_RAM_rddataB (glob_RAM_rddataB[63:0]),                      
   .ld_vector      (ld_vector       ),
   .vector         (vector          ),                       
   .pre_PC         (pre_PC          ),                       
   .PC             (PC              ),                      
   .pc_q1          (pc_q1           ), 
   .pc_q2          (pc_q2           ), 
   .rewind_PC      (rewind_PC       ),                       
   .wrcycl         (wrcycl          ),                       
   .discont_out    (discont         ),                       
   .OPsrcA_q0      (OPsrcA_q0[15:0] ),
   .OPsrcA_q1      (OPsrcA_q1[15:0] ),
   .OPsrcA_q2      (OPsrcA_q2[15:0] ),                       
   .OPsrcB_q0      (OPsrcB_q0[15:0] ),                       
   .OPsrcB_q1      (OPsrcB_q1[15:0] ),                       
   .OPsrcB_q2      (OPsrcB_q2[15:0] ),                       
   .OPdest_q0      (OPdest_q0[15:0] ),                       
   .OPdest_q1      (OPdest_q1[15:0] ),                       
   .OPdest_q2      (OPdest_q2[15:0] ),                       
   .RPT_not_z      (RPT_not_z       ),                       
   .Dam_q0         (Dam_q0[1:0]     ),                       
   .Dam_q1         (Dam_q1[1:0]     ),                          
   .Dam_q2         (Dam_q2[1:0]     ),                       
   .Ind_Dest_q2    (Ind_Dest_q2     ),                       
   .Ind_Dest_q1    (Ind_Dest_q1     ),                       
   .Ind_SrcA_q0    (Ind_SrcA_q0     ),                       
   .Ind_SrcA_q2    (Ind_SrcA_q2     ),                       
   .Ind_SrcB_q0    (Ind_SrcB_q0     ),
   .Imod_Dest_q0   (Imod_Dest_q0    ),                       
   .Imod_Dest_q2   (Imod_Dest_q2    ),                       
   .Imod_SrcA_q0   (Imod_SrcA_q0    ),                       
   .Imod_SrcB_q0   (Imod_SrcB_q0    ),                       
   .Ind_SrcB_q2    (Ind_SrcB_q2     ),
   .Size_SrcA_q1   (Size_SrcA_q1    ),
   .Size_SrcB_q1   (Size_SrcB_q1    ),
   .Size_SrcA_q2   (Size_SrcA_q2    ),
   .Size_SrcB_q2   (Size_SrcB_q2    ),
   .Size_Dest_q2   (Size_Dest_q2    ),
   .Sext_SrcA_q2   (Sext_SrcA_q2    ),                      
   .Sext_SrcB_q2   (Sext_SrcB_q2    ),                      
   .Sext_Dest_q2   (Sext_Dest_q2    ),                      
   .OPsrc32_q0     (OPsrc32_q0[31:0]),                      
   .Ind_Dest_q0    (Ind_Dest_q0     ),                      
   .Dest_addrs_q2  (coreDest_addrs_q2),
   .Dest_addrs_q0  (Dest_addrs_q0    ),                
   .SrcA_addrs_q0  (coreSrcA_addrs_q0),                
   .SrcB_addrs_q0  (SrcB_addrs_q0   ),                
   .SrcA_addrs_q1  (SrcA_addrs_q1   ),                    
   .SrcB_addrs_q1  (SrcB_addrs_q1   ),                    
   .V_q2           (V_q2            ),                      
   .N_q2           (N_q2            ),                      
   .C_q2           (C_q2            ),                      
   .Z_q2           (Z_q2            ),                      
   .V              (V               ),                      
   .N              (N               ),                      
   .C              (C               ),                      
   .Z              (Z               ),                      
   .IRQ            (IRQ             ),                      
   .done           (done            ),                      
   .IRQ_IE         (IRQ_IE          ),                      
   .break_q0       (break_q0        ),                       
   .rddataA_integer(rddataA_integer[63:0]),                  
   .rddataB_integer(rddataB_integer[63:0]),                  
   .mon_write_reg  (mon_write_reg   ),  
   .mon_read_reg   (mon_read_reg    ),
   .ind_mon_read_q0 (ind_mon_read_q0),
   .ind_mon_write_q2(ind_mon_write_q2),                            
   .exc_codeA      (exc_codeA       ),                      
   .exc_codeB      (exc_codeB       ),                      
   .float_rddataA  (float_rddataA   ),
   .float_rddataB  (float_rddataB   ),
   .RM_q1          (RM_q1           ),                       
   .fp_ready_q1    (fp_ready_q1     ),                             
   .fp_ready_q2    (fp_ready_q2     ),                             
   .RM_Attribute_on(RM_Attribute_on),
   .Away           (Away            ),
   .RM_Attribute   (RM              ),       
   .int_in_service (int_in_service  ),
   .statusRWcollision(statusRWcollision),
   .writeAbort     (writeAbort      ),
   .write_disable  (write_disable   ),
   .XCU_CNTRL_REG  (XCU_CNTRL_REG   ),
   .XCU_STATUS_REG (XCU_STATUS_REG  ),
   .XCU_monitorREADreq (XCU_monitorREADreq), 
   .XCU_monitorWRITEreq(XCU_monitorWRITEreq),
   .XCU_monitorWRITE_ALL_req(XCU_monitorWRITE_ALL_req)
   );   
    
always @(posedge CLK) tableRead_q1 = tableRead_q0; 

CPUultraProgRAM #(.ADDRS_WIDTH(`PSIZE))       //dword addressable for program and table/constant storage
   PRAM0(      //program memory 
   .CLK       (CLK ),
   .wren      (tableWrite_q2 ),  
   .wraddrs   (Dest_addrs_q2[`PSIZE-1:0]),             //writes to program ram are dword in address increments of one
   .wrdata    (wrsrcAdataSext),
   .rdenA     (tableRead_q0),
   .rdaddrsA  (SrcA_addrs_q0[`PSIZE-1:0]),
   .rddataA   (tableReadData_q1),
   .rdenB     (rdcycl ),
   .rdaddrsB  (pre_PC[`PSIZE-1:0]),
   .rddataB   (Instruction_q0)
   ); 
    
    
triPortBlockRAM  #(.ADDRS_WIDTH(12))   
    ram0(            //(first 32k bytes) of directly or indirectly addressable memory
   .CLK       (CLK   ),
   .wren      (wrcycl && (Dest_addrs_q2[31:15]==16'b0)),
   .wrsize    (Size_Dest_q2),
   .wraddrs   (Dest_addrs_q2[14:0]),
   .wrdata    (wrsrcAdataSext),
   .rdenA     (SrcA_addrs_q0[31:15]==16'b0),
   .rdAsize   (Size_SrcA_q0),
   .rdaddrsA  (SrcA_addrs_q0[14:0]),
   .rddataA   (priv_RAM_rddataA[63:0]),
   .rdenB     (SrcB_addrs_q0[31:15]==16'b0),                                                       
   .rdBsize   (Size_SrcB_q0),
   .rdaddrsB  (SrcB_addrs_q0[14:0]),
   .rddataB   (priv_RAM_rddataB[63:0])
   );    
                                                                
triPortBlockRAM #(.ADDRS_WIDTH(`DSIZE))  
   ram1(      // indirectly addressable triport RAM
   .CLK       (CLK   ),
   .wren      (wrcycl && ~|Dest_addrs_q2[31:20] && |Dest_addrs_q2[19:16]),
   .wrsize    (Size_Dest_q2),
   .wraddrs   (Dest_addrs_q2[`DSIZE+2:0]),
   .wrdata    (wrsrcAdataSext),
   .rdenA     (~|SrcA_addrs_q0[31:20] && |SrcA_addrs_q0[19:16]),
   .rdAsize   (Size_SrcA_q0),
   .rdaddrsA  (SrcA_addrs_q0[`DSIZE+2:0]),
   .rddataA   (glob_RAM_rddataA[63:0]),
   .rdenB     (~|SrcB_addrs_q0[31:20] && |SrcB_addrs_q0[19:16]),
   .rdBsize   (Size_SrcB_q0),
   .rdaddrsB  (SrcB_addrs_q0[`DSIZE+2:0]),
   .rddataB   (glob_RAM_rddataB[63:0])
   );    
   
integr_logic integr_logic(
   .CLK         (CLK         ),
   .RESET       (RESET       ),
   .wren        (wrcycl && (Dest_addrs_q2[31:12]==20'h0000D)),    // A[15:12]==4'b1101 && wrcycl && ~Ind_Dest_q2
   .Sext_Dest_q2(Sext_Dest_q2),
   .Size_Dest_q1(Size_Dest_q1),
   .wraddrs     (Dest_addrs_q2[6:3]),    // A[11:7] is operator select, A[6:3] is result buffer select
   .operatr_q2  (Dest_addrs_q2[11:7]),   
   .oprndA      (wrsrcAdataSext[63:0]),
   .oprndB      (wrsrcBdataSext[63:0]),
   .C           (C           ),
   .V           (V           ),
   .N           (N           ),
   .Z           (Z           ),
   .rdenA       (~&Dam_q0[1:0] && (SrcA_addrs_q0[31:12]==20'h0000D)),
   .Sext_SrcA_q1(Sext_SrcA_q1),
   .Sext_SrcA_q2(Sext_SrcA_q2),
   .Size_SrcA_q1(Size_SrcA_q1),
   .rdaddrsA    (SrcA_addrs_q0[6:3]),    //A[11:7] is operator select, A[6:3] is result buffer select
   .operatrA_q0 (SrcA_addrs_q0[11:7]),
   .rddataA     (rddataA_integer),
   .rdenB       (~&Dam_q0[1:0] && (SrcB_addrs_q0[31:12]==20'h0000D)),
   .Sext_SrcB_q1(Sext_SrcB_q1),
   .Sext_SrcB_q2(Sext_SrcB_q2),
   .Size_SrcB_q1(Size_SrcB_q1),
   .rdaddrsB    (SrcB_addrs_q0[6:3]),    //A[11:7] is operator select, A[6:3] is result buffer select
   .operatrB_q0 (SrcB_addrs_q0[11:7]),
   .rddataB     (rddataB_integer),
   .ready_q1    (ready_integer_q1)
   );

always @(posedge CLK or posedge RESET)
    if (RESET) XCU_monitorREADreq_q1 <= 1'b0;
    else XCU_monitorREADreq_q1 <= XCU_monitorREADreq;


always @(*) begin
   if (Sext_SrcA_q2)
       casex (sextA_sel)
           4'b0100,
           4'b1000,
           4'b1100 :  if (wrsrcAdata[7]) wrsrcAdataSext[63:0] = {56'hFFFF_FFFF_FFFF_FF, wrsrcAdata[7:0]};
                      else wrsrcAdataSext[63:0] = wrsrcAdata[63:0];
           4'b1001,
           4'b1101 :  if (wrsrcAdata[15]) wrsrcAdataSext[63:0] = {48'hFFFF_FFFF_FFFF, wrsrcAdata[15:0]};
                      else wrsrcAdataSext[63:0] = wrsrcAdata[63:0];
                      
           4'b1110 :  if (wrsrcAdata[31]) wrsrcAdataSext[63:0] = {32'hFFFF_FFFF, wrsrcAdata[31:0]};
                      else wrsrcAdataSext[63:0] = wrsrcAdata[63:0];
            default: wrsrcAdataSext[63:0] = wrsrcAdata[63:0]; 
       endcase
    else  wrsrcAdataSext[63:0] = wrsrcAdata[63:0];
end                           

always @(*) begin
   if (Sext_SrcB_q2)
       casex (sextB_sel)
           4'b0100,
           4'b1000,
           4'b1100 :  if (wrsrcBdata[7]) wrsrcBdataSext[63:0] = {56'hFFFF_FFFF_FFFF_FF, wrsrcBdata[7:0]};
                      else wrsrcBdataSext[63:0] = wrsrcBdata[63:0];
           4'b1001,
           4'b1101 :  if (wrsrcBdata[15]) wrsrcBdataSext[63:0] = {48'hFFFF_FFFF_FFFF, wrsrcBdata[15:0]};
                      else wrsrcBdataSext[63:0] = wrsrcBdata[63:0];
                      
           4'b1110 :  if (wrsrcBdata[31]) wrsrcBdataSext[63:0] = {32'hFFFF_FFFF, wrsrcBdata[31:0]};
                      else wrsrcBdataSext[63:0] = wrsrcBdata[63:0];
            default: wrsrcBdataSext[63:0] = wrsrcBdata[63:0]; 
       endcase
    else  wrsrcBdataSext[63:0] = wrsrcBdata[63:0];
end     


always @(posedge CLK) RESET <= RESET_OUT;

always @(posedge CLK or posedge RESET) begin                                                                     
   if (RESET) begin                                                                                             
       // state 1 fetch                                                                                         
       pc_q1               <= `PCWIDTH'h100;                                                                               
       Dam_q1[1:0]         <= 2'b00;                         
       SrcA_addrs_q1       <= 32'b0;                                                                                
       SrcB_addrs_q1       <= 32'b0;                                                              
       OPdest_q1[15:0]     <= 16'h0000;                                                                        
       OPsrcA_q1[15:0]     <= 16'h0000;                                                                        
       OPsrcB_q1[15:0]     <= 16'h0000;                                                                        
       RM_q1[1:0]          <= 2'b00;  
       Sext_Dest_q1        <= 1'b0;
       Size_Dest_q1[1:0]   <= 2'b00;
       Ind_Dest_q1         <= 1'b0;
       Imod_Dest_q1        <= 1'b0;
       Sext_SrcA_q1        <= 1'b0;
       Size_SrcA_q1[1:0]   <= 2'b00;
       Ind_SrcA_q1         <= 1'b0; 
//       Imod_SrcA_q1        <= 1'b0;
       Sext_SrcB_q1        <= 1'b0;
       Size_SrcB_q1[1:0]   <= 2'b00;
       Ind_SrcB_q1         <= 1'b0; 
//       Imod_SrcB_q1        <= 1'b0; 
       OPsrc32_q1          <= 32'b0;                                                                                                              
                                                                                                                 
       // state2 read                                                                                             
       pc_q2               <= `PCWIDTH'h100;                                                                 
       Dam_q2[1:0]         <= 2'b00;           
//       SrcA_addrs_q2       <= 32'b0;                                                                         
//       SrcB_addrs_q2       <= 32'b0;                                                       
       OPdest_q2[15:0]     <= 16'h0000;                                                              
       OPsrcA_q2[15:0]     <= 16'h0000;                                                              
       OPsrcB_q2[15:0]     <= 16'h0000;                                                              
//       RM_q2[1:0]          <= 2'b00;  
       Sext_Dest_q2        <= 1'b0;
       Size_Dest_q2[1:0]   <= 2'b00;
       Ind_Dest_q2         <= 1'b0;
       Imod_Dest_q2        <= 1'b0;
       Sext_SrcA_q2        <= 1'b0;
       Size_SrcA_q2[1:0]   <= 2'b00;
       Ind_SrcA_q2         <= 1'b0; 
//       Imod_SrcA_q2        <= 1'b0;
       Sext_SrcB_q2        <= 1'b0;
       Size_SrcB_q2[1:0]   <= 2'b00;
       Ind_SrcB_q2         <= 1'b0; 
//       Imod_SrcB_q2        <= 1'b0;                                                                                                    
                                                                                                     
       STATE <= 4'b0000;                                                                               
                                                                                                       
       wrsrcAdata[63:0] <= 64'b0;
       wrsrcBdata[63:0] <= 64'b0;         
               
       fp_ready_q2 <= 1'b1;
//       fp_sel_q2 <= 1'b0;                                                  
//       ready_integer_q2 <= 1'b1;                         
//       integer_sel_q2 <= 1'b0;
       
                                                                                                                        
       SrcA_addrs_q1       <= 32'b0;
       SrcB_addrs_q1       <= 32'b0;
               
       C_q2 <= 1'b0;
       V_q2 <= 1'b0;
       N_q2 <= 1'b0;
       Z_q2 <= 1'b0;
              
       write_collision_os <= 1'b0;
       write_collision_os_q1 <= 1'b0;
   end                                                                                                          
   else begin                                                                                                   
       STATE <= {1'b1, STATE[3:1]};    //rotate right 1 into msb  (shift right)
       fp_ready_q2         <= fp_ready_q1         ;
 //      ready_integer_q2    <= ready_integer_q1    ;
       write_collision_os <= write_collision ;
       write_collision_os_q1 <= write_collision_os;
       
       if (SrcA_addrs_q1[31:12]==20'h0000D) begin
           C_q2 <= C_q1;
           V_q2 <= V_q1;
           N_q2 <= N_q1;
           Z_q2 <= Z_q1;
       end
    
          RM_q1[1:0]          <= RM_q0[1:0]          ;
          pc_q1               <= PC              ; 
          Dam_q1[1:0]         <= Dam_q0[1:0]         ;                 
          SrcA_addrs_q1       <= SrcA_addrs_q0       ; 
          SrcB_addrs_q1       <= SrcB_addrs_q0       ; 
          OPdest_q1           <= OPdest_q0           ;
          OPsrcA_q1           <= OPsrcA_q0           ;
          OPsrcB_q1           <= OPsrcB_q0           ;
          OPsrc32_q1          <= OPsrc32_q0;
          
//          fp_sel_q2           <= fp_sel_q1           ;
//          integer_sel_q2      <= integer_sel_q1      ;
          
          pc_q2               <= pc_q1               ;  
//          SrcA_addrs_q2       <= SrcA_addrs_q1       ; 
//          SrcB_addrs_q2       <= SrcB_addrs_q1       ; 
          OPdest_q2           <= OPdest_q1           ;
          OPsrcA_q2           <= OPsrcA_q1           ;
          OPsrcB_q2           <= OPsrcB_q1           ;
          
          Sext_Dest_q1        <= Sext_Dest_q0        ;
          Size_Dest_q1[1:0]   <= Size_Dest_q0[1:0]   ;
          Ind_Dest_q1         <= Ind_Dest_q0         ;
          Imod_Dest_q1        <= Imod_Dest_q0        ;
          Sext_SrcA_q1        <= Sext_SrcA_q0        ;
          Size_SrcA_q1[1:0]   <= Size_SrcA_q0[1:0]   ;
          Ind_SrcA_q1         <= Ind_SrcA_q0         ;
//          Imod_SrcA_q1        <= Imod_SrcA_q0        ;
          Sext_SrcB_q1        <= Sext_SrcB_q0        ;
          Size_SrcB_q1[1:0]   <= Size_SrcB_q0[1:0]   ;
          Ind_SrcB_q1         <= Ind_SrcB_q0         ;
//          Imod_SrcB_q1        <= Imod_SrcB_q0        ;
                                                     
          Sext_Dest_q2        <= Sext_Dest_q1        ;
          Size_Dest_q2[1:0]   <= Size_Dest_q1[1:0]   ;
          Ind_Dest_q2         <= Ind_Dest_q1         ;
          Imod_Dest_q2        <= Imod_Dest_q1        ;
          Sext_SrcA_q2        <= Sext_SrcA_q1        ;
          Size_SrcA_q2[1:0]   <= Size_SrcA_q1[1:0]   ;
          Ind_SrcA_q2         <= Ind_SrcA_q1         ;
//          Imod_SrcA_q2        <= Imod_SrcA_q1        ;
          Sext_SrcB_q2        <= Sext_SrcB_q1        ;
          Size_SrcB_q2[1:0]   <= Size_SrcB_q1[1:0]   ;
          Ind_SrcB_q2         <= Ind_SrcB_q1         ;
//          Imod_SrcB_q2        <= Imod_SrcB_q1        ;


          case(Dam_q1)     //MOV
              2'b00 : begin    // both srcA and srcB are either direct or indirect
                         wrsrcAdata <= rdSrcAdata;  //rdSrcA expects data here to be zero-extended to 64 bits           
                         wrsrcBdata <= rdSrcBdata;  //rdSrcB expects data here to be zero-extended to 64 bits
                      end
              2'b01 : begin   //srcA is direct or indirect and srcB is 8 or 16-bit immediate
                         if (~Ind_SrcA_q1 && ~|OPsrcA_q1) wrsrcAdata <= {48'h0000_0000_0000, OPsrcB_q1}; //rdSrcA expects data here to be zero-extended to 64 bits
                         else  wrsrcAdata <= rdSrcAdata;
                         wrsrcBdata <= {48'h0000_0000_0000, OPsrcB_q1};    //rdSrcB expects data here to be zero-extended to 64 bits
                      end
              2'b10 : begin  //srcA is table-read and srcB is direct or indirect 
                         wrsrcAdata <= rdSrcAdata;     //rdSrcA expects data here to be zero-extended to 64 bits        
                         wrsrcBdata <= rdSrcBdata;     //rdSrcB expects data here to be zero-extended to 64 bits
                      end
              2'b11 : begin //32-bit immediate       
                         wrsrcAdata <= {32'h0000_0000, OPsrc32_q1[31:0]};   //rdSrcA expects data here to be zero-extended to 64 bits
                      end
          endcase  
         
  end             
end

endmodule
