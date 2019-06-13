
##############################################################
# name: Mei Qi Deanna Liu
##############################################################
.text

##############################
# PART 1 FUNCTIONS
##############################
replace1st:
	#a0 is String
	#a1 is toReplace
	#a2 is replaceWith
	move $t2, $a0 #copy a0 (the word) into t2 
#checks for Errors:
	blt $a1, 0x00, error 
	bgt $a1, 0x7F, error
	blt $a2, 0x00, error
	bgt $a2, 0x7F, error
	j innerStr #if no error start the replace loop - "innerStr"
error:
	li $v0, -1 		#return -1
	jr $ra			#end
innerStr:
	lbu $t3, 0($t2) 	#load the letter into $t3
	beqz $t3, printZero	#if the letter is /0 then print a 0
	beq $t3, $a1, replace	#if the letter = toReplace then perform the replace
	addi $t2, $t2, 1	#increment to the next letter
	j innerStr
replace:
	sb $a2, 0($t2)		#storing the replaceWith into where the String is pointing at the moment
#Memory Address is off by 1?
	addi $t2, $t2, 1	#increment the memory address by 1
	move $v0, $t2		#returning the modified String
	jr $ra			#end
printZero:
	li $v0, 0		#return 0
	jr $ra			#end


################################### 1B #######################################
printStringArray:
 	blt $a3, 1, printError #Length is less than 1
   	bltz $a1, printError #startIndex is less than 0
   	bge $a1, $a3, printError #startIndex is greater than or equal length
   	bltz $a2, printError #endIndex is less than 0
   	bge $a2, $a3, printError #endIndex is greater than or equal length
   	blt $a2, $a1, printError #endIndex is less than startIndex
   	
   	move $t0, $a0
   	move $t1, $a1
   	li $t2, 0
   	
   	#startingPoint:
#	li $v0, 4
#	move $a0, $t1
#	syscall	
#	la $a0, newLine
#	syscall
#	syscall		
#printRest:
#	lw $t1, 0($t4)
#	bgeu $t0, $a2, end1
#	addi $t4, $t4, 4
#	addi $t0, $t0, 1
#	addi $t2, $t2, 1
#	li $v0, 4
#	move $a0, $t1
#	syscall	
#	la $a0, newLine
#	syscall	
#	syscall
#	j printRest

   	startLoop:
   		bgt $t1, $a2, endLoop
   		sll $t3, $t1, 2
   		add $t4, $t0, $t3
   		#addi $t4, $t0, 4
   		lw $t5, 0($t4)
   		move $a0, $t5
   		li $v0, 4
   		syscall
   		la $a0, newLine
   		syscall
   		syscall
   		addi $t1, $t1, 1
   		addi $t2, $t2, 1
   		j startLoop
   	
   	endLoop:
   		#sw $a0, 4($sp)
	#lw $ra, 0($sp)
	#lw $s1, 4($sp)
	#lw $s0, 8($sp)
	#addi $sp, $sp, 4
   		move $v0, $t2
   		jr $ra
   	printError:
   		li $v0, -1
   		jr $ra
    	
########################## 1C #####################################################
verifyIPv4Checksum:
	#a0 = Valid Header
	move $t0, $a0 #a0 = $t0
	lbu $t1, 3($t0) #Version || HeaderLength
	sll $t1, $t1, 28
	srl $t1, $t1, 28
	#t1 = HeaderLength
#		move $a0, $t1
#		li $v0, 34
#		syscall
#		li $v0, 4
#		la $a0, newline
#		syscall
	li $t2, 2
	mult $t1, $t2
	mflo $t3 #header * 2
	li $t5, 0 #pointer
	li $t4, 0 
looploop:
	lhu $t7, ($t0)
	beq $t4, $t3, endlooploop
	add $t5, $t5, $t7 #t5 = sum of everything
	addi $t4, $t4, 1
	addi $t0, $t0, 2
	j looploop
