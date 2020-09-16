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
	
	# $t0 will be storing the address of where the character begins
	lw $t0, addr_arg1
	
	# Because we know the String is fixed 3 digit we can just grab those using 0,1,2 immediate
	# Here we have all the registers free except $t0, $s1, and $s2
	lbu $t1, 0($t0) # Grab the first digit of the whole number
	lbu $t2, 1($t0) # The second digit of the whole number
	lbu $t3, 2($t0) # The third digit of thew hole number
	
	# Nowe we have to subtract the ascii values to get the actual decimal values
	addi $t1, $t1, -48 # Get the decimal of the first digit
	addi $t2, $t2, -48 # Get the decimal of the second digit
	addi $t3, $t3, -48 # Get the decimal of the third digit
	
	# Store immediate 100 and 10 in $t6 and $t7 for use
	li $t6, 100
	li $t7, 10
	
	# Multiply $t1 by 100 and store it in $t1
	mul $t1, $t1, $t6
	
	# Multiply $t2 by 10 and store it in $t2
	mul $t2, $t2, $t7
	
	# Add $t1 and $t2 first and store it into $t1
	add $t1, $t1, $t2
	
	# Then we add $t1 with $t3 and store it in $t1
	add $t1, $t1, $t3
	
	# Now if we are here $t1 contains our decimal(hexadecimal in register) whole number and we must print the binary
	# value.
	# We have to figure out the number of bits we have to print for the integer part, which can be done
	# By counting the number of division that is require to make $t1 into 0 by dividing by 2
	# We don't want to lose our number so we use another register to do the division
	move $t2, $t1 # Copy $t1 into $t2
	
	li $t3, 0 # $t3 will be our counter for the number of division that is required
	li $t4, 2 # This register will store 2 which is the divisor
	
	division_counting_loop: # This loop will counting the number of times that is required to make $t2 into 0	
		# If $t3 is equal to 0 then we have done counting the number of division that is required
		beq $t2, $0, finished_counting
		
		# If we are here we first do the division
		div $t2, $t4
		
		# lo contains our quotient we don't care about reminder store it into $t2
		mflo $t2
		
		# Then increment our counter and j back to the loop at the top
		addi $t3, $t3, 1
		
		j division_counting_loop
		
	finished_counting:
	# If we are here then we finished counting the number of division in $t3
	# $t3 represent the number of bits we need for printing
	# $t1 represent the actual number we have to print, whole integer part
	
	# We have the special case when $t3 is 0 meaning the whole number part is equal to 0 hence we skip to just printing a 0
	beq $t3, $0, only_one_zero
	
	li $t4, 1 # $t4 will be used as a masking register for printing
	
	# The number of left shift we have to do is $t3 minus one
	addi $t3, $t3, -1
	
	# Then we do the shift using $t3's value
	sllv $t4, $t4, $t3
	
	# Now we will be using a loop to print the whole integer number as a binary number
	loop_for_f_binary: # This loop aim to print $t1 using $t4 as masking bit
		# If the masking bit is equal to 0 then we are done printing just exit
		beq $t4, $0, finished_binary_loop_f
		
		# We AND $t4(mask) with $t1 and store into $t2
		and $t2, $t1, $t4
		
		bne $t2, $0, print_one_bit
		beq $t2, $0, print_zero_bit
		
		continue_after_printing_binary:
		# After pritning we have to shift right the mask register
		srl $t4, $t4, 1
		
		# And jump back up the loop
		j loop_for_f_binary
		
	print_one_bit:
		# Prints 1 and jumps back to the loop
		li $v0, 1
		li $a0, 1
		syscall
		
		j continue_after_printing_binary
	
	print_zero_bit:
		# Prints 0 and jumps back to the loop
		li $v0, 1
		li $a0, 0
		syscall
		
		j continue_after_printing_binary
		
	only_one_zero:
		li $v0, 1
		li $a0, 0
		syscall
		
		# Don't have to jump after printing because it is next line anyway
	
	finished_binary_loop_f:
	# Now we have printed the whole number part let's move on to the fraction part
	# Before that let's print the period
	# Let's load the character back into $t0 register again
	lw $t0, addr_arg1
	
	# We have gather the characters from imemdaiate 3, 4, 5, 6, 7, 8 because is a period follow by 5 fractions
	# We will be storing them from $t1 to $6 respectively
	lbu $t1, 3($t0)
	lbu $t2, 4($t0)
	lbu $t3, 5($t0)
	lbu $t4, 6($t0)
	lbu $t5, 7($t0)
	lbu $t6, 8($t0)
	
	# Then again we have to subtract 48 to get the real decimal value, don't need to for $t1
	addi $t2, $t2, -48
	addi $t3, $t3, -48
	addi $t4, $t4, -48
	addi $t5, $t5, -48
	addi $t6, $t6, -48
	
	# Now we will find out which bit is turned on in the fraction part
	# Now because the fraction is always in 5 bits and is made up of 2^-1 to 2^-5
	# We can just use subtraction to figure out which bit is needed to print in a loop
	
	# First we print period in $t1
	li $v0, 11
	move $a0, $t1
	syscall
	
	# The next let's sum the digits up first
	li $t1, 10000 # We multiply 10,000 to $t2
	
	# The answer will be store in $t2 and $t1 is used as our storage for 10^n
	mul $t2, $t1, $t2  
	
	li $t1, 1000 # We multiply 1,000 to $t3 and add it to $t2
	
	# So $t3 times 1,000
	mul $t3, $t1, $t3
	
	# Add it back into $t2
	add $t2, $t2, $t3
	
	li $t1, 100 # We multiply 100 to $t4 and add it to $t2
	
	# So $t4 times 100
	mul $t4, $t1, $t4
	
	# Add it back into $t2
	add $t2, $t2, $t4
	
	li $t1, 10 # We multiply 10 to $t5 and add it to $t2
	
	# So $t4 times 10
	mul $t5, $t1, $t5
	
	# Add it back into $t2
	add $t2, $t2, $t5
	
	# Lastly we just add $t6 into $t2
	add $t2, $t2, $t6
	
	# $t2 will contain the fraction part read as a whole number
	# Next we will store 2^-1 to 2^-5 as whole number by multiplying by 100,000
	# They will be in $t3 - $t7 respectively
	li $t3, 50000
	li $t4, 25000
	li $t5, 12500
	li $t6, 6250
	li $t7, 3125
	
	# If our fraction whole number part is greater than 50,000 we branch to minus_t3
	# To print 1 and jump to continue_back_one
	bge $t2, $t3, minus_t3
	
	# If it is not greater than 50,000 then we know we don't use it and hence we print a 0 instead of a 1
	# Then we continue to check if it is greater than orequal to 25,000
	li $v0, 1
	li $a0, 0
	syscall
	
	# We jump back here after minus_t3
	continue_back_one:
	
	# If this is true that means our whole number part is greater than 25,000 hence we branch to minus_t4
	# To print 1 and jump to continue_back_two
	bge $t2, $t4, minus_t4
	
	# If we are here that means our fraction is not greater than 25,000 hence we print a 0
	li $v0, 1
	li $a0, 0
	syscall
	
	# We jump back here after minus_t4
	continue_back_two:
	
	# If this is true our whole number is greater than 12,500 hence we branch to minus_t5
	# To print 1 and jump to continue_back_three
	bge $t2, $t5, minus_t5
	
	# If we are here that means our fraction is not greater than 12,500 hence we print a 0
	li $v0, 1
	li $a0, 0
	syscall
	
	# We jump back here after minus_t5
	continue_back_three:
	
	# Then we check if whole number isgreater than 6,250 hence we branch to minus_t6
	bge $t2, $t6, minus_t6
	
	# If we are here that means our fraction is not greater than 6,250 hence we print a 0
	li $v0, 1
	li $a0, 0
	syscall
	
	# We jump back here after minus_t6
	continue_back_four:
	
	# LASTLY we check if we are greater than 3125 if it is we branch to minus_t7
	bge $t2, $t7, minus_t7
	
	# If we are here that means our fraction is not greater than 3,125 hence we print our last 0
	li $v0, 1
	li $a0, 0
	syscall
	
	# We jump back here after minus_t7
	continue_back_five:
	
	
	# FINALLY, all the printing is done we just have to print the \n character and exit
	li $v0, 11
	li $a0, '\n'
	syscall
	
	j exit
	
	
	minus_t3:
		# We subtract 50,000 from our fraction value, have to use sub because of 16-bit overflow
		sub $t2, $t2, $t3
		
		# And print 1 as our binary value
		li $v0, 1
		li $a0, 1
		syscall
		
		j continue_back_one
		
	minus_t4:
		# We subtract 25,000 from our fraction value
		addi $t2, $t2, -25000
		
		# And print 1 as our binary value
		li $v0, 1
		li $a0, 1
		syscall
		
		j continue_back_two
	
	minus_t5:
		# We subtract 12,500 from our fraction valule
		addi $t2, $t2, -12500
		
		# Then print 1 as our binary value
		li $v0, 1
		li $a0, 1
		syscall
		
		j continue_back_three
	
	minus_t6:
		# We subtract 6,250 from our fractionvalue
		addi $t2, $t2, -6250
		
		# Then print 1
		li $v0, 1
		li $a0, 1
		syscall
		
		j continue_back_four
	
	minus_t7:
		# Technically we don't even have to subtract if we are here that means
		# It is the last 1 we have to print because the fractional part always fit inside 5 bits
		# So just print 1 and jump back
		li $v0, 1
		li $a0, 1
		syscall
		
		j continue_back_five	
	
