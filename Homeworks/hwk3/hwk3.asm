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
    jr $ra

set_slot:
    jr $ra

place_next_apple:
    jr $ra

find_next_body_part:
    jr $ra

slide_body:
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
