.text 

	li $8, 0xF1
	li $9, 0x01
	and $10, $8, $9
	beq $10, $0, zero
	li $10, 0
	j skip
zero:	li $10, 1
skip:	
	# tell mars we are done
	li $v0, 10
	syscall

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	li $8, 0xF0F0F0F0	# value to test
	li $9, 32		# loop counter
	li $10, 1		# mask
	li $11, 0		# zero count
	li $12, 0		# result of AND
loop:
	beq $9, $0, done
	and $12, $8, $10
	bne $12, $0, notzero
	addi $11, $11, 1
notzero:
	subi $9, $9, 1
	srl $8, $8, 1
	j loop
done:
	li $v0, 10
	syscall
	
	