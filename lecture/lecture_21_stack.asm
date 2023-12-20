.text
	# invoke bar(1,2,3,4,5,6)
	li $a0, 1
	li $a1, 2
	li $a2, 3
	li $a3, 4
	
	addi $sp, $sp, -8
	li $t0, 5
	sw $t0, 0($sp)
	li $t0, 6
	sw $t0, 4($sp)
	jal bar
	addi $sp, $sp, 8
	move $s0, $v0
	
	li $v0, 10
	syscall

# Sum the arguments and return the value in $v0
# This function has 6 parameters
# The first four are in $a0 - $a3
# The last two are on the stack.
#
# +------------+
# | argument 6 |20      arguments, push by the caller
# | argument 5 |16
# |------------+
# |    s2      |12	saved registers pushed by the callee (ie bar)
# |    s1      | 8
# |    s0      | 4
# |    ra      | 0   <-- sp
# +------------|
bar:	addi $sp, $sp, -16
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)

	li $s0, 0xFF
	li $s1, 0xFE
	li $s2, 0x01
	
	li $v0, 0
	add $v0, $v0, $a0
	add $v0, $v0, $a1
	add $v0, $v0, $a2
	add $v0, $v0, $a3
	
	lw $t0, 16($sp)
	add $v0, $v0, $t0
	lw $t0, 20($sp)
	add $v0, $v0, $t0

	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	addi $sp, $sp, 16
done:	jr $ra

