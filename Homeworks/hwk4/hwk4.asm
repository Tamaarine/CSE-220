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

determine_leap_year:
    # This is just a helper function for is_leap_year to determine if the given
    # integer that represent a year is a leap year
    
    # $a0 -> An integer that represent a year
    # Output -> $v0, 1 if the year is a leap year, 0 if it is not 
    
    # 1st in checking
    # If the year is evenly divisible by 4, then we go to step 2 
    # if it is not divisible by 4 then it is not a leap year
    first_step_leap_year_checking:
    # We will do the divisible here first
    li $t7, 4 # Load 4 for division
    
    # We do the division
    div $a0, $t7
    
    # We only have to check the remainder
    mfhi $t0
    
    # If the year is divisible by 4 then we go to step 2
    beq $t0, $0, second_step_leap_year_checking
    
    # If it is not divisible by 4 then it is definitely not a leap year
    j not_leap_year_helper
    
    second_step_leap_year_checking:
    # If the year here is also divisble by 100 then we go to step 3
    # if it is not divislbe by 100 then it is a leap year
    li $t7, 100
    
    # We do the division
    div $a0, $t7
    
    # We just have to check the remainder
    mfhi $t0
    
    # If the year is divisible by 100 then we go to step 3
    beq $t0, $0, third_step_leap_year_checking
    
    # If it is not divislbe by 100 then we know it is a leap year
    j is_leap_year_helper
    
    third_step_leap_year_checking:
    # If the year here is also disvible by 400 then it is a leap year
    # otherwise it is not a leap year
    li $t7, 400
    
    # Then we do the division here
    div $a0, $t7
    
    # Again only need remainder
    mfhi $t0
    
    # If the year is divislbe by 400 then it is also a leap year
    # otherwise it is not a leap year
    beq $t0, $0, is_leap_year_helper
    
    # If it is not divisible by 400 then it is not a leap year
    j not_leap_year_helper
    
    is_leap_year_helper:
    # If it is a leap year then we just have to return 1
    li $v0, 1
    
    # Then just jump to finish function
    j finished_determine_leap_year
    
    not_leap_year_helper:
    # If it is not a leap year then we just have to return 0
    li $v0, 0
    
    # Then we can just follow through to return
    
    finished_determine_leap_year:
    # We have nothing to deallocate we can just return to caller    
    jr $ra 

is_leap_year:
    # This function determines whether or not the given year is a leap year or
    # and if it is not a leap year then it will determine the number of years that is
    # required before the next leap year
    
    # $a0 -> An integer that represent the year
    # Output -> Returns a 0 if the year is before < 1582, and returns a 1 if the given year
    # is a leap year. And if the year is not a leap year then it returns the negated
    # until the next leap year
    
    # Since we will be calling functions we have to save the arguments
    # We just need 8 bytes in total so far
    # 4 more byte for another register
    addi $sp, $sp, -12 # Allocating 12 bytes of memory on the run time stack
    
    # Then we can save the $s registers
    sw $s0, 0($sp) # Saving the $s0 register
    sw $s1, 4($sp) # Saving the $s1 register
    
    # Saving the return address
    sw $ra, 8($sp)
    
    # Then we can save the arguments on the $s register
    move $s0, $a0 # $s0 have the integer that represent the yeare
    
    # First things first we have to check if the given year is before 1582 or not
    # if it is before 1582 < then we just return 0
    li $t7, 1582
    
    # We take this branch if the given year is less than 1582
    blt $s0, $t7, less_than_1582
    
    # Now we have to call determine leap_year to see if the
    # given year is a leap year or not
    # $a0 -> The year we want to determine if it is a leap year or not
    move $a0, $s0
    
    # Then we can call the function
    jal determine_leap_year
    
    # In $v0 we have return value of whether or not the given year is a leap
    # year or not. 0 if it isn't and 1 if it is 
    # If the return value in $v0 is a 0 then that means the year given
    # is not a leap year hence we have to use a for loop to find the next
    # leap year and subtract with the current year to give the difference
    beq $v0, $0, not_leap_year_determine_difference
    
    # However if we are here then that means the given year is indeed
    # a leap year and we can just return a 1 as our output value
    li $v0, 1
    
    # Then we are essentially done with this algorithm and just have to finish
    j finished_is_leap_year_algorithm
    
    
    not_leap_year_determine_difference:
    # If we are here then that means the given year is not a leap year hence we have
    # to determine the next leap year and subtract with the given year
    # to give back a difference
    
    # To do this we will be looping through a set of years starting at
    # given year + 1, and we will be keeping track of that year in $s1
    addi $s1, $s0, 1 # The given year + 1 is where we will start our search for the next leap year
    
    # This for loop will help me find the next leap year
    for_loop_to_find_next_leap_year:
        # Our stopping condition will be whenever we find the next leap year
        # hence we have to call the determine_leap_year function right away
        # $a0 -> The year we want to determine if it is a leap year, which is just $s1
        move $a0, $s1
        
        # Then we call the function
        jal determine_leap_year
        
        # Now in $v0 we have whether or not it is a leap year
        # we will break if it is a leap year
        li $t7, 1
        
        # If the search year is indeed a leap year then we stop
        beq $v0, $t7, finished_finding_next_leap_year
        
        # However, if the search year is not a leap year then we will continue the search and
        # go onto the next year, by adding 1 to it
        addi $s1, $s1, 1
        
        # Then jump back up the loop
        j for_loop_to_find_next_leap_year
    
    finished_finding_next_leap_year:
    # Now if we are here then in $s1 have the next leap year 
    # we just have to subtract $s0 - $s1 as our return value because
    # the instruction want us to return the negated differences
    sub $v0, $s0, $s1 # given year - the next leap year
    
    # Then we are done with the function and we can be finished
    j finished_is_leap_year_algorithm    
    
    
    less_than_1582:
    # If the given year is less than 1582 then we just return 0
    li $v0, 0
    
    # And follow logically to finish up the algorithm
    
    finished_is_leap_year_algorithm:
    # If we are here then we are done with the algorithm
    # we can start restoring the registers and deallocate the memory
    lw $s0, 0($sp) # Restoring the $s0 register
    lw $s1, 4($sp) # Restoring the $s1 register
    
    # We also need to restore the return address
    lw $ra, 8($sp) 
    
    # Then we can just deallocate the memory that we have used
    addi $sp, $sp, 12 # Deallocating the 12 byte of memory we have used
    
    # And we can return to the caller!
    jr $ra

