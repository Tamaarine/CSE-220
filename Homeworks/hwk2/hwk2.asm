# Ricky Lu
# rilu
# 112829937

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################

############################## Do not .include any files! #############################

# This file is the file we are writing our function in not the main files
.text
strlen:
    # If we are here then that means from strlen_main called this function with the argument
    # passed in $a0, which represent the String we need to find the length for
    
    # Input: $a0 -> String to find length for
    # Output: $v0 -> The length of the String MUST!
    # DO NOT MODIFY ANY MAIN MEMORY, the stacks or the heaps it is not needed
    
    # So we are going to do a simple for loop with a counter at $t0
    li $t0, 0 # Counter for the length of the String
    
    # This will be the for loop that we are going to use to count our strings
    for_loop_to_count_letters:
    	# Getting each letter and storing into $t1
    	lbu $t1, 0($a0) # We will be storing each letter in $t1 and incrementing the address $a0
    	
    	# This means that the character we are at right now is a terminating character
    	# Hence we break out of the loop
    	beq $t1, $0, finished_counting_loop
    	
    	# But if we are here then that means it is a valid letter so we increment the counter
    	# And we increment the address and jump back top to the loop
    	addi $t0, $t0, 1 # Increment the counter by 1
    	addi $a0, $a0, 1 # Increment the address by 1 to get to the next letter
    	
    	# Jump back to the top
    	j for_loop_to_count_letters
    	
    finished_counting_loop:
    # If we are here then that means the terminating character is reached hence we just have to move
    # The letter counter into $v0 as return value and done!
    move $v0, $t0 # Move counter into return register $v0 as specified 
    
    # Return and complete with this method
    jr $ra

index_of:
    # If we here then we are going oto implement a function that returns the index of the first
    # Instance of a wanted character in a null-terminated String. We will start searching at
    # The given index and continue onward until we hit the end of the String or invalid index in the beginning
    
    # $a0 -> is the starting address of the String we are looking through
    # $a1 -> is the character we are looking for in the String, is guaranteeded to be printable
    # $a2 -> is the start_index, the index where we begin our search
    # Output -> returning in $v0 the index where the character is found starting from start_index
    
    # Let's first obtain the length of our String using the strlen method we wrote
    # in the previous part. We have to save our $ra or else index_of won't know where to return
    # Allocate 4 byte of memory in our stack first, by subtracting 4
    addi $sp, $sp, -4 # Giving us 4 byte address to store $ra
    
    sw $ra, 0($sp) # Save the return address of index_of on the stack
    
    # Because we have $a0 already then we can call strlen to get the length of the String
    # in $v0, but keep in mind that strlen modifies $a0 so we have to restore it by subtracting with length
    # after it comes back
     
    jal strlen # Call the strlen function that returns the length of the given String in $v0
    
    # Let's store the return value of the String length in $t0
    move $t0, $v0 # Store the length into $t0
    
    # Before we move on we have to subtract $a0's address by the length to back to the beginning
    # of the word again because we are looping through to check the index of a character, after getting length
    sub $a0, $a0, $t0
    
    # Now before we proceed to loop it through, we must check $a2 or the start index is valid
    # or else we just return -1
    blt $a2, $0, invalid_start # If $a2 < 0 then it is for sure invalid
    bge $a2, $t0, invalid_start # If $a2 >= length(string) then it is also for sure invalid
    
    # If we reach here than means the start_index is 100% valid to check the character with
    # Now we can begin our procedure
    # We first add the offset of start_index to $a0 to get where we need to start the search
    add $a0, $a0, $a2 # Add beginning address of the word with start_index to get effective index to start
    
    # We will be keeping track of the index we are at in $t1 so later it is easier to move to $v0
    li $t1, 0
    
    # We add it with start_index to get to where $a0 starts in terms of index
    add $t1, $t1, $a2
    
    for_loop_for_index_of:
    	# This for loop is where we will be comparing whether we find the character for not
    	lbu $t2, 0($a0) # Loading each character starting at the effective index to start
    	
    	beq $t2, $0, finished_for_loop_for_index_of # Means we reach the end of the String we get out
    	
    	# We check whether the character we are at right now is equal to $a1 the character
    	# we are looking for
    	beq $t2, $a1, finished_for_loop_for_index_of # If they are equal, $t1 have the index get out	
    	
    	# Now if we are here we increment the address $a0 by 1
    	# as well as the index counter
    	addi $t1, $t1, 1 # Increment the index counter
    	addi $a0, $a0, 1 # Increment the address to get next character
    	
    	# Jump back to the top
    	j for_loop_for_index_of 
    	
    finished_for_loop_for_index_of:
    # If we are here $t1 have the index where the character lies or it is equal to the length of the String
    # so we just have to double check $t1 is equal to the length of the String we put -1 into $v0
    # else we just move $t1 into $v0
    
    beq $t1, $t0, not_found # Means that the index counter is at length which mean we did not found the char
    
    # If we are able to reach here that means the char is found
    found:
    	# This is for the character is found in String
    	# move $t1 into $v0
    	move $v0, $t1
    
    	# Then we are finished with this method
    	j finished_index_of_method
    
    not_found:
    	# Well we don't even have to load -1 into it because the lines following this
    	# label will do it for us
    	
    invalid_start:
    # If we are here that means the start_index provided is not valid hence we return
    # -1 in $v0
    li $v0, -1
    
    # Then we just return back the value to the caller 	
    
    finished_index_of_method:
    # We have to restore $ra here before we jump back else index_of will stuck here forever
    lw $ra, 0($sp) # Loading back the return address of index_of from the stack
    
    # Don't forget to deallocate the memory after!
    addi $sp, $sp, 4 # Adding 4 to deallocate what we allocated
    
    # Jump back to the main with the index in $v0
    jr $ra

