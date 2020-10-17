# Ricky Lu
# rilu
# 112829937

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################

.text
load_game:
    # This function require us to load in the game and constructing the struct into the address
    # state. The text file that we will be reading from will be a filename provided in the argument
    # Keep in mind that the struct we are given will be filled with garbages. If the file doesn't exist
    # we don't write any changes to state
    
    # $a0 -> This is where we are putting the struct data structure from the file we are reading from
    # keeping in mind that it consists of number of rows, number of columns, the row and col of where the
    # snake's head is in the given file. The length of the snake, and the actual game board
    # $a1 -> This contains the file name that describe the gameboard
    # Output -> $v0, If the input file don't exist return -1, else return 1 if an apple 
    # is found in the file. 0 if an apple is not found
    # Output -> $v1, If the input file don't exist return -1, else return the number of # (walls) found in the file 
    
    # Allocate 16 bytes for the three $s registers we are going to use and the other 4 byte used for storing the
    # output from the file descriptor
    addi $sp, $sp, -16
    
    # Storing the $s registers before we can use them
    sw $s0, 12($sp) # Storing $s0 register
    sw $s1, 8($sp) # Storing $s1 register
    sw $s2, 4($sp) # Storing $s2 register
    # The space at 0($sp) will be the 4 byte that is user for getting the output from the file desciptor
    # from calling syscall 14
    
    # We put the argument into the $s registers as backup
    move $s0, $a0 # $s0 have the address where we putting the struct
    move $s1, $a1 # $s1 have the address of the text for the filename
    
    # First we have to open the file that is given to us using the syscall 13
    # with the 0 as $a1 for reading, and 0 as $a2 for the mode since it is ignored
    # After the file is open it will return a file descriptor in $v0 will tells us
    # if the file exist or not, negative if not 
    li $v0, 13 # We first load in the system service for opening a file

    # Since $s1 is the filename we just have to move it to $a0 the argument for which file to open
    move $a0, $s1
    
    # For flags we set it to 0 for reading not writing
    li $a1, 0
    
    # Then for mode we put 0 since it is ignored
    li $a2, 0
    
    # Then we can do syscall which returns a file descriptor in $v0
    syscall
    
    # We should save the file descriptor in the $s2 register so we don't lose it
    move $s2, $v0
    
    # Now we have to check $s2 whether if it is negative or not
    # If the value inside $s2 is negative it means that the file didn't exist so
    # we can just return -1 and -1 in both return value without doing extra work
    bltz $s2, file_didnt_exist
    
    # If we are here then that means the file descriptor is positive meaning
    # a file is indeed read so we have to do work on each character
    
    # We will be storing the line counter in $t1 since it is free
    li $t1, 0 # It will be initally 0 until we increment
    
    # From register $t3 to $t6 we will initalize it with all -1 for us
    # to store the row and col's value
    li $t3, -1 # $t3 and $t4 will handle the column
    li $t4, -1
    li $t5, -1 # $t5 and $t6 will handle the row
    li $t6, -1
    
    # Then let's try to read the file descriptor char by char, byte by byte
    # in a for loop, the stopping condition will be when the return value in $v0 is 0
    # which means end-of-file
    for_loop_to_read_file:
    	li $v0, 14 # We first load in the service for reading a file descriptor
    	
    	move $a0, $s2 # $a0 is file descriptor which is in $s2
    	move $a1, $sp # $a1 is where we are temporarily storing the byte we are reading which is in 0($sp)
    	li $a2, 1 # $a2 is how many character we reading each time, it will just be 1 since we are doing byte by byte
    	
    	# Then we can do syscall here
    	syscall
    	
    	# Now we have the return value in $v0 let's store it in $t0 just in case
    	move $t0, $v0
    	
    	# If the return value is equal to a 0 that means we finished reading the files already
    	beq $t0, $0, finished_for_loop_to_read_file
    	
    	# Now if we are here then that means a character is read
    	# Let's store the character into $t0, because we put the character in $sp we just have to load
    	# in that byte from the stack
    	lbu $t0, 0($sp)
    	
    	# remember 10 is ascii code for \n
    	# 13 is ascii code for \r, we don't care about \r and we will only increment $t1 when we see a
    	# \n ascii character and move on to the next iteration
    	# We will use $t7 to store the comaprsion charaters
    	li $t7, '\n'
    	
    	# If the character we read is not a new line then we don't have to increment that counter
    	bne $t0, $t7, dont_increment_newline_counter
    	
    	# If that branch is false then we encountered a newline we have to do some work before
    	# incrementing the newline counter
    	# If the line counter is 0 then information in $t5 and $t6 is about the row's value
    	beq $t1, $0, solidify_row_in_gamestate
    	
    	# If the line counter is 1 then information in $t3 and $t4 is about the column's value
    	li $t7, 1
    	beq $t1, $t7, solidify_col_in_gamestate

    	# If it is other line, we just skip it for now
    	j increment_newline_counter
    	
    	solidify_row_in_gamestate:
    	# Now if we are here that means $t5 + $t6 have our information for the game's row
    	li $t7, -1 # We load -1 for comparsion
    	
    	# If $t6 is -1 then it is a single digit row
    	beq $t6, $t7, single_digit_row
    	
    	# But if it is not a single digit row then we have to multiply
    	# $t5 by 10 and add $t6 into it to get our row value
    	li $t7, 10 # Load 10 for multiplication
    	
    	# Multiply $t5 by 10 
    	mul $t5, $t5, $t7
    	
    	# Adding $t6 to $t5 to get the row value
    	add $t5, $t5, $t6
    	
	# And we can just use the next label to store it into the byte address
	# because we computed the row's value in $t5 anyway
    	
    	single_digit_row:
    	# If $t6 is -1 then it is only a single digit row we can just store what is in $t5
    	# onto 0($s0) byte
    	sb $t5, 0($s0)
    	
    	# After we store the row's value onto the struct we can just increment newline's counter
    	j increment_newline_counter
    	
    	solidify_col_in_gamestate:
    	# If we are here then that means $t3 and $t4 have our information for the game's col
    	li $t7, -1
    	
    	# If $t4 is -1 then it is a single digit col
    	beq $t4, $t7, single_digit_col
    	
    	# However if it is not a single_digit_col we have to compute the column's value using
    	# the two digits
    	li $t7, 10 # Store 10 for multiplication
    	
    	# Multiply $t3 with 10 
    	mul $t3, $t3, $t7
    	
    	# Then we can just add $t3 with $t4 to get the double digit column value
    	add $t3, $t3, $t4
    	
    	# Then we can just follow to the next line for storing
    	
    	single_digit_col:
    	# If it is only single digit column we store what is inside $t3
    	# onto the game struct which is at 1($s0)
    	sb $t3, 1($s0)
    	
	# So after we jump we are finished with collecting the information for row and col
	# Now we have to work with the game description's characters
	# $t2 and $t6 registers are freed up
	# $t0 is the character we read
	# $t1 is our line counter which we can use for the row counter by subtracting 2
	# We will be putting the column counter in $t2 and is reset each time when we hit the newline
	li $t2, 0
	
	# $t3 will be a copy of the address referring to where we store the game description in our struct
	# So that way we don't have to increment $s0 and messed up the rest of the code
	# Now $t3 is the start of the address of the game struct where we store the game board's information
	addi $t3, $s0, 5
	
	# $t4 will be the length of the snake
	li $t4, 0
	
	# $t5 will be whether an apple is found or not, 0 for not found, 1 for found
	li $t5, 0 # We assume is not found until it is found
	
	# $t6 will be the total number of walls encountered in the game
	li $t6, 0
	
    	increment_newline_counter:
    	# Then we increment the counter after solifying the data
    	addi $t1, $t1, 1
    	
    	# Additionally we reset the counter for the column to 0
    	li $t2, 0
    	
    	# Then we just have to jump to the next iteration
    	j for_loop_to_read_file
    	
    	
    	dont_increment_newline_counter:
    	# If we don't increment the newline counter it might be that the char we read is
    	# a letter, digit, period, #, or \r. We have to make sure we filter \r out and only those
    	# valid snake game characters are considered
    	li $t7, '\r' 
    	
    	# This branch make sure that we don't touch the carriage return character
    	bne $t0, $t7, not_carriage_return
    	
    	# If we are here then that means we indeed encountered a carriage return so we just skip to the next iteration
    	j for_loop_to_read_file
    	
    	not_carriage_return:
    	# If it is not a carriage return character then we can actually parse the character now
    	# If the line counter is equal to 0 then we are on the row where row information is stored
    	beq $t1, $0, gather_row_information
    	
    	# If the line counter is equal to 1 then we are on the row where col infromation is stored
    	li $t7, 1
    	beq $t1, $t7, gather_col_information
    	
    	# If we are here then that means we are on the row where the game board is stored
    	gather_game_board_information:
    	# $t6 is total number of walls in the game
    	# $t5 is whether an apple is found or not
    	# $t4 is the length of the snake
    	# $t3 represent the address of where we storing the game board information in the struct
    	# Here register $t2 represent the column we are at in the game grid
    	# $t1 - 2 repressent the row we are at
    	# $t0 represent the character we got
    	# t4 - $t7 are free for us to use
    	
    	# Regardless of which character we encounter in the game description, we have to 
    	# Append it to the part of the struct which stores the game
    	sb $t0, 0($t3) # We store the byte into the address that have the game board information
    	
    	# Now we are going to do some house keeping work with each character
    	# We have to figure out the row and col where the head of the snake is at
    	# Figure out the length of the snake
    	# Figure out whether an apple is found or not
    	# Figure out the total number of walls that is encountered in the game
    	li $t7, 'a' # a for representing the apple
    	
    	# This branch if the character encountered is not a 'a'
    	bne $t0, $t7, not_apple_character
    	
    	# If we are here then we indeed found an apple hence we mark $t5 to 1 to signal true
    	li $t5, 1
    	
    	# Then we finished parsing one character
    	j finished_parsing_one_character_for_gameboard
    	
    	not_apple_character:
    	# However if we are here then it is not a 'a' character we have to check if it is a wall
    	li $t7, '#' # # for representing the apple
    	
    	# Branch if the character is not a '#'
    	bne $t0, $t7, not_wall_character
    	
    	# If here then it is a wall hence increment $t6
    	addi $t6, $t6, 1
    	
    	# Move onto the next character
    	j finished_parsing_one_character_for_gameboard
    	
    	not_wall_character:
    	# If it is not 'a' not '#' then it can only be character about snake or '.'
    	# We don't have anything special to do about '.'
    	li $t7, '.'
    	
    	bne $t0, $t7, not_period_character
    	
    	# If it is a period we just move onto the next
    	
    	j finished_parsing_one_character_for_gameboard
    	
    	not_period_character:
    	# If not '.', 'a', '#' then it is 1-9 or A-Z
    	li $t7, '1' # Load in ascii value for 1
    	
    	bgt $t0, $t7, not_head_body_segement
    	
    	# But if it is a head segement meaning the character is a 1 then we have to get the 
    	# Row and column information
    	# We store the head's row in 2($s0), the head's column in 3($s0)
    	# The row is just $t1 - 2
    	addi $t0, $t1, -2 # We can use $t0 because we are done checking it already
    	
    	sb $t0, 2($s0) # Storing the snake's row in the approriate byte in struct
    	
    	# The column is just $t2
    	sb $t2, 3($s0) # Storing the snake's column in the apporiate byte in struct
    	
    	# Then we also have to increment the body segement
    	
    	not_head_body_segement:
    	# If the character we are at is 2-9 or A-Z, we just have to increment
    	# because it is not a head so we can't get any information
    	addi $t4, $t4, 1
    	
	# Then follow logically to the next character
	
    	finished_parsing_one_character_for_gameboard:
    	# Label for going onto to the next character with soem incrementing accounting
    	# Then we increment the address to prepare for storing next character
    	addi $t3, $t3, 1
    	
    	# We increment the column we are at
    	addi $t2, $t2, 1
    	
    	# Then we store the body length in 4($s0)
    	sb $t4, 4($s0)
    	
    	j next_read_file_iteration
    	
    	gather_row_information:
    	# Let's start with gathering row's information first
    	li $t7, -1
    	
    	# Getting the actual decimal value from the ascii value by subtracting 48
    	addi $t0, $t0, -48
    	
    	# This means that the first digit is already occupied so we put the next digit into 
    	# $t6 register
    	bne $t5 $t7, gather_row_information_update_t6
    	
    	# But if we are here then that means it is the first digit we read we put it into $t5
    	# Update the first digit register 
    	move $t5, $t0
    	
    	# Then we move onto next iteration
    	j next_read_file_iteration
    	
    	gather_row_information_update_t6:
    	# If we are here then we already have the first digit occupied and we are reading the second digit
    	# Update the second digit register
    	move $t6, $t0
    	
    	# Then move onto the nexti teration
    	j next_read_file_iteration
    	
    	gather_col_information:
    	# Similar to what we wrote for row we start by gathering the information for col first
    	li $t7, -1
    	
    	# Getting the decimal value by subtracting 48
    	addi $t0, $t0, -48
    	
    	# If we take this branch that means the first digit is already occupied so we move onto the
    	# the digit in t4
    	bne $t3, $t7, gather_col_information_update_t4
    	
    	# However if we stay then that means $t0 is our first digit to be put into $t3
    	move $t3, $t0
    	
    	# Then jump back up
    	j next_read_file_iteration
    	
    	gather_col_information_update_t4:
    	# If we are here then that means the first digit is already occupied so we have
    	# to update the second digit register $t4
    	move $t4, $t0
    	
    	# We don't have to explicitly jump to next file iteration
    	
    	next_read_file_iteration:
    	# This is just a label that helps us to go to the next iteration
    	
    	# Jump back up the loop
    	j for_loop_to_read_file
    	
    finished_for_loop_to_read_file:
    # Now if we are here we finished lookign at all the special characters
    # The gameboard description is filled in the struct we can null terminate it
    sb $0, 0($t3)
    
    # Now if we are here then $t5 have whether or not an apple is found
    # $t6 have the total number of walls
    # We just have to store it in $v0 $t5
    # $v1 with $t6
    # But before we do that we have to close our file descriptor
    move $a0, $s2 # Putting the file descriptor we are closing into the argument
    li $v0, 16 # 16 is for closing file descriptors
    syscall # Closing file descriptor
    
    # Then we can do the return values
    move $v0, $t5 # Whether an apple is found
    move $v1, $t6 # Number of walls found in the game
    
    # Then we jump to restore and deallocate memory
    j finished_loading_game_algorithm
    
    file_didnt_exist:
    # If we are here then that means that the file didn't exist hence we just return
    # -1 and -1 in both $v0 and $v1
    li $v0, -1
    li $v1, -1
    
    # We don't have to jump since it goes to finished_loading_game_algorithm anyway

    finished_loading_game_algorithm:
    # If we are here then we are done with this function hence we have to first restore
    # all of the registers we have used
    lw $s0, 12($sp) # Restoring $s0 register
    lw $s1, 8($sp) # Restoring $s1 register
    lw $s2, 4($sp) # Restoring $s2 register
    
    # Then we have the dealloacte all the 16 byte we have used
    addi $sp, $sp, 16
    
    
    # Then we can just return to the main
    jr $ra

