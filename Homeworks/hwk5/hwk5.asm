# Ricky Lu
# rilu
# 112829937

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
    li $s2, 80
    
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
        bge $s1, $s2, finished_for_loop_to_append_80_cards
        
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
    # This function deals 44 cards in order to each of the column of the cards
    # that is indexed from 0 to 8 inclusive. The first 35 cards are dealt
    # face down, so all the columns will receive 4 face down cards except the last column
    # which will only have 3 face down cards. Then it deals 9 more cards all face up
    # the first card is dealt to the last column first then it warps around to the first
    # column and finish it off. So in the end all column should have 5 cards except the
    # last column which only have 4 
   
    # $a0 -> Represents the board, which is an array of 9 pointers to 9 card_list which
    # represents 9 columns indexing from 0 to 8 respectively. They all have size and head of 0
    # $a1 -> This represent the deck of 80 cards that we have to distribute to the 9 columns
    
    # So we will be calling functions hence we have to save our arguments and our return address
    # meaning 12 bytes in total. Let's get 2 more $s registers so 8 more bytes total of 24 bytes
    addi $sp, $sp, -20 # Allocating 20 bytes of memory on the run time stack
    
    # Saving the $s registers before we can use them
    sw $s0, 0($sp) # Saving the $s0 register
    sw $s1, 4($sp) # Saving the $s1 register
    sw $s2, 8($sp) # Saving the $s2 register
    sw $s3, 12($sp) # Saving the $s3 register
   
    # Saving the return address or else deal_starting_card won't know where to return
    sw $ra, 16($sp)
    
    # Now we can save the arguments
    move $s0, $a0 # $s0 have the array of 9 pointers to the different column card_list
    move $s1, $a1 # $s1 have the card_list pointers for the 80 cards we have to deal
    
    # Okay here we need a for loop to add the first 35 cards onto each column in order
    # We need to keep a column counter to keep point to the column that we are adding
    # this card to, and we will get which column by modding by 9
    li $s2, 0 # $s2 will be the column counter starting with 0 meaning the first column
    
    # We also need our stopping condition which is whenever our column counter is greater than or equal to 35
    li $s3, 35
    
    # Now we will start our for loop to add the cards to each column from the deck
    for_loop_to_add_35_facedown_cards:
        # Let's just get the stopping condition out of the way
        # which is whenever our column counter is greater than or equal to 35
        bge $s2, $s3, finished_adding_35_facedown_cards
        
        # If we are here then that means we haven't finish dealing 35 cards
        # yet so we have to actually deal it
        # So first we have to get the column where to we deal the cards to first
        # which we can get my dividing our column counter by 9
        li $t7, 9 # 9 for division
        
        # Then we do the division
        div $s2, $t7
        
        # We can get our remainder from mfhi and let's put it into $t0
        mfhi $t0
        
        # Now we have to calculate the effective address of where that address is stored
        # in the board, which contain the array of 9 pointers to card_list
        # We can calculate it from this formula base_address + 4 * i
        li $t7, 4 # 4 for multiplication
        
        # Let's multiply the index with 4 and store the result into $t1
        mul $t1, $t0, $t7
        
        # Now in $t1 we have our offset we add the offset into $s0 to get
        # the effective address of where the address is stored in the board array
        # Let's put the effective address into $t0
        add $t0, $s0, $t1 
        
        # Now in $t0 we have the actual effective address that stores the pointer to
        # the card_list column we have to put our cards in let's load that address into $t1
        # so just to be clear $t1 is the actual address to the actual card_list where we are putting in
        # the card. $t0 is just the effective address of where this address is stored in the array
        lw $t1, 0($t0)
        
        # Then we can call append_card with this address to append our card
        # but before we do that we have to get the card that we are adding
        # which is just the head card from the deck. 
        # Hence let's load the head from the deck's card_list into $t2
        lw $t2, 4($s1) # Getting the address of the CardNode of where the head of the card_list is
        
        # Then to get the actual card we can just load the word at 0($t2)
        # and let's put it into $t3
        lw $t3, 0($t2) # This is loading the card's value from the CardNode
        
        # So let's recap what we have right now
        # In $t3 we have the card that we have to be put into the column
        # and in $t1 we have the address of the card_list where we are putting the card in
        # Now we can call append_card method to put the card into that column
        # $a0 -> The column where we are putting the card in which is just $t1
        # $a1 -> The card integer that we are putting into the column which is $t3
        move $a0, $t1 # Column that we are putting the card into
        move $a1, $t3 # Card integer that we are putting the column into
        
        # Now we can actually call the method to put the card in
        jal append_card
        
        # Now after the previous function call we have put the card in already
        # great we can start incrementing our column counters
        addi $s2, $s2, 1
        
        # And don't forget to remove the card we have dealt to the column by
        # moving the head to the next card
        # We have to get the address of the head first, let's put that into $t0
        lw $t0, 4($s1)
        
        # Then we get the next address of the head and put that into $t1
        lw $t1, 4($t0)
        
        # Then all we have to do is store the next address of the head into $s1's head
        # which basically removes the current head and points the head to the card after the current head
        sw $t1, 4($s1) # Removing the current head and make head the next card
        
        # Additionally we have to subtract 1 from the size of the deck because we have removed a card
        # Let's load the current size of the deck into $t0
        lw $t0, 0($s1)
        
        # We subtract 1 from it
        addi $t0, $t0, -1
        
        # And store that back into the size of the deck
        sw $t0, 0($s1)
        
        # Now we can jump back up the loop
        j for_loop_to_add_35_facedown_cards
    
    finished_adding_35_facedown_cards:
    # If we are here then we have finished adding the 35 facedown cards
    # now we have to add 9 more faceup cards starting at column 9 from the deck
    
    # Again we will have the same column counter but this time
    # we will start adding the faceup cards at column 8
    # which means our column counter will start at 8
    li $s2, 8
    
    # Now because we are going to be adding only 9 cards that means
    # our stopping condition will be 17, so whenever our column counter
    # is greater than or equal to 17 it stops
    li $s3, 17
    
    # Now we can start our for loop to add the faceup cards
    for_loop_to_add_9_faceup_cards:
        # Let's just get our stopping condition our of the way first
        # which is whenever our column counter is greater than or equal to the
        # max of 17
        bge $s2, $s3, finished_adding_9_faceup_cards
        
        # If we are here then that means we haven't finished dealing the 9 faceup
        # cards yet hence we have to actually deal it
        # So again let's get the column that we are appending these faceup card
        # to by dividing by 9
        li $t7, 9 # Loading in 9 for division
        
        # We will divide our column counter by 9
        div $s2, $t7
        
        # Then we store the remainder which is the index of where we have to put
        # the card into into $t0
        mfhi $t0
        
        # Then we have to calculate the effective address of where that address is stored
        # in the board. The board have array of total of 9 pointers we have to get toe
        # the effective address to get the address of card_list we have to add the card to
        # We can calculate this by doing
        # base_address + 4 * i
        li $t7, 4 # Load in 4 for multiplication
        
        # Then let's multiply the index by 4 and store the result into $t1
        mul $t1, $t0, $t7
        
        # So in $t1 we have the offset that we have to add to the board to
        # get the effective address of where the card_list column is stored
        # Let's add it to the board address and get our effective address and put that into $t0
        add $t0, $s0, $t1
        
        # So right now in $t0 we have the effective address that stores the pointer to the card_list
        # we will load the address and store it into $t1
        lw $t1, 0($t0)
        
        # Then we will be calling append_card and add the card into $t1
        # However, before we do that we have to get the faceup card that we are appending to this column
        # We can do so by getting the head from the deck and just load in the card value it has
        # Let's load in the head into $t2
        lw $t2, 4($s1) # Getting the address of where the head is store from card_list
        
        # Before we can get actual card value we have to turn it into faceup, because the deck comes
        # in facedown we have to manually switch the specific byte that controls whether the card
        # is faceup or facedown to faceup, and that byte is the third byte with index of 2
        # so this means 2($t2) controls whether or not the card is faceup or facedown
        # We have to turn that byte into 'u'and we just have to store the byte before we read it
        li $t7, 'u' # The byte to store into 2($t2) to make the card faceup
        
        sb $t7, 2($t2) # Storing 'u' into the card because we are storing this card face up
        
        # Then to get the actual card value we just have to load it from $t2 and let's put it into $t3
        lw $t3, 0($t2) # Getting the card's value from the CardNode
        
        # Now we can call append_card to add int the card to the column it has to go into
        # $a0 -> The column card_list that we are appending our card into
        # $a1 -> The card value that we are putting into the column
        move $a0, $t1 # The column we are appending the card to
        move $a1, $t3 # The card integer that we are putting into the column
        
        # Now we can just call the function
        jal append_card
        
        # After we append the card we have to increment our column counters
        addi $s2, $s2, 1
        
        # We also have to remove the card we have appended
        # so we have to move the head to the next card
        # Let's get the address of the head first and put that into $t0
        lw $t0, 4($s1)
        
        # We can get the next address of the head and put that into $t1
        lw $t1, 4($t0)
        
        # Then all we have to do is store the next address into $s1's head
        sw $t1, 4($s1) # This removes the current card and move onto the next card
        
        # Another thing we can't forget to do is to subtract 1 from the size of the deck because we drawn out a card
        # We load the current size of the deck into $t0
        lw $t0, 0($s1)
        
        # We just have to subtract 1 from it
        addi $t0, $t0, -1
        
        # And store it back into the size of the deck
        sw $t0, 0($s1)
        
        # Then we can jump back up the loop
        j for_loop_to_add_9_faceup_cards
    
    finished_adding_9_faceup_cards:
    # If we are here then we have finished adding the 9 faceup cards
    # And we are essentially done with the algorithm, deal_starting_cards
    # don't return anything hence we can just start restoring and deallocating the memories
    
    # Let's also print the size of the deck as well to check how many cards
    # we have left
    lw $a0, 0($s1)
    li $v0, 1
    syscall
    
    move $a0, $s1
    jal print_card_in_card_list

    # If we are here then we are done with the algorithm and we can start restoring the
    # $s registers we have used
    lw $s0, 0($sp) # Restoring the $s0 register
    lw $s1, 4($sp) # Restoring the $s1 register
    lw $s2, 8($sp) # Restoring the $s2 register
    lw $s3, 12($sp) # Restoring the $s3 register
    
    # We also have to restore the return address else it won't know where to return
    lw $ra, 16($sp)
    
    # Then we have to deallocate the memory we have used
    addi $sp, $sp, 20 # Deallocating the 20 bytes of memory we have used
    
    # Then we can just return to the caller
    jr $ra

