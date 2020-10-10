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
    # If we are here then that means we have to generate a plaintext based on
    # the given sorted alphabet. The most frequent one repeat which is the first
    # letter in the sorted alphabet string will repeat 8 times, total of 9 time in the
    # plaintext alphabet. The second frequent one repeats 7 times, total of 8 times in the plaintext alphabet
    # so on and so forth

    # $a0 -> contains the address where we are suppose to writte the plaintext_alphabet
    # it is unitialized and is at least 63 byte in size, it must be null terminated at the [62] position
    # or at the last byte or the String
    # $a1 -> contains the string for the sorted_alphabet this is where the sorted alphabet is placed
    # we will be looping through this String for 8 times to find the 8 most frequent letters
    # that needs to be repeated
    # Output -> No return value because this method is void

    # So our game plan is we will allocate a 26 byte sized array in the run time stack
    # Each index will be mapped to a-z letter respectively by adding or subtracting 97 to the ascii
    # to get the index value. The actual byte content will contain the number of times that we have
    # to repeat the letter. All of the elements will be initially 1 first so let's first allocate it
    # then we will store 1s in all of them
    addi $sp, $sp, -26 # Allocating 26 byte of memory in the run time stack for an array

    # Let's store the loop counter at $t0
    li $t0, 0

    # We store our stopping condition at $t1 which is 25 because we will go
    # through it 25 times
    li $t1, 25

    # Then we store 1 into $t2 because that is the value we are putting inside each byte
    li $t2, 1

    # Now we will have to put the value of 1 them from index 0 to 25
    for_loop_to_put_one_in_elements:
    	# Let's do our stopping condition first, it will stop as soon as it hit 26
    	# which means it will go through 0 - 25
    	bgt $t0, $t1, finished_loop_to_put_one_in_elements

    	# Now if we are here then we have to get our effective address first
    	# before we can store $t2 into each byte
    	# We get our effective address of each element by adding $t0 to the stack pointer
    	# let's store it into $t3
    	add $t3, $t0, $sp # Getting our effective address for each element

    	# Then we just have to store $t2 into $t3's address
    	sb $t2, 0($t3)

    	# Then we increment our counter
    	addi $t0, $t0, 1

    	# And jump back up the loop
    	j for_loop_to_put_one_in_elements

    finished_loop_to_put_one_in_elements:
    # Now if we are here then that means there is 26 1's in each elements of the array
    # The next step is to loop through the sorted array 8 times only to grab the first 8
    # characters that needs to be repeated
    # So let's establish our counters
    li $t0, 0 # This is our loop counter

    # We have to go through it 8 times so $t1 have 8 which is our stopping condition
    li $t1, 8

    # Then we have to have a register to keep track of the amount that we repeat
    # it starts at 8 and decrements until 0 but not used we put that in $t2
    li $t2, 8 # $t2 is our repeat counter to tell us how many times to add in addition to only 1 in the stack array

    # This loop will go through sorted_arrays total of 8 times to add
    # the number of repetition that is needed for the first 8 letters in the sorted array
    for_loop_to_add_repetition:
    	# Let's do our stopping condition here first
    	# If our counter is greater than or equal to 8 then we are done
    	# going through 0 - 7 index of the string, which is total of 8 letters
    	bge $t0, $t1, finished_loop_to_add_repetition

    	# Now if we are here then we first let's just get our ascii value of the string
    	# at this index. To do that we add $t0 with $a1 to get our effective address
    	# for the element and let's store it in $t3
    	add $t3, $t0, $a1

    	# Then $t3 contain our effective address for that character
    	# we just load it in into the same register because we don't need that address again
    	lbu $t3, 0($t3)

    	# Now we know that the letter in $t3 need to be repeated $t2 times
    	# so we have to add $t2 to the element repeat counter in our stack array
    	# that represents the letter $t3
    	# To do that we have to get our offsets for the stack array
    	# Which can be accomplished by subtracting 97 to $t3 which get us our index
    	# for the stack array
    	# Let's load in 97 in $t4
    	li $t4, 97

    	# Then we will subtract $t3 with $t4 and store it back in $t3
    	sub $t3, $t3, $t4

    	# Now we have our offset of the index in the runtime stack in $t3
    	# We just have to add it with $sp to get our real address for the
    	# byte that we are suppose to increment by $t2
    	add $t3, $t3, $sp

    	# Then we get the value that is inside of that byte first store it in $t4
    	lbu $t4, 0($t3)

    	# We add $t2 to $t4
    	add $t4, $t2, $t4

    	# Then we put it back in $t3
    	sb $t4, 0($t3)

    	# Now we have to increment our counters
    	addi $t0, $t0, 1

    	# And subtract our repetition counter by 1
    	addi $t2, $t2, -1

    	# And jump back up the loop
    	j for_loop_to_add_repetition

    finished_loop_to_add_repetition:
    # If we are here then that means our runtime stack contains the number of times we are suppose
    # append each letter into plaintext_alphabet
    # Now we have to loop through our runtime stack array and append as many times
    # of the ascii value that is associated with that index onto $a0
    # It will be a nested for loop

    # First because at the 62 position of $a0 in the plaintext_alphabet it must be null terminated
    # Let's just do that right here to get it out of the way
    sb $0, 62($a0) # Storing a null terminator at the [62] position of the plaintext_alphabet

    # Let's set up our counters for the nested for loops first
    li $t0, 0 # This is our counter for the outer for loop

    # We will put our stopping condition 26 into $t2 because there is 26
    # element in the runtime stack array, so the outer loop need to traverse from 0 to 25
    li $t2, 26

    for_loop_appending_repetition_letters_outer:
    	# This is our outer loop let's do the stopping condition first
    	# This will allow us to go from 0 to 25 inclsuive that represent the runtime stack array index
    	bge $t0, $t2, finished_append_repetition_letters_outer

    	# So before going into the inner loop we have to get the number that is in the
    	# runtime stack array which represents the stopping condition for our inner loop
    	# We have to get the effective address first, then we add $t0 with $sp and store it into $t3
    	add $t3, $t0, $sp

    	# $t3 have our effective address of the repetition element
    	# Let's load it and store it in $t3
    	lbu $t3, 0($t3)

    	# Now $t3 is our stopping condition, if it is 1 then we only append 1 time 0
    	# if it is 3 then we append 3 times, 0 to 2
    	# if it is 9 then we append 9 times, 0 to 8
    	# so on and so forth
    	# We will put the inner loop counter in $t1 and initialize it 0
    	li $t1, 0

    	# Now before we go in let's get the letter that we are suppose to be appending
    	# This can be done through adding 97 to outer loop index
    	# Let's store it in $t4 97 first then we will add $t0 into it
    	li $t4, 97

    	# Then we add $t4 with $t0 which gives us the letter that we have to append in the inner loop
    	add $t4, $t4, $t0

    	for_loop_appending_repetition_letters_inner:
    		# Then we can go into the inner for loop
    		# Let's knock our stopping condition out of the way first
    		# Our counter starts at 0, stopping condition can be 1...9 representing
    		# How many times we need to iterate
    		# Once the counter hits $t3 then we stop because we already appended enough times
    		bge $t1, $t3, finished_appending_repetition_letters_inner

    		# Now if we are here we store $t4 in $a0
    		sb $t4, 0($a0)

    		# After we finish storing it we must increment $a0 to move onto the next
    		# location to put our alphabet
    		addi $a0, $a0, 1

    		# Then after we add to plaintext_alphabet we have to increment our inner loop counter
    		addi $t1, $t1, 1

    		# Then we just have to jump back up to the inner loop
    		j for_loop_appending_repetition_letters_inner

    	finished_appending_repetition_letters_inner:
    	# Now if we are here then that means we are finished appending that specific letter
    	# number of times according to the runtime stack array
    	# Then we have to increment our outer loop counter
    	addi $t0, $t0, 1

    	# Then jump back up to the outer loop
    	j for_loop_appending_repetition_letters_outer

    finished_append_repetition_letters_outer:
    # Then if we are here then it is essentially done, we are done with the problem!

    # Don't forget to deallocate the 26 byte of space we have used in the runtime stack
    addi $sp, $sp, 26 # Deallocating the 26 byte

    # Then we can return to main everything gucci
    jr $ra

