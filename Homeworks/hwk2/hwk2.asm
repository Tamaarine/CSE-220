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
    # If we here then we are going to implement a function that returns the index of the first
    # Instance of a wanted character in a null-terminated String. We will start searching at
    # The given index and continue onward until we hit the end of the String or invalid index in the beginning
    
    # Preamable
    # Now because we are going to call on the function strlen which takes in 
    # $a0 as argument we still need to save it because we don't know if 
    # $a0 will be modified or not so we have to save it into a $s register
    # Now since we are overwritting a $s register we have to follow convention and save it on the
    # runtime stack before we can use it
    # Then we also allocate 4 more byte to save $ra because we will be calling strlen function
    # Just do it here it will be much easier than later on scattered everywhere
    addi $sp, $sp, -8 # We allocate 8 byte of memeory to store $s0 and $ra
    
    # We put $s0 on the stack then we are able to use $s0 now
    sw $s0, 0($sp) 
    
    # Then we put $ra on the stack position 4, now we are able to call the function
    sw $ra, 4($sp) 
    
    # $a0 -> is the starting address of the String we are looking through
    # $a1 -> is the character we are looking for in the String, is guaranteeded to be printable
    # $a2 -> is the start_index, the index where we begin our search
    # Output -> returning in $v0 the index where the character is found starting from start_index
    
    # Now before we can call strlen we have to save $a0 onto $s0 because it might modifify it
    move $s0, $a0  
     
     # Then we can safely call strlen because we have saved $ra already
    jal strlen # Call the strlen function that returns the length of the given String in $v0
    
    # Let's store the return value of the String length in $t0
    move $t0, $v0 # Store the length into $t0
    
    # Before we move on we have to restore $a0 by moving from $s0 
    move $a0, $s0
    
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
    # Postamable
    # We have to register the $s register we have used from the runtime stack
    lw $s0, 0($sp)
    
    # We also have to restore $ra here before we jump back else index_of will stuck here forever
    lw $ra, 4($sp)
    
    # Don't forget to deallocate the memory after!
    addi $sp, $sp, 8 # Adding 8 to deallocate what we allocated
    
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
    	
    	# Now we have to put this byte to where it belongs through sb as replacement
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
    
    # Preamable for all the s registers that we have used!
    # Because we have used $s0 we must preserve that on the runtimestack and restore it later
    # Along with the stack array that we will allocate, together it will be total of 68 byte
    # The last 4 byte on position 64 - 67 will be used to store $s0
    # Everything from 0 - 63 inclusive will be used to store the runtime stack array
    # I know we will have 2 byte of extra memory for the array but we have to deal with it
    addi $sp, $sp, -68 # Allocating total of 68 byte of memory or 17 words
    
    # The last word will be used to store $s0 because we are using it
    sw $s0, 64($sp) # Storing the $s0 register at the last word at our allocated memory
    
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
    
    # Then don't forget to have to restore $s0 from the runtime stack array
    # at position 64 wordd 17
    lw $s0, 64($sp) # Restoring the $s0 register from our stack
    
    # Then we have to deallocate the entire 68 byte of memory we used
    addi $sp, $sp, 68
    
    # Holy hell that is such a big improvement in efficency after i used an array
    # damn that is impressive from my 100,000 instruction run from the first time i wrote this
    
    # Jump back to main
    jr $ra

