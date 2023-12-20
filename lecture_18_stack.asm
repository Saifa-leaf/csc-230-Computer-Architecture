.text

	la $a0, string1
	jal str_len
	move $s0, $v0
	
	la $a0, string2
	jal str_len
	move $s1, $v0
	
	la $a0, string3
	jal str_len
	move $s2, $v0
	
	li $v0, 10
	syscall

# $a0 - address of the string to find length of
# $v0 - the length of the string
# $t0 - the current character
#
str_len:	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	li $v0, 0
count:
	lb $t0, 0($a0)
	beq $t0, $zero, done
	addi $a0, $a0, 1
	addi $v0, $v0, 1
	j count
	
done:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
.data
string1:	.asciiz ""
string2:	.asciiz "a"
string3:	.asciiz "abc"
