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
	
	.globl main
	.text	
main:
	addi $a0, $zero, 0
	addi $a1, $zero, 0
	addi $a2, $zero, 0x00ffff00
	jal set_pixel
	
	addi $a0, $zero, 15
	addi $a1, $zero, 15
	addi $a2, $zero, 0x00ff0000
	jal set_pixel
	
	addi $a0, $zero, 7
	addi $a1, $zero, 7
	addi $a2, $zero, 0x00ffa500
	jal set_pixel
	
	addi $a0, $zero, 8
	addi $a1, $zero, 8
	addi $a2, $zero, 0x00aaaaaa
	jal set_pixel
	
	addi $a0, $zero, 0
	addi $a1, $zero, 0
	li $s0, 0
	li $s1, 0
	li $s2, 0x123456
loop:
	beq $s0, 16, check
	li $v0, 41
	move $a0, $s2
	syscall
	move $s2, $a0
	move $a0, $s0
	move $a1, $s1 
	move $a2, $s2
	jal set_pixel
	addi $s0, $s0, 1
	j loop
check:
	beq $s1, 15, done
	li $s0, 0
	addi $s1 ,$s1, 1
	j loop
done:
	addi $v0, $zero, 10
	syscall
	