get_slot:
    # If we are here then we have to basically return the character stored in grid[row][col]
    # The grid is already stored in row-major order so we have to use this formula
    # effect_addr = base_addr + element_size_in_byte ( i * num_columns + j) to get
    # the byte that we are suppose to load in unsigned
    
    # $a0 -> The pointer to a valid struct
    # $a1 -> The row where we read the character
    # $a2 -> The column where we are reading the character
    # Output -> $v0, Output the ascii value of the character at grid[row][col], it will return
    # -1 if the row or col isn't within valid range [0, row-1] and [0, col-1]
    
    # Now let's load in the number of rows and columns first so we can have a valid range
    # to compare our arguments
    # We will load row into $t0
    # Load col into $t1
    # Keep in mind that 0($a0) stores the row in the struct
    lb $t0, 0($a0)
    
    # 1($a0) stores the column in the struct
    lb $t1, 1($a0)

    # Now we have the row and column we can start comparing whether or not the given
    # argument is within the valid range
    
    # This means that if the given row is a negative number it won't be valid
    blt $a1, $0, invalid_row_col_argument
    
    # This means that we branch if the given row is greater than or equal to the row of the game grid
    # Not valid because it is from [0, row-1]
    bge $a1, $t0, invalid_row_col_argument
    
    # If we are here then row is valid but we also have to check if col is also valid
    # Same thing we check if the given col is a negative it won't be valid
    blt $a2, $0, invalid_row_col_argument
    
    # If we are here then $a2 is definitely greater than or equal to 0 
    # If $a2 is greater than or equal to the column of the game grid
    # it won't be valid because it is from [0, col-1]
    bge $a2, $t1, invalid_row_col_argument
    
    # Now if we are here then that means row and column are valid which we can actually get 
    # the actual character from the grid now
    # We must first grab the struct address which stores the grid, and it is at 5($a0)
    # Let's store it in $t3
    addi $t3, $a0, 5
    
    # Then we can use $t3 as the base address to compute the effective address of the character
    # effect_addr = base_addr + element_size_in_byte ( i * num_columns + j)
    # element_size_in_byte = 1
    # i = $a1
    # j = $a2
    # num_columns = $t1
    
    # i * num_columns + j into $t4
    mul $t4, $a1, $t1
    
    # Then we add j to $t4
    add $t4, $t4, $a2
    
    # Then add base address $t3 with $t4
    add $t3, $t3, $t4
    
    # Then we can just do lbu from $t3 as our return value
    lbu $v0, 0($t3)
    
    # Then we are essentially done!
    j finished_getting_slot_algorithm
    
    invalid_row_col_argument:
    # If we are here then that means that the given row and column is invalid
    li $v0, -1
    
    finished_getting_slot_algorithm:
    # No memory is used we can just return
    jr $ra

