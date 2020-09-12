.data
hello: .asciiz "Hello World"
exit_label: .asciiz "It's completed\n"

.text
# Given a register that is is FFFF in $t0 we want to print the binary value that is in it
li $t0, 0xFFFF

# Testing print_bin print the hexadecimal in $t0 in binary
print_bin:
	# Keep in mind that we can use masking to print the values
	# $t1 will be the register that have 1 to the most sinificant bit to do the masking
	li $t1, 1 
	sll $t1, $t1 15 # Shift to right 15 bits to palce it in the 16's digit
	
	# Now mask and continue until the mask reaches 0 
	loop:
		# We only branch away if the mask is equal to 0 meaning that we are done
		beq $t1, $0, exit_bin_loop
		
		# And we AND here where $t3 will store the result
		and $t3, $t1, $t0
		
		# We branch if the result is 1 to print 1
		bne $t3, $0, print_one
		
		# We branch if the result is 0 to print 0
		beq $t3, $0, print_zero
		
		continue_after_print:
		# Then we will shift the masking register to the right 1 bit
		srl $t1, $t1, 1
		
		# And jump back up the loop
		j loop
		
		
		
	exit_bin_loop:
		# If we are here then that means we are done printing
		# Load in the new line ascii into $t5 and print it
		li $a0, '\n'
		li $v0, 11
		syscall
		j exit
	
print_one:
	li $a0, 1
	li $v0, 1
	syscall
	
	j continue_after_print


print_zero:
	li $a0, 0
	li $v0, 1
	syscall
	
	j continue_after_print

exit:
	li $v0, 4
	la $a0, exit_label
	syscall
	