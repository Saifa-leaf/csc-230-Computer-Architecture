#
# An initial example using the stack to protect $ra so that
# subroutines can be invoked from within another subroutine
#
.text
	jal bar
	nop
	jal bar
	nop 
	jal bar
	li $v0, 10
	syscall
	
	
bar:	addi $sp, $sp, -4	# allocate space on the stack for $ra
	sw $ra, 0($sp)		# save $ra's value on entry into the subroutine
	
	jal foobar
	nop
	
	lw $ra, 0($sp)		# restore $ra 
	addi $sp, $sp, 4	# deallocate space on the stack
	jr $ra			# return from subroutine
	
	# 
	# This subroutine is a leaf -- it does not call
	# any other subroutines so it does not protect
	# $ra
	#  
foobar:	nop
	jr $ra
