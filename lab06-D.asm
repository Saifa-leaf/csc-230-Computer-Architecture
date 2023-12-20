.data

seven_segment:
	.byte 0x3f, 0x06, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x07, 0x7f, 0x6f, 0x5f, 0x7c, 0x39, 0x5e, 0x79, 0x71
	
.text
	addi $a0, $zero, 0x3f
	addi $a1, $zero, 1
	jal display_hex_digit	
	
	
	addi $a0, $zero, 0x6d
	addi $a1, $zero, 0
	jal display_hex_digit
	
finish:
	addi $v0, $zero, 10
	syscall


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
	lw $s2, 8($sp)
	lw $s1, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 12
	jr $ra
