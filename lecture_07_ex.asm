# This is an assembler directive (anthing that starts with a . is an assembler directive)
# It tells the assembler that what follows should be placed in the "text" section, which
# is where executable code goes.
.text

# For now, you should use registers $2 to $25 inclusive.  
# The other registers have special conventions.  We
# will talk about this in more detail later.

	addi $9, $0, 1
	add $10, $9, $9         # $10 = $9+$9
	add $10, $10, $9  

	li $11, 1
	# This instruction does nothing.  No operation == nop
	nop
	nop
	
	li $12, 0xFFFFFFFF
	li $13, 0x000F0000
	and $14, $12, $13
	
	li $15, 0
	li $16, 0xF0F0F0F0
	or $17, $15, $16

	li $9, 5	
# This is a label, which can be a destination of a branch	
loop:	
	beq $9, $0, done	# compare $9 to $0, if they are equal goto done, 
				# otherwise execute the next instruction as normal
	subi $9, $9, 1

	j loop			# always goto loop.
done:
	nop
	# for now, don't worry about how these next two lines
	# work, just put them at the end of your program to
	# have it terminate gracefully.
	# We will discuss this in more detail later.
	li   $v0, 10          # system call for exit
	syscall
	
