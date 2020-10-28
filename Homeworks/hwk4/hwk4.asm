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
    # Now if we are here then this function takes an uninitialized HashTable struct and initialize it
    # by setting the struct's capacity to the given capacity, the size to 0, element_size to the given
    # element_size, and fill the entire element object array with 0 -> All capacity * element_Size bytes
    
    # $a0 -> The pointer to the uninitialized block of memory for the hashtable
    # $a1 -> The max number of element in the has tables elements array
    # $a2 -> The size of a single struct element that is stored in one element of the hash table's 
    # element array
    # Output -> $v0, Return -1 if capacity is less than 1 or element_size is less than 1 or 0 otherwise
    
    # Keep in mind that the hashtable that we are making directly contain the array of structs
    # and not just the pointer to the structs
    
    # So the first step that we have to do is to check whether or not the given capacity, and given
    # element_size is less than 1 if it is we just return -1 without changing the hashtable pointer
    # $t7 will be used as our value comparsion register
    li $t7, 1
    
    # If we take this branch that means the given capacity to this function is less than
    # 1 therefore it is considered invalid, hence we just return -1 and finish with this function
    blt $a1, $t7, invalid_capacity_or_element_size_argument
    
    # Now if we are here then capacity is definitely greater than or equal to 1 which is fine
    # but we still have to check if element_size is valid or not
    # If we take this branch that means the given element_size is less than 1 which is invalid
    # hence we just return -1 and finish with the function as well
    blt $a2, $t7, invalid_capacity_or_element_size_argument
    
    # If we are here then that means the capacity and element_size are both valid therefore
    # we can proceed to set the struct's attributes
    
    # First step, we set the struct's capacity field to the given capacity
    # Capacity is stored at 0($a0) in the given hashtable and is size of 4 bytes (a word)
    sw $a1, 0($a0) # Putting the given capacity in the hashtable's capacity
    
    # Second step, we set the struct's size field to 0 
    # Size is stored at 4($a0) in the given hashtable and is also size of 4 bytes
    sw $0, 4($a0) # Putting 0s in the hashtable's size field
    
    # Third step, we step the struct's element_size field to the given element_size
    # Element_size is stored at 8($a0) in the given hashtable and is size of 4 bytes
    sw $a2, 8($a0) # Putting the element size in the hashtable's element_size field
    
    # Fourth step, we have to clean all the capacity * element_size bytes to 0
    # in the hashtable. We will be doing in through a for loop
    # Let's compute how many byte we have to go through first which is capacity * element_size
    # and store that result in $t1
    mul $t1, $a1, $a2 # Multiplying capacity with element_size
    
    # We will be keeping a counter of how many bytes we have clean so far in $t0
    li $t0, 0
    
    # Before we begin cleaning we have to move the $a0 pointer to actually point at the
    # part of the struct that we have to clean which starts at 12($a0)
    addi $a0, $a0, 12 # Adding offset of 12 to get the pointer to the first byte of the element array
    
    # This for loop will be going through the hashtable to clean the array
    for_loop_to_clean_the_hashtable_array:
    	# Let's check our stopping condition first
    	# If our counter becomes greater than or equal to the number of bytes that we have to clean
    	# then we are done clenaing the array and we can stop
    	bge $t0, $t1, finished_cleaning_hashtable_array
    	
    	# Now if we are here then we have to actually clean the byte that is in 0($a0)
    	# We are cleaning byte by byte not word by word
    	sb $0, 0($a0) # Putting 0 in the byte that is in 0($a0)
    
    	# After we clean this byte we have to increment the byte counter
    	addi $t0, $t0, 1
    	
    	# And we also have to increment $a0 to go to the next byte to clean
    	addi $a0, $a0, 1
    	
    	# Then we jump back up the for loop
    	j for_loop_to_clean_the_hashtable_array
    
    finished_cleaning_hashtable_array:
    # Now if we are here then the for_loop have finished going through all the
    # capacity * element_size bytes and clean all of them
    # We can just return 0 as our output value and finish with the algorithm
    li $v0, 0
    
    # Jump to finish algorithm
    j finished_initialize_hashtable_function

    invalid_capacity_or_element_size_argument:
    # If we are here then either the given capacity or element_size argument is invalid
    # hence we just return -1 in $v0 and finish with the function
    li $v0, -1
    
    finished_initialize_hashtable_function:
    # Because we didn't allocate any memories or used any $s register we don't have to deallocate
    # or restore anything and can just return to the caller
    
    # Returning to the caller
    jr $ra