to_lowercase:
    # If we are here then we are implmenting a function that takes the given String and turn
    # all of the upper case letters into lower case and return the number of upper case
    # letter converted into lower case letters
    
    # $a0 -> stores the address of the String in which we are converting, null-terminated
    # Output -> $v0 the number of letters changed from upper to lower case 
    
    # The way we going to do this is first loop through each letter in the String 
    # If the letter is uppercase we increment the counter and then for that letter
    # we subtract 32 from the upper case letter to get to the lower case letter
    # Then we store the byte at the same place, because each letter represent a byte
    
    # We will be keeping the number of upper case letter converted in $t0
    li $t0, 0 # With 0 as the initial value
    
    # We have to upload the ascii range for A-Z since they are the ones we are concerned with
    li $t2, 65 # $t2 Represent A in ascii value
    li $t3, 90 # $t3 Represent Z in ascii value
    
    for_loop_for_to_lowercase:
    	# In this for loop we are going to load in each letter first in register $t1
    	lbu $t1, 0($a0) # Load in each letter
    	
    	# When we hit the null-terminator we have to exit the loop
    	beq $t1, $0, finished_to_lowercase_loop
    	
    	# If the letter we are at is less than 65 then it is definitely not upper case letter
    	# So we skip to next letter
    	blt $t1, $t2, skip_next_letter_to_convert
    	
    	# If the letter we are at is greater than 90 then it is also definitely not upper case letter
    	# So we skip to next letter
    	bgt $t1, $t3, skip_next_letter_to_convert
    	
    	# Now if we are here then it is for sure that the letter is a upper case letter
    	# Let's increment the counter right away
    	addi $t0, $t0, 1 # Adds 1 to the counter to signal that we found a upper case letter
    	
    	# Now because the lower case letter is stored in $t1 we can add 32 to it to get the lower cased letter
    	addi $t1, $t1, 32 # Adding 32 to get the lower cased letter
    	
    	# Now we have to put this byte to where it belongs through sw as replacement
    	sb $t1, 0($a0) # We can just put $t1 at 0($a0) because $a0 is the one moving
    
    	# This label is for non-upper case letters to be skipped
    	skip_next_letter_to_convert:
    	# All we do here is to increment the $a0 address nothing else
    	addi $a0, $a0, 1
    	
    	# Then we jump back up again
    	j for_loop_for_to_lowercase
    
    finished_to_lowercase_loop:
    # If we are here then that means the for loop is finished and we have finished converting every
    # Upper case letter to lower case and $t0 have the number of upper case letter converted
    # All we have to do is to store $t0 into $v0 because that is where we return out value
    move $v0, $t0
    
    # Then jump back to main and done
    jr $ra

