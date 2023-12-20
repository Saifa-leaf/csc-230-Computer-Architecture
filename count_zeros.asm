# $ 8 - value = 0x00				0b0001010101011111 
# $ 9 - loopcount = 32				0b0000000000000001
# $10 - mask = 1				==================
# $11 - count = 0
# $12 - temp  = 0
# while (loopcount != 0) {
#  temp = val & mask
#  if (temp == 0) {
#    count++
#  }
#  value = value >> 1
#  loopcount--
# }

.text
	li $8, 0xF0F0F0F0	# every mips instruction is 32 bits
	li $9, 32
	li $10, 1
	li $11, 0
	li $12, 0
loop:
	beq $9, 0, done
	and $12, $8, $10
	bne $12, 0, skip
	addiu $11, $11, 1
skip:	
	srl $8, $8, 1
	subiu $9, $9, 1	
	j loop
done:
	li $v0, 10
	syscall
	