hash_book:
    # This function basically takes in a valid HashTable struct called books and an
    # 13 - value ISBN value that we have to hash it, to hash it we just take
    # the sum of the 13 ascii values and mod it by the capacity of the books hash table
    
    # $a0 -> The starting address of the HashTable structure
    # $a1 -> The 13 null terminated character that represent valid ISBN
    # Output -> $v0, the value of the hash function when evaluated for the provided ISBN
    
    # First step that we have to do is to sum up all the 13 ascii values that is in the ISBN
    # we will put the sum of the ascii value inside $t0
    li $t0, 0
    
    # Now next we will be using a for loop to do the summation
    for_loop_to_sum_isbn:
    	# Let's do our stopping condition first
    	# which is when the character we get from $a1 is a null terminator then we will stop
    	lbu $t1, 0($a1) # Loading the character from the ISBN
    	
    	# If the character that we read from the ISBN is a null terminator then we are
    	# done summing all the ascii values from the ISBN and we can exit	
    	beq $t1, $0, finished_summing_isbn_ascii
    	
    	# But if we are here then that means $t1 is not a null terminator hence we have to sum
    	# it together into $t0
    	add $t0, $t0, $t1 # Adding the ascii sum with the current ascii value from ISBN
    	
    	# After summing the current character we have to increment the ISBN String address to point
    	# to the next character to sum
    	addi $a1, $a1, 1
    	
    	# Then we jump back up the loop
    	j for_loop_to_sum_isbn

    finished_summing_isbn_ascii:
    # Now if we are here then that means $t0 have the sum of all 13 ascii values
    # and all we have to do is to divide it with the capacity of the HashTable
    # Let's get the capacity from the hashtable first
    # which is located at 0($a0) as the entire word, we will load it into $t1
    lw $t1, 0($a0) # Loading capacity from the HashTable
    
    # Now we can do the division
    div $t0, $t1 # Dividing the sum of ascii value by the capacity
    
    # We can get the remainder using mfhi which is our return value in $v0
    mfhi $v0
    
    # Then that is it we are done with this function and can just return to the caller
    # there is nothing to deallocate or to restore so we can just follow to jr $ra
    jr $ra

