# Ricky Lu
# rilu
# 112829937

.data
# Command-line arguments
num_args: .word 0
addr_arg0: .word 0
addr_arg1: .word 0
addr_arg2: .word 0
addr_arg3: .word 0
addr_arg4: .word 0
addr_arg5: .word 0
addr_arg6: .word 0
addr_arg7: .word 0
no_args: .asciiz "You must provide at least one command-line argument.\n"

# Output messages
big_bobtail_str: .asciiz "BIG_BOBTAIL\n"
full_house_str: .asciiz "FULL_HOUSE\n"
five_and_dime_str: .asciiz "FIVE_AND_DIME\n"
skeet_str: .asciiz "SKEET\n"
blaze_str: .asciiz "BLAZE\n"
high_card_str: .asciiz "HIGH_CARD\n"

# Error messages
invalid_operation_error: .asciiz "INVALID_OPERATION\n"
invalid_args_error: .asciiz "INVALID_ARGS\n"

# Put your additional .data declarations here, if any.
it_happened: .asciiz "It happened!\n"

# Main program starts here
.text
.globl main
main:
    # Do not modify any of the code before the label named "start_coding_here"
    # Begin: save command-line arguments to main memory
    sw $a0, num_args
    beqz $a0, zero_args
    li $t0, 1
    beq $a0, $t0, one_arg
    li $t0, 2
    beq $a0, $t0, two_args
    li $t0, 3
    beq $a0, $t0, three_args
    li $t0, 4
    beq $a0, $t0, four_args
    li $t0, 5
    beq $a0, $t0, five_args
    li $t0, 6
    beq $a0, $t0, six_args
seven_args:
    lw $t0, 24($a1)
    sw $t0, addr_arg6
six_args:
    lw $t0, 20($a1)
    sw $t0, addr_arg5
five_args:
    lw $t0, 16($a1)
    sw $t0, addr_arg4
four_args:
    lw $t0, 12($a1)
    sw $t0, addr_arg3
three_args:
    lw $t0, 8($a1)
    sw $t0, addr_arg2
two_args:
    lw $t0, 4($a1)
    sw $t0, addr_arg1
one_arg:
    lw $t0, 0($a1)
    sw $t0, addr_arg0
    j start_coding_here

zero_args:
    la $a0, no_args
    li $v0, 4
    syscall
    j exit
    # End: save command-line arguments to main memory

start_coding_here:
    # Start the assignment by writing your code here
    # This loads the first argument into register $s0 and ready for checking length
    lw $s0, addr_arg0
    
    # $t2 will for now hold the counter for the length of characters in $t1
    li $t2, 0
    
    # Now we have to check the length using a for loop
    checkLengthLoop:
    	# Load in the character from the given register with the address into register $t3
    	lbu $t3, 0($s0)
    	
    	# If we reach the null terminating character we get out of the for loop
    	# Otherwise we stay in it
    	beqz $t3,exitCheckLengthLoop
    	
    	# Increment counter
    	addi $t2, $t2, 1
    	
    	# Get the address of next character using the same address
    	addi $s0, $s0, 1
    	
    	# Jump back for looping
    	j checkLengthLoop
    
    exitCheckLengthLoop:
    	# If we are here then that means we are done checking the length of the String
    	# If the length is greater than 1 we branch to exit because it is not an valid inptu
  	li $t4, 1 # Load 1 termporarily into register $t4 for comparing
    	bgt $t2, $t4, invalid_operator # If we branch that means more than 1 character
    	
    	# Reset $s0 register to the beginning of the word again
    	lw $s0, addr_arg0
    	
    	# Load the first character into register $t3 for comparsion
    	lbu $t3, 0($s0)
    	
	# Now if we are here we have to check input
	li $t5, 49 # $t5 have 1 the ascii code not the integer
	li $t6, 50 # $t6 have 2 the ascii code not the integer
	li $t7, 83 # $t7 have S
	li $s1, 70 # $s1 have F
	li $s2, 82 # $s2 have R
	li $s3, 80 # $s3 have P
	
	beq $t3, $t5, option_one # Option to 1
	beq $t3, $t6, option_two # Option to 2
	beq $t3, $t7, option_s # Option to S
	beq $t3, $s1, option_f # Option to F
	beq $t3, $s2, option_r # Option to R
	beq $t3, $s3, option_p # Option to P
	
	# If we reach here then that means the input matched none of the above hence
	# Exit
	j invalid_operator
	