set_slot:
    # This function sets grid[row][col]'s char to ch basically it
    
    # $a0 -> The pointer to a valid struct
    # $a1 -> The row where we storing the char
    # $a2 -> The column where we storing the char
    # $a3 -> The char that we are storing
    # Output -> Returns -1 if the row or column is outside of valid range,
    # else return char that we just stored
    
    # So again let's load in the number of rows and columns for comparing valid range
    # $t0 for the game's row
    # $t1 for the game's column
    lb $t0, 0($a0) # Gets the row from the struct
    
    lb $t1, 1($a0) # Gets the column from the struct
    
    # Now we do logic checking, for the given argument
    # If the given row is less than 0 it is negative hence invalid argument
    blt $a1, $0, invalid_row_col_argument_part2
    
    # If we are here it is greater than or equal to 0 but we also should check upper bound
    # This means that we branch if the row is greater than or equal to game row
    bge $a1, $t0, invalid_row_col_argument_part2
    
    # We also do the same for column
    # Means that the column is a negative value hence invalid
    blt $a2, $0, invalid_row_col_argument_part2
    
    # Check if is less than the upper bound
    bge $a2, $t1, invalid_row_col_argument_part2
    
    # Now if we are here then that means that the row and col are valid
    # Hence we can proceed to store $a3 into grid[row][col]
    # We must first grab the struct address which stores the grid, and it is at 5($a0)
    # Let's store it in $t3
    addi $t3, $a0, 5
    
    # Then we can use $t3 as the base address to compute the effective address of the character
    # effect_addr = base_addr + element_size_in_byte ( i * num_columns + j)
    # element_size_in_byte = 1
    # i = $a1
    # j = $a2
    # num_columns = $t1
    
    # i * num_columns + j into $t4
    mul $t4, $a1, $t1
    
    # Then we add j to $t4
    add $t4, $t4, $a2
    
    # Then add base address $t3 with $t4
    add $t3, $t3, $t4
    
    # Now $t3 have the effective address where we are storing the given char
    # We just store it 
    sb $a3, 0($t3)
    
    # And we just have to put the char's value into $v0 as the return value
    move $v0, $a3
    
    # Then we can just jump there because we are done
    j finished_setting_slot_algorithm
    
    invalid_row_col_argument_part2:
    # If we are here then that means the given row or col is invalid in range
    # We just return -1
    li $v0, -1

    finished_setting_slot_algorithm:
    # Nothign to deallocate so we can just jump back to main
    jr $ra

