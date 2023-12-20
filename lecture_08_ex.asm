.text

# If the 2nd bit (where the rightmost bit is the 0th bit) of $8:
#   is 1, set $9 to 0xFF
#   is 0, set %9 to 0xAA

	li $8, 0xFF
	
   
# Sum the integers from 1 to the value in $8.
# store the result in $10
#
# Pre-conditions:
#   $8 > 1

	li $8, 10
	# Your code here
	li $9, 0 #count
	li $10, 0 #sum
while:
	beq $9, $8, done
		add $10, $9, $10
		addi $9, $9, 1 
		j while
	
done:
	add $10, $9, $10
	nop
	
	
	

