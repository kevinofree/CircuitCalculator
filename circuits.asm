;Author Information
;  Author name: Kevin Ochoa
;  Author email: ochoakevinm@gmail.com
;Project Information
;  Project title: Four-Device Circuit Calculator
;  Purpose: This program calculates the current, total current, and total power of a parallel circuit using vector processing.
;  Project files: circuits.asm, circuitsdriver.cpp
;Module Information
;  This module's call name: circuit_program
;  Date last modified: 9-9-15
;  Language: X86-64
;  Purpose: This module prompts the user for a voltage value. Then it asks for four power values to be entered. After all the values are inputted, the program displays
;           the user inputted voltage and power values. It also uses these values to calculate both the total current and total power in the circuit. Lastly, it 
;           returns the total power value to the driver program.
;  Filename: circuits.asm
;Translator Information:
;   Linux: nasm -f elf64 -l circuits.lis -o circuits.o -circuits.asm
;References and Credits:
;   Holliday, Floyd. Floating Point Input and Output. N.p., 1 July 2015. Web. 9 Sep. 2015. 
;   Holliday, Floyd. Instructions acting on SSE and AVX. N.p., 27 August 2015. Web. 9 Sep. 2015. 
;   Holliday, Floyd. Test Presence of AVX. N.p., 15 July 2015. Web. 9 Sep. 2015
;Format Information
;  Page width: 172 columns
;  Begin Comments: 61
;Permission information: No restrictions on posting this file online.
;===== Beginning of circuits.asm ==========================================================================================================================================

extern printf                                               ;External C++ function for writing to standard output device

extern scanf                                                ;External C++ function for reading from standard input device

global circuit_program                                      ;Allows the circuit program to be called outside of file

segment .data                                               ;Place for initialized data

;===== Message and Format Declarations ====================================================================================================================================

startmessage db "This program will help analyze direct current circuits configured in parallel.", 10, 0

voltageprompt db "Please enter the voltage of the entire circuit in volts: ", 0

powerprompt db "Enter the power of 4 devices (watts) separated by space and press enter: ",0

thanks db "Thank you. The computations have completed with the following results.",10,10,0

circuit_total db "Circuit total voltage: %1.18lf V" ,10,0

devices db "Device number: 	         1                       2                       3                       4",10,0

power db "Power (watts):  %1.18lf	%1.18lf	%1.18lf	%1.18lf ",10, 0

current db "Current (amps): %1.18lf	%1.18lf	%1.18lf	%1.18lf",10,10,0

endmessage db "The analyzer program will now return the total power to the driver.",10,10,0

totalcurrent db "Total current in the circuit is: %1.18lf amps.",10,0

totalpower db "Total power in the circuit is: %1.18lf watts.",10,0

stringformat db "%s",0

eight_byte_format db "%lf",0

four_float_format db "%lf%lf%lf%lf",0

segment .bss                                                ;Place for pointers to un-initialized space
;===== Entry point of circuits_program ====================================================================================================================================

segment .text                                               ;Place for executable instructions

circuit_program:                                            ;Entry point for circuit_program

push       rbp                                              ;This marks the start of a new stack frame for this function.
mov        rbp, rsp                                         ;rbp holds the address of the start of this new stack frame.

;===== Display Start Message ==============================================================================================================================================

mov qword  rax, 0                                           ;No data from SSE will be printed
mov        rdi, stringformat                                ;"%s"
mov        rsi, startmessage                                ;"This program will help analyze direct current circuits configured in parallel."
call       printf                                           ;Call a library function to make the output                            
 
;===== Prompt the user to input a voltage value ===========================================================================================================================

mov qword  rax, 0                                           ;No data from SSE will be printed
mov        rdi, stringformat                                ;"%s"
mov        rsi, voltageprompt                               ;"Please enter the voltage of the entire circuit in volts: "
call       printf                                           ;Call a library function to make the output        

