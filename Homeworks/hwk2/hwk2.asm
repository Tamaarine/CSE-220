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
    
    # $a0 -> stores the address of the String in which we are converting
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
