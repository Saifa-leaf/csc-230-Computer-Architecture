.text
	la $8, thestring	# pointer to string
	li $9, 0		# counter for length
	li $10, 0		# current character
	
	# write a sequence of instructions	
		
loop:	lbu $10, 0($8)
	beq $10, $0, done
	addiu $8, $8, 1
	addiu $9, $9, 1
	j loop
done:

	li $v0, 10
	syscall


.data
thestring:	.asciiz	"This is it"
