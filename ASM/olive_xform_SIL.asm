           CPU  "SYMPL64_IL.TBL"
           HOF  "bin32"
           WDLN 8
; SYMPL 64-Bit CPU Demo 3D Transform Micro-Kernel (SYMPL Intermediate Language IL version)
; version 2.01   May 22, 2018
; Author:  Jerry D. Harthcock
; Copyright (C) 2018.  All rights reserved.
; 
; //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
; //                                                                                                                  //
; //                                                Open-Source                                                       //
; //                                        SYMPL 64-Bit OpCodeless CPU                                               //
; //                                Evaluation and Product Development License                                        //
; //                                                                                                                  //
; //                                                                                                                  //
; // Open-source means that this source code may be freely downloaded, copied, modified, distributed and used in      //
; // accordance with the terms and conditons of the licenses provided herein.                                         //
; //                                                                                                                  //
; // Provided that you comply with all the terms and conditions set forth herein, Jerry D. Harthcock ("licensor"),    //
; // the original author and exclusive copyright owner of this SYMPL 64-Bit OpCodeless CPU and related development    //
; // software ("this IP") hereby grants recipient of this IP ("licensee"), a world-wide, paid-up, non-exclusive       //
; // license to implement this IP within the programmable fabric of Xilinx, Intel, MicroSemi or Lattice               //
; // Semiconductor brand FPGAs only and used only for the purposes of evaluation, education, and development of end   //
; // products and related development tools.  Furthermore, limited to the purposes of prototyping, evaluation,        //
; // characterization and testing of implementations in a hard, custom or semi-custom ASIC, any university or         //
; // institution of higher education may have their implementation of this IP produced for said limited purposes at   //
; // any foundary of their choosing provided that such prototypes do not ever wind up in commercial circulation,      //
; // with such license extending to said foundary and is in connection with said academic pursuit and under the       //
; // supervision of said university or institution of higher education.                                               //            
; //                                                                                                                  //
; // Any copying, distribution, customization, modification, or derivative work of this IP must include an exact copy //
; // of this license and original copyright notice at the very top of each source file and any derived netlist, and,  //
; // in the case of binaries, a printed copy of this license and/or a text format copy in a separate file distributed //
; // with said netlists or binary files having the file name, "LICENSE.txt".  You, the licensee, also agree not to    //
; // remove any copyright notices from any source file covered or distributed under this Evaluation and Product       //
; // Development License.                                                                                             //
; //                                                                                                                  //
; // LICENSOR DOES NOT WARRANT OR GUARANTEE THAT YOUR USE OF THIS IP WILL NOT INFRINGE THE RIGHTS OF OTHERS OR        //
; // THAT IT IS SUITABLE OR FIT FOR ANY PURPOSE AND THAT YOU, THE LICENSEE, AGREE TO HOLD LICENSOR HARMLESS FROM      //
; // ANY CLAIM BROUGHT BY YOU OR ANY THIRD PARTY FOR YOUR SUCH USE.                                                   //
; //                                                                                                                  //
; //                                               N O T I C E                                                        //
; //                                                                                                                  //
; // Certain implementations of this IP involving certain floating-point operators may comprise IP owned by certain   //
; // contributors and developers at FloPoCo.  FloPoCo's licensing terms can be found at this website:                 //
; //                                                                                                                  //
; //    http://flopoco.gforge.inria.fr                                                                                //
; //                                                                                                                  //
; // Licensor reserves all his rights, including, but in no way limited to, the right to change or modify the terms   //
; // and conditions of this Evaluation and Product Development License anytime without notice of any kind to anyone.  //
; // By using this IP for any purpose, you agree to all the terms and conditions set forth in this Evaluation and     //
; // Product Development License.                                                                                     //
; //                                                                                                                  //
; // This Evaluation and Product Development License does not include the right to sell products that incorporate     //
; // this IP or any IP derived from this IP. If you would like to obtain such a license, please contact Licensor.     //           
; //                                                                                                                  //
; // Licensor can be contacted at:  SYMPL.gpu@gmail.com                                                               //
; //                                                                                                                  //
; //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
;                                                                                                                     
           
;private dword storage
bitbucket:  EQU     0x0000                   ;this dword location is reserved.  Don't use it for anything because a lot of garbage can wind up here
work_1:     EQU     0x0008                    
work_2:     EQU     0x0010
work_3:     EQU     0x0018
capt0_save: EQU     0x0020                  ;alternate delayed exception capture register 0 save location
capt1_save: EQU     0x0028                  ;alternate delayed exception capture register 1 save location
capt2_save: EQU     0x0030                  ;alternate delayed exception capture register 2 save location
capt3_save: EQU     0x0038                  ;alternate delayed exception capture register 3 save location

;for private storage of parameters for 3D transform                                                                                       
ext_vect_start: EQU     0x0040              ;location in external memory where the first triangle x1 may be found                                
triangles:  EQU     0x0048                  ;storage location of number of triangles in this thread's list to process                                 

;dword storage locations for parameters so it will be easy to change to/from double precision
scaleX:     EQU     0x0050                  ;scale factor X axis
scaleY:     EQU     0x0058                  ;scale factor Y axis
scaleZ:     EQU     0x0060                  ;scale factor Z axis
transX:     EQU     0x0068                  ;translate amount X axis
transY:     EQU     0x0070                  ;translate amount Y axis
transZ:     EQU     0x0078                  ;translate amount Z axis

