// LZC_16.v

`timescale 1ns/100ps

// Author:  Jerry D. Harthcock
// Version:  1.03  June 17, 2018
// Copyright (C) 2018.  All rights reserved.

 
 // Acknowledgement: this LZC RTL is derrived, in part, from the article found in the citation below.
 // Satish Paidi, Rohit Sreerama, K.Neelima / International Journal of Engineering Research and
 // Applications (IJERA) ISSN: 2248-9622 www.ijera.com
 // Vol. 2, Issue 2,Mar-Apr 2012, pp.1103-1105
 // A Novel High Speed Leading Zero Counter For Floating Point Units

module LZC_16 (
    In,
    R,
    All_0
    );

input [15:0] In;
output [3:0] R;
output All_0;

wire [7:0] k;
wire [3:0] R;
wire All_0;

assign R[3] = ~k[4];
assign R[2] = ~( k[7] && ~( k[4] && ~k[3]));
assign R[1] = ~(~k[6] && ~( k[4] &&  k[2]));
assign R[0] = ~(~k[5] && ~( k[4] &&  k[1]));
assign All_0 = k[0] && k[4];



LZC_8 lzc_8_H(   //most significant 8-bit input
    .In  (In[15:8]),
    .nyb (k[7:4] )
    );

LZC_8 lzc_8_L(
    .In  (In[7:0]),
    .nyb (k[3:0] )
    );
endmodule 
