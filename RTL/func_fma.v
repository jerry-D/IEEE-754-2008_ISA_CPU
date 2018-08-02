// func_fma.v
 
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

module func_fma (
    RESET,
    CLK,
    NaN_del,
    Sext_Dest_q2,
    wren,
    round_mode_del,
    Away_del,
    A_sign_del,
    A_is_zero_del,
    A_invalid_del,
    A_inexact_del,
    A_is_infinite_del,
    B_sign_del,
    B_is_zero_del,
    B_invalid_del,
    B_inexact_del,
    B_is_infinite_del,
    wraddrs,
    wraddrs_del,
    wrdataA,
    wrdataB,
    rdenA,
    rdaddrsA,
    rddataA,
    rdenB,
    rdaddrsB,
    rddataB,
    ready
    );

input RESET, CLK, wren, rdenA, rdenB;
input Sext_Dest_q2;
input [9:0] NaN_del;
input Away_del;
input A_sign_del;
input A_is_zero_del;
input A_invalid_del;
input A_inexact_del;
input A_is_infinite_del;
input B_sign_del;
input B_is_zero_del;
input B_invalid_del;
input B_inexact_del;
input B_is_infinite_del;
input [3:0] wraddrs, wraddrs_del, rdaddrsA, rdaddrsB;   // {thread, addrs}
input [18:0] wrdataA, wrdataB;

input [1:0] round_mode_del;

output [17:0] rddataA, rddataB;
output ready;


parameter sig_NaN      = 3'b000;  // singnaling NaN is an operand--if possible, an incoming sNaN should have the last 3 bits equal to this code
parameter mult_oob     = 3'b001;  // multiply operands out of bounds, multiplication(0, INF) or multiplication(?INF, 0)
parameter fsd_mult_oob = 3'b010;  // fused multiply operands out of bounds
parameter add_oob      = 3'b011;  // add or subract or fusedmultadd operands out of bounds
parameter div_oob      = 3'b100;  // division operands out of bounds, division(0, 0) or division(?INF, INF) 
parameter rem_oob      = 3'b101;  // remainder operands out of bounds, remainder(x, y), when y is zero or x is infinite (and neither is NaN)
parameter sqrt_oob     = 3'b110;  // square-root or log operand out of bounds, operand is less than zero
parameter quantize     = 3'b111;  

//FloPoCo exception codes
parameter zero = 2'b00;
parameter infinity = 2'b10;
parameter NaN = 2'b11;
parameter normal = 2'b01;
                       
reg [15:0] semaphor;  // one for each memory location
reg readyA;
reg readyB;


reg [3:0] wraddrs_del_0,
          wraddrs_del_1,                                   
          wraddrs_del_2,
          wraddrs_del_3,
          wraddrs_del_4;
          
reg Sext_Dest_q2_del_0,          
    Sext_Dest_q2_del_1,          
    Sext_Dest_q2_del_2,          
    Sext_Dest_q2_del_3,          
    Sext_Dest_q2_del_4;          


    
reg wren_del_0,  
    wren_del_1, 
    wren_del_2, 
    wren_del_3,
    wren_del_4;
    
reg Rmult_infinity_del_0,
    Rmult_infinity_del_1,
    Rmult_infinity_del_2;

reg mul_inexact_del_0,
    mul_inexact_del_1,
    mul_inexact_del_2,
    mul_inexact_del_3;

    
reg [23:0] Rmultq;   

reg [26:0] C_reg [15:0];

reg [26:0] C;
         
wire ready;

wire [17:0] rddataA, rddataB; 

wire [23:0] Rmult;
wire [23:0] Radd;
wire [17:0] R18;
wire mul_invalid;
wire mul_inexact;

wire add_AorB_is_Inf;
wire subtractInf;
wire add_operator_overflow;

wire mult_g; 
wire mult_r; 
wire mult_s; 

wire add_g;
wire add_r;
wire add_s;

wire C_sign_del;

wire C_invalid;
wire C_inexact;
wire C_NaN;

assign C_invalid = A_invalid_del;
assign C_inexact = A_inexact_del;
assign C_NaN = &wrdataA[15:10] && |wrdataA[9:0];

reg C_invalid_del_1, 
    C_inexact_del_1, 
    C_NaN_del_1;

reg C_invalid_del_0, 
    C_inexact_del_0, 
    C_NaN_del_0;