date_to_days_helper:
    # This function takes in a date and count the number of days that have passed since
    # 1600/1/1
    
    # $a0 -> The starting address of the date we want to count the days to
    # Output -> The number of days elapsed since 1600/1/1
    
    # We need to save the argument in $s register because we will be making function calls
    # 1 argument, 4 bytes, 3 more register 12 bytes and a return address total of 20 bytes
    addi $sp, $sp, -20 # Allocating 20 bytes of memory in the run time stack
    
    # Then we save the $s registers
    sw $s0, 0($sp) # Saving the $s0 register
    sw $s1, 4($sp) # Saving the $s1 reigser
    sw $s2, 8($sp) # Saving the $s2 register
    sw $s3, 12($sp) # Saving the $s3 register
    
    # Saving the return address
    sw $ra, 16($sp)
    
    # Then we save the argument that is given
    move $s0, $a0 # $s0 will be the starting address of the date we are figureing out the days for
    
    
    # The first step is to just grab the year first then we will worry about
    # the months and the days later. Step by step bruh
    # The years comes from 0($a0), 1,2,and 3
    
    # We will put it into register $t0,1,2 and 3 respective of each ascii digit
    lbu $t0, 0($s0) # Thousand place
    lbu $t1, 1($s0) # Hundred place
    lbu $t2, 2($s0) # Tens place
    lbu $t3, 3($s0) # Ones place
    
    # Next we subtract everything by 48 to get the actual integer value
    addi $t0, $t0, -48
    addi $t1, $t1, -48
    addi $t2, $t2, -48
    addi $t3, $t3, -48
     
    # We will put the year component into $t0
    # First we need to multiply thousand by 1000
    li $t7, 1000
    mul $t0, $t0, $t7 # Multiply thousands place by 1000
    
    # Then multiply hundred by 100
    li $t7, 100
    mul $t1, $t1, $t7
    
    # Tens by 10
    li $t7, 10
    mul $t2, $t2, $t7
    
    # Ones we don't have to, and we just sum them all up
    add $t0, $t0, $t1 # Thousand + hundred
    add $t0, $t0, $t2 # Thousand + hundred + tens
    add $t0, $t0, $t3 # Thousand + hundred + tens + ones
    
    # We move the year we parsed into $s2, this is our stopping condition
    # for the for loop
    move $s2, $t0
    
    # We will store the counter that starts at 1600 into $s1
    li $s1, 1600
    
    # Then we put the days counter into $s3 to count the total numbner of days that have passed
    li $s3, 0
    
    # Next we will be using a for loop to loop from 1600 to the current year while calling
    # is_leap_year to sum up all the days of the years that is already passed
    # We will need a counter which is the year 1600, a stopping condition which is the year we just got
    # they need to be in $s register because we will be calling is_leap_year
    for_loop_to_find_total_of_days_passed_since_year:
        # Let's just do our stopping condition first
        # which is whenever our counter is greater than or equal to the stopping condition
        # that means we are done summing all the years that have passed so far
        bge $s1, $s2, finished_counting_total_of_days_passed_since_year
    
        # Now if we are here then that means we haven't finished summing 
        # the number of days in a year yet, so we have to check if it is a leap year first
        # if it is a leap year then we add 366 to the day counter $s3, if it is not then we just add 365
        # $a0 -> The integer year that we want to determine whether it is a year or not which is $s1 our counter
        move $a0, $s1
        
        # Now we can call is_leap_year
        jal is_leap_year
        
        # In $v0 we have 1 if the given year is a leap year, if it is not then it is some negative value
        li $t7, 1
        
        # We take this branch if the return value is 1 because it is a leap year
        beq $v0, $t7, is_leap_year_add_366
        
        # If we don't take the previous branch then it is not a leap year
        # hence we just have to add 365 to the day counter
        addi $s3, $s3, 365
                
        # And we jump to the next iteration
        j next_for_loop_total_days_passed_iteration
        
        is_leap_year_add_366:
        # But if it here then we add 366 days instead
        addi $s3, $s3, 366
        
        # And follow logically to the next iteration
        
        next_for_loop_total_days_passed_iteration:
        # Here we increment our year counter
        addi $s1, $s1, 1
        
        # Then jump back up the loop
        j for_loop_to_find_total_of_days_passed_since_year
        
    finished_counting_total_of_days_passed_since_year:
    # Now if we are here then we have the number of days passed since that year to the given year
    # without counting the number of days passed in the current year in $s3
    
    # Good we have the correct number of days that have passed since 1600 to the current year in $s3
    # $s1 is basically freed up. $s0 is still our starting address of date string
    # $s2 is our current year 
    
    # Next we have to first know if the current year is a leap year or not
    # which will determine whether we add 28 or 29 when we are summing the months that has passed
    # $a0 -> the year we are trying to determine if it is a leap year or not
    move $a0, $s2 
    
    # We call the function
    jal is_leap_year
    
    # Now in $v0 we have whether or not the current year is a leap year
    # 1 if it is and other value if it is not
    li $t7, 1
    
    # If the current year is a leap year then we allocate 29 in the february place
    beq $v0, $t7, is_leap_year_array
    
    # If we don't take the preivous branch then we allocate 28 in the february placc
    j is_not_leap_year_array
    
    is_leap_year_array:
    # If it is a leap year then we allocate the array with 29 in february place
    # We are going to allocate 12 byte of memory on the run time stack
    # where each byte represent the number of days in the respective month
    # 0 = january, 1 = february, and so on
    
    # And we put 29 into february instead of 28
    addi $sp, $sp, -12 # Allocating 12 more bytes of additional space on the run time stack
    
    # Values to grab from
    li $t0, 30
    li $t1, 31
    li $t2, 29
    
    sb $t1, 0($sp) # January
    sb $t2, 1($sp) # February, 29 days not 28
    sb $t1, 2($sp) # March
    sb $t0, 3($sp) # April
    sb $t1, 4($sp) # May
    sb $t0, 5($sp) # June
    sb $t1, 6($sp) # July
    sb $t1, 7($sp) # August
    sb $t0, 8($sp) # September
    sb $t1, 9($sp) # October
    sb $t0, 10($sp) # November
    sb $t1, 11($sp) # December
    
    # After we allocate the bytes for the months we will jump to sum up all the months that have passed
    j sum_up_months
    
    is_not_leap_year_array:
    # If it is not a leap year then we allocate the array with 28 in february place
    # We are going to allocate 12 byte of memory on the run time stack
    # where each byte represent the number of days in the respective month
    # 0 = january, 1 = february, and so on
    
    addi $sp, $sp, -12 # Allocating 12 more bytes of additional space on the run time stack
    
    # Values to grab from
    li $t0, 30
    li $t1, 31
    li $t2, 28
    
    sb $t1, 0($sp) # January
    sb $t2, 1($sp) # February, 29 days not 28
    sb $t1, 2($sp) # March
    sb $t0, 3($sp) # April
    sb $t1, 4($sp) # May
    sb $t0, 5($sp) # June
    sb $t1, 6($sp) # July
    sb $t1, 7($sp) # August
    sb $t0, 8($sp) # September
    sb $t1, 9($sp) # October
    sb $t0, 10($sp) # November
    sb $t1, 11($sp) # December
    
    # We just follow logically to sum up the months that have passed
    sum_up_months:
    # If we are here then now we have to grab the months component from the given date
    # in order to sum it up
    lbu $t0, 5($s0) # Grab the tens place for months
    lbu $t1, 6($s0) # Grab the ones place for months
    
    # Again we subtract 48 from the ascii value to get actual integer value
    addi $t0, $t0, -48
    addi $t1, $t1, -48
    
    # Then we just have to multiply things out to get the actual month value
    li $t7, 10
    
    # We multiply the tens place by 10
    mul $t0, $t0, $t7
    
    # Then we just have to add for the ones place
    add $t0, $t0, $t1
    
    # Let's put a counter here for the months we have summed
    # starting with 1 in $t1, to represent january
    # The stopping condition is actually the month we grabbed from the date
    li $t1, 1
    
    # If our month is 2 (february), we just sum only january's 31 days and stop at 2
    # if it is 5(may), we sum 1,2,3,4, but not may because may is not done yet
    
    # Now in $t0 we have the months of the current date, we are going to do another
    # for loop to sum up all the months that have passed since 1/1
    for_loop_to_sum_up_months_passed:
        # So let's just do our stopping condition here
        bge $t1, $t0, finished_sum_up_months_passed
    
        # If we are here then that means we haven't finished summing up the months yet
        # so we have our index $t1, which will help us get the index in the run time stack
        # if it is 1, then we subtract 1 to get 0 which represent january's days
        # Let's subtract 1 from our counter and put it into $t2
        addi $t2, $t1, -1
        
        # Then this is our offset to the stack pointer we sum it with $sp to get our effective
        # address for that month's byte
        add $t3, $t2, $sp
        
        # We load back in the byte into $t4 using $t3 as effective address
        lb $t4, 0($t3)
        
        # Then we just sum it with $s3 our day counter
        add $s3, $s3, $t4
        
        # Then we are done with this iteration, we increment our counter
        addi $t1, $t1, 1
    
        # Then we jump back up the loop
        j for_loop_to_sum_up_months_passed
    
    finished_sum_up_months_passed:
    # Now don't forget to deallocate the 12 byte we have used else it will be a big trouble
    addi $sp, $sp, 12
    
    # Now if we are here $s3 have the years accounted for and all the months accounted for as well
    # Okay final step is just to handle the days
    # We will do the same let's just load in the bytes first from the String
    lbu $t0, 8($s0) # Load in the tens place
    lbu $t1, 9($s0) # Load in the ones place
    
    # We subtract by 48 again
    addi $t0, $t0, -48
    addi $t1, $t1, -49
    
    # Then we multiply the tens place by 10
    li $t7, 10
    
    # Multiply tens place by 10
    mul $t0, $t0, $t7
    
    # Then we just have to sum tens place with the ones place
    add $t0, $t0, $t1
    
    # Then finally add this to the day counter and we are finished
    add $s3, $s3, $t0
    
    # We put this into the return value and we are done
    move $v0, $s3
    
    
    # After finishing the algorithm we have to restore all the $s registers we have used
    lw $s0, 0($sp) # Restoring the $s0 register
    lw $s1, 4($sp) # Restoring the $s1 reigser
    lw $s2, 8($sp) # Restoring the $s2 register
    lw $s3, 12($sp) # Restoring the $s3 register
    
    # Restoring the return address
    lw $ra, 16($sp)
    
    # We have to deallocate the memory we have used
    addi $sp, $sp, 20 # Deallocating the 20 bytes of memorry we have used
    
    # Then we can just jump back to the caller
    jr $ra