count_lowercase_letters:
    # If we are here then that means we are taking a String of messages and then count
    # every lower case letter's occurences in the String, we store the occurences in an array
    # where each word represent a letter starting from a ends at z
    # Rememeber we are dealing with words not with byte!
    
    # $a0 -> is the array where we are storing the frequency of each lower case letter
    # we must clean it before we use it because it might be filled with all garbages and not 0s
    # $a1 -> this is our message String that we are going to loop through and extract each
    # letter to count the lowercase from
    # Output -> $v0, we are going to return the total count of lowercase letters in messages
    
    # Preamable for the $s registers we have used
    # Throughout this function we have used $s0 so we must preserve it on the
    # runtime stack before we can unlock it and use it
    # Let's allocate 4 byte of memory to store that $s0 on a word
    addi $sp, $sp, -4 # Allocating 4 byte for the $s0 register
    
    # Then we just have to simply store it on the stack
    sw $s0, 0($sp)
    
    # Now we can use the $s0 register because we have saved it on the stack
       
    # Since we have 26 letters we will go up the byte index until 104 stopping before hitting 104 at 100
    # indexing we will be using $t0 to keep track of the index we are at, and $t1 as
    # the byte length for stopping condition. 0 to 100 is 26 byte
    li $t0, 0 # Our for loop and index counter
    li $t1, 104 # Our stopping goal 
    
    # So before we do anything let's each word of our given array
    for_loop_to_clean_array:
    	# This is our stopping condition, if our byte index is less than
    	# 104 then we are still in a valid index
    	# But once it hit 104 we are done, if we clean 104th byte's word then we are doing 27
    	# words not 26 anymore
    	bge $t0, $t1, finished_cleaning_array # If our byte counter is greater than or equal to 104 we are done
    	
    	# If we are here then we have to clean the word by storing $0 into that word
    	# Let's get our effective address by adding $t0 with $a0 and store it in $t2
    	add $t2, $t0, $a0
    	
    	# Then we just have to store $0 into $t2 because that is the effective address already
    	sw $0, 0($t2)
    	
    	# Then we have to increment our byte index counter by 4
    	addi $t0, $t0, 4
    	
    	# And jump back up the loop
    	j for_loop_to_clean_array
    
    finished_cleaning_array:
    # If we are here then that means we have clean everything from 0 to 25 word
    # They are all 0 now and we can start working on the array
    
    # Let's load 97 into $t1
    # And 122 into $t2
    # This is for comparsion to make sure it is a lowercase letter
    li $t1, 97
    li $t2, 122
    
    # Now we also have to keep track of a counter for the total number of lowercase letter we counted
    # We will put it in register $s0
    li $s0, 0
    
    # We are going to loop through the entire messsages, load one byte at a time
    # Then add in the values to the respected array word if it is a lowercase letter
    for_loop_to_count_lowercase:
    	# Keep in mind these registers
    	# $a0 -> Is the starting address of our array accessed through offset of multiple of 4, for word!
    	# $a1 -> Is the starting address of the message
    	# We will store each character in register $t0
    	lbu $t0, 0($a1) # Loading each character in message
    	
    	# Our loop stopping condition is when we hit the null terminator in message
    	beq $t0, $0, finished_counting_lowercase_loop
    	
    	# Now before we do more work we have to make sure that it is a lowercase letter
    	# which have ascii value between 97 and 122 inclusive
    	blt $t0, $t1, skip_to_next_letter_to_count # The character have ascii value less than 97 definitely not lowercase
    	bgt $t0, $t2, skip_to_next_letter_to_count # The character have ascii value greater than 122 definitely not lowercase
    	
    	# Now if we are here then it is for sure that the character is lowercase
    	# We just have to increment it in our array of integers
    	# To do that we have to get our effective offsets of the index, which
    	# we can do by subtracting 97 from our lowercase letter 
    	# Let's store the index offset into register $t3
    	sub $t3, $t0, $t1
    	
    	# Now $t3 have the index where the word is suppose to go
    	# to get the word offset we multiply $t3 by 4
    	# We load 4 into $t4
    	li $t4, 4
    	
	# We multiply the index with 4 this gets our word offsets which we add
	# with $a0 to get our effective address
    	mul $t3, $t3, $t4
    	
    	# We add $t3 with $a0 to get our effective address to increment the lowercase letter
    	add $t3, $t3, $a0
    	
    	# Now we have to get the values from the array first, add it, then put it back in
    	# We will get the value from array and put it into $t4. We use $t3 as our effective address
    	lw $t4, 0($t3)
    	
    	# We increment the value in $t4
    	addi $t4, $t4, 1
    	
    	# Then we store the value back in the same effective address $t3
    	sw $t4, 0($t3)
    	
    	# Now we are done, we increment the lowercase's count in the array
    	# We can move onto the next character in message to work with
    	# We just have to increment $a1 and $s0 lowercase letter counter
    	addi $a1, $a1, 1
    	
    	addi $s0, $s0, 1
    	
    	# After incrementing we jump to the next iteration
    	j for_loop_to_count_lowercase
    	
    	skip_to_next_letter_to_count:
	# If we are here then that means we just have to increment the message address
	# to get our next character we don't increment the lowercase letter counter
	addi $a1, $a1, 1
	
	# Then we jump back up the loop
	j for_loop_to_count_lowercase
    
    finished_counting_lowercase_loop:
    # If we are here then we are essentially done with counting
    # All we have to do is move $s0 into $v0 and return that's it
    move $v0, $s0
    
    # Now before we return we have to restore the $s0 register we have used
    # from the runtime stack
    lw $s0, 0($sp)
    
    # Then we deallocate the 4 byte of memory we have used by adding 4
    addi $sp, $sp, 4
    
    # Then we return and done, heck I just did selection sort in MIPS that is freaking crazy
    jr $ra

