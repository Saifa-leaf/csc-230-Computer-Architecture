.data

bob:
	.word 212
	
connie:
	.word 40122
	
.text
	# Store the sum of integer
	# at 'bob' and integer at
	# 'connie' into register
	# $12 -- and without using
	# bob or connie directly
	# in a 'lw' instruction
	# (ie must use register and
	# an offset of zero).
	