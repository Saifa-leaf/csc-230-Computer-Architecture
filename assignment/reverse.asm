# UVic CSC 230, Fall 2020
# Assignment #1, part B

# Student name: Keanu Reeves
# Student number: V1234576


# Compute the reverse of the input bit sequence that must be stored
# in register $8, and the reverse must be in register $15.


.text
start:
	lw $8, testcase3   # STUDENTS MAY MODIFY THE TESTCASE GIVEN IN THIS LINE
	
# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
	
	li $9, 0 #count from 0 to 31 (bits)
	li $10, 0 # check last bit

loop:
	beq $9, 31, exit
	addi $9, $9, 1
	li $10, 0
	andi $10, $8, 1
	srl $8, $8, 1
	beq $10, 1, append
	sll $15, $15, 1
	j loop

append:
	addi $15, $15, 1
	sll $15, $15, 1
	j loop
	
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE

exit:
	add $2, $0, 10
	syscall
	
	

.data

testcase1:
	.word	0x00200020    # reverse is 0x04000400

testcase2:
	.word 	0x00300020    # reverse is 0x04000c00
	
testcase3:
	.word	0x1234fedc     # reverse is 0x3b7f2c48