;word (32-bit) storage for x1, y1, z1, x2, y2, z2, x3, y3, z3 for assembling half-word pieces from little endian external memory file of .stl object
x1:         EQU     0x0080
y1:         EQU     0x0084
z1:         EQU     0x0088
x2:         EQU     0x008C
Y2:         EQU     0x0090
z2:         EQU     0x0094
x3:         EQU     0x0098
y3:         EQU     0x009C
z3:         EQU     0x00A0

XCUs:       EQU     0x00B0                  ;number of XCUs in this implementation
result_buf: EQU     0x00B8                  ;this is start of the buffer where results are stored and then read back out to external memory when processing is complete
remainder_push:  EQU     0x00C0             
remainder_pull:  EQU     0x00C8             

sin_thetaX: EQU     sind.0                  ;sine of theta X for rotate X                                                         
cos_thetaX: EQU     cosd.0                  ;cosine of theta X for rotate X                                                      
sin_thetaY: EQU     sind.1                  ;sine of theta Y for rotate Y                                                        
cos_thetaY: EQU     cosd.1                  ;cosine of theta Y for rotate Y                                                      
sin_thetaZ: EQU     sind.2                  ;sine of theta X for rotate Z                                                        
cos_thetaZ: EQU     cosd.2                  ;cosine of theta X for rotate Z  

PROG_START: EQU     0x80000000              ;CPU and XCU program memory can be indirectly accessed starting here
STL_START:  EQU     0x00100000              ;start location of .stl file in external memory space                                                    
buf_START:  EQU     0x00010000              ;start location of internal tri-port indirectly addressable RAM, which is where the first triangle x1 will be pushed      

            org     0x0              


Constants:  DFL     0, load_vects                   ;entrypoint for this program
        
prog_len:   DFL     0, progend 

;parameters for this particular 3D transform test run
xform_3axis_parameters: 

rotx:       dfl     0, 29                          ;rotate around x axis in integer degrees  
roty:       dfl     0, 44                          ;rotate around y axis in integer degrees  
rotz:       dfl     0, 75                          ;rotate around z axis in integer degrees  
scal_x:     dff     0, 2.0                         ;scale X axis amount real
scal_y:     dff     0, 2.0                         ;scale y axis amount real
scal_z:     dff     0, 2.25                        ;scale Z axis amount real
trans_x:    dff     0, 4.75                        ;translate on X axis amount real
trans_y:    dff     0, 3.87                        ;translate on Y axis amount real
trans_z:    dff     0, 2.237                       ;translate on Z axis amount real
              
;           type    dest = OP:(type:srcA, type:srcB) 

            org     0x00000100                         ;default interrupt vector locations
load_vects: 
            uh      NMI_VECT = uh:#NMI_                ;load of interrupt vectors for faster interrupt response
            uh      IRQ_VECT = uh:#IRQ_                ;these registers are presently not visible to app s/w
            uh      INV_VECT = uh:#INV_
            uh      DIVx0_VECT = uh:#DIVx0_
            uh      OVFL_VECT = uh:#OVFL_
            uh      UNFL_VECT = uh:#UNFL_
            uh      INEXT_VECT = uh:#INEXT_
            
                    enableInt                      
                    
done:               setDone 
            uw      TIMER = uw:#60000                  ;load time-out timer with sufficient time to process before timeout
                    BREAK                              ;just sit here and wait for interrupt or pushXCU PC
                    
begin:              GOSUB threadStart
                    goto done

