.text


main:	



# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

	## Test code that calls procedure for part A
	# jal save_our_souls

	## morse_flash test for part B
	# addi $a0, $zero, 0x42   # dot dot dash dot
	# jal morse_flash
	
	## morse_flash test for part B
	# addi $a0, $zero, 0x37   # dash dash dash
	# jal morse_flash
		
	## morse_flash test for part B
	# addi $a0, $zero, 0x32  	# dot dash dot
	# jal morse_flash
			
	## morse_flash test for part B
	# addi $a0, $zero, 0x11   # dash
	# jal morse_flash	
	
	# flash_message test for part C
	# la $a0, test_buffer
	# jal flash_message
	
	# letter_to_code test for part D
	# the letter 'P' is properly encoded as 0x46.
	# addi $a0, $zero, 'P'
	# jal letter_to_code
	
	# letter_to_code test for part D
	# the letter 'A' is properly encoded as 0x21
	# addi $a0, $zero, 'A'
	# jal letter_to_code
	
	# letter_to_code test for part D
	# the space' is properly encoded as 0xff
	# addi $a0, $zero, ' '
	# jal letter_to_code
	
	# encode_message test for part E
	# The outcome of the procedure is here
	# immediately used by flash_message
	 la $a0, message03
	 la $a1, buffer01
	 jal encode_message
	 la $a0, buffer01
	 jal flash_message
	
	
	# Proper exit from the program.
	addi $v0, $zero, 10
	syscall

	
	
###########
# PROCEDURE
save_our_souls:
	jal seven_segment_on
	jal delay_short
	jal seven_segment_off
	jal delay_long
	jal seven_segment_on
	jal delay_short
	jal seven_segment_off
	jal delay_long
	jal seven_segment_on
	jal delay_short
	jal seven_segment_off
	jal delay_long
	jal seven_segment_on
	jal delay_long
	jal seven_segment_off
	jal delay_long
	jal seven_segment_on
	jal delay_long
	jal seven_segment_off
	jal delay_long
	jal seven_segment_on
	jal delay_long
	jal seven_segment_off
	jal delay_long
	jal seven_segment_on
	jal delay_short
	jal seven_segment_off
	jal delay_long
	jal seven_segment_on
	jal delay_short
	jal seven_segment_off
	jal delay_long
	jal seven_segment_on
	jal delay_short
	jal seven_segment_off
	jal delay_long
	jr $31


# PROCEDURE
# $s0 - store one byte from $a0 
# $s1 - 4 right bit from $s0
# $s2 - 4 left bit from $s0
# $t0 - copy of $s2 to count how many reverse operation 
# $t1 - check last bit in reverse
# $t2 - left most bit
morse_flash:
	addi $sp, $sp, -16
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	
	move $s0, $a0
	andi $s1, $s0, 0x0f
	andi $s2, $s0, 0xf0
	srl $s2, $s2, 4
	li $t3, 0
	
reverse:		
	addi $t0, $s2, 0
	li $t1, 0 
	li $t2, 0

loop_r:
	beqz $t0, exit
	subi $t0, $t0, 1
	li $t1, 0
	andi $t1, $s1, 1
	srl $s1, $s1, 1
	beq $t1, 1, append
	sll $t2, $t2, 1
	j loop_r

append:
	sll $t2, $t2, 1
	addi $t2, $t2, 1
	j loop_r

exit:	
	move $s1, $t2
	bne $s2, 0xf, cont
	jal delay_long
	jal delay_long
	jal delay_long
	j done_morse_flash
cont:	
	beqz $s2, done_morse_flash
	li $t3, 0
	subi $s2, $s2, 1
	andi $t3, $s1, 1
	srl $s1, $s1, 1
	beq $t3, 1, dash
	jal seven_segment_on
	jal delay_short
	jal seven_segment_off
	jal delay_long
	j cont
dash:	
	jal seven_segment_on
	jal delay_long
	jal seven_segment_off
	jal delay_long
	j cont
	
done_morse_flash:
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	addi $sp, $sp, 16
	jr $ra
	

###########
# PROCEDURE
# $s0 - hold address in $a0
# $s1 - count to get address
# $s2 - hold each byte from $s0
# $a0 - to pass to morse_flash
flash_message:
	addi $sp, $sp, -16
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	
	move $s0, $a0
	li $s1, 0
	add $t0, $s1, $s0
	lb $a0, ($t0)

loop_flash_message:
	beqz $a0, finish_flash
	jal morse_flash
	addi $s1, $s1, 1
	add $t0, $s1, $s0
	lb $a0, ($t0)
	j loop_flash_message
	
finish_flash:
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	addi $sp, $sp, 16
	jr $ra
	
	
###########
# PROCEDURE
# $s0 - store codes address
# $s1 - store $a0
# $t0 - hold current byte address
# $t1 - hold current byte
# $t2 - count, to tell which address to load byte from
# $t3 - tell whatever it's a dot or dash
# $t4 - count number of dot/dash
letter_to_code:
	addi $sp, $sp, -16
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	
	li $v0, 0
	la $s0, codes
	move $s1, $a0
	add $t0, $t2, $s0
	lb $t1, ($t0)
	li $t2, 0
	li $t3, 0
	li $t4, 0
	bne $s1, ' ', find_letter
	addi $v0, $v0, 0xff
	j finish_letter
find_letter:
	beq $t1, $s1, found
	addi $t2, $t2, 8
	add $t0, $t2, $s0
	lb $t1, ($t0)
	j find_letter
