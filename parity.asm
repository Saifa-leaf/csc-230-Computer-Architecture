# UVic CSC 230, Fall 2020
# Assignment #1, part A

# Student name: Keanu Reeves
# Student number: V1234576


# Compute odd parity of word that must be in register $8
# Value of odd parity (0 or 1) must be in register $15


.text

start:
	lw $8, testcase1 # STUDENTS MAY MODIFY THE TESTCASE GIVEN IN THIS LINE
	
# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
	
	li $10, 0 # check last bit 
	li $15, 1 # parity
loop:
	beqz $8, exit
	andi $10, $8, 1
	srl $8, $8, 1
	beq $10, 1, shift
	j loop
	
shift:
	xori $15, $15, 1
	li $10, 0
	j loop


# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE


exit:
	add $2, $0, 10
	syscall
		

.data

testcase1:
	.word	0x00200020    # odd parity is 1

testcase2:
	.word 	0x00300020    # odd parity is 0
	
testcase3:
	.word  0x1234fedc     # odd parity is 0

