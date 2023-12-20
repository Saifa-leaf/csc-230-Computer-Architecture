	.data
KEYBOARD_EVENT_PENDING:
	.word	0x0
KEYBOARD_EVENT:
	.word   0x0
KEYBOARD_COUNTS:
	.space  128
NEWLINE:
	.asciiz "\n"
SPACE:
	.asciiz " "
	
	
	.eqv 	LETTER_a 97
	.eqv	LETTER_b 98
	.eqv	LETTER_c 99
	.eqv 	LETTER_D 100
	.eqv 	LETTER_space 32
	
	
	.text  
main:
# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

	la $s0, 0xffff0000	# control register for MMIO Simulator "Receiver"
	lb $s1, 0($s0)
	ori $s1, $s1, 0x02	# Set bit 1 to enable "Receiver" interrupts (i.e., keyboard)
	sb $s1, 0($s0)

check_for_event:
	la $s0, KEYBOARD_EVENT_PENDING
	lw $s1, 0($s0)
	bnez $s1, check
	j check_for_event
check:
	sw $s1, KEYBOARD_EVENT
	beq $s1, LETTER_a, pressA
	beq $s1, LETTER_b, pressB
	beq $s1, LETTER_c, pressC
	beq $s1, LETTER_D, pressD
	beq $s1, LETTER_space, print
	j done
pressA:
	la $t0, KEYBOARD_COUNTS
	lw $t1, 0($t0)
	addi $t1, $t1, 1
	sw $t1, KEYBOARD_COUNTS
	j done
pressB:
	la $t0, KEYBOARD_COUNTS+4
	lw $t1, 0($t0)
	addi $t1, $t1, 1
	sw $t1, KEYBOARD_COUNTS+4
	j done
pressC:
	la $t0, KEYBOARD_COUNTS+8 
	lw $t1, 0($t0)
	addi $t1, $t1, 1
	sw $t1, KEYBOARD_COUNTS+8
	j done
pressD:
	la $t0, KEYBOARD_COUNTS+12
	lw $t1, 0($t0)
	addi $t1, $t1, 1
	sw $t1, KEYBOARD_COUNTS+12
	j done
print:
	li $v0, 1
	la $a1, KEYBOARD_COUNTS
	lw $a0, 0($a1)
	syscall
	la $a0, SPACE
	li $v0, 4
	syscall
	li $v0, 1
	la $a1, KEYBOARD_COUNTS
	lw $a0, 4($a1)
	syscall
	la $a0, SPACE
	li $v0, 4
	syscall
	li $v0, 1
	lw $a0, 8($a1)
	syscall
	la $a0, SPACE
	li $v0, 4
	syscall
	li $v0, 1
	lw $a0, 12($a1)
	syscall
	la $a0, NEWLINE
	li $v0, 4
	syscall
done:
	li $s1, 0
	sw $zero, KEYBOARD_EVENT_PENDING
	beq $zero, $zero, check_for_event
	


	.kdata

	.ktext 0x80000180
__kernel_entry:
	mfc0 $k0, $13		# $13 is the "cause" register in Coproc0
	andi $k1, $k0, 0x7c	# bits 2 to 6 are the ExcCode field (0 for interrupts)
	srl  $k1, $k1, 2	# shift ExcCode bits for easier comparison
	beq $zero, $k1, __is_interrupt

__is_interrupt:
	andi $k1, $k0, 0x0100	# examine bit 8
	bne $k1, $zero, __is_keyboard_interrupt	 # if bit 8 set, then we have a keyboard interrupt.
	
__is_keyboard_interrupt:
	la $k0, 0xffff0004
	lw $k1, 0($k0)	
	sw $k1, KEYBOARD_EVENT_PENDING
	
__exit_exception:
	eret
	
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE

	
