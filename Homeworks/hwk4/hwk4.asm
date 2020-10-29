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

strlength:
    # This is suppose to be a helper method for add_book
    # to find the length of a given String
    
    # a0 -> The null terminated String we are looking the length for
    # Output -> $v0, the length of the String
    
    # We will be keeping a counter as 0 in $t0
    li $t0, 0
    
    for_loop_for_finding_length_of_string:
    	# We will do our stopping condition first which is whenever
    	# we hit a null terminator
    	lbu $t1, 0($a0) # Loading in the current byte from the given String
    	
    	# This is our stopping condition if we hit a null terminator in the String
    	# then we are done finding the length
    	beq $t1, $0, finished_loop_finding_length_of_string
    
        # However if it is not a null terminator then we have to
        # increment the counter
        addi $t0, $t0, 1
        
        # And we also need to increment the String address to point to the next character
        addi $a0, $a0, 1
        
        # Then we jump back up the loop
        j for_loop_for_finding_length_of_string
    
    finished_loop_finding_length_of_string:
    # Then if we are out here that means $t0 have the lenght of the String
    # We can just put into our output value
    move $v0, $t0
    
    # And return
    jr $ra
    
add_book:
    # This function essentially attempt to insert the given book into the HashTable struct
    
    # $a0 -> The starting address of a valid HashTable
    # $a1 -> The 13 character null-terminated String that represent a valid ISBN
    # $a2 -> The null terminated String that represent the book title
    # $a3 -> The null terminated String that represent the book author
    # Output -> $v0, the index of element where the new book is added or found if it already exist
    # returns -1 if the table is full
    # Output -> $v1, the number of entries accessed before the book is added or -1 if the table is full
    
    # Because we will be calling functions we have to store the arguments into $s registers
    # total of 4 arguments, 16 bytes, and a return address total of 20 bytes
    # Add another three more register that is required later so 12 more bytes
    addi $sp, $sp, -32 # Allocating 32 bytes in the run time stack
    
    # Saving the $s registers before we can use it
    sw $s0, 0($sp) # Saving the $s0 register
    sw $s1, 4($sp) # Saving the $s1 register
    sw $s2, 8($sp) # Saving the $s2 register
    sw $s3, 12($sp) # Saving the $s3 register
    sw $s4, 16($sp) # Saving the $s4 register
    sw $s5, 20($sp) # Saving the $s5 register
    sw $s6, 24($sp) # Saving the $s6 register
    
    # Saving the return address
    sw $ra, 28($sp)
    
    # Now we can save the arguments
    move $s0, $a0 # $s0 have the valid HashTable
    move $s1, $a1 # $s1 have the 13 null terminated String that represent ISBN
    move $s2, $a2 # $s2 have the String that represent book title
    move $s3, $a3 # $s3 have the String that represent book author
    
    # Okay first step is to check if the HashTable is full or not, if the table is full
    # then the function just returns (-1,-1) and finishes
    # Let's grab the capacity and size field from the HashTable
    lw $t0, 0($s0) # Getting the capacity from the HashTable
    
    # Getting the size from the HashTable
    lw $t1, 4($s0)
    
    # If this branch is true then that means the HashTable still have space
    # hence we can proceed to work on adding the new book into the HashTable
    bne $t0, $t1, add_book_not_full_hashtable
    
    # However, if it is not true then size == capacity
    # therefore we return (-1,-1)
    li $v0, -1
    li $v1, -1
    
    # Then we can just jump to finish because we are done with this algorithm no more work is required
    j finished_add_book_algorithm


    add_book_not_full_hashtable:
    # If we are here then that means the HashTable is not full so we can try to add in
    # the book into the HashTable
    # We call get_book with the given ISBN, to see if the book is already in the HashTable
    # If it is then we just return the value return by get_book
    # $a0 -> HashTable
    # $a1 -> ISBN
    move $a0, $s0 # $a0 is the HashTable we looking through
    move $a1, $s1 # $a1 is the ISBN we are looking for 
    
    # Then we can call the function
    jal get_book
    
    # In $v0 we have the index that the target book is found
    # $v1 we have the number of books we looked before the book is found or not found
    # We just have to compare $v0 if $v0 index is -1 then we know for sure the book is not in the HashTable
    li $t7, -1
    
    # If the return value is not equal to -1 then the book is not found in the HashTable
    beq $v0, $t7, book_is_not_found_in_hashtable
    
    # But if the previous branch is false that means get_book indeed found the book in the
    # HashTable and we can just return the valuye return by get_book as our output value
    # We can just jump to finish algorithm
    j finished_add_book_algorithm
    
    
    book_is_not_found_in_hashtable:
    # If we are here then that means the book doesn't exist in the HashTable hence
    # actual insertion is required for this book
    
    # We must call hash_book first to determine where the book is expected to go
    # and if linear probing is required to find a place to put this book
    # $a0 -> The HashTable we are looking through
    # $a1 -> The ISBN that we are hashing
    move $a0, $s0 # The HashTable struct we are looking through
    move $a1, $s1 # The ISBN String we are hasing
    
    # Now we can call the function
    jal hash_book
    
    # Let's save $v0 for the expected operations
    move $s5, $v0
    
    # Now in $s5 we have the index where the book is suppose to go
    # We will do a iteration to check for the expected placement
    # We load in the first byte to check whether or not it is empty or deleted entry already
    # We have to add 12 byte to the HashTable to get to the object array
    addi $t0, $s0, 12 # Adding 12 byte to the HashTable to get to object array
    
    # 12($base_address) + index * element_size
    # We load in 68 as our element_size because book struct is fixed sized for multiplication
    li $t7, 68
    
    # Then we multiply the index with 68 to get our offset
    # we will put the offset into $t1
    mul $t1, $s5, $t7
    
    # Then we add the offset to the base_address to get the effective address of that
    # book struct in our array and put it back into $t0
    add $t0, $t0, $t1
    
    # Next we only load in the first byte to check whether or not if it is deleted, empty, or already has a book
    lbu $t1, 0($t0) # Loading in the first byte from the book struct
    
    # We load in -255 for comparsion of a deleted entry
    li $t7, 0xFF
    
    # If we are here then the first byte of the book is negative meaning it is a
    # deleted entry we can just put the book into that spot without any more work
    beq $t1, $t7, add_book_dont_require_probing
    
    # If we are here then it can be empty or a book entry
    # So we do a further check if the first byte is 0 then it is empty
    # which means we can put that book into the spot without any problem
    beq $t1, $0, add_book_dont_require_probing
    
    # Now if we are here then that means the expected spot is occupied by another book hence
    # linear probing is require to find a place to put the book
    j add_book_require_probing
    
    
    add_book_dont_require_probing:
    # Now if we are here then that means the expected placement is a deleted or empty entry
    # we can just put the book into that expected spot without any trouble
    # We have our effective address for that book in $t0, because we will be calling
    # memcpy here let's just store $t0 into $s4 as a backup
    move $s4, $t0 # $s4 temporarily have the expected location's book address for doing data placement
    
    # We can for sure put the 13 bytes into the book object first
    # $a0 -> Is the destination where we want to put our ISBN
    # $a1 -> Is the source where we are copying the ISBN from
    # $a2 -> Is how many bytes we are copying which is just 13
    move $a0, $s4 # This is the book object we are writing the ISBN to
    move $a1, $s1 # This is the ISBN we are copying from
    li $a2, 14 # 13 character hence 13 bytes, but also include the null terminator
    
    # Now we can call memcpy function
    jal memcpy
    
    # Now after calling memcpy we have sucessfully placed the ISBN into the book object
    # Now we have to handle the title as well as the author
    # This is what we will do, we find the length of author first, if the length is > 24
    # we copy only 24 byte set the 25th byte to \0
    # If the length is <= 24, we copy the length byte and do padding for 25 - length bytes
    
    # Let's call strlength on title first
    move $a0, $s2
    
    # Calling the function
    jal strlength 
    
    # Now in $v0 we have the length of the String
    # We will break into two cases if length > 24 and if length <= 24
    li $t7, 24
    
    # If the length of title is greater than 24 bytes then we copy only 24 bytes and set 25byte to \0
    bgt $v0, $t7, copy_title_24_bytes
    
    # We will put a counter for the number of bytes we have cleared
    li $t0, 0
    
    # We have 25 bytes hence 25 is our stopping condition
    li $t1, 25
    
    # The address we do the cleaning is from 14($s4), let's store it into $t2
    addi $t2, $s4, 14 # This gets us to the title
   
    # If we are here then that means the length of title is <= 24
    # What we will do it set all the 25 bytes into \0
    # then just copy length byte from the title, which effectively did the same thing as paddin
    for_loop_to_null_terminate_title:
    	# Let's do our stopping condition first
    	# which is when our counter is greater than or equal to 25
    	bge $t0, $t1, finished_null_terminating_title
    	
    	# Now if we are here then that means we have to null terminate this byte
    	sb $0, 0($t2) # Null terminating this byte
    	
    	# Then we have to do the incrementation
    	addi $t0, $t0, 1
    	
    	# We also have to increment the address the next byte we null terminate
    	addi $t2, $t2, 1
    	
    	# Then jump back up the loop
    	j for_loop_to_null_terminate_title
    
    finished_null_terminating_title:
    # Now if we are outside then that means all 25 byte in title are null terminated
    # we can just copy length byte into 14($s4)
    # $a0 -> The place where we are storing the title to, 14($s4)
    # $a1 -> The place where we are copying the title from, $s2
    # $a2 -> The number of bytes we are copying which is just $v0, length bytes
    addi $a0, $s4, 14
    move $a1, $s2 # The title we are copying
    move $a2, $v0 # The number of bytes we are copying, which is just length bytes
    
    # Then we have to call the method that does the copying
    jal memcpy
    
    # Now after we finish copying the title we have to also do the same for author
    # god dammit
    j handle_copying_author
    
    copy_title_24_bytes:
    # However if we are here then we just have to copy 24 bytes of the title
    # and set the 25th byte to \0
    # $a0 -> The place where we are copying it to
    # $a1 -> The String that we are copying from
    # $a2 -> The number of bytes that we have to copy which is 24
    
    # Title starts at the 14($s4), so we have to add it before we can pass into $a0
    addi $a0, $s4, 14
    move $a1, $s2 # $a1 is just the title
    li $a2, 24 # We are copying 24 bytes
    
    # Calling the memory copy function
    jal memcpy 
    
    # Now we copied the 24 bytes from title we have to set the 25th byte to \0
    addi $t0, $s4, 38 # Adding 38 will bring us to the last character in title of the book array
    sb $0, 0($t0) # Then we just have to put a null terminator there
    
    
    handle_copying_author:
    # After finishing copying and padding for title we also have to do the same for the author
    # We will first figure out the length of author as well
    move $a0, $s3
    
    # Calling strlength
    jal strlength
    
    # Now in $v0 we have the length of the author
    # again we will break into two difference cases for handling
    li $t7, 24
    
    # If the length of author is greater than 24 bytes we just have to copy 24 bytes
    # and set the 25th byte to \0
    bgt $v0, $t7, copy_author_24_bytes
    
    # However, if we are here then that means the length is less than or equal to 24
    # we will just null terminate everything first then copy length bytes
    # We will put a counter for the number of bytes we have cleared
    li $t0, 0
    
    # We have 25 bytes hence 25 is our stopping condition
    li $t1, 25
    
    # The address we do the cleaning is from 39($s4), let's store it into $t2
    addi $t2, $s4, 39 # This gets us to the author 
   
    # If we are here then that means the length of title is <= 24
    # What we will do it set all the 25 bytes into \0
    # then just copy length byte from the title, which effectively did the same thing as paddin
    for_loop_to_null_terminate_author:
    	# Let's do our stopping condition first
    	# which is when our counter is greater than or equal to 25
    	bge $t0, $t1, finished_null_terminating_author
    	
    	# Now if we are here then that means we have to null terminate this byte
    	sb $0, 0($t2) # Null terminating this byte
    	
    	# Then we have to do the incrementation
    	addi $t0, $t0, 1
    	
    	# We also have to increment the address the next byte we null terminate
    	addi $t2, $t2, 1
    	
    	# Then jump back up the loop
    	j for_loop_to_null_terminate_author
    
    finished_null_terminating_author:
    # If we are here then that means we have finshed null-terminating all of the bytes inside author
    # then we can start copying length byte
    # $a0 -> The place where we are copying author to
    # $a1 -> The place where we are copying author from $s3
    # $a2 -> The number of bytes we are copying which is just length
    addi $a0, $s4, 39 # Add 39 will get us to the starting address of author
    move $a1, $s3 # The author we are copying
    move $a2, $v0 # The number of bytes we are copying, which is just length bytes
    
    # Calling memcpy
    jal memcpy
    
    # Furthermore we have to reset the sales to 0
    addi $t0, $s4, 64 # This is the starting address of that word
    sw $0, 0($t0) # We put 0 in that entire word

    # And we also have to increment the HashTable's size because we have put one books in
    # the size is located at 4($s0) of the HashTable, we load it in first
    lw $t0, 4($s0)
    
    # We add one to it
    addi $t0, $t0, 1
    
    # Then we put it back in
    sw $t0, 4($s0)

    # We load the index that we found it from $s5
    move $v0, $s5
    
    # Load the number of books looked which is just
    li $v1, 1
    
    # Then we are done handling this case
    # and done with this algorithm if expected place is where we are putting the book
    j finished_add_book_algorithm
    
    copy_author_24_bytes:
    # Now if we are here then we only have to copy 24 bytes from the author because
    # author is more than 24 characters
    # $a0 -> The place where we are copying it to
    # $a1 -> The String that we are copying from
    # $a2 -> The number of bytes that we have to copy which is 24
    
    # Title starts at the 39($s4), so we have to add it before we can pass into $a0
    addi $a0, $s4, 39
    move $a1, $s3 # $a1 is just the author
    li $a2, 24 # We are copying 24 bytes
    
    # Calling memcpy
    jal memcpy 
    
    # Now we have to null terminate the character at index 24
    addi $t0, $s4, 63 # Adding 63 will bring us to the last character in title of the book array
    sb $0, 0($t0) # Then we just have to put a null terminator there
    
    # Furthermore we have to reset the sales to 0
    addi $t0, $s4, 64 # This is the starting address of that word
    sw $0, 0($t0) # We put 0 in that entire word

    # And we also have to increment the HashTable's size because we have put one books in
    # the size is located at 4($s0) of the HashTable, we load it in first
    lw $t0, 4($s0)
    
    # We add one to it
    addi $t0, $t0, 1
    
    # Then we put it back in
    sw $t0, 4($s0)

    # We load the index that we found it from $s5
    move $v0, $s5
    
    # Load the number of books looked which is just
    li $v1, 1
    
    # And we are done with this case we can just finish algorithm
    j finished_add_book_algorithm


    add_book_require_probing:
    # If the expected place already has a book then we have to do linear probing in order to find
    # a place to put the insert the book. Oh wish me good luck
    
    # We need a counter to keep track of which index we are looking at 
    # which is already in $s5, but because $s5 is already occupied we are going to
    # be looking at the book immediately right after it, so we will be adding 1 to $s5
    addi $s5, $s5, 1
    
    # Then we also need a counter to keep track of the number of books we have already looked at
    # which starts with 1 and we will be putting it inside $s4
    li $s4, 1
    
    # Now we have to put this through a for loop in order to find the approriate place to put
    # this book and we are guaranteed to find one
    for_loop_add_book_probing:
    	# Our stopping condition will simply just be whenever
    	# we find a empty or deleted entry in our HashTable
    	# If we ever find a book entry then we will skip into the next iteration
    	# Let's load in the book that we are looking at first
    	# 12($base_address) + index * element_size
    	# Let's get 12($base_address) and put it into $t0
    	addi $t0, $s0, 12 # This gets us to the starting address of the array
	
        # We have to get the remainder by dividing $s5 with the capacity in order to handle
        # the loop arounds
        # Let's get the capacity first and put it into $t2 which is located at 0($s0)
        lw $t2, 0($s0) # $t2 have the capacity
        
        # Then we haver to do the division $s5 / $t2 in order to get the actual index
        div $s5, $t2
        
        # We move the index into $t3
        mfhi $t3
        
        li $t7, 68 # 68 for multiplying with index
        
        # We multiply the index with 68 to get our offset
        mul $t1, $t7, $t3
        
        # Then we add the offset to $t0 to get our effective address for that book we are looking at
        add $t0, $t0, $t1
        
        # Now we load in the first byte to help us check whether or not we can put a book
        # in this place or not
        lbu $t1, 0($t0)
        
        # Now if the first byte is -1 then we know for sure it is a deleted entry and we can exit the
        # loop and put the book there
        li $t7, 0xFF
        beq $t1, $t7, place_book_entry_in_delete_or_empty
        
        # We also need to check if it is empty
        beq $t1, $0, place_book_entry_in_delete_or_empty
        
        # However, if we are here that means the book is already occupied
        # no need to do more work just move and check the next book
        
        next_iteration_add_book_probing:
        # If we are here then it is because we encountered a book already occupying this space
        # so we have to look at the next index
        # We have to increment the index counter
        addi $s5, $s5, 1
        
        # We have to increment the number of books we examine counter
        addi $s4, $s4, 1
        
        # Then we can jump back up the loop
        j for_loop_add_book_probing
    
    
    place_book_entry_in_delete_or_empty:
    # If we are here then that means we just came out of the for loop
    # finding a place to put the books to, we have to add one more value to
    # $s4, because it didn't account for the one that we came out with
    addi $s4, $s4, 1
    
    # Now in $t0 we have the effective address of where we have to put our
    # books in. We have to again break it into several difference cases 
    # We will store $t0 into $s6 so the address of where we are putting our book
    # can be preserved across function calls
    move $s6, $t0
    
    # First things first we will copy the in the ISBN into $s6, keep in mind that it is 14 bytes and not 13 bytes
    # $a0 -> The place that we are storing the ISBN
    # $a1 -> The place that we are copying the ISBN from which is just $s1
    # $a2 -> How many bytes we are copying, which is 14
    move $a0, $s6
    move $a1, $s1
    li $a2, 14
    
    # Then we call the actual function to copy it
    jal memcpy
    
    # Now after the memcpy call, the ISBN is copied now we have to handle the title and the author
    # We will do it through a similar procedure we have done in the beginning
    # Let's handle copying the book's title first
    # We need the length of the title first call strlength to help us do that
    move $a0, $s2
    
    # Calling the function 
    jal strlength
    
    # In $v0 we have the length of the title we will compare with 24 to break into
    # two separate cases
    li $t7, 24
    
    # We take the branch if the length of the title is greater than 24
    # which means we will just copy only 24 bytes 
    bgt $v0, $t7, copy_title_24_bytes_probing
    
    # If we didn't take the branch that means the title is less than or equal to 24 character
    # hence we have to do the paddings here. We will clean the 25 bytes first
    # and then just copy length title there
    # $t0 will be the number of bytes we have cleaned so far
    li $t0, 0
    
    # We have 25 bytes hence 25 is our stopping condition
    li $t1, 25
    
    # The address we do the cleaning is from 14($s6), let's store it into $t2
    addi $t2, $s6, 14 # This gets us to the title
    
    # Now a for loop that going through 25 times
    for_loop_to_null_terminate_title_probing:
        # Let's do our stopping condition
        # when our counter is greater than or equal to 25
        bge $t0, $t1, finished_null_terminating_title_probing
        
        # Now we null terminate the byte here
        sb $0, 0($t2)
        
        # Then we do our incrementation
        addi $t0, $t0, 1
        
        # Increment our address as well
        addi $t2, $t2, 1
        
        j for_loop_to_null_terminate_title_probing
        
    finished_null_terminating_title_probing:
    # Now if we are here then that means we are finished null terminating the title
    # we can actually copy the title into it now
    # $a0 -> The place where we are storing the title to 14($s6)
    # $a1 -> The title we are copying from
    # $a2 -> The number of bytes we are copying which is just the length
    addi $a0, $s6, 14
    move $a1, $s2 # The title we are copying from
    move $a2, $v0 # Number of bytes we are copying, just the length
    
    # We have to call the function to copy the memory
    jal memcpy
    
    # Now after we handle the title we have to handle the author
    j handle_copying_author_probing    
    
    copy_title_24_bytes_probing:
    # If we are here then we are only copying 24 bytes and 25th byte is \0
    # $a0 -> The place we are copying the title to
    # $a1 -> The title we are copying from
    # $a2 -> The number of bytes we are copyiong
    addi $a0, $s6, 14
    move $a1, $s2 # The title we are copying from
    li $a2, 24
    
    # Then we call memcpy function
    jal memcpy
        
    # Now we copied the 24 bytes from title we have to set the 25th byte to \0
    addi $t0, $s6, 38 # Adding 38 will bring us to the last character in title of the book array
    sb $0, 0($t0) # Then we just have to put a null terminator there
    
    
    handle_copying_author_probing:
    # After we finished copying the title we have to copy the author
    # same procedure get the length of the author first
    move $a0, $s3
    
    # Calling strlength
    jal strlength
    
    li $t7, 24
    
    # If the length is greater than 24 then we copy 24 bytes and null terminate the last one
    bgt $v0, $t7, copy_author_24_bytes_probing    
    
    # But if we are here then that means the author is less than or equal to 24 characters
    # so we have to do the freaking padding
    # Counter for the number of bytes we cleaned
    li $t0, 0
    
    # We have 25 bytes hence 25 is our stopping condition
    li $t1, 25
    
    # The address we do the cleaning is from 39($s6), let's store it into $t2
    addi $t2, $s6, 39 # This gets us to the author
    
    # Now a for loop that going through 25 times
    for_loop_to_null_terminate_author_probing:
        # Let's do our stopping condition
        # when our counter is greater than or equal to 25
        bge $t0, $t1, finished_null_terminating_author_probing
        
        # Now we null terminate the byte here
        sb $0, 0($t2)
        
        # Then we do our incrementation
        addi $t0, $t0, 1
        
        # Increment our address as well
        addi $t2, $t2, 1
        
        j for_loop_to_null_terminate_author_probing
        
    finished_null_terminating_author_probing:
    # Now if we are here then that means we are finished null terminating the author
    # we can actually copy the author into it now
    # $a0 -> The place where we are storing the author to 39($s6)
    # $a1 -> The author we are copying from
    # $a2 -> The number of bytes we are copying which is just the length
    addi $a0, $s6, 39
    move $a1, $s3 # The author we are copying from
    move $a2, $v0 # Number of bytes we are copying, just the length
    
    # Now we call memcpy
    jal memcpy
    
    # After calling we have to reset the number of sales
    addi $t0, $s6, 64 # This is the starting address of that word number of sales
    sw $0, 0($t0) # We put 0 in that entire word

    # And we also have to increment the HashTable's size because we have put one books in
    # the size is located at 4($s0) of the HashTable, we load it in first
    lw $t0, 4($s0)
    
    # We add one to it
    addi $t0, $t0, 1
    
    # Then we put it back in
    sw $t0, 4($s0)

    # We get the capacity first
    lw $t0, 0($s0)
    
    # Divide by $s5
    div $s5, $t0

    # $v0 output is mfhi
    mfhi $v0
        
    # $v1 is the number of books we looked which is just $s4
    move $v1, $s4
    
    j finished_add_book_algorithm
    
    copy_author_24_bytes_probing:
    # If we are here then we are only copying 24 bytes and 25th byte is \0
    # $a0 -> The place we are copying the author to
    # $a1 -> The author we are copying from
    # $a2 -> The number of bytes we are copying
    addi $a0, $s6, 39
    move $a1, $s3 # The author we are copying from
    li $a2, 24    
    
    # Then we call memcpy function
    jal memcpy   
    
    # Now we have to null terminate the character at index 24
    addi $t0, $s6, 63 # Adding 63 will bring us to the last character in title of the book array
    sb $0, 0($t0) # Then we just have to put a null terminator there
    
    # After we fix null terminator we also have to reset the number of sales
    addi $t0, $s6, 64 # This is the starting address of that word number of sales
    sw $0, 0($t0) # We put 0 in that entire word

    # And we also have to increment the HashTable's size because we have put one books in
    # the size is located at 4($s0) of the HashTable, we load it in first
    lw $t0, 4($s0)
    
    # We add one to it
    addi $t0, $t0, 1
    
    # Then we put it back in
    sw $t0, 4($s0)

    # We get the capacity first
    lw $t0, 0($s0)
    
    # Divide by $s5
    div $s5, $t0

    # $v0 output is mfhi
    mfhi $v0
        
    # $v1 is the number of books we looked which is just $s4
    move $v1, $s4
    
    # Then we are done with the algorithm
    
    finished_add_book_algorithm:
    # If we are here then we are finish with the function and we can restore all the $s registers we have used
    lw $s0, 0($sp) # Restoring the $s0 register
    lw $s1, 4($sp) # Restoring the $s1 register
    lw $s2, 8($sp) # Restoring the $s2 register
    lw $s3, 12($sp) # Restoring the $s3 register
    lw $s4, 16($sp) # Restoring the $s4 register
    lw $s5, 20($sp) # Restoring the $s5 register
    lw $s6, 24($sp) # Restoring the $s6 register
    
    # We also need to restore the return address
    lw $ra, 28($sp)
    
    # Then we can finally deallocate the memory we have used
    addi $sp, $sp, 32 # Deallocating the 32 bytes we have used

    # And we can return to the caller
    jr $ra

