# This code assumes the use of the "Bitmap Display" tool.
#
# Tool settings must be:
#   Unit Width in Pixels: 32
#   Unit Height in Pixels: 32
#   Display Width in Pixels: 512
#   Display Height in Pixels: 512
#   Based Address for display: 0x10010000 (static data)
#
# In effect, this produces a bitmap display of 16x16 pixels.


	.include "bitmap-routines.asm"

	.data
TELL_TALE:
	.word 0x12345678 0x9abcdef0	# Helps us visually detect where our part starts in .data section
KEYBOARD_EVENT_PENDING:
	.word	0x0
KEYBOARD_EVENT:
	.word   0x0
BOX_ROW:
	.word	0x0
BOX_COLUMN:
	.word	0x0

	.eqv LETTER_a 97
	.eqv LETTER_d 100
	.eqv LETTER_w 119
	.eqv LETTER_x 120
	.eqv BOX_COLOUR 0x0099ff33
	
	.globl main
	
	.text	
main:
# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

	# initialize variables
	la $s0, 0xffff0000	# control register for MMIO Simulator "Receiver"
	lb $s1, 0($s0)
	ori $s1, $s1, 0x02	# Set bit 1 to enable "Receiver" interrupts (i.e., keyboard)
	sb $s1, 0($s0)
	
	la $t0, BOX_ROW
	lw $a0, ($t0)
	la $t0, BOX_COLUMN
	lw $a1, ($t0)
	li $a2, BOX_COLOUR
	jal draw_bitmap_box
	
check_for_event:
	la $s0, KEYBOARD_EVENT_PENDING
	lw $s1, 0($s0)
	bnez $s1, check
	j check_for_event
check:
	beq $s1, LETTER_a, press
	beq $s1, LETTER_d, press
	beq $s1, LETTER_w, press
	beq $s1, LETTER_x, press
	j done
press:
	la $t0, BOX_ROW
	lw $a0, ($t0)
	la $t0, BOX_COLUMN
	lw $a1, ($t0)
	li $a2, 0
	jal draw_bitmap_box
	beq $s1, LETTER_a, press_a
	beq $s1, LETTER_d, press_d
	beq $s1, LETTER_w, press_w
	beq $s1, LETTER_x, press_x

press_a:
	la $t0, BOX_COLUMN
	lw $a1, ($t0)
	addi $a1, $a1, -1
	sw $a1, BOX_COLUMN
	j box
press_d:
	la $t0, BOX_COLUMN
	lw $a1, ($t0)
	addi $a1, $a1, 1
	sw $a1, BOX_COLUMN
	j box	
press_w:
	la $t0, BOX_ROW
	lw $a1, ($t0)
	addi $a1, $a1, -1
	sw $a1, BOX_ROW
	j box
press_x:
	la $t0, BOX_ROW
	lw $a1, ($t0)
	addi $a1, $a1, 1
	sw $a1, BOX_ROW
	j box
box:
	la $t0, BOX_ROW
	lw $a0, ($t0)
	la $t0, BOX_COLUMN
	lw $a1, ($t0)
	li $a2, BOX_COLOUR
	jal draw_bitmap_box
done:
	sw $zero, KEYBOARD_EVENT_PENDING
	la $s0, KEYBOARD_EVENT_PENDING
	lw $s1, 0($s0)
	beq $zero, $zero, check_for_event
	
	
	# Should never, *ever* arrive at this point
	# in the code.	

	addi $v0, $zero, 10

.data
    .eqv BOX_COLOUR_BLACK 0x00000000
.text

	addi $v0, $zero, BOX_COLOUR_BLACK
	syscall



# Draws a 4x4 pixel box in the "Bitmap Display" tool
# $a0: row of box's upper-left corner
# $a1: column of box's upper-left corner
# $a2: colour of box

draw_bitmap_box:
#
# You can copy-and-paste some of your code from part (c)
# to provide the procedure body.
#
	addi $sp, $sp, -24
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	addi $s3, $s0, 4
	addi $s4, $s1, 3
	
loop:
	beq $s0, $s3, check2
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	jal set_pixel
	addi $s0, $s0, 1
	j loop
	
check2:
	beq $s1, $s4, done2
	subi $s0, $s0, 4
	addi $s1, $s1, 1
	j loop
done2:
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	addi $sp, $sp, 24
	jr $ra


	.kdata

	.ktext 0x80000180
#
# You can copy-and-paste some of your code from part (a)
# to provide elements of the interrupt handler.
#
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


.data

# Any additional .text area "variables" that you need can
# be added in this spot. The assembler will ensure that whatever
# directives appear here will be placed in memory following the
# data items at the top of this file.

	
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE


.eqv BOX_COLOUR_WHITE 0x00FFFFFF
	
