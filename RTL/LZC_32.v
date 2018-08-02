// LZC_32.v

`timescale 1ns/100ps

// Author:  Jerry D. Harthcock
// Version:  1.03  June 17, 2018
// Copyright (C) 2018.  All rights reserved.

 
 // Acknowledgement: this LZC RTL borrows from the article found in the citation below.
 // Satish Paidi, Rohit Sreerama, K.Neelima / International Journal of Engineering Research and
 // Applications (IJERA) ISSN: 2248-9622 www.ijera.com
 // Vol. 2, Issue 2,Mar-Apr 2012, pp.1103-1105
 // A Novel High Speed Leading Zero Counter For Floating Point Units
 

module LZC_32 (
    In,
    R,
    All_0
    );

input [31:0] In;
output [4:0] R;
output All_0;

wire [4:0] R;
wire [3:0] upper_R;
wire All_0_upper16;

wire [3:0] lower_R;
wire All_0_lower16;
wire All_0;

assign R = All_0_upper16 ? {1'b1, lower_R[3:0] ^ 4'hF} : {1'b0, lower_R[3:0] ^ 4'hF };
assign All_0 = All_0_upper16 && All_0_lower16;

LZC_16 LZC_16M(
    .In    (In[31:16] ),
    .R     (upper_R ),
    .All_0 (All_0_upper16 )
    );
    
LZC_16 lzc_16L(
    .In  (In[15:0]),
    .R (lower_R ),
    .All_0 (All_0_lower16 )
    );
    

endmodule