generate_ciphertext_alphabet:
    move $s7, $a0
    # If we are here then our text is to generate a set of ciphertext_alphabet using the
    # given keyphase. We append any unused letter in the keyphase, lower case letter first, then
    # we append upper case, then lastly the digits
    
    # $a0 -> is where we are storing the ciphertext_alphabets, it is 63 byte so we have 62 symbols to
    # be used. The last byte must be \0 null terminator
    # $a1 -> is the keyphase we are extracting the symbols from. It is guaranteeded
    # to be non-empty, null-terminating. Keep in mind we don't care about puncutation
    # so we only take in lowercase letter, uppercase letter, and digits
    # Output -> $v0 will be storing the number of unique, case-sensitive, numerical characters
    # we extracted from keyphase. Basically how many characters we have used in keyphase
    
    # Let's allocate 62 byte of array in the run time stack for us to store the
    # boolean of each array, we put a 1 if it exist in the keyphase, 0 if it doesn't exist
    # So initially everything is 0 then we will just have to loop through the keyphase to pick out
    # Which one exist and which one doesn't
    
    # Let's first allocate 64 byte of array, we want the pointer to be word aligned
    # We will have 2 extra byte, we have to deal with it
    addi $sp, $sp, -64
    
    # Now because we can't assume the memory is 0 in the beginning we have to make them all 0
    # It is from 0 to 61 immediates to add to $sp to get the effective address
    # So that means our for loop must travel 61 times
    li $t0, 62 # Let's store our < 62 in $t0
    li $t1, 0 # This is our for loop counter
    
    # We make a copy of $sp to be the one incrementing in $t2
    move $t2, $sp
    
    # 335 instructions not that bad
    # This loop will set everything on the 62 byte that we allocate to 0
    for_loop_to_clean_run_time_stack:
    	# If the counter reached 62 then we have already runned it 61 times that's it
    	# We are done
    	beq $t0 $t1, finished_clean_stack_loop
    	
    	# Then we store 0 at each index of the run time stack using $t2
    	# since that is the one we are using to increment
    	sb $0, 0($t2)
    	
    	# Then don't forget to increment the $t2 and our loop counter
    	addi $t2, $t2, 1 # Our $sp address pointer
    	addi $t1, $t1, 1 # Our loop counter
    	
    	# Jump back up
    	j for_loop_to_clean_run_time_stack
    	
    finished_clean_stack_loop:
    # Outside of the loop the 62 byte of stack memory we allocate should all be 0
    
    # We have to keep track of how many letters we have extracted from the keyphase
    # Let's store it in $s0
    li $s0, 0 # Counter for the letter collected from keyphase
    
    # We know that $a0 must be null terminated at the [62] byte let's just do it now to get it out of the way
    sb $0, 62($a0) # Store a null terminator at the last byte of the 63 byte
    
    # Now we can loop through the keyphase and do our thing
    # We will be using a for loop to go through the entire keyphase to extract
    # all the valid characters to be added to the real alphabet
    for_loop_to_generate_alphabet:
    	# We will load each character from the keyphase into register $t0
    	lbu $t0, 0($a1)
    	
    	# This will be the stopping condition, once the loop hit null terminator it will stop
	beq $t0, $0, finished_generating_alphabet
    
    	# Now we MUST make sure it is a uppercase, lowercase, or digit symbol before we add it into alphabet
	# Code below will determine whether or not this character we got is upper,lower, or digit
	
	# We load all the ascii value to compare into register $t7
	# Load 48 onto $t7
	li $t7, 48
	blt $t0, $t7, invalid_characters # The char is less than 48 can't be good

	# Load 122 onto $t7
	li $t7, 122
	bgt $t0, $t7, invalid_characters # The char is greater than 122 can't be good

	# For sure between 48 and 122 inclusive
	# Load 57 onto $t7
	li $t7, 57
	ble $t0, $t7, character_is_a_digit # We know 100% that the given character is a number ascii

	# Here then is between 58 and 122 inclusive
	# Load 65 onto $t7
	li $t7, 65
	blt $t0, $t7, invalid_characters # Between 58 to 64 inclusive can't be good

	# Here we know for sure is from 65 and 122 inclsuive
	# Load 90 onto $t7
	li $t7, 90
	ble $t0, $t7, character_is_a_uppercase # Between 65 and 90 inclusive for sure it is a upper case letter

	# If here we know is between 91 and 122 inclusive
	# Load 97 onto $t7
	li $t7, 97
	blt $t0, $t7, invalid_characters # Between 91 to 96 inclusive can't be good

	# Here it means is definitely a lower case letter
	j character_is_a_lowercase # Just go to good
	
	# The reason why we separate them into different cases is because so we know
	# Where to put the boolean value in array we have allocated
	# This branch is for if the character is a digit
	character_is_a_digit:
		# Any digit have ascii from 48 to 57 inclusive
		# We will map it into 0 to 9 inclusive region of our array
		# The way we going to do this is to subtract the ascii value by 48 to get our 
		# offset for the effective address
		# Load 48 into our register $t1 for subtraction
		li $t1, 48 
		
		# We can store the effective offset in $t2 because it is free
		sub $t2, $t0, $t1
		
		# Add it with $sp to get our effective address
		add $t2, $t2, $sp
		
		# Now $t2 the effective address for this character, we need to get the byte from the stack
		# To see whether or not we append this character or we don't
		lbu $t3, 0($t2) # Getting the boolean value for this character from the array
		
		# After getting the boolean value from the array in stack, $t3, we check whether or not
		# this character is in the array already. We append if it is equal to 0, don't if it is 1
		bne $t3, $0, skip_append_digit_character # We branch if the boolean value is true, already appended
	
		# If we are here then 	
		# We know that the digit is not in the array yet so we append it to the alphabet using $a0
		sb $t0, 0($a0)
		
		# After adding we need to increment the counter
		addi $s0, $s0, 1
		
		# We need to increment keyphase address
		addi $a1, $a1, 1
		
		# We need to increment alphabet address to point to the next position
		addi $a0, $a0, 1
		
		# We also have to put 1 into our array to signal that it is true
		addi $t3, $t3, 1 # Add 1 to the 0 then store it back using $t2 which is our effective address
		sb $t3, 0($t2) # Storing 1 into the array
		
		# Then we jump to the next iteration
		j for_loop_to_generate_alphabet
		
		skip_append_digit_character:
			# If we are here then that means the character is already added
			# We just need to increment keyphase address nothing else
			addi $a1, $a1, 1
			
			# Then jump to next iteration
			j for_loop_to_generate_alphabet

	character_is_a_uppercase:
		# Any upper case letter will have ascii value from 65 to 90 inclusive
		# We will be mapping it to the 10 to 35 inclusive region of our array
		# The way we are just going to be doing this is to subtract the ascii value
		# by 55 to get our offset for the effective address
		# Let's load 55 into $t1
		li $t1, 55
		
		# Then we can store our offset into $t2
		sub $t2, $t0, $t1
		
		# Then we add it with $sp to get our effective address
		add $t2, $t2, $sp
		
		# Now after we get our effective address we need to get the actual boolean value
		# To see whether or not this character is already in the alphabet
		# We will store it in $t3
		lbu $t3, 0($t2)
		
		# Now we check, if the boolean is not a 0 then we skip adding it because it is already
		# in the alphabet
		bne $t3, $0, skip_append_uppercase_character
		
		# But if it is 0 then we have to append it to the alphabet using $a0
		sb $t0, 0($a0)
		
		# After adding it to the alphabet we have to increment the counter
		addi $s0, $s0, 1
		
		# We need to increment keyphase address
		addi $a1, $a1, 1
		
		# We need to increment alphabet address
		addi $a0, $a0, 1
		
		# We also have to put 1 into our array to signal that it is true
		addi $t3, $t3, 1 # Add 1 to the 0 then store it back using $t2 which is our effective address
		sb $t3, 0($t2) # Storing 1 into the array
		
		# Then we jump to the next iteration
		j for_loop_to_generate_alphabet
		
		skip_append_uppercase_character:
			# If we are here then that means the character is already added
			# We just need to increment keyphase address nothing else
			addi $a1, $a1, 1
			
			# Then jump to next iteration
			j for_loop_to_generate_alphabet
		
	character_is_a_lowercase: 
		# Any lower case letter will have ascii value from 97 to 122 inclusive
		# We will be mapping it to the 36 to 61 inclusive region of our array
		# Same thing with upper case we are just going to be subtracting 61 from our sscii value
		# to get our offset for the effective address
		# Let's load 61 into $t1
		li $t1, 61
		
		# Then we can just store our offset into $t2
		sub $t2, $t0, $t1
		
		# Next is our effective address
		add $t2, $t2, $sp
		
		# Same thing after we get our effective address we need the boolean value
		# Store it in $t3
		lbu $t3, 0($t2)
		
		# Now we check, if the boolean is not a 0 then we skip adding it because it is already
		# in the alphabet
		bne $t3, $0, skip_append_lowercase_character
		
		# But if it is 0 then we have to append it to the alphabet using $a0
		sb $t0, 0($a0)
		
		# After adding it to the alphabet we have to increment the counter
		addi $s0, $s0, 1
		
		# We need to increment keyphase address
		addi $a1, $a1, 1
		
		# We need to increment alphabet address
		addi $a0, $a0, 1
		
		# We also have to put 1 into our array to signal that it is true
		addi $t3, $t3, 1 # Add 1 to the 0 then store it back using $t2 which is our effective address
		sb $t3, 0($t2) # Storing 1 into the array
		
		# Then we jump to the next iteration
		j for_loop_to_generate_alphabet
		
		skip_append_lowercase_character:
			# If we are here then that means the character is already added
			# We just need to increment keyphase address nothing else
			addi $a1, $a1, 1
			
			# Then jump to next iteration
			j for_loop_to_generate_alphabet
	
	invalid_characters:
		# If we are here then that means the character is not a uppercase,lowercase, or a digit
		# We just have to increment keyphase address and jump to next iteration
		addi $a1, $a1, 1
			
		# Then jump to next iteration
		j for_loop_to_generate_alphabet
    
    finished_generating_alphabet:
    # If we are here then that means the for loop have finished extracting all the valid characters
    # from the keyphase, we just have to append the left overs
    # Registers to keep in mind
    # $s0 -> Is number of letters we extracted from keyphase our output
    # $a0 -> Currently stores the next position to place the alphabets
    
    # We really just need 3 more for loop to append the leftover characters
    # We need to start with lowercase letters first
    # Let's load in the ascii a into $t0 register
    # and z into ascii $t1
    li $t0, 'a'
    li $t1, 'z'
    
    # Then this is our for loop to take in all the left over lowercase letters
    for_loop_leftover_lowercase:
    	# First let's set the condition for continuation and end of the loop
    	bgt $t0, $t1, out_lowercase # If we finished picking lowercase go to uppercase
    	
    	# Now again we have to get the offset for the effective address before we know
    	# Whether or not we have used this letter yet
    	# To get the offset remember we subtract 61
    	# Let's load 61 into $t2
    	li $t2, 61
    	
    	# Then we subtract with $t0 to get our offset and put it into $t3
    	sub $t3, $t0, $t2
    	
    	# Then to get our effective address we add it into $t3 $sp
    	add $t3, $t3, $sp
    	
    	# Then we can load in the boolean value from effective address into $t4
    	lbu $t4, 0($t3)
    	
    	# We branch away if the letter's boolean value is not 0 because we already have it in our alphabet
    	bne $t4, $0, skip_leftover_lowercase
    	
    	# But if we are here then we have to append it into our alphabet using $a0 and $t0
    	sb $t0, 0($a0)
    	
    	# After appending we have to only increment $a0 and $t0
    	addi $a0, $a0, 1 # For next position
    	addi $t0, $t0, 1 # For next letter
    	
    	# Storing the boolean value back is not needed
    	# Then we jump to next iteration
    	j for_loop_leftover_lowercase
    	
    	skip_leftover_lowercase:
    	# If we skip then we just have to increment for next letter and jump back
    	addi $t0, $t0, 1
    
    	j for_loop_leftover_lowercase
    
    # Outside of the previous's for loop
    out_lowercase:
    # We have to load in A into $t0
    # and Z into $t1
    li $t0, 'A'
    li $t1, 'Z'
    
    # Next is the loop for adding in the leftover uppercase letters
    for_loop_leftover_uppercase:
    	# First let's set the condition for continuation and end of the loop
    	bgt $t0, $t1, out_uppercase # If we finished picking upper go to digit
    	
    	# Now again we have to get the offset for the effective address before we know
    	# Whether or not we have used this letter yet
    	# To get the offset remember we subtract 55
    	# Let's load 55 into $t2
    	li $t2, 55
    	
    	# Then we subtract with $t0 to get our offset and put it into $t3
    	sub $t3, $t0, $t2
    	
    	# Then to get our effective address we add it into $t3 $sp
    	add $t3, $t3, $sp
    	
    	# Then we can load in the boolean value from effective address into $t4
    	lbu $t4, 0($t3)
    	
    	# We branch away if the letter's boolean value is not 0 because we already have it in our alphabet
    	bne $t4, $0, skip_leftover_uppercase
    	
    	# But if we are here then we have to append it into our alphabet using $a0 and $t0
    	sb $t0, 0($a0)
    	
    	# After appending we have to only increment $a0 and $t0
    	addi $a0, $a0, 1 # For next position
    	addi $t0, $t0, 1 # For next letter
    	
    	# Storing the boolean value back is not needed
    	# Then we jump to next iteration
    	j for_loop_leftover_uppercase
    	
    	skip_leftover_uppercase:
    	# If we skip then we just have to increment for next letter and jump back
    	addi $t0, $t0, 1
    
    	j for_loop_leftover_uppercase
    	
    # Outside of the previous for loop
    out_uppercase:
    # We have to put 0 in $t0
    # and 9 in $t1
    li $t0, '0'
    li $t1, '9'
    
    # Lastly, the leftover we have to add in is digits
    for_loop_leftover_digit:
    # First let's set the condition for continuation and end of the loop
    	bgt $t0, $t1, complete_algorithm # If we finished picking upper go to digit
    	
    	# Now again we have to get the offset for the effective address before we know
    	# Whether or not we have used this letter yet
    	# To get the offset remember we subtract 48
    	# Let's load 48 into $t2
    	li $t2, 48
    	
    	# Then we subtract with $t0 to get our offset and put it into $t3
    	sub $t3, $t0, $t2
    	
    	# Then to get our effective address we add it into $t3 $sp
    	add $t3, $t3, $sp
    	
    	# Then we can load in the boolean value from effective address into $t4
    	lbu $t4, 0($t3)
    	
    	# We branch away if the letter's boolean value is not 0 because we already have it in our alphabet
    	bne $t4, $0, skip_leftover_digit
    	
    	# But if we are here then we have to append it into our alphabet using $a0 and $t0
    	sb $t0, 0($a0)
    	
    	# After appending we have to only increment $a0 and $t0
    	addi $a0, $a0, 1 # For next position
    	addi $t0, $t0, 1 # For next letter
    	
    	# Storing the boolean value back is not needed
    	# Then we jump to next iteration
    	j for_loop_leftover_digit
    	
    	skip_leftover_digit:
    	# If we skip then we just have to increment for next digit and jump back
    	addi $t0, $t0, 1
    
    	j for_loop_leftover_digit
    
    complete_algorithm:
    # Finally if we here then everything is added in we just have to move $s0 into $v0 and return
    move $v0, $s0
    
    # Don't forget to deallocate the 64 byte that we have used
    addi $sp, $sp, 64
    
    # Holy hell that is such a big improvement in efficency after i used an array
    # damn that is impressive from my 100,000 instruction run from the first time i wrote this
    # Let's test its efficiency
    move $a0, $s7
    li $v0, 4
    syscall
    
    jr $ra

count_lowercase_letters:
    jr $ra

sort_alphabet_by_count:
    jr $ra

generate_plaintext_alphabet:
    jr $ra

encrypt_letter:
    jr $ra

encrypt:
    jr $ra

decrypt:
    jr $ra

############################## Do not .include any files! #############################

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
