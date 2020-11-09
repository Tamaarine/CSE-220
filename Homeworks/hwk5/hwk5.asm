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