option_r:
	# The input of capital R is reached here
	# Load in $t5 as the argument comparer 
	li $t5, 7
	
	# R option expects 6 more argument so total number of argument needs to be 7 in $a0 else invalid arg
	# Again be branch away if the total argument is not 7, and remain here if it is
	bne $a0, $t5, invalid_args
	
	# If we are here that means we have 6 more arugment
	# The first one is always 00 representing an empty register
	# The second and to the fifth one will always be 2 digits and must be between 0-31 inclusive in decimal
	# The sixth argument will be also 2 digits and be between 0-63 inclsuive in decimal
	
	# The first thing to do is to convert the second to sixth argument into decimal values and store them into register
	# Let's let $t0 to $t6
	# $t0 will be the opcode argument which is always 00 so we just haveto store 0 into $t0
	li $t0, 0
	
	# We load 10 into $s1 for multiplication
	li $s1, 10
	
	# We load 32 into $s2 for comparsion
	li $s2, 32
	
	# We load 64 into $s3 for comparsion
	li $s3, 64
	
	# $t1 will be rs argument but first we have to read it from ascii into decimal
	# The rs argument is stored in the third argument (addr_arg2)
	# Let's put the address into $t1 first then we can obtain the characters
	# Let's store the two characters into $t2 and $t3 respectively and combine to store it into $t1 using
	# multiplication
	lw $t1, addr_arg2 # Getting the first digit character
	
	# Store the first and secondd digit in $t2, $t3 respectivel
	lbu $t2, 0($t1)
	lbu $t3, 1($t1)
	
	# Then we minius 48 to get the actual decimal value
	addi $t2, $t2, -48
	addi $t3, $t3, -48
	
	# Multiply $t2 by $t1 and add $t3 to it then store result into $t1
	mul $t1, $t2, $s1
	add $t1, $t1, $t3 # Then add $t3 into $t1 to get our decimal value of rs argument
	
	# Then we compare $t1 against $22 to make sure it is between 0-31
	bge $t1, $s2, invalid_args
	
	# If we are here that means $t1 is in valid range
	# rs conversion if complete we move onto the next one
	# rt is next which is in (addr_arg3)
	lw $t2, addr_arg3
	
	# Then we store the first and second digit in $t3 and $t4 respectively
	lbu $t3, 0($t2)
	lbu $t4, 1($t2)
	
	# Minius 48 to get the actual decimal value
	addi $t3, $t3, -48
	addi $t4, $t4, -48
	
	# Multiply $t3 by $s1 and add $t4 to it then store result into $t2
	mul $t2, $t3, $s1
	add $t2, $t2, $t4 # Then we add $t4 into $t2 to get our decimal value for rt
	
	# Then we check $t2 against $s2 to make sure rt is between 0-31
	bge $t2, $s2, invalid_args
	
	# If we are here then time to convert rd which is in (addr_arg4)
	lw $t3, addr_arg4
	
	# Store first and second digit first into $t4 and $t5
	lbu $t4, 0($t3)
	lbu $t5, 1($t3)
	
	# Minius 48 to get the actual decimal value
	addi $t4, $t4, -48
	addi $t5, $t5, -48
	
	# Multiply $t4 by $s1 and add $t5 then store into $t3
	mul $t3, $t4, $s1
	add $t3, $t3, $t5
	
	# Then we check $t3 against $s2 to make sure rd is between 0-31
	bge $t3, $s2, invalid_args
	
	# If we are here then rd is valid hence we are going to convert shamt in (addr_arg5)
	lw $t4, addr_arg5
	
	# Store first and second digit first into $t5 and $t6
	lbu $t5, 0($t4)
	lbu $t6, 1($t4)
	
	# Minius 48 to get the actual decimal value
	addi $t5, $t5, -48
	addi $t6, $t6, -48
	
	# Multiply $t5 by $s1 and add $t6 then store into $t4
	mul $t4, $t5, $s1
	add $t4, $t4, $t6
	
	# Then we check $t4 against $s2 to make sure shamt is between 0-31
	bge $t4, $s2, invalid_args
	
	# FINALLY the last argument to check is funct is in (addr_arg6)
	lw $t5, addr_arg6
	
	# Store first and second digit first into $t6 and $t7
	lbu $t6, 0($t5)
	lbu $t7, 1($t5)
	
	# Minius 48 to get the actual decimal valule
	addi $t6, $t6, -48
	addi $t7, $t7, -48
	
	# Multiply $t6 by $s1 and add $t7 then store it into $t5
	mul $t5, $t6, $s1
	add $t5, $t5, $t7
	
	# Then we check $t5 against $s3 to make sure funct is between 0-63
	bge $t5, $s3, invalid_args
	
	# Finally if we are here $t1 to $t5 represent rs, rt, rd, shamt, and funct let's check and $t0 to represent 00
	# We will be putting the result of putting together all opcode, rs, rt, rd, shamt, and funct bit into
	# register $s1. First let's add funct into register $s1
	# Reset $s1 register to 0 first
	li $s1, 0
	
	# Then add $t5 which is funct into $s1 first
	add $s1, $s1, $t5
	
	# Then $t4 register that stores shamt will be shifted left 6 bits and OR into $s1
	sll $t4, $t4, 6 # Shift to the left 6 bits
	
	# Then or with $s1 to concatenate the bit
	or $s1, $s1, $t4
	
	# Next in $t3 we have our rd value let's shift left for 11 bits and OR into $s1
	sll $t3, $t3, 11
	
	# OR it to the $s1
	or $s1, $s1, $t3
	
	# Next in $t2 we have our rt value let's shift to the left for 16 bits and OR into $s1
	sll $t2, $t2, 16
	
	# OR it to the $s1
	or $s1, $s1, $t2
	
	# Last in $t1 we have our rs value let's shift to the left for 21 bits and OR into $s1
	sll $t1, $t1, 21
	
	# THEN OR it to the $s1
	or $s1, $s1, $t1
	
	# Then what we should have in our $s1 is the R instruction we need to print it in hexadecimal
	# Using value 34 for syscall to print it
	li $v0, 34
	move $a0, $s1
	syscall
	
	# Then don't forget to print the new line character
	li $v0, 11
	li $a0, '\n'
	syscall
	
	j exit
	
