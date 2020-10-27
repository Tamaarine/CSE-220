# Ricky Lu
# rilu
# 112829937

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################

.text
memcpy:
    # This function basically takes n byte of data from src, and copies it onto dest array, this
    # method will be used tocopy one struct to another place
    # The destination is guaranteed to be at least n byte in size
    
    # $a0 -> dest, address to copy byte to
    # $a1 -> src, address to copy byte from
    # $a2 -> n, the number of bytes to copy from dest to src
    # Output -> $v0, number of bytes copied which is just n
    
    # First we will check whether or not the number of bytes is > 0, if it is <= 0 then
    # we will return -1 and done with the algorithm
    # If this branch is true then that means n is less than or equal to 0 hence invalid_num_bytes
    ble $a2, $0, invalid_num_bytes
    
    # We will be using a counter to keep track of the number of bytes that we have copied so far
    # in the loop and that can just be in $t0
    li $t0, 0 # Initalize it to the value of 0
    
    # If we are here then that means n is definitely greater than 0 and hence is valid
    # We will be implementing this by simply using a for loop
    for_loop_to_copy_bytes:
    	# Let's do our stopping condition first which is when
    	# our counter is greater than or equal to n we will stop because we have copied
    	# n byte of data already
    	bge $t0, $a2, finished_for_loop_to_copy_bytes 
    	
    	# Now if we are here then we have to actually copy the data from $a1 to $a0
    	# and we will do it byte by byte
    	# Let's get the byte that is from src first, we will be doing lbu instead of lb because professor said so
    	# we can just use the address of src $a1 directly
    	lbu $t1, 0($a1) # Getting the byte from src
    	
    	# In $t1 we have the byte that is loaded in we will store that byte we got into
    	# 0($a0) directly, we don't need any offsets for both address because we will increment them 
    	# both after we have finish storing
    	sb $t1, 0($a0) # Storing the byte from src we got into dest
    	
    	# Now we can just increment everything
    	addi $a1, $a1, 1 # Incrementing the src address to point to the next byte
    	addi $a0, $a0, 1 # Incrementing the dest address to point to the next space to store
    	addi $t0, $t0, 1 # Incrementing the counter for the number of bytes we copied
    	
    	# Then we just have to jump back up the loop
    	j for_loop_to_copy_bytes

    finished_for_loop_to_copy_bytes:
    # Now if we are here then we have finished copying n number of bytes
    # from src to dest
    # the value of n or $t0 have our output value which is the number of bytes copied
    move $v0, $t0
    
    # Then we can just finish with the algorithm
    j finished_memcpy_algorithm
    
    invalid_num_bytes:
    # If we are here then that means the given n is less than or equal to 0 hence we just return
    # -1 in the return value
    li $v0, -1
    
    # Then we can just follow it logically to the next line and finish with the algorithm
    
    finished_memcpy_algorithm:
    # If we are here then we are finsihed with the algorithm
    # we can just return to the caller because there is nothing we need to deallocate or restore
    
    jr $ra

