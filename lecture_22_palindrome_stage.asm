#
# palindrom example
#
.text
	la $a0, str1
	jal is_pali
	
	or $a0, $v0, $zero	# move the result to v0 for printing
	li $v0, 1		# select the print integer service
	syscall

	la $a0, str2
	jal is_pali
	
	or $a0, $v0, $zero	# move the result v0 for printing
	li $v0, 1		# select the print integer service
	syscall

	li $v0, 10		# print string service
	syscall

# $t0 - current character from start of string 
# $t1 - current character from end of string
#
# $v0 - 1 if string is palindrome, 0 otherwise
# Stack frame:
# | $ra | 0
# +-----|
is_pali:

	li $v0, 1
	addi $sp, $sp, -4
	sw $ra, ($sp)
	li $t3, 0
	li $t4, 0
	add $t2, $t4, $a0
	lb $t1, ($t2)
get_end:
	beqz $t1, done1
	addi $t4, $t4, 1
	add $t2, $t4, $a0
	lb $t1, ($t2)
	j get_end
done1:
	subi $t4, $t4, 1
	add $t2, $t4, $a0
	lb $t1, ($t2)
	add $t2, $t3, $a0
	lb $t0, ($t2)
	
check_pa:
	bne $t0, $t1, out
	beqz $t0, finish
	subi $t4, $t4, 1
	addi $t3, $t3, 1
	add $t2, $t4, $a0
	lb $t1, ($t2)
	add $t2, $t3, $a0
	lb $t0, ($t2)
	j check_pa
out:
	li $v0, 0
finish:	
	lw $ra, ($sp)
	addi $sp, $sp, 4
	jr $ra
.data 
str1: .asciiz "abccba"
str2: .asciiz "abc"
