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