option_one:
	# The input of 1 is reached here
	# We can load in $t5 as the argument comparer
	li $t5, 3
	
	# Expects 2 more arguments so total needs to be 3 argument in $a0 else invalid args
	# We branch away if the total argument is not equal to 3, and remain here if it is
	bne $a0, $t5, invalid_args
	
	# If we are here then that means we have to parse the second argument and make turn it into a two's complement
	# Hexadecimal. 
	# First step is to turn the 4 character into its hexadecimal value representation, not ascii
	# We will be storing converted result into $s1 (not the real answer)
	li $s1, 0 # Resetting register $t5
	
	# Load the second argument's starting address into register $t1
	lw $t1, addr_arg1
	
	li $t4, 48 # $t4 store 48 which is ascii for 1
	li $t5, 57 # $t5 stores 57 which is ascii for 9
	li $t6, 65 # $t6 stores 65 which is ascii for A
	li $t7, 70 # $t7 stores 70 which is ascii for F
	
	hexadecimal_loop_option_one: # This turns 4 char into hexadecimal of what it is suppose to represent
		# We will loop through the 4 characters one by one into register $t2
		lbu $t2, 0($t1)
		
		# Before we move on check if character is a terminating char, if it is equal to 0 then exit
		beq $t2, $0, finish_option_one_algorithm
		
		bgt $t4, $t2, invalid_args # If 48 is greater than the current ascii then it is definietly not 1-9, A-F
		bgt $t2, $t7, invalid_args # If the current ascii is greater than the 70 then it is not 1-9, A-F
		# Now we are bound between 48-70 inclusive
		ble $t2, $t5, is_number # It is a number if it is less than or equal 57
		bge $t2, $t6, is_letter # It is a letter if it is greater than or equal 65
		
		j invalid_args # The value is between 58-64 inclusive hence invalid
		
		is_letter:
		# If the ascii is letter we subtract 55
		addi $t2, $t2, -55
		j done_ascii_to_value
		
		is_number:
		# If the ascii is a number we subtract 48
		addi $t2, $t2, -48
	
		done_ascii_to_value:
		# If we are here that means we finish transforming the ascii char from ascii to decimal
		# We store that into $s1 and shift 4 bits to the left
		# Shift before add!
		sll $s1, $s1, 4 # Shift 4 bits to the left
		add $s1, $s1, $t2 # Adding it to the register
		# Increment address of the word to get the next character
		addi $t1, $t1, 1
	
		# Then we jump back up the loop
		j hexadecimal_loop_option_one
		
	finish_option_one_algorithm: 
		# This is where we turn the hexadecimal in $s1 from one's complement into two's complement
		# First we get the sign bit that is the most imporant information
		# The only register we can't use it $s1 since it store our converted hexadecimal
		# $t0 will be used as a masking bit
		li $t0, 1 # Load one into it
		sll $t0, $t0, 15 # Shift the 1 to the left 15 place to get it to the 16th position
		
		# Then we store sign bit into $t1
		and $t1, $t0, $s1
		
		# Now if the sign bit is negative, we have to do more work
		# But if the sign bit is positive, we don't have to do work
		beq $t1, $0, skip_flipping_option_one # If the sign bit is negative we branch away no need work
		
		# More work here, if the sign bit is positive
		# What we are going to do is prepend 16 ones to $s1 using logical operator OR
		li $t2, 0xFFFF0000
		or $s1, $t2, $s1
		
		# Then we add one to turn it into two's complement
		addi $s1, $s1, 1
		
		# Then we just print it
		
		skip_flipping_option_one:
		# Then the next line will be printing so no need to jump
	
print_s1_as_binary:
	# More work here is needed to be done
	# Load the third argument's starting address into register $t1
	# Keep in mind that we can't use $s1 because it stores our answer to print
	lw $t1, addr_arg2

	lbu $t2, 0($t1) # Load the first digit into $t2
	lbu $t3, 1($t1) # Load the second digit into $t2
	
	addi $t2, $t2, -48 # Turn it into its decimal value
	addi $t3, $t3, -48 # Turn it into its decimal value
	
	# Load in immediate 10
	li $t4, 10
	
	# Then we store answer into $s1
	# Make sure to initialize it to 0
	li $s2, 0 # Reset it to 0 so we can store our answers in there
	
	mul $s2, $t2, $t4
	add $s2, $s2, $t3
	
	# Now $s2 have our number of digits which have to be between 16 and 32 inclusive
	# $t1 will have the 16 number
	li $t1, 16
	
	# $t2 will have the 32 number
	li $t2, 32
	
	bgt $t1, $s2, invalid_args # We branch away to invalid args if the input is less than 16
	bgt $s2, $t2, invalid_args # We branch away to invalid args if input is greater than 32
	
	# Otherwise we stay and print the number given subtract by one
	addi $s2, $s2, -1
	
	# $t1 will be the register that have 1 to the most sinificant bit to do the masking
	li $t1, 1 
	sllv $t1, $t1, $s2 # Put the number of bits that you want subtract 1, 16 bit put 15 in the immediate argument
	# Now mask and continue until the mask reaches 0 
	loop:
		# We only branch away if the mask is equal to 0 meaning that we are done
		beq $t1, $0, exit_bin_loop
		
		# And we AND here where $t3 will store the result
		and $t3, $t1, $s1
		
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
	
