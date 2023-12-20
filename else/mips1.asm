.text
# count 0 in $8

	li $8, 0x0fa500	#num
	li $9, 0	#loop count
	li $10, 0	#check last num
	li $11, 0	#result
loop:
	beq $9, 32, done
	addi $9,$9 ,1 
	andi $10, $8, 1 
	srl $8, $8, 1
	beqz $10, plus
	j loop
plus:
	addi $11, $11, 1
	j loop
done:
	nop
