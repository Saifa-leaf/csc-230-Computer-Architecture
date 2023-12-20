.text

# $8 is pointer to the array
# $9 is pointer to count
# $10 is a pointer to x
# $11 is the counter
# $12 is the sum
# 

	la $8, array
	la $9, count
	la $10, x
	lw $11, 0($9)
	li $12, 0
loop:
	beq $11, 0, skip
	lw $13, 0($8)
	addu $12, $12, $13
	subi $11, $11, 1
	addiu $8, $8, 4
	j loop
skip:
	sw $12, 0($10)
		
	li $v0, 10
	syscall

.data
array:	.word 7, 8, 9, 10
count:	.word 4
x:	.word 0