threadStart:

            sw      *SP--[8] = uw:PC_COPY              ;save return address
            
                     clearDone                         ;to signal host CPU or XCU has started (ie, not done)

            uw       AR0    = uw:result_buf            ;load AR0 with pointer to source/destination internal result buffer for XCU X1 of first triangle
            uw       AR1   =  uw:result_buf             
                     
            fs       sin_thetaX = sind:(uw:@rotx)      ;calculate sine of theta X and save
            fs       cos_thetaX = cosd:(uw:@rotx)      ;calculate cosine of theta X and save                               
            fs       sin_thetaY = sind:(uw:@roty)      ;calculate sine of theta Y and save                                   
            fs       cos_thetaY = cosd:(uw:@roty)      ;calculate cosine of theta Y and save                                   
            fs       sin_thetaZ = sind:(uw:@rotz)      ;calculate sine of theta Z and save                                   
            fs       cos_thetaZ = cosd:(uw:@rotz)      ;calculate cosine of theta Z and save                                   
                                                                                                                             
            fs       scaleX = fs:@scal_x               ;save scale X factor
            fs       scaleY = fs:@scal_y               ;save scale Y factor
            fs       scaleZ = fs:@scal_z               ;save scale Z factor
            fs       transX = fs:@trans_x              ;save translate X axis amount
            fs       transY = fs:@trans_y              ;save translate Y axis amount
            fs       transZ = fs:@trans_z              ;save translate Z axis amount
                   
                    for (LPCNT0 = uh:triangles) (      ;load loop counter 0 with number of triangles 
                    
loop:   ;scale on X, Y, Z axis

                    ;the following routine performs scaling on all three axis first, 
                    ;rotate on all three axis second, then translate on all three axis last 
                              
            ;vertex 1
            fs        FMUL.0 = multiplication:(fs:*AR0++[4], fs:scaleX)
            fs        FMUL.1 = multiplication:(fs:*AR0++[4], fs:scaleY)
            fs        FMUL.2 = multiplication:(fs:*AR0++[4], fs:scaleZ)
            ;vertex 2
            fs        FMUL.3 = multiplication:(fs:*AR0++[4], fs:scaleX)
            fs        FMUL.4 = multiplication:(fs:*AR0++[4], fs:scaleY)
            fs        FMUL.5 = multiplication:(fs:*AR0++[4], fs:scaleZ)
            ;vertex 3
            fs        FMUL.6 = multiplication:(fs:*AR0++[4], fs:scaleX)
            fs        FMUL.7 = multiplication:(fs:*AR0++[4], fs:scaleY)
            fs        FMUL.8 = multiplication:(fs:*AR0++[4], fs:scaleZ)
            
            
;                     X1 is now in FMUL_0         
;                     Y1 is now in FMUL_1         
;                     Z1 is now in FMUL_2         
;                     X2 is now in FMUL_3         
;                     Y2 is now in FMUL_4         
;                     Z2 is now in FMUL_5         
;                     X3 is now in FMUL_6         
;                     Y3 is now in FMUL_7         
;                     Z3 is now in FMUL_8  

  ;rotate around X axis
       ;vertex 1
            ; (cos(xrot) * Y1) - (sin(xrot) * Z1) 
            fs        FMUL.9 = multiplication:(fs:FMUL.1, fs:cos_thetaX)      ; FMUL.9 = (cos(xrot) * Y1)
            fs        FMUL.10 = multiplication:(fs:FMUL.2, fs:sin_thetaX)     ; FMUL.10 = (sin(xrot) * Z1)
            ; (sin(xrot) * Y1) + (cos(xrot) * Z1) 
            fs        FMUL.11 = multiplication:(fs:FMUL.1, fs:sin_thetaX)     ; FMUL.11 = (sin(xrot) * Y1)
            fs        FMUL.12 = multiplication:(fs:FMUL.2, fs:cos_thetaX)     ; FMUL.12 = (cos(xrot) * Z1)
            
            fs        FSUB.0 = subtraction:(fs:FMUL.9, fs:FMUL.10)            ; FSUB.0 = (cos(xrot) * Y1) - (sin(xrot) * Z1)
            fs        FADD.0 = addition:(fs:FMUL.11, fs:FMUL.12)              ; FADD.0 = (sin(xrot) * Y1) + (cos(xrot) * Z1)

       ;vertex 2
            ; (cos(xrot) * Y2) - (sin(xrot) * Z2) 
            fs        FMUL.1 = multiplication:(fs:FMUL.4, fs:cos_thetaX)      ; FMUL.1 = (cos(xrot) * Y2)
            fs        FMUL.2 = multiplication:(fs:FMUL.5, fs:sin_thetaX)      ; FMUL.2 = (sin(xrot) * Z2)
            ; (sin(xrot) * Y2) + (cos(xrot) * Z2) 
            fs        FMUL.13 = multiplication:(fs:FMUL.4, fs:sin_thetaX)     ; FMUL.13 = (sin(xrot) * Y2)
            fs        FMUL.14 = multiplication:(fs:FMUL.5, fs:cos_thetaX)     ; FMUL.14 = (cos(xrot) * Z2)
            
            fs        FSUB.1 = subtraction:(fs:FMUL.1, fs:FMUL.2)             ; FSUB.1 = (cos(xrot) * Y2) - (sin(xrot) * Z2)
            fs        FADD.1 = addition:(fs:FMUL.13, fs:FMUL.14)              ; FADD.1 = (sin(xrot) * Y2) + (cos(xrot) * Z2)

       ;vertex 3
            ; (cos(xrot) * Y3) - (sin(xrot) * Z3) 
            fs        FMUL.9 = multiplication:(fs:FMUL.7, fs:cos_thetaX)      ; FMUL.9 = (cos(xrot) * Y3)
            fs        FMUL.10 = multiplication:(fs:FMUL.8, fs:sin_thetaX)     ; FMUL.10 = (sin(xrot) * Z3)
            ; (sin(xrot) * Y3) + (cos(xrot) * Z3) 
            fs        FMUL.11 = multiplication:(fs:FMUL.7, fs:sin_thetaX)     ; FMUL.11 = (sin(xrot) * Y3)
            fs        FMUL.12 = multiplication:(fs:FMUL.8, fs:cos_thetaX)     ; FMUL.12 = (cos(xrot) * Z3)
            
            fs        FSUB.2 = subtraction:(fs:FMUL.9, fs:FMUL.10)            ; FSUB.2 = (cos(xrot) * Y3) - (sin(xrot) * Z3)
            fs        FADD.2 = addition:(fs:FMUL.11, fs:FMUL.12)              ; FADD.2 = (sin(xrot) * Y3) + (cos(xrot) * Z3)            
            
            ;         X1 is now in FMUL_0
            ;         Y1 is now in FSUB_0
            ;         Z1 is now in FADD_0 
            ;         X2 is now in FMUL_3
            ;         Y2 is now in FSUB_1
            ;         Z2 is now in FADD_1
            ;         X3 is now in FMUL_6
            ;         Y3 is now in FSUB_2
            ;         Z3 is now in FADD_2      

  ;rotate around Y axis
       ;vertex 1
            ; (cos(yrot) * X1) + (sin(yrot) * Z1) 
            fs        FMUL.1 = multiplication:(fs:FMUL.0, fs:cos_thetaY)      ; FMUL.1 = (cos(yrot) * X1)
            fs        FMUL.2 = multiplication:(fs:FADD.0, fs:sin_thetaY)      ; FMUL.2 = (sin(yrot) * Z1)
            ; (cos(yrot) * Z1) - (sin(yrot) * X1)
            fs        FMUL.4 = multiplication:(fs:FADD.0, fs:cos_thetaY)      ; FMUL.4 = (cos(xrot) * Z1)
            fs        FMUL.5 = multiplication:(fs:FMUL.0, fs:sin_thetaY)      ; FMUL.5 = (sin(xrot) * X1)
            
            fs        FADD.3 = addition:(fs:FMUL.1, fs:FMUL.2)                ; FADD.3 = (cos(yrot) * X1) + (sin(yrot) * Z1)
            fs        FSUB.3 = subtraction:(fs:FMUL.4, fs:FMUL.5)             ; FSUB.3 = (cos(yrot) * Z1) - (sin(yrot) * X1)
       ;vertex 2
            ; (cos(yrot) * X2) + (sin(yrot) * Z2) 
            fs        FMUL.7 = multiplication:(fs:FMUL.3, fs:cos_thetaY)      ; FMUL.7 = (cos(yrot) * X2)
            fs        FMUL.8 = multiplication:(fs:FADD.1, fs:sin_thetaY)      ; FMUL.8 = (sin(yrot) * Z2)
            ; (cos(yrot) * Z2) - (sin(yrot) * X2)
            fs        FMUL.9 = multiplication:(fs:FADD.1, fs:cos_thetaY)      ; FMUL.9 = (cos(xrot) * Z2)
            fs        FMUL.10 = multiplication:(fs:FMUL.3, fs:sin_thetaY)     ; FMUL.10 = (sin(xrot) * X2)
            
            fs        FADD.4 = addition:(fs:FMUL.7, fs:FMUL.8)                ; FADD.4 = (cos(yrot) * X2) + (sin(yrot) * Z2)
            fs        FSUB.4 = multiplication:(fs:FMUL.9, fs:FMUL.10)         ; FSUB.4 = (cos(yrot) * Z2) - (sin(yrot) * X2)
            
       ;vertex 3
            ; (cos(yrot) * X3) + (sin(yrot) * Z3) 
            fs        FMUL.11 = multiplication:(fs:FMUL.6, fs:cos_thetaY)     ; FMUL.11 = (cos(yrot) * X3)
            fs        FMUL.12 = multiplication:(fs:FADD.2, fs:sin_thetaY)     ; FMUL.12 = (sin(yrot) * Z3)
            
            ; (cos(yrot) * Z3) - (sin(yrot) * X3)
            fs        FMUL.13 = multiplication:(fs:FADD.2, fs:cos_thetaY)     ; FMUL.13 = (cos(xrot) * Z3)
            fs        FMUL.14 = multiplication:(fs:FMUL.6, fs:sin_thetaY)     ; FMUL.14 = (sin(xrot) * X3)
            
            fs        FADD.5 = addition:(fs:FMUL.11, fs:FMUL.12)              ; FADD.5 = (cos(yrot) * X3) + (sin(yrot) * Z3)
            fs        FSUB.5 = subtraction:(fs:FMUL.13, fs:FMUL.14)           ; FSUB.5 = (cos(yrot) * Z3) - (sin(yrot) * X3)  
            
            ;         X1 is now in FADD_3
            ;         Y1 is now in FSUB_0
            ;         Z1 is now in FSUB_3
            ;         X2 is now in FADD_4
            ;         Y2 is now in FSUB_1
            ;         Z2 is now in FSUB_4
            ;         X3 is now in FADD_5
            ;         Y3 is now in FSUB_2 
            ;         Z3 is now in FSUB_5                      

  ;rotate around Z axis
       ;vertex 1
            ; (cos(zrot) * X1) - (sin(zrot) * Y1) 
            fs        FMUL.0 = multiplication:(fs:FADD.3, fs:cos_thetaZ)      ; FMUL.0 = (cos(zrot) * X1)
            fs        FMUL.1 = multiplication:(fs:FSUB.0, fs:sin_thetaZ)      ; FMUL.1 = (sin(xrot) * Y1)
            ; (sin(zrot) * X1) + (cos(zrot) * Y1) 
            fs        FMUL.2 = multiplication:(fs:FADD.3, fs:sin_thetaZ)      ; FMUL.2 = (sin(xrot) * X1)
            fs        FMUL.3 = multiplication:(fs:FSUB.0, fs:cos_thetaZ)      ; FMUL.3 = (cos(xrot) * Y1)
            
            fs        FSUB.6 = subtraction:(fs:FMUL.0, fs:FMUL.1)             ; FSUB.6 = (cos(zrot) * X1) - (sin(zrot) * Y1)
            fs        FADD.6 = addition:(fs:FMUL.2, fs:FMUL.3)                ; FADD.6 = (sin(zrot) * X1) + (cos(zrot) * Y1)

       ;vertex 2
            ; (cos(zrot) * X2) - (sin(zrot) * Y2) 
            fs        FMUL.4 = multiplication:(fs:FADD.4, fs:cos_thetaZ)      ; FMUL.4 = (cos(zrot) * X1)
            fs        FMUL.5 = multiplication:(fs:FSUB.1, fs:sin_thetaZ)      ; FMUL.5 = (sin(xrot) * Y1)
            ; (sin(zrot) * X2) + (cos(zrot) * Y2) 
            fs        FMUL.6 = multiplication:(fs:FADD.4, fs:sin_thetaZ)      ; FMUL.6 = (sin(xrot) * X2)
            fs        FMUL.7 = multiplication:(fs:FSUB.1, fs:cos_thetaZ)      ; FMUL.7 = (cos(xrot) * Y2)
            
            fs        FSUB.7 = subtraction:(fs:FMUL.4, fs:FMUL.5)             ; FSUB.7 = (cos(zrot) * X2) - (sin(zrot) * Y2)
            fs        FADD.7 = addition:(fs:FMUL.6, fs:FMUL.7)                ; FADD.7 = (sin(zrot) * X2) + (cos(zrot) * Y2)

       ;vertex 3
            ; (cos(zrot) * X3) - (sin(zrot) * Y3) 
            fs        FMUL.8 = multiplication:(fs:FADD.5, fs:cos_thetaZ)      ; FMUL.8 = (cos(zrot) * X3)
            fs        FMUL.9 = multiplication:(fs:FSUB.2, fs:sin_thetaZ)      ; FMUL.9 = (sin(xrot) * Y3)
            ; (sin(zrot) * X3) + (cos(zrot) * Y3)   
            fs        FMUL.10 = multiplication:(fs:FADD.5, fs:sin_thetaZ)     ; FMUL.10 = (sin(xrot) * X3)
            fs        FMUL.11 = multiplication:(fs:FSUB.2, fs:cos_thetaZ)     ; FMUL.11 = (cos(xrot) * Y3)
            
            fs        FSUB.8 = subtraction:(fs:FMUL.8, fs:FMUL.9)             ; FSUB.8 = (cos(zrot) * X3) - (sin(zrot) * Y3)
            fs        FADD.8 = addition:(fs:FMUL.10, fs:FMUL.11)              ; FADD.8 = (sin(zrot) * X3) + (cos(zrot) * Y3)            
            
            ;         X1 is now in FSUB.6
            ;         Y1 is now in FADD.6
            ;         Z1 is now in FSUB.3
            ;         X2 is now in FSUB.7
            ;         Y2 is now in FADD.7
            ;         Z2 is now in FSUB.4
            ;         X3 is now in FSUB.8
            ;         Y3 is now in FADD.8
            ;         Z3 is now in FSUB.5
       
    ;now translate on X, Y, Z axis
        ;vertex 1
            fs        FADD.0 = addition:(fs:FSUB.6, fs:transX)     
            fs        FADD.1 = addition:(fs:FADD.6, fs:transY)     
            fs        FADD.2 = addition:(fs:FSUB.3, fs:transZ)     
        ;vertex 2
            fs        FADD.9 = addition:(fs:FSUB.7, fs:transX)     
            fs        FADD.10 = addition:(fs:FADD.7, fs:transY)     
            fs        FADD.11 = addition:(fs:FSUB.4, fs:transZ)     
        ;vertex 3
            fs        FADD.12 = addition:(fs:FSUB.8, fs:transX)     
            fs        FADD.13 = addition:(fs:FADD.8, fs:transY)     
            fs        FADD.14 = addition:(fs:FSUB.5, fs:transZ)     

            fs        *AR1++[4] = fs:FADD.0         ;copy transformed X1 to alignable memory
            fs        *AR1++[4] = fs:FADD.1         ;copy transformed Y1 to alignable memory
            fs        *AR1++[4] = fs:FADD.2         ;copy transformed Z1 to alignable memory
            fs        *AR1++[4] = fs:FADD.9         ;copy transformed X2 to alignable memory
            fs        *AR1++[4] = fs:FADD.10        ;copy transformed Y2 to alignable memory
            fs        *AR1++[4] = fs:FADD.11        ;copy transformed Z2 to alignable memory
            fs        *AR1++[4] = fs:FADD.12        ;copy transformed X3 to alignable memory
            fs        *AR1++[4] = fs:FADD.13        ;copy transformed Y3 to alignable memory
            fs        *AR1++[4] = fs:FADD.14        ;copy transformed Z3 to alignable memory 

                    NEXT LPCNT0 GOTO: loop)        ;continue until done
                    nop
            uw      PC = uw:*SP++[8]                ;return