;===== Get the user inputed voltage value and save in ymm register ========================================================================================================

push qword 0                                                ;reserve 8 bytes of storage for voltage value      
mov qword  rax, 0                                           ;SSE is not involved with this scanf operation
mov        rdi, eight_byte_format                           ;"%lf"
mov        rsi, rsp                                         ;Give scanf a point to reserved storage
call       scanf                                            ;Call a library function to retrieve user value
vbroadcastsd ymm15, [rsp]                                   ;save the voltage value from the user in all 4 spaces of ymm15
pop rax                                                     ;free up storage used by scanf

;===== Prompt the user to input four power values =========================================================================================================================

mov qword  rax, 0                                           ;No data from SSE will be printed
mov        rdi, stringformat                                ;"%s"
mov        rsi, powerprompt                                 ;"Enter the power of 4 devices (watts) sperated by space and press enter:"
call       printf                                           ;call a library function to make the output      

;===== Get the four user inputted values and save them into a ymm register  ===============================================================================================

mov        rdi, four_float_format                           ;"%lf%lf%lf%lf"
push qword 0 						    ;reserve 8 bytes of storage for power value
mov        rsi, rsp				            ;move rsp down the stack
push qword 0						    ;reserve 8 bytes of storage for power value
mov        rdx, rsp				            ;move rsp down the stack
push qword 0						    ;reserve 8 bytes of storage for power value
mov        rcx, rsp				            ;move rsp down the stack
push qword 0						    ;reserve 8 bytes of storage for power value
mov        r8, rsp				            ;Give scanf a point to reserved storage
mov        rax, 0                                           ;SSE is not involved with this scanf operation
call       scanf                                            ;Call a library function to retrieve user values

vmovupd    ymm14, [rsp]                                     ;copy the user inputted power values into ymm14 for division
vmovupd    ymm13, [rsp]                                     ;copy user inputted values into ymm13 for output

pop        rax						    ;free up storage used by scanf
pop        rax						    ;free up storage used by scanf
pop        rax						    ;free up storage used by scanf
pop        rax						    ;free up storage used by scanf

;===== Display the Thank You message ======================================================================================================================================

mov qword  rax, 0                                           ;No data from SSE will be printed
mov        rdi, stringformat                                ;"%s"
mov        rsi, thanks                                      ;"Thank you. The computations have completed with the following results."
call       printf                                           ;call a library function to make the output  

;===== Display the Circuit total voltage ==================================================================================================================================

vextractf128 xmm0, ymm15, 0				    ;move voltage values into xmm0 for output
mov        rax,1                                            ;1 floating point number will be printed
mov        rdi, circuit_total                               ;"Circuit total voltage: %1.18lf V"
call       printf                                           ;call a library function to make the output  

;===== Display the Device Numbers =========================================================================================================================================

mov qword  rax, 0                                           ;No data from SSE will be printed
mov        rdi, stringformat                                ;"%s"
mov        rsi, devices                                     ;"Device number: 	1 		2		3		4"
call       printf                                           ;call a library function to make the output  

;===== Display the Power values stored in ymm13 ===========================================================================================================================

push qword 0                                                ;Reserve 8 bytes of storage for power value
push qword 0                                                ;Reserve 8 bytes of storage for power value
push qword 0                                                ;Reserve 8 bytes of storage for poweer value
push qword 0                                                ;Reserve 8 bytes of storage for power value

vmovupd [rsp], ymm13			   		    ;copy the 4 power values stored in ymm13 onto the stack
 
movsd xmm0, [rsp+24]                                        ;copy first power value into xmm0
movsd xmm1, [rsp+16]                                        ;copy second power value into xmm1
movsd xmm2, [rsp+8]                                         ;copy third power value into xmm3
movsd xmm3, [rsp]                                           ;copy fourth power value into xmm4

pop rax 						    ;Discard power value from the integer stack
pop rax							    ;Discard power value from the integer stack
pop rax						            ;Discard power value from the integer stack