option_two:
	# The input of 2 is reached here
	# Load in $t5 as the argument comparer
	li $t5, 3
	
	# This option expects 2 more argument as well, so total need to be 3 argument in $a0 else invalid arg
	# We branch away if the total argument is not equal to 3, and remain here if it is
	bne $a0, $t5, invalid_args
	
	# So if we are here, the given four characters represent two's complement in hexadecimal
	# First step is to turn the 4 character into its hexadecimal value representation, not ascii
	# We will be storing converted result into $s1 (not the real answer)
	li $s1, 0 # Resetting register $t5
	
	# Load the second argument's starting address into register $t1
	lw $t1, addr_arg1
	
	li $t4, 48 # $t4 store 48 which is ascii for 1
	li $t5, 57 # $t5 stores 57 which is ascii for 9
	li $t6, 65 # $t6 stores 65 which is ascii for A
	li $t7, 70 # $t7 stores 70 which is ascii for F
	
	hexadecimal_loop_option_two: # This turns 4 char into hexadecimal of what it is suppose to represent
		# We will loop through the 4 characters one by one into register $t2
		lbu $t2, 0($t1)
		
		# Before we move on check if character is a terminating char, if it is equal to 0 then exit
		beq $t2, $0, finish_option_two_algorithm
		
		bgt $t4, $t2, invalid_args # If 48 is greater than the current ascii then it is definietly not 1-9, A-F
		bgt $t2, $t7, invalid_args # If the current ascii is greater than the 70 then it is not 1-9, A-F
		# Now we are bound between 48-70 inclusive
		ble $t2, $t5, is_number_two # It is a number if it is less than or equal 57
		bge $t2, $t6, is_letter_two # It is a letter if it is greater than or equal 65
		
		j invalid_args # The value is between 58-64 inclusive hence invalid
		
		is_letter_two:
		# If the ascii is letter we subtract 55
		addi $t2, $t2, -55
		j done_ascii_to_value_two
		
		is_number_two:
		# If the ascii is a number we subtract 48
		addi $t2, $t2, -48
	
		done_ascii_to_value_two:
		# If we are here that means we finish transforming the ascii char from ascii to decimal
		# We store that into $s1 and shift 4 bits to the left
		# Shift before add!
		sll $s1, $s1, 4 # Shift 4 bits to the left
		add $s1, $s1, $t2 # Adding it to the register
		# Increment address of the word to get the next character
		addi $t1, $t1, 1
	
		# Then we jump back up the loop
		j hexadecimal_loop_option_two
	
	finish_option_two_algorithm:
		# If we are here then that means we have completed the conversion from ascii into hexadecimal
		# Which represents a two's complement
		# Again we have to get the sign bit using masking
		li $t0, 1 # $t0 will be the masking register with 1 in it
		sll $t0, $t0, 15 # We shift it 15 bits to the left to get it to the 16th position
		
		# Then we AND it with our results to get the sign bit storing it into $t1
		and $t1,$t0,$s1
		
		# Now if the sign bit is negative, we have to do more work
		# But if the sign bit is positive, we don't have to do work
		beq $t1, $0, skip_flipping_option_two # If the sign bit is negative we branch away no need work
		
		# More work here, if the sign bit is positive
		# What we are going to do is prepend 16 ones to $s1 using logical operator OR
		li $t2, 0xFFFF0000
		or $s1, $t2, $s1
		
		# We don't have to add 1 to $s1 because it is already in two's complement
		
		# Then we just print it
		
		skip_flipping_option_two:
			# Just go print the $s1 as binary
			j print_s1_as_binary
	
