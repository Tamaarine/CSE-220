finish_option_one_algorithm:
	
	# Now we have completed the transformation process of making the 4 ascii letter into its corresponding binary
	# We need to get the significant bit to check pos or neg
	# Use masking bit
	li $t0, 1 # Store 1 into $t0 as the masking bit
	sll $t0, $t0, 15 # Shift 15 bit to the left to get the 1 into the 16th position which is the sign bit
	
	# Next we AND it with $s1 to check whether or not the one's complement is pos or neg
	# The result is stored in $t1
	and $t1,$t0,$s1
	
	# If $t1 is equal to 0, meaning it is positive we branch away and print the number without adding one
	beq $t1, $0, print_s1_as_binary
	
	# But if we didn't branch away we add one to get the two's complement using one's complement
	addi $s1, $s1, 1
	
	# Don't have to jump to print_s1_as_binary since it is underneath anyway