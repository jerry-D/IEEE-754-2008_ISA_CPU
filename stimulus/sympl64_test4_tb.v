// Example testbench for Universal IEEE 754 2008 Floating-Point CPU
// Author:  Jerry D. Harthcock  
// version 2.01  March, 28, 2018
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
                                                                                                                     

// this testbench reads a .stl binary file into system external synchronous SRAM
// the .stl 3D model is transformed according to the parameters in program memory 
// the testbench divides the number of triangles by the number of available XCUs (if any) or just by 1 if the CPU is going solo
// and that is roughly how many triangles each thread gets
// once the triangles are pushed, reset is released
// while the CPU or XCUs are crunching away, a breakpoint is set and enabled on the CPU, it is then single-stepped a few times and a monitor read/write is performed
// the CPU is then released from breakpoint and while running real-time another monitor read/write is performed
// "olive_xform_SIL.hex"  and "olive.stl" need to be in the working simulation directory.  
// "olive_xform_SIL.hex" is the hex file containing the 3D transform program the CPU or XCUs execute and "olive.stl" is the 3D object being transformed
// 
// the results of the 3D transform is written to the file "result_trans.stl".  You can view the resulting model using virtually any online .STL file viewer
// the original .stl file must not be greater than 32k bytes, otherwise you will need to modify this testbench to process in more than one chunk at a time.


