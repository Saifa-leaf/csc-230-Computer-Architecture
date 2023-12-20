# UVic CSC 230, Summer 2020
#
# Howdy, world!

	.data
howdy_string:
	.asciiz	"\nHello! My name is Saifa Leechitcham!\n\n"
howdy_number:
	.asciiz "V00965399\n"
	
	
	.text
main:
	li	$v0, 4
	la	$a0, howdy_string
	syscall
	
	li	$v0, 4
	la	$a0, howdy_number
	syscall
	
	li	$v0, 10
	syscall
