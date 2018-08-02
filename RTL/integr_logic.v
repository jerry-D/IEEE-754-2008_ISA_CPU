// cpu_integr_logic.v
 `timescale 1ns/100ps
 
// Author:  Jerry D. Harthcock
// Version:  1.03  June 17, 2018
// Copyright (C) 2018.  All rights reserved.
 

module integr_logic(
    CLK,
    RESET,
    wren,
    Sext_Dest_q2,
    Size_Dest_q1,        
    wraddrs,     
    operatr_q2,
    oprndA,
    oprndB,
    C,
    V,
    N,
    Z,
    rdenA,
    Sext_SrcA_q1,
    Sext_SrcA_q2,
    Size_SrcA_q1,
    rdaddrsA,    
    operatrA_q0,
    rddataA,
    rdenB,
    Sext_SrcB_q1,
    Sext_SrcB_q2,
    Size_SrcB_q1,
    rdaddrsB,    
    operatrB_q0,
    rddataB,
    ready_q1
    );

input         CLK;
input         RESET;
input         wren;
input         Sext_Dest_q2;
input  [1:0]  Size_Dest_q1;
input  [3:0]  wraddrs;
input  [4:0]  operatr_q2;
input  [63:0] oprndA;
input  [63:0] oprndB;
input         C;
input         V;
input         N;
input         Z;
input         rdenA;
input  [3:0]  rdaddrsA;
input         Sext_SrcA_q1;
input         Sext_SrcA_q2;
input  [1:0] Size_SrcA_q1;
input  [4:0]  operatrA_q0;
output [67:0] rddataA;
input         rdenB;
input         Sext_SrcB_q1;
input         Sext_SrcB_q2;
input  [1:0] Size_SrcB_q1;
input  [3:0]  rdaddrsB;
input  [4:0]  operatrB_q0;
output [67:0] rddataB;
output        ready_q1;


parameter AND_    = 5'b1111_1;   // 0xDFF8- 0xDF80
parameter OR_     = 5'b1111_0;   // 0xDF78- 0xDF00
parameter XOR_    = 5'b1110_1;   // 0xDEF8- 0xDE80
parameter ADD_    = 5'b1110_0;   // 0xDE78- 0xDE00
parameter ADDC_   = 5'b1101_1;   // 0xDDF8- 0xDD80
parameter SUB_    = 5'b1101_0;   // 0xDD78- 0xDD00
parameter SUBB_   = 5'b1100_1;   // 0xDCF8- 0xDC80
parameter MUL_    = 5'b1100_0;   // 0xDC78- 0xDC00
parameter DIV_    = 5'b1011_1;   // 0xDBF8- 0xDB80
parameter SHFT_   = 5'b1011_0;   // 0xDB78- 0xDB00
parameter MAX_    = 5'b1010_1;   // 0xDAF8- 0xDA80
parameter MIN_    = 5'b1010_0;   // 0xDA78- 0xDA00
parameter BSET_   = 5'b1001_1;   // 0xD9F8- 0xD980
parameter BCLR_   = 5'b1001_0;   // 0xD978- 0xD900
parameter ENDI_   = 5'b1000_1;   // 0xD8F8- 0xD880
parameter BUBL_   = 5'b1000_0;   // 0xD878- 0xD800
parameter CNVFBTA_ = 5'b0111_1;   // 0xD7F8- 0xD780  --binary to ASCII numberic
parameter CNVTBFA_ = 5'b0111_0;   // 0xD778- 0xD700  --ASCII numberic to binary

                                                                                                           
reg [67:0] rddataA;                                                                                      
reg [67:0] rddataB;
reg        readyA;                                               
reg        readyB;
reg [5:0] operatrA_q1;
reg [5:0] operatrB_q1;

reg rdenA_q1;
reg rdenB_q1;

wire [67:0] rddataA_AND;
wire [67:0] rddataB_AND;
wire        ready_AND;

wire [67:0] rddataA_OR;
wire [67:0] rddataB_OR;
wire        ready_OR;

wire [67:0] rddataA_XOR;
wire [67:0] rddataB_XOR;
wire        ready_XOR;

wire [67:0] rddataA_ADD;
wire [67:0] rddataB_ADD;
wire        ready_ADD;

wire [67:0] rddataA_SUB;
wire [67:0] rddataB_SUB;
wire        ready_SUB;

wire [67:0] rddataA_MUL;
wire [67:0] rddataB_MUL;
wire        ready_MUL;

wire [67:0] rddataA_DIV;
wire [67:0] rddataB_DIV;
wire        ready_DIV;

wire [67:0] rddataA_SHFT;
wire [67:0] rddataB_SHFT;
wire        ready_SHFT;

wire [67:0] rddataA_MAX;
wire [67:0] rddataB_MAX;
wire        ready_MAX;

wire [67:0] rddataA_MIN;
wire [67:0] rddataB_MIN;
wire        ready_MIN;


wire [67:0] rddataA_ENDI;
wire [67:0] rddataB_ENDI;
wire        ready_ENDI;

wire [67:0] rddataA_BSET;
wire [67:0] rddataB_BSET;
wire        ready_BSET;

wire [67:0] rddataA_BCLR;
wire [67:0] rddataB_BCLR;
wire        ready_BCLR;

wire [67:0] rddataA_CNVFBTA;   //convert from binary numeric to ASCII numeric
wire [67:0] rddataB_CNVFBTA;
wire        ready_CNVFBTA;

wire [67:0] rddataA_CNVTBFA;  //convert to binary numeric from ASCII numeric
wire [67:0] rddataB_CNVTBFA;
wire        ready_CNVTBFA;


wire ready_q1;
assign ready_q1 = readyA && readyB;                      

logic_SHIFT logic_SHIFT(
    .CLK      (CLK          ),
//    .RESET    (RESET        ),
    .wren     (wren && (operatr_q2==SHFT_)),
    .wraddrs  (wraddrs[3:0]),      
    .oprndA   (oprndA       ),
    .oprndB_shiftype (oprndB[2:0]),
    .oprndB_shiftamount (oprndB[14:10]),
    .C        (C            ),
    .V        (V            ),
    .rdenA    (rdenA && (operatrA_q0==SHFT_)),
    .rdaddrsA (rdaddrsA[3:0]),   
    .rddataA  (rddataA_SHFT  ),
    .rdenB    (rdenB && (operatrA_q0==SHFT_)),
    .rdaddrsB (rdaddrsB[3:0]),   
    .rddataB  (rddataB_SHFT  ),
    .ready    (ready_SHFT    )
    );

logic_AND logic_AND(
    .CLK      (CLK          ),
//    .RESET    (RESET        ),
    .wren     (wren && (operatr_q2==AND_)),
    .wraddrs  (wraddrs[3:0] ),      
    .oprndA   (oprndA       ),
    .oprndB   (oprndB       ),
    .C        (C            ),
    .V        (V            ),
    .rdenA    (rdenA && (operatrA_q0==AND_)),
    .rdaddrsA (rdaddrsA[3:0]),   
    .rddataA  (rddataA_AND  ),
    .rdenB    (rdenB && (operatrB_q0==AND_)),
    .rdaddrsB (rdaddrsB[3:0]),   
    .rddataB  (rddataB_AND  ),
    .ready    (ready_AND    )
    );

logic_OR logic_OR(
    .CLK      (CLK          ),
//    .RESET    (RESET        ),
    .wren     (wren && (operatr_q2==OR_)),
    .wraddrs  (wraddrs[3:0] ),      
    .oprndA   (oprndA       ),
    .oprndB   (oprndB       ),
    .C        (C            ),
    .V        (V            ),
    .rdenA    (rdenA && (operatrA_q0==OR_)),
    .rdaddrsA (rdaddrsA[3:0]),   
    .rddataA  (rddataA_OR  ),
    .rdenB    (rdenB && (operatrB_q0==OR_)),
    .rdaddrsB (rdaddrsB[3:0]),   
    .rddataB  (rddataB_OR  ),
    .ready    (ready_OR    )
    );

logic_XOR logic_XOR(
    .CLK      (CLK          ),
//    .RESET    (RESET        ),
    .wren     (wren && (operatr_q2==XOR_)),
    .wraddrs  (wraddrs[3:0] ),      
    .oprndA   (oprndA       ),
    .oprndB   (oprndB       ),
    .C        (C            ),
    .V        (V            ),
    .rdenA    (rdenA && (operatrA_q0==XOR_)),
    .rdaddrsA (rdaddrsA[3:0]),   
    .rddataA  (rddataA_XOR  ),
    .rdenB    (rdenB && (operatrB_q0==XOR_)),
    .rdaddrsB (rdaddrsB[3:0]),   
    .rddataB  (rddataB_XOR  ),
    .ready    (ready_XOR    )
    );

integer_ADD integer_ADD(
    .CLK      (CLK          ),
//    .RESET    (RESET        ),
    .Sext_Dest_q2(Sext_Dest_q2),
    .Sext_SrcA_q2(Sext_SrcA_q2),
    .Sext_SrcB_q2(Sext_SrcB_q2),
    .wren     (wren && (operatr_q2==ADD_)),
    .wraddrs  (wraddrs[3:0] ),      
    .oprndA   (oprndA       ),
    .oprndB   (oprndB       ),
    .C        (C            ), 
    .rdenA    (rdenA && (operatrA_q0==ADD_)),
    .rdaddrsA (rdaddrsA[3:0]),   
    .rddataA  (rddataA_ADD  ),
    .rdenB    (rdenB && (operatrB_q0==ADD_)),
    .rdaddrsB (rdaddrsB[3:0]),   
    .rddataB  (rddataB_ADD  ),
    .ready    (ready_ADD    )
    );

integer_SUB integer_SUB(
    .CLK      (CLK          ),
//    .RESET    (RESET        ),
    .Sext_Dest_q2(Sext_Dest_q2),
    .Sext_SrcA_q2(Sext_SrcA_q2),
    .Sext_SrcB_q2(Sext_SrcB_q2),
    .wren     (wren && (operatr_q2==SUB_)),
    .wraddrs  (wraddrs[3:0] ),      
    .oprndA   (oprndA       ),
    .oprndB   (oprndB       ),
    .C        (C            ), 
    .rdenA    (rdenA && (operatrA_q0==SUB_)),
    .rdaddrsA (rdaddrsA[3:0]),   
    .rddataA  (rddataA_SUB  ),
    .rdenB    (rdenB && (operatrB_q0==SUB_)),
    .rdaddrsB (rdaddrsB[3:0]),   
    .rddataB  (rddataB_SUB  ),
    .ready    (ready_SUB    )
    );

integer_MUL integer_MUL(
    .CLK      (CLK          ),
//    .RESET    (RESET        ),
    .Sext_SrcA_q2(Sext_SrcA_q2),
    .Sext_SrcB_q2(Sext_SrcB_q2),
    .wren     (wren && (operatr_q2==MUL_)),
    .wraddrs  (wraddrs[3:0] ),      
    .oprndA   (oprndA[31:0] ),
    .oprndB   (oprndB[31:0] ),
    .C        (C            ),
    .V        (V            ),
    .rdenA    (rdenA && (operatrA_q0==MUL_)),
    .rdaddrsA (rdaddrsA[3:0]),   
    .rddataA  (rddataA_MUL  ),
    .rdenB    (rdenB && (operatrB_q0==MUL_)),
    .rdaddrsB (rdaddrsB[3:0]),   
    .rddataB  (rddataB_MUL  ),
    .ready    (ready_MUL    )
    );

integer_DIV integer_DIV(
    .CLK      (CLK          ),
    .RESET    (RESET        ),
    .wren     (wren && (operatr_q2==DIV_)),
    .wraddrs  (wraddrs[3:0] ),      
    .oprndA   ({Sext_SrcA_q2, oprndA[31:0]}),
    .oprndB   ({Sext_SrcB_q2, oprndB[31:0]}),
    .rdenA    (rdenA && (operatrA_q0==DIV_)),
    .rdaddrsA (rdaddrsA[3:0]),   
    .rddataA  (rddataA_DIV  ),
    .rdenB    (rdenB && (operatrB_q0==DIV_)),
    .rdaddrsB (rdaddrsB[3:0]),   
    .rddataB  (rddataB_DIV  ),
    .ready    (ready_DIV    )
    );

logic_ENDI logic_ENDI(
    .CLK      (CLK          ),
    .RESET    (RESET        ),
    .wren     (wren && (operatr_q2==ENDI_)),
    .Size_Dest_q1(Size_Dest_q1),
    .wraddrs  (wraddrs[3:0] ),      
    .oprndA   (oprndA       ),
    .oprndB   (oprndB[31:0] ),
    .C        (C            ),
    .V        (V            ),
    .rdenA    (rdenA && (operatrA_q0==ENDI_)),
    .Size_SrcA_q1(Size_SrcA_q1),
    .rdaddrsA (rdaddrsA[3:0]  ),   
    .rddataA  (rddataA_ENDI   ),
    .rdenB    (rdenB && (operatrB_q0==ENDI_)),
    .rdaddrsB (rdaddrsB[3:0]  ),   
    .rddataB  (rddataB_ENDI   ),
    .ready    (ready_ENDI     )
    );

logic_BSET logic_BSET(
    .CLK      (CLK          ),
//    .RESET    (RESET        ),
    .wren     (wren && (operatr_q2==BSET_)),
    .wraddrs  (wraddrs[3:0] ),      
    .oprndA   (oprndA       ),
    .oprndB   (oprndB[5:0]  ),
    .C        (C            ),
    .V        (V            ),
    .rdenA    (rdenA && (operatrA_q0==BSET_)),
    .rdaddrsA (rdaddrsA[3:0]),   
    .rddataA  (rddataA_BSET ),
    .rdenB    (rdenB && (operatrB_q0==BSET_)),
    .rdaddrsB (rdaddrsB[3:0]),   
    .rddataB  (rddataB_BSET ),
    .ready    (ready_BSET   )
    );
    
logic_BCLR logic_BCLR(
    .CLK      (CLK          ),
//    .RESET    (RESET        ),
    .wren     (wren && (operatr_q2==BCLR_)),
    .wraddrs  (wraddrs[3:0] ),      
    .oprndA   (oprndA       ),
    .oprndB   (oprndB[5:0]  ),
    .C        (C            ),
    .V        (V            ),
    .rdenA    (rdenA && (operatrA_q0==BCLR_)),
    .rdaddrsA (rdaddrsA[3:0]),   
    .rddataA  (rddataA_BCLR ),
    .rdenB    (rdenB && (operatrB_q0==BCLR_)),
    .rdaddrsB (rdaddrsB[3:0]),   
    .rddataB  (rddataB_BCLR ),
    .ready    (ready_BCLR   )
    );
    
logic_MAX logic_MAX(
    .CLK      (CLK          ),
//    .RESET    (RESET        ),
    .wren     (wren && (operatr_q2==MAX_)),
    .wraddrs  (wraddrs[3:0] ),      
    .oprndA   (oprndA       ),
    .oprndB   (oprndB       ),
    .C        (C            ),
    .V        (V            ),
    .rdenA    (rdenA && (operatrA_q0==MAX_)),
    .rdaddrsA (rdaddrsA[3:0]),   
    .rddataA  (rddataA_MAX  ),
    .rdenB    (rdenB && (operatrB_q0==MAX_)),
    .rdaddrsB (rdaddrsB[3:0]),   
    .rddataB  (rddataB_MAX  ),
    .ready    (ready_MAX    )
    );
    
logic_MIN logic_MIN(
    .CLK      (CLK          ),
//    .RESET    (RESET        ),
    .wren     (wren && (operatr_q2==MIN_)),
    .wraddrs  (wraddrs[3:0] ),      
    .oprndA   (oprndA       ),
    .oprndB   (oprndB       ),
    .C        (C            ),
    .V        (V            ),
    .rdenA    (rdenA && (operatrA_q0==MIN_)),
    .rdaddrsA (rdaddrsA[3:0]),   
    .rddataA  (rddataA_MIN  ),
    .rdenB    (rdenB && (operatrB_q0==MIN_)),
    .rdaddrsB (rdaddrsB[3:0]),   
    .rddataB  (rddataB_MIN  ),
    .ready    (ready_MIN    )
    );
    
func_cnvTHC cnvTHC(
    .RESET    (RESET        ),
    .CLK      (CLK          ),
    .Sext_SrcA_q1(Sext_SrcA_q1),
    .Sext_SrcB_q1(Sext_SrcB_q1),
    .wren(wren && (operatr_q2==CNVFBTA_)),
    .wraddrs  (wraddrs[3:0] ),
    .oprndA   (oprndA       ),
    .C        (C            ),
    .V        (V            ),
    .N        (N            ),
    .Z        (Z            ),
    .rdenA    (rdenA && (operatrA_q0==CNVFBTA_)),
    .rdaddrsA (rdaddrsA[3:0]),
    .rddataA  (rddataA_CNVFBTA),
    .rdenB    (rdenB && (operatrB_q0==CNVFBTA_)),
    .rdaddrsB (rdaddrsB[3:0]),
    .rddataB  (rddataB_CNVFBTA),
    .ready    (ready_CNVFBTA )
    );            
                
func_cnvFHC cnvFHC(
    .RESET    (RESET        ),
    .CLK      (CLK          ),
    .wren(wren && (operatr_q2==CNVTBFA_)),
    .wraddrs  (wraddrs[3:0] ),
    .oprndA   (oprndA       ),
    .oprndB   (oprndB       ),
    .C        (C            ),
    .V        (V            ),
    .N        (N            ),
    .Z        (Z            ),
    .rdenA    (rdenA && (operatrA_q0==CNVTBFA_)),
    .rdaddrsA (rdaddrsA[3:0]),
    .rddataA  (rddataA_CNVTBFA),      
    .rdenB    (rdenB && (operatrB_q0==CNVTBFA_)),
    .rdaddrsB (rdaddrsB[3:0]),
    .rddataB  (rddataB_CNVTBFA),
    .ready    (ready_CNVTBFA )
    );
    

always @(*) begin
    if (rdenA_q1)
        casex(operatrA_q1)
            AND_  : begin
                        rddataA = rddataA_AND;
                        readyA = ready_AND;
                    end    
            OR_   : begin
                        rddataA = rddataA_OR;
                        readyA = ready_OR;
                    end    
            XOR_  : begin
                        rddataA = rddataA_XOR;
                        readyA = ready_XOR;
                    end    
            ADD_  : begin
                        rddataA = rddataA_ADD;
                        readyA = ready_ADD;
                    end    
 //           ADDC_ : begin
 //                       rddataA = rddataA_ADDC;
 //                       readyA = ready_ADDC;
 //                   end
            SUB_  : begin
                        rddataA = rddataA_SUB;
                        readyA = ready_SUB;
                    end
                        
//            SUBB_ : begin
//                        rddataA = rddataA_SUBB;
//                        readyA = ready_SUBB;
//                    end    
            MUL_  : begin
                        rddataA = rddataA_MUL;
                        readyA = ready_MUL;
                    end    
            DIV_  : begin
                        rddataA = rddataA_DIV;
                        readyA = ready_DIV;
                    end    
            SHFT_ : begin
                        rddataA = rddataA_SHFT;
                        readyA = ready_SHFT;
                    end
                    
             MAX_ : begin
                        rddataA = rddataA_MAX;
                        readyA = ready_MAX;
                    end
                     
             MIN_ : begin
                        rddataA = rddataA_MIN;
                        readyA = ready_MIN;
                    end
                     
            ENDI_ : begin
                        rddataA = rddataA_ENDI;
                        readyA = ready_ENDI;
                    end
                    
            BSET_ : begin
                        rddataA = rddataA_BSET;
                        readyA = ready_BSET;
                    end
                    
            BCLR_ : begin
                        rddataA = rddataA_BCLR;
                        readyA = ready_BCLR;
                    end

            CNVFBTA_ : begin
                        rddataA = rddataA_CNVFBTA;
                        readyA = ready_CNVFBTA;
                    end
                    
            CNVTBFA_ : begin
                        rddataA = rddataA_CNVTBFA;
                        readyA = ready_CNVTBFA;
                    end
            
          default : begin
                        rddataA = 68'h0_0000_0000_0000_0000;
                        readyA = 1'b1;
                    end
        endcase                 
    else begin
        rddataA = 68'h0_0000_0000_0000_0000;
        readyA = 1'b1;
    end    
end

always @(*) begin
    if (rdenB_q1)
        casex(operatrB_q1)
            AND_  : begin
                        rddataB = rddataB_AND;
                        readyB = ready_AND;
                    end    
            OR_   : begin
                        rddataB = rddataB_OR;
                        readyB = ready_OR;
                    end    
            XOR_  : begin
                        rddataB = rddataB_XOR;
                        readyB = ready_XOR;
                    end    
            ADD_  : begin
                        rddataB = rddataB_ADD;
                        readyB = ready_ADD;
                    end    
//            ADDC_ : begin
//                        rddataB = rddataB_ADDC;
//                        readyB = ready_ADDC;
//                    end
            SUB_  : begin
                        rddataB = rddataB_SUB;
                        readyB = ready_SUB;
                    end
                        
//            SUBB_ : begin
//                        rddataB = rddataB_SUBB;
//                        readyB = ready_SUBB;
//                    end    
             MUL_ : begin
                        rddataB = rddataB_MUL;
                        readyB = ready_MUL;
                    end    
            DIV_  : begin
                        rddataB = rddataB_DIV;
                        readyB = ready_DIV;
                    end    
            SHFT_ : begin
                        rddataB = rddataB_SHFT;
                        readyB = ready_SHFT;
                    end  
                    
             MAX_ : begin
                        rddataB = rddataB_MAX;
                        readyB = ready_MAX;
                    end
                     
             MIN_ : begin
                        rddataB = rddataB_MIN;
                        readyB = ready_MIN;
                    end
            ENDI_ : begin
                        rddataB = rddataB_ENDI;
                        readyB = ready_ENDI;
                    end

            BSET_ : begin
                        rddataB = rddataB_BSET;
                        readyB = ready_BSET;
                    end
                    
            BCLR_ : begin
                        rddataB = rddataB_BCLR;
                        readyB = ready_BCLR;
                    end
                    
            CNVFBTA_ : begin
                        rddataB = rddataB_CNVFBTA;
                        readyB = ready_CNVFBTA;
                    end
                    
            CNVTBFA_ : begin
                        rddataB = rddataB_CNVTBFA;
                        readyB = ready_CNVTBFA;
                    end
                    
          default : begin
                        rddataB = 68'h0_0000_0000_0000_0000;
                        readyB = 1'b1;
                    end 
        endcase                
    else begin
        rddataB = 68'h0_0000_0000_0000_0000;
        readyB = 1'b1;
    end    
end

always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        rdenA_q1 <= 1'b0;
        rdenB_q1 <= 1'b0;
        operatrA_q1 <= 5'b00000;
        operatrB_q1 <= 5'b00000;
    end
    else begin
        rdenA_q1 <= rdenA;    
        rdenB_q1 <= rdenB;
        operatrA_q1 <= operatrA_q0;
        operatrB_q1 <= operatrB_q0;
    end
end
    
endmodule