encrypt_letter:
    # If we are here then that means we have to substitute the given plaintext letter
    # along with its index value that it appeared in the plaintext message to one of the
    # letter in the ciphertext, using the plaintext_alphabet
    # We will only consider mapping if the given plaintext letter is a lowercase letter
    # which have the ascii value from 97 to 122 inclusive. If we have to map the letter
    # We have to find the length of the entire string that consist of that letter in the plaintext_alphabet
    # and the start of that letter in the plaintext_alphabet before we can actually do the mapping
    # to which of the ciphertext_alphabet

    # $a0 -> contains the plaintext_letter which is the one we are substituting
    # we have to make sure that it is lowercase or else we return -1
    # $a1 -> contains the letter_index which is where the plaintext_letter belongs in the plaintext message
    # it is an non-negative integer. We will be using to do the modulous to determine which letter
    # we map it into
    # $a2 -> contains the plaintext alphabet, the 62 character String alphaet that we are using to encrypt
    # this plain_text letter. It will tell us which letter from ciphertext we can use to substitue
    # $a3 -> contains the ciphertext_alphabet, the 62 character String that have the letter for each plaintext
    # letter to be mapped to. This is the String that we are using to get the actual
    # encryped letter
    # Output -> $v0, we return in $v0 the encryped letter or -1 if plaintext_letter is not lowercase!

    # So obviously we have to get the base case out which is when
    # plaintext_letter is not a lowercase letter which is ascii value from 97 to 122 inclusive
    # Let's load 97 and 122 into register $t0 and $t1 respectively
    li $t0, 97 # Contain 'a'
    li $t1, 122 # Contain 'z'

    # This means that the plaintext_letter's ascii value is less than 97
    # Which means that it can never be a lowercase letter
    blt $a0, $t0, is_not_lowercase_plaintext_letter

    # We branch if the plaintext_letter's ascii value is greater than 122
    # Which means that it can never a lowercase letter
    bgt $a0, $t1, is_not_lowercase_plaintext_letter

    # Now if we are here then the plaintext letter is actually a lowercase
    # Which means that we have actual work to do for the encryption
    # We must figure out the index of where the plaintext_letter starts and ends
    # before we can figure out which letter it maps to in the ciphertext_alphabet
    # Let's use a for loop to determine whether $a0 starts in the plaintext_alphabet
    # $t0 will be our index answer containing the beginning of where plaintext_alphabet starts
    li $t0, 0 # Our index counter

    # Now we have to load in the first letter in $a2 first before going into the while loop
    # We will load it in $t1
    lbu $t1, 0($a2)

    # Instead of incrementing $a2 we will make a copy of it in $t7 and increment that address
    # instead so $a2 will stay in tact
    move $t7, $a2

    # So we are going to do a while loop for finding the beginning idnex of the plaintext_letter
    # We are guranteeded to find one because plaintext_alphabet contains all the lowercase
    while_loop_to_find_plaintext_letter_start:
    	# Let's do the stopping condition first, which is when
    	# our current letter is equal to the plaintext_letter, then that means we have found
    	# the starting index of that letter at $t0
    	beq $t1, $a0, finished_find_plaintext_letter

    	# But if we are here then that means $t1 isn't equal to the plaintext_text letter so we have to load
    	# in the next plaintext_alphabet letter
    	# So first we increment $t7 because that is our address pointer for $a2
    	addi $t7, $t7, 1

    	# Then we load in the byte that is at $t7 into $t1
    	lbu $t1, 0($t7)

    	# Then we also have incremnet our index counter
    	addi $t0, $t0, 1

    	# Then we jump back up the loop
    	j while_loop_to_find_plaintext_letter_start

    finished_find_plaintext_letter:
    # If we are here then that means the previous for loop have
    # found where the plaintext_alphabet starts in $t0
    # Now we have to find where the index ends in order to figure out
    # where the chain of plaintext_letter ends in order to get the length
    # Which will be another for loop
    # Our initial counter will be the value that is inside $t0 which we will put in
    # $t1 as our end counter, we don't want to overwrite the precious start index we just found
    move $t1, $t0

    # Now $t1 is where plaintext_letter begins we have to find where it ends so the end
    # condition is whenever the letter we are at are not equal to the plaintext_letter
    # We will be using another while_loop
    while_loop_to_find_plaintext_letter_end:
    	# Let's do our stopping condition first
    	# We load in the letter we are currently at right now, to do that
    	# we have to get the effective address which we can do by adding
    	# $t1 with $a2 and let's store it in $t2
    	add $t2, $t1, $a2

    	# Then we load in the character into $t3
    	lbu $t3, 0($t2)

    	# Now we do our stopping condition here, if $t3 is not equal to the plaintext_letter then
    	# We stop
    	bne $t3, $a0, finished_find_plaintext_letter_end

    	# But if we are here then we are going to check whether the next letter
    	# is still a plaintext_letter
    	# We will increment $t1 counter
    	addi $t1, $t1, 1

    	# Then we jump back up the loop
    	j while_loop_to_find_plaintext_letter_end

    finished_find_plaintext_letter_end:
    # Now if we are here $t1 contains the first letter that is isn't our plaintext_letter
    # So we get the actual last index of where plaintext_letter ends we have to subtract by 1
    addi $t1, $t1, -1

    # Okay! We have $t0 which is where plaintext_letter starts in plaintext_alphabet
    # We have $t1 which is where plaintext_letter ends in plaintext_alphabet
    # We can get the length of the by subtracting $t1 - $t0 and adding 1, the length is important
    # to figure out which ciphertext_alphabet we are mapping it to
    sub $t2, $t1, $t0

    # Then we add 1 to $t2 to get the length
    addi $t2, $t2, 1

    # Okay! We have where the letter begins, where it ends, and the length which is what k+1 is
    # We just have to do some computation to figure out the index of the letter we have to return
    # We will put that result index in $t3
    # First we have to mod $a1 by the length to get letter_index mod (k+1)
    # This can be done by div
    div $a1, $t2 # letter_index mod (k+1)

    # We put the remainder in $t4
    mfhi $t4

    # Then to get the index we are suppose to replace we add $t0 with $t4 and put it in $t3 as our
    # result index of the ciphertext_alphabet
    add $t3, $t0, $t4

    # Then we just have to actually get the letter and put it into $v0 and we are DONE!
    # We get the effective adderss by adding $a3 with $t3
    add $t3, $t3, $a3

    # Then we can put the byte that we load into $v0 directly
    lbu $v0, 0($t3)

    # And we are done! We can jump to exit
    j finished_encrypt_letter_exit

    # Make sure we jump here so we don't accidently overwrite the $v0 if it is actually
    # lowercase letter

    is_not_lowercase_plaintext_letter:
    # Now we jump here if the plaintext_letter is not lowercase and
    # we load in -1 into the $v0 as the return value because we can't
    # do any encryptions other than a lowercase letter
    li $v0, -1

    # There is no need to deallocate anything because we didn't use the runtime stack
    # Let's test it!

    finished_encrypt_letter_exit:
    # Then we jump back to the main
    jr $ra