place_next_apple:
    # This function basically look through the apple array that is given of length apple_length
    # Every two element represent an apple in the position (row, col) which hasn't been placed
    # (-1, -1) pair is an apple that is already placed. It will look through every pair to see if
    # at that position is there a '.', if it is '.' it will replace it with a 'a' by calling set_slot
    # then the apple array will be changed to both (-1, -1) to reflect that it is placed. If the
    # space is already occupied by a wall or snake then it will skip that pair and look at the next pair
    # until a valid apple is placed. We are promised that a valid apple is in the array
    
    # We must call get_slot and set_slot
    
    # $a0 -> The valid struct that contains game's information
    # $a1 -> The starting address to the apple byte array
    # $a2 -> The number of pairs that is in the array, say 6 element = 3 pairs
    # Output -> $v0, the row that the apple is placed at
    # Output -> $v1, the column that the apple is placed at
    
    # Since we are going to call the functions we obviously have to preserve each function arguments
    # and the return address of place_next_apple on the run time stack.
    # There is 3 arguments, so that is 12 bytes plus 4 more for $ra will need 16
    # But we need 3 more registers to store the row and col values that we get from the array
    # Then another one register to keep as the loop counter for going through the array
    # so we can call the functions to check whether it is valid or not adding another 12 byte
    addi $sp, $sp, -28 # Allocating a total of 28 byte on the stack
    
    # Saving the $s registers before we can use them
    sw $s0, 0($sp) # Saving $s0 register
    sw $s1, 4($sp) # Saving $s1 register
    sw $s2, 8($sp) # Saving $s2 register
    sw $s3, 12($sp) # Saving $s3 register
    sw $s4, 16($sp) # Saving $s4 register
    sw $s5, 20($sp) # Saving $s5 register
    
    # Saving the return address as well so we can call functions
    sw $ra, 24($sp)
    
    # Now we unlock $s0 - $s2 we can save our arguments in them
    move $s0, $a0 # $s0 will have the game_state struct address
    move $s1, $a1 # $s1 will have the starting address to the apple byte array
    move $s2, $a2 # $s2 will have the number of pairs in the apple array
    
    # Now we have to have a loop that traverse through the apple array
    # it will have a counter which keeps track of which pair we are at and is 0-indexed
    # We will use $s5 as that counter and $s2 is our stopping condition
    # $s5 beause we need a register that is preserved across function call
    li $s5, 0
    
    # Our for loop to traverse through the apple array
    for_loop_for_apple_array:
    	# Let's just do our stopping condition and get it out of the way
    	# Once our index counter is equal to or greater than the number of pair of apples
    	# we are done
    	bge $s5, $s2, finished_for_loop_for_apple_array
    	
    	# However, if we are here then we have a valid index to grab the (row, col) from the apple
    	# To grab the row we do pair_counter * 2
    	# To grab the column we do pair_counter * 2 +1
    	# As the index offset and add it to the base address
    	# We load 2 into register $t7 for multiplication
    	li $t7, 2
    	
    	# We will store the row's offset in $t1 and column's offset in $t2
    	# Multiplying pair_counter * 2 for row's offset
    	mul $t1, $s5, $t7
    	
    	# Multiplying pair_counter * 2 for column's offset
    	mul $t2, $s5, $t7
    	
    	# Then we add 1 to $t2 to get the column's offset
    	addi $t2, $t2, 1
    	
    	# Now in $t1 we have offset for row and $t2 have offset for column
    	# We just have to add the base_address to get the effective address for each
    	add $t1, $t1, $s1 # Effective address for apple's row
    	add $t2, $t2, $s1 # Effective address for apple's column
    	
    	# Let's save the effective address into the $s3 and $s4 registers
    	move $s3, $t1 # $s3 have effective address of row value
    	move $s4, $t2 # $s4 have effetive address of column value
    	
    	# Now we have to call get_slot to really check what is in that grid[row][col]
    	# before we can actually place it in that position
    	
    	# Preparing to call get_slot
    	# $a0 -> The struct
    	# $a1 -> The row
    	# $a2 -> The column
    	move $a0, $s0
    	lb $a1, 0($s3)
    	lb $a2, 0($s4)
    	
    	# Now we can actually call the get_slot function
    	jal get_slot
    	
    	# After in $v0 have the character that is located in grid[row][col]
    	# We have to check if it is an empty space '.' else if it is a wall or snake body
    	# We cannot put our apples there
    	li $t7, '.' # Load in '.' for comparsion
    	
    	# We will branch if the return character is not a period
    	# which means we cannot put our apples there
    	bne $v0, $t7, unable_to_place_apple
    	
    	# However, if we are here that means we are able to put our apples
    	# in this (row, col) position so we will do so with set_slot
    	# Preparing to call set_slot
    	# $a0 -> The struct
    	# $a1 -> The row
    	# $a2 -> The column
    	# $a3 -> 'a' we are storing
    	move $a0, $s0
    	lb $a1, 0($s3)
    	lb $a2, 0($s4)
    	
    	# Storing a and using it as our character for $a3
    	li $t7, 'a'
    	move $a3, $t7
    	
    	# Then we are ready to call set_slot
    	jal set_slot
    	
    	# Then that character is already set, it is guranteeded to work
    	# because the row and column we get is definitely valid.
    	# If it is not valid then get_slot will return a negative value and
    	# it will go to unable_to_place_apple. If we are here then that row and column
    	# is definitely a '.' character in which we can replace
    	
    	# Before we set the row and value to -1 let's grab it again to put into our
    	# output value
    	lb $v0, 0($s3) # $v0 is our row
    	lb $v1, 0($s4) # $v1 is our col
    	
    	# Then we have to update the (row, col) to (-1, -1) because we have placed into our
    	# game_state already which we can do with $s3, and $s4
    	li $t7, -1
    	
    	# Updating the pair value after placing the apple
    	sb $t7, 0($s3) # Storing row as -1
    	sb $t7, 0($s4) # Storing col as -1 
    	
    	# Then we jump back out because we found an apple that we can place
    	# so we are done traversing the loop, break out early
    	j finished_for_loop_for_apple_array
    	
    	unable_to_place_apple:
    	# If we are here then we are unable to put an apple in the current (row, col) pair of apple
    	# Hence we just move onto the next pair
    	
    	# Incrementing the pair counter
    	addi $s5, $s5, 1
    	
    	# Jump back up the loop
    	j for_loop_for_apple_array
    	
    finished_for_loop_for_apple_array:
    # If we are here then we have finished placing the apples
    
    # We have to restore each registers
    lw $s0, 0($sp) # Restoring $s0 register
    lw $s1, 4($sp) # Restoring $s1 register
    lw $s2, 8($sp) # Restoring $s2 register
    lw $s3, 12($sp) # Restoring $s3 register
    lw $s4, 16($sp) # Restoring $s4 register
    lw $s5, 20($sp) # Restoring $s5 register

    # Restore the return address else it won't know where to return to
    lw $ra, 24($sp) # Restoring the return address
    
    # Deallocating the 28 byte memory that we have used
    addi $sp, $sp, 28
    
    # Then jump back to main
    jr $ra

