# hw2_main1.asm
# This file is NOT part of your homework 2 submission.
# Any changes to this file WILL NOT BE GRADED.
#
# We encourage you to modify this file  and/or make your own mains to test different inputs

.include "hw2_grading.asm"

# Constants
.data
newline:  .asciiz "\n"
comma:    .asciiz ", "
testchar: .byte '9'
success: .asciiz "Success: "
bytes: .asciiz "Bytes: "
packetNumber_1: .asciiz "packet number "
packetNumber_2: .asciiz " has invalid checksum"

.text
.globl _start


####################################################################
# This is the "main" of your program; Everything starts here.
####################################################################

_start:

toProcessDatagram:
	##################
	# processDatagram
	##################
	la $a0, backslashN
	li $a1, 9
	la $a2, abcArray
	jal processDatagram

	# print return value
	move $a0, $v0
	li $v0, 1
	syscall
	li $v0, 4
	la $a0, newline
	syscall


	# Exit the program
	li $v0, 10
	syscall

###################################################################
# End of MAIN program
####################################################################


#################################################################
# Student defined functions will be included starting here
#################################################################

.include "hw2.asm"
