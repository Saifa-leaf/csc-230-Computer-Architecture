#
# An introduction to interrupts.
# This code contains the minimum code to 
# respond to an interrupt from the external keyboard tool.
#
# More detail in the labs and lecture next week.
#
.text  
main:
# MARS starts with interrupts enabled, but we
# must specifically enable interrupts from the
# keyboard device:
	la $t0, 0xffff0000	# control register for MMIO Simulator "Receiver"
	lb $t1, 0($t0)
	ori $t1, $t1, 0x02	# Set bit 1 to enable Receiver interrupts (i.e., keyboard)
	sb $t1, 0($t0)

	li $at, 0x00000000
	li $t0, 0xFF
	li $t1, 0x37
loop:
	addiu $at, $at, 1
	b loop
	
.data
foobar:	.word 0x0

# NB:
# One only has $k0 and $k1 to use in the 
# exception handler.
# 
# One *cannot* use the stack to save registers
# If more than $k0 and $k1 are needed, then space
# in .kdata must be allocated.
#
# The easiest way to do this is static space for
# specific registers, but that makes the
# exception handler non-rentrant.
#
# Psuedo instructions cannot be used
# unless you first save $at (good question for a midterm, why?)
# 
# We are saving $at in a static location which makes this
# handler non-rentrant.
#
.kdata
save_at:
.word 0x00

# The exception handler must be at this location
.ktext 0x80000180

csc230_ehandler:
	# save $at so we can use pseudo-instructions
	or $k0, $zero, $at
	la $k1, save_at
	sw $k0, 0($k1)
	
	# We can end up here for three reasons:
	# A trap, an exception or an interrupt
	# In this class we will only deal with interrupts.
	# The reason we are here is in the cause register in coproc0 $13
	mfc0 $k0, $13
	andi $k1, $k0, 0x7C	# 7C: 01111100 --> mask to select bits 2 to 6 which is the exccode
				# ExcCode is 0 for interrupts
	srl  $k1, $k1, 2	# shift to make comparsion easier
	beq $k1, $zero, csc230_is_interrupt
	# If we get here it is either an exception or a trap
	# We aren't going to handle either.  
	j csc230_exit_ehandler

csc230_is_interrupt:
	nop
		
csc230_exit_ehandler:
	# restore $at
	la $k1, save_at
	lw $at, 0($k1)
	eret
	
