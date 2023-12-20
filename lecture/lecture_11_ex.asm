.text
	la $8, loc1
	lw $9, 0($8)

	la $8, loc2
	lw $10, 0($8)
	
	la $8, loc3
	lw $11, 0($8)
	lbu $12, 0($8)
	lb $13, 0($8)
	
	li $v0, 10
	syscall
.data

loc1:
.word 0xDEADBEEF
loc2:
.word 0x0
loc3:
.byte 0xDE, 0xAD, 0xBE, 0xEF
loc4:
.byte 0x0