strcmp:
    # This function takes two null terminated String which could both or either be empty
    # and returns an integer that compares the two String lexicographically
    
    # $a0 -> str1's starting adress
    # $a1 -> str2's starting adress
    # Output -> $v0, the differences between the ascii value for the first mismatched letter that is found
    # or it will return 0 if the String are equal or both are empty string. It will return length of
    # str1 if str2 is an empty string and str1 is non-empty. It will return length of str2 negated if
    # str1 is empty and str2 is non-empty
    
    # So here is the game plan, we will first check if the two Strings are empty, if they are both empty
    # then they are definitely equal and we can just return 0
    # We just have to grab the first letter from both String to check and if they are both null terminator
    # then they are equal for sure since they are both empty String
    lbu $t0, 0($a0) # Getting the first letter from str1
    
    # We will be checking str1's first letter first to see if it is a null terminator
    bne $t0, $0, str1_is_not_empty
    
    # If we are here then that means str1 is in fact an empty String
    # But we need to also check whether or not str2 is an empty String
    # Let's get the first letter from str2 into $t0
    lbu $t0, 0($a1) # Getting the first letter from str2
    
    # We check here str2's first letter and see that if it is not a null terminator
    # then we know for sure str2 is not empty
    bne $t0, $0, str2_is_not_empty
    
    # However, if we reached here that means str1 and str2 are both empty 
    # and hence they are equal therefore we have to return 0 for return value
    li $v0, 0
    
    # Then we can just jump to finish because we are done
    j finished_strcmp_algorithm
    
    str1_is_not_empty:
    # Now if we are here then we for sure we know str1 is not empty
    # but we are still uncertain about if str2 is empty or not so we have to do another check
    # for str2 to determine whether or not str2 is empty
    lbu $t0, 0($a1) # We load the first letter from str2
    
    # If the first letter from str2 is not a null terminator
    # then we know both string are non-empty
    bne, $t0, $0, both_string_are_non_empty
    
    # Butt if we are here then that means the first letter from str2 is indeed a nmull terminator
    # which means str2 is empty therefore we can just return the length of the first String
    # as our output value
    
    # We will keep the length counter in $t0
    li $t0, 0
    
    # We have to use this for loop to find the length of str1 because str2 is empty and str1 is non-empty
    for_loop_to_find_length_str1:
    	# Let's do our stopping condition which is when we reach a null terminator in str1
    	lbu $t1, 0($a0) # Loading in the current letter from str1
    	
    	# If we read a null terminator then we stop the for loop because we finish
    	# counting the length already
    	beq $t1, $0, finished_for_loop_length_str1
    	
    	# If we are here then that means it is not a null terminator hence we increment
    	# then length counter
    	addi $t0, $t0, 1
    	
    	# We also increment the address of str1 to read the next character
    	addi $a0, $a0, 1
    	
    	# Then we jump back up the loop
    	j for_loop_to_find_length_str1
    	
    finished_for_loop_length_str1:
    # Now if we are here then $t0 is the length of str1 which we can just return
    # in $v0 as our output value
    move $v0, $t0
    
    # And then we can just jump to finish_algorithm
    j finished_strcmp_algorithm
    
    
    str2_is_not_empty:
    # If we are here then that means str1 is empty and str2 is not empty
    # hence we can just return the negated length of str2 as our output value
    
    # $t0 will be our length counter
    li $t0, 0
    
    # We will be using this for loop to find the length of str2 then just multiply -1 to it to get the negated value
    for_loop_to_find_length_str2:
    	# Let's do the same stopping condition which is when we hit a null terminator
    	lbu $t1, 0($a1) # Loading in the current character from str2
    	
    	# If the letter that we got is a null terminator then we are finished counting the
    	# length in str2
    	beq $t1, $0, finished_for_loop_length_str2
    	
    	# However, if we are here then we have to increment length counter
    	addi $t0, $t0, 1
    	
    	# We also have to increment the address of str2 to get the next character
    	addi $a1, $a1, 1
    	
    	# Then jump back up the loop
    	j for_loop_to_find_length_str2
    
    finished_for_loop_length_str2:
    # Anddd if we are here then we got the length of str2 and we must multiply -1 to it
    # to get our return value
    li $t7, -1
    
    # Multiply str2's length with -1 and put it into $v0 as our return value
    mul $v0, $t0, $t7
    
    # Then we are done with the algorithm
    j finished_strcmp_algorithm
    
    
    both_string_are_non_empty:
    # If we are here then that means both Strings are non-empty
    # here we must do a for-loop to return the proper lexicographical return value
    for_loop_to_determine_lexicographic_return:
    	# We will grab current letter from both str1 and str2 for comparsion
    	# Grab str1's letter
    	lbu $t0, 0($a0) # $t0 will be the letter from str1
    	
    	# Grab str2's letter
    	lbu $t1, 0($a1) # $t1 will be the letter from str2
    	
    	# First we do a comparsion if str1's letter equal to str2's letter
    	# then it can be either they are the same letter or both are null terminator
    	beq $t0, $t1, move_on_next_letter_or_equal_string
    	
    	# Now if we are here then it is for sure that str1's letter and str2's letter aren't equal
    	# and there are three different cases
    	# 'A' and 'B' which we just return the difference between the ascii values
    	# 'A' and '\0' which we just return A's ascii value subtract by 0
    	# '\0' and 'A' which we return 0 - A's ascii value
    	# Which is all just A - B case we don't have to worry about anything and we can just subtract
    	# because we hit two letter from two strings that are different so we have to compare and find the
    	# lexicographical difference between the two strings
    	sub $v0, $t0, $t1 # This is taking str1's letter minusing str2's letter and storing it into our output value
    	
    	# And that is it for the case if the two letter from both string aren't equal
    	j finished_strcmp_algorithm
    	
    	
    	move_on_next_letter_or_equal_string:
    	# Now if we are here then that means either str1 and str2's current letter are both
    	# the same letter like 'A' = 'A' or both hit a null terminator which means that
    	# str1 = str2 
    	
    	# Because both string are equal, if the letter from str1 equals to a null terminator
    	# then letter from str2 will also be a null terminator hence the two strings are equal
    	
    	# Because both strings are equal, if the letter from str1 isn't equal to a null terminator
    	# then letter from str2 will also be a null terminator, so the two letter are equal in
    	# 'A' = 'A' we have to move onto the next character
    	bne $t0, $0, unequal_character_case
    		
    	# Now if we didn't take the branch that means both letter from str1 and str2 equals to
    	# a null terminator hence that means the two strings are equal
    	# we return 0 in our output value and break out of the loop
    	li $v0, 0
    	
    	# Finished with the algorithm, the two strings are equal
    	j finished_strcmp_algorithm	
    	
    	unequal_character_case:
    	# If we are here then that means the two letters from str1 and str2 are equal in the sense
    	# that they are both currently the same letter so we to check the next pair of characters
    	# Thus we have to increment the address for both strings
    	addi $a0, $a0, 1 # Increment address for str1 to get next char
    	addi $a1, $a1, 1 # Increment address for str2 to get next char
    	
    	# Then we have to jump back up the loop
    	j for_loop_to_determine_lexicographic_return

    finished_strcmp_algorithm:
    # If we are here then that means we are finished with strcmp algorithm
    # since there is nothing to deallocate or restore we can just return to the caller
    
    # Return to the caller of this function
    jr $ra

initialize_hashtable:
    



    jr $ra

hash_book:
    jr $ra

get_book:
    jr $ra

add_book:
    jr $ra

delete_book:
    jr $ra

hash_booksale:
    jr $ra

is_leap_year:
    jr $ra

datestring_to_num_days:
    jr $ra

sell_book:
    jr $ra

compute_scenario_revenue:
    jr $ra

maximize_revenue:
    jr $ra

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
