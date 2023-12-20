#
# str_equal example
#
.text
	la $a0, str1
	la $a1, str2
	jal str_equal
	
	or $a0, $v0, $zero	# move the result to v0 for printing
	li $v0, 1		# select the print integer service
	syscall

	li $v0, 10		
	syscall

# $t0 - current character in $a0
# $t1 - current character in $a1
# $t2 - current address pointer
# $s0 - count to point to correct character
# $v0 - 1 if strings are equal, 0 otherwise
# Stack frame:
# |-$s1-| 8
# |-$s0-| 4
# | $ra | 0
# |-----|
str_equal:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	li $t3, 0
	add $t2, $t3, $a0
	lb $t0, ($t2)
	add $t2, $t3, $a1
	lb $t1, ($t2)
	li $v0, 1
	
loop:
	bne $t0, $t1, out
	beqz $t0, finish
	addi $t3, $t3, 1
	add $t2, $t3, $a0
	lb $t0, ($t2)
	add $t2, $t3, $a1
	lb $t1, ($t2)
	j loop
	
out:	
	li $v0, 0
finish:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
.data 
str1: .asciiz "abc"
str2: .asciiz "abc"
