.data

nums:
	.word 1, 3, 5, -11, 22, 33, -4, 5, 0

	
.text
	li $8, 0 #sum
	# $12 is current num
	li $10, 0xdeadbeef
	
	la $11, nums
	lw $12, ($11)
sum:
	beqz $12, done
	lw $12, ($11)
	add $8, $8, $12
	add $11, $11, 4
	j sum
done:
	nop
	
	