datestring_to_num_days:
    # This function takes in a start and end date and we have to determine the number of days
    # have elapsed between these two dates
    
    # $a0 -> Start date in YYYY-MM-DD format
    # $a1 -> End date in YYYY-MM-DD format
    # Output -> $v0, the number of days elapsed from start to end, including end but not end
    # return -1 if end_date is before start_date
    
    # Because we are going to be call we have to save the two arugments
    # plus two more arguments to store the return days converted and return address
    # Hence total of 20 bytes on the run time stack
    addi $sp, $sp, -20
    
    # Then we save the $s register
    sw $s0, 0($sp) # Saving the $s0 register
    sw $s1, 4($sp) # Saving the $s1 register
    sw $s2, 8($sp) # Saving the $s2 register
    sw $s3, 12($sp) # Saving the $s3 register

    # Then we save the return address
    sw $ra, 16($sp)
    
    # Now we can save the arguments
    move $s0, $a0 # $s0 will be the start date's address
    move $s1, $a1 # $s1 will be the end date's address
    
    # This is the strategy that we are going to do, we are going to call the helper method that basically
    # convert each date to number of days have passed since 1600/1/1 and just subtract them
    # Okay let's convert the start date first
    # $a0 -> the date to convert
    move $a0, $s0 # Convert the start date first
    
    # Calling the function
    jal date_to_days_helper
    
    # Now we have the days converted in $v0 we save that in $s2
    move $s2, $v0
    
    # We call it again but on the end date
    # $a0 -> date to convert
    move $a0, $s1
    
    # Calling the functino
    jal date_to_days_helper
    
    # In $v0 we have the end date converted store that into $s3
    move $s3, $v0
    
    # Now we have to compare if end_start is before start_date, start_date is > end_date
    bgt $s2, $s3, invalid_start_end_date
    
    # However if we are here then that means start_end is before end_date
    # so that means we can just subtract and return the dates elapsed
    # as our output value
    sub $v0, $s3, $s2 # end_date - start_date to get our output value
    
    # And we are done with this algorithm we can just return
    j finished_datestring_to_num_days_algorithm
    
    invalid_start_end_date:
    # If we are here then that means end_date is before start_date hence we just return -1
    li $v0, -1
    
    
    finished_datestring_to_num_days_algorithm:
    # If we are here then we are done with this algorithm
    # hence we can start restoring all the $s registers we used
    lw $s0, 0($sp) # Restoring the $s0 register
    lw $s1, 4($sp) # Restoring the $s1 register
    lw $s2, 8($sp) # Restoring the $s2 register
    lw $s3, 12($sp) # Restoring the $s3 register

    # Then we also restore the return address
    lw $ra, 16($sp)
    
    # And deallocate all the memory we have used
    addi $sp, $sp, 20 # Deallocating the 20 bytes of memory we have used
    
    # And we can jump back to the caller
    jr $ra