get_book:
    # This function takes in a valid HashTable struct where each element in the arrayt is a book struct
    # and it also takes in an ISBN String, it will return the index of where that ISBN is in the array
    # of book struct and the number of entries we have looked by linear probing before it is found
    
    # $a0 -> The starting address of that valid HashTable struct
    # $a1 -> The ISBN String that we want to find
    # Output -> $v0, returns the index that the element is found, or -1 if the HashTable doesn't have
    # that particular book
    # Output -> $v1, returns the amount of books that is looked before a book is found or not found
    
    # So our first step is to save these two arguments because we we will be calling functions
    # two arguments, is 8 byte, and the return address. 12 bytes in total
    # Add in another $s register for saving the return index of the expected
    # and another $s register for saving the total of book entry we have looked at
    addi $sp, $sp, -20 # Allocating 20 bytes of memory in the run time stack
    
    # Now we save the $s registers before we can use them
    sw $s0, 0($sp) # Saving $s0 register
    sw $s1, 4($sp) # Saving $s1 register
    sw $s2, 8($sp) # Saving $s2 register
    sw $s3, 12($sp) # Saving $s3 register
    
    # Saving the return address
    sw $ra, 16($sp)
    
    # Now we can move the arugments to the $s register
    move $s0, $a0 # $s0 will have the valid HashTable struct
    move $s1, $a1 # $s1 will have the ISBN String address that we want to find
    
    # Now we will call the hash_book function for the first time to check
    # if the index that is expected is where the book belong
    # $a0 -> HashTable
    # $a1 -> ISBN String that we want to find
    move $a0, $s0
    move $a1, $s1
    
    # Now we can call the function hash_book
    jal hash_book
    
    # We save the expected index into our $s2 register
    move $s2, $v0
    
    # After calling hash_book $s2 will have the index where the
    # the ISBN is 'suppose' to go in the book array
    # Now we have to perform a one iteration check to see if probing is needed
    # If the expected index does indeed have our book then we can just return
    # the index we got as our $v0, and 1 as our $v1 because we only did one time check
    # There is other cases, like deleted, empty, and another book which need to be handle separately
    
    # We must check the deletede and empty case first before
    # To get the ISBN in that index we have to do some math calculation
    # to get the effective address of that book, we will have to do
    # 12($base_address) + index * element_size, which is always 68 because a
    # book struct always take up 68 bytes
    # Let's store 12($base_address) into a registe, $t0
    addi $t0, $s0, 12 # Adding 12 byte to the HashTable to get to the starting address of the book struct array
    
    # Then we can get to any book struct in the array by adding index * 68
    # let's do the multiplication and store the result into $t1
    li $t7, 68 # Storing 68 into the $t7 for multiplication
    
    # Multiplying the index with 68 to get the offset
    mul $t1, $s2, $t7
    
    # Then we can just add it into $t0 to get the effective address of that book struct
    add $t0, $t0, $t1
    
    # We will load in the first byte of that book to help us check whether or not that book object
    # is empty, deleted, or has a book into $t1
    lbu $t1, 0($t0) # Loading the first byte of the book object unsigned 
       
    # If that byte is -1, 0xFF (unsigned byte) then we know that that that entry is definitely deleted
    # hence probing is required
    li $t7, 0xFF # 255, or -1 in the context of unsigned byte for -1 for comparsion
    
    # Now if the first byte of the book is a deleted then we have to go do probing
    beq $t1, $t7, probing_required
    
    # However, if we are here then that means the first byte is not -1, meaning the book could be
    # a book or empty we will check the empty case
    beq $t1, $0, empty_expected_entry_found
    
    # Now if we are here then the book is not deleted, or empty, then it has to be an actual book
    # in this index, and hence we must perform checks to determine whether, that book
    # is the book we are looking for or we need to do probing
    j a_book_expected_entry_found
    
    
    empty_expected_entry_found:
    # Now if we branch here then that means the expected location is empty
    # hence there is no such book of given ISBN exist in the book array
    # We just return -1 and 1 in our return value
    li $v0, -1 # -1 for not able to find the book
    li $v1, 1 # 1 for we only had to check one book to know there isn't such book in the book array
    
    # Then we are essentially done with the algorithm
    j finished_get_book_algorithm
    
    
    a_book_expected_entry_found:
    # But if we branch here then that means the expected location does have a book
    # we have to check whether or not this book matches the book we are looking for
    # if so we will return the index it is found and 1 in our return value
    # we will do the checking by calling strcmp, if it is not the one we are looking for
    # then we have to do probing
    
    # $a0 -> str1, which is the ISBN we are looking for
    # $a1 -> str2, which is the one in the expected book array, it is in $t0 already and we can just pass it in
    move $a0, $s1 # The ISBN that we are looking for
    move $a1, $t0 # The ISBN that we expect in the array
    
    # Calling the strcmp function
    jal strcmp
    
    # Now in $v0 we have the answer whether or not the ISBN we are looking for is in the expected
    # location, if it is not equal to 0 then we have to do probing
    bne $v0, $0, probing_required
    
    # But if we are here then that means the expected ISBN matches our target ISBn
    # hence we can just return $s2 in $v0, and 1 in $v1 because it only took one iteration
    # to do the checking
    move $v0, $s2 # $s2 have the expected index from the beginning
    li $v1, 1 # We return 1 because it only take one check for checking the expected location
    
    # And we are done with the algorithm
    j finished_get_book_algorithm
    
    probing_required:
    # But if we are here then unfortunately we have to do probing procedures
    # we will start probing at $s2 + 1, which is the next book after the expected location
    # because the expected book is either deleted or it doesn't match our ISBN
    addi $s2, $s2, 1 # Adding 1 to our expected location
    
    # We also need to keep track of the total number of books we have looked
    # as part of our stopping condition it will start with 1 because we have looked at
    # the expected book already. And the for loop will stop whenever it hits the capacity
    # of the HashTable
    li $s3, 1 # The total number of books checked counter
    
    for_loop_to_do_probing_search:
    	# Our stopping condition will be whenever we find an empty entry or if the book counter hits
    	# the capacity, or if the target book is found
    	
    	# First condition to check is if $s3 is less than the capacity. If it is greater than or equal to
    	# the capacity then we have finished checking all the books but the target ISBN is not found
    	# Loading in the capacity from the HashTable
    	lw $t0, 0($s0) # Capacity is at 0($s0) of the HashTable
    	
    	# Stopping condition of looking through all books but target ISBN is not found 
    	bge $s3, $t0, finished_checking_all_books_no_target_isbn_found
    	
    	# Now if we are here then that means we haven't look through all the books
    	# Let's get our current book from the array through $s2, which is the counter for index of which
    	# book we are looking at. We have to mod it with capacity because it will handle the wrap around
    	div $s2, $t0 # Diving the index counter by the capacity, and in HI it will have the actual index we need to look
    	
    	# Let's store remainder (the index) into $t1
    	mfhi $t1
    	
    	# Now with $t1 as the index we have to get the book by doing some calculation
    	# 12($base_address) + index * element_size, element_size is always 68
    	# Let's store 12($base_address) into $t2
    	addi $t2, $s0, 12 # This gets us to the object array
    	
    	# Now we calculate the offset
    	li $t7, 68 # 68 for multiplication
    	
    	# We store the multiplication result into $t3
    	mul $t3, $t1, $t7 # Multiplying the index by 68
    	
    	# Then we add it back into the object array address
    	add $t2, $t2, $t3 # This gets us the book that we are looking at
    	
    	# Now before we do strcmp we have to check if this book is currently, empty, deleted, or is an actual book
    	# all we have to do is load in the first byte, we will load into $t3
    	lbu $t3, 0($t2)
    	
    	li $t7, 0xFF # -1 without sign extension equivalent of -1
    	
    	# If the current book we have is a deleted entry then we have to continue the probing search
    	beq $t3, $t7, next_probing_search_iteration
    	
    	# However, if the current book we have now is an empty book, then we stop searching
    	# increment the number of books we looked at and return
    	beq $t3, $0, probing_search_found_empty
    	
	# But if the book is not deleted, or not empty then we have to do the comparsion
	j probing_search_found_a_book
    	
    	probing_search_found_empty:
    	# If we are here then that means we have found an empty book during linear probing
    	# hence we just have to increment $s3 counter once, load that in as our return value
    	# and return -1 for unable to find the target ISBN in $v0
    	li $v0, -1
    	addi $s3, $s3, 1 # Incrementing $s3 once
    	
    	# Moving from $s3 as our return value for $v1
    	move $v1, $s3
    	
    	# Then we are done with this algorithm
    	j finished_get_book_algorithm
    	    	
    	probing_search_found_a_book:    	    	
    	# Now we must call strcmp to compare the target ISBN and the current book ISBN we are looking at
    	# $a0 -> str1
    	# $a1 -> str2
    	move $a0, $s1 # The book that we are looking for
    	move $a1, $t2 # The book that we current have to compare with
    	
    	jal strcmp
    	
    	# In $v0 we have the result of whether or not the two ISBN is equal or not
    	# if the result is $0 then we have found the book we need to find
	beq $v0, $0, finished_for_loop_for_probing_search
    
    	# However, if the book didn't match then we have to check the next book
    	# And the incrementation can just follow it logically
    	
    	next_probing_search_iteration:
    	# If we are here then we will check on with the next iteration
    	# before we jump back up we have to do some incrementation
    	# We have to increment the index
    	addi $s2, $s2, 1
    	
    	# We also have to increment the total number of books we have looked
    	addi $s3, $s3, 1
    	
    	# Then we can jump back up the for loop
    	j for_loop_to_do_probing_search
    	
    finished_for_loop_for_probing_search:
    # If we are here then we have found the book we need to find
    # before we can return we have to add 1 to the $s3 because we didn't
    # increment that iteration in the for loop
    addi $s3, $s3, 1
    
    # And that will be our $v1 return value
    move $v1, $s3
    
    # For $v0 we have to do the mod with capacity to get the index we found the book in
    lw $t0, 0($s0) # We load the capacity from the HashTable
    
    # We do the division with the index counter $s2
    div $s2, $t0 
    
    # Then $v0 can just be the value in HI
    mfhi $v0
    
    # And finally we can return as we are finished with the algorithm
    j finished_get_book_algorithm
    
    
    finished_checking_all_books_no_target_isbn_found:
    # If we are here then that means that we have looked through all the books
    # but the ISBN is not found hence we have to return -1 and the capacity
    # because we have looked through all the books
    li $v0, -1
    move $v1, $s3 # Return $s3 because it will reach the capacity whenever we break out of the for loop with this condition
    
    # Then we can just follow the next line logically to return

    finished_get_book_algorithm:
    # If we are here then we have to restore all the $s registers that we have used
    lw $s0, 0($sp) # Restoring $s0 register
    lw $s1, 4($sp) # Restoring $s1 register
    lw $s2, 8($sp) # Restoring $s2 register
    lw $s3, 12($sp) # Restoring $s3 register
    
    # Restoring the return address or else get_book won't know where to return
    lw $ra, 16($sp) # Restoring the return address

    # Then we deallocate the memory that we used
    addi $sp, $sp, 20 # Deallocating the 20 byte that we used

    # Then we can jump back to the caller
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
