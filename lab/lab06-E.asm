.data

seven_segment:
	.byte 0x3f, 0x06, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x07, 0x7f, 0x6f, 0x5f, 0x7c, 0x39, 0x5e, 0x79, 0x71
	
.text
	addi $a0, $zero, 0x2b
	jal count_up_with_display
	jal display_dashes
	
finish:
	addi $v0, $zero, 10
	syscall


# $a0: Maximum counter value

count_up_with_display:
	addi $sp, $sp, -16
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	
	la $t0, seven_segment	# hold address
	add $t1, $zero, $zero	# temp hold byte from 7_segment
	addi $s0, $a0, 1	# final count
	li $s1, 0		# count right
	li $s2, 0		# count left
	li $a0, 0		# $a0: hex digit to be displayed
	li $a1, 0		# $a1: 0 == right display; 1 == left display

loop:
	beqz $s0, finish2
	
	add $t1, $s2, $t0
	lb $a0, ($t1)
	li $a1, 1
	jal display_hex_digit	
	add $t1, $s1, $t0
	lb $a0, ($t1)
	li $a1, 0
	jal display_hex_digit
	
	addi $s1, $s1, 1
	subi $s0, $s0, 1
	bne $a0 , 0x71, skip
	li $s1, 0
	addi $s2, $s2, 1
skip:
	jal delay_400_msec
	j loop
	
	
finish2:
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	addi $sp, $sp, 16
	jr $ra


# $a0: hex digit to be displayed
# $a1: 0 == right display; 1 == left display

display_hex_digit:
	addi $sp, $sp, -12
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	
	add $s0, $a0, $zero
	add $s1, $a1, $zero
	beqz $s1, else
if:
	la $s2, 0xffff0011
	sb $s0, 0($s2)
	j done
else:
	la $s2, 0xffff0010
	sb $s0, 0($s2)
	j done
done:	
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	addi $sp, $sp, 12
	jr $ra
	
	
delay_400_msec:
	addi $sp, $sp -4
	sw $ra, 0($sp)
	
	addi $a0, $zero, 400
	addi $v0, $zero, 32
	syscall
	
	lw $ra, 0($sp)
	add $sp, $sp, 4
	jr $ra
	

display_dashes:
	addi $sp, $sp, -20
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	
	la $s0, 0xffff0010
	la $s1, 0xffff0011
	addi $s2, $zero, 0x40
	addi $s3, $zero, 0x40
	sb $s2, 0($s0)
	sb $s3, 0($s1)
	
	lw $s3, 16($sp)
	lw $s2, 12($sp)
	lw $s1, 8($sp)
	lw $s0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 20
	jr $ra
	jr $ra
	