sort_alphabet_by_count:
    # For this problem we are going to use a selection sort to sort the counts of the alphabets
    # We are going to use the run time stack to keep track of an array of letter that correspond to
    # with the count of the letter. This way we will know which count is for which and when we 
    # Swap in count we also swap in the run time stack. It will be just 26 byte because 
    # Each character can be contained in a byte there isn't a need to do an entire word which adds more trouble
    
    # $a0 -> have the starting address of where we are putting the sorted_alphabet, it is at least
    # 27 bytes in size and is uninitilized, we don't have to clean it because we are going to overwrite it
    # with the letters anyway after we sort, but we do have to put a null terminator at index 26
    # $a1 -> have the starting address of the counts array which is 26 words that contains the count
    # for each letter. This is the array we are looping over to sort our array
    # Output -> None, this is a void method so we don't have to return anything
    
    # Preamable
    # Now because in the function we are going to be using 
    # $s0, $s1, $s2, $s3 registers we have to save those 4 registers
    # onto the stack. 4 registers each of 4 byte which makes it 16 byte in total
    # Now we also will be allocating 26 byte of stack array in our runtime stack
    # To help us to do the sorting, We have to make it word aligned so
    # 26 needs to be round up to 28, 28 + 16 = 44 byte of memory which makes it
    # total of 11 words
    # Let's allocate that
    addi $sp, $sp, -44
    
    # Now keep in mind memory index 0 to 27 will be used by the stack array
    # I know we will have 2 extra byte of memory but we have to deal with it
    
    # Memory index 28 to 43 will be used to restore the 4 registers, let's do that right now
    sw $s0, 28($sp) # The first word stores $s0
    sw $s1, 32($sp) # Second word stores $s1
    sw $s2, 36($sp) # Third word stores $s2
    sw $s3, 40($sp) # Fourth word stores $s3
    
    # Now we have unlocked the 4 registers for us to use
    # Let's do some testing to make sure 2 byte of memory is not used
    li $t0, 'P'
    li $t1, 'E'
    
    sb $t0, 26($sp)
    sb $t1, 27($sp)
    
    # Then rest is for the runtime stack array
    
    # Now we put the first lowercase letter a in $t0
    # and the last lowercase letter z in $t1
    li $t0, 'a'
    li $t1, 'z'
    
    # The register $t2 will be holding byte index and will be the
    # one that is incremented along with $t0 to help us store the letter in the corresponding position
    # in the run time stack array. It will be the same value as $sp
    move $t2, $sp
    
    # Now we will go through iteration from a to z
    for_loop_for_placing_letters:
    	# We set our stopping condition when $t0 is greater than z
    	bgt $t0, $t1, finished_loop_placing_letters
    
    	# If we are here then we have to put $t0 in the $t2 position of the array
    	sb $t0, 0($t2)
    	
    	# Then we increment $t0 to get the next letter
    	addi $t0, $t0, 1
    	
    	# And increment the position counter
    	addi $t2, $t2, 1
    	
    	# Then jump back up the loop
    	j for_loop_for_placing_letters
    
    finished_loop_placing_letters:
    # If we are out here then we are done placing the letters a to z in the run time stack array
    
    # We should only keep track fo the index only , effective address can be calculated later
    # This is our outer loop and we will be keeping track of the outer loop counter in $t0 starting with 0
    # And the inner loop counter will be in register $t1, the end goal which is 26 will be in register $t2
    li $t0, 0
    li $t2, 26
    
    # This is our outer loop for selection sort, remember $t0 is the loop counter for the outer loop
    for_loop_selection_sort_outer:
    	# This is our stopping condition once $t0 hits 26 then everything in the array
    	# is sorted there is no need to continue on
    	bge $t0, $t2, finished_selection_sort
    	
    	# If we are here then that means we have to find the maximum element through
    	# the inner loop, we will be keeping track of the largest element index in $t3
    	# We assume $t0 is the largest element index in the beginning until proven
    	move $t3, $t0 # Assume i is the largest element index until proven
    	
	# $t1 is the counter for the inner loop and it will have the vallue of $t0 plus 1
	move $t1, $t0
	addi $t1, $t1, 1 # We add one for i + 1 as the inner loop counter
	
	# Then this is our inner loop, remember $t1 is the inner loop counter
	for_loop_selection_sort_inner:
	    # Here we have to compare every element from i + 1 and on against the element we have
	    # at $t3 and after the inner loop we will have the largest element to swap with at $t3
   	    # But before we do anything we have to check the inner loop condition, it is the same
   	    # condition with the outer loop except we compare it using $t1
   	    bge $t1, $t2, finished_inner_loop_selection_sort	 
   	    
   	    # Now if we are able to reach here then we have to compare the element at $t3
   	    # against the element at $t1. Element in $a1 are words so we the way we have to get the element
   	    # is to multiply the index by 4 and add it to the base address
	    # In register $t4 we will store the address offset of maxIndexElement, while in $t5 we will
	    # Store the offset of the element we are comparing. In $t7 we will store 4
	    li $t7, 4
	    
	    # Now multiply $t3 by $t7 and store in $t4
	    mul $t4, $t3, $t7
	    
	    # Then we multiply $t1 the inner loop counter by 4 and store in $t5
	    mul $t5, $t1, $t7
	    
	    # Now to get our effective address of the element we add $t4 and $t5 with $a1
	    add $t4, $t4, $a1
	    add $t5, $t5, $a1
	    
	    # Then we will load in each element in $t6 and $t7 for the maxIndexElement and the current
	    # element we are comparing in j
	    lw $t6, 0($t4) # $t6 have our maxIndexElement
	    lw $t7, 0($t5) # $t7 have our element that we are comparing maxIndexElement with
	    
	    # Now because of the special case that if the counts are equal
	    # We have to take the letter that has a smaller ascii value 
	    # We must do more work to check to ascii values too
	    beq $t6, $t7, check_ascii_values_too_before_replace
	    
	    # If we are here then that means that the two elements are definitely not equal so there is no 
	    # conflicts, we just have to take the one that is bigger after comparsion
	    # If our maxIndexElement is bigger than or greater than the element we are comparing
	    # Then we don't replace max_index_element because it is already the biggest
	    # And we only take the first largest not the last
	    bge $t6, $t7, skip_replace_max_index_element
	    
	    # If we are here then that means we are replaing max_index_element
	    # with the one we have currently in the inner loop which is $t1
	    move $t3, $t1
	    
	    # After we updated the maxIndexElement we have to increment
	    # the inner loop counter $t1 so we jump to skip_replace_max_index_element
	    j skip_replace_max_index_element
	    
	    check_ascii_values_too_before_replace:
	    # If we are here then that means the two values we are comparing
	    # Have the same exact counts, hence we need to check their ascii
	    # values to further determine which one we replace $t3 with
	    # The only important registers here is
	    # $t0, which is our current element that we have this is also our outer loop counter
	    # $t1, which is the current element we are comparing $t3, the maxIndexElement 
	    # $t2, is our stop condition, we must not change it
	    # Then all the register from $t4 and on can be used but we will use $s registers to distingusish
	    # Between comparing the ascii value from the counts value
	    
	    # Now because the counts are organized by bytes not words, we don't have to multiply by 4
	    # in order to access each index element
	    # We just have to add $t1 with $sp and $t3 with $sp
	    add $s0, $t3, $sp # This is the maxIndexElement's letter address
	    add $s1, $t1, $sp # This is the element we are comparing to maxIndexElement's letter's address
	    
	    # Now we get the actual ascii value
	    lbu $s2, 0($s0) # This is the maxIndexElement's letter
	    lbu $s3, 0($s1) # This is the element we are comapring to maxIndexElement's letter
	    
	    # Now we only take the one that is lower ascii value, not the bigger one
	    # So if the ascii value of $s0 is greater than $s1's ascii value
	    # Like if e is the maxIndexElement compared to a, we take a not e so
	    # update the maxIndexElement ($t3) to $t1, else if $s0's ascii is less than $s1 we skip
	    
	    # This means that the letter we have is already the smaller ascii value so we skip
	    blt $s2, $s3, skip_replace_max_index_element 
	    
	    # Else if $s1 is the smaller ascii value we place $t3 with $t1
	    move $t3, $t1
	     
	    # Then logically we move onto the next count to check
	    
	    skip_replace_max_index_element:
   	    # Here we just have to increment $t1 the inner loop counter
   	    addi $t1, $t1, 1
   	    
   	    # And jump back up the inner loop
   	    j for_loop_selection_sort_inner
   	    	
    	# If we are here then $t3 have the largest element index to swap with $t0's element
    	# We swap here
    	finished_inner_loop_selection_sort:
	# Let's restate the registers that are important again
	# $a0 is where we are putting the sorted letters
	# $a1 is the counters array that have the counts for each letter
	# $t3 is the register that have the index of the largest element to swap with element in $t0
	# $t0 the outer loop counter which is also the element index that we are swapping with element in $t3
	# $t2 is our 26 which is our stopping condition make sure we don't mess with that
	# then rest of the registers are free for us to use
	
	# Now again we have to get our effective address in order to do the swapping
	# Load 4 into $t7
	li $t7, 4
	
	# We multiply $t3 by $t7 and store in $t4 this is offset for the maxIndexElemenet we store in $t4
	mul $t4, $t3, $t7
	
	# We multiply $t0 by $t7 and store it in $t5 this is the offset for the current element we have to
	# swap with maxIndexElement and we store in $t5
	mul $t5, $t0, $t7
	
	# Now to get our effective address of the element we add $t4 and $t5 with $a1
	add $t4, $t4, $a1 # The max element
	add $t5, $t5, $a1 # The current element we have to swap with
	
	# Then we load in the actual value of each element
	lw $t6, 0($t4) # $t6 is our max element
	lw $t7, 0($t5) # $t7 is the current element we have to swap with
	
	# Then we just have to swap with the address
	sw $t6, 0($t5) # We put the current element into where the max element is
	sw $t7, 0($t4) # Then we put the max element to where the current element is
	
	# Now that only did the counter element, we have to do it in the run time stack array
	# to mirror the effect all we have to do is to change $a1 to $sp
	# Because the array is byte sized, we don't have to multiply by 4
	
	# Remember we are swapping the letters in the run time stack so to get our
	# effective address we have to add the offset indext with the stack pointer register
	add $t4, $t3, $sp # The max element
	add $t5, $t0, $sp # The current element we have to swap with
	
	# Then everything else is the same as the previous one
	lbu $t6, 0($t4) # $t6 is our max element
	lbu $t7, 0($t5) # $t7 is the current element we have to swap with
	
	# Then we just have to swap with the address
	sb $t6, 0($t5) # We put the current element into where the max element is
	sb $t7, 0($t4) # Then we put the max element to where the current element is
	
	# We swapped in the counter, we swapped in the run time stack
	# We can proceed to the next letter
	
	# Swap is complete we can increment $t0 to work on the next element
	addi $t0, $t0, 1
	
	# Then we jump back up to the outer loop
	j for_loop_selection_sort_outer
	
    finished_selection_sort:
    # After finishing the selection sort, the counts array is sorted, the run time stack is sorted
    # based on ascii values and the counts. Then all we have to do is just replace everything in 
    # a0 with the letters in the run time stack then we are done!
    # We will again be keeping track of the index of this loop in $t0 starting at 0
    li $t0, 0
    
    # We know this loop will run 26 times so our stopping condition is at 26
    li $t1, 26
    
    # Now before we do anything, because the string sorted_alphabet is 27 byte in size it must be null
    # terminated at index 26. Let's just do that right now and get it out of the way first
    sb $0, 26($a0) # Putting a null terminator at the end of the String
    
    # Then we can go through a for loop to copy the ordering of the letters in the run time stack
    # to the String
    for_loop_for_extracting_from_rts:
    	# Obviously we have to do the stopping condition first
    	bge $t0, $t1, finished_the_sort_alphabet_by_count_function
    	
    	# Of course we have to grab the effective address from the run time stack
    	# and the string first
    	# We will store it in $t2 the effective address of run time stack
    	add $t2, $t0, $sp 
    	
    	# We will store in it $t3 the effective address of the String
    	add $t3, $t0, $a0
    	
    	# Then we load the letter from $t2 into $t4
    	lbu $t4, 0($t2)
    	
    	# Then just have to store it in the effective address of the String $t3
    	sb $t4, 0($t3)
    	
    	# Increment the loop counter
    	addi $t0, $t0, 1
    	
    	# Jump back up
    	j for_loop_for_extracting_from_rts
    
    finished_the_sort_alphabet_by_count_function:
    # If we are here then we have extracting the letters from the run time stack and moved to
    # the String we need to move it to
    
    # Now we have to restore what was in those 4 $s registers from the runtime stack
    lw $s0, 28($sp) # The first word stores $s0
    lw $s1, 32($sp) # Second word stores $s1
    lw $s2, 36($sp) # Third word stores $s2
    lw $s3, 40($sp) # Fourth word stores $s3
    
    # Then we have to deallocate the 44 byte of memory we have allocated
    addi $sp, $sp, 44
    
    # Jump back up to the main	
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