find_next_body_part:
    # This function basically scans the top, down, left, and right of gamegrid[row][col]
    # to check if it is able to find the specified target part. We will be calling
    # get_slot four times to do the checking
    
    # $a0 -> The valid game struct starting address
    # $a1 -> The row that we are searching from
    # $a2 -> The column that we are searching from
    # $a3 -> The target_part of the snake body we looking for around (row, col)
    # Output -> the row of the target, returns -1 if (row, col) given is not valid or target not found
    # Output -> the column of the target, returns -1 if (row, col) given is not valid or target not found
    
    # Since we are going to be calling the get_slot four times we have to save our given arguments
    # four arugments, 4 byte eachs makes it 16 byte in total. We have to preserve $ra as well
    # hence total of 20 bytes for now
    addi $sp, $sp, -20 # Allocating 16 byte in the run time stack
    
    # Preserving the $s registers before using them
    sw $s0, 0($sp) # Saving $s0 register
    sw $s1, 4($sp) # Saving $s1 register
    sw $s2, 8($sp) # Saving $s2 register
    sw $s3, 12($sp) # Saving $s3 register
    
    # Saving the return address else find_next_body_part won't know where to return to
    sw $ra, 16($sp)
    
    # Saving the arguments
    move $s0, $a0 # $s0 have the game struct address
    move $s1, $a1 # $s1 have the row that we are searching from
    move $s2, $a2 # $s2 have the column that we are searching from
    move $s3, $a3 # $s3 have the target_part that we are looking for
    
    # First things first we have to make sure that the given row and column arguments
    # from where we are looking from are valid hence let's grab the game row and column from the struct
    # We can grab the row from 0($s0)
    lb $t0, 0($s0)
    
    # We can grab the column from 1($s0)
    lb $t1, 1($s0)
    
    # Now let's do the checking to make sure both the given row and column are in valid range
    # If the row is less than 0, negative can't be valid
    blt $s1, $0, invalid_row_col_argument_part3
    
    # If the row's valid is greater than or equal to the game's row then it can't be valid
    # because the valid range is from [0, game_row - 1]
    bge $s1, $t0, invalid_row_col_argument_part3
    
    # Now if we are here row is definitely valid but we also need to check it for the column as well    
    # If the column is less than 0, negative can't be valid
    blt $s2, $0, invalid_row_col_argument_part3
    
    # If the column's valid is >= to the game's column then it can't be valid
    bge $s2, $t1, invalid_row_col_argument_part3
    
    # effect_addr = base_addr + element_size_in_byte ( i * num_columns + j)
    # This formula will be used to calculate the effect address of that specific four square
    # Okay if we are here the given row and column argument are both valid hence we
    # start performing the checking
    
    # Up square first
    # where the row is obtained by subtracting 1 but the column remains the same
    # We will store the possible location row in $t0, possible location col in $t1
    addi $t0, $s1, -1 # Subtracting 1 from given row to get up square's row
    
    # Then we can just move in the arguments for get_slot
    # $a0 -> Game struct
    # $a1 -> Row
    # $a2 -> Col
    move $a0, $s0
    move $a1, $t0
    move $a2, $s2 # Same column value
    
    # Then we can call get_slot
    jal get_slot
    
    # In $v0 we have the character that is returned that is up of (row, col)
    # Let's check if it is the target
    # We take the branch if the target is found in the up square
    beq $v0, $s3, at_up_body_part_target_found
    
    # If we don't take the branch then we check the down square
    # Down square second 
    # Row is just adding 1 and the column is the same
    addi $t0, $s1, 1
    
    # Move in the arguments for get_slot
    # $a0 -> Game struct
    # $a1 -> Row
    # $a2 -> Col
    move $a0, $s0
    move $a1, $t0
    move $a2, $s2 # Same column value
    
    # Call get_slot
    jal get_slot
    
    # If $v0 is equal to target then the target is found at down square
    beq $v0, $s3, at_down_body_part_target_found
    
    # If we don't branch we check left square
    # Row is the same, but the column is subtracted by 1
    addi $t0, $s2, -1
    
    # Move in the argument for get_slot
    # $a0 -> Game struct
    # $a1 -> Row
    # $a2 -> Col
    move $a0, $s0
    move $a1, $s1 # Same as row value
    move $a2, $t0
    
    # Call get_slot
    jal get_slot
    
    # If $v0 is equal to target then target is found at left square
    beq $v0, $s3, at_left_body_part_target_found
    
    # If we don't branch the check right last square
    # Row is the same, column add by 1
    addi $t0, $s2, 1
    
    # Move in argument
    # $a0 -> Game struct
    # $a1 -> Row
    # $a2 -> Col
    move $a0, $s0
    move $a1, $s1 # Same as row value
    move $a2, $t0
    
    # Call get_slot
    jal get_slot
    
    # If $v0 is equal to target then target is found at right square
    beq $v0, $s3, at_right_body_part_target_found
    
    # Now we come here, if we are here then the target cannot be found in any of the 4 squares
    # hence we return -1 and -1 for both output value
    # We can do so by jumping to invalid_row_col_argument_part3
    j invalid_row_col_argument_part3
    
    at_up_body_part_target_found:
    # At the up square the target is found hence we make $v0 the return value
    # to row - 1, and $v1 the just col
    addi $v0, $s1, -1 # The row is just given row - 1
    move $v1, $s2 # The column is the same 
    
    # We are then done and can return
    j finished_find_next_body_part_algorithm
    
    at_down_body_part_target_found:
    # At the down square the target is found hence we make $v0 the return value
    # to row + 1, and $v1 is just the col
    addi $v0, $s1, 1 # The row is given row + 1
    move $v1, $s2 # The column is the same
    
    # We are then done and can return
    j finished_find_next_body_part_algorithm
    
    at_left_body_part_target_found:
    # At the left square the target is found hence we make $v0 the return value
    # to just row, and $v1 is col - 1
    move $v0, $s1 # The row is the same
    addi $v1, $s2, -1 # The col is given col - 1
    
    # We are then done and can return
    j finished_find_next_body_part_algorithm
    
    at_right_body_part_target_found:
    # At the right square the taget is found hence we make $v0 the return value
    # of jsut row, and $v1 is col + 1
    move $v0, $s1 # The row is the same
    addi $v1, $s2, 1 # The col is given col + 1
    
    # We are then done and can return. Can't follow else it will be logic error
    j finished_find_next_body_part_algorithm
    
    invalid_row_col_argument_part3:
    # If we are here then that means the the row and col given
    # if not valid hence we return -1 in both $v0 and $v1
    li $v0, -1
    li $v1, -1
    
    finished_find_next_body_part_algorithm:
    # If we are here then that means that we have finished executing this algorithm
    # We can restore all the registsers and the memory that we have used
    
    # Restoring the registers
    lw $s0, 0($sp) # Restoring $s0 register
    lw $s1, 4($sp) # Restoring $s1 register
    lw $s2, 8($sp) # Restoring $s2 register
    lw $s3, 12($sp) # Restoring $s3 register
    
    # Restoring the return address
    lw $ra, 16($sp) # Restoring the return address
    
    # Deallocating the memory that we have used
    addi $sp, $sp, 20 
    
    # Then we can jump back to main
    jr $ra

