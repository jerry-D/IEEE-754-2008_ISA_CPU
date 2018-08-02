// LZC_8.v

`timescale 1ns/100ps

// Author:  Jerry D. Harthcock
// Version:  1.03  June 17, 2018
// Copyright (C) 2018.  All rights reserved.

 
 // Acknowledgement: this LZC RTL borrows from the article found in the citation below.
 // Satish Paidi, Rohit Sreerama, K.Neelima / International Journal of Engineering Research and
 // Applications (IJERA) ISSN: 2248-9622 www.ijera.com
 // Vol. 2, Issue 2,Mar-Apr 2012, pp.1103-1105
 // A Novel High Speed Leading Zero Counter For Floating Point Units
 
module LZC_8 (
     In,
     nyb
     );
 input [7:0] In;
 output [3:0] nyb;
 
 wire [3:0] nyb;
 
 //front nor gates
 wire [3:0] nr;
 assign nr[0] = ~|In[1:0];
 assign nr[1] = ~|In[3:2];
 assign nr[2] = ~|In[5:4];
 assign nr[3] = ~|In[7:6];
 
 assign nyb[3] = nr[3] && nr[2];
 assign nyb[0] = nyb[3] && nr[1] && nr[0];
 assign nyb[2] = ~( nr[3] && ~(nyb[3] && ~nr[1]));
 assign nyb[1] = ~((~In[7] && ~(nr[3] && In[5])) && ~(nyb[3] && ~(~In[3] && ~(nr[1] && In[1]))));
 
 endmodule