; interrupt/exception trap service routines            
NMI_:       sw      *SP--[8] = uw:PC_COPY           ;save return address from non-maskable interrupt (time-out timer in this instance)
            uw      TIMER = uw:#60000               ;put a new value in the timer
                    nop
            sw      PC = uw:*SP++[8]                ;return from interrupt
              
INV_:       sw      *SP--[8] = uw:PC_COPY           ;save return address from floating-point invalid operation exception, which is maskable
            ud      capt0_save = ud:CAPTURE0        ;read out CAPTURE0 register and save it
            ud      capt1_save = ud:CAPTURE1        ;read out CAPTURE1 register and save it
            ud      capt2_save = ud:CAPTURE2        ;read out CAPTURE2 register and save it
            ud      capt3_save = ud:CAPTURE3        ;read out CAPTURE3 register and save it
                    lowerSignals(ub:#invalid)       ;lower invalid signal
                    raiseFlags(ub:#invalid)         ;raise invalid flag   
            uw      TIMER = uw:#60000               ;put a new value in the timer
            sw      PC = uw:*SP++[8]                ;return from interrupt
               
DIVx0_:     sw      *SP--[8] = uw:PC_COPY           ;save return address from floating-point divide by 0 exception, which is maskable
            ud      capt0_save = ud:CAPTURE0        ;read out CAPTURE0 register and save it
            ud      capt1_save = ud:CAPTURE1        ;read out CAPTURE1 register and save it
            ud      capt2_save = ud:CAPTURE2        ;read out CAPTURE2 register and save it
            ud      capt3_save = ud:CAPTURE3        ;read out CAPTURE3 register and save it
                    lowerSignals(ub:#divByZero)     ;lower divByZero signal
                    raiseFlags(ub:#divByZero)       ;raise divByZero flag   
            uw      TIMER = uw:#60000               ;put a new value in the timer
            sw      PC = uw:*SP++[8]                ;return from interrupt
               
OVFL_:      sw      *SP--[8] = uw:PC_COPY           ;save return address from floating-point overflow exception, which is maskable
            ud      capt0_save = ud:CAPTURE0        ;read out CAPTURE0 register and save it
            ud      capt1_save = ud:CAPTURE1        ;read out CAPTURE1 register and save it
            ud      capt2_save = ud:CAPTURE2        ;read out CAPTURE2 register and save it
            ud      capt3_save = ud:CAPTURE3        ;read out CAPTURE3 register and save it
                    lowerSignals(ub:#overflow)      ;lower overflow signal
                    raiseFlags(ub:#overflow)        ;raise overflow flag   
            uw      TIMER = uw:#60000               ;put a new value in the timer
            sw      PC = uw:*SP++[8]                ;return from interrupt
               
UNFL_:      sw      *SP--[8] = uw:PC_COPY           ;save return address from floating-point underflow exception, which is maskable
            ud      capt0_save = ud:CAPTURE0        ;read out CAPTURE0 register and save it
            ud      capt1_save = ud:CAPTURE1        ;read out CAPTURE1 register and save it
            ud      capt2_save = ud:CAPTURE2        ;read out CAPTURE2 register and save it
            ud      capt3_save = ud:CAPTURE3        ;read out CAPTURE3 register and save it
                    lowerSignals(ub:#underflow)     ;lower underflow signal
                    raiseFlags(ub:#underflow)       ;raise underflow flag   
            uw      TIMER = uw:#60000               ;put a new value in the timer
            sw      PC = uw:*SP++[8]                ;return from interrupt
               
INEXT_:     sw      *SP--[8] = uw:PC_COPY           ;save return address from floating-point inexact exception, which is maskable
            ud      capt0_save = ud:CAPTURE0        ;read out CAPTURE0 register and save it
            ud      capt1_save = ud:CAPTURE1        ;read out CAPTURE1 register and save it
            ud      capt2_save = ud:CAPTURE2        ;read out CAPTURE2 register and save it
            ud      capt3_save = ud:CAPTURE3        ;read out CAPTURE3 register and save it
                    lowerSignals(ub:#inexact)       ;lower inexact signal
                    raiseFlags(ub:#inexact)         ;raise inexact flag   
            uw      TIMER = uw:#60000               ;put a new value in the timer
            sw      PC = uw:*SP++[8]                ;return from interrupt
            
IRQ_XCU:    sw      *SP--[8] = uw:PC_COPY           ;save return address (general-purpose, maskable interrupt)
            uw      TIMER = uw:#60000               ;put a new value in the timer
                    nop
            sw      PC = uw:*SP++[8]                ;return from interrupt  
            
thread_end:            
            
               
IRQ_:       sw      *SP--[8] = uw:PC_COPY

                    clearDone     
                                                                           
push_thread:  
                    forceReset(uh:#{XCU15 | XCU14 | XCU13 | XCU12 | XCU11 | XCU10 | XCU9 | XCU8 | XCU7 | XCU6 | XCU5 | XCU4 | XCU3 | XCU2 | XCU1 | XCU0})
                    forceBreak(uh:#{XCU15 | XCU14 | XCU13 | XCU12 | XCU11 | XCU10 | XCU9 | XCU8 | XCU7 | XCU6 | XCU5 | XCU4 | XCU3 | XCU2 | XCU1 | XCU0})
                    forceReset(uh:#0)         ;release all target XCU resets.  Note that releasing reset does not affect forceBreak

                    ;at this point all XCUs should be in h/w break state doing absolutely nothing

            uw      AR5 = uw:@prog_len
            
            uw      AR0 = uw:#0x80000000                   ;load AR0 with pointer to location of beginning of thread to be pushed into XCU program memories
                                                           ;be sure to set MSB of pointer to access program memory indirecly
            uw      AR1 = uw:#0x80000000                   ;place the thread starting at 0x00000000 in XCU program memory (setting MSB of address)
                                                           ;forces data to be written to program memory instead of data memory
                    REPEAT [AR5]                           ;push the the 3D transform thread into each XCU program memory--simultaneously
                        pushAll ud:*AR1++[1], ud:*AR0++[1] ;the entire thread is pushed into XCU using this instruction sequence

            uw      AR0 = uw:#STL_START                    ;load AR0 with address of external RAM location where raw STL file begins
            uw      ext_vect_start = uw:#STL_START + 96    ;this is the location of the first triangle X1 in external RAM
            uw      result_buf = uw:#buf_START
            sw      triangles = uw:*AR0[80]                ;set destination sign extend bit to signal reverse endian-ness and get number of triangles



_16_XCUs:           if (ud:XCU_STATUS_REG:[bit63]==0) GOTO: _8_XCUs     ;test DONE bit for XCU15
            ub      XCUs   = ub:#16
                    goto push_XCUs

_8_XCUs:            if (ud:XCU_STATUS_REG:[bit55]==0) GOTO: _4_XCUs     ;test DONE bit for XCU7
            ub      XCUs   = ub:#8
                    goto push_XCUs

_4_XCUs:            if (ud:XCU_STATUS_REG:[bit51]==0) GOTO: _2_XCUs     ;test DONE bit for XCU3
            ub      XCUs   = ub:#4
                    goto push_XCUs

_2_XCUs:            if (ud:XCU_STATUS_REG:[bit49]==0) GOTO: _1_XCU      ;test DONE bit for XCU1
            ub      XCUs   = ub:#2
                    goto push_XCUs

_1_XCU:             if (ud:XCU_STATUS_REG:[bit48]==0) GOTO: NO_XCUs     ;test DONE bit for XCU0
            ub      XCUs   = ub:#1
                    goto push_XCUs
                    
NO_XCUs:    ub      XCUs = ub:#0
                    GOTO solo_process  ;the CPU has to do the 3D transform solo

                    
push_XCUs:
            uw      AR3 = uw:#load_vects                          ;each XCU PC will be initialized to begin executing here
            uw      AR4 = uw:#begin                               ;this is the PC address from which all threads begin processing (ie, exit out of SW break)

            uw      work_1 = uh:#{XCU_MON_REQUEST}                ;get base address of pushXCU operator
            uw      add.0  = add:(uw:work_1, ub:XCUs)             ;add number of XCUs to get most significant address +1
            uw      div.0  = div:(uw:triangles, ub:XCUs)          ;div.0 now contains number of triangles per XCU (not counting any remainder)
            uw      mul.0  = mul:(uw:div.0, ub:XCUs)              ;determine any remainder
            uw      sub.0  = sub:(uw:triangles, uw:mul.0)         ;sub.0 now contains any remainder
            uw      remainder_push = uw:sub.0                     ;copy result of remainder calc into remainder so it can be used later
            uw      remainder_pull = uw:sub.0                     ;copy result of remainder calc into remainder so it can be used later

                    pushAll uw:PC, uw:AR3                         ;preset PCs of all XCUs at once to point to entrypoint of initialization sequence
                    pushAll uw:result_buf, uw:result_buf          ;push the location of the beginning of XCU input/result buffer 

            uw      AR2    = uh:add.0                             ;current XCU base address for that XCU 
            uw      AR1 = uw:ext_vect_start                       ;address in external RAM of where the first triangle X1 is located
                    
                    for (LPCNT1 = uh:XCUs) (                      ;for the number of XCUs ... 
push_outer:                              
            uh          0x0000 = uh:*AR2--[1]                     ;bumb by -1 XCU number
            uw          AR0    = uw:result_buf                    ;load AR0 with pointer to destination result buffer for XCU X1 of first triangle

            uw          add.1 = add:(uw:div.0, uw:#0)             ;copy calculated triangles/XCUs  into add.1 for future use

                        compare(uw:remainder_push, uh:#0x0)       ;see if there was any remainder from original triangles/XCU calculation
                        IF (A==B) GOTO: no_remainder_push         ;if no remainder, skip over a push of one more triangle for the current XCU

            uw          sub.0  = sub:(uw:remainder_push, ub:#1)   ;decrement any remainder by 1        
            uw          add.1 = add:(uw:div.0, uw:#1)             ;add.1 now contains the number of triangles this particular XCU is to process
            uw          remainder_push = uw:sub.0

no_remainder_push:
                        pushXCU *AR2++[0]:uh:triangles, uh:add.1 ;poke the triangle batch size for this XCU into its "trangles" location

                        for (LPCNT0 = uh:add.1) (                 ;for the number of triangles per XCU ...
push_inner:                 REPEAT    uh:#17                      ;push 18 half-words into target XCU (for a total of 9 32-bit floats per triangle)    
                                pushXCU.endi *AR2++[0]:uh:*AR0++[2], uh:*AR1++[2]  ;reverse endian-ness just before push (AR2 contains the current XCU number)
            uh              0x0000  = uh:*AR1++[14]               ;bump source pointer by 14 to skip over .STL attribute and NORM fields
                        NEXT LPCNT0 GOTO: push_inner)             ;decrement and jump if result not zero
push_next_XCU:
                    NEXT LPCNT1 GOTO: push_outer)                 ;decrement number of XCUs in LPCNT0 and jump if not zero

                    forceBreak(uh:#0)                             ;clear all h/w breakpoints
                    sstep(uh:#{XCU15 | XCU14 | XCU13 | XCU12 | XCU11 | XCU10 | XCU9 | XCU8 | XCU7 | XCU6 | XCU5 | XCU4 | XCU3 | XCU2 | XCU1 | XCU0})
                    sstep(uh:#0)                                  ;each XCU must be single-stepped out of a h/w break to begin running freely
                    
                    ;like the CPU before it was interrupted to invoke this process, the XCU's will now encounter a "s/w" breakpoint
                    ;at which point the CPU will change their PC's to threadStart to begin processing
                    
waitForXCUbreak0:   if (ud:XCU_STATUS_REG:[bit32]==0) GOTO: waitForXCUbreak0  ;wait for XCU_0 to hit s/w breakpoint
                    nop                                                       ;since push and pull ops occur immediatly, two nops must be inserted to prevent triggering if branch taken
                    nop
                    pushAll uw:PC, uw:AR4                                     ;push "begin" into all XCU PCs simultaneously
                    sstep(uh:#{XCU15 | XCU14 | XCU13 | XCU12 | XCU11 | XCU10 | XCU9 | XCU8 | XCU7 | XCU6 | XCU5 | XCU4 | XCU3 | XCU2 | XCU1 | XCU0})
                    sstep(uh:#0)                                              ;each XCU must be single-stepped out of a h/w break to begin running freely

waitForNotDone0:    if (ud:XCU_STATUS_REG:[bit48]==1) GOTO: waitForNotDone0   ;wait for XCU_0 to bring its DONE bit low, indicating processing has started
                    ;
                    ;  XCUs are busy processing here
                    ;
waitForDone0:       if (ud:XCU_STATUS_REG:[bit48]==0) GOTO: waitForDone0      ;wait for XCU_0 to bring its DONE bit high, indicating completion
                    ;
                    ;  now that XCU0 is done processing its triangles, it's time to start pull them out and pushing them
                    ;  back into external memory
                    ;
            uw      AR2 = uh:add.0                              ;previously calculated current XCU base address for that XCU 
            uw      AR1 = uw:ext_vect_start                     ;address in external RAM of where the first triangle X1 is located
                    for (LPCNT1 = uh:XCUs) (                    ;for the number of XCUs ... 
pull_outer:
            uh          0x0000 = uh:*AR2--[1]                   ;bumb by -1 XCU number
            uw          AR0 = uw:result_buf                     ;load AR0 with pointer to destination result buffer for XCU X1 of first triangle
            uw          add.1 = add:(uw:div.0, uw:#0)           ;copy calculated triangles/XCUs  into add.1 for future use

                        compare(uw:remainder_pull, uh:#0x0)     ;see if there was any remainder from original triangles/XCU calculation
                        IF (A==B) GOTO: no_remainder_pull       ;if no remainder, skip over a push of one more triangle for the current XCU

            uw          sub.0  = sub:(uw:remainder_pull, ub:#1) ;decrement any remainder by 1        
            uw          add.1 = add:(uw:div.0, uw:#1)           ;add.1 now contains the number of triangles this particular XCU is to process
            uw          remainder_pull = uw:sub.0

no_remainder_pull:                              
                        for (LPCNT0 = uh:add.1) (               ;for the number of triangles per XCU ...
pull_inner:                 REPEAT    uh:#17                    ;push 18 half-words into target XCU (for a total of 9 32-bit floats per triangle)    
                                pullXCU.endi  uh:*AR1++[2], *AR2++[0]:uh:*AR0++[2]  ;reverse endian-ness just before pull (AR2 contains the current XCU number)
                            nop
                            nop
            uh              0x0000  = uh:*AR1++[14]             ;bump source pointer by 14 to skip over .STL attribute and NORM fields
                        NEXT LPCNT0 GOTO: pull_inner)

pull_next_XCU: 
                    NEXT LPCNT1 GOTO: pull_outer)
                    setDone
            sw      PC = uw:*SP++[8]                            ;return from interrupt--we are done
                      
solo_process:
            uw      AR0 = uw:#STL_START                         ;load AR0 with address of external RAM location where raw STL file begins
            uw      ext_vect_start = uw:#STL_START + 96         ;this is the location of the first triangle X1 in external RAM
            sw      triangles = uw:*AR0[80]                     ;set destination sign extend bit to signal reverse endian-ness and get number of triangles
            uw      AR0 = uw:#buf_START                         ;load AR0 with pointer to destination result buffer for XCU X1 of first triangle
            uw      AR1 = uw:ext_vect_start                     ;address in external RAM of where the first triangle X1 is located
                    for (LPCNT0 = uh:triangles) (               ;pull triangles in from external memory into internal working memory  
pull_solo:              REPEAT    uh:#17                   
            sh              *AR0++[2] = uh:*AR1++[2]            ;reverse endian-ness just before push (by setting destination sign extend bit (ie, "sh")
            uh          0x0000  = uh:*AR1++[14]                 ;bump source pointer by 14 to skip over .STL attribute and NORM fields
                    NEXT LPCNT0 GOTO: pull_solo)
                    
                    gosub threadStart                           ;compute the transform of entire 3D object--solo 
                    nop
            uw      AR1 = uw:ext_vect_start
            uw      AR0 = uw:#buf_START    

                    for (LPCNT0 = uh:triangles) (               ;push computed transform result back out to external memory
push_solo:              REPEAT    uh:#17                  
            sh              *AR1++[2] = uh:*AR0++[2] 
                        nop
                        nop         
            uh          0x0000  = uh:*AR1++[14]           
                    NEXT LPCNT0 GOTO: push_solo)
                    setDone
            sh      PC = uh:*SP++[8]                       
                       
progend:        
            end
          
    