sell_book:
    # This function attempts to insert the given book isbn into the sales
    # HashTable which is array of BookSale struct, it also update the number of times_sold
    # in the books HashTable
    
    # $a0 -> HashTable with BookSale struct
    # $a1 -> HashTable with book struct
    # $a2 -> ISBN, the 13 char null terminated String
    # $a3 -> The integer that represent the customer's id
    # 0($sp) -> The 10 character null terminated String that represent a date
    # on or after 1600/1/1
    # 4($sp) -> The integer that represent price for the book
    # Output -> $v0, the index where the book is inserted, -1 if full HashTable, -2 if the ISBN don't exist in books
    # Output -> $v1, the number of books accessed before is inserted, -1 if full HashTable, -2 if the ISBN don't exist in books
    
    # We have a pointer to the stack before we move it so we have access to
    # the argument that is provided to us from the caller
    move $t0, $sp
    
    # Now we are going to be calling alot of functions so we need to save these arguments
    # 6 arguments so 24 bytes, plus 4 more for the return address so total of 28 bytes
    # add another 8 byte for 2 more reigster
    addi $sp, $sp, -36 # Allocating 36 bytes on the run time stack
    
    # Saving the $s registers
    sw $s0, 0($sp) # Saving the $s0 register
    sw $s1, 4($sp) # Saving the $s1 register
    sw $s2, 8($sp) # Saving the $s2 register
    sw $s3, 12($sp) # Saving the $s3 register
    sw $s4, 16($sp) # Saving the $s4 register
    sw $s5, 20($sp) # Saving the $s5 register
    sw $s6, 24($sp) # Saving the $s6 register
    sw $s7, 28($sp) # Saving the $s7 register
    
    
    # Then we also need to save the return address
    sw $ra, 32($sp)
    
    # Now we can save the arugments
    move $s0, $a0 # $s0 have the HashTable BookSale struct
    move $s1, $a1 # $s1 have the HashTable book struct
    move $s2, $a2 # $s2 have the ISBN null terminated String's starting address
    move $s3, $a3 # $s3 have the integer that represent the customer's id
    lw $s4, 0($t0) # $s4 have the starting address that represent the date
    lw $s5 4($t0) # $s5 have the integer that represent the price of the book
    
    # Now we will begin our algorithm
    # First we check if sales HashTable is full, size == capacity, if it is then we just return (-1,-1)
    lw $t0, 0($s0) # Load in the capacity of sales HashTable
    lw $t1, 4($s0) # Loading in the size of sales HashTable
    
    # We take this branch if the sale's HashTable is full
    beq $t0, $t1, full_sales_hashtable
    
    # Now if we are here then that means the HashTable isn't full yet hence we have to check next
    # if the given ISBN is even in the books HashTable, if it don't exist then we return (-2, -2)
    # We can check if the book exist by calling get_book
    # $a0 -> The book HashTable
    # $a1 -> The book ISBN we are looking for
    move $a0, $s1 # The book struct
    move $a1, $s2 # The book we are looking for
    
    # Then we can call the function
    jal get_book
    
    # Now in $v0 we have -1 if the book is not found or
    # other value if the book is indeed found
    li $t7, -1
    
    # We take this branch if the book we are trying to record a sale
    # don't even exist in the books HashTable
    beq $v0, $t7, book_not_found_in_book_hashtable
    
    # However, if we are here then that means the book does indeed exist and the
    # booksale HashTable isn't full yet hence we have to proceed to insert the BookSale
    # struct into its correct place
    
    # We have to find the place where we are putting the struct and we can figure that out
    # by calling hash_booksale(sales, isbn, customer_id)
    # $a0 -> The HashTable that contains sales struct
    # $a1 -> The ISBN
    # $a2 -> Customer's ID
    move $a0, $s0
    move $a1, $s2
    move $a2, $s3
    
    # Then we can call the hash_booksale function
    jal hash_booksale
    
    # We should save that expected location index into $s7 just so that we don't lose it
    move $s7, $v0 
    
    # In $s7 we have where the expected location where we are putting the book in the
    # booksale HashTable. Let the hell begin with insertion and linear probing
    # But the question was nice enough to only have valid book or empty book
    # there is no entry that is deleted hence we only have 1 case for the expected location
    
    # Now let's start, we begin by calculating the effective address of where that book is
    # at that index. The formula will just be 12($base_address) + index * 28 to get the effective address of a sale at the given index
    # We store 12($base_address) into $t0 first
    addi $t0, $s0, 12 # This get us to the array of booksales
    
    # Then we load in 28 for multiplication
    li $t7, 28
    
    # And we multiply the expected location index with 28, we store that into $t1
    mul $t1, $s7, $t7 # index * 28
    
    # And we just have to add it into $t0
    add $t0, $t0, $t1
    
    # We should save the effective address of the expected location in the HashTable
    # into one of the $s registers $s6
    move $s6, $t0 # Storing the effective address of the place where we are putting the sales

    
    # Now in $s6 we have the effective address of the expected location where the booksales struct go
    # we grab the first byte by doing lbu for checking empty or is already booked, we grab the byte
    # and put it into $t1
    lbu $t1, 0($s6)
    
    # Now we check if the byte is 0 then we have an empty expected location which we can just insert the book into
    # easily without any more work. But if the byte is not 0 then we are screwed and we have to do linear probing
    beq $t1, $0, probing_not_needed
    
    # However, if we are here then that means probing to find a place to insert the booksale
    # struct is required
    j insert_booksale_probing_needed
    
    
    probing_not_needed:
    # If we are here then we can just put the booksale struct into the expected location
    # because it is an empty. Keep in mind that $s6 is the effective address of where
    # we are putting the booksale struct
    
    # Sooo first things first, we copy in the 14 bytes of ISBN into the book sale struct
    # $a0 -> The place where we are copying the ISBN to which is just $s6
    # $a1 -> The place where we are copying the ISBN from which is just $s2
    # $a2 -> The number of bytes we are copying which is 14 bytes
    move $a0, $s6
    move $a1, $s2
    li $a2, 14 # 14 bytes of memory we are copying
    
    # And we call the method to copy the ISBN
    jal memcpy
    
    # After copying the 14 bytes of ISBN, we have to add two byte of paddings
    # that have value of 0, and we do it at index 14 and 15
    sb $0, 14($s6) # Store a 0 in the padding
    sb $0, 15($s6) # Store a 0 in the padding
    
    # Next we also need to copy in the 4 byte customer id
    # we will just do that by doing sw at the 16($s6) position
    sw $s3, 16($s6) # Putting the customer id into the proper word position
    
    # Next we have to calculate the number of days elapsed between the given date
    # and 1600/1/1, we can find that by calling the function datestring_to_num_days
    # Okay the most logical way of giving 1600-01-01 into the function parameter is to
    # allocate 10 bytes + 2 byte for null terminating the date on the run time stack and to make it word aligned
    # and pass the run time stack as the argument 
    addi $sp, $sp, -12 # Allocate 12 bytes of memory on the run time stack
    
    # Then here is where we store the ascii value value into each 
    # 1600 = 49 54 48 48
    # -01-01 = 45 48 49 45 48 49
    # Keep in mind to null terminate the last two bit just in case
    li $t0, '1'
    li $t1, '6'
    li $t2, '0'
    li $t3, '-'
    
    sb $t0, 0($sp) # 1
    sb $t1, 1($sp) # 6
    sb $t2, 2($sp) # 0
    sb $t2, 3($sp) # 0
    sb $t3, 4($sp) # -
    sb $t2, 5($sp) # 0
    sb $t0, 6($sp) # 1
    sb $t3, 7($sp) # -
    sb $t2, 8($sp) # 0
    sb $t0, 9($sp) # 1
    sb $0, 10($sp) # Null terminator
    sb $0, 11($sp) # Null terminator
    
    # Then we pass in the stack pointer for datestring_to_num_days
    # $a0 -> Start date just the stack pointer
    # $a1 -> End date
    move $a0, $sp # 1600-01-01
    move $a1, $s4 # The given date
    
    # Then we can call the function 
    jal datestring_to_num_days
    
    # We need to deallocate the 12 btyes we have used
    addi $sp, $sp, 12 # Deallocating the 12 bytes we have temporarily used
    
    # Now in $v0 we have the number of days have elapsed
    # we store that word into 20($s6)
    sw $v0, 20($s6)
    
    # Lastly, we have to store the store_price into 24($s6)
    sw $s5, 24($s6)
    
    # And we have to increment size element in the book struct
    # Now we have to figure out where that ISBN book is in the book struct
    # in order to increment it we can do so that calling get_book again
    # $a0 -> The book struct we are searching the book in
    # $a1 -> The ISBN we are searching for
    move $a0, $s1
    move $a1, $s2
    
    # Then we can call the get_book function
    jal get_book
    
    # Now in $v0 we have the index where the book belongs
    # we have to calculate the effective address of that book in order to increment
    # the number of times that book was sold
    # 12($base_address) + index * 68
    # Let's load 12($base_address) into $t0
    addi $t0, $s1, 12
    
    # Load 68 for multiplication
    li $t7, 68
    
    # Then we multiply index * 68 and put it into $t1
    mul $t1, $v0, $t7
    
    # Then we add the offset to the array address
    add $t0, $t0, $t1
    
    # Now in $t0 we have the effective starting address where the book is
    # we have to grab the times_sold which is at 64($t0)
    lw $t1, 64($t0)
    
    # We increment it by one
    addi $t1, $t1, 1
    
    # And we store it back in the same locaiton
    sw $t1, 64($t0)
    
    # Andddd we are finally freaking done
    # the return value is in $s7 for $v0
    # the return value $v1 is 1
    move $v0, $s7 # The index where the booksale struct is stored
    li $v1, 1 # Number of books accessed before it is place
    
    # Hold up before we call it done we also need to increment the size of the booksales HashTable
    # Let's load in the current size into $t0
    lw $t0, 4($s0)
    
    # We increment it by 1
    addi $t0, $t0, 1
    
    # Then we put that back in
    sw $t0, 4($s0)
    
    # Then we can call it done
    
    
    # And we can return and finished
    j finished_sell_book_algorithm    
    
    
    insert_booksale_probing_needed:
    # If we are here then linear probing is required because there is a book in the expected
    # location already, starting at index $s7 + 1
    # $s0 have the HashTable BookSale struct
    # $s1 have the HashTable book struct
    # $s2 have the ISBN null terminated String's starting address
    # $s3 have the integer that represent the customer's id
    # $s4 have the starting address that represent the date
    # $s5 have the integer that represent the price of the book
    # $s7 have the expected index, but we need to increment by 1 to start after it, because expected location have a book already
    # We can use $s6 for counting the number of books we have looked starting at 1
    li $s6, 1
    
    # We have to increment $s7 by 1 because that is the next index we are looking at
    addi $s7, $s7, 1
    
    # We don't need a stopping condition because we are guaranteed to have a free space to put the book during probing
    # Now let's begin a for loop of doom
    for_loop_for_booksale_probing:
        # Now let's get the index we are checking the place to put the sales in
        # we have to mod $s7 by the capacity in order to find the index we are looking at
        # Let's get the capacity from the struct which is located at 0($s0) and load into $t0
        lw $t0, 0($s0) # Capacity
        
        # Now we have to div the $s7 by $t0
        div $s7, $t0
        
        # Let's get the index by doing mfhi and put into $t0
        mfhi $t0
        
        # In $t0 we have the index where to check if it is available
        # We have to use the formula 12($base_address) + index * 28 to get to that booksale address
        # We will store 12($base_address) into $t1
        addi $t1, $s0, 12
        
        # We load in 68 for multiplication
        li $t7, 28
        
        # Then we multiply the index by 28 and store into $t2
        mul $t2, $t0, $t7
        
        # Now we add together the array address with the offset and put into $t1
        add $t1, $t1, $t2
        
        # Now we have the effective address of that sales struct, we get the first byte
        # if it is empty then we break out, if it is not empty then we have to keep checking
        lbu $t2, 0($t1)
        
        # We take this branch if the first byte is empty meaning that this particular index is good for storing our
        # sales struct 
        beq $t2, $0, found_empty_space_for_booksales_struct
        
        # However if it is not empty then we have to check the next book
        # We increment the $s7 index counter
        addi $s7, $s7, 1
        
        # We also need to increment the total book accessed counter
        addi $s6, $s6, 1
        
        # Then jump back up the loop
        j for_loop_for_booksale_probing
        
    
    found_empty_space_for_booksales_struct:
    # Now in $t0 we have the index where the book is to be placed
    # And in $t1 we have the effective address of where the book needs to go
    # we have to add one more to the access count number because after we exit it didn't count that current book
    addi $s6, $s6, 1
    
    # Now we don't need $s7 counter anymore we will replace it with the index that we have placed the book in
    # which is $t0
    move $s7, $t0
    
    # Okay we have our effective address of where the book needs to go
    # Okay before we free up $s0 register we have to increment the size of HashTable sales
    # Let's load in the current size first
    lw $t0, 4($s0)
    
    # We increment it by 1
    addi $t0, $t0, 1
    
    # Then we put that back where it needs to be
    sw $t0, 4($s0)
    
    # Okay then $s0 is now free up we can use that to store the effective aaddress of where the book need to go
    move $s0, $t1
    
    
    # First step we have to copy over the ISBN
    # $a0 -> The place where we are copying the isbn to
    # $a1 -> The ISBN we are copying from
    # $a2 -> 14 bytes
    move $a0, $s0
    move $a1, $s2
    li $a2, 14
    
    # Now we can call memcpy to copy over
    jal memcpy
    
    # Okay ISBN is copied over we need to provide 2 byte of padding at
    # 14($s0) and 15($s0)
    sb $0, 14($s0)
    sb $0, 15($s0)
    
    # Next we have to store the customer_id at 16($s0)
    sw $s3, 16($s0) # Store the customer id at the proper place
    
    # Okay now we must compute sales date 
    addi $sp, $sp, -12 # Allocate 12 bytes of memory on the run time stack
    
    # Then here is where we store the ascii value value into each 
    # 1600 = 49 54 48 48
    # -01-01 = 45 48 49 45 48 49
    # Keep in mind to null terminate the last two bit just in case
    li $t0, '1'
    li $t1, '6'
    li $t2, '0'
    li $t3, '-'
    
    sb $t0, 0($sp) # 1
    sb $t1, 1($sp) # 6
    sb $t2, 2($sp) # 0
    sb $t2, 3($sp) # 0
    sb $t3, 4($sp) # -
    sb $t2, 5($sp) # 0
    sb $t0, 6($sp) # 1
    sb $t3, 7($sp) # -
    sb $t2, 8($sp) # 0
    sb $t0, 9($sp) # 1
    sb $0, 10($sp) # Null terminator
    sb $0, 11($sp) # Null terminator
    
    # Then we pass in the stack pointer for datestring_to_num_days
    # $a0 -> Start date just the stack pointer
    # $a1 -> End date
    move $a0, $sp # 1600-01-01
    move $a1, $s4 # The given date
    
    # Then we can call the function 
    jal datestring_to_num_days
    
    # We need to deallocate the 12 btyes we have used
    addi $sp, $sp, 12 # Deallocating the 12 bytes we have temporarily used
    
    # In $v0 we have the number of days that is passed and we need to store that into
    # where date of sales in #days which is at 20($s0)
    sw $v0, 20($s0)
    
    # Lastly we store the sale_price at 24($s0)
    sw $s5, 24($s0)
    
    # Good everything is stored now we need to increment the times_sold in the book struct
    # We need to get the index of where that book is by calling get_book again
    # $a0 -> The book struct we are searching the book in
    # $a1 -> The ISBN we are searching for
    move $a0, $s1
    move $a1, $s2
    
    # Then we call get_book function
    jal get_book
    
    # In $v0 we have the index where the book belongs
    # we have to find the effective address of that  book in oreder to increment the number of times sold
    # We get to the starting address of the array
    addi $t0, $s1, 12
    
    # Load 68 for mult
    li $t7, 68
    
    # Multiply the index with 68 and put into $t1
    mul $t1, $v0, $t7
    
    # Then we add offset to the array address
    add $t0, $t0, $t1
    
    # Now in $t0 we have the effective starting address of where the book is
    # we grab the times sold at 64($t0)
    lw $t1, 64($t0)
    
    # Increment by 1
    addi $t1, $t1, 1
    
    # Then we store it back in the same locaiton
    sw $t1, 64($t0)
        
    # And we have to move in the output
    # in $v0 we have the index it is stored
    # which is just $s7
    # for $v1 the number of moves it took is in $s6
    move $v0, $s7
    move $v1, $s6
    
    # And we can call it done finally
    j finished_sell_book_algorithm

    
    book_not_found_in_book_hashtable:
    # If we are here then that means the book don't even exist
    # we just return (-2, -2) and finished
    li $v0, -2
    li $v1, -2

    # Then we are done with the algorithm
    j finished_sell_book_algorithm
    
    full_sales_hashtable:
    # If we are here then that means the sales HashTable is full we can't insert anymore
    # book sales into the table hence we just reutrn (-1, -1)
    li $v0, -1
    li $v1, -1
    
    # Then we can just follow the next logical line to return
    
    finished_sell_book_algorithm:
    # If we are here then we are done with the algorithm we can start restoring the
    # $s registers we have used
    lw $s0, 0($sp) # Restoring the $s0 register
    lw $s1, 4($sp) # Restoring the $s1 register
    lw $s2, 8($sp) # Restoring the $s2 register
    lw $s3, 12($sp) # Restoring the $s3 register
    lw $s4, 16($sp) # Restoring the $s4 register
    lw $s5, 20($sp) # Restoring the $s5 register
    lw $s6, 24($sp) # Restoring the $s6 register
    lw $s7, 28($sp) # Restoring the $s7 register
    
    # Then we also need to Restoring the return address
    lw $ra, 32($sp)
    
    # Then finally deallocate the memory we have used
    addi $sp, $sp, 36 # Deallocating the 36 bytes of memory we have used
    
    # And jump back to the caller
    jr $ra

