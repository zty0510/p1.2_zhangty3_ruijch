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
add a5 x0 x0#int a5=0 offset of a2
add a6 x0 x0#a6 a2+a5
add a7 x0 x0 #offset of cnts a7=a4*4
add s2 x0 x0 #s2=a3+a7
add s3 x0 x0 #store command
lw s4 lines_of_rvc_codes#s4=length
addi t3 x0 2#t3=2
addi t4 x0 4#t4=4

loop1:
bge a4 s4 loop1_end #end main loop
add a6 a2 a5#update pointer
slli a7 a4 2#a7=a4*4
add a7 a7 a3#a7=a7+a3
lw s3 0(a6)#read a command to s3
jal judgeType #check if its 32 bit or 16 bit and update offset

beq t2 t3 SixteenTrans #if 16 bit
beq t2 t4 ThirttTrans # if 32 bit



loop1_middle:
addi a4 a4 1#a4++
j loop1#loop

loop1_end:
add	   a1, x0, x0
addi   a0, x0, 17
ecall#end 


judgeType:
addi sp sp -8
sw ra 0(sp)
sw s3 4(sp)#save command 
addi t1 x0 0b000000000000000000000000000000011 #t1
and s3 s3 t1#get the last two bits
beq s3 t1 ThirtyTwo #if ture jump to 32 bits update
addi a5 a5 2 #add 16 bits offset to a5
addi t2 x0 2#t2=2
sw t2 0(a7)#save 2 to cnts
j judgeType_end#end judgeType

ThirtyTwo:
addi a5 a5 4 #add 32 bits offset to a5
addi t2 x0 4 #t2=4
sw t2 0(a7)#save 4 to cnts

judgeType_end:
lw ra 0(sp)
lw s3 4(sp)#restore command
addi sp sp 8
jr ra

SixteenTrans:#16 bit translate

j loop1_middle #return

ThirttTrans:#32 bit translate

j loop1_middle #return