encrypt:
    # This function will encrypt a plaintext message
    # It will return two integers in which we will have to keep track of throughout
    # the function calls

    # $a0 -> Ciphertext, where we putting our encrypted text
    # $a1 -> Plaintext, the null terminated String that we want to encrypt
    # $a2 -> Keyphrase, how to we going toget our ciphertext_alphabet
    # $a3 -> Corpus, for the frequency to generate the plain_text alphabet

    # Before we make the function calls lets save these address of String into the
    # So we are going to use 5 $s registers therefore we have to allocate a total of
    # 20 bytes of runtime stack memory to store those $s registers before we can unlock them for our use
    # Then we also have to allocate 4 more byte for our return location when we call the serveral functions
    # or else encryption won't know how to return to the main
    addi $sp, $sp, -24 # Allocating 24 byte of memory

    sw $s0, 0($sp) # Saving the $s0 register
    sw $s1, 4($sp) # Saving the $s1 register
    sw $s2, 8($sp) # Saving the $s2 register
    sw $s3, 12($sp) # Saving the $s3 register
    sw $s4, 16($sp) # Saving the $s4 register

    # Now we have unlocked the 4 register we us to store the different arguments
    move $s0, $a0 # $s0 have the Ciphertext
    move $s1, $a1 # $s1 have the Plaintext
    move $s2, $a2 # $s2 have the Keyphrase
    move $s3, $a3 # $s3 have the Corpus

    # Then we also have to store the $ra on the stack as well
    sw $ra, 20($sp)

    # Now everything is clear we can make the function calls right now
    # We are going to make several function calls throughout the encryption
    # The first step is to call to_lowercase on both Plaintext and Corpus
    # We move $s1 into $a0 for turning Plaintext into lowercase
    move $a0, $s1

    # We call the to_lowercase on Plaintext
    jal to_lowercase

    # Now if we are here then we know that Plaintext is turned into lowercase

    # Then we have to also call to_lower on Corpus
    # So we move $s3 into $a0 for turning Corpus into lowercase
    move $a0, $s3

    # Then we call the to_lowercase on Corpus
    jal to_lowercase

    # If we are here then Corpus is turned into lowercase
    # First step is complete

    # Onto step two in which we have to allocate 26 word in the runtime stack
    # 26 word is equal to total of 104 bytes, please don't forget to deallocate this later
    addi $sp, $sp, -104

    # Step three!
    # Using this new memory that we just have allocated we have to call the
    # count_lowercase_letters function. Which takes two arguments
    # $a0 -> A 26 word array that stores the count of each letter, only counting lowercase ignoring all others
    # $a1 -> Is the corpus
    # So this is the function call we are doing count_lowercase_letters(counts, corpus)
    # For $a0 we just have to give $sp because that is total of 104 bytes
    move $a0, $sp # The first argument which is the 26 word array in our runtime stack
    move $a1, $s3 # This is the corpus after being turned into lowercase

    # Calling the count_lowercase_letters function
    jal count_lowercase_letters

    # Now if we are here then in the 26 word or 104 byte we have allocated we have the counts of
    # the 26 letters stored in each word separately

    # Step FOURRRRR!
    # Before we allocate the 28 byte of free memory let's save the current $sp address in
    # register $t0 because this is going to the $a1 argument in step FIVE!
    move $t0, $sp

    # Then we are going to allocate at least 27 bytes of memory on the stack to store the String
    # returned by sort_alphabet_by_count. We have to round it to the next word which make it into 28 byte
    addi $sp, $sp, -28

    # Step FIVE!
    # We will be calling sort_alphabet_by_count
    # $a0 will be $sp because that is the 28 byte we have just allocated in step FOUR
    # $a1 will be counts array which we took the liberty to save in step FOUR which is $t0
    move $a0, $sp # The first argument which is the 28 byte of space for function to store the sorted alphabets
    move $a1, $t0 # The second argument is the counts that it is going to use to make the sorted alphabets

    # Calling the sort_alphabet_by_count function
    jal sort_alphabet_by_count

    # Now at those 28 byte of memory we have the sorted alphabet generated from sort_alphabet_by_count

    # Onto step Six
    # Before we allocate the 64 byte of free memory let's save the current $sp address again
    # because lowercase_letters will be one of the arguments in step seven so we need this address to be saved
    # We will save it in register $t0
    move $t0, $sp

    # Then we will have to allocate at least 63 byte of memory this is going to be use to store
    # the plaintext_alphabet generated when we call generate_plaintext_alphabet
    # We have to round up to a word so we have to do 64 byte instead of 63
    addi $sp, $sp, -64

    # Step SeVeN
    # This step we will call generate_plaintext_alphabet
    # $a0 -> plaintext_alphabet which is the current $sp
    # $a1 -> lowercase_letters which we have saved in step six in $t0
    move $a0, $sp # The first argument is the location of where we will be putting the plaintext_alphabet which is $sp
    move $a1, $t0 # The second arugment is the lowercase_letters which we have saved in $t0

    # Then we can just call the function
    jal generate_plaintext_alphabet

    # Step EIGHT
    # We have to allocate at least 63 byte of memory to store ciphertext_alphabet
    # again we round it up to 64 byte
    addi $sp, $sp, -64

    # Step nine
    # In this step we have to call on generate_ciphertext_alphabet
    # $a0 -> is the place where we will be writing the ciphertext_alphabet which is just $sp
    # $a1 -> second argument is the keyphrase which is $s2
    move $a0, $sp # First argument is our place to store ciphertext_alphabet which is $sp
    move $a1, $s2 # Second arugment is our keyphrase which is in $s2

    # Then we can just call the function
    jal generate_ciphertext_alphabet

    # Step TEN!
    # In a loop we have to loop over the plaintext, we call encrypt_letter on each lowercase letter
    # if the letter is not lowercase then we just have to write it into ciphertext, don't call encrypt_letter.
    # If it is the return ascii value we write it into ciphertext
    # Because plaintext will be null terminated we can have the stopping condition when it
    # hits the null terminator
    # We will be storing the loop counter in $s2 because we need that inorder to call the function
    # And since we are going to be calling function our counters needs to be preserved
    li $s2, 0 # We don't need the address of the corpus anymore so we can overwrite that with our counter

    # Now for this for loop we also have to have 2 counters
    # One in $s3, since we don't need corpus anymore to keep track of the number of lowercase we encrypted
    # One in $s4, to keep track of number of lowercase we didn't encryped but simply appended
    li $s3, 0 # Counte for letter that did encrypt
    li $s4, 0 # Counter for letter didn't encrypt

    # This is the for loop to encrypt each letter in the plaintext
    for_loop_to_encrypt_each_letter:
    	# Let's get each letter from the plaintext and put it in $t0
    	lbu $t0, 0($s1)

    	# As long as $t0 is not the null terminator we will do work on each letter
    	beq $t0, $0, finished_encrypting_each_letters

    	# If we are here then that means we have to encrypt the symbol we got
    	# We have to make sure it is a lowercase letter before calling the function
    	li $t1, 97 # Ascii value for 'a'
    	li $t2, 122 # Ascii value for 'z'

    	# If the ascii of the character is less than 97 then it is definitely not a lowercase
    	# then we don't have to call the encrypt function on it just append it in ciphertext
    	blt $t0, $t1, encrypt_not_lowercase_just_append

    	# If the ascii of the character is greater than 122 then it is defintely not a lowercase
    	# we don't have to call encrypt function we just have to append it in ciphertext
    	bgt $t0, $t2, encrypt_not_lowercase_just_append

    	# If we are here then that means that $t0 is indeed a lowercase which we have to call
    	# encrypt_letter on it. But before we call it we have to prepare the arguments first
    	# $a0 -> is just $t0 because it is the character we want to encrypt from the plaintext
    	# $a1 -> is the index that the plaintext letter which is $s2
    	# $a2 -> is the plaintext_alphabet which can be obtained by adding 64 byte to $sp
    	# $a3 -> is the ciphertext_alphabet which is just $sp
    	move $a0, $t0 # First argument which is the plaintext_letter
    	move $a1, $s2 # Second argument which is the plaintext_letter index
    	move $a3, $sp # Fourth argument which is the ciphertext_alphabet's address

    	# Now to get the plaintext_alphabet's address we have to add 64 byte to $sp
    	# We do that and put it in $t3
    	addi $t3, $sp, 64

    	# Then we move into $a2
    	move $a2, $t3 # Third argument which is the plaintext_alphabet's address

    	# Now everything is in place we can call the encrypt_letter function
    	jal encrypt_letter

    	# If we are here then that means $v0 contains the suppose encrypted letter of the plaintext
    	# We have to store that into $s0 which is the ciphertext
    	sb $v0, 0($s0)

    	# After we store it we have to increment our index counter
    	addi $s2, $s2, 1

    	# We also have to increment our ciphertext address to move it to the next position
    	addi $s0, $s0, 1

    	# We need to also also increment the plaintext address to look at the next character for encryption
    	addi $s1, $s1, 1

    	# Then we also have to increment the $s3 because we encrypted a letter
    	addi $s3, $s3, 1

    	# Then we jump back up the loop to work on the next letter in plaintext
    	j for_loop_to_encrypt_each_letter

    	encrypt_not_lowercase_just_append:
		# If we are here then that means the letter we received is not a lowercase
		# In this case we just have to append $t0 to the ciphertext
		sb $t0, 0($s0)

		# Then we increment the index counter
		addi $s2, $s2, 1

		# Increment the ciphertext address
		addi $s0, $s0, 1

		# Increment plaintext address
		addi $s1, $s1, 1

		# Increment $s4 because we didn't encrypt a letter
		addi $s4, $s4, 1

		# Then jump back up to the loop
    		j for_loop_to_encrypt_each_letter

    finished_encrypting_each_letters:
    # Then if we are here we have to null terminate the ciphertext
    # Which we can just do by adding a null terminator at 0($s0)
    sb $0, 0($s0)

    # Finally we can move the return value
    # Remember $s3 have the number of letters that are encrypted
    # $s4 have the number of letters that are just appended
    move $v0, $s3
    move $v1, $s4

    # Then we are done! Now we have to deallocate everything we have used
    # And restore all the registers we have used

    # We have to deallocate 260 byte first so we can get our stack pointer back to the $s registers
    # that is saved on the stack
    addi $sp, $sp, 260

    # We have to restore all of the $s registers we have used in our function
    lw $s0, 0($sp) # Restoring the $s0 register
    lw $s1, 4($sp) # Restoring the $s1 register
    lw $s2, 8($sp) # Restoring the $s2 register
    lw $s3, 12($sp) # Restoring the $s3 register
    lw $s4, 16($sp) # Restoring the $s4 register

    # We also have to make sure to restore the $ra from the runtime stack or else encrypt won't
    # know where to return to
    lw $ra, 20($sp) # Restoring the $ra for encrypt after all these inner function calls

    # Then we deallocate rest of the 24 byte we have used for the registers
    addi $sp, $sp, 24

    # Then we can just return and done with this function!
    jr $ra