compute_scenario_revenue:
    # This function will take in at most 32 booksale struct array and looking at the scenario
    # integer bitstring to compute the total revenue generated by selling the book
    # in that given order.
    
    # $a0 -> The array with completelye filled array of booksales struct
    # $a1 -> The number of booksale struct in sales_list
    # $a2 -> The 32 bit integer that tells the order to sell books
    # Ouput -> $v0, the total revenue produced by selling the book in the given order
    
    # We will be keeping two index pointers that starts pointing at 0 denotes the leftmost in $t5
    # And we will put the other index at the last element pointing at length - 1 denote the rightmost in $t6
    li $t5, 0
    
    # To find rightmost $t6, we have to get the num_sales element 
    # And we subtract 1 from it which gives us the index for the last sales struct
    addi $t6, $a1, -1
    
    # We will be putting the total profit we have made in $t4
    li $t4, 0
    
    # The multiplier in $t3 which starts with 1
    li $t3, 1
    
    # So to do this problem we have to get the given number bitstring from
    # left to the right. One by one to determine the order we sell each book
    for_loop_to_obtain_each_order_bit:
        # Our stopping condition is simple we will stop whenever $a1 becomes 0, which means
        # we have no book left to sell anymore
        beq $a1, $0, finished_selling_all_the_book
    
        # However if we are here then that means there is still book left to sell
        # and we have to get the order of which book we sell through the 
        # bitstring $a2 

        # We shift 32 - $a1 bit to the left, and 31 bit back to the right to get that order
        li $t7, 32 # Used for subtraction
        
        # We will store the difference in $t0
        sub $t0, $t7, $a1
        
        # $t0 contains the number of shifts we do to the left
        # and we will do the shift on $a1 and store the result into $t1
        sllv $t1, $a2, $t0 # Shift the bit string left 32 - $a1 times
        
        # Then after we shift to the right 31 bit
        srl $t1, $t1, 31
        
        # And in $t1 we have the result of 0 which is to take the leftmost book
        # or 1 which we take the right most book
        # If we take this branch that means that the order is a 0 hence we sell the leftmost book
        beq $t1, $0, sell_leftmost_book
        
        # But if we are here then that means we have to sell the rightmost book instead        
        j sell_rightmost_book
        
        
        sell_leftmost_book:
        # Okay if we are here then we have to sell the leftmost book instead
        # We have to grab the price from that sales's location and we have the index
        # of the book we need to grab in $t5 denoting the leftmost book's index right now
        # We do index * 28 and put it into $t1
        li $t7, 28 # For multiplication
        mul $t1, $t5, $t7
        
        # Lastly we add it together with the array address
        add $t0, $a0, $t1
        
        # Okay in $t0 right now we have the sales's starting address, we must grab the price
        # which is located at 24($t0) and load into $t1
        lw $t1, 24($t0)
        
        # And we multiply it with the multiplier to get our profit
        mul $t1, $t1, $t3
        
        # And we have to add it to the profit we have made
        add $t4, $t4, $t1
        
        # And after we sold and count up the profit we have to increment the leftmost pointer
        # by adding 1
        addi $t5, $t5, 1
        
        # Then jump to next iteration        
        j next_iteration_sales
        
        
        sell_rightmost_book:
        # If we are here then we have to sell the rightmost book
        # # We grab the price from the sale's location and we have the index of the book in $t6
        # again to calculate the effective address is 12($base_address) + index * 28
        li $t7, 28 # 28 for multiplicaiton
        # We do index * 28 to put it into $t1
        mul $t1, $t6, $t7
        
        # And we add it together with the array address
        add $t0, $a0, $t1
        
        # Then we can grab the price of that sales from 24($t0) and load it into $t1
        lw $t1, 24($t0)
        
        # And we multiply the price by the multiplier we get our profit
        mul $t1, $t1, $t3
        
        # Then add it to the total profit
        add $t4, $t4, $t1
        
        # After we have to decrement the rightmost  pointer by adding -1
        addi $t6, $t6, -1
        
        # Follow logically to the next iteration        
        
        next_iteration_sales:
        # Decrement $a1 because we just made a sale
        addi $a1, $a1, -1
        
        # We also need to increment the multipler
        addi $t3, $t3, 1
        
        
        # Then we jump back up the loop
        j for_loop_to_obtain_each_order_bit 
    
    
    finished_selling_all_the_book:
    # Then if we are here then $t4 contains the total profit we have made by selling all the books
    # we just load taht into $v0 as our output
    move $v0, $t4
    
    # And we have nothing to deallocate and can just return
    jr $ra