print_card_in_card_list:
    # This function essentially takes in an pointer to a card_list struct
    # and proceeds to print out each CardNode in order
    
    # $a0 -> The card_list address of where the list of cards are stored
    
    # Let's just get the head address from the card_list first and load that into $t0
    # this will be our currNode pointer
    lw $t0, 4($a0)
    
    # Let's also get the size of the card_list so that can be our counter
    # we store the size into $t1
    lw $t1, 0($a0)
    
    # Now our counter will just be in $t2 starting at 0
    li $t2, 0
    
    # We will be using a for loop to print each CardNode that is in the card_list
    for_loop_to_print_each_card_in_card_list:
    	# Let's just get our stopping condition out of the way which is when
    	# our counter is greater than or equal to the size of card_list in $t1
        bge $t2, $t1, finished_printing_each_card_in_card_list
        
        # Then we print it
        addi $sp, $sp, -4
        lw $a0, 0($t0)
        sw $a0, 0($sp)
        move $a0, $sp
        li $v0, 4
        syscall
        addi $sp, $sp, 4
        
        # Then we need a space after it as well
        li $a0, ' '
        li $v0, 11
        syscall
        
        # Then after we print it we have to move the currNode pointer to the
        # point to the next card
        # Let's get the next card's address and put it into $t3
        lw $t3, 4($t0)
        
        # Then we update the currNode pointer with the next address
        move $t0, $t3
        
        # Don't forget to also update the counter
        addi $t2, $t2, 1
        
        # Then we can jump back up the loop
        j for_loop_to_print_each_card_in_card_list
	
    finished_printing_each_card_in_card_list:
    # Then a new line as well if we want to print other columns as well
    li $a0, '\n'
    li $v0, 11
    syscall
    
    # If we are here then that means we have finished printing all of the cards
    # that is in the card_list already so we can just return to the caller without
    # any restoring or deallocation of memory at all
    jr $ra
    
