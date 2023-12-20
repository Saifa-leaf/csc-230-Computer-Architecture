.text 
	# $8 : initial value for which we look for trailing zeros
	# $9 : the counter to keeps track of # of trailing zeros (result)
	# $10 :  the result of the AND with the mask
	
	ori $8, $0, 0xc800	      # same as "addi $8, $0, 0xc800"
# problem up here   ^   when using 0 we get an infinite loop
# solution, check if initial value is 0
	beqz $8, exit
		
	ori $9, $0, 0		# counter
loop:
	andi $10, $8, 1
	bne $10, $0, exit
	addi $9, $9, 1
	srl $8, $8, 1
	b loop
	
exit: 
	nop			# answer is in $9
	
	
