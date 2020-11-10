# erase this line and type your first and last name here in a comment
# erase this line and type your Net ID here in a comment (e.g., jmsmith)
# erase this line and type your SBU ID number here in a comment (e.g., 111234567)

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################

.text

init_list:
   # This function is just reset the given card_list's head
   # and size field to 0 that's all nothing more nothing less
   
   # $a0 -> The starting address of a 8 byte buffer of unitialied memory
   # which we have to rest both 2 words to 0 to
   
   # So there are two words in this starting address, 0($a0) = size
   # 4($a0) = The 4 byte address to the first node in our linked-list
   # all we have to do is reset both of them to 0 that's it
   sw $0, 0($a0) # Reset size to 0
   sw $0, 4($a0) # Reset head to 0
   
   # Then we are done and can just return back to the caller
   jr $ra

append_card:
   # This function takes in the address of a card_list which has the size and the
   # head field at that address. We need to append the given card to the end of it
   # by linking the last card of card_list's next to the given card
   
   # $a0 -> The address of a valid card_list struct which could be empty, meaning that
   # it could be empty, the size is 0 and the head is 0 representing a null node
   # $a1 -> The integer that encodes a playing card we can assume the card is always valid
   # Output -> $v0, Returns the size of card_list after appending the new card
   
   # Before we allocate the memory we have to move the arguments 
   # because we will be loading in immediates into $a0, let's save the two arguments into
   # $t5 and $t6 for now
   move $t5, $a0 # $t5 saves the address to the valid card_list
   move $t6, $a1 # $t6 saves the integer that represents the valid card we adding
   
   # So the first thing we must do is to allocate memory for that new CardNode by using
   # syscall 9
   li $a0, 8 # We are allocating 8 bytes of memory on the heap
   li $v0, 9 # syscall for allocating memory on the heap
   syscall
   
   # Then after we do the syscall we can restore it back
   move $a0, $t5 # Moving back the valid card_list
   move $a1, $t6 # Moving back the integer that represent the card we storing
   
   # Now in $v0 we have the starting memory address of where that 8 byte is located in the heap
   # that we just allocated
   # We have to put our given card information into the CardNode we have just created
   # by storing that word into 0($v0), because the first word in CardNode represent the card's information
   sw $a1, 0($v0) # Putting the given card's information in the CardNode
   sw $0, 4($v0) # We also have to put 0 in the CardNode's next node because it is not linked to anything
   
   # Then we have to find the tail node from the card_list which we will be doing through a for loop
   # but we have to handle some special cases such as when the head is empty, meaning no card is in the
   # list yet, and when there is at least one element in the list
   # We can check for empty head by checking for the size, if the size is 0 then we know the head is empty
   # else if the size is 1 or more then we know there is a tail which we can find through a for loop
   
   # Let's check the the case when the head is empty, we just have to set the head to be $v0
   # if that is the case and increment the size by 1
   # We will load the head into $t0
   lw $t0, 4($a0) # Loading the head's address from the card_list
   
   # If we take this branch that means the card_list is completely empty
   beq $t0, $0, empty_card_list
   
   # However, if we didn't take the branch that means the card_list is not empty
   # and we have to find the last card of the list and we begin our search starting from the head
   # we will put the current node we have at $t0
   
   # We will be using a for loop to find the last card from the card_list
   for_loop_to_find_last_card:
   	# Let's just get the stopping condition out of the way
   	# which is whenever next is 0 in the current node, $t0
   	# Let's load in the next address from the current node, if the current node's next
   	# is 0 that means the current node is the tail node
   	# We will load the next of the current node into $t1
   	lw $t1, 4($t0) # Loading the next CardNode from the current CardNode
   	
   	# If we take this branch then that means the current node we have in $t0
   	# is the tail because the next of current node is 0
   	beq $t1, $0, finished_for_loop_to_find_last_card
   	
   	# However, if we are here then we have to go to the next CardNode
   	# We move the next CardNode as the current CardNode
   	move $t0, $t1 
   
        # Then we can jump back up the for loop
        j for_loop_to_find_last_card
   
   finished_for_loop_to_find_last_card:
   # If we reached here from the for loop that means we have found the
   # tail node from the linked list in $t0, we can just set the next
   # of the tail node to $v0
   sw $v0, 4($t0) # We set the tail node's next to be the CardNode we are adding
   
   # Don't forget to increment size by 1
   # Let's load the size of card_list into $t1
   lw $t1, 0($a0) 
   
   # We increment the size by 1
   addi $t1, $t1, 1
   
   # Then we store the word back into the card_list at 0($a0)
   sw $t1, 0($a0) 
   
   # Because we have to return the incremented sized as our return value we can just put
   # $t1 into $v0 as the output
   move $v0, $t1
   
   # Then we are essentially done with the algorithm and can jump to finished
   j finished_append_card_algorithm
   
   empty_card_list:
   # If we are here then that means the card_list we are given have no cards in it
   # therefore all we have to do is make the head be $v0 as the first CardNode
   sw $v0, 4($a0) # Setting the card_list's head as the CardNode that we just created
   
   # Then we can just set the size of the card_list to be 1 because we just added one CardNode to
   # the empty list, so the size must be 1
   li $t7, 1 # Load in 1 for storing
   
   # Storing 1 into the size of card_list
   sw $t7, 0($a0)
   
   # And we can just return 1 as our output value because from an empty list to
   # a list with a card is just size of 1
   li $v0, 1
   
   # Then we can just follow logically to finish this algorithm
   finished_append_card_algorithm:
   # Since we don't have anything to restore or deallocate we can just return to the caller
   jr $ra