print_board:
    # This functions takes in an array of 9 pointers and print each of the card_list
    # that is in each pointer by calling print_card_in_card_list
    
    # $a0 -> The address of the board array which contains 9 pointers to 9 card_list structs
    
    # We will be calling functions so we need to save $a0 and as well as our return address
    # 8 bytes so far but we probably need 2 more as our counter and stopping condition
    # so total of 16 bytes
    addi $sp, $sp, -16 # Allocating 16 bytes of memory on the stack
    
    # Saving the $s registers before wecan use them
    sw $s0, 0($sp) # Saving the $s0 register
    sw $s1, 4($sp) # Saving the $s1 register 
    sw $s2, 8($sp) # Saving the $s2 reigster
    
    # We also have to save the return address else print_board won't know where to return
    sw $ra, 12($sp)
    
    # Now we can move the arguments onto the $s register
    move $s0, $a0 # $s0 will be the address that points to the array of 9 pointers
    
    # We will need a counter in $s1
    li $s1, 0
    
    # We will also need a stopping condition which is just 9
    li $s2, 9
    
    # Now we can begin our for loop to loop through the array of addresses
    for_loop_to_print_each_card_list:
        # Let's just get our stopping condition out of the way first
        # which is whenever our counter is greater than or equal to 9
        bge $s1, $s2, finished_printing_each_card_list
    
        # If we are in here then we haven't finished printing every single column yet
        # so we can have to actually print it
        # Let's calculate the effective address so we can get the pointer to the card_list we are printing
        # through this formula base_address + i * 4
        li $t7, 4 # 4 for mulitplication
        
        # Then we multiply the index with 4 and store that into $t0
        mul $t0, $s1, $t7
        
        # Then we add the offset to the base_address into $a0
        add $a0, $s0, $t0
        
        # Then we have to load the actual address that is stored at the effective address into $t1
        lw $t1, 0($a0)
        
        # Print the column index first
        move $a0, $s1
        li $v0, 1
        syscall 
        
        li $a0, 58
        li $v0, 11
        syscall
        
        li $a0, ' '
        li $v0, 11
        syscall
        
        # Then we can just call the print method to print that card list
        move $a0, $t1
        jal print_card_in_card_list
        
        # Then after priting we move onto the next column to print
        # by incrementing the counter
        addi $s1, $s1, 1
        
        # And jump back up the loop
        j for_loop_to_print_each_card_list
    
    finished_printing_each_card_list:
    # If we are here then we that means we have finished printing all the 
    # 9 linked list hence we can start restoring the $s registers we have used
    lw $s0, 0($sp) # Restoring the $s0 register
    lw $s1, 4($sp) # Restoring the $s1 reigster
    lw $s2, 8($sp) # Restoring the $s2 register
    
    # We also have to restore the return address or else it won't know where to return to
    lw $ra, 12($sp)

    # Then we have to deallocate the memory we have used
    addi $sp, $sp, 16 # Deallocating the 16 bytes of memory we have used
    
    # And finally we can return to the caller
    jr $ra

