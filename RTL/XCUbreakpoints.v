// breakpoints.v
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
 


module XCUbreakpoints (
    CLK,
    RESET,
    Instruction_q0,
    Instruction_q0_del,
    swbreakDetect,
    
    sstep,
    frc_brk,
    broke,
    skip_cmplt,
    break_q0,
    break_q1,
    break_q2,
    ind_mon_read_q0,
    ind_mon_write_q2,
    monRWaddrs,
    monRWsize,
    monRDreq,
    monWRreq
    );

input CLK;
input RESET;
output swbreakDetect;
input  [63:0] Instruction_q0;
output [63:0] Instruction_q0_del;


    
input sstep;

input frc_brk;

output broke;

output skip_cmplt;

output break_q0;
output break_q1;
output break_q2;
output ind_mon_read_q0;
output ind_mon_write_q2;
input  [31:0] monRWaddrs;  
input  [1:0] monRWsize;

input monRDreq;
input monWRreq;

parameter MON_ADDRS = 32'h0000FE00;
parameter SWBREAK   = 64'h14FFA04FF887C000;


reg break_q0;
reg break_q1;
reg break_q2;

reg [1:0] break_state;

reg broke;

reg skip;

reg skip_cmplt;



reg ind_mon_wr_q1;
reg ind_mon_wr_q2;


wire swbreakDetect;
assign swbreakDetect = (Instruction_q0_del==SWBREAK);


wire [1:0] mon_write_size;
assign mon_write_size = monWRreq ? monRWsize : 2'b11;
wire [1:0] mon_read_size;
assign mon_read_size = monRDreq ? monRWsize : 2'b11;

wire mon_req;
assign mon_req = monRDreq || monWRreq; 

wire [31:0] mon_read_addrs;
assign mon_read_addrs = monRDreq ? monRWaddrs : 32'b0;  
wire [31:0] mon_write_addrs;
assign mon_write_addrs = monWRreq ? monRWaddrs : 32'b0;  

wire any_break_det;

wire [63:0] Instruction_q0_del;
wire [63:0] monitor_instruction;

wire ind_mon_read;
wire ind_mon_write;
wire ind_mon_read_q0;
wire ind_mon_write_q2;
                                                                                                         

assign ind_mon_read  = monRDreq && |mon_read_addrs[31:16];                                                                                       
assign ind_mon_write = monWRreq && |mon_write_addrs[31:16];
assign ind_mon_read_q0  = ind_mon_read  && break_q0;
assign ind_mon_write_q2 = ind_mon_wr_q2 && break_q2;

assign any_break_det = frc_brk || broke || swbreakDetect;
                       
                       
assign monitor_instruction = {5'b0000_0, mon_write_size, ind_mon_write, mon_write_addrs[15:0], 1'b0, mon_read_size, ind_mon_read, mon_read_addrs[15:0], 4'b0110, 16'h0000};    
assign Instruction_q0_del = break_q0 ?  monitor_instruction : Instruction_q0;  


always @(posedge CLK) begin
    ind_mon_wr_q1 <= ind_mon_write;
    ind_mon_wr_q2 <= ind_mon_wr_q1;
end    
                                                                                                                  
always @(posedge CLK or posedge RESET) begin
    if (RESET) begin                                                                                               
        break_q0 <= 1'b0;                                                                                          
        break_q1 <= 1'b0;                                                                                          
        break_q2 <= 1'b0;                                                                                          
    end
    else begin                                                                                                     
        break_q0 <= (any_break_det && ~skip) || mon_req; 
        break_q1 <= break_q0;
        break_q2 <= break_q1;
    end                 
end   

always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        broke <= 1'b0;
        break_state <=2'b00;
        skip <= 1'b0;
        skip_cmplt <= 1'b0;
    end
    else begin
        case(break_state) 
            2'b00 : begin
                        skip_cmplt <= 1'b0;
                        if (frc_brk || swbreakDetect) begin 
                            broke <= 1'b1;
                            break_state <= 2'b01;
                        end
                    end    
            2'b01 : begin
                        skip_cmplt <= 1'b0;
                        if (sstep) begin
                            skip <= 1'b1;
                            break_state <= 2'b10;
                        end
                    end    
            2'b10 : begin
                        skip <= 1'b0;
                        skip_cmplt <= 1'b1;
                        if (~sstep) begin
                            if (~frc_brk) begin
                                broke <= 1'b0;
                                break_state <= 2'b00;
                            end
                            else break_state <= 2'b01; 
                        end    
                    end
          default : begin
                        broke <= 1'b0;
                        break_state <=2'b00;
                        skip <= 1'b0;
                        skip_cmplt <= 1'b0;
                    end    
                                    
        endcase
    end
end   


endmodule