found:
	addi $t2, $t2, 1
	add $t0, $t2, $s0
	lb $t1, ($t0)
decode:
	beqz $t1, dot_dash_count
	li $t3, 0
	andi $t3, $t1, 1
	beqz $t3, dot
	addi $v0, $v0, 1
dot:
	addi $t2, $t2, 1
	add $t0, $t2, $s0
	lb $t1, ($t0)
	addi $t4, $t4, 1
	beqz $t1, dot_dash_count
	sll $v0, $v0, 1
	j decode
dot_dash_count:
	beqz $t4, finish_letter
	addi $v0, $v0, 16
	subi $t4, $t4, 1
	j dot_dash_count
	
finish_letter:
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	addi $sp, $sp, 16
	jr $ra	


###########
# PROCEDURE
# $s0 - copy of $a0 (address of sentence)
# $s1 - copy of $a1 (buffer)
# $s2 - count for position in buffer and $s0
# $s3 - temp hold current address
encode_message:
	addi $sp, $sp, -16
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	
	move $s0, $a0
	move $s1, $a1 
	li $s2, 0
	add $s3, $s2, $s0
	lb $a0, ($s3)
	
loop_encode:	
	beqz $a0, done_encode 
	jal letter_to_code
	sb $v0, ($s1)
	addi $s1, $s1, 1
	addi $s2, $s2, 1
	add $s3, $s2, $s0
	lb $a0, ($s3)
	j loop_encode
	
done_encode:
	sub $s1, $s1, $s2
	move $a1, $s1
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	addi $sp, $sp, 16
	jr $ra

# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE

#############################################
# DO NOT MODIFY ANY OF THE CODE / LINES BELOW

###########
# PROCEDURE
seven_segment_on:
	la $t1, 0xffff0010     # location of bits for right digit
	addi $t2, $zero, 0xff  # All bits in byte are set, turning on all segments
	sb $t2, 0($t1)         # "Make it so!"
	jr $31


###########
# PROCEDURE
seven_segment_off:
	la $t1, 0xffff0010	# location of bits for right digit
	sb $zero, 0($t1)	# All bits in byte are unset, turning off all segments
	jr $31			# "Make it so!"
	

###########
# PROCEDURE
delay_long:
	add $sp, $sp, -4	# Reserve 
	sw $a0, 0($sp)
	addi $a0, $zero, 600
	addi $v0, $zero, 32
	syscall
	lw $a0, 0($sp)
	add $sp, $sp, 4
	jr $31

	
###########
# PROCEDURE			
delay_short:
	add $sp, $sp, -4
	sw $a0, 0($sp)
	addi $a0, $zero, 200
	addi $v0, $zero, 32
	syscall
	lw $a0, 0($sp)
	add $sp, $sp, 4
	jr $31




#############
# DATA MEMORY
.data
codes:
	.byte 'A', '.', '-', 0, 0, 0, 0, 0
	.byte 'B', '-', '.', '.', '.', 0, 0, 0
	.byte 'C', '-', '.', '-', '.', 0, 0, 0
	.byte 'D', '-', '.', '.', 0, 0, 0, 0
	.byte 'E', '.', 0, 0, 0, 0, 0, 0
	.byte 'F', '.', '.', '-', '.', 0, 0, 0
	.byte 'G', '-', '-', '.', 0, 0, 0, 0
	.byte 'H', '.', '.', '.', '.', 0, 0, 0
	.byte 'I', '.', '.', 0, 0, 0, 0, 0
	.byte 'J', '.', '-', '-', '-', 0, 0, 0
	.byte 'K', '-', '.', '-', 0, 0, 0, 0
	.byte 'L', '.', '-', '.', '.', 0, 0, 0
	.byte 'M', '-', '-', 0, 0, 0, 0, 0
	.byte 'N', '-', '.', 0, 0, 0, 0, 0
	.byte 'O', '-', '-', '-', 0, 0, 0, 0
	.byte 'P', '.', '-', '-', '.', 0, 0, 0
	.byte 'Q', '-', '-', '.', '-', 0, 0, 0
	.byte 'R', '.', '-', '.', 0, 0, 0, 0
	.byte 'S', '.', '.', '.', 0, 0, 0, 0
	.byte 'T', '-', 0, 0, 0, 0, 0, 0
	.byte 'U', '.', '.', '-', 0, 0, 0, 0
	.byte 'V', '.', '.', '.', '-', 0, 0, 0
	.byte 'W', '.', '-', '-', 0, 0, 0, 0
	.byte 'X', '-', '.', '.', '-', 0, 0, 0
	.byte 'Y', '-', '.', '-', '-', 0, 0, 0
	.byte 'Z', '-', '-', '.', '.', 0, 0, 0
	
message01:	.asciiz "A A A"
message02:	.asciiz "SOS"
message03:	.asciiz "WATERLOO"
message04:	.asciiz "DANCING QUEEN"
message05:	.asciiz "CHIQUITITA"
message06:	.asciiz "THE WINNER TAKES IT ALL"
message07:	.asciiz "MAMMA MIA"
message08:	.asciiz "TAKE A CHANCE ON ME"
message09:	.asciiz "KNOWING ME KNOWING YOU"
message10:	.asciiz "FERNANDO"

buffer01:	.space 128
buffer02:	.space 128
test_buffer:	.byte 0x30 0x37 0x30 0x00    # This is SOS