endlooploop:
	li $t6, 65536
	bge $t5, $t6, endAround
	#lhu $t0, 8($a0) #checksum
	move $v0, $t5
	jr $ra
endAround:
	srl $t3, $t5, 16 #t5 = 0100
	sll $t6, $t5, 16 
	srl $t6, $t6, 16
	add $t6, $t3, $t6
	xori $t6, $t6, 0x0000ffff
	move $t9, $t6
	move $v0, $t6
#		move $a0, $t6
#		li $v0, 34
#		syscall
#		la $a0, testing
#		li $v0, 4
#		syscall
#		la $a0, newline
#		syscall
jr $ra

##############################
# PART 2 FUNCTIONS
##############################

extractData:
	#a0 = parray
	#a1 = n
	#a2 = msg
	addi $sp, $sp, -36
	sw $s7, 32($sp)
	sw $s6, 28($sp)
	sw $s5, 24($sp)
	sw $s4, 20($sp)
	sw $s3, 16($sp)
	sw $s2, 12($sp)
	sw $s1, 8($sp)
	sw $s0, 4($sp)
	sw $ra, 0($sp)
	
	move $a3, $a2
	move $s0, $a0 
	#s0 = parray
	#get payload first
	#li $s1, 0 #msg pointer
	li $t8, 20 
	li $s2, 0 #sum of bytes
	li $s3, 0 #parray pointer
	#li $a3, 0
	extractPayload:
	beq $s3, $a1, endFill #compare length and parraypointer
	lhu $s4, 0($s0) #total length is in s4
		#	li $t9, 20
		addi $s5, $s4, -20 
		#	li $t9, 0
		add $s2, $s2, $s5
	lbu $s1, 3($s0) #Version || HeaderLength
	sll $s1, $s1, 28
	srl $s1, $s1, 28
	sub $s6, $s4, $s1 #s6 = payload
		#	move $a0, $t2
		#	li $v0, 34
		#	syscall
		#	li $v0, 4
		#	la $a0, newline
		#	syscall
	#		move $a0, $t2
	#		li $v0, 34
	#		syscall
	#		li $v0, 4
	#		la $a0, newline
	#	syscall
		move $a0, $s0
		move $s7 ,$s0
		jal verifyIPv4Checksum
		#increment parray pointer
			addi $s3, $s3, 1 
			addi $s0, $s0, 60
			bnez $v0, errorFill
		j extractPayload
		
endFill:	
	move $v1, $s2
	addi $s7, $s7, 20
	li $s3, 0
	beqz $v0, fillbytes
	
nextPacket:
	addi $s7, $s7, 20
	li $t8, 20 
	addi $s3, $s3, 1
	beq $s3, $a1, endfill2
	j fillbytes
errorFill:
	addi $s3, $s3, -1
	li $v0, -1
	move $v1, $s3
	j endfill2
endfill2:
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	lw $s5, 24($sp)
	lw $s6, 28($sp)
	lw $s7, 32($sp)
	addi $sp, $sp, 36
    	jr $ra

fillbytes:
	lbu $t3, 0($s7)
	#	move $a0, $t3
	#	li $v0, 34
	#	syscall
	#	li $v0, 4
	#	la $a0, newline
	#	syscall
	sb $t3, 0($a3)
	addi $s7, $s7, 1
	beq $t8, 60, nextPacket
	addi $t8, $t8, 1
	addi $a3, $a3, 1
	j fillbytes

    #################################### 2E ##############################