delete_book:
    # This function basically takes in an ISBN and tries to delete it from the given HashTable
    # by filling the book struct with entirely -1 0XFF. It will only attempt to delete if
    # it found the book by calling get_book which returns the index that book is found at
    
    # $a0 -> The valid starting address of the HashTable
    # $a1 -> The 13 character null terminating ISBN String
    # Output -> $v0, returns the index of where the book is deleted, if the book doesn't exist
    # it will just return -1
    
    # Since we are going to be calling functions we have to save the two given arguments in the
    # $s register and hence we have to allocate space for it on the run time stack to save it
    # 2 arguments, 8 bytes and a return address total of 12 bytes
    addi $sp, $sp, -12 # Allocating 12 bytes on the run time stack
    
    # Saving the $s registers before we can use them
    sw $s0, 0($sp) # Saving the $s0 register
    sw $s1, 4($sp) # Saving the $s1 register
    
    # Saving the return address
    sw $ra, 8($sp)
    
    # Now we can use the $s registers to save the arguments
    move $s0, $a0 # $s0 have the HashTable's address
    move $s1, $a1 # $s1 have the ISBN 14 bytes
    
    # The first step is to obviously call get_book on that book to see if it exist
    # if it doesn't exist then we return -1 and done with this function
    # $a0 -> The HashTable we are looking the book from
    # $a1 -> The ISBN we are looking for
    move $a0, $s0 # The HashTable
    move $a1, $s1 # The ISBN
    
    # Then we can call the function
    jal get_book
    
    # Now in $v0 we have either the index that the book is in or -1 if that book doesn't exist
    li $t7, -1 # Load in -1 for comparsion
    
    # We take the branch if the index is equal to -1 which means the book doesn't exist in the HashTable
    beq $v0, $t7, delete_book_doesnt_exist
    
    # However if the book does exist then we have to do work to fill the entire struct with -1
    # all 68 bytes of it
    # 12($base_address) + index * element_size, is how we get to the effective address of a given index book
    li $t7, 68 # Load in 68 for multiplication
    
    # We add 12 to the HashTable address to get us to the object array and we will store that into $t0
    addi $t0, $s0, 12
    
    # Then we just have to simply multiply the index by 68, and we will store that into $t1
    mul $t1, $v0, $t7 # Index * 68 to get us the offset
    
    # Then we will add the offset with the array address
    add $t0, $t0, $t1 # Now we have the effective address of the book struct for which we need to delete
    
    # Then we just have to loop a for loop to do the deletion, it will loop 68 times to do in order to
    # delete the 68 bytes to all -1
    # We will have a simple counter to count the number of bytes we have deleted so far
    li $t1, 0
    
    # Then we have our stopping condition which is just 68
    li $t2, 68
    
    # We put the byte we need to replace which is -1 into $t7
    li $t7, -1
    
    # Then this will be our for_loop that does the delete for us
    for_loop_to_delete_book_struct:
        # We do our stopping condition first which is whenever
        # $t1 is greater than or equalto 68, that means we have finished deleting
        # the 68 bytes already
        bge $t1, $t2, finished_for_loop_deleting_book
    
        # But if we are here then that means we haven't finish deleting the book yet hence we have to
        # actually delete the byte by storing the byte there
        sb $t7, 0($t0)
        
        # After resetting the byte to -1 we have to do incrementation
        # We increase our counter
        addi $t1, $t1, 1
        
        # We also increase the address to the next byte that we have to delete
        addi $t0, $t0, 1
        
        # Then just jump back up the loop
        j for_loop_to_delete_book_struct
    
    finished_for_loop_deleting_book:
    # If we are here then we have finished deleting the book
    # the return value is already the index of the book we deleted
    # hence we can just return without doing anything else
    j finished_delete_book_algorithm
    
    delete_book_doesnt_exist:
    # If we are here then that means the book we try to delete doesn't exist in the 
    # HashTable hence we can just return -1 as our output value and done with the function
    li $v0, -1
    
    # We can just follow the next line logically to exit 
    
    finished_delete_book_algorithm:
    # If we are here then we are done with the algorithm and we have to
    # start restoring the $s registers that we have used
    lw $s0, 0($sp) # Restoring the $s0 register
    lw $s1, 4($sp) # Restoring the $s1 register
    
    # We also have to restore the return address or else delete_book won't know where to return
    lw $ra, 8($sp) # Restoring the return address    
    
    # Then we have to deallocate the memory we have used
    addi $sp, $sp, 12 # Deallocating the 12 bytes of memory we have used
    
    # Now we can just used to the caller
    jr $ra

