#   Project 1.2 RVC instructions to RISC-V instructions in RISC-V

#   You can suppose you will get the number of machine codes you should translate from 
#   "lines_of_rvc_codes" and get the 16 or 32 bits-machine codes from "rvc_codes". 
#   Both of them are stored in file "input.S"

#   When we test your project, we will change the input files content.

# DO NOT REMOVE THIS LINE WHEN SUBMITTING
.import input.S

# Your code to convert the RVC codes to RVI codes.
.data
.globl cnts #store the length of each instuction
cnts:
	.space 1000


# Exit with error code 0
.text

la a2 rvc_codes #a2 points to the rvc_code array
la a3 cnts #a3 points to the cnts array
add a4 x0 x0#int a4=0 
add a5 x0 x0#int a5=0 offset of a4 a5=a4*4
lw a6 lines_of_rvc_codes #a6=length of rvc_code array
add a7 x0 x0#int a7=0 store each command
add s2 x0 x0#int s2=0 offset+a2
add s3 x0 x0#int s3=0 offset+a3


loop1:
bge a4 a6 loop1_end#if a4>=length break;
slli a5 a4 2 # a5=a4*4
add s2 a2 a5#s2=a2+offset 
lw a7 0(s2)#read a line from rvc_codes
jal JudgeDigits#judge if the rvc_codes is 32 digit or 16 digit
add t2 x0 x0 #int t2=0
addi t2 x0 32#t2=32




addi a4 a4 1#a4++
j loop1


loop1_end:

add	   a1, x0, x0
addi   a0, x0, 17
ecall

Translate:#translate rvc to riscv
addi sp sp -8
sw a7 0(sp)#save rvc_code
sw ra 4(sp)#save return address



lw a7 0(sp)#restore a7
lw ra 4(sp)#restore return address
addi sp sp 8
jr ra #return


JudgeDigits:#judge whether the rvc_code is 32 or 16
addi sp sp -8
sw ra 0(sp)
sw a7 4(sp)#save a7 for further use
add t1 x0 x0#t1=0


loopForDigits:
beq a7 x0 loopForDigitsEnd #if a7==0 break
srli a7 a7 1 #a7=a7>>1 
addi t1 t1 1#t1++
j loopForDigits


loopForDigitsEnd:

lw ra 0(sp)
lw a7 4(sp)#restore a7 from stack
addi sp sp 8
jr ra