processDatagram:
    #Define your code here
    #a0 is msg
    #a1 is M
    #a2 is sarray
	addi $sp, $sp, -8
	sw $ra, 0($sp)
	sw $s1, 4($sp)
	
	#li $t8, 1 #pointer
	move $t5, $a0 #copy of message -- s0
	#move $s0, $a0 #copy of message 
	move $t7, $a1 #t7 is M ---- s1
	li $s1, 0
	move $t6, $a2 #t6 is the sArray --- s2
	#	move $a0, $t8
	li $a1, '\n'
	li $a2, '\0'
	ble $t7, 0, errorload
	li $t4, 0  #t9
	li $t2, 0  #s3
	li $t8, 0
	
	
	replaceLoop:
		jal replace1st
		beq $v0, 0, input
		sub $s1, $v0, $a0 
		add $t4, $t4, $s1
	#	addi $t4, $t4, 1
		sw $a0, 0($t6)
		add $a0, $a0, $s1
		addi $t6, $t6, 4
		addi $t8, $t8, 1
		blt $t4, $t7, replaceLoop
	input:
		addi $a0, $a0, 1
		addi $t4, $t4, 1
		blt $t4, $t7, replaceLoop
	testSu:
		bgt $t4, $t7, endReplace
		sb $a2, 0($a0)
		addi $a0, $a0, 1
	#	sub $t4, $t4, $t7
		addi $t4, $t4, 1
	#	sub $a0, $a0, $t4
		sw $a0, 0($t6)
		addi $t8, $t8, 1
endReplace:
	move $v0, $t8
	j exit_parte
errorload:
	li $v0, -1
exit_parte:
	lw $ra, 0($sp)
	lw $s1, 4($sp)
	addi $sp, $sp, 8 
	jr $ra

##############################
# PART 3 FUNCTIONS
##############################

printDatagram:
    #Define your code here
    ############################################
    # DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
    li $v0, -555
    ############################################
       	addi $sp, $sp, -16
#	sw $s7, 32($sp)
#	sw $s6, 28($sp)
#	sw $s5, 24($sp)
#	sw $s4, 20($sp)
	sw $s3, 12($sp)
	sw $s2, 8($sp)
	sw $s1, 4($sp)
#	sw $s0, 4($sp)
	sw $ra, 0($sp)
	
	#li $s6, 0 #endIndex
	# $a0, pktArray_ex1
	# $a1, 1
	# $a2, msg_buffer
	move $s3, $a0 #s3 is parray
	move $s7, $a1
	move $s2, $a2 #s2 is msg_buffer
	move $s5, $a3 
	# $a3, Sarray

    blez $a1, errorInData
    jal extractData
    
    
  #  lw $ra, 0($sp)
#	addi $sp, $sp, 4
	beq $v0, -1, errorInData
  #  move $s0, $v0 #s0 = result in ExtractData
  #  move $s4, $v1 #s4 = M
  #  move $s4, $a2 #the messageArray from extractData
 #  	lb $a0, 0($s4)
  #  	li $v0, 1
   # 	syscall
    #	move $v0, $s0
   # beqz $v0, startProcess
  
    startProcess:
   	 move $a0, $a2
   	 move $a1, $v1 #v1 is M
   	 move $a2, $a3
   	
    jal processDatagram
    move $s1, $v0 #s1 = result in processDatagram
   # 	move $a0, $v0
    #	li $v0, 1
    #	syscall
    #	move $v0, $s1
    move $v0, $s1
    beq $v0, -1, errorInData
    #bne $s1, -1, startPrint
	
    startPrint:
    	#addi $s6, $s7, -1
	move $a0, $a3
	li $a1, 0
	move $a2, $v0
	addi $a2, $a2, -1
	move $a3, $v0
		
	#	move $a0, $a2
    	#	li $v0, 1
    	#	syscall		
    #		li $v0, 1
    #		syscall
    #		move $a0, $a3
    #		li $v0, 1
    #		syscall
	#	move $a0, $s2
   	jal printStringArray
   	li $v0, 0
   	j ending
errorInData: 
	li $v0, -1
ending:
    	lw $ra, 0($sp)
   # 	lw $s0, 4($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
#	lw $s4, 20($sp)
#	lw $s5, 24($sp)
#	lw $s6, 28($sp)
#	lw $s7, 32($sp)
	addi $sp, $sp, 16
    jr $ra


#################################################################
# Student defined data section
#################################################################
.data
.align 2  # Align next items to word boundary

#place all data declarations here

Err_num: .asciiz "-1"
testing: .asciiz "placement"
newLine:  .asciiz "\n"