decrypt:
    # If we are here then we are in our final problem which is to decrypt the message
    # that we have just encrypted. The process if extremely simialr to encryption
    # the only differences is when we decrypt each letter

    # $a0 -> Plaintext, which is the place where we are going to store the decrypted message
    # $a1 -> Ciphertext, which is where the encrypted text String is stored we have to decrypt
    # this String throughout this function
    # $a2 -> Keyphrase, which is the keyphrase string that we are going to use to make our ciphertext_alphabet
    # $a3 -> Corpus, this is what we going to use to make our plaintext_alphabet
    # Now we have to store all these functions onto the $s registers because we are going to
    # call several functions throughout this functions and we don't want to lose these arguments
    # Because we have four arguments it means that we need to unlock four $s registers
    # In addition we also have to store the $ra of decrypt or else when we call inners function inside
    # decrypt won't know where to return to. So 4 $s registers needs 16 byte, plus 4 more byte for $ra makes a total of 24 bytes
    addi $sp, $sp, -24 # Allocating 24 bytes of memory in the runtime stack

    # Then we just have to store each registers into the runtime stack
    sw $s0, 0($sp) # Storing register $s0
    sw $s1, 4($sp) # Storing register $s1
    sw $s2, 8($sp) # Storing register $s2
    sw $s3, 12($sp) # Storing register $s3
    sw $s4, 16($sp) # Storing register $s4

    # And we also store our $ra address
    sw $ra, 20($sp)

    # And we move each of the arguments into the $s registers
    move $s0, $a0 # $s0 have the Plaintext
    move $s1, $a1 # $s1 have the Ciphertext
    move $s2, $a2 # $s2 have the Keyphrase
    move $s3, $a3 # $s3 have the Corpus

    # Now everything is backup we can proceed to do our steps
    # Step ONE!
    # We must call to_lowercase on the corpus
    # to_lowercase takes the starting address of the String that we want it to convert to lowercase
    # So we can just move $s3 into $a0, turning the corpus into lowercase
    move $a0, $s3

    # Here we are calling the to_lowercase function on the corpus
    jal to_lowercase

    # Onto Step two!
    # We have to allocate at least 26 word of memory on the runtime stack
    # This is used for the count array that is needed for the count_lowercase_letters function
    # Since it is 26 words we have to allocate total of 104 bytes
    addi $sp, $sp, -104 # Allocating 104 bytes of memory in the runtime stack or 26 words

    # Step THREE!
    # $a0 -> this is just $sp because that is the space we have just allocated in the previous step
    # $a1 -> this is takes the corpus which is $s3
    move $a0, $sp # First argument which is the array that we allocated which in the previous step
    move $a1, $s3 # Second argument is the corpus which is just from $s3

    # Then now we can just call the count_lowercase_letters function
    jal count_lowercase_letters

    # Step FOUR!
    # We have to allocate at least 27 byte of memory for lowercase_letters that is for
    # sort_alphabet_by_count. We have to round it up to 28 byte
    # Now before we allocate the 28 byte of memory we have to save the $sp in $t0
    # So we can have a reference to counts array when we are calling sort_alphabet_by_count
    move $t0, $sp # Saving a copy of the current stack pointer that is pointing to counts

    addi $sp, $sp, -28 # Allocating 28 byte of memory in the runtime stack

    # Step five
    # Here we will be calling sort_alphabet_by_count
    # $a0 -> lowercase_letters, which will just be $sp
    # $a1 -> counts, we have saved a copy in $t0 already
    move $a0, $sp # First argument, lowercase_letters space for storage
    move $a1, $t0 # Second argument, counts

    # Calling the actual function
    jal sort_alphabet_by_count

    # Step six
    # We have to allocate 63 byte of memory on the stack for plaintext_alphabet
    # We round it up to 64 byte, and before we allocate we have to save the current
    # $sp because that is for lowercase_letter that we need to pass into the function as well
    move $t0, $sp # Saving current $sp as a copy, it refers to the lowercase_letter

    addi $sp, $sp, -64 # Allocating 64 byte of memory for the plaintext_alphabet

    # Step seven
    # Actually calling the generate_plaintext_alphabet method
    # $a0 -> this is the plaintext_alphabet which is the current $sp
    # $a1 -> this is the lowercase_letter which is $t0 that we have saved
    move $a0, $sp # First argument, plaintext_alphabet
    move $a1, $t0 # Second argument, lowercase_letter

    # Calling the generate_plaintext_alphabet
    jal generate_plaintext_alphabet

    # Step eight
    # Alloacting 63 byte of memory for the ciphertext_alphabet
    # We round it to 64
    addi $sp, $sp, -64

    # Step nine
    # We have to actually call generate_ciphertext_alphabet
    # $a0 -> is the current $sp
    # $a1 -> is ths keyphrase which is stored in $s2
    move $a0, $sp # First argument, ciphertext_alphabet
    move $a1, $s2 # Second argument, keyphrase

    # Calling the function
    jal generate_ciphertext_alphabet

    # Step 10!
    # Through a loop we have to decrypt each of the letter in ciphertext
    # and write the decrypted character onto plaintext
    # If the character we look at in ciphertext is not an alphabet, just append it in plaintext
    # We don't need to do any decryption on it

    # Algorithm to decrypt, it is actually very simple, call index_of each alphabetical character
    # you have encounter in ciphertext, then you will get a index back, just add that index to
    # plaintext's address then you will get the letter that is replaced by that encrypted letter
    # Since we don't need the keyphrase and corpus's address anymore we can use $s2 and $s3 registers
    # $s2 will keep track of those alphabet we decrypted
    # $s3 will keep track of those non-alphabet that we just copy into plaintext
    li $s2, 0
    li $s3, 0

    # We will use $t0 as our variable to store each character in ciphertext
    # We will increment the ciphertext's position using $s4, $s1 stores the start position
    move $s4, $s1 
    
    # Loading in the first character
    lbu $t0, 0($s4)

    # This for loop is going through each ciphertext's letter
    for_loop_decrypting_each_letter:
        # This is the stopping condition for the for loop, once we hit null terminator on ciphertext we stop
        beq $t0, $0, finished_decrypting_each_letter
        
        # If we are here then we must check whether or not the character is a letter or a number
        # not just a lowercase letter but also uppercase
        # We will be putting every comparsion value inside $t1
        li $t1, 48 # 0
        
        # The letter is less than 48 can't be digit
        blt $t0, $t1, decrypt_not_alphabet_letter
        
        li $t1, 57 # 9
        
        # The letter is greater than 57 so it can't be digit but it could be upper
        bgt $t0, $t1, decrypt_check_for_uppercase
        
        # If we are here then that means it is a digit we can decrypt the letter
        j proceed_to_decrypt_word
        
        decrypt_check_for_uppercase:
        # If we are here then it is greater than 57
        li $t1, 65 # A
        
        # The letter is less than 65 can't be alphabet
        blt $t0, $t1, decrypt_not_alphabet_letter
        
        li $t1, 90 # Z
        
        # The letter is greater than 90 can't be upper but could be lowercase
        bgt $t0, $t1, decrypt_check_for_lowercase
        
        # If we are here then it is uppercase letter
        # Hence we decrypt the word
        j proceed_to_decrypt_word
        
        decrypt_check_for_lowercase:
        # Just because it is greater than 90 doesn't mean it can't be a lowercase ascii value hence we have to check
        li $t1, 97 # a
        
        # Letter is less than a can't be lowercase
        blt $t0, $t1, decrypt_not_alphabet_letter
        
        li $t1, 122 # z
        
        # Letter is greater than 122 can never be a lowercase letter
        bgt $t0, $t1, decrypt_not_alphabet_letter
        
        # Now if we are here then we can proceed to decrypt the given letter
        proceed_to_decrypt_word:
        # We must call index_of in here which takes in 3 arguments
        # $a0 -> String which is our ciphertext_alphabet $sp
        # $a1 -> the letter to index for which is just $t0
        # $a2 -> the start index we can just put 0 to look for it from the start
        move $a0, $sp # First argument, the String to index the letter in
        move $a1, $t0 # Second argument, the letter to index for         
        li $a2, 0 # Thrid argument, look from the start    
        
        # Now we can call the function
        jal index_of
        
        # Right here we have the index of that letter in $v0
        # What we do with that index is to add it to the plaintext_alphabet to get the effective address
        # of the decrypted letter. To get to plaintext we have to add 64 byte to the $sp
        # Let's store the plaintext_alphabet in $t2
        
        move $t2, $v0
        addi $t3, $sp, 64
        add $t2, $t2, $t3
        
        # Now we load in the byte to get the letter
        lbu $t2, 0($t2)
        
        # Then we store it in plaintext
        sb $t2, 0($s0)
        
        # Increment plaintext's address too
        addi $s0, $s0, 1
        
        # Increment the address of ciphertext
        addi $s4, $s4, 1
        
        # We load in the byte again
        lbu $t0, 0($s4)
        
        # We increment $s2 because it is alphabet or number
        addi $s2, $s2, 1
        
        # Jump back up the loop
        j for_loop_decrypting_each_letter
        
        decrypt_not_alphabet_letter:
        # This is the easier case where we just append the letter into the plaintext
        sb $t0, 0($s0) # Appending the non-alphabet letter into plaintext as it is
        
        # increment address of plaintext
        addi $s0, $s0, 1
        
        # Then we increment the address of the ciphertext
        addi $s4, $s4, 1
        
        # And we load the byte in again
        lbu $t0, 0($s4)
        
        # We have to increment $s3 since is non-alphabet
        addi $s3, $s3, 1
        
        # Then jump back up the loop
        j for_loop_decrypting_each_letter

    finished_decrypting_each_letter:
    # If we are here then that means we have finished decrypting each letter in ciphertext
    # Step 11 null terminate plaintext
    sb $0, 0($s0)
    
    # And don't forget our return values
    move $v0, $s2 # Counts for the decrpted letters
    move $v1, $s3 # Counts for the non-decrypted letters
    
    # Now we begin our clean up process
    
    # First deallocate all the memory we used up until the saved registers
    addi $sp, $sp, 260
    
    # Then we have to restore each of the $s registers that we have used
    lw $s0, 0($sp) # Restoring register $s0
    lw $s1, 4($sp) # Restoring register $s1
    lw $s2, 8($sp) # Restoring register $s2
    lw $s3, 12($sp) # Restoring register $s3
    lw $s4, 16($sp) # Restoring register $s4

    # Don't forget we have to restore our $ra for decrpytion or else it won't
    # know where to return to
    lw $ra, 20($sp) # Restoring the return address for decryption

    # Then we have to deallocate the 24 byte of memory we have used
    addi $sp, $sp, 24

    jr $ra

############################## Do not .include any files! #############################

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