always @(posedge CLK) 
   if (Sext_Dest_q2_del_0 && wren_del_0) C_reg[wraddrs_del_0] <= {C_invalid, C_inexact, C_NaN, wrdataA, 5'b0};
   else if (wren_del_3 && ~Sext_Dest_q2_del_3) C_reg[wraddrs_del_3] <={ C_invalid_del_1, C_inexact_del_1, C_NaN_del_1, Radd};

always @(posedge CLK) begin
    if (wren_del_0 && ~Sext_Dest_q2_del_0) C <= C_reg[wraddrs_del_0];
    else C <= 27'b0;
    {C_invalid_del_0, C_inexact_del_0, C_NaN_del_0} <= C[26:24];
    {C_invalid_del_1, C_inexact_del_1, C_NaN_del_1} <= {C_invalid_del_0, C_inexact_del_0, C_NaN_del_0};
end    

assign C_sign_del = C_reg[wraddrs_del_3][21];

assign mul_inexact = |Rmult[4:0] || mult_g || mult_r || mult_s;

assign mul_invalid = (A_is_zero_del && B_is_infinite_del) || 
                     (B_is_zero_del && A_is_infinite_del);

assign add_invalid = Rmult_infinity_del_2 && B_is_infinite_del && ((A_sign_del ^ B_sign_del) ^ C_sign_del) && wren_del_3 && ~Sext_Dest_q2_del_3;    


assign ready = readyA && readyB;

FPMultExpert6101015 fatMUL(
    .clk (CLK ), 
    .rst (RESET ),
    .X   (wrdataA),
    .Y   (wrdataB),  
    .R   (Rmult ),      
    .IEEEg (mult_g ),    // these GRS bits are used only for determining unrounded fat multiply inexact, which is not, per se, "signaled"
    .IEEEr (mult_r ),    
    .IEEEs (mult_s ),    
    .roundit (1'b0)    
    );

// this operator pipe is 2 clocks deep FP 6 15
FPAdd615 fatADD(
    .clk (CLK ), 
    .rst (RESET ),
    .X   (Rmultq),
    .Y   (C[23:0]),  
    .R   (Radd ),    
    .grd (add_g ),              
    .rnd (add_r ),        
    .stk (add_s ),        
    .addToRoundBit (1'b0)    
    );
    

FP610_To_IEEE754_510_filtered FP610toIEEE510(
    .CLK               (CLK          ),
    .RESET             (RESET        ),
    .wren              (wren_del_3 && ~Sext_Dest_q2_del_3  ),      
    .round_mode        (round_mode_del),     
    .Away              (Away_del     ),
    .trunk_invalid     (mul_invalid || add_invalid),
    .NaN_in            (A_invalid_del ? NaN_del : C[9:0] ),         
    .invalid_code      (mul_invalid ? fsd_mult_oob : add_oob),        
    .operator_overflow (1'b0         ),  
    .operator_underflow(1'b0         ),    
    .div_by_0_del      (1'b0         ),      
    .A_invalid_del     (A_invalid_del || C_invalid_del_1),      
    .B_invalid_del     (B_invalid_del),      
    .A_inexact_del     (A_inexact_del || mul_inexact_del_3 || C_inexact_del_0),      
    .B_inexact_del     (B_inexact_del),      
    .X                 (Radd[23:5]   ),      
    .Rq                (R18          ),      
    .G_in              (Radd[4]      ),      
    .R_in              (Radd[3]      ),      
    .S_in              (|{|Radd[2:0], add_g, add_r, add_s})         
    );                       
 
      
//RAM64x34tp ram64(
RAM_func #(.ADDRS_WIDTH(4), .DATA_WIDTH(18))
    ram64_mulclk(
    .CLK        (CLK     ),
    .wren       (wren_del_4 && ~Sext_Dest_q2_del_4),
    .wraddrs    (wraddrs_del_4 ),   
    .wrdata     (R18     ), 
    .rdenA      (rdenA   ),   
    .rdaddrsA   (rdaddrsA),
    .rddataA    (rddataA ),
    .rdenB      (rdenB   ),
    .rdaddrsB   (rdaddrsB),
    .rddataB    (rddataB ));


always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        wren_del_0 <= 1'b0;
        wren_del_1 <= 1'b0;
        wren_del_2 <= 1'b0;
        wren_del_3 <= 1'b0;
        wren_del_4 <= 1'b0;
    end
    else begin
        wren_del_0 <= wren;
        wren_del_1 <= wren_del_0;                                                 
        wren_del_2 <= wren_del_1;                                                 
        wren_del_3 <= wren_del_2;                                                 
        wren_del_4 <= wren_del_3;                                                 
    end
end   



always @(posedge CLK) begin
    Sext_Dest_q2_del_0 <= Sext_Dest_q2;
    Sext_Dest_q2_del_1 <= Sext_Dest_q2_del_0;                                                 
    Sext_Dest_q2_del_2 <= Sext_Dest_q2_del_1;                                                 
    Sext_Dest_q2_del_3 <= Sext_Dest_q2_del_2;                                                 
    Sext_Dest_q2_del_4 <= Sext_Dest_q2_del_3;                                                 
end   


always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        Rmult_infinity_del_0 <= 1'b0;
        Rmult_infinity_del_1 <= 1'b0;
        Rmult_infinity_del_2 <= 1'b0;
    end    
    else begin
        Rmult_infinity_del_0 <= (Rmult[18:7]==infinity);
        Rmult_infinity_del_1 <= Rmult_infinity_del_0;
        Rmult_infinity_del_2 <= Rmult_infinity_del_1;
    end                                         
end        

always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        mul_inexact_del_0 <= 1'b0;
        mul_inexact_del_1 <= 1'b0;
        mul_inexact_del_2 <= 1'b0;
        mul_inexact_del_3 <= 1'b0;
    end    
    else begin
        mul_inexact_del_0 <= mul_inexact;
        mul_inexact_del_1 <= mul_inexact_del_0;
        mul_inexact_del_2 <= mul_inexact_del_1;
        mul_inexact_del_3 <= mul_inexact_del_2;
    end                                        
end
        
always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        Rmultq <= 24'b0;
    end    
    else begin
        Rmultq <= Rmult;
    end                                         
end        

        
always @(posedge CLK or posedge RESET) begin
    if (RESET) semaphor <= 16'hFFFF;
    else begin
        if (wren) semaphor[wraddrs] <= 1'b0;
        if (wren_del_4) semaphor[wraddrs_del] <= 1'b1;
    end
end     

always @(posedge CLK) begin
    wraddrs_del_0 <= wraddrs;
    wraddrs_del_1 <= wraddrs_del_0;
    wraddrs_del_2 <= wraddrs_del_1;
    wraddrs_del_3 <= wraddrs_del_2;
    wraddrs_del_4 <= wraddrs_del_3;
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