`timescale 1ns/100ps

module symplyon64_tb();

   reg clk;
   reg reset;


   reg [7:0]  STL_mem8[131071:0];       //8-bit memory initially loaded with .stl file
   
   reg [63:0] STL_mem64[16383:0];       //64-bit memory initially loaded with .stl file

   
   
   reg ready_q1;
   
   reg IRQ;
   
   reg [63:0] out_value, in_value;				// JTAG data register out_value
   reg [7:0]  instr;
 
   reg TCK;		
   reg TMS;
   reg TDI;
   reg TRSTn;
   
   wire TDO;
   
    
   wire all_done;
   
   wire done;
   
   
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
   wire [13:0] Aq;    
   wire [63:0] DQ;    
   wire OE;
      
            
   integer stl_addrs;
   integer i, r, file;
   integer clk_high_time;						// high time for CPU clock	
   integer tck_high_time;                       // high time for JTAG clock
   integer tck_period;
   integer bit_ptr, dr_width, ir_width;  		// bit pointer of data to be scanned 
   
   
   
   //bi-directional databus between CPU and synchronous SRAM
   assign (pull1, pull0) DQ = 64'hFFFF_FFFF_FFFF_FFFF; 
   
   assign Aq = A[16:3]; 
   
//NBT (No Bus Turn Around) Flow Through Mode Synchronous x64-Bit SRAM
RAM64_byte #(.ADDRS_WIDTH(14)) sysMem( //14-bit address by 8 bytes = 16k x 8 bytes = 128k bytes
    .CLK    (clk    ),
    .CEN    (CEN    ),       //clock enable active low
    .CE123  (CE123  ),       //chip enable active high
    .WE     (WE     ),       //active low write enable
    .BWh    (BWh    ),       //active low
    .BWg    (BWg    ),       //active low
    .BWf    (BWf    ),       //active low
    .BWe    (BWe    ),       //active low
    .BWd    (BWd    ),       //active low
    .BWc    (BWc    ),       //active low
    .BWb    (BWb    ),       //active low
    .BWa    (BWa    ),       //active low
    .adv_LD (adv_LD ),       //advance/load
    .A      (Aq     ),       //(dword) address
    .DQ     (DQ     ),       //data in/out (three-state)
    .OE     (OE     )        //active low output enable
);    
   
         
MultiCPU DUT(
    .CLK          (clk    ),
    .RESET_IN     (reset  ),
    .HTCK  (TCK   ),
    .HTRSTn(TRSTn ),
    .HTMS  (TMS   ),
    .HTDI  (TDI   ),
    .HTDO  (TDO   ),

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
    
    .IRQ   (IRQ   )    
    );

//debugger register addresses for access via debug port    
parameter mon_read_addrs_addrs  = 8'h20;
parameter mon_write_addrs_addrs = 8'h21;
parameter mon_write_reg_addrs   = 8'h22; 
parameter mon_read_reg_addrs    = 8'h23;
parameter evnt_cntr_addrs       = 8'h24;   
parameter trigger_A_addrs       = 8'h25;
parameter trigger_B_addrs       = 8'h26;
parameter brk_cntrl_addrs       = 8'h27;
parameter brk_status_addrs      = 8'h28;
parameter trace_newest_addrs    = 8'h30;
parameter trace_1_addrs         = 8'h31;
parameter trace_2_addrs         = 8'h32;
parameter trace_oldest_addrs    = 8'h33;
parameter bypass                = 8'hFF;

//brk_cntrl_reg bit identifiers
parameter PC_EQ_BRKA_en = 6'h08;
parameter PC_EQ_BRKB_en = 6'h07;
parameter PC_GT_BRKA_en = 6'h06;
parameter PC_LT_BRKB_en = 6'h05;
parameter PC_AND_en     = 6'h04;
parameter mon_req       = 6'h03;
parameter sstep         = 6'h02;
parameter frc_brk       = 6'h01;
parameter frc_rst       = 6'h00;

//brk_status_reg bit identifiers
parameter skip_cmplt    = 6'h05;
parameter swbreakDetect = 6'h04;
parameter broke         = 6'h03;
parameter FRCE_BREAK    = 6'h02;
parameter RESET_IN      = 6'h01;
parameter FRCE_RESET    = 6'h00;
                               
parameter byte  = 2'b00;      
parameter hword = 2'b01;      
parameter word  = 2'b10;
parameter dword = 2'b11;
    

reg [63:0] debug_rd_data;

reg [63:0] brk_cntrl_reg;

reg [31:0] triggerA;
reg [31:0] triggerB;

reg [63:0] monitor_rd_data;

assign all_done = done;

assign (pull1, pull0) TDO  = 1'b1;


   initial begin
        clk = 0;
        reset = 1;
        clk_high_time = 5;
		tck_high_time = 2;
		tck_period = 4;
		ir_width = 8;
		dr_width = 64;
        
        TDI     = 1'b1;
        TMS     = 1'b1;
		TCK = 1'b0;
        TRSTn = 1'b0;
                  
        ready_q1       = 1'b1;
        
        IRQ        = 1'b0;
        
        brk_cntrl_reg  = 64'h0000_0000_0000_0000;
        debug_rd_data  = 64'h0000_0000_0000_0000;
        triggerA   = 32'b0;
        triggerB   = 32'b0;

//load program memory with 3D transform program
        file = $fopen("olive_xform_SIL.hex", "rb");   
        r = $fread(STL_mem64, file, 0);       
        $fclose(file);  
        # 1 i = 0;
       
        while(i < 16384) begin
        DUT.u1.CPU.PRAM0.pram0.twoportRAMA[i] = STL_mem64[i];
        DUT.u1.CPU.PRAM0.pram0.twoportRAMB[i] = STL_mem64[i];       
        i = i + 1;
        end
        
        #1

        file = $fopen("olive.stl", "rb");   
//       file = $fopen("small_diamond.stl", "rb"); 
//       file = $fopen("ring.stl", "rb");  

        r = $fread(STL_mem8, file);       // "olive.stl" loaded into 8-bit test bench memory
        $fclose(file);  
        # 1 i = 0;

        
        while(i < 16384) begin
        sysMem.RAM64[i] = {STL_mem8[(i*8)], STL_mem8[(i*8)+1], STL_mem8[(i*8)+2], STL_mem8[(i*8)+3], STL_mem8[(i*8)+4], STL_mem8[(i*8)+5], STL_mem8[(i*8)+6], STL_mem8[(i*8)+7]};
        i = i + 1;
        end
    
         @(posedge clk);
 
         
         #100 reset = 0;
              TRSTn = 1'b1;
         
         #100
    
    
         triggerA   = 20'h001B3;
         SET_TRIGGER_A;
         
         brk_cntrl_reg[PC_EQ_BRKA_en] = 1'b1;
         ENABLE_TRIGGERS;
         
         #1400 IRQ = 1;
         #400 IRQ = 0;

      
         READ_DEBUG_PORT(brk_status_addrs, 64'b0);
         while(~debug_rd_data[broke]) READ_DEBUG_PORT(brk_status_addrs, 64'b0);  // wait for break on CPU to occur
         
         SSTEP;
         SSTEP;
         SSTEP; 
              
         MONITOR_WRITE(32'h00000100, dword, 64'hA5A5_5A5A_A5A5_5A5A);
         MONITOR_READ(32'h00000100, dword);      
     
         RUN_THREADS;  
 
         MONITOR_WRITE(32'h00000100, dword, 64'h600D_FEED_C001_FEED);            
         MONITOR_READ(32'h00000100, dword);    

          
         #1 wait (~all_done);
         #1 wait (all_done);

        # 1 i = 0;
        
        while(i < 16384) begin
        {STL_mem8[(i*8)], STL_mem8[(i*8)+1], STL_mem8[(i*8)+2], STL_mem8[(i*8)+3], STL_mem8[(i*8)+4], STL_mem8[(i*8)+5], STL_mem8[(i*8)+6], STL_mem8[(i*8)+7]} = sysMem.RAM64[i];
        i = i + 1;
        end

 
         stl_addrs = 0;        
         file = $fopen("result_trans.stl", "wb");            
         while(r>0) begin
             $fwrite(file, "%c", STL_mem8[stl_addrs]);
          #1 stl_addrs = stl_addrs + 1;
             r = r - 1;
         end 

        
         #1
         $fclose(file);
         
         $finish;                  
   end 


   
task SET_TRIGGER_A;
    begin
      WRITE_DEBUG_PORT(trigger_A_addrs, triggerA);
    end
endtask

task SET_TRIGGER_B;
    begin
      WRITE_DEBUG_PORT(trigger_B_addrs, triggerB);    
    end
endtask
    
task ENABLE_TRIGGERS;
    begin
        WRITE_DEBUG_PORT(brk_cntrl_addrs, brk_cntrl_reg);
    end
endtask    

task SSTEP;     
    begin
      {brk_cntrl_reg[sstep], brk_cntrl_reg[frc_brk]} = 2'b11;
      WRITE_DEBUG_PORT(brk_cntrl_addrs, brk_cntrl_reg);
      while (~debug_rd_data[skip_cmplt]) READ_DEBUG_PORT(brk_status_addrs,  64'b0);   //wait for CPU to step
      {brk_cntrl_reg[sstep], brk_cntrl_reg[frc_brk]} = 2'b01;
      WRITE_DEBUG_PORT(brk_cntrl_addrs, brk_cntrl_reg);
      @(posedge clk);
      debug_rd_data[3:0] = 4'b0000;
    end   
endtask

    
task RUN_THREADS;  
    begin
      {brk_cntrl_reg[sstep], brk_cntrl_reg[frc_brk]} = 2'b10;
      WRITE_DEBUG_PORT(brk_cntrl_addrs, brk_cntrl_reg);
      @(posedge clk);   
      {brk_cntrl_reg[sstep], brk_cntrl_reg[frc_brk]} = 2'b00;
      WRITE_DEBUG_PORT(brk_cntrl_addrs, brk_cntrl_reg);
    end
endtask

task FORCE_BREAK;   
    begin
      @(posedge clk);
      {brk_cntrl_reg[sstep], brk_cntrl_reg[frc_brk]} = 2'b01;
      WRITE_DEBUG_PORT(brk_cntrl_addrs, brk_cntrl_reg);
    end
endtask    
    
task MONITOR_READ;
    input [31:0] monitor_rd_addrs;
    input  [1:0] monitor_rd_size; 
    begin                                                            //read-from   and  write-to
      WRITE_DEBUG_PORT(mon_read_addrs_addrs, {14'b0, monitor_rd_size, monitor_rd_addrs, 16'hFE00});  //location 16'hFE00 is a monitor read register visible to the debugger h/w
      brk_cntrl_reg[mon_req] = 1'b1;
      WRITE_DEBUG_PORT(brk_cntrl_addrs, brk_cntrl_reg);
      brk_cntrl_reg[mon_req] = 1'b0;
      WRITE_DEBUG_PORT(brk_cntrl_addrs, brk_cntrl_reg);
      READ_DEBUG_PORT(mon_read_reg_addrs, 64'b0);
      monitor_rd_data = debug_rd_data;
    end
endtask
      
task MONITOR_WRITE;
    input [31:0] monitor_wr_addrs;
    input [1:0] monitor_wr_size;
    input [63:0] monitor_wr_data;    
    begin                                           
      WRITE_DEBUG_PORT(mon_write_reg_addrs, monitor_wr_data);   //this is data to be written
                                                    //read-from       and        write-to
      WRITE_DEBUG_PORT(mon_write_addrs_addrs, {14'b0, 16'hFE00, monitor_wr_size, monitor_wr_addrs});  //this specifies 16'hFE00 as the read address and the destination (write) address for the write operation
      brk_cntrl_reg[mon_req] = 1'b1;
      WRITE_DEBUG_PORT(brk_cntrl_addrs, brk_cntrl_reg);
      brk_cntrl_reg[mon_req] = 1'b0;
      WRITE_DEBUG_PORT(brk_cntrl_addrs, brk_cntrl_reg);
    end
endtask

task WRITE_DEBUG_PORT;
    input [7:0] wraddrs;
    input [63:0] wrdata;
    begin
       @(posedge clk);
		instr = wraddrs;			
		shift_ir;						
		out_value = wrdata;
		shift_dr;						
    end
endtask

task READ_DEBUG_PORT;
    input [7:0] rdaddrs;
    input [63:0] wrdata;
    begin
       @(posedge clk);
		instr = rdaddrs;			
		shift_ir;						
		out_value = wrdata;
		shift_dr;						
        debug_rd_data = in_value;
    end
endtask        

task shift_ir;
	begin
 	    @(negedge TCK);
	    #tck_period TMS = 0;		 //Run_Test Idle
		#tck_period TMS = 1;		 //select_dr_scan
		#tck_period TMS = 1;		 //select_ir_scan
		#tck_period TMS = 0;		 //capture_ir
		#tck_period TMS = 0;		 //shift_ir
		load_inst_reg;
		TMS = 1;					 //exit1_ir
		#tck_period TMS = 1;		 //update_ir
		#tck_period TMS = 0;		 //Run_Test Idle
	end
endtask

task load_inst_reg;
	begin
		bit_ptr = 0;
		#tck_high_time;  
		repeat(ir_width)
			begin
			 	@(negedge TCK); 
				TDI = instr[bit_ptr];
				bit_ptr = bit_ptr + 1;
			end
	end
endtask

task shift_dr;
	begin
   		@(negedge TCK);	
 		#tck_period TMS = 1;		//select_dr_scan
		#tck_period TMS = 0;		//capture_dr
		#tck_period TMS = 0;
		load_shift_reg;
		TMS = 1;					//exit1_dr
	  	#tck_period TMS = 1;		//update_dr
		#tck_period TMS = 0;		//Run_test_idle
	end
endtask

task load_shift_reg;
	begin
		bit_ptr = 0;
		begin
		  	 #tck_period;  

			repeat(dr_width)
				begin
					
				  	@(negedge TCK);
	  					TDI = out_value[bit_ptr];
				  	@(posedge TCK);
                        in_value[bit_ptr] = TDO;
	 					bit_ptr = bit_ptr + 1;
				end
 		end
	end
endtask


always #clk_high_time clk = ~clk;

always #tck_high_time TCK = ~TCK;					
        
    
endmodule 