option_p:
	# The input of capital P is reached here
	# Load in $t5 as the argument comparer 
	li $t5, 2
	
	# Like F P expects 1 more argument so total number of argument is 2, if not invalid arg
	# Branch away if its not 2
	bne $a0, $t5, invalid_args
	
	# If we are here that means we have one additional argument which presents the card hands that we have to
	# Parse and sort to figure out which Poker hand it is
	# Load the address of the input first into $t0
	lw $t0, addr_arg1
	
	# Now we have all 5 ascii characters in $t1 - $t5
	# Keep in mind the ascii value will be only in 2 hexadecimal digits, or 8 bits
	# The left 4 bit represent the suit and right 4 bit represent the rank of the card
	# Let's parse each ascii and store their rank in $t1 - $t5 register
	li $t7, 0xF
	
	# Now we have the value of the card let's go through each painful iteration and sort the register
	# As well of as the word together
	# $s7 will store the smallest's rank's address using la $s7, (that card in $t registers)
	# $s6 will hold the smallest card's value using $s6
	iteration_one:
		# Getting the card from memory
		lbu $t1, 0($t0) # First card
		lbu $t2, 1($t0) # Second card
		lbu $t3, 2($t0) # Third card
		lbu $t4, 3($t0) # Fourth card
		lbu $t5, 4($t0) # Fifth card
		
		# Getting the rank that is inside each ascii that reprsents the card
		and $s1, $t1, $t7 # ANDing $t1 and $t7 to get rank
		and $s2, $t2, $t7 # ANDing $t2 and $t7 to get rank
		and $s3, $t3, $t7 # ANDing $t3 and $t7 to get rank
		and $s4, $t4, $t7 # ANDing $t4 and $t7 to get rank
		and $s5, $t5, $t7 # ANDing $t5 and $t7 to get rank
		
		# We will assume that the address of the smallest rank is the first card
		# Until proven
		move $s7, $t0 # Getting the address in the main memory of the first card
		
		move $s6, $s1 # We assume card #1 is the smallest until proven
		
		loop_until_found_min_s1: # This will run until we have found the smallest first card
		# Here we will be doing the comparsion
		bgt $s6, $s2, min_2_iter1 # Our assumption is greater than another value, $s2 update address to second card
		bgt $s6, $s3, min_3_iter1 # Our assumption is greater than another value, $s3 update address to third card
		bgt $s6, $s4, min_4_iter1 # Our assumption is greater than another value, $s4 update address to fourth card
		bgt $s6, $s5, min_5_iter1 # Our assumption is greater than another value, $s5 update address to fifth card
		
		# If we reach here then $s6 finished finding the smallest and hence we do the swapping
		# Because we updated the $s7 with the address of that minimum card, and know
		# It has to swap with the first card we can do so
		# We only have to switch it in the main memory since we will load back up each card in
		# later iteration so there is no need to update the register
		lbu $s1, 0($s7) # We load the smallest card into a temp in $s1
		sb $t1, 0($s7) # Put the first card in the smallest card's place
		sb $s1, 0($t0) # Put the smallest card in the first place
		
		j iteration_two
		
		min_2_iter1: # Update $s7 to the second card and $s6 to the second card's rank
			move $s7, $t0
			addi $s7, $s7, 1
			move $s6, $s2
			
			j loop_until_found_min_s1
		min_3_iter1: # Update $s7 to the third card and $s6 to the third card's rank
			move $s7, $t0
			addi $s7, $s7, 2
			move $s6, $s3
			
			j loop_until_found_min_s1
		min_4_iter1: # Update $s7 to the fourth card and $s6 to the fourth card's rank
			move $s7, $t0
			addi $s7, $s7, 3
			move $s6, $s4
		
			j loop_until_found_min_s1
		min_5_iter1: # Update $s7 to the fifth card and $s6 to the fifth card's rank
			move $s7, $t0
			addi $s7, $s7, 4
			move $s6, $s5
		
			j loop_until_found_min_s1
	
	iteration_two: # Iteration 2 we assume second card is minimum until proven
		# Getting the card from memory
		lbu $t2, 1($t0) # Second card
		lbu $t3, 2($t0) # Third card
		lbu $t4, 3($t0) # Fourth card
		lbu $t5, 4($t0) # Fifth card
		
		and $s2, $t2, $t7 # ANDing $t2 and $t7 to get rank
		and $s3, $t3, $t7 # ANDing $t3 and $t7 to get rank
		and $s4, $t4, $t7 # ANDing $t4 and $t7 to get rank
		and $s5, $t5, $t7 # ANDing $t5 and $t7 to get rank
		
		# We will assume that the address of the smallest rank is the second card
		# Until proven
		move $s7, $t0 # Getting the address in the main memory of the second card
		addi $s7, $s7, 1 # We add one to get to the memory address of the second card
		
		move $s6, $s2 # We assume card #2 is the smallest until proven
		
		loop_until_found_min_s2: # This will run until we have found the smallest second card
		# Here we will be doing the comparsion
		bgt $s6, $s3, min_3_iter2 # Our assumption is greater than another value, $s3 update address to third card
		bgt $s6, $s4, min_4_iter2 # Our assumption is greater than another value, $s4 update address to fourth card
		bgt $s6, $s5, min_5_iter2 # Our assumption is greater than another value, $s5 update address to fifth card
		
		# Then if we are here $s7 contains the address of the second smallest card
		# We just have to swap the characters in the main memory between the second card
		# With the smallest second card
		lbu $s1, 0($s7) # We load the smallest card into a temp in $s1
		sb $t2, 0($s7) # Put the second card in the smallest card's place
		sb $s1, 1($t0) # Put the smallest card in the second place
		
		j iteration_three
		
		min_3_iter2: # Update $s7 to third card and $s6 to the third card's rank
			move $s7, $t0
			addi $s7, $s7, 2
			move $s6, $s3
			
			j loop_until_found_min_s2
		min_4_iter2: # Update $s7 to fourth card and $s6 to the fourth card's rank
			move $s7, $t0
			addi $s7, $s7, 3
			move $s6, $s4
			
			j loop_until_found_min_s2
		min_5_iter2: # Update $s7 to fifth card and $s6 to the fifth card's rank
			move $s7, $t0
			addi $s7, $s7, 4
			move $s6, $s5
			
			j loop_until_found_min_s2
		
		
	iteration_three: # Iteration three we assume the third card is the minimum until proven
		# Getting the card from memory
		lbu $t3, 2($t0) # Third card
		lbu $t4, 3($t0) # Fourth card
		lbu $t5, 4($t0) # Fifth card
	
		and $s3, $t3, $t7 # ANDing $t3 and $t7 to get rank
		and $s4, $t4, $t7 # ANDing $t4 and $t7 to get rank
		and $s5, $t5, $t7 # ANDing $t5 and $t7 to get rank
		
		# We will assume that the address of the smallest rank is the third card
		# Until proven
		move $s7, $t0 # Getting the address in the main memory of the third card
		addi $s7, $s7, 2 # We add two to get to the memory address of the third card
		
		move $s6, $s3 # We assume card #2 is the smallest until proven
		
		loop_until_found_min_s3: # This will run until we have found the smallest second card
		# Here we will be doing the comparsion
		bgt $s6, $s4, min_4_iter3 # Our assumption is greater than another value, $s4 update address to fourth card
		bgt $s6, $s5, min_5_iter3 # Our assumption is greater than another value, $s5 update address to fifth card
		
		# If we are here then $s7 have the smallest card's address and we will be doing the swap
		# We just have to swap the characters in the main memory between the third card
		# With the smallest third card
		lbu $s1, 0($s7) # We load the smallest card into a temp in $s1
		sb $t3, 0($s7) # Put the third card in the smallest card's place
		sb $s1, 2($t0) # Put the smallest card in the third place
		
		j iteration_four
		
		min_4_iter3: # Update $s7 to fourth card and $s6 to the fourth card's rank
			move $s7, $t0
			addi $s7, $s7, 3
			move $s6, $s4
			
			j loop_until_found_min_s3
			
		min_5_iter3: # Update $s7 to fifth card and $s6 to the fifth card's rank
			move $s7, $t0
			addi $s7, $s7, 4
			move $s6, $s5
			
			j loop_until_found_min_s3
		
	iteration_four: # Last iteration to sort the final two cards
		# Getting the card from memory
		lbu $t4, 3($t0) # Fourth card
		lbu $t5, 4($t0) # Fifth card
	
		and $s4, $t4, $t7 # ANDing $t4 and $t7 to get rank
		and $s5, $t5, $t7 # ANDing $t5 and $t7 to get rank
		
		# We will assume that the address of the smallest rank is the fourth card
		# Until proven
		move $s7, $t0 # Getting the address in the main memory of the fourth card
		addi $s7, $s7, 3 # We add three to get to the memory address of the fourth card
		
		move $s6, $s4 # We assume card #4 is the smallest until proven
	
		loop_until_found_min_s4: # This will run until we have found the smallest second card
		# Here we will be doing the comparsion
		bgt $s6, $s5, min_5_iter4 # Our assumption is greater than another value, $s5 update address to fifth card
		
		# If we are here then $s7 have the smallest card's address and we will be doing the swap
		# We just have to swap the characters in the main memory between the fourth card
		# With the smallest third card
		lbu $s1, 0($s7) # We load the smallest card into a temp in $s1
		sb $t4, 0($s7) # Put the fourth card in the smallest card's place
		sb $s1, 3($t0) # Put the smallest card in the fourth place
		
		j finished_sorting
		
		min_5_iter4: # Update $s7 to the fifth card and $s6 to the fifth's rank
			move $s7, $t0
			addi $s7, $s7, 4
			move $s6, $s5
			
			j loop_until_found_min_s4
			
	finished_sorting:
	# Finally finished sorting holy heck
	# Now at addr_arg1 we have a sorted 5 hand card let's begin checking for poker hands
	# Let's reload the addr into $t0 again and make sure we have the right thing
	lw $t0, addr_arg1
	
	# We will have different sections for checking poker hands
	# We will check for Bib bobtail first because it rank the highest
	# Then we will have different labels for all the other ranks just in case
	# If we skip any
	check_big_booby:
	
	check_full_house:
	
	check_five_and_dime:
	
	check_skeet:
	
	check_blaze:
	
	just_high_noon:
	
	
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