create_deck:
   # This function creates a new card_list that have a total of 80 play cardss going from
   # 0x00645330 to 0x00645339 repeated total of 8 times
   
   # Output -> $v0, returns the card_list's address that have the 80 cards
   
   # Since we are going to be calling functions we have to save the return address
   # which will be 4 bytes. Add on another 20 bytes for total of 5 reigsters
   # hence total of 24 bytes
   addi $sp, $sp, -24 # Allocating 24 bytes of memory on the run time stack
   
   # Then we have to save the $s registers before we can use them
   sw $s0, 0($sp) # Saving the $s0 register
   sw $s1, 4($sp) # Saving the $s1 register
   sw $s2, 8($sp) # Saving the $s2 register
   sw $s3, 12($sp) # Saving the $s3 register
   sw $s4, 16($sp) # Saving the $s4 register
   
   # Saving the return address or else it won't know where to return
   sw $ra, 20($sp)   
            
   # Now we have to allocate 8 bytes of memory on the heap stack which will be used
   # to store the card_list struct, and used for calling init_list
   # We will be allocating that heap memory by doing syscall 9
   li $a0, 8 # Allocating 8 bytes of memory hence we put 8
   li $v0, 9 # Syscall for allocating memory on the heap
   syscall 
   
   # Now in $v0 we have the address of where that 8 byte memory start 
   # we will move that into $s0 to prevent losing it
   move $s0, $v0
   
   # Now before we can start adding those cards
   # we must initalize the card_list by calling init_list
   # $a0 -> The card_list that we want to initalize which is just $s0
   move $a0, $s0 # $a0 is the card_list that we want to initalize
   
   # Then we can call the function to actually initalize it
   jal init_list
   
   
   # Then next in order to add those 80 cards we need a for loop
   # that will be looping total of 80 times
   # $s1 will be our counter for the number of times we have added the cards
   li $s1, 0
   
   # $s2 will be our stopping condition which is whenever the card counter is greater than
   # or equal to 80 
   li $s2, 10
   
   # Then we have our card counter which will start on 0x00645330
   li $s3, 0x00645330
   
   # And the card to start looping back around whenever our card counter hits the
   # last card which is just 0x00645339
   li $s4, 0x00645339
   
   # Now we can begin our for loop to append these 
   for_loop_to_append_80_cards:
   	# Let's just get our stopping conditions out of the way
   	# which is whenever our counter for the number of cards is greater than or equal to 80
   	# that means we have append total of 80 cards already
   	beq $s1, $s2, finished_for_loop_to_append_80_cards
   	
   	# However, if we are here then that means we haven't finish appending the 80 cards yet
   	# and we have to append it right here
   	# Now right here we have to call append_card
   	# $a0 -> The card_list we are appending our cards to and is $s0
   	# $a1 -> The card we are appending which is just $s3
   	move $a0, $s0 # The card_list we are appending the card to
   	move $a1, $s3 # The card we are appending 
   	
   	# Then we can call the function append_card
   	jal append_card
   	
   	# Now after we append the card we have to increment our counter
   	# First our card number appended counter to signal that we have just append a card
   	addi $s1, $s1, 1
   	
   	# Then we also have to increment our card counter but we have to check
   	# whether or not the current card counter is the max, if it is max
   	# we have to loop back to 0x00645330
   	# So if we take this branch then that means our current card counter is at
   	# the last card, so we have to loop back around in order to increment it
   	beq $s3, $s4, loop_back_around_for_card_counter
   	
   	# However, if we are here then that means the current card counter isn't
   	# at max yet hence we just have to add 1 to the current card counter that's it
   	addi $s3, $s3, 1
   	
   	# And we jump to the next iteration
   	j next_append_80_card_iteration
   	
   	loop_back_around_for_card_counter:
   	# If we are here then we have to loop back to the start of the card counter 
   	# which is the first card, 0x00645330
   	li $s3, 0x00645330
   	
   	next_append_80_card_iteration:
   	# If we are here then we jump back up the loop for the next iteration
   	j for_loop_to_append_80_cards
   	
   finished_for_loop_to_append_80_cards:
   # Now if we are here then we have total of 80 cards appended to the card_list
   # Our return value is just $s0 the starting address of card_list struct
   move $v0, $s0
   
   # Andddd we are essentially done with the algorithm and we can start
   # restoring the registers and deallocating the memory
   
   # Restoring the $s registers we have used
   lw $s0, 0($sp) # Restoring the $s0 register
   lw $s1, 4($sp) # Restoring the $s1 register
   lw $s2, 8($sp) # Restoring the $s2 register
   lw $s3, 12($sp) # Restoringing the $s3 register
   lw $s4, 16($sp) # Restoring the $s4 register
   
   # We also have to restore the return address or else create_deck won't know where to return to
   lw $ra, 20($sp) 
   
   # Then we deallocate the memory we have used
   addi $sp, $sp, 24 # Deallocating the 24 bytes of memory we have used
   
   # And finally we can jump back to the caller
   jr $ra

deal_starting_cards:
   jr $ra

get_card:
    jr $ra

check_move:
    jr $ra

clear_full_straight:
    jr $ra

deal_move:
    jr $ra

move_card:
    jr $ra

load_game:
    jr $ra

simulate_game:
    jr $ra

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