get_card:
    # This function basically get the card that is located at the given index
    # keep in mind that the list is 0-indexed
    
    # $a0 -> The valid card_list of cards to search through
    # $a1 -> The index that we want to retrive the card from
    # Output -> $v0, 1 if the card we get is face down, 2 if the card we get is faceup
    # and -1 if the index that was given is invalid or the list is empty
    # Output -> $v1, returns the actual card value from the CardNode, -1 if the index is invalid
    # or if the list is empty
    
    # First thing first we must check if the list we are searching through is empty
    # which we can do by just checking the size of the card_list
    # Let's get the size of the card_list into $t0
    lw $t0, 0($a0)
    
    # Now if the size is 0 then we will return (-1,-1)
    beq $t0, $0, get_card_card_list_empty_or_invalid_index
    
    # However, if we are here then that means the card_list is not empty
    # hence we have to check whether or not the given index is valid
    # a valid index is between 0 <= x < size so he have to check the logically opposite
    # if the index is less than 0 it is invalid, if it is greater than or equal to size it is invalid
    blt $a1, $0, get_card_card_list_empty_or_invalid_index
    
    # If we are here then that means the index is greater than or equal to 0 but
    # we still have to check if it is greater than or equal to the size which is invalid
    # we have our size in $t0 already so we can use that to help us checkl
    # The index is greater than or equal to the size hence invalid
    bge $a1, $t0, get_card_card_list_empty_or_invalid_index
    
    # Andd finally if we are here we can finally begin finding the index CardNode in our card_list
    # we will be keeping a counter in $t1 which start with 0
    li $t1, 0
    
    # We will be keeping our currNode pointer in $t2 as well and update as we go
    lw $t2, 4($a0)
    
    # Our stopping condition we already got it which is just the index we are looking for
    # then we can begin our for loop to search for that particular index
    for_loop_to_look_for_index_card:
        # Let's just get our stopping condition out of the way
        # which is whenever our counter is greater than or equal to our target index
        bge $t1, $a1, finished_looking_for_index_card
    
        # If we are here then that means we haven't reach the index node we want yet
        # hence we have to increment the pointer as well as our counter
        # Incrementing our counter
        addi $t1, $t1, 1
        
        # Then we also have to incremento our currNode pointer to the next CardNode
        # We will get the next and put it into $t3
        lw $t3, 4($t2)
        
        # Then we put the next as our currNode pointer
        move $t2, $t3
        
        # Then we can just jump back up the loop
        j for_loop_to_look_for_index_card

    finished_looking_for_index_card:
    # If we are here then our currNode pointer will be pointing at the desired index CardNode that we want 
    # Let's just get the card value and put that as our output value in $v1
    lw $v1, 0($t2) # Putting the card value of CardNode as our $v1 output
    
    # Then we have to get the third byte of the card value in order to determine which output we
    # give for $v0. We load the third byte of the card value into $t0
    lbu $t0, 2($t2)
    
    # Now we can do our if-statement checking
    li $t7, 'u' # 'u' for comparsion with the third byte
    
    # If we take this branch that means the third byte of the target card is a 'u'
    # so we have to give the value 2 as the return value in $v0
    beq $t0, $t7, get_card_is_a_faceup_card
    
    # However if we are here then that means the card must be facedown
    # hence we just have to return 1 in $v0
    li $v0, 1
    
    # Then we can just jump to finished algorithm
    j finished_get_card_algorithm
    
    get_card_is_a_faceup_card:
    # The target card is a face up card hence we have to return 2 in $v0
    li $v0, 2
    
    # Then we can just jump to algorithm
    j finished_get_card_algorithm
    
    
    get_card_card_list_empty_or_invalid_index:
    # If we are here then that means the card_list we are indexing through is empty
    # or it could be that the index is less than 0 or greater than or equal to the size which is invalid as well
    # hence we just return (-1,-1) as our output value
    li $v0, -1
    li $v1, -1

    # Then we can just follow logically to return to the caller
    finished_get_card_algorithm:
    # Since we didn't use any $s register or allocate any memory we can just return to the caller no problem
    jr $ra