maximize_revenue:
    # Alright last push for the last function here we go bois
    # For this function we will be enumerating all the 2^n bitstring from
    # 0 to 2^n-1 and comptue the revenue of the largest profit by the
    # way selling each book
    
    # $a0 -> The sales_list starting address
    # $a1 -> The number of books that is inside the sales_list
    
    # We will be calling functions hence we have to save the argumentrs
    # 2 arguments, 8 bytes, 1 return address, 4 byte
    # then we need 1 register to store the max we go up to
    # and one to save the current value we are up to so another 8 byte
    # and another one to save the max profit we have encountered so far 4 more byte
    # total of 24 bytes
    addi $sp, $sp, -24 # Allocating 24 bytes of memory on the run time stack
    
    # Saving the $s register before we can use them
    sw $s0, 0($sp) # Saving the $s0 register
    sw $s1, 4($sp) # Saving the $s1 register
    sw $s2, 8($sp) # Saving the $s2 register
    sw $s3, 12($sp) # Saving the $s3 register
    sw $s4, 16($sp) # Saving the $s4 register
    
    # Saving the return address
    sw $ra, 20($sp)
    
    # Now we can save the arguments on the $s register
    move $s0, $a0 # $s0 contain the sales_list starting address
    move $s1, $a1 # $s1 contain the number of books that is inside the sales_list
        
    # So first things first we have to figure out the max value we will be looping
    # to which is just 2^($a1), and we have to do that through a for loop
    # we will be keeping track of that value inside $s2 which starts with 1 so it can be multiplied by 2, n times
    li $s2, 1
    
    # We will keep a counter in $t0 to count the number of times we have multiply 2
    li $t0, 0
    
    # This for loop will help us to find the maximum value we go up to in the enuermating for loop
    for_loop_to_find_max_value:
        # Let's do our stopping condition first if the number of books is 3
        # then when our counter hits 3 then we stop because we have already
        # multiplied 2 3 times from 0,1,2 hence we exit if our counter is greater than or
        # equal to the number of books
        bge $t0, $s1, finished_finding_max_value
        
        # If we are here then we haven't finishing multiplying yet hence we have to keep multiplying 2
        li $t7, 2 # 2 for multiplication
        
        # Then we do the multiplication here
        mul $s2, $s2, $t7
        
        # Then don't forget to increment our counter
        addi $t0, $t0, 1
        
        # And we can jump back up the loop
        j for_loop_to_find_max_value
    
    finished_finding_max_value:
    # If we are here then that means $s2 have the max value our enumerating for loop will go up to
    # if it is greater than or equal to that value we will stop
    # Now here is where we begin our enumerating process. We will start at value of 0
    # and go up to $s2 - 1.
    # $s4 will be our max profit we have seen so our start with -1 just to be safe
    li $s4, -1
    
    # $s2 is our stopping condition for the for loop
    # $s3 is our counter for the enumerating for loop which start at 0
    li $s3, 0
    
    # This for loop will help me find the maximum profit by doing all the possible
    # combination of selling each book
    for_loop_to_find_maximum_profit:
        # Let's do our stopping condition first which is whenever our
        # $s3 counter is greater than or equal to the maximum value
        bge $s3, $s2, finished_finding_max_profit
    
        # Now if we are here then that means we haven't finished checking every single option yet
        # hence we have to call compute_scenario_revenue
        # $a0 -> Is the sales list we are checking, which is just $s0
        # $a1 -> is the number of books that is in the sales which is just $s1
        # $a2 -> Is the scenario we are computing for which is $s3
        move $a0, $s0
        move $a1, $s1
        move $a2, $s3
        
        # Now we can call the function
        jal compute_scenario_revenue
        
        # After we call the function in $v0 we have the total profit that is returned
        # Now we compare that to our max profit encountered if it is greater than
        # we update our max profit, else we skip it to the next interation
        bgt $v0, $s4, update_max_profit
        
        # But if it is less than or equal to the max we don't update it
        # and just move onto the next iteration
        j next_iteration_to_find_max
        
        update_max_profit:
        # If we are here then the computed profit is the bigger profit hence we have
        # to update our max profit to the new max
        move $s4, $v0
        
        next_iteration_to_find_max:
        # Then to move onto the next iteration we increment our scenario counter $s3
        addi $s3, $s3, 1
        
        # And we just jump back up that's it
        j for_loop_to_find_maximum_profit
    
    
    finished_finding_max_profit:
    # Now if we are here then $s4 have the maximum profit that we are longing for
    # that is just our output value, put that in and we are done
    move $v0, $s4

    # Then we are done follow logically to finish this homework!
        
    finished_maximize_revenue_algorithm:
    # If we are here then we are done with the algorithm hence we can start
    # restoring the $s registers
    lw $s0, 0($sp) # Restoring the $s0 register
    lw $s1, 4($sp) # Restoring the $s1 register
    lw $s2, 8($sp) # Restoring the $s2 register
    lw $s3, 12($sp) # Restoring the $s3 register
    lw $s4, 16($sp) # Restoring the $s4 register
    
    # Restoring the return address
    lw $ra, 20($sp)
    
    # Then we have to deallocate the memory we have used
    addi $sp, $sp, 24 # Deallocating 24 bytes of memory we have used
    
    # Then finally we can return to the caller    
    jr $ra

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