slide_body:
    # This function moves the snake in a direction that is given as argument
    # (1,0) = Move down a row
    # (-1,0) = Move up a row
    # (0,1) = Move right a col
    # (0,-1) = Move left a col
    # We have to update the struct's snake head_row and col after we finished moving
    
    # $a0 -> The valid game_struct
    # $a1 -> The delta head_row, how much we are changing the row
    # $a2 -> The delta head_col, how much we are changing the col
    # $a3 -> The apple's array which contains the pair of values
    # 0($sp) -> Accessing from the stack that contains the caller's stack frame for the
    # fifth argument which is the apple_length
    # Output -> $v0, 0 if the snake move into empty slot '.'
    # 1 if the snake move into a slot that have an apple and move forwaard without any trouble
    # -1 if the snake can't move forward because if so it moves outside gameboard, intersect itself
    # or intersect a wall with no change to the game struct
    
    # Save a copy of the $sp before we allocate so we can grab the argument from the caller
    # easily in $t0
    move $t0, $sp
    
    # First and foremost let's save all the 8 $s registers because we are going to be needing
    # all of them as well as space for the $ra, making it 36 byte in total
    addi $sp, $sp, -36 # Allocating 36 byte in the run time stack
    
    sw $s0, 0($sp) # Saving register $s0
    sw $s1, 4($sp) # Saving register $s1
    sw $s2, 8($sp) # Saving register $s2
    sw $s3, 12($sp) # Saving register $s3
    sw $s4, 16($sp) # Saving register $s4
    sw $s5, 20($sp) # Saving register $s5
    sw $s6, 24($sp) # Saving register $s6
    sw $s7, 28($sp) # Saving register $s7
    
    sw $ra, 32($sp) # Saving the return address
    
    # Then we can store the arguments now
    move $s0, $a0 # Storing the game struct
    move $s1, $a1 # Storing the delta row
    move $s2, $a2 # Storing the delta col
    move $s3, $a3 # Storing the apple array address
    lb $s4, 0($t0) # Storing the apple length
    
    # Now we have to first see if the place that the snake is moving to is a
    # valid place to go to by calling get_slot in the future position of the snake
    # We will proceed to calculate the future row and future col of the snake using the snake's
    # current head and row position adding it to the delta row and delta col and calling get_slot
    # Future row will be in $t0, future col will be in $t1
    # Load snake's head from game_struct first
    lb $t0, 2($s0) # Getting the head row
    lb $t1, 3($s0) # Getting the head col
    
    # Now adding the delta row and delta col
    add $t0, $t0, $s1 # Delta row
    add $t1, $t1, $s2 # Delta col
    
    # Then we have to call get_slot to check whether or not the snake can move into that
    # position
    move $a0, $s0 # Game struct
    move $a1, $t0 # Row to check
    move $a2, $t1 # Col to check
    
    # Calling get_slot
    jal get_slot
    
    # In $v0 we have the future snake's position's character
    # Now we will only break the difference cases where the snake can move into
    
    # We need a place to store the true or false value of whether or not the snake moved
    # into an apple and eat it without trouble or into a '.' space
    # We will allocate it in the run time stack using additional of 4 byte and we will deallocate
    # it right after we finished the for loop
    addi $sp, $sp, -4 # Allocating 4 more byte to store the true or false value of the boolean
    
    # We will only one byte one at 0($sp) with inital value of 0 to signal that
    # it hasn't eaten an apple until found
    sb $0, 0($sp) 
    
    # First case is if it can enter a free slot
    li $t7, '.'
    
    beq $v0, $t7, move_into_free_slot_snake
    
    # Second case is the apple slot
    li $t7, 'a'
    
    beq $v0, $t7, move_into_apple_slot_snake
    
    # Now if we are here then the position that the snake is about to move into is
    # either a wall, the snake body itself, or outside of the gamebaord
    # We will just return -1 as the unable to move value without changing any game state
    li $v0, -1 
    
    # Then we just have to return that's it nothing to do if we are unable to move into a position
    j finished_sliding_algorithm
    
    move_into_apple_slot_snake:
    # If there is an apple in front it is a special case
    # We have to update 0($sp) to be 1 because an apple is found
    li $t7, 1
    
    sb $t7, 0($sp)
    
    # Then we must call place_next_apple to put the next apple
    # before making the snake 'eat' the apple
    move $a0, $s0 # The game struct argument
    move $a1, $s3 # The apple array
    move $a2, $s4 # The apple_length 
    
    # Now we have everything we can just call place_next_apple
    jal place_next_apple
    
    # After putting the next apple we can make the snake move forward into that apple
    # which just follows the next label logically
    
    move_into_free_slot_snake:
    # Now if we are here then that means the next position the snake is going to be moving into
    # is just a free slot, we can do so without worries
    # So we comptue the future row and future columns again so we can call set_slot on the game
    # struct to update the head of the snake first 
    lb $t0, 2($s0) # Getting the head row
    lb $t1, 3($s0) # Getting the head col
    
    # Now adding the delta row and delta col
    add $t0, $t0, $s1 # Delta row
    add $t1, $t1, $s2 # Delta col
    
    # Only the head we are moving using set_slot for now
    li $t7, '1'
    move $a0, $s0 # Game struct
    move $a1, $t0 # The row we are placing 1 into
    move $a2, $t1 # The col we are placing 1 into
    move $a3, $t7 # The character we are placing at the future row and col
    
    # Now we can call set_slot
    jal set_slot
    
    # So after the 1 is set in the future row and col we will be using a for loop
    # to move all the body segements starting from original head row, col 
    # to find the next body segement which is 2, and move it into current head row, col
    # then update the 
    
    # So after the 1 is set in the future row and col we will be using a for loop
    # to do all the moving. Let's define some variables first
    # We call working_row and working_col as the current row, col starting.
    # It will be initally head's row, col. Then it will look for the next body segement starting with 2
    # at working_row and working_col. If it finds 2 by calling find_next_body_part
    # It will update the body part working_row, working_col current at with 2 and update
    # the value to the 2's row and col and increment to find the next body segement which is 3.
    # Then it will just basically keep doing that until it hits a current_row and working_col where
    # the next body segment it returns is -1 which means there that it has finished incrementing all the bodies
    # The last step is to make the cell at working_row and working_col into an empty slot and that's it
    
    # So working_row will be $s5
    # Working_col will be $s6
    lb $s5, 2($s0) # Starting at head_row
    lb $s6, 3($s0) # Starting at head_col
    
    # We will need a body segment counter and will be in $s7
    li $s7, '2' # Starting at 2 since that is the next body segment we looking for
    
    for_loop_for_sliding_the_snake:
    	# So here is our stopping condition
    	# After we called find_next_body_part, if a -1 is returned in $v0 or $v1 we will
    	# exit the loop because that means the next body segment is not found at working_row
    	# and working_col
    	move $a0, $s0 # Game struct
    	move $a1, $s5 # The row we searching from will just be working_row
    	move $a2, $s6 # The col we searching from will just be working_col
    	move $a3, $s7 # Target will be the body segement counter
    	
    	# Then we can call find_next_body_part
    	jal find_next_body_part
    	
    	# And in $v0, $v1 we have our next_body part's position
	# Store it in $t0 and $t1 first
	move $t0, $v0 # Next part row
	move $t1, $v1 # Next part col
	
	# We have to make sure that the next_body part exists before we start replacing
	# Which is also our stopping condition, that if we can't find the next body segment
	# we are done moving the body parts
	li $t7, -1
	
	# We will branch if the next body part doesn't exist
	beq $t0, $t7, finished_loop_for_sliding_the_snake
	
	# If we are here then that means the next body part does exist and we have to
	# replace the character at (working_row, working_col) with $s7
	# then update working_row and working_col to $t0 and $t1
    	# effect_addr = base_addr + element_size_in_byte ( i * num_columns + j)
	
	# Get the base address for the game_board
	addi $t5, $s0, 5
	
	# Get number of columns first
	lb $t2, 1($s0)
	
	# i * num_columns first into $t4
	mul $t4, $s5, $t2
	# Then plus j
	add $t4, $t4, $s6
	
	# Add to base address to get effective address
	add $t4, $t4, $t5
	
	# Now having the effective address we can replace the (working_row, working_col) with
	# $s7 which is the body segment we are looked for
	sb $s7, 0($t4)
	
	# Okay after we replace it we have to replace working_row and working_col with
	# the body segment row and col we just found
	move $s5, $t0
	move $s6, $t1
	
	# Then we have to increment $s7 to point to the next body segment we looking for
	# but we have to keep in mind when $s7 is '9' we have to jump to 'A'
	li $t7, '9'
	
	# If the body segment we just looked at is 9 already we have to turn it into A
	beq $s7, $t7, apple_ascii_jump
	
	# Else we just increment it like normal, even when it turn into A
	addi $s7, $s7, 1
	
	# We have to make sure to skip over it if it is not a 9 after incrementing
	j after_apple_ascii_jump
	
	apple_ascii_jump:
	# Jumping from 9 to A, only occurs at most once
	li $s7, 'A'
	
	after_apple_ascii_jump:
	# Then that's it we just have to jump back up the loop
	j for_loop_for_sliding_the_snake
	 
    finished_loop_for_sliding_the_snake:
    # Then we have to removed the character at (working_row, working_col) into '.'
    li $t7, '.'
    
    # Get the base address for the game_board
    addi $t0, $s0, 5
	
    # Get number of columns first
    lb $t1, 1($s0)
	
    # i * num_columns first into $t2
    mul $t2, $s5, $t1
    # Then plus j
    add $t2, $t2, $s6
	
    # Add to base address to get effective address
    add $t2, $t2, $t0
    
    # Then store it into $t2
    sb $t7, 0($t2)
    
    # Then we are essentially done! We will have our result
    # which did the snake moved into a '.' or 'a' in 0($sp)
    # so we just have to put it into $v0 as our output value
    lb $v0, 0($sp)
    
    # Then we are essentially done with the algorithm
    # But before we are done we have to update the new snake head's row and col before we return
    # Which can be easily obtain by adding both with delta row and col
    # Load in the current snake head's row and col first, into $t0 and $t1
    lb $t0, 2($s0) # Head row
    lb $t1, 3($s0) # Head col
    
    # Then we add it with the delta row and delta col
    add $t0, $t0, $s1
    add $t1, $t1, $s2 
    
    # Then store it back into the struct
    sb $t0, 2($s0) # Update head row
    sb $t1, 3($s0) # Update head col
    
    # Then we are done
    
    finished_sliding_algorithm:
    # Then we have to deallocate the 4 byte we use to store as a boolean expression
    addi $sp, $sp, 4
    
    # Restoring all the registers
    lw $s0, 0($sp) # Restoring register $s0
    lw $s1, 4($sp) # Restoring register $s1
    lw $s2, 8($sp) # Restoring register $s2
    lw $s3, 12($sp) # Restoring register $s3
    lw $s4, 16($sp) # Restoring register $s4
    lw $s5, 20($sp) # Restoring register $s5
    lw $s6, 24($sp) # Restoring register $s6
    lw $s7, 28($sp) # Restoring register $s7
    
    lw $ra, 32($sp) # Restoring the return address
    
    # Deallocating all the memory we used
    addi $sp, $sp, 36
    
    # Then we can return to main
    jr $ra

add_tail_segment:
    jr $ra

increase_snake_length:
    jr $ra

move_snake:
    jr $ra

simulate_game:
    jr $ra

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