push qword 0                                                ;Get on the boundary
mov rax, 4                                                  ;4 floating point values will be printed
mov rdi, power                                              ;"Power (watts): %1.18lf	%1.18lf	%1.18lf	%1.18lf"
call printf                                                 ;Call a library function to make the output
pop rax                                                     ;reverse push from 4 instructions earlier
pop rax							    ;Discard power value fromt the integer stack


;===== Display the Current values stored in ymm14 =========================================================================================================================

push qword 0                                                ;Reserve 8 bytes of storage for current value
push qword 0                                                ;Reserve 8 bytes of storage for current value
push qword 0                                                ;Reserve 8 bytes of storage for current value
push qword 0                                                ;Reserve 8 bytes of storage for current value

vdivpd     ymm14, ymm15                                     ;divide the power vector by the voltage vector
vmovupd [rsp], ymm14                                        ;move the 4 current values stored in ymm14 onto the stack
 
movsd xmm0, [rsp+24]                                        ;copy the first current value over to xmm0
movsd xmm1, [rsp+16]                                        ;copy the second current value over to xmm1
movsd xmm2, [rsp+8]                                         ;copy the third current value over to xmm2
movsd xmm3, [rsp]                                           ;copy the fourth current value over to xmm3

pop rax 						    ;Discard current value from the integer stack
pop rax							    ;Discard current value from the integer stack
pop rax						            ;Discard current value from the integer stack

push qword 0                                                ;Get on the boundary
mov rax, 4                                                  ;4 floating point values will be printed
mov rdi, current                                            ;"Current (amps): %1.18lf  %1.18lf  %1.18lf  %1.18lf"
call printf                                                 ;Call a library function to make the output
pop rax                                                     ;reverse push from 4 instructions earlier
pop rax                                                     ;Discard power value fromt the integer stack

;===== Calculate the total current in the circuit =========================================================================================================================

vhaddpd ymm12, ymm14, ymm14                                 ;Add the current vector to itself and place result in ymm12
vextractf128 xmm0,ymm12,1                                   ;place upper half of ymm12 into xmm0 for addition
addsd      xmm0,xmm12                                       ;add xmm0 to ymm12 to get total current value

mov        rax,1                                            ;1 floating point number will be printed
mov        rdi, totalcurrent                                ;"Total current in the circuit is: %1.18lf"
call       printf                                           ;call a library function to make the output 

;====== Calculate the total power in the circuit ==========================================================================================================================

vhaddpd ymm11, ymm13, ymm13                                 ;Add the power vector to itself and place result in ymm11
vextractf128 xmm0,ymm11,1                                   ;place upper half of ymm11 into xmm0 for addition
addsd      xmm0,xmm11                                       ;add xmm0 to ymm11 to get total power value

push qword 0                                                ;Reserve 8 bytes of storage for return value
movsd  [rsp], xmm0                                          ;Place a backup copy of the total power in the reserved storage  

push qword 0                                                ;Get on the boundary
mov        rax,1                                            ;1 floating point number will be printed
mov        rdi, totalpower                                  ;"Total power in the circuit is: %1.18lf"
call       printf                                           ;call a library function to make the output
pop rax                                                     ;Reverse the push from 4 instructions earlier

;====== Display End Message ===============================================================================================================================================

mov qword  rax, 0                                           ;No data from SSE will be printed
mov        rdi, stringformat                                ;"%s"
mov        rsi, endmessage                                  ;"The analyzer program will now return the total power to the driver."
call       printf                                           ;Call a library function to make the output 
             
;===== Copy the Total power and return to caller ==========================================================================================================================

movsd      xmm0, [rsp]                                      ;A copy of the total power is now in xmm0
pop        rax                                              ;Discard the value
  
;====== Restore the Base Pointer ==========================================================================================================================================

pop        rbp

ret

;===== End of circuits.asm ================================================================================================================================================





