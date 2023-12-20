.data

stringA: .asciiz "We're off to see the wizard,"
stringB: .asciiz "the wonderful wizard of OZ!"
stringC: .asciiz "I'll be back..."
stringD: .asciiz "Doh!"

string_space:
	.asciiz "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"


# Given the string address loaded in $8,
# find the length of the string and store
# that length is $10

.text
	la $8, stringD
	add $10, $0, $0
	la $11, string_space
	
loop_start:
	lb $9, 0($8)
	beq $9, $0, finish
	addi $8, $8, 1
	addi $10, $10, 1
	sb $9, 0($11)
	addi $11, $11, 1
	beq $0, $0, loop_start
	
	
finish:
	# Nothing more is needed
	
	# At this point length of the string
	# is stored in $9
