.data

# Constant integer specifying the lines of RVC codes

# DO NOT MODIFY THIS VARIABLE
.globl lines_of_rvc_codes
lines_of_rvc_codes:
    .word 1


# RVC codes, 16-bits instructions mixed with 32-bits instructions
# A 16/32-bits binary number represents one line of rvc code.
# You can suppose all of the input codes are valid. 

# DO NOT MODIFY THIS VARIABLE
.globl rvc_codes
rvc_codes:
    
    .half 0b1001100011011001




	


   





    
    
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

addi sp sp -8
sw s3 0(sp)#save command
add s5 x0 s3 #s5=command
addi t1 x0 0b000000000000000000000000000000011 #t1
and s3 s3 t1#get the last two bits
addi t5 x0 0b000000000000000000000000000000010#t5
beq s3 t5 OneZeroOp #op 10
addi t5 x0 0b000000000000000000000000000000001#t5
beq s3 t5 ZeroOneOp #op 01

SixteenTrans_middle:





lw s3 0(sp)#restore s3
addi sp sp 8
j loop1_middle #return



ThirttTrans:#32 bit translate

j loop1_middle #return



OneZeroOp:#op 10







ZeroOneOp:#op 01
addi sp sp -4
sw s5 0(sp) #save command to stack
li t5 0b000000000000000001111110000000000#get funct6
and s5 s5 t5#get funct6
li t6 0b000000000000000001000110000000000#if CA format
beq s5 t6 CaFormat#if it is CA format

lw s5 0(sp)#restore s5
li t5 0b000000000000000001110000000000000#get funct3
and s5 s5 t5#get funct3
li t6 0b000000000000000000100000000000000#li
beq s5 t6 CLI #cli
li t6 0b000000000000000000110000000000000#lui
beq s5 t6 CLUI #clui
li t6 0b000000000000000000000000000000000#addi
beq s5 t6 CAADI #addi
li t6 0b00000000000000001100000000000000#beqz
beq s5 t6 CBEQZ
li t6 0b000000000000000001110000000000000#bnez
beq s5 t6 CBNEZ#bnez
li t6 0b000000000000000001000000000000000#srli or srai or andi
beq s5 t6 srlai_judge




ZeroOneOp_end:
lw s5 0(sp)#restore command
addi sp sp 4
j SixteenTrans_middle#return


CLI:
lw s5 0(sp)#restore s5 from stack
li t6 0b000000000000000000000111110000000#reg
and s7 s5 t6 #get reg store it to s7
srli s7 s7 7#put it to low bits
li t6 0b000000000000000000000000001111100#imm[4:0]
and s8 s5 t6#get imm[4:0]and store it to s8
srli s8 s8 2#puit it to low bits
li t6 0b000000000000000000001000000000000#imm[5]
and s9 s5 t6#get imm[5] and put it to s9
srli s9 s9 7#put it to the 6th bit
li s10 0b00100000 # negative
beq s9 s10 NegtiveNum
add s9 s9 s8#s9=imm[5:0]
li s6 0b000000000000000000000000000010011	#s6 is the answer 

j cli_ans

NegtiveNum:
add s9 s9 s8#s9=imm[5:0]
li s6 4227858451	#s6 is the answer 

cli_ans:

slli s9 s9 20
add s6 s6 s9#add imm to answer
slli s7 s7 7
add s6 s6 s7#add rd to answer
jal PrintAnswer
j ZeroOneOp_end#return



CLUI:
j ZeroOneOp_end#return

CAADI:
lw s5 0(sp)#restore s5 from stack
li t6 0b000000000000000000000111110000000#reg
and s7 s5 t6 #get reg store it to s7
srli s7 s7 7#put it to low bits
li t6 0b000000000000000000000000001111100#imm[4:0]
and s8 s5 t6#get imm[4:0]and store it to s8 
srli s8 s8 2#puit it to low bits
li t6 0b000000000000000000001000000000000#imm[5]
and s9 s5 t6#get imm[5] and put it to s9
srli s9 s9 7#put it to the 6th bit
li s10 0b00100000 # negative
beq s9 s10 NegtiveNum_addi
add s9 s9 s8#s9=imm[5:0]
li s6 0b000000000000000000000000000010011	#s6 is the answer 

j caddi_ans

NegtiveNum_addi:
add s9 s9 s8#s9=imm[5:0]
li s6 4227858451	#s6 is the answer 

caddi_ans:

slli s9 s9 20
add s6 s6 s9#add imm to answer
slli s7 s7 7
add s6 s6 s7#add rd to answer
slli s7 s7 8 #add rs1 to answer
add s6 s6 s7
jal PrintAnswer


j ZeroOneOp_end#return