option_s:
	# The input of capital S is reached here
	# Load in $t5 as the argument comparer
	li $t5, 3
	
	# This option expects 2 more argument so total have to be 3 in $a0 else invalid arg
	# We branch away if the total argument is not 3, and remain here if it is
	bne $a0, $t5, invalid_args
	
	# If we are here then that means we are given a 4 character representing a signed binary in hexadecimal
	# And the goal is to turn it into two's complement and storing it into register $s1
	li $s1, 0 # Resetting the register to 0
	
	# Load the second argument's starting address into register $t1
	lw $t1, addr_arg1
	
	li $t4, 48 # $t4 store 48 which is ascii for 1
	li $t5, 57 # $t5 stores 57 which is ascii for 9
	li $t6, 65 # $t6 stores 65 which is ascii for A
	li $t7, 70 # $t7 stores 70 which is ascii for F
	
	hexadecimal_loop_option_three: # This turns 4 char into hexadecimal of what it is suppose to represent
		# We will loop through the 4 characters one by one into register $t2
		lbu $t2, 0($t1)
		
		# Before we move on check if character is a terminating char, if it is equal to 0 then exit
		beq $t2, $0, finish_option_three_algorithm
		
		bgt $t4, $t2, invalid_args # If 48 is greater than the current ascii then it is definietly not 1-9, A-F
		bgt $t2, $t7, invalid_args # If the current ascii is greater than the 70 then it is not 1-9, A-F
		# Now we are bound between 48-70 inclusive
		ble $t2, $t5, is_number_three # It is a number if it is less than or equal 57
		bge $t2, $t6, is_letter_three # It is a letter if it is greater than or equal 65
		
		j invalid_args # The value is between 58-64 inclusive hence invalid
		
		is_letter_three:
		# If the ascii is letter we subtract 55
		addi $t2, $t2, -55
		j done_ascii_to_value_three
		
		is_number_three:
		# If the ascii is a number we subtract 48
		addi $t2, $t2, -48
	
		done_ascii_to_value_three:
		# If we are here that means we finish transforming the ascii char from ascii to decimal
		# We store that into $s1 and shift 4 bits to the left
		# Shift before add!
		sll $s1, $s1, 4 # Shift 4 bits to the left
		add $s1, $s1, $t2 # Adding it to the register
		# Increment address of the word to get the next character
		addi $t1, $t1, 1
	
		# Then we jump back up the loop
		j hexadecimal_loop_option_three
	
	finish_option_three_algorithm:
		# Now we have to get the sign bit inside $s1 to determine whether or not more work
		# is required
		# We will use $t0 to store our mask bit
		li $t0, 1 # Put 1 into the register
		
		# Then we shift left 15 bits to make it into the 16th position
		sll $t0, $t0, 15
		
		# We put the sign bit into $t1
		and $t1, $t0, $s1
		
		# Now here comes determining whether we have more work or not
		# If it is equal to 0 that means the number is positive no more is require just print it
		beq $t1, $0, skip_more_work_option
		
		# If we are here that means the sign bit is 1, meaning the number is negative hence
		# more work is required
		# First $t2 will store the mask bit to only keep the 15 digit from the right
		li $t2, 0x7FFF
		
		# Then we AND it with $s1 to take out the sign bit
		and $s1, $s1, $t2
		
		# Then we NOT $s1 to get one's complement
		not $s1, $s1
		
		# Then we add 1
		addi $s1, $s1, 1
		
		# Then the conversion is complete just print it
		
		skip_more_work_option:
			# If we are here we just have to print whatever is in $s1
			j print_s1_as_binary
	
option_f:
	# The input of capital F is reached here
	# Load in $t5 as the argument comparer
	li $t5, 2
	
	# This option expects 1 more argument so total number of argument needs to be 2 in $a0 else invalid arg
	# We branch away if the total argument is not 2, and remain here if it is
	bne $a0, $t5, invalid_args
	
	# If we are here that means we have to convert the given argument from decimal into binary which includes a fraction
	# We have to split up the work where we do whole number first
	# Then we work on fractions next
	# Alright let's start with the whole number, to convert the given integer into binary we have to turn
	# it from ascii into hexadecimal value first
	
	# Again $s1 will store the hexadecimal value of the integer part
	# Then $s2 will store the hexadecimal value of the decimal part
	li $s1, 0 # Initialize the register to 0
	li $s2, 0 # Initialize the register to 0
	
	# $t1 will be storing the address of where the character begins
	lw $t1, addr_arg1
	
	# Because we know the String is fixed 3 digit we can just grab those using 0,1,2 immediate
	grab_whole_number_loop:
		
	
	
	
	
	
option_r:
	# The input of capital R is reached here
	# Load in $t5 as the argument comparer 
	li $t5, 7
	
	# R option expects 6 more argument so total number of argument needs to be 7 in $a0 else invalid arg
	# Again be branch away if the total argument is not 7, and remain here if it is
	bne $a0, $t5, invalid_args
	
	li $v0, 1
	li $a0, 777
	syscall
	j exit
	
option_p:
	# The input of capital P is reached here
	# Load in $t5 as the argument comparer 
	li $t5, 2
	
	# Like F P expects 1 more argument so total number of argument is 2, if not invalid arg
	# Branch away if its not 2
	bne $a0, $t5, invalid_args
	
	li $v0, 1
	li $a0, 69
	syscall
	j exit
	
	
valid_arg:
	# For testing print purposes only
	li $v0, 4
	la $a0, it_happened
	syscall

invalid_operator:
	# This is called because of an invalid operator and prints the error message
	li $v0, 4
	la $a0, invalid_operation_error
	syscall
	
	# After we print it we want to jump to exit
	j exit

invalid_args:
	# This is called because of an invalid argument error and prints the error message
	li $v0, 4
	la $a0, invalid_args_error
	syscall
	
	# Don't have to jump since exit is right after it

exit:
    li $v0, 10
    syscall