check_move:
    # This function just look at the game move that is encoded in the integer and check
    # if it is a legal or illegal move by returning an integer code that tells the result
    # it will make no changes to the board but just tell whether or not the move is valid
    
    # $a0 -> Array of 9 pointers where each pointer points to a card_list struct address
    # $a1 -> The pointer to a valid card_list that represents a deck of cards
    # $a2 -> The integer that encodes the game move
    # Output -> $v0, Returns in $v0 the integer that tells whether or not the move is legal or illegal
    
    # Since we will be calling functions we have to save our arguments and the return address
    # 3 arguments, 12 bytes, and a return address 4 more bytes. So total of 16 bytes right now
    # Add 16 more bytes for 4 more $s registers
    addi $sp, $sp, -32 # Allocating 32 bytes of memory on the run time stack
    
    # Then we have to save the $s registers before we can use them
    sw $s0, 0($sp) # Saving the $s0 register
    sw $s1, 4($sp) # Saving the $s1 register
    # Now instead of saving another $s register, since we have to access the individual byte of move
    # we are going to put the integer move directly onto the stack instead on a $s register at 8($sp)
    sw $s2, 12($sp) # Saving the $s2 register
    sw $s3, 16($sp) # Saving the $s3 register
    sw $s4, 20($sp) # Saving the $s4 register
    sw $s5, 24($sp) # Saving the $s5 register
    
    # Then we have to also save the return address or else it won't know where to return to
    sw $ra, 28($sp)
    
    # Now we can move the arguments onto the $s registers
    move $s0, $a0 # $s0 will have the board that contains an array of 9 pointers where each pointer points to a column
    move $s1, $a1 # $s1 is the pointer that points to a deck of cards
    sw $a2, 8($sp) # Putting the move integer onto the stack, then 8($sp) can access first byte, 9($sp) second byte and so on
    
    # Now after we have everything saved we can begin our error checking
    # First error, deal_move parameter error
    # It will return -1 if the move argument encodes an invalid deal move so if byte #3 is 1 but all
    # other bytes it not all zero return -1. Or if the deal_move byte is not 0 or 1 return -1
    # Let's load in byte #3 into $t0 first
    lbu $t0, 11($sp) # Loading in byte #3 of the move
    
    # We will have to split into two cases, one where byte #3 is 0, meaning normal move
    # and the other case is 1, meaning deal move
    beq $t0, $0, check_move_is_a_normal_move
    
    # However, if we are here then it is definitely not a normal_move and we have to check
    # if it is a deal_move which is if the byte #3 is 1
    li $t7, 1 # Load in 1 for comparsion
    
    # If byte #3 is a 1 then we have a deal move then we have to do more checking
    # to make sure that all other bytes are 0, if not deal_move_parameter_error
    beq $t0, $t7, check_move_is_a_deal_move
    
    # However, if we are here that means it is not a deal move, and is not a normal
    # move. So it is some other number hence we have to return deal_move_parameter_error
    # we can just jump there
    j check_move_deal_move_parameter_error
    
    
    check_move_is_a_deal_move:
    # If we are here then that means the byte #3 is indeed 1 but we have to check all the other
    # bytes to make sure they are all 0 or else deal_move_parameter_error
    # We will load each byte into $t1, $t2, $t3 respective
    lbu $t1, 8($sp) # Byte #0
    lbu $t2, 9($sp) # Byte #1
    lbu $t3, 10($sp) # Byte #2
    
    # Now bunch of bne statement to do the logical opposite of not equal to 0
    # and jump to deal_move_parameter_error if it is true
    bne $t1, $0, check_move_deal_move_parameter_error # Byte #0 is not 0
    bne $t2, $0, check_move_deal_move_parameter_error # Byte #1 is not 0
    bne $t3, $0, check_move_deal_move_parameter_error # Byte #2 is not 0
    
    # Anddd if we are here then that means the move encodes a deal move and
    # all of the other bytes are all 0
    # Then we move onto the second error which is illegal_deal_move_error
    # which is when we have a valid deal move parameter but the deck is empty
    # or if at least one column of the board is empty then we return -2
    # Let's just check for the deck size first, if it is 0 then we can just return this error
    # we load the size of the deck into $t0
    lw $t0, 0($s1) # Loading the size of the deck
    
    # Now if the size of the deck is empty then we jump to illegal_deal_move_error
    beq $t0, $0, check_move_illegal_deal_move_error
    
    # But if we didn't take the branch that means the deck is not empty, then we have to check
    # if at least one of the column of the board is empty and we will be doing that through a for loop
    # which loops through each column of the board, and see if any of the size is 0, if we find at least 1
    # is 0 then we return the error
    
    # Now we need a counter to go through the 9 pointers in the board array
    # and we will just set $t0 as our pointer starting with 0
    li $t0, 0
    
    # Then we also need a stopping condition which is just 9 because we have 9 pointers
    li $t1, 9
    
    # Now we can begin our for loop in search of a empty column
    for_loop_to_find_empty_column:
        # Let's just get our stopping condition out of the way which is when our counter
        # is greater than or eqaul to 9 that means we have finished looking through
        # all of the columns and none of them are empty
        bge $t0, $t1, finished_loop_to_find_empty_column
    
        # Now if we are here we have to actually check the actual column we are at to see
        # if it is empty or not, if it is empty then we return the error
        # if it is not empty for this column then we will just go check the next columns
        # We have to get the pointer to the actual card_list by doing some math
        # the effective address of where the pointer is stored can be calculated using
        # base_address + i * 4
        li $t7, 4 # Load in 4 for multiplication
        
        # Then we have to multiply our current counter by 4 and put the result into $t2
        mul $t2, $t0, $t7 # i * 4
        
        # Then in $t2 we have our offset to add to the base_address
        # Let's store the effective address into $t3
        add $t3, $s0, $t2
        
        # Now $t3 have the effective address of where the pointer is stored let's actually get the pointer
        # and put it into $t3 again
        lw $t3, 0($t3)
        
        # Okay so we have the address of the actual card_list column, let's get the size of the column
        # and put it into $t4
        lw $t4, 0($t3)
        
        # And if this current column we are looking at have the size of 0 then we return the error
        beq $t4, $0, check_move_illegal_deal_move_error
        
        # However, if we are here then that means this current column isn't empty hence
        # we can move on and check the next column by incrementing the counter
        addi $t0, $t0, 1
        
        # Then we can jump back up the loop
        j for_loop_to_find_empty_column
    
    finished_loop_to_find_empty_column:
    # If we are here then that means we have got through all 9 columns and none of the are empty
    # and which means it is a leagl deal_move hence we can just return 1 as our output value
    li $v0, 1
    
    # And we can jump to finished algorithm for this case
    j finished_check_move_algorithm
    
    
    check_move_is_a_normal_move:
    # So we will be here if byte #3 is a 0 meaning it is a normal move
    # which have a whole separate error checking on its own
    # third error, normal_move_parameter_error. And this error on its on
    # have 3 cases by itself
    
    # The first case of the parameter error returns -3 if the column or
    # recipient column in the move is invalid, so they are not between 0 <= x < 9
    # Let's check the donor column first which is byte #0 at 8($sp)
    # Let's load in donor column into $t0
    lbu $t0, 8($sp)
    
    # So if byte #0 is less than 0 or greater than or equal to 9 it is invalid
    li $t7, 9 # We load 9 for comparsion
    
    # So we will jump to normal_move_parameter_error -3 if donor column is less than 0
    # since it is invalid
    blt $t0, $0, check_move_normal_move_parameter_error_neg_3
    
    # So if we are here we have to also make sure it is less than 9
    # so if it is greater than or equal to 9 it will be invalid as well with the same error
    bge $t0, $t7, check_move_normal_move_parameter_error_neg_3
    
    # Okay if we are here then that means column is valid, we also need to check the recipient column
    # which is byte #2 located at 10($sp) let's just load it in and put it into $t1
    lbu $t1, 10($sp) # Getting the recipient column from the move
    
    # Then we do the same checking. If the recipient column is less than zero we also return -3
    # as the error code
    blt $t1, $0, check_move_normal_move_parameter_error_neg_3
    
    # And if it is also greater than or equal to 9 we also return -3 error code
    bge $t1, $t7, check_move_normal_move_parameter_error_neg_3
    
    # Okay so if we are here then we are steer clear from error code -3
    # we can proceed to check the second case of normal_move_parameter_error which returns -4
    # Let's just get the byte #1 first which represents the row we are taking the card from from the column
    # and put that into $t2
    lbu $t2, 9($sp) # Getting the donor row from the move
    
    # So the donor row must be greater than or equal to 0, meaning it can't be less than 0
    # we will do the check right here. If it is less than 0 error code -4
    blt $t2, $0, check_move_normal_move_parameter_error_neg_4
    
    # Now we have to make sure this row index we are taking from the column is less than the column size
    # so it cannot be greater than or equal to the card_list's size at i
    # If we are here then that means the column we are taking from is in fact valid so we can use this
    # index to calculate the effect address of where the pointer is stored in board[]
    # base_address + i * 4
    li $t7, 4 # Load 4 for multiplication
    
    # We do i * 4 and put the result into $t3
    mul $t3, $t0, $t7
    
    # Now we have the offset we can just add it to the base_address to calculate the
    # effective address of where that pointer is stored on the array, we will put the
    # effective address back into $t3
    add $t3, $s0, $t3
    
    # Now we load the pointer that is stored in that effective address into $t4
    lw $t4, 0($t3)
    
    # Okay we load in the size into $t5 from the card_list struct
    lw $t5, 0($t4)
    
    # Okay we got the size right now, our donor row must be less than this size
    # else we return -4 as our error code
    bge $t2, $t5, check_move_normal_move_parameter_error_neg_4
    
    # Finally, if we are here then that means we are steer clear from error code -4
    # we have our final case to check which isn't too bad
    # The last case will return -5 if the donor column and the recipient column are valid
    # but they are equal, which represent a move from a column to itself which doesn't count
    # and we have to return the error code approripately
    # We have already got the donor column and recipient column from up there
    # $t0 have our donor column, and $t1 have our recipient column we can just check their equality for error -5
    beq $t0, $t1, check_move_normal_move_parameter_error_neg_5 # We branch to error -5 if donor column and recipient columns are the same   
    
    
    # Last case of error checking which is illegal_normal_move_error
    # and there is total of 3 subcases to handle as well!
    # Let's just begin with the first one which is if the card at donor column and
    # row is a face down card. We must call get_card on that column
    # So again we have the donor column in $t0 already lets 
    # that effective address on the board first 
    # base_address  + i * 4
    li $t7, 4 # 4 for mulipliation
    
    # We will do i * 4 and put the result into $t3
    mul $t3, $t0, $t7
    
    # In $t3 right now we have the offset that we have to add to the base_address
    # let's add it and store the effective address back into $t3
    add $t3, $s0, $t3
    
    # We load the pointer into $t4 from the effective address
    # this is the address we use to call get_card on
    lw $t4, 0($t3)
    
    # We must call get_card here
    # $a0 -> The card_list we are indexing through which is just $t4
    # $a1 -> The index we are looking at which is just $t2, the donor row
    move $a0, $t4 # The column of card_list we are indexing through
    move $a1, $t2 # The card index we are looking at
    
    # Then we can call the function
    jal get_card
    
    # In $v0 we have whether or not the card is facedown(1) or faceup(2)
    # if the return value is 1 meaning the card we start to take from is facedown
    # we return -6 error code
    li $t7, 1 # Load 1 for comparsion
    
    # We take this branch if the return value is a facedown card
    beq $v0, $t7, check_move_illegal_normal_move_error_neg_6
    
    # Okay if we are here then we are clear from -6 error code we can start checking for the second
    # subcase of returning -7 which is there is a gap in between the cards we are taking.
    # so if the cards we are picking are 6-5-3-2-1 it will return -7 because it jumped a card
    # from 5 to 3. The way we will be doing this is traverse the given column starting at the
    # row index down to the last card, looking at two cards at a time and if the any
    # pair of two cards have differences of not being 1 we return -7
    # First things first we need the pointer to the card_list struct of the column we are looking through
    # Keep in mind the formula of i * 4
    li $t7, 4 # Load 4 for mulitplication
    
    # i will be the donor column let's just get it again and put it into $t6
    lbu $t6, 8($sp)
    
    # Let's do the multiplication and put the offset into $t3
    mul $t3, $t6, $t7 # i * 4
    
    # Then we add it to the base_address to get the effective address of where the pointer is stored
    # and put it back into $t3
    add $t3, $t3, $s0
    
    # Then we can load the struct address into $s4 for us to use. This is the address of the card_list
    # to the column
    lw $s4, 0($t3)
    
    # In $s2 we will be storing the row index that we start to look exam at
    # In $s3 we will store the last index we will be looking at which is the size of that column - 1,
    # because we are looking at two cards at a time
    lbu $s2, 9($sp) # $s2 will have the row that we start looking at the column with
    
    # We first load in the size of the column into $s3 first
    lbu $s3, 0($s4)
    
    # Then we subtract 1 from it because we need to stop the for loop one early since we are looking
    # at two cards at a time
    addi $s3, $s3, -1
    
    # Now we can begin our for loop to exam for if the card/cards are going to be moved are not in
    # descending order
    for_loop_to_look_for_not_descending_order:
        # First we will get our stopping condition out of the way which is
        # when our row counter $s2 is greater than or equal to the size of the column - 1 $s3
        # that means we have looked through every pair of cards and they are all in descending order
        # thus no error is needed to be returned
        bge $s2, $s3, finished_loop_to_look_for_not_descending_order
    
        # However if we are here then that means we didn't finished looking through
        # every pair of the cards so we have to actually look at that pair
        # Let's get the current card value at index i
        # $a0 -> The card_list we are indexing through which is $s4
        # $a1 -> The index we want to get the card from which is $s2
        move $a0, $s4 # The card_list we are indexing through
        move $a1, $s2 # The index we are searching through
        
        # Call the get_card method
        jal get_card
        
        # In $v1 we have the card value that is returned let's save that into $s5 since we have to
        # call get_card one more time to get the i + 1 card's value
        move $s5, $v1
        
        # Then we have to get the i + 1 card'svalue
        # $a0 -> The card_list we are indexing through which is $s4
        # $a1 -> The index we want to get the card from which is $s2 + 1
        move $a0, $s4 # The card_list we are indexing through
        addi $a1, $s2, 1 # The index we are searhcing through which is $s2 + 1
        
        # Call the get_card method
        jal get_card
        
        # Okay now in $s5 we have the current card's value
        # and in $v1 we have the current card + 1's value 
        # we must get the two card's rank value and compare them if the difference between
        # the current one and the one after is not 1 return -7 error, else we check the next pair
        # by incrementing the counter and going back up the loop again
        
        # We can get the current card's value along by doing sll 24 then srl 24
        sll $s5, $s5, 24 # Move 24 bit left
        srl $s5, $s5, 24 # Move 24 bit right
        
        sll $v1, $v1, 24 # Move 24 bit left
        srl $v1, $v1, 24 # Move 24 bit right
        
        # Okay $s5 we have current card's value and $v1 is the next card's value
        # We subtract these two cards if the value is not 1 then we branch
        # We store the difference into $t0
        sub $t0, $s5, $v1 # Current card - Next card
        
        # If the difference is not 1 then we branch to error -7
        li $t7, 1 # Load 1 for comparsion
        
        # If the difference between the current card and the next card is not one then we return error code -7
        bne $t0, $t7, check_move_illegal_normal_move_error_neg_7
        
        # However if we didn't take the branch then that means the two pair we have
        # have descending value hence we go to the next pair and check
        # we have to increment our counter before we can jump back up
        addi $s2, $s2, 1
        
        # Then we can just jump back up the loop
        j for_loop_to_look_for_not_descending_order
    
    finished_loop_to_look_for_not_descending_order:
    # If we are here then that means we have to looked through every pair starting from the row index
    # and all the pairs are in valid descending order hence error -7 is not needed to be returned
    # Now we check the last subcase which is -8. So if the recipient column is not empty
    # AND the selected card is not one less than the rank of the top card in the recipient column
    # we just return error -8
    # Let's get the card that is on top of the recipient column
    # To do that we will need the recipient column at 10($sp) from the stack
    # Let's get that and put it into $t0
    lbu $t0, 10($sp) # Recipient column index
    
    # Keep in mind the formula is base_address + i * 4
    li $t7, 4 # Load in 4 for multiplication
    
    # Then we do i * 4 and store the result into $t1
    mul $t1, $t0, $t7
    
    # Then we add the base_address with the offset to get the effective address so we store it into $t0
    add $t0, $s0, $t1
    
    # Then we load the pointer into $t0
    lw $t0, 0($t0)
    
    # Before we can get the top card of recipient column we must check if it is empty or not empty first
    # We can load the size of recipient column card_list into $t1
    lw $t1, 0($t0)
    
    # Now if the size is equal to 0 we branch away to just return 2 as a success because there is no
    # difference to check to move a card or stack of card into an empty column
    beq $t1, $0, empty_recipient_column_success_code_2
    
    # However, if we are here then that means the recipient column is not empty hence we have to
    # check the difference between the two cards

    # We are comparing the top of the recipient which is the last card in the card_list, hence size - 1
    # We subtract 1 to get us the index of the last card
    addi $t1, $t1, -1
    
    # Then we have to call get_card to actually get the card to make the comparsion
    # $a0 -> The card_list we are looking through which is the recipient column, $t0
    # $a1 -> The index we are looking at which is $t1
    move $a0, $t0 # The recipient column
    move $a1, $t1 # The last card or top of the card
        
    # Call the get_card method
    jal get_card
    
    # Okay in $v1 we have the recipient column's top card value let's store that into $s5
    move $s5, $v1
    
    # Now we have to get the donor column row card
    # $a0 -> The card_list we are looking through, we have the donor column's card_list address stored that into $s4 already
    # $a1 -> The index we are looking at which is just 9($sp)
    move $a0, $s4 # The card_list we are looking through which is the donor column
    lbu $a1, 9($sp) # The index we are looking at
    
    # Then we call the get_card function
    jal get_card
    
    # Now we have to do the same shifting function we did for error code -7
    # move 24 bit to the left and move 24 bit back
    sll $s5, $s5, 24 # Move 24 bit left
    srl $s5, $s5, 24 # Move 24 bit right
    
    sll $v1, $v1, 24 # Move 24 bit left
    srl $v1, $v1, 24 # Move 24 bit right
    
    # Finally $s5 is the top card value of recipient column, which $v1 is the card we taking from from the donor column
    # $s5 - $v1 must equal to 1 to consider a valid move
    # We store the difference into $t0 again
    sub $t0, $s5, $v1
    
    # Load in 1 for comparsion
    li $t7, 1
    
    # If we have the difference of 1
    beq $t0, $t7, non_empty_recipient_column_success_code_3
    
    # However if we are here then that means the difference is not 1
    # hence we return the error code of -8
    j check_move_illegal_normal_move_error_neg_8
    
  
  
    check_move_normal_move_parameter_error_neg_3:
    # If we are here then we return -3 because either the donor column or recipient column in the move
    # are invalid
    li $v0, -3
    
    # And we can jump to finish algorithm
    j finished_check_move_algorithm
    
    
    check_move_normal_move_parameter_error_neg_4:
    # If we are here then we have to return -4 because the row we want to move from
    # is invalid in move. Meaning the btye is not between 0 <= x < board[i].size
    # So we just have to return -4
    li $v0, -4
    
    # And jump to finish the algorithm
    j finished_check_move_algorithm
    
    
    check_move_normal_move_parameter_error_neg_5:
    # If we are here then we return -5 because the donor column and recipient columns
    # are valid but they are the same number. Moving from a column to itself don't count
    li $v0, -5
    
    # And we jump to finish the algorithm
    j finished_check_move_algorithm
    
    
    check_move_illegal_normal_move_error_neg_6:
    # If we are here then we return -6 because the card at donor column and row is a face
    # down card and we are trying to move from that card which we aren't allow to since
    # we can't move a facedown card
    li $v0, -6
    
    # And we jump to finish the algorithm
    j finished_check_move_algorithm
    
    
    check_move_illegal_normal_move_error_neg_7:
    # If we are here then we return -7 because the cards we are going to be moving are not in descending order
    li $v0, -7
    
    # And we can jump to finish the algorithm
    j finished_check_move_algorithm
    
    
    check_move_illegal_normal_move_error_neg_8:
    # If we are here then we return -8 because the recipient column is not empty
    # AND the difference between the selected card and recipient card is not 1
    li $v0, -8
    
    # And jump to finish
    j finished_check_move_algorithm
    
    
    empty_recipient_column_success_code_2:
    # If we are here then that means the recipient column is empty
    # and the cards we are moving are in descending order hence it is a valid legal move
    # we just return 2
    li $v0, 2
    
    # And jump to finish
    j finished_check_move_algorithm
    
    
    non_empty_recipient_column_success_code_3:
    # If we are here then that means the recipient column is not empty
    # but the difference between the top card and the cards we are moving is 1
    # hence it is considered a valid legal move just return 3
    li $v0, 3
    
    # And jump to finish
    j finished_check_move_algorithm
    
    
    check_move_illegal_deal_move_error:
    # If we are here then that means we do have a valid deal move bytes
    # but the deck is empty or if at least one column of the board is empty
    # hence we just return -2
    li $v0, -2
    
    # Then after setting the output we can just jump to finished algorithm
    j finished_check_move_algorithm
    
    
    check_move_deal_move_parameter_error:
    # If we are here then that means either byte #3 is not 0 or 1, or
    # if byte #3 is a 1 but all other bytes is not all 0 hence we return -1
    li $v0, -1
    
    
    finished_check_move_algorithm:
    # If we are here then that means we have finished checking whether or not the
    # given move is valid or not. We can start restoring the $s registers we have used
    lw $s0, 0($sp) # Restoring the $s0 register
    lw $s1, 4($sp) # Restoring the $s1 register
    # We don't haev to restore 8($sp) to anything because it just stores the move integer on the stack
    # we didn't use any more $s registers just 2 and that's it
    lw $s2, 12($sp) # Restoring the $s2 register
    lw $s3, 16($sp) # Restoring the $s3 register
    lw $s4, 20($sp) # Restoring the $s4 register
    lw $s5, 24($sp) # Restoring the $s5 register
    
    # Then we have to also restore the return address or else it won't know where to return to
    lw $ra, 28($sp)
    
    # Then we have to deallocate the memory we have used
    addi $sp, $sp, 32 # Deallocating the 32 bytes of memory we have used
    
    # And we are done and can just jump back to the caller
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
