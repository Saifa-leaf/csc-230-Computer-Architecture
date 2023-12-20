.text

	li $a0, 'a'
	jal is_upper_case
	move $s0, $v0
	
	li $a0, 'A'
	jal is_upper_case
	move $s1, $v0
	
	li $a0, 'Z'
	jal is_upper_case
	move $s2, $v0

	li $a0, 'N'
	jal is_upper_case
	move $s3, $v0

	li $a0, '7'
	jal is_upper_case
	move $s4, $v0
		
	la $a0, string1
	jal count_upper_case
	move $s5, $v0

	la $a0, string2
	jal count_upper_case
	move $s6, $v0

	la $a0, string3
	jal count_upper_case
	move $s7, $v0
		
	li $v0, 10
	syscall

# $a0 - the ascii value
# $v0 - 1 if $a0 is an upper case character
#     - 0 if $a0 is NOT an upper case character
#
# upper lettter is >= "A" and <= "Z"
# or it is not upper if < "A" OR > "Z"
is_upper_case:
	li $v0, 0
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	li $t1, 'A'
	li $t2, 'Z'
	
	blt $a0, $t1, done
	bgt $a0, $t2, done
	addi $v0, $v0, 1
	
done: 	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

# $a0 - pointer to string to count upper case letters in
# $v0 - number of upper case letters in $a0
#
#
# $s0 - copy of pointer to string
# $s1 - copy of number of upper case letters in 
# $t0 - current letter
#
# +-----+
# | $s1 | 8
# | $s0 | 4
# | $ra | 0
# +-----+
count_upper_case:
	addi $sp, $sp, -12
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	
	move $s0, $a0
	li $s1,0
loop:
	lbu $t0, 0($s0)
	beqz $t0, done2
	addi $s0, $s0, 1	# move string forward
	move $a0, $t0
	jal is_upper_case
	beqz $v0, loop
	addi $s1, $s1, 1
	j loop
	
done2:	move $v0, $s1

	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	addi $sp, $sp, 12
	jr $ra
.data
string1:	.asciiz ""
string2:	.asciiz "ABC"
string3:	.asciiz "there are none here"

