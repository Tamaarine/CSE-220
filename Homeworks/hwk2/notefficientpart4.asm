    # $s0 will be storing the growing length of the letters we have extracted from keyphase
    # So when we use indexOf, we will be comparing the result using $s0, if it is -1 or anything bigger than
    # $s0, we know it is not part of the actual alphabet in making so we append the letter to it
    li $s0, 0

    # We know that $a0 must be null terminated at the [62] byte, we need to do it now or else
    # indexOf won't know where to stop
    sb $0, 62($a0) # Store a null terminator at the last byte of the 63 byte
            
    # We have to use a copy of $a0 to do the incrementation for storing the bytes in the alphabet
    # Because when we call indexOf it needs the starting address of the String, not somewhere in between
    # We will store the one where we increment to advance to the next character to replace in $s2
    move $s2, $a0
    
    # Another copy to restore it after
    move $s7, $a0
    
    # We will be using a for loop to go through the entire keyphase before 
    # Using 3 more for loop to add any remaining unused lower, upper, digit symbols
    for_loop_to_generate_alphabet:
	# $s1 will be storing each letter from the keyphase
	lbu $s1, 0($a1) # Loading each character from $a1
	
	# This will be the stopping condition, once the loop hit null terminator it will stop
	beq $s1, $0, finished_generating_alphabet
	
	# Now we MUST make sure it is a uppercase, lowercase, or digit symbol before using indexOf function
	# Things below will determine whether or not this character we got is a valid character we can use indexOf
	# Load everything onto register $t7
	# Load 48 onto $t7
	li $t7, 48
	blt $s1, $t7, invalid_characters # The char is less than 48 can't be good

	# Load 122 onto $t7
	li $t7, 122
	bgt $s1, $t7, invalid_characters # The char is greater than 122 can't be good

	# For sure between 48 and 122 inclusive
	# Load 57 onto $t7
	li $t7, 57
	ble $s1, $t7, upper_lower_or_digit # We know 100% that the given character is a number ascii

	# Here then is between 58 and 122 inclusive
	# Load 65 onto $t7
	li $t7, 65
	blt $s1, $t7, invalid_characters # Between 58 to 64 inclusive can't be good

	# Here we know for sure is from 65 and 122 inclsuive
	# Load 90 onto $t7
	li $t7, 90
	ble $s1, $t7, upper_lower_or_digit # Between 65 and 90 inclusive for sure it is a upper case letter

	# If here we know is between 91 and 122 inclusive
	# Load 97 onto $t7
	li $t7, 97
	blt $s1, $t7, invalid_characters # Between 91 to 96 inclusive can't be good

	# Here it means is definitely a lower case letter
	j upper_lower_or_digit # Just go to good

	invalid_characters:
		# This means that we have encountered a puncutation in the keyphase
		# which we don't care about so we just skip to the next character
		addi $a1, $a1, 1 # Incrementing the address to get the next character
		
		# Jump back up the loop
		j for_loop_to_generate_alphabet

	upper_lower_or_digit:
		# This means that we have encountered a upper, lower, or digit character
		# Now we must use indexOf to see if it is already inside the keyphase
		# Before appending it
		
		# Before calling it we have to store $ra of generate_ciphertext_alphabet else
		# it won't know where to return to
		addi $sp, $sp, -4 # Allocate 4 bytes for the return address
		
		sw $ra, 0($sp) # Store this method's return address onto the stack
		
		# Yikes we also have to store $a1's address or else it will be overwritten by index_of because
		# we are giving it the letter we want to look at
		# We can store $a1 which is the current keyphase's address in $s3 and restore it later
		move $s3, $a1 # Storing $a1 in register $s3, make sure to restore it later
		
		# Now we can safely call jal index_of without worrying anything
		# $s7 -> $a0 because that is the inital copy of the starting address of alphabet
		move $a0, $s7
		
		# $a1 we have to give it the character we want it to look for which is in $s1
		# $s1 -> $a1
		move $a1, $s1
		
		# $a2 is the position we want to start looking at, just give 0
		li $a2, 0
		
		# Now we can call jal index_of
		jal index_of
		
		# Right after we call index_of let's restore $a1 from $s1
		# So we can have our keyphase's position back
		move $a1, $s3
		
		# Once we are out of here we know $v0 have our index position
		# If it is -1 we append, 100% we load -1 in $t0
		li $t0, -1
		beq $v0, $t0, append_letter_into_alphabet
		
		# If the return index that is found is GREATER THAN OR EQUAL TO the real alphabet length counter
		# We know it is definitely not part of the alphabet hence we have to append to alphabet
		bge $v0, $s0, append_letter_into_alphabet 
		
		# If we are here then that means the letter is already present in the alphabet
		# We don't have to add it hence we just increment keyphase address
		addi $a1, $a1, 1
		
		# Then we jump to finish_handling_upper_lower_digit
		j finish_handling_having_upper_lower_digit
		
		append_letter_into_alphabet:
		# But if we are here that means we have to add it to the alphabet because
		# We don't have it in the cyphertext_alphabet
		sb $s1, 0($s2) # We store the unadded alphabet into the real alphabet using $s2
		
		# Then we increment the keyphase address and real alphabet address to get to the
		# next position for replacement
		addi $s2, $s2, 1
		addi $a1, $a1, 1
		
		# Also increment alphabet counter
		addi $s0, $s0, 1
		
		finish_handling_having_upper_lower_digit:
		# Restore the $ra DON'T FORGET
		lw $ra, 0($sp)
		
		# Then deallocate the 4 byte we used
		addi $sp, $sp, 4
	
		# Then we jump back up the loop for next character
		j for_loop_to_generate_alphabet
	
    finished_generating_alphabet:   
    	# Outside of the for loop that means we finished extracting letter from keyphase
    	# Now we just have to add the leftover from all the rest
	
    	# The registers we have to keep in mind is
    	# $s0 -> The real alphabet length counter our $v0 output
    	# $s2 -> Holds the first position where to put upper, lower, digit character in alphabet
    	# $s7 -> Contains the initial starting address of the alphabet
    	# The rest we are all free to use
    	
    	# Load the beginning of a
    	li $s3, 'a'
    	
    	# Load the ending of Z
    	li $s4, '{'
    	
    	# We start with lower case letters
    	for_loop_to_add_lowercase:
    		# If we are here we have to call indexOf to check whether or not that
    		# letter is used in alphabet which $s3
    		move $a1, $s3 # Move the character we looking for into $a1
    		
    		# s7 -> a0
    		move $a0, $s7
    		
    		# 0 -> a2
    		li $a2, 0

    		# If we hit the { character we finished adding all the lower case characters
    		beq $s3, $s4, finished_loop_to_add_lowercase
    		
    		# Before calling it we have to store $ra of generate_ciphertext_alphabet else
		# it won't know where to return to
		addi $sp, $sp, -4 # Allocate 4 bytes for the return address
		
		sw $ra, 0($sp) # Store this method's return address onto the stack
		
		# Calling the function
		jal index_of
		
		# After calling we know $v0 contains the index of each lower case character in 
		# the alphabet
		
		# If $v0 is equal to -1 we definitely append
		# Store -1 into $t1
		li $t1, -1
		beq $v0, $t1, append_letter_from_lowercase
		
		# If $v0 is greater than or equal to $s0 we append for sure
		bge $v0, $s0, append_letter_from_lowercase
		
		# We only have to increment to next letter but not $s2
		addi $s3, $s3, 1
		
		j finished_append_letter_from_lowercase
		
		append_letter_from_lowercase:
    		# We just store the byte at $s2 then finished
    		sb $s3, 0($s2)
    		
    		# We have to increment to the next letter also $s2
    		addi $s3, $s3, 1
    		addi $s2, $s2, 1
    		
    		finished_append_letter_from_lowercase:
    		# Restore the $ra DON'T FORGET
		lw $ra, 0($sp)
		
		# Then deallocate the 4 byte we used
		addi $sp, $sp, 4
    		
    		# Jump back up the loop
    		j for_loop_to_add_lowercase
    		
    	finished_loop_to_add_lowercase:
    	
    	# Load the beginning of A
    	li $s3, 'A'
    	
    	# Load the ending of Z
    	li $s4, '['
    	
    	# Then we proceed with uppercase letters
    	for_loop_to_add_uppercase:
    		# If we are here we have to call indexOf to check whether or not that
    		# letter is used in alphabet which $s3
    		move $a1, $s3 # Move the character we looking for into $a1
    		
    		# s7 -> a0
    		move $a0, $s7
    		
    		# 0 -> a2
    		li $a2, 0

    		# If we hit the [ character we finished adding all the lower case characters
    		beq $s3, $s4, finished_loop_to_add_uppercase
    		
    		# Before calling it we have to store $ra of generate_ciphertext_alphabet else
		# it won't know where to return to
		addi $sp, $sp, -4 # Allocate 4 bytes for the return address
		
		sw $ra, 0($sp) # Store this method's return address onto the stack
		
		# Calling the function
		jal index_of
		
		# After calling we know $v0 contains the index of each upper case character in 
		# the alphabet
		
		# If $v0 is equal to -1 we definitely append
		# Store -1 into $t1
		li $t1, -1
		beq $v0, $t1, append_letter_from_uppercase
		
		# If $v0 is greater than or equal to $s0 we append for sure
		bge $v0, $s0, append_letter_from_uppercase
		
		# We only have to increment to next letter but not $s2
		addi $s3, $s3, 1
		
		j finished_append_letter_from_uppercase
		
		append_letter_from_uppercase:
    		# We just store the byte at $s2 then finished
    		sb $s3, 0($s2)
    		
    		# We have to increment to the next letter also $s2
    		addi $s3, $s3, 1
    		addi $s2, $s2, 1
    		
    		finished_append_letter_from_uppercase:
    		# Restore the $ra DON'T FORGET
		lw $ra, 0($sp)
		
		# Then deallocate the 4 byte we used
		addi $sp, $sp, 4
    		
    		# Jump back up the loop
    		j for_loop_to_add_uppercase
    		
    	finished_loop_to_add_uppercase:
    	
    	# Load the beginning of 0
    	li $s3, '0'
    	
    	# Load the ending of 9
    	li $s4, ':'
    	
    	# Then we proceed with digits
    	for_loop_to_add_digit:
    		# If we are here we have to call indexOf to check whether or not that
    		# letter is used in alphabet which $s3
    		move $a1, $s3 # Move the character we looking for into $a1
    		
    		# s7 -> a0
    		move $a0, $s7
    		
    		# 0 -> a2
    		li $a2, 0

    		# If we hit the : character we finished adding all the digits
    		beq $s3, $s4, finished_loop_to_add_digit
    		
    		# Before calling it we have to store $ra of generate_ciphertext_alphabet else
		# it won't know where to return to
		addi $sp, $sp, -4 # Allocate 4 bytes for the return address
		
		sw $ra, 0($sp) # Store this method's return address onto the stack
		
		# Calling the function
		jal index_of
		
		# After calling we know $v0 contains the index of each digit in 
		# the alphabet
		
		# If $v0 is equal to -1 we definitely append
		# Store -1 into $t1
		li $t1, -1
		beq $v0, $t1, append_letter_from_digit
		
		# If $v0 is greater than or equal to $s0 we append for sure
		bge $v0, $s0, append_letter_from_digit
		
		# We only have to increment to next letter but not $s2
		addi $s3, $s3, 1
		
		j finished_append_letter_from_digit
		
		append_letter_from_digit:
    		# We just store the byte at $s2 then finished
    		sb $s3, 0($s2)
    		
    		# We have to increment to the next letter also $s2
    		addi $s3, $s3, 1
    		addi $s2, $s2, 1
    		
    		finished_append_letter_from_digit:
    		# Restore the $ra DON'T FORGET
		lw $ra, 0($sp)
		
		# Then deallocate the 4 byte we used
		addi $sp, $sp, 4
    		
    		# Jump back up the loop
    		j for_loop_to_add_digit
    		
    	finished_loop_to_add_digit:
    	# If we reached here then that means the ciphetext_alphabet is finally complete
    	# $s0 contains the number of uppercase letter we converted into lowercase letter
    	# Since we are returning in $v0 just move it to that register
    	move $v0, $s0
    	
    	# Let's just print what $a0 have DEBUG TESTING ONLY
    	# move $a0, $s7
    	# li $v0, 4
    	# syscall

    # Then we just have to return that's it