CaFormat:
lw s5 0(sp)#restore s5 which is the copy of codes
srli s5 s5 5#shift left 5 bits
li t5 0b11
and s5 s5 t5#get funct2
li t6 0b11
beq s5 t6 AND
li t6 0b10
beq s5 t6 OR
li t6 0b01
beq s5 t6 XOR
li t6 0b00
beq s5 t6 SUB


AND:
lw t1 0(sp)#t1 is the copy of codes
li t2 0b1110000000
and t2 t2 t1#t2 = rd / rs1
li t0 0b11100
and t0 t0 t1#t0 = rs2   
#mapReg
srai t2 t2 7
srai t0 t0 2
mv s7 t2
jal mapReg
mv t2 s7

mv s7 t0
jal mapReg
mv t0 s7

li s6 0#initialize s6 which is the answer 
slli t0 t0 20#shift rs2
slli t2 t2 15#shift rs1
add s6 s6 t0
add s6 s6 t2

srli t2 t2 8#shift rd from rs1
add s6 s6 t2
li t0 0b111000000110011#t0 = opcode + funct3
add s6 s6 t0#merge ans
jal PrintAnswer
j ZeroOneOp_end#return



OR:
lw t1 0(sp)#t1 is the copy of codes
li t2 0b1110000000
and t2 t2 t1#t2 = rd / rs1
li t0 0b11100
and t0 t0 t1#t0 = rs2   
#mapReg
srai t2 t2 7
srai t0 t0 2
mv s7 t2
jal mapReg
mv t2 s7

mv s7 t0
jal mapReg
mv t0 s7

li s6 0#initialize s6 which is the answer 
slli t0 t0 20#shift rs2
slli t2 t2 15#shift rs1
add s6 s6 t0
add s6 s6 t2

srli t2 t2 8#shift rd from rs1
add s6 s6 t2
li t0 0b110000000110011#t0 = opcode + funct3
add s6 s6 t0#merge ans
jal PrintAnswer
j ZeroOneOp_end#return



XOR:
lw t1 0(sp)#t1 is the copy of codes
li t2 0b1110000000
and t2 t2 t1#t2 = rd / rs1
li t0 0b11100
and t0 t0 t1#t0 = rs2   
#mapReg
srai t2 t2 7
srai t0 t0 2
mv s7 t2
jal mapReg
mv t2 s7

mv s7 t0
jal mapReg
mv t0 s7

li s6 0#initialize s6 which is the answer 
slli t0 t0 20#shift rs2
slli t2 t2 15#shift rs1
add s6 s6 t0
add s6 s6 t2

srli t2 t2 8#shift rd from rs1
add s6 s6 t2
li t0 0b100000000110011#t0 = opcode + funct3
add s6 s6 t0#merge ans
jal PrintAnswer
j ZeroOneOp_end#return


SUB:
lw t1 0(sp)#t1 is the copy of codes
li t2 0b1110000000
and t2 t2 t1#t2 = rd / rs1
li t0 0b11100
and t0 t0 t1#t0 = rs2   
#mapReg
srai t2 t2 7
srai t0 t0 2
mv s7 t2
jal mapReg
mv t2 s7

mv s7 t0
jal mapReg
mv t0 s7

li s6 0#initialize s6 which is the answer 
slli t0 t0 20#shift rs2
slli t2 t2 15#shift rs1
add s6 s6 t0
add s6 s6 t2

srli t2 t2 8#shift rd from rs1
add s6 s6 t2
li t0 0b000000000110011#t0 = opcode + funct3
add s6 s6 t0#merge ans
li t0 0100000
slli t0 t0 25#t0 = funct7=010 0000
add s6 s6 t0
jal PrintAnswer
j ZeroOneOp_end#return




j ZeroOneOp_end#return

CBEQZ:
j ZeroOneOp_end#return

CBNEZ:
j ZeroOneOp_end#return

PrintAnswer:
addi sp sp -16
sw t4 0(sp)
sw s6 4(sp)
sw t5 8(sp)
sw t3 12(sp)
addi t5 x0 31#t5=0
addi t4 x0 32#t4=32
addi t3 x0 0#t3=0
PrintLoop:
bge t3 t4 PrintEnd
lw s6 4(sp)#restore s6
sll s6 s6 t3
srli s6 s6 31
add a1 x0 s6#write s6 to a1
addi a0 x0 1
ecall#print
addi t3 t3 1#t3++
j PrintLoop#loop

PrintEnd:
addi a1 x0 10
addi a0 x0 11#print \n
ecall
lw t4 0(sp)
lw s6 4(sp)
lw t5 8(sp)
lw t3 12(sp)
addi sp sp 16
jr ra

srlai_judge:
lw s5 0(sp)#restore s5 from stack
li t5 0b000000000000000000000110000000000#get funct2
and s5 s5 t5#get funct2
li t6 0b000000000000000000000000000000000#srli
beq s5 t6 csrli
li t6 0b000000000000000000000010000000000#srai
beq s5 t6 csrai
li t6 0b000000000000000000000100000000000#andi
beq s5 t6 candi



csrli:
lw s5 0(sp)#restore s5 from stack
li t6 0b000000000000000000000001110000000#reg
and s7 s5 t6 #get reg store it to s7
srli s7 s7 7#put it to low bits
jal mapReg #get 5 bits reg 7

li t6 0b000000000000000000000000001111100#imm[4:0]
and s8 s5 t6#get imm[4:0]and store it to s8 
srli s8 s8 2#puit it to low bits
li t6 0b000000000000000000001000000000000#imm[5]
and s9 s5 t6#get imm[5] and put it to s9
srli s9 s9 7#put it to the 6th bit
li s6 0b000000000000000000101000000010011
add s9 s9 s8#imm[5:0]
slli s9 s9 20
add s6 s6 s9#add imm to answer
slli s7 s7 7
add s6 s6 s7#add rd to answer
slli s7 s7 8 #add rs1 to answer
add s6 s6 s7
jal PrintAnswer


j ZeroOneOp_end#return



csrai:
lw s5 0(sp)#restore s5 from stack
li t6 0b000000000000000000000001110000000#reg
and s7 s5 t6 #get reg store it to s7
srli s7 s7 7#put it to low bits
jal mapReg #get 5 bits reg 7

li t6 0b000000000000000000000000001111100#imm[4:0]
and s8 s5 t6#get imm[4:0]and store it to s8 
srli s8 s8 2#puit it to low bits
li t6 0b000000000000000000001000000000000#imm[5]
and s9 s5 t6#get imm[5] and put it to s9
srli s9 s9 7#put it to the 6th bit
li s6 0b001000000000000000101000000010011
add s9 s9 s8#imm[5:0]
slli s9 s9 20
add s6 s6 s9#add imm to answer
slli s7 s7 7
add s6 s6 s7#add rd to answer
slli s7 s7 8 #add rs1 to answer
add s6 s6 s7
jal PrintAnswer

j ZeroOneOp_end#return

candi:
lw s5 0(sp)#restore s5 from stack
li t6 0b000000000000000000000001110000000#reg
and s7 s5 t6 #get reg store it to s7
srli s7 s7 7#put it to low bits
jal mapReg#convert reg
li t6 0b000000000000000000000000001111100#imm[4:0]
and s8 s5 t6#get imm[4:0]and store it to s8 
srli s8 s8 2#puit it to low bits
li t6 0b000000000000000000001000000000000#imm[5]
and s9 s5 t6#get imm[5] and put it to s9
srli s9 s9 7#put it to the 6th bit
li s10 0b00100000 # negative
beq s9 s10 NegtiveNum_andi
add s9 s9 s8#s9=imm[5:0]
li s6 0b000000000000000000111000000010011	#s6 is the answer 

j candi_ans

NegtiveNum_andi:
add s9 s9 s8#s9=imm[5:0]
li s6 4227887123	#s6 is the answer 

candi_ans:

slli s9 s9 20
add s6 s6 s9#add imm to answer
slli s7 s7 7
add s6 s6 s7#add rd to answer
slli s7 s7 8 #add rs1 to answer
add s6 s6 s7
jal PrintAnswer


j ZeroOneOp_end#return



j ZeroOneOp_end#return

mapReg:#s7 store the reg to be mapped,and store the return reg into s7
addi sp sp -4
sw t5 0(sp)
li t5 0b000000
beq t5 s7 mapZero#s7=000
li t5 0b000001
beq t5 s7 mapOne#s7=001
li t5 0b000010
beq t5 s7 mapTwo#s7=010
li t5 0b000011
beq t5 s7 mapThree#s7=011
li t5 0b000100
beq t5 s7 mapFour#s7=012
li t5 0b000101
beq t5 s7 mapFive#s7=013
li t5 0b000110
beq t5 s7 mapSix#s7=014
li t5 0b000111
beq t5 s7 mapSeven#s7=015


mapZero:
li s7 8
j mapReg_end

mapOne:
li s7 9
j mapReg_end

mapTwo:
li s7 10
j mapReg_end


mapThree:
li s7 11
j mapReg_end

mapFour:
li s7 12
j mapReg_end

mapFive:
li s7 13
j mapReg_end

mapSix:
li s7 14
j mapReg_end

mapSeven:
li s7 15
j mapReg_end

mapReg_end:
lw t5 0(sp)
addi sp sp 4
jr ra
