![](https://github.com/jerry-D/IEEE-754-2008_ISA_CPU/blob/master/images/SYMPL_CPU_LOGO.png)

![](https://github.com/jerry-D/IEEE-754-2008_ISA_CPU/blob/master/images/SYMPL_CPU_LOGO.png)

(August 2, 2018) Alpha release of the SYMPL 64-bit, IEEE 754-2008 ISA single and multi-core CPU that efficiently implements in hardware “all” operations mandated by IEEE 754-2008 using one instruction per operation.   Much more efficient than conventional “load-store” models, it can push two 64-bit operands into an operator, whether it be floating point, integer or logical, every clock cycle, with results automatically spilling into one of sixteen memory-mapped result buffers dedicated to that operator.  

For a quick look at the various configurations of   SYMPL 64-bit, IEEE 754-2008 ISA single and multi-core CPU, download this poster-sized preliminary information sheet:

https://github.com/jerry-D/IEEE-754-2008_ISA_CPU/blob/master/IEEE_754_2008_ISA_poster.pdf

Immediately below is a block diagram of the seventeen-core version.

![](https://github.com/jerry-D/IEEE-754-2008_ISA_CPU/blob/master/images/seventeen_CPUs.png)

All you have to do to configure for one, two, three, five or nine cores, simply remove comments from the desired module instantiation in the “MultiCPU.v” file in the RTL folder as follows:

``` 
//CPU_HAS_NO_XCUs u1(
//CPU_HAS_1_XCU  u1(
//CPU_HAS_2_XCUs  u1(
CPU_HAS_4_XCUs  u1(
//CPU_HAS_8_XCUs  u1(
//CPU_HAS_16_XCUs u1(
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
    .IRQ   (IRQ   )
    );
```

The demo 3D transform program the CPU executes automatically figures out how many XCUs are connected to the CPU and evenly distributes triangles comprising the 3D object among them for processing.

This instruction-set comprises features not available on conventional “load-store” models. For instance, it includes both direct and indirect addressing modes, the later with either auto-post-increment/decrement (by up to 2047 bytes, or fixed displacement/offset by up to 1023 bytes).  In addition, it features at least two very efficient hardware loop counters and repeat counters.  When used in combination with auto-post increment/decrement indirect addressing mode, the REPEAT instruction is a powerful and efficient means for moving or pushing large chunks of data into any of the core's pipelined operators or block of memory much more efficiently than means available for doing the same thing in conventional load-store models, in that no extra cycles are needed to modify source or destination pointers after each read or write operation.

This IEEE 754-2008 ISA CPU, and any eXtension Compute Units (XCUs) attached to it, supports binary16, binary32 and binary64 floating-point formats to the base range and precision of the installed floating-point operators.  Meaning that, since the instruction format includes two “size” bits for each of the SourceA, SourceB and Destination address fields of the instruction, no explicit conversion is necessary for computations involving mixed formats, as results automatically inherit conversion exceptions.  For stricter handling, numbers can of course be converted explicitly before submission to the operator. 

Stated simply, the Universal IEEE 754-2008 Floating-Point ISA CPU is a ready and easy to use, “canned” hardware implementation of the IEEE 754-2008 specification.  Meaning, there is just one instruction per operation, which includes (among many others):  fusedMultiplyAdd, remainder, convertFromDecimalCharacter, convertToDecimalCharacter, nextUp, nextDown, pow, powr, pown.  Not only that, but it also supports alternate exception handling, including exception capture registers, in hardware.

As required by IEEE 754-2008, half-precision subnormal numbers are also now fully supported, meaning that all floating-point computational operators can accept and produce subnormal numbers as input or as a result of computation, allowing generation and propagation of gradual underflow in a computational stream as required for specification compliance.

All specified default and directed rounding modes (nearest, positive/negative infinity, zero and away) are now fully supported by way of a rounding mode attribute field in the status register.  Alternatively, when no rounding mode attribute is set, the rounding mode can be specified on-the-fly within the instruction.  The default rounding mode "00" is "nearest".  However, the directed rounding mode attribute enable bit in the status register, if set, overrides any specified in the instruction.

At this repository you will find all the synthesizable Verilog and VHDL source code needed to simulate and synthesize the instant  64-bit IEEE 754-2008 ISA CPU.  

This design was developed using the “free” version of Xilinx Vivado, version 2018, targeted to a Kintex UltraScale+, -3 speed grade.  To obtain a copy of the latest version of Vivado, visit Xilinx' website at www.Xilinx.com .

After place and route, it was determined that this 64-bit design will clock at roughly 100MHz in a Kintex UltraScale+  without constraints of any kind except for specifying what pin to use as the clock and at what clock rate.  Most of the delays are attributed to routing and not logic propagation delays. 

The instant design incorporates several FloPoCo 6-bit exponent, 10-bit fraction operators modified and adapted for fully compliant operations.   If you would like to change Emulator core operators to increase range/precision, visit FloPoCo's website at:

http://flopoco.gforge.inria.fr

There you will find everything you need to generate virtually any kind of floating-point operator and many others.

For more information regarding the FloPoCo library and generator, read the article at the link provided below:
Florent de Dinechin and Bogdan Pasca.  Designing custom arithmetic data paths with FloPoCo.  IEEE Design & Test of Computers, 28(4):18—27, July 2011.

http://perso.citi-lab.fr/fdedinec/recherche/publis/2011-DaT-FloPoCo.pdf

The simplest way to increase range and/or precision, is to use the existing operator wrappers as templates.  Care should be taken to properly adjust the number of “delay” registers to correspond to the latency of the substituted operator.  For instance, single-precision will generally require more stages than half-precision, with double-precision requiring even more.

### SYMPL 64-bit IEEE 754-2008  CPU ISA
Also at this repository you will find the SYMPL 64-bit IEEE 754-2008  CPU ISA instruction table that can be used with “CROSS-32” Universal Cross-Assembler to compile the example multi-core 3D-transform thread used in the example simulation.   The instruction table can be found in the ASM folder at this repository.  A detailed wiki for the Universal IEEE 754-2008 ISA CPU basic architecture and instruction set is being developed, which will take some time.  In the meantime, for a basic description instruction formatting, refer to the instruction table.

To obtain a copy of CROSS-32, visit Data-Sync Engineering's website: 

http://www.cdadapter.com/cross32.htm
sales@datasynceng.com

A copy of the Cross-32 manual can be viewed online here: 

http://www.cdadapter.com/download/cross32.pdf

### Real-Time Debug On-Chip

Additionally, this design comes with on-chip JTAG debug capability. The CPU has h/w breakpoints with programmable pass-counters, single-steps, 4-level deep PC discontinuity trace buffer, and real-time data exchange/monitoring.  CPU registers can be read and modified in real-time without affecting ongoing processes. The CPU and or any XCUs connected to it can be independently or simultaneously breakpointed, single-stepped or released. Presently all this is done through an IEEE 1149-1 (JTAG) interface.  The test bench provided at this repository has examples of breakpoints, single-steps, etc.

For more information on how to use the debug feature, study the test bench in the stimulus folder at this repository.

### Simulating the SYMPL 64-Bit  IEEE 754-2008 Floating-Point ISA CPU Design

The example test case takes a 3D representation of an olive in single-precision binary .stl file format and performs a 3D transformation on all three axis, which includes:  scale(x, y, z), rotate(x, y, x) and translate(x, y, z).   The “olive” was created using the OpenSCAD, free open source 3D modeling environment and was exported in ASCII .stl file format.  To convert to binary, the “olive.stl” file was imported into “Blender”, free open source 3D modeling environment, and immediately exported back to .stl format, which, for Blender, is binary format.  Below is the “before” and “after” 3D rendering of the olive as viewed with OpenSCAD.  Note that the number of faces were kept to a minimum to facilitate faster simulation.

The “Olive” Before and After

![](https://github.com/jerry-D/SYMPL-FP324-AXI4-GP-GPU/blob/master/olive_trans_both.gif.gif)

To run this simulation using Vivado, download or clone the SYMPL IEEE 754-2008 Floating-Point ISA CPU design in this repository.   All the files you need to run the 3D transformation of the “olive” in the simulation and ASM files.  For the simulation, you need to make sure that “threeD_xform_SIL.HEX” is in the Vivado simulation working directory, which is presently automatically loaded into the external system memory in the test-bench. 

The other file that you need to run this simulation is the “olive.stl” file, which also needs to be in the working simulation directory.  It's a very coarse representation of the olive to keep number of triangles down to keep simulation time down to reasonable minimum.  There are a couple other 3D objects in .stl file format located in the STL folder that you can run using the same setup.  Resulting 3D transformations will be written in .stl binary format to the Vivado .sim/behav directory under the file name, “result_trans.stl”.  You can view the transformed result using any online .stl file viewer, including the one at GitHub.

### Technical Support
If you need assistance setting up your simulation, answers to pertinent technical questions, assistance customizing or modifying this design for your application, please don't hesitate to direct them at me here:  sympl.gpu@gmail.com