hash_booksale:
    # This fuynction basically takes in a HashTable and an ISBN null terminated String, and a customer_id to
    # compute the Hash Function. The Hash Function is just summing up the 13 ascii values and
    # sum up the digit values in customer_id and mod it by the capacity of the sales function by the grand total
    # grand_total = sum_of_ascii + sum_of_digits
    
    # $a0 -> The starting address of the HashTable
    # $a1 -> The 13 character null terminated String that represent ISBN
    # $a2 -> An integer that provide the customer ID
    # Output -> $v0, the hashed value
    
    # So let's just sum up the ascii value first and we will put the sum into $t0
    li $t0, 0
    
    # This for loop will help me sum up the ISBN ascii value
    for_loop_to_sum_isbn_booksale:
        # So let's do our stopping condition first which is whenver
        # the character we read is a null terminator which means we have already
        # finished summing up all the 13 characters alredy
        lbu $t1, 0($a1) # Load in the ascii character from ISBN
        
        # If we take this branch then that means we have finished summing up all the ISBN value    
        beq $t1, $0, finished_for_loop_to_sum_isbn
        
        # If we are here then we have to actually sum the ascii value up
        add $t0, $t0, $t1
        
        # Then we increment the ISBN address to get the next character
        addi $a1, $a1, 1
        
        # And we jump back up the loop
        j for_loop_to_sum_isbn_booksale
    
    finished_for_loop_to_sum_isbn:
    # Now if we are here then that means $t0 have the sum of all 13 ascii values
    # next we have to sum the digits from the customer_id which we will be doing through
    # modding by 10, Let's put 10 into $t7 for our division operation
    li $t7, 10
    
    # We will be putting the sum of digits into $t1
    li $t1, 0
    
    # This for loop will help me us sum up the customer's id
    for_loop_to_sum_customer_id:
        # First we will check if the customer_id $a2 is 0 yet, if it is 0
        # then we exit because we have sum up the digits already
        beq $a2, $0, finished_summing_customer_id
        
        # If there is still quotient remaining then we will do division
        # and replace the customer id with the quotient and we sum the remainder
        div $a2, $t7 # We divide the customer id by 10 which get us the last digit
        
        # Then we load the remainder into $t2
        mfhi $t2 
        
        # We load the quotient back into $a2
        mflo $a2
        
        # Then we sum the last digit with the accumulator
        add $t1, $t1, $t2
        
        # Then we jump back up the loop
        j for_loop_to_sum_customer_id
    
    finished_summing_customer_id:
    # Then if we are here then $t0 have the sum of ascii, $t1 have the sum of digits
    # we just add them together and divide by the capacity
    add $t0, $t0, $t1 # Adding the ascii value with the digit sum into $t0
    
    # Then we need to load the capacity which is located at 0($a0)
    lw $t1, 0($a0)
    
    # Then we do the division
    div $t0, $t1
    
    # And we put the remainder into our output value
    mfhi $v0        
    
    # And that's it we can just return to the caller
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
