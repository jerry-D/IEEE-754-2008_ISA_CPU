//debug.v

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

module debug (
    CLK,
    RESET_IN,
    RESET_OUT,
    
    HTCK  ,
    HTRSTn,
    HTMS  ,
    HTDI  ,
    HTDO  ,
    
    Instruction_q0,
    Instruction_q0_del,
    pre_PC,
    PC,     
    pc_q2,      
    discont,
    break_q0,
    break_q1,
    break_q2,
    ind_mon_read_q0,
    ind_mon_write_q2,
    mon_write_reg,                 //pre-registered data to be written during monitor write
    mon_read_reg,                  //data captured during monitor read
    mon_read_addrs,                //monitor read-from address
    mon_write_addrs                //monitor write-to address
    );
    
input         CLK;
input         RESET_IN;
output        RESET_OUT;

input  HTCK;
input  HTRSTn;
input  HTMS;
input  HTDI;
output HTDO;

input  [63:0] Instruction_q0;
output [63:0] Instruction_q0_del;
input  [`PCWIDTH-1:0] pre_PC;
input  [`PCWIDTH-1:0] PC;   
input  [`PCWIDTH-1:0] pc_q2;    
input         discont;
output        break_q0;
output        break_q1;
output        break_q2;
output        ind_mon_read_q0; 
output        ind_mon_write_q2;
output [63:0] mon_write_reg;
input  [63:0] mon_read_reg;

output [31:0] mon_read_addrs; 
output [31:0] mon_write_addrs;
              
parameter mon_read_addrs_addrs  = 8'h20;
parameter mon_write_addrs_addrs = 8'h21;
parameter mon_write_reg_addrs   = 8'h22; 
parameter mon_read_reg_addrs    = 8'h23;
parameter evnt_cntr_addrs       = 8'h24;   
parameter trigger_A_addrs       = 8'h25;
parameter trigger_B_addrs       = 8'h26;
parameter brk_cntrl_addrs       = 8'h27;
parameter brk_status_addrs      = 8'h28;
parameter sstep_addrs           = 8'h29;  
parameter trace_newest_addrs    = 8'h30;
parameter trace_1_addrs         = 8'h31;
parameter trace_2_addrs         = 8'h32;
parameter trace_oldest_addrs    = 8'h33;
parameter bypass                = 8'hFF;

parameter SWBREAK = 64'h14FFA04FF887C000;



reg [31:0] evnt_cntr;

reg [`PCWIDTH-1:0] trigger_A;
reg [`PCWIDTH-1:0] trigger_B;

reg [63:0] rddata;

reg [31:0] mon_read_addrs;    
reg [31:0] mon_write_addrs;   
reg [1:0]  mon_read_size;
reg [1:0]  mon_write_size;
reg [63:0] mon_write_reg;

reg [63:0]    SHIFT_REG;

reg PC_EQ_BRKA_en;
reg PC_EQ_BRKB_en;
reg PC_GT_BRKA_en;
reg PC_LT_BRKB_en;
reg PC_AND_en;   
reg mon_req;   
reg sstep;     
reg frc_brk;  
reg FORCE_RESET; 


wire  [63:0] Instruction_q0_del;

wire  break_q0;                                                                   
wire  break_q1;                                                                   
wire  break_q2;                                                                   
                                                                                  
wire  broke;                                                                  
                                                                                  
wire  skip_cmplt;                                                             

wire  event_det;

wire [63:0] trace_newest;
wire [63:0] trace_1;
wire [63:0] trace_2;
wire [63:0] trace_oldest;


wire ind_mon_read_q0; 
wire ind_mon_write_q2;

wire swbreakDetect;

wire [63:0] brk_status_reg;
assign brk_status_reg = {`DESIGN_ID, 26'b0, skip_cmplt, swbreakDetect, broke, frc_brk, RESET_IN, FORCE_RESET};
assign swbreakDetect = (Instruction_q0==SWBREAK);


wire          UTDI_;
wire          UDRCAP_;
wire          UDRCK_;
wire          UDRSH_;
wire          UDRUPD_;
wire          URSTB_;
wire [7:0]    UIREG_;


wire          URST_;
wire          RESET_OUT;


assign        URST_        = ~URSTB_;
assign        RESET_OUT = RESET_IN || FORCE_RESET;

   

breakpoints breakpoints(                                                                                   
    .CLK           (CLK          ),                                                               
    .RESET         (RESET_OUT || URST_),                                                               
    .Instruction_q0(Instruction_q0),                                                               
    .Instruction_q0_del(Instruction_q0_del),                                                               
    .pre_PC        (pre_PC       ),                                                               
                                           
    .PC_EQ_BRKA_en (PC_EQ_BRKA_en),
    .PC_EQ_BRKB_en (PC_EQ_BRKB_en),
    .PC_GT_BRKA_en (PC_GT_BRKA_en),
    .PC_LT_BRKB_en (PC_LT_BRKB_en),
    .PC_AND_en     (PC_AND_en    ),
        
    .event_det     (event_det    ),
    
    .evnt_cntr     (evnt_cntr    ),

    .trigger_A     (trigger_A    ),
    .trigger_B     (trigger_B    ),
    
    .sstep         (sstep        ),
    .frc_brk       (frc_brk      ),                                     
    .broke         (broke        ),                                     
    .skip_cmplt    (skip_cmplt   ),                                     
    .break_q0      (break_q0     ),
    .break_q1      (break_q1     ),
    .break_q2      (break_q2     ),
    .ind_mon_read_q0 (ind_mon_read_q0), 
    .ind_mon_write_q2(ind_mon_write_q2),
    .mon_read_addrs (mon_read_addrs),   
    .mon_write_addrs(mon_write_addrs),
    .mon_read_size (mon_read_size),
    .mon_write_size(mon_write_size),
    .mon_req       (mon_req      )
    );                 

trace_buf trace_buf(
    .CLK       (CLK         ),
    .RESET     (RESET_OUT || URST_),
    .discont   (discont     ),
    .PC        (PC          ),
    .pc_q2     (pc_q2       ),
    .trace_reg0(trace_newest),
    .trace_reg1(trace_1     ),
    .trace_reg2(trace_2     ),
    .trace_reg3(trace_oldest)
    );  
          
    
always @(posedge UDRCK_ or posedge URST_) begin
    if (URST_) begin
        SHIFT_REG       <= 64'b0;
        mon_read_addrs  <= 32'b0;   //two MSBs are size bits, i.e., byte, hw, w, dw 
        mon_read_size   <= 2'b0;                                                               
        mon_write_addrs <= 32'b0;                                                                   
        mon_write_size  <= 2'b0;                                                               
        mon_write_reg   <= 64'b0; 
        evnt_cntr       <= 32'h0000_0001;
        trigger_A       <= `PCWIDTH'b0;
        trigger_B       <= `PCWIDTH'b0;
        PC_EQ_BRKA_en   <= 1'b0;
        PC_EQ_BRKB_en   <= 1'b0;
        PC_GT_BRKA_en   <= 1'b0;
        PC_LT_BRKB_en   <= 1'b0;
        PC_AND_en       <= 1'b0;
        mon_req         <= 1'b0;
        sstep           <= 1'b0;
        frc_brk         <= 1'b0;
        FORCE_RESET     <= 1'b0;
    end

    else begin

        if (UDRCAP_ && ~UDRSH_) begin  //data register capture
            case (UIREG_)
                mon_read_addrs_addrs  : SHIFT_REG <= {30'b0, mon_read_size, mon_read_addrs};
                mon_write_addrs_addrs : SHIFT_REG <= {30'b0, mon_write_size, mon_write_addrs};
                mon_write_reg_addrs   : SHIFT_REG <= mon_write_reg;    //data to be written during monitor write cycle
                mon_read_reg_addrs    : SHIFT_REG <= mon_read_reg;      //data captured during monitor read cycle
                evnt_cntr_addrs       : SHIFT_REG <= {32'b0, evnt_cntr};
                trigger_A_addrs       : SHIFT_REG <= {64-`PCWIDTH'b0, trigger_A};
                trigger_B_addrs       : SHIFT_REG <= {64-`PCWIDTH'b0, trigger_B};
                brk_cntrl_addrs       : SHIFT_REG <= {55'b0, 
                                                      PC_EQ_BRKA_en, 
                                                      PC_EQ_BRKB_en, 
                                                      PC_GT_BRKA_en, 
                                                      PC_LT_BRKB_en, 
                                                      PC_AND_en, 
                                                      mon_req,
                                                      sstep  ,
                                                      frc_brk, 
                                                      FORCE_RESET};
                brk_status_addrs      : SHIFT_REG <= brk_status_reg;
                sstep_addrs           : SHIFT_REG <= 64'h600DFEED600DFEED;
                trace_newest_addrs    : SHIFT_REG <= trace_newest;
                trace_1_addrs         : SHIFT_REG <= trace_1;     
                trace_2_addrs         : SHIFT_REG <= trace_2;     
                trace_oldest_addrs    : SHIFT_REG <= trace_oldest;
                bypass                : SHIFT_REG <= 64'hFFFF_FFFF_FFFF_FFFF;
                              default : SHIFT_REG <= 64'hBADFEED0BADFEED0;
            endcase 
        end
		else if (UDRSH_ && (UIREG_==bypass)) SHIFT_REG[0] <= UTDI_;
        else if (UDRSH_ ) SHIFT_REG <= {UTDI_, SHIFT_REG[63:1]};

        if (UDRUPD_) begin  //data register update
            case (UIREG_)
                mon_read_addrs_addrs  : begin
                                            {mon_read_size, mon_read_addrs} <= SHIFT_REG[49:16];
                                            mon_write_size  <= SHIFT_REG[49:48];
                                            mon_write_addrs <= {16'b0, SHIFT_REG[15:0]};
                                        end    
                mon_write_addrs_addrs : begin
                                            {mon_write_size, mon_write_addrs} <= SHIFT_REG[33:0];
                                            mon_read_size <= SHIFT_REG[33:32]; 
                                            mon_read_addrs <= {16'b0, SHIFT_REG[49:34]};
                                        end    
                mon_write_reg_addrs   : mon_write_reg   <= SHIFT_REG[63:0];  //data to be written
                evnt_cntr_addrs       : evnt_cntr <= SHIFT_REG[31:0];
                trigger_A_addrs       : trigger_A <= SHIFT_REG[`PCWIDTH-1:0];
                trigger_B_addrs       : trigger_B <= SHIFT_REG[`PCWIDTH-1:0];
                brk_cntrl_addrs       : {PC_EQ_BRKA_en, 
                                         PC_EQ_BRKB_en, 
                                         PC_GT_BRKA_en, 
                                         PC_LT_BRKB_en, 
                                         PC_AND_en,
                                         mon_req,
                                         sstep, 
                                         frc_brk, 
                                         FORCE_RESET} <= SHIFT_REG[8:0];
                              default :  SHIFT_REG <= SHIFT_REG;        

            endcase
        end
    end
end



HUJTAG hujtag(
                
                .TDI(HTDI),
                .TDO(HTDO),
                .TMS(HTMS),
                .TCK(HTCK),
                .TRSTB(HTRSTn),
                
                .UTDI(UTDI_),               // output
                .UTDO(SHIFT_REG[0]),        // input
                .UDRCAP(UDRCAP_),
                .UDRCK(UDRCK_),
                .UDRSH(UDRSH_),
                .UDRUPD(UDRUPD_),
                .URSTB(URSTB_),
                .UIREG0(UIREG_[0]),
                .UIREG1(UIREG_[1]),
                .UIREG2(UIREG_[2]),
                .UIREG3(UIREG_[3]),
                .UIREG4(UIREG_[4]),
                .UIREG5(UIREG_[5]),
                .UIREG6(UIREG_[6]),
                .UIREG7(UIREG_[7]));


endmodule
