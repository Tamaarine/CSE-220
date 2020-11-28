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
        
        # We also want to print the size here as well
        li $a0, '-'
        li $v0, 11
        syscall
        
        lbu $a0, 0($t1)
        li $v0, 1
        syscall
        
        # Print :
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
    # This function just basically try to remove tyhe top 10 cards at the given column if the
    # top 10 cards are face up and are from 9 to 0, or 0 to 9 depend on the way you look at it
    # After you remove the full straight, the top card of the column is flipped face up, so the
    # size of the column need to be adjusted as well
    
    # $a0 -> The address that contains the array of 9 pointers which each represent a column
    # $a1 -> The 0-indexed number that represent the column to check for a full straight
    # Output -> $v0, Returns a code that communicate the correct result to the caller
    
    # Since we have to the function get_card that means we have to save our arguments
    # into the $s register so we have to allocate memory on the run time stack
    # 2 arguments 8 bytes, 1 return address 4 more bytes. So total of 12 bytes for now
    # 16 more byte for 4 more reigster
    addi $sp, $sp, -28 # Allocating 28 bytes of memory on the run time stack
    
    # Now we can save the $s registers before we can use them
    sw $s0, 0($sp) # Saving the $s0 register 
    sw $s1, 4($sp) # Saving the $s1 register
    sw $s2, 8($sp) # Saving the $s2 register
    sw $s3, 12($sp) # Saving the $s3 register
    sw $s4, 16($sp) # Saving the $s4 register
    sw $s5, 20($sp) # Saving the $s5 register
    
    # We also have to save the return address else clear_full_straight won't know where to return
    sw $ra, 24($sp)
    
    # Then we can move the arguments to the $s registers
    move $s0, $a0 # $s0 will represent the array that contains the 9 array pointers to card_list
    move $s1, $a1 # $s1 will have the index number that represent the column to check for a full straight
    
    # We will do the checks for full straight step by step
    # the first step is to make sure the column argument that is given is in valid range, which is 0 <= x < 9
    # If the given column index is less than 0 then it is definitely not a valid column index
    # hence we return -1 as our output value
    blt $s1, $0, clear_full_straight_invalid_neg_1
    
    # If we are here then that means the column index is definitely 0 or greater but we have
    # to make sure it is less than 9 else it is definitely invalid
    li $t7, 9 # Load 9 for comparsion
    
    # If the given column index is greater than or equal to 9 then it is definitely not a valid column index
    # hence we have to return error code -1
    bge $s1, $t7, clear_full_straight_invalid_neg_1
    
    
    # If we are here then that means we are steer clear from error code -1
    # hence we begin to check for error code -2 which is thrown if
    # the card_list's size is less than 10. If it is greater than or equal to 10 then we don't throw -2
    # First we have to calculate the offset to get the effective address which stores the
    # pointer to the card_list struct
    # This can be computed by doing base_address + i * 4
    li $t7, 4 # Load 4 for multiplication
    
    # Then we have to multiple 4 with the index $s1 let's store the offset into $t0
    mul $t0, $s1, $t7 # i * 4
    
    # Then we add it to the base_address and put the result into $t1
    add $t1, $t0, $s0
    
    # Now in $t1 we have the effective address of the column's pointer we put it into $s2 so
    # we can use it across the other section of error checking
    lw $s2, 0($t1)
    
    # Now let's just load in the size of the card_list first into $t0
    lw $t0, 0($s2)
    
    # Then we have to compare to 10, if it is 10 or less then we will return error code -2
    # because the card_list doesn't even have 10 cards inside so it cannot be a full straight 100%
    li $t7, 10 # Load 10 for comparsion
    
    # We will take the branch to return error code -2 if the size of the column we are checking
    # at is less than 10. If it is greater than or equal to 10 we will have to do further checking
    blt $t0, $t7, clear_full_straight_invalid_neg_2
    
    
    # Okay great if we are here then we are steer clear from error code -3
    # and now we have to actually check for the full straight. This is how we will be doing it
    # We will have a index counter that starts at the top of the card so size - 1
    # and the stopping condition will be size - 1 - 9 = size - 10 and is ble size - 10
    # because we want it to check in pairs for a full straight
    # Let's review the variables first before we dive in
    # $s2 -> Is the address of our column card_list struct
    # $s0 -> Is our board is array
    # $s1 -> Is the column we are searching full straight through
    # $s3 -> We will use this as our counter that starts from size - 1 of the board
    # $s4 -> This will be used as our stopping condition of the for loop which is equal to size - 10
    
    # Let's just get our counter first which is size - 1, we will get the size of the card_list into $t0
    lw $t0, 0($s2) # Getting the size of the card_list
    
    li $t7, 1 # Load in 1 for subtraction
    
    # size - 1 to get our starting index which is at the last card
    sub $s3, $t0, $t7
    
    # Then we have to subtract size - 10 to get the stopping condition at the 10th card
    li $t7, 10 # Load 10 for subtraction
    
    # size - 10 to get our stopping condition in $s4
    sub $s4, $t0, $t7 
    
    # Now we get the last card from the card_list first to see if it is 0
    # if it is not 0 then we just return -3 it is not valid full straight to clear from
    # $a0 -> The card_list we are indexing through
    # $a1 -> The index we want to look at in the card_list we are just looking at the last card first which is $s3
    move $a0, $s2
    move $a1, $s3
    
    # Then we can call the method to get us the last card
    jal get_card
    
    # Okay in $v1 we have the card value and in $v0 we have whether or not the card
    # is face up or face down. In order to continue this check for full straight
    # this last card must be face up (2) AND have value of 0 (sll 24 + srl 24)
    # Let's check the face up constraint first
    li $t7, 1 # Load 1 for comparsion
    
    # We will take this branch if the last card we get is a face down card hence
    # it cannot never be a full straight that we clear since it is a face down card
    beq $v0, $t7, clear_full_straight_invalid_neg_3
    
    # However if we are here then that means the last card is a face up card, then we have to
    # do another check that the last card is also have the value of 0, else return -3
    # We can get the value of the last card by doing sll 24 and srl 24 on $v1
    sll $v1, $v1, 24 # Shift left 24 bits
    srl $v1, $v1, 24 # Shift right 24 bits
    
    # Then in $v1 we have the rank of the last_card and we just compare it to $0
    # if it is not '0' then we return -3, if it is '0' then we will continue our check
    li $t7, '0' # Load '0' for comparsion
    
    bne $v1, $t7, clear_full_straight_invalid_neg_3
    
    # Now if we are here then that means the last card of this column we are checking
    # infact does have 0 as our top card and is face up. Now we have to check every pair
    # from size - 1 index to and not including size - 10 index to check for a valid
    # full straight
    # Keep in mind that $s3 is our starting index at the last card
    # and $s4 is our stopping index at index - 10
    # $s5 we will use it to store the prev or current card value
    for_loop_to_check_for_full_straight:
        # Let's just get our stopping condition out of the way
        # which is whenever our counter is less than or equal to our stopping condition
        ble $s3, $s4, finished_for_loop_to_check_for_full_straight 
    
        # However, if we are here then that means we haven't finished checking every
        # pair yet so we have to actually check it
        # Let's get the current card and check for the face up and face down constraint
        # and then we will check the previous card relative to the current card for face up and face down constraint too
        # and then if both card pass the faceup constraint we will check their differences
        
        # Getting current card by calling get_card
        # $a0 -> The card_list we are indexing through
        # $a1 -> The index we are looking at in the card_list
        move $a0, $s2 # The card_list we are seraching through
        move $a1, $s3 # The current card index we are getting 
        
        # Then we can call the function get_card
        jal get_card
        
        # Okay so in $v0 we have whether or not the current card is face up or down
        # and in $v1 we have the card value we will have to do check on both of them
        li $t7, 1 # Load 1 for comparsion
        
        # If the current card is a facedown card it cannot have a full straight hence just
        # return -3 as our output
        beq $v0, $t7, clear_full_straight_invalid_neg_3
        
        # However if we are here then that means it is faceup, we will sdave the card value into
        # s5, so we can move onto getting the card value of the previous card
        move $s5, $v1 # Saving the current card's value into $s5
        
        # Okay we have the get the previous card by calling get_card
        # $a0 -> The card_list we are indexing through
        # $a1 -> The idnex we are looking at in the card_list which is one less than the current card's index
        move $a0, $s2 # The card_list we are searching through
        addi $a1, $s3, -1 # We have to subtract one from the current index in order to get the index of the previous card
        
        # Then we can call the function get_card
        jal get_card
        
        # Alright again we have to also check the face up and face down constraint on the preivous card
        # as well just like the current card
        li $t7, 1 # Load 1 for comparsion
        
        # If the previous card is also a facedown card it cannot have a full straight in the
        # column hence we just retunr -3 as our output
        beq $v0, $t7, clear_full_straight_invalid_neg_3
        
        # But if we are here then that means both the current card and the previous card
        # are face up hence we can proceed to check theri differences 
        # But first we have to do the shifts to get their rank value by moving 
        # 24 bit left and 24 bit right
        sll $s5, $s5, 24 # Shift 24 bit left
        srl $s5, $s5, 24 # Shift 24 bit right
        
        sll $v1, $v1, 24 # Shift 24 bit left
        srl $v1, $v1, 24 # Shift 24 bit right
        
        # In $s5 is the current card's value and $v1 is the previous card's value
        # previous card - current card must be equal to 1 else we return -3 as our
        # output value. We will store the differences into $t0
        sub $t0, $v1, $s5 # previous card - current card
        
        li $t7, 1 # Load 1 for comparsion
        
        # If the difference between the two card is not 1 then uh oh it is not
        # a valid full straight because there is at least one pair of cards
        # that are not consecutive hence we return -3 as our output value
        bne $t0, $t7, clear_full_straight_invalid_neg_3
        
        # But if we are here then that means the current card and previous card's difference
        # is indeed 1. Then we have to go on and check the other pairs by doing another iteration
        # we have to decrement our counters
        addi $s3, $s3, -1 
        
        # Then we can jump back up the loop
        j for_loop_to_check_for_full_straight    
    
    finished_for_loop_to_check_for_full_straight:
    # Now if we are here then that means we have finished checking all the 10 cards and
    # they are a valid full straight starting at the top
    # Few things we have to do. We have to remove the 10 full straight cards by cutting off
    # the connection. We will do that after we check the sizes
    # If the size - 10 is equal to 0 we just make that column's head equal to 0 removing all the carsd
    # If the size - 10 is 1 or more we find the last card after removing the 10 full straight card
    # and make that next equal to 0
    
    # Let's get the current size again in $t0 of the column we are checking
    lw $t0, 0($s2) 
    
    # We will subtract 10 from it
    addi $t0, $t0, -10
    
    # Now if the size after taking off 10 cards is 0 meaning empty column we will return 2
    # and cut off the head to just be 0
    beq $t0, $0, clear_full_straight_is_empty
    
    # However if we are here then the column is not empty after taking off the 10 cards
    # we will jump to a label that will do the other things
    j clear_full_straight_is_not_empty
    
    
    clear_full_straight_is_empty:
    # If we are here then that means the full straight is the only 10 cards that is
    # in this column hence we update the size of this card_list and just make
    # head be equal to 0 
    
    # We first update the size which is already calculated in $t0 
    sw $t0, 0($s2) 
    
    # Then we just have to make $s2's head equal to 0 and we are done
    sw $0, 4($s2) # Cutting off the connection to all the other cards
    
    # Then we return the output value of 2 and done
    li $v0, 2
    
    # And we can just jump to finish the algorihtm
    j finished_clear_full_straight_algorithm
    
    
    clear_full_straight_is_not_empty:
    # If we are here then that means is after the 10 cards are removed the column will still have
    # few cards remaining we have to look at the cards that is left and flip the one that is on top
    # That important card we are flipping and putting next to 0 is located at size - 11
    # we can just take $t0 and subtract 1 to get that important card's index, and let's put that index
    # into $t1
    addi $t1, $t0, -1 # Subtracting 1 from size - 10 
    
    # We will need a for loop to traverse to that specific important CardNode
    # we will start with the head let's get that and put it into $t3. This will be our currNode pointer
    lw $t3, 4($s2)
    
    # Our counter will start with 0 in $t2
    li $t2, 0
    
    # Now we can begin our for loop to search for that important CardNode which is located at $t1 index
    for_loop_to_look_for_that_important_card:
        # Let's just get our stopping condition out of the way which is
        # whenever our counter is greater than or equal to the stopping condition
        bge $t2, $t1, finished_looking_for_that_important_card
    
        # However, if we are here then that means we haven't reach the address of that important card yet
        # hence we have to actually update our currNode pointer as well as our counter
        # Get the next of currNode pointer into $t4
        lw $t4, 4($t3)
        
        # Then we update our currNode pointer with that next address
        move $t3, $t4
        
        # Then we update our counter
        addi $t2, $t2, 1
        
        # And jump back up the loop
        j for_loop_to_look_for_that_important_card
    
    finished_looking_for_that_important_card:
    # If we are here then that means $t3 current have the address of that important card
    # We make that CardNode's next equal to 0
    sw $0, 4($t3)
    
    # And we have to flip it so it faces up
    li $t7, 'u' # Load 'u' ascii for us to store it at byte #2
    sb $t7, 2($t3) # Flip the important card to face up after removing the full straight flush
    
    # Then lastly we have to update the size of the card_list after removing the 10 cards
    # which is still in $t0 in the card_list struct
    sw $t0, 0($s2)
    
    # AND finally we are done we can just return 1 as our output value
    li $v0, 1
    
    # And jump to finish the algorithm
    j finished_clear_full_straight_algorithm
    
    
    clear_full_straight_invalid_neg_1:
    # If we are here then that means the given column index is not valid
    # hence we just return -1 as our output value
    li $v0, -1
    
    # Then we can jump to finish algorithm
    j finished_clear_full_straight_algorithm
    
    
    clear_full_straight_invalid_neg_2:
    # If we are here then that means the column we are checking for full straight
    # doesn't even have 10 cards or more hence it can never have a full straight
    # so we just return -2 as our output value
    li $v0, -2
    
    # And we can jump to finish algorithm
    j finished_clear_full_straight_algorithm 
    
    
    clear_full_straight_invalid_neg_3:
    # If we are here then that means the card_list we are checking for full straight in
    # has at least 10 or more cards. BUT! A full straight cannot be clear from the 
    # top 10 cards, since it doesn't have the full straight or some of the are face down
    # or the full strtaight exist somewhere else it doesnt' end at the last card
    # hence we just return -3
    li $v0, -3 
    
    # Then it can just follow logically to finsh the algorithm    
    
    
    finished_clear_full_straight_algorithm:
    # If we are here then that means we have finished the algorithm
    # and we can start restoring the $s registers we have used and deallocate the memories
    lw $s0, 0($sp) # Restoring the $s0 register 
    lw $s1, 4($sp) # Restoring the $s1 register
    lw $s2, 8($sp) # Restoring the $s2 register
    lw $s3, 12($sp) # Restoring the $s3 register
    lw $s4, 16($sp) # Restoring the $s4 register
    lw $s5, 20($sp) # Restoring the $s5 register
    
    # We also have to restore the return address else it won't know where to return to
    lw $ra, 24($sp)
    
    # And we can deallocate the memory we have used
    addi $sp, $sp, 28 # Deallocating the 28 bytes of memory we have used
    
    # And finally we can return to the caller
    jr $ra

deal_move:
    # This function will do a deal-move drawing 0 cards from the deck and lay them
    # face up at the top of each of 9 columns of the game board sequentially
    
    # $a0 > The array of 9 pointers to the 9 columns card_list struct
    # $a1 -> The pointer to the card_list which represent the deck we are drawing the 9
    # cards from
    
    # Since we will be calling functions we have to save our arugments on the $s registers
    # 2 arguments 8 bytes, 4 byte for the return address so 12 bytes in total
    # 8 more byte for 2 more registers
    addi $sp, $sp, -20 # Allocating 20 bytes of memory on the run time stack
    
    # We have to save the $s registers before we can use them
    sw $s0, 0($sp) # Saving the $s0 register
    sw $s1, 4($sp) # Saving the $s1 reigster
    sw $s2, 8($sp) # Saving the $s2 register
    sw $s3, 12($sp) # Saving the $s3 register
    
    # Saving the return address as well
    sw $ra, 16($sp)
    
    # Now we can move the arguments onto the $s registers
    move $s0, $a0 # $s0 will have the 9 pointers that pointers to the 9 columns of card_list struct
    move $s1, $a1 # $s1 will have the pointer to the deck of cards we are distributing
    
    # And we can begin distributing the 9 cards from the deck
    # We will do so through a for loop
    # Our counter will be be $s2 which starts at 0
    # Our stopping condition will just be 9 because we are dealing 9 cards and we have 9 columns
    li $s2, 0 # Counter for the for loop
    li $s3, 9 # Stopping condition for the for loop
    
    # Then we can start our for loop to deal 9 cards from the deck
    for_loop_to_deal_9_cards:
        # Let's just get our stopping condition out of the way first
        # which is whenever our counter is greater than or eqaul to 9
        # that means we have finished dealing 9 cards from the deck already
        bge $s2, $s3, finished_loop_to_deal_9_cards

        # If we are here then that means we haven't finished dealing the 9 cards
        # yet so we have to actually deal them from the deck
        # First thing first is to get the column that we are adding the card to
        # Which can be done by doing base_address + i * 4, with i as $s2
        li $t7, 4 # Load 4 for multiplication
        
        # Then we will do i * 4 and store the result into $t0
        mul $t0, $s2, $t7
        
        # And we can add the offset with the base_address and store it into $t0 again
        add $t0, $t0, $s0
        
        # We must load the actual word that is stored in that effective address
        lw $t0, 0($t0)
        
        # Okay great we have the card_list struct of where we are adding the
        # drawn card to which is in $t0
        # Next step is to actually draw the top card from the deck
        # Let's grab the head address from our card_list and put it into $t1
        lw $t1, 4($s1)
        
        # Now before we can get the card value we must change the card to face up
        # which have the ascii value of 'u' at byte #2
        li $t7, 'u' # Load 'u' for storing the byte
        
        # Then we can store the byte at byte #t2 of the head address
        sb $t7, 2($t1)
        
        # Then we can get the card value of the head card and put it again back into $t1
        lw $t1, 0($t1)
        
        # Now we have what we have to append to this column and the column we are appending to
        # $a0 -> The card_list struct we are adding the card to
        # $a1 -> The card integer that we are adding it
        move $a0, $t0 # The card_list we are adding the card value to
        move $a1, $t1 # The card integer that we are adding
        
        # Then we can actually append the card into the card_list column
        jal append_card
        
        # Okay great we added the card, the size of the column is handled already by append_card
        # what we have to do now is to decrease the size of our deck and remove the
        # card that we have just drawn out from the deck
        # We will move the head of deck card_list to point at the next card
        # We load in the head address first into $t0
        lw $t0, 4($s1)
        
        # Then we get the next address of the first card into $t1
        lw $t1, 4($t0)
        
        # And we can just store this address as the head of the deck card_list
        sw $t1, 4($s1)
        
        # Then don't forget we have to decrement the size of the deck card_list as well
        lw $t0, 0($s1) # Load in the current size of the deck
        
        # We subtract 1 from it
        addi $t0, $t0, -1
        
        # Then store the word back into the size of the deck
        sw $t0, 0($s1)
        
        # Next all we have to do is to increment the counter
        addi $s2, $s2, 1
        
        # And jump back up the loop
        j for_loop_to_deal_9_cards
    
    finished_loop_to_deal_9_cards:
    # If we are here then that means we have finished dealing the 9 cards from the deck
    # we can proceed to start restoring the $s registers and deallocate the memory
    lw $s0, 0($sp) # Saving the $s0 register
    lw $s1, 4($sp) # Saving the $s1 reigster
    lw $s2, 8($sp) # Saving the $s2 register
    lw $s3, 12($sp) # Saving the $s3 register
    
    # We have to also restore the return address else it won't know where to return it
    lw $ra, 16($sp)
    
    # We can have to deallocate the memory we have used
    addi $sp, $sp, 20 # Deallocating the 20 bytes of memory we have used
    
    # Then we can just jump back to the caller as we are done with this algorithm URGH
    jr $ra

move_card:
    # This function will actually do the game move that is encoded in the move argument
    # using the given gameboard and the deck of cards. If the move is valid then
    # we actually do it. If not then we just return -1
    
    # $a0 -> The pointer that points to array of 9 pointers
    # $a1 -> The pointer that points to a valid card_list that represent a deck of cards
    # $a2 -> An integer that encodes a game move
    # Output -> $v0, Returns -1 if check_movee say it is an illegal move in anyway
    # or it return 1 if the given move is executed
    
    # Since we will be calling functions throughout this method we will have to save
    # the arguments in the $s registesr
    # 3 argument, 12 bytes plus 4 more byte for return address. 16 bytes for now
    # 2 more $s registers, 8 more bytes
    addi $sp, $sp, -24 # Allocating 24 bytes of memory on the run time stack
    
    # Saving the $s registers
    sw $s0, 0($sp) # Saving the $s0 register
    sw $s1, 4($sp) # Saving the $s1 register
    # 8($sp) will be left empty for storing the move
    sw $s2, 12($sp) # Saving the $s2 register
    sw $s3, 16($sp) # Saving the $s3 register
        
    # We also have to save the return address else it won't know where to return to
    sw $ra, 20($sp)
    
    # Then we can proceed to save the arguments in the $s registers
    move $s0, $a0 # $s0 will be the pointer that points to the array of 9 pointers 
    move $s1, $a1 # $s1 will be the pointer that points to the card_list that represent deck of cards
    # Instead of saving the move in a $s register we will save it on the stack directly
    # at 8($sp). So 8($sp) gives byte #0, 9($sp) gives byte #1 and so on
    sw $a2, 8($sp)
    
    # First things first we have to call check_move to see if the given move is
    # valid or not
    # $a0 -> The board array we are using
    # $a1 -> The deck of cards
    # $a2 -> The game move
    move $a0, $s0
    move $a1, $s1
    lw $a2, 8($sp) # We just have to load the word from the run time stack to get the move integer back
    
    # Now we can actually call the function check_move
    jal check_move
    
    # In $v0 we have values from -1 to -8 inclusive that signal an illegal move
    # and values from 1 to 3 inclusive that signals a legal move 
    # So if $v0 is anything that is less than 0 then we will just return -1 since it is an illegal move
    blt $v0, $0, move_card_illegal_move
    
    # Now if we are here then that means $v0 is either
    # 1 a legal deal move
    # 2 a normal move that moves cards from donor column to a empty recipient column
    # 3 a normal move that moves cards from donor column to a non-empty recipient column
    # We will break into different cases based on the return value
    li $t7, 1 # Load 1 for comparsion
    
    # If the return value from check_move is 1 then we do deal_move
    beq $v0, $t7, move_card_deal_move 
    
    li $t7, 2 # Load 2 for comparsion
    
    # If the return value from check_move is 2 then we do normal_move_empty_column
    beq $v0, $t7, move_card_normal_move_to_empty_column
    
    # Now if we are here then it is only one option what the check_move returned
    # which is 3 and that means normal move to nonempty column
    j move_card_normal_move_to_nonempty_column
    
    
    move_card_deal_move:
    # If we are here then that means we are just simply doing a deal_move
    # We will call deal_move first to deal out the cards
    # $a0 -> The board that we are dealing the cards to
    # $a1 -> The deck that we are deaaling the cards from
    move $a0, $s0 # The boards that we are dealing the cards to
    move $a1, $s1 # The deck of cards
    
    # Then we can call deal_move to actually deal out the cards
    jal deal_move
    
    # Okay so after the previous function calls we have deal out the cards already
    # now the next step is to call clear_full_straight on every single columns
    # to try to cleare out any full straight that it has
    # We will be doing that over a for loop
    # And we will use $s2 to keep it as our counter starting at 0
    # and $s3 as our stopping condition which is 9
    li $s2, 0
    li $s3, 9
    
    # Now we can begin our for loop to call clear_full_straight on all the columns
    for_loop_to_clear_full_straight_on_all:
        # Let's just get the stopping condition out of the way which is when 
        # our counter is greater than or equal to 9, that means we have
        # called clear_full_straight on all the 9 columns already
        bge $s2, $s3, finished_loop_clear_full_straight_on_all
    
        # However if we are here then that means we haven't finished calling
        # clear_full_straight on all of the columns yet so we have to do it here
        # $a0 -> The board of columns we are looking at
        # $a1 -> The specific column index we are clearing the straight from
        move $a0, $s0 # The board of arrays we are going through
        move $a1, $s2 # The specific column index we are clearing the straight
        
        # Then we can call clear_full_straight
        jal clear_full_straight
        
        # And after the previous call we can move onto the next column to clear the straight
        # We increment our counter
        addi $s2, $s2, 1
        
        # And jump back up the loop for next iteration
        j for_loop_to_clear_full_straight_on_all
    
    finished_loop_clear_full_straight_on_all:
    # If we are here then that means we have finished calling clear_full_straight on
    # all of the board columns and we can just return 1 since we sucuessfully
    # executed a deal move
    li $v0, 1
    
    # And we can jump ti finished algorithm
    j finished_move_card_algorithm
    
    
    move_card_normal_move_to_empty_column:
    # If we are here then that means we are moving one or more or entire column
    # of cards to the recipient column which is empty
    # Now there are two cases to consider, case when the row is 0, meaning moving the
    # entire column or it could just mean 1 card. The other case is when the row is not 0
    # meaning moving 1 or more cards but not the entire column
    
    # Let's get the donor column's address
    lbu $t0, 8($sp)
    
    # Then calculate the effective address of where donor column is stored
    li $t7, 4 # 4 for multiplication
    
    # i * 4 into $t1
    mul $t1, $t0, $t7
    
    # Then we add the offset to the base_address and store it into $t0 again
    add $t0, $s0, $t1
    
    # Now we have to actually load in the content of effective address into $s2
    lw $s2, 0($t0)
    
    # Let's get the recipient column's address too
    lbu $t0, 10($sp)
    
    # Then i * 4 again into $t1
    mul $t1, $t0, $t7
    
    # And add it to the offset of the base_address and store it into $t0 again
    add $t0, $s0, $t1
    
    # Then load the actual content of the effective address into $s3
    lw $s3, 0($t0)
    
    
    # Okay before we split into two cases again let's recap
    # $s2 have the address of the donor column
    # $s3 have the address of the recipient column

    
    # Let's get the row into $t0 and break it up into different cases
    lbu $t0, 9($sp)
    
    # If the donor row we are taking from is actually 0 then that means
    # we are moving the entire row or only one card, it doesn't matter
    # we are moving the entire row
    beq $t0, $0, normal_move_to_empty_column_entire_column
    
    # However, if we are here then we are not moving an entire column
    # hence more work is needed
    j normal_move_to_empty_column_not_entire_column
    
    
    normal_move_to_empty_column_entire_column:
    # If we are here then that means we are going to move the entire donor
    # column to an empty recipient column
    # We have to get the head address and the size of the donor column first
    # We will put the head address into $t0
    lw $t0, 4($s2)
    
    # And the size of the donor column into $t1
    lw $t1, 0($s2)
    
    # Now since we are moving the entire column we have to clear out everything
    # of the donor column so we just have to set size to 0, and head to 0
    sw $0, 0($s2) # Size to 0
    sw $0, 4($s2) # Head to 0 (null)
    
    # Then we store the head address we have into the recipient column
    sw $t0, 4($s3) # Put head address as head address of the recipient column
    sw $t1, 0($s3) # Update the size of the recipient column as well
    
    # Now we have to call clear_full_straight only on the recipient column
    # $a0 -> The board to clear the full straight in
    # $a1 -> The specific column that we want to clear the full straight in which is recipient column
    move $a0, $s0 # The board array that we are clearing full straight in
    lbu $a1, 10($sp) # The recipient column's index
    
    # Then we can just call the method
    jal clear_full_straight
    
    # Then we load in 1 as our output value
    li $v0, 1
    
    # And we can jump to finish
    j finished_move_card_algorithm
    
    
    normal_move_to_empty_column_not_entire_column:
    # If we are here then that means we are going to move only part of the donor
    # column to an empty recipient column
    # We will have to get the important card's next address and the size we can calculate later
    # We need a for loop to traverse up to that point which is row - 1
    # Let's load the row in first into $t1
    lbu $t1, 9($sp)
    
    # Then we subtract 1 from it which gives us the index of the important card
    addi $t1, $t1, -1
    
    # We will have a counter which starts at 0
    li $t0, 0
    
    # And we will also need a currNode pointer which starts at the head of the donor column
    lw $t2, 4($s2)
    
    # This for loop will help us locate the address of that important card
    # which we can use to cut off the cards we are moving
    # and help us get the cards we are moving to recipient column
    for_loop_to_find_the_important_card_part1:
        # Get the stopping condition out of the way first
        # which is whenever our counter is greater than or equal to $t1
        bge $t0, $t1, finished_loop_to_find_important_card_part1
    
        # If we are still in this for loop then that means we haven't reach the important card yet
        # let's just increment 
        # Our currNode pointer will be the next, let's load in next into $t3
        lw $t3, 4($t2)
        
        # Then we update our currNode to be next
        move $t2, $t3
        
        # Then we also have to increment our counter
        addi $t0, $t0, 1
        
        # And jump back up the for loop
        j for_loop_to_find_the_important_card_part1
    
    finished_loop_to_find_important_card_part1:
    # If we are outside of the previous for loop that means $t2 have the
    # address of the important card
    # We get the next of the important card into say $t3
    lw $t3, 4($t2)
    
    # To calculate the new size we first have to do size - row of donor column
    # Load in the size again into $t0
    lbu $t0, 0($s2)
    
    # We also need the row again into $t1
    lbu $t1, 9($sp)
    
    # Then we subtract the size - row and put the result into $t3
    sub $t3, $t0, $t1
    
    # So $t3 is how many cards we are taking from donor column which will be the
    # new size of the recipient column
    # Now subtracting size with $t3 will gives us how many cards are left in the donor column
    # let's put that into $t4
    sub $t4, $t0, $t3
    
    # So $t3 is the new size for recipient column
    # $t4 is the new size for donor column
    # $t2 is the imporatnt card
    # Let's load in the address of the next of the important card into $t0
    lw $t0, 4($t2)
    
    # We set the recipient column's head to this address
    sw $t0, 4($s3)
    
    # Then we have to update the recipient column's size which is just $t3
    sw $t3, 0($s3)
    
    # Lastly we also have to update the important card's next to be 0
    sw $0, 4($t2)
    
    # And update the donor column's size to be $t4
    sw $t4, 0($s2)
    
    # We also have to flip the important 'over'
    li $t7, 'u' # 'u' for storing a flipped over card
    
    # We store this byte at byte #2 of the important card to flip it over
    sb $t7, 2($t2)
    
    # Now we have to call clear_full_straight only on the recipient column
    # $a0 -> The board to clear the full straight in
    # $a1 -> The specific column that we want to clear the full straight in which is recipient column
    move $a0, $s0 # The board array that we are clearing full straight in
    lbu $a1, 10($sp) # The recipient column's index
    
    # Then we can just call the method
    jal clear_full_straight
    
    # Then we load in 1 as our output value
    li $v0, 1
    
    # Anddd we are finished! We can just jump to finished algorithm
    j finished_move_card_algorithm
    
    
    move_card_normal_move_to_nonempty_column:
    # If we are here then that means we are moving one or more or entire column
    # of cards to the recipient column which is nonempty
    
    # Let's get the donor column's address
    lbu $t0, 8($sp)
    
    # Then calculate the effective address of where donor column is stored
    li $t7, 4 # 4 for multiplication
    
    # i * 4 into $t1
    mul $t1, $t0, $t7
    
    # Then we add the offset to the base_address and store it into $t0 again
    add $t0, $s0, $t1
    
    # Now we have to actually load in the content of effective address into $s2
    lw $s2, 0($t0)
    
    # Let's get the recipient column's address too
    lbu $t0, 10($sp)
    
    # Then i * 4 again into $t1
    mul $t1, $t0, $t7
    
    # And add it to the offset of the base_address and store it into $t0 again
    add $t0, $s0, $t1
    
    # Then load the actual content of the effective address into $s3
    lw $s3, 0($t0)
    
    
    # $s2 have the address of the donor column
    # $s3 have the address of the recipient column
    # Then we will split into two cases again where the row could be 0
    # meaning we take the entire column. If it is not 0 then that means
    # we are not taking the entire column, could be one card or more cards
    # Let's load in the row index again into $t0
    lbu $t0, 9($sp)
    
    # If the row is equal to 0 then we move the entire row
    beq $t0, $0, normal_move_to_nonempty_column_entire_column
    
    # However if the row is not equal to 0 then we only move partial row
    j normal_move_to_nonempty_column_not_entire_column
    
    
    normal_move_to_nonempty_column_entire_column:
    # If we are here then we are moving the entire donor column into
    # a nonempty recipient column which shouldn't be that bad to handle i hope
    # We have to get the head and size of the donor row
    # Let's get the head address into $t0
    lw $t0, 4($s2)
    
    # And the size into $t1
    lw $t1, 0($s2)
    
    # Now we have to find the last card of the recipient column before we can append these the recipient column
    # We will of course do that through a for loop
    # We will let $t2 be our counter
    li $t2, 0
    
    # We will let the size - 1 of the recipient column be our stopping condition
    lw $t3, 0($s3)
    addi $t3, $t3, -1
    
    # Then we keep a currNode pointer in $t4 which initially points at the head of the recipient column
    lw $t4, 4($s3)
    
    # Now we can begin our for loops to find the last card in the recipient column
    for_loop_to_find_tail_of_recipient_column_part1:
        # Let's just get the stopping condition out of the way first
        # which is when our counter is greater than or equal to the stopping condition
        bge $t2, $t3, finished_loop_to_find_tail_of_recipient_column_part1
        
        # If we are here then we haven't yet reach the last card hence we have to increment
        # our counters. We load the next address of the currNode pointer into $t5
        lw $t5, 4($t4)
        
        # Then update our currNode pointer to that next node
        move $t4, $t5
        
        # And increment our counter
        addi $t2, $t2, 1
        
        # Jump back up the loop
        j for_loop_to_find_tail_of_recipient_column_part1
    
    finished_loop_to_find_tail_of_recipient_column_part1:
    # If we are here then we have found the address of the last CardNode in the recipient
    # column in $t4. Then we can proceed to append the cards from the donor column
    # All we have to do is change the last card's next to be $t0
    sw $t0, 4($t4)
    
    # And we have to add the size of the donor column to the recipient's size
    # Get the recipient column's size into $t5
    lw $t5, 0($s3)
    
    # Add the donor column's size with the recipient column's size
    add $t5, $t5, $t1
    
    # And just store it back in
    sw $t5, 0($s3)
    
    # Don't forget to change the head of donor's column to 0 as well because we moved the entire row
    sw $0, 4($s2)
    
    # And we also have to update the donor column's size to 0 as well since we move entire row
    sw $0, 0($s2)
    
    # Now we have to call clear_full_straight only on the recipient column
    # $a0 -> The board to clear the full straight in
    # $a1 -> The specific column that we want to clear the full straight in which is recipient column
    move $a0, $s0 # The board array that we are clearing full straight in
    lbu $a1, 10($sp) # The recipient column's index
    
    # Then we can just call the method
    jal clear_full_straight
    
    # Then we load in 1 as our output value
    li $v0, 1
    
    # And be done with this function
    j finished_move_card_algorithm
    
    
    normal_move_to_nonempty_column_not_entire_column:
    # If we are here then we are only moving one or more cards not the entire
    # column of the donor column to a nonempty recipient column
    # Again we will need a for loop to help us traverse through the linked list
    # until we find that important CardNode which is located at row - 1 index
    lbu $t1, 9($sp)
    
    # Then we subtract 1 to get us the index of the important card
    addi $t1, $t1, -1
    
    # Then we will have a counter which starts at 0
    li $t0, 0
    
    # We will also need a currNode pointer which starts at he head of the donor column in $t2
    lw $t2, 4($s2)
    
    # Okay great we can begin our for loop to search for that important card
    for_loop_to_find_the_important_card_part2:
        # Let's just get our stopping condition out of the way
        # which is when the counter is greater than or equal to the stopping condition
        bge $t0, $t1, finished_loop_to_find_important_card_part2    
    
        # However if we are here then we haven't reach the important card's index and address yet
        # hence we have to increment everything
        # Load the next's address into $t3
        lw $t3, 4($t2)
        
        # And update $t2
        move $t2, $t3
        
        # Increment our counter
        addi $t0, $t0, 1
        
        # Jump back up the loop
        j for_loop_to_find_the_important_card_part2
    
    finished_loop_to_find_important_card_part2:
    # If we are here $t2 have the address of the important card
    # Now we also need to find the address of the last card in the recipient column
    # Let $t0 be our counter
    li $t0, 0
    
    # And $t1 be our stopping condition which is the recipient size - 1
    lw $t1, 0($s3)
    
    # Subtract 1 to get the last card index
    addi $t1, $t1, -1
    
    # Then we let $t3 be our currNode pointer
    lw $t3, 4($s3)
    
    for_loop_to_find_tail_of_recipient_column_part2:
        # Get the stopping condition out of the way first
        # which is when counter is greater than or equal to the stopping conditrion
        bge $t0, $t1, finished_loop_to_find_tail_of_recipient_column_part2
    
        # Here we haven't reach the recipient column's last card hence increment
        # we put the next in $t4
        lw $t4, 4($t3)
        
        # Then we update currNode pointer to be next
        move $t3, $t4
        
        # Increment our counter
        addi $t0, $t0, 1
        
        # Jump back up the loop
        j for_loop_to_find_tail_of_recipient_column_part2
    
    finished_loop_to_find_tail_of_recipient_column_part2:
    # If we are here then that means $t2 have the address of the important card in donor column
    # and $t3 is the address of the last card in recipient column
    # We get the next address of the important card in $t0
    lw $t0, 4($t2)
    
    # Then we make recipient column's last card point to that as well
    sw $t0, 4($t3)
    
    # Then we have to make important card next to point to 0
    sw $0, 4($t2)
    
    # And we update the size on both columns
    # Load in the current donor column size into $t0
    lw $t0, 0($s2)
    
    # We subtract the donor column size - row
    lbu $t1, 9($sp) # Load in the row
    sub $t4, $t0, $t1 # The result in $t4 is how many cards we are taking
    
    # Then we subtract size with how many cards we are taking which
    # will give us how many cards are left in $t5
    sub $t5, $t0, $t4
    
    # So $t4 is what we have to add to the recipient column's size
    # $t5 is the new size for the donor column
    sw $t5, 0($s2) # update the size for donor column
    
    # Then we get the current size of the recipient column in $t0
    lw $t0, 0($s3)
    
    # We add how many cards we took in $t4 with it
    add $t0, $t0, $t4
    
    # And store that back into recipient column
    sw $t0, 0($s3)
    
    # We also have to flip the important 'over'
    li $t7, 'u' # 'u' for storing a flipped over card
    
    # We store this byte at byte #2 of the important card to flip it over
    sb $t7, 2($t2)
    
    # Finally we have to call clear_full_straight on the recipient column
    # $a0 -> The board we are clearing
    # $a1 -> The specific column we are clearing the straight which is recipient column
    move $a0, $s0
    lbu $a1, 10($sp)
    
    # Call the method
    jal clear_full_straight
    
    # We return 1 as we have sucessfully executed the algorithm
    li $v0, 1
    
    # And jump to finish algorithm
    j finished_move_card_algorithm
    
    
    move_card_illegal_move:
    # If we are here then that means the encoded move given is an illegal move
    # we just have to return -1 
    li $v0, -1
    
    # Just follow logically to finish this algorithm
    
    finished_move_card_algorithm:
    # If we are here then that means we are done with this algorithm
    # we can start restoring the $s registers and deallocate the memories we have used
    lw $s0, 0($sp) # Restoring the $s0 register
    lw $s1, 4($sp) # Restoring the $s1 register
    lw $s2, 12($sp) # Restoring the $s2 register
    lw $s3, 16($sp) # Restoring the $s3 register
    # We didn't use register for 8($sp) so we don't have to restore a $s register for it
    
    # Then we also have to restore the return address else move_card won't know where to return to
    lw $ra, 20($sp)
    
    # And finally deallocate the memories we have used
    addi $sp, $sp, 24 # Deallocating the 24 bytes of memory we have used

    # Jump back to the caller    
    jr $ra

load_game:
    # The function opens the file and use the content to initialize the board
    # deck and moves

    # $a0 -> The filename that we are reading from
    # $a1 -> The address that represents the array of 9 pointers that points to
    # 9 different card_list structs in which all 9 card_list are all uninitalized  
    # $a2 -> An uninitialized card_list struct that is suppose to store the deck of cards
    # $a3 -> An address that represents an allocated memory that is large enough to store all the
    # moves that is in the file
    # Output -> $v0, -1 if the file is not found 1 if the file is open successfully
    # Output -> $v1, -1 if the file is not found, else the number of moves in the moves array    
    
    # We have to save the arguemnts because we are calling functions
    # 4 arguments 16 bytes, and 4 more byte for the return address so total of 20 bytes
    # we need to also allocate 4 more bytes for the file reader to store the byte that is read from the file
    # 3 more gister so 12 more bytes
    addi $sp, $sp, -36 # Allocating 36 bytes of memory on the stack
    
    # Saving the $s registers before we can use them
    sw $s0, 4($sp) # Saving the $s0 register
    sw $s1, 8($sp) # Saving the $s1 register
    sw $s2, 12($sp) # Saving the $s2 register
    sw $s3, 16($sp) # Saving the $s3 register
    sw $s4, 20($sp) # Saving the $s4 register
    sw $s5, 24($sp) # Saving the $s5 register
    sw $s6, 28($sp) # Saving the $s6 register

    # Then we also have to save the return address else it won't know where to return to
    sw $ra, 32($sp)    
    
    # We will leave 0($sp) for the file descriptor to put the read byte there
    
    # Now we can save our arguments
    move $s0, $a0 # $s0 will have the file name
    move $s1, $a1 # $s1 will have the address that represent the array of 9 pointers to 9 card_list struct
    move $s2, $a2 # $s2 will be the uninitalized card_list struct that represent deck of cards
    move $s3, $a3 # $s3 will be the address that points to a region memory that will be array of integers help store the encoded move integers 
    
    # Let's open our file first by calling syscall 13
    # $a0 -> The file name we are opening
    # $a1 -> is the flag should just be 0 for reading
    # $a2 -> Mode is just ignored so just 0
    move $a0, $s0
    li $a1, 0
    li $a2, 0
    
    # Then we load in the syscall into $v0 and do the syscall
    li $v0, 13
    syscall
    
    # Now in $v0 we have the file descriptor we should save this on the $s4 register
    # so we won't lose it 
    move $s4, $v0 # Saving the file descriptor
    
    # Then we will do a if-statement check if the file is opened sucessfully
    # if the return file descriptor is a negative number then that means it is an error opening the file
    blt $s4, $0, file_opening_error
    
    # However, if we are here then the file is opened sucessfully
    # then we can start doing our parsing algorithm
        
        
    parse_for_line_one_beginning:
    # This is the first time we are entering parse_for_line_one
    # hence we have to initialize the deck first before we start reading and appending the cards
    # $a0 -> The card_list to initialize
    move $a0, $s2
    
    # Then we call the init_list to initialize the card_list
    jal init_list

        
    parse_for_line_one:
    # If we are here then that means we are currently parsing the first line
    # which parse for the starting deck of cards    
    # We'll start with this one which is required to read two character at a time
    
    # We read only one character first, if it is a \n which has ascii value of 10
    # then that means we go to parse_for_line_two, else we stay in parse_for_line_one
    # and actually parse it
    # $a0 -> The file descriptor
    # $a1 -> The input buffer that we are storing the character to
    # $a2 -> The number of charactersd we are reading which is just 1
    move $a0, $s4 # The file descriptor
    move $a1, $sp # We are reading the character to the run time stack
    li $a2, 1 # Reading 1 character at a time    
    
    # Actually read it
    li $v0, 14
    syscall
    
    # Now in 0($sp) we have the byte that is read let's get it and put it into $t0
    lbu $t0, 0($sp)
    
    # Load in '\n' for comparsion
    li $t7, '\n'
    
    # If the character that we read is actually a new line then we go to the next line and
    # parse the second line. We are done with parsing the first line
    beq $t0, $t7, parse_for_line_two_beginning
    
    # However if we are here then that means we haven't yet finish parsing line one
    # hence let's start parsing. So we already got 1 character which is the card's rank in $t0
    # we have to call it again to read the second part of the card. I know it is not needed but it
    # will help us increment the file descriptor
    # $a0 -> The file descriptor
    # $a1 -> The input buffer that we are storing the character to
    # $a2 -> The number of charactersd we are reading which is just 1
    move $a0, $s4 # The file descriptor
    move $a1, $sp # We are reading the character to the run time stack
    li $a2, 1 # Reading 1 character at a time    
    
    # Actually read it
    li $v0, 14
    syscall
    
    # We store the faceup or facedown into $t1
    lbu $t1, 0($sp)
    
    # Let's review $t0 have the rank of the card and $t1 have the faceup or facedown attribute
    # $t2 will be the suit of the card which is just 'S' for all of the card because we are playing
    # one suit solitaire
    # now we have to make the integer for it and append it to the deck
    li $t2, 'S'
    
    # For the faceup or facedown attribute we shift 16 bit to the left
    sll $t1, $t1, 16
    
    # For the suit of the card we shift 8 bit to the left
    sll $t2, $t2, 8
    
    # We don't have to shift anything for the rank
    # Now the integer of the card we are going to make will be stored into $t4 which starts with 0
    li $t4, 0
    
    # Then we add the faceup and facedown to $t4
    add $t4, $t4, $t1
    
    # Then we add the suit
    add $t4, $t4, $t2
    
    # Then we add the rank of the card in ascii not in numbers
    add $t4, $t4, $t0
    
    # Finally $t4 have the card_value that we are going to append to the deck
    # and let's append it
    # $a0 -> The card_list we are appending the card into
    # $a1 -> The card integer value we are appending
    move $a0, $s2
    move $a1, $t4
    
    # Then we call the function to append it
    jal append_card
    
    # After appending the card we have to jump back up the function as a loop
    j parse_for_line_one
        
        
    parse_for_line_two_beginning:
    # Now if we are here then we just finished parsing the first line of the file
    # now we begin parsing for the second line of the file
    # Now there is nothing to do for the beginning of parsing line two
    # except we have to make a counter for counting the number of moves we have stored
    # which we can use $s0 for because we have open the file already
    li $s0, 0 # Our counter for the number of moves we have parsed
    
    parse_for_line_two: 
    # If we are here then that means we are currently parsing the second line
    # which handles parsing the moves 
    # Okay let's read in the first byte of the second line first
    # $a0 -> The file descriptor
    # $a1 -> The input buffer which is just $sp
    # $a2 - > The number of bytes we are reading which is just 1 byte
    move $a0, $s4
    move $a1, $sp
    li $a2, 1
    
    # Okay we call syscall 14
    li $v0, 14
    syscall
    
    # We get the first byte into $t0
    lbu $t0, 0($sp)
    
    # We will do some if_statement checking
    li $t7, '\n' # Load in '\n' for comparsion
    
    # If the byte that we read is a new line then that means we have finished
    # parsing for line two and we need to move onto to parse for line three or more
    beq $t0, $t7, parse_for_line_three_or_more_beginning
    
    # The other case we have to also check for is spaces
    li $t7, ' ' # Load in ' ' for comparsion
    
    # If we load in a space we just have to ignore it and go to the next iteration
    beq $t0, $t7, parse_for_line_two
    
    # And if it is not space and not new line then it has to be ascii values for the encoded moves
    # Which means we are allowed to read the other 3 bytes now
    # Keep in mind we have the digit read in $t0 which represent byte #0 of moves
    
    # We have to call syscall 14 three more times
    move $a0, $s4
    move $a1, $sp
    li $a2, 1
    
    # Okay we call syscall 14
    li $v0, 14
    syscall
    
    # This is our byte #1 of moves
    lbu $t1, 0($sp) 
    
    # Calling syscall 14 two more times
    move $a0, $s4
    move $a1, $sp
    li $a2, 1
    
    # Okay we call syscall 14
    li $v0, 14
    syscall
    
    # This is our byte #2 of moves
    lbu $t2, 0($sp)
    
    # Calling syscall 14 one more time
    move $a0, $s4
    move $a1, $sp
    li $a2, 1
    
    # Okay we call syscall 14
    li $v0, 14
    syscall
    
    # This is our byte #3 of moves
    lbu $t3, 0($sp)
    
    # $t0 -> byte #0
    # $t1 -> byte #1
    # $t2 -> byte #2
    # $t3 -> byte #3
    # We have to actually subtract each value by 48 first to get their numerical value from ascii value
    addi $t0, $t0, -48
    addi $t1, $t1, -48
    addi $t2, $t2, -48
    addi $t3, $t3, -48
    
    # Okay now we can actually begin making our move integer for us to append
    # byte #3 need to be shifted 24 bit
    # byte #2 need to be shifted 16 bit
    # byte #1 need to be shifted 8 bit
    # byte #0 don't need to be shiftted
    sll $t3, $t3, 24
    sll $t2, $t2, 16
    sll $t1, $t1, 8
    
    # Okay then all we have to do is to add them all together all into $t4
    li $t4, 0 # We initialize it to be 0
    add $t4, $t3, $t2
    add $t4, $t4, $t1
    add $t4, $t4, $t0
    
    # Finally $t0 have the encoded integer which we have to store it as word
    # onto the moves array
    sw $t4, 0($s3)
    
    # After we store it we have to increment our counter
    addi $s0, $s0, 1
    
    # We also have to increment the address we have to store the next move
    addi $s3, $s3, 4
    
    # And finally we can jump back up the loop
    j parse_for_line_two

    
    parse_for_line_three_or_more_beginning:
    # If we are here then that means we are going to
    # parse the third or more lines which handles the starting
    # configuration of the boards
    
    # The first thing we have to do is to call init_list on each of the 9 entries
    # of the board array. Initializing all of the 9 card_list structs before we can proceed
    # We can put our counter in $s5 and our stopping condition into $s6
    li $s5, 0
    li $s6, 9
    
    # Then we can start our for loop to initialize all the 9 card_list 
    for_loop_to_initialize_columns:
        # Let's get the stopping condition out of the way first
        # which is whenever our counter is greater than or equal to our stopping condition
        # that means we have finished initializing all 9 columns of the board array
        bge $s5, $s6, finished_loop_to_initialize_columns
    
        # If we are here then that means we haven't yet finished
        # initiailzing all of the 9 columns in the board array
        # So let's begin cleaning, we have to calculate the effective address
        # of where the pointer that is stored in the board array
        # the formula is base_address + i * 4
        li $t7, 4 # Load 4 for multiplication
        
        # Then we multiply the index with 4 and store the product into $t0
        mul $t0, $s5, $t7
        
        # Then we can add the base_address of board array with the offset to get effective address into $t1
        add $t1, $s1, $t0
        
        # Okay so the content that is store at address $t1 is the pointer that we have to initialized
        # we can just load the content into $a0 as our argument for init_list
        # $a0 -> The card_list we are initializing
        lw $a0, 0($t1)
        
        # And we can call the function init_list
        jal init_list
        
        # And after we have finished initializing this list we have to increment our counter
        addi $s5, $s5, 1
        
        # And jump back up the loop
        j for_loop_to_initialize_columns
    
    finished_loop_to_initialize_columns:
    # If we are here then all 9 card_list in board array is initialized and we can begin our parsing process
    # which we can do just by following logically
    
    # But before we go we need a counter to keep track of which column we are adding the card to
    # which we will use $s5 reigster for that
    li $s5, 0
    
    
    parse_for_line_three_or_more:
    # If we are here then that means we are currently parsing the third or more lines
    # which handles the starting configuration of the boards
    # The step is very similar to the other two we will read only the first byte of the line
    # first. If it is an ascii that represent a card, then we will read the other byte
    # If it is a ' ' then we will read the other ' ' and go to the next iteration without any work
    # If it is a '\n' then we will just skip to the next iteration to read next line
    # If it receives a 0 in $v0 that means we reached the end of the file hence we are complete!
    
    # Say less and begin our reading
    # $a0 -> The file descriptor
    # $a1 -> The input buffer which is just $sp
    # $a2 - > The number of bytes we are reading which is just 1 byte
    move $a0, $s4
    move $a1, $sp
    li $a2, 1
    
    # Okay we call syscall 14
    li $v0, 14
    syscall
    
    # The first thing we should do is check the return value in $v0, if it is 0
    # then that means the end of the file is reached hence we can stop reading
    beq $v0, $0, finished_parsing_line_three_or_more

    # However if we haven't reach the end of the file yet then we will keep parsing
    # We will load the byte we just read into $t0
    lbu $t0, 0($sp)

    # We will check for ' ' spaces first
    li $t7, ' ' # Load ' ' for comparsion
    
    # If the byte we read is a space then we just have to read
    # the other space as well and jump back up the loop
    beq $t0, $t7, line_three_or_more_found_space
    
    # However, if it is not a space then we will check if it is a '\n'
    li $t7, '\n' # Load '\n' for comparsion
    
    # If we read the byte '\n' then we just have to skip to the next iteration
    # to read from the next line. Don't need to increment column counter
    beq $t0, $t7, parse_for_line_three_or_more
    
    # Now finally if we are here then we are reading a value for the cards
    # then we have to also read the other byte as well
    move $a0, $s4
    move $a1, $sp
    li $a2, 1
    
    # Okay we call syscall 14
    li $v0, 14
    syscall
    
    # We will put the other byte that read into $t1
    lbu $t1, 0($sp)
    
    # So let's summarize what we have so far
    # $t0 have the rank of the card in ascii
    # $t1 have the faceup or facedown of the card in ascii
    # We will put the suit which is all 'S' into $t2
    li $t2, 'S'
    
    # Then here we need to do some shiftings
    # $t0 the rank don't need any shifts
    # $t1 which is the faceup or facedown need to be shifted 16 bits
    # $t2 which is the suit need to be shifted 8 bits
    sll $t1, $t1, 16
    sll $t2, $t2, 8
    
    # We will store the card value into $t4 and it need to be initialized with 0
    li $t4, 0
    
    # Then we can just add them all up
    add $t4, $t4, $t1 # Add the faceup or facedown
    add $t4, $t4, $t2 # Add the suit
    add $t4, $t4, $t0 # Add the rank
    
    # Finally we have the card_value we are adding to the card_list in $t4
    # and the column we are adding it to is in $s5
    # We first have to divide $s5 by 9 first and get the remainder
    li $t7, 9 # 9 for division
    
    # Do the division
    div $s5, $t7 
    
    # Then we have the remainder in hi let's save it into $t0
    mfhi $t0
    
    # Next we have to calculate the effective address of where that pointer
    # is stored in the board array. base_address + i * 4
    li $t7, 4 # Load 4 for mulitplication
    
    # We do i * 4 and store result into $t1
    mul $t1, $t0, $t7
    
    # Then we add the offset to the base_address $s1 and store the result into $t2
    # which is the effective address
    add $t2, $s1, $t1
    
    # Okay great in the effective address $t2 is the pointer to the card_list struct
    # where we putting the card to. We can call append_card now
    # $a0 -> The card_list we are adding the card to
    # $a1 -> The card value we are adding
    lw $a0, 0($t2) # Getting the content which is the pointer store in the effective address
    move $a1, $t4 # Put the card_value we are adding to $a1
    
    # Finally we can call append_card
    jal append_card
    
    # After adding the card to the respective column we must increment our counter for the column
    addi $s5, $s5, 1
    
    # And finally jump back up the for loop
    j parse_for_line_three_or_more
    
    
    line_three_or_more_found_space:
    # If we are here then that means we have found space as the first byte
    # then we will just read the second space and just go to the next iteration
    # two spaces just means that there is no card for this column in this line
    move $a0, $s4
    move $a1, $sp
    li $a2, 1
    
    # Okay we call syscall 14
    li $v0, 14
    syscall
    
    # We also need to increment our column counter because we skip over adding a card for this column
    addi $s5, $s5, 1
    
    # We don't even care about storing it, we just want to increment our file descriptor
    # so it will read the next column's card. So all we do here is just back up the loop
    j parse_for_line_three_or_more


    finished_parsing_line_three_or_more:
    # If we are here then that means end of the file is reached
    # Let's close the file descriptor first before we do our return value
    move $a0, $s4 # The file descriptor to close
    
    # syscall 16 to close the file descriptor
    li $v0, 16
    
    # Closing the file descriptor
    syscall
    
    # Then we have finished parsing everything then all we have to do is to load $s0
    # as our return value in $v1 and 1 as our return value in $v0
    li $v0, 1
    move $v1, $s0
    
    # Then we can just jump to finish algorithm
    j finished_load_game_algorithm


    file_opening_error:
    # If we cannot open the file or the file doesn't exist then we will just
    # return (-1,-1) as our output value
    li $v0, -1
    li $v1, -1
    
    # Then we can just follow logically to finish the algorithm

    finished_load_game_algorithm:
    # If we are here then we have to start restoring the $s registers
    # and deallocate the memories we have used    
    lw $s0, 4($sp) # Restoring the $s0 register
    lw $s1, 8($sp) # Restoring the $s1 register
    lw $s2, 12($sp) # Restoring the $s2 register
    lw $s3, 16($sp) # Restoring the $s3 register
    lw $s4, 20($sp) # Restoring the $s4 register
    lw $s5, 24($sp) # Restoring the $s5 register
    lw $s6, 28($sp) # Restoring the $s6 register
    
    # We also need to restore the return address else load_game won't know where to return to
    lw $ra, 32($sp)
    
    # We don't have to restore 0($sp) to anything because that is just the buffer for the file descriptor
    # Then we can deallocate the memories we have used
    addi $sp, $sp, 36 # Deallocating the 36 bytes of memories we have used
    
    # And finally we can just return to the caller    
    jr $ra

print_move_list:
    # This function will print the give move list as hexadecimal
    
    # $a0 -> The address of where the move array is located
    # $a1 -> The size of the move integer array
    
    move $t1, $a0 # We will save the address pointer into $t1
    li $t0, 0 # This is our counter
    
    # We can begin our for loop to print each move that is listed in the integer array
    for_loop_to_print_each_move:
        # Let's get the stopping condition out of the way first which is
        # whenever our counter is greater than or equal to the size of the integer array
        bge $t0, $a1, finished_loop_to_print_each_move
    
        # If we are here then that means we haven't finished printing all of the moves
        # in the integer array let's load it and print it
        lw $a0, 0($t1)
        
        # Then we print it 
        li $v0, 34
        syscall
        
        # Print a spce
        li $a0, ' '
        li $v0, 11
        syscall
        
        # Then we have to increment our counters
        addi $t0, $t0, 1
        
        # And we have to increment our address
        addi $t1, $t1, 4
        
        # And jump back up the loop
        j for_loop_to_print_each_move
    
    finished_loop_to_print_each_move:
    # If we are here then that means we have finished printing each move we
    # can just return to the caller
    jr $ra

simulate_game:
    # This function ties everything together and simulate the game
    # based on the input in the given file
    
    # $a0 -> The file name to be open
    # $a1 -> The pointer to a array of 9 pointers to 9 card_list structs
    # $a2 -> This is the pointer that points to a uninitailized memory that represent deck of cards
    # $a3 -> The region of memory big enough to store all the moves in the file
    # Output -> $v0, -1 if the file can't be opened, else the number of valid moves were executed
    # Output -> $v1, -1 if the file can't be opened, -2 if all the moves are executed but the
    # game is not won, return 1 if the game is won which is the gameboard is cleared, and deck is empty

    # Because we will be calling functions we have to save all these arguments
    # 4 arguemnts, 16 bytes then with 4 more byte for the return address hence 20 byte in total
    # 2 more register 8 more bytes
    addi $sp, $sp, -28 # Allocating 28 bytes of memory on the run time stack
    
    # Then we have to save the $s reigsters before we can use them
    sw $s0, 0($sp) # Saving the $s0 register
    sw $s1, 4($sp) # Saving the $s1 register
    sw $s2, 8($sp) # Saving the $s2 register
    sw $s3, 12($sp) # Saving the $s3 register
    sw $s4, 16($sp) # Saving the $s4 register
    sw $s5, 20($sp) # Saving the $s5 register
    
    # Then we have to also save the return address else simulate_game won't know where to return to
    sw $ra, 24($sp)
    
    # Finally we can save the arguments into the $s registers
    move $s0, $a0 # $s0 have the filename that is needed to be open
    move $s1, $a1 # $s1 have the pointer that points to an array of 9 pointers to 9 card_list structs
    move $s2, $a2 # $s2 is the pointer that points to an uninitialized memory that represent deck of cards
    move $s3, $a3 # $s3 is the region of memory used to store the array of moves

    # The first step is to laod the game that is stored in the given file by calling load_game
    # $a0 -> The filename to load the game from
    # $a1 -> The array pointers that represent the 9 columns unintialized
    # $a2 -> The pointer that points to a card_list which represent a deck of cards uninitialized
    # $a3 -> A region of memory big enough to store all of the moves
    move $a0, $s0
    move $a1, $s1
    move $a2, $s2
    move $a3, $s3
        
    # We call the method load_game
    jal load_game
    
    # Okay now in $v0 we have whether or not the file is successfully open and read or not which returns -1
    li $t7, -1 # Load -1 for comparsion
    
    # If in $v0 it is -1 that means load_game failed which means we couldn't open the file at all
    # hence we just return (-1,-1) as our output value
    beq $v0, $t7, fail_to_load_game
    
    # But if we are here then that means the board, deck, and move and everything is
    # initialized now we can begin executing the moves in the move array
    # We need a counter to keep track of the number of valid moves we have executed
    # we can repurpose $s0 because we have loaded the files already
    li $s0, 0 # Counter for the number of valid moves executed
    
    # We will use $s4 as our index counter for the current move we are executing
    # in the moves array
    li $s4, 0
    
    # We will use $s5 as our stopping condition because that is the size
    # of the moves array which is stored in $v1 after calling load_game
    move $s5, $v1

    # Then let's begin our for loops    
    for_loop_to_execute_moves:
        # Let's just get the stopping condition out of the way which is
        # whenever our counter is greater than equal to our stopping condition
        bge $s4, $s5, finished_loop_to_execute_moves
        
        # If we are here then we haven't finished executing all the moves
        # yet hence we have to execute the move that is located in this current index
        # We have to load in the moves we are currently executing first from the array
        # The formula to calculate it is base_address + i * 4 since integer is 4 bytes
        li $t7, 4 # Load 4 for multiplication
        
        # The index we multiply is $s4 let's store the offset into $t0
        mul $t0, $s4, $t7
        
        # Then we add the offset to the base_address which is $s3
        # and store it into $t1
        add $t1, $s3, $t0
        
        # Okay we have the effective address of the move we need to execute
        # we just have to load it for move_card
        # $a0 -> The board we are playing on which is just $s1
        # $a1 -> The deck of cards we are playing with which is just $s2
        # $a2 -> The move we are executing which is in the address $t1
        move $a0, $s1
        move $a1, $s2
        lw $a2, 0($t1)
        
        # Then we call move_card
        jal move_card
        
        # Then it will return -1 if the move is illegal and nothing is done
        # or it will return 1 if the move is legal and it has done something to the game
        # We will only increment our legal move counter $s0 if it is a legal move
        li $t7, 1 # Load 1 for comparsion
        
        # If the return value in $v0 after calling move_card is 1
        # then that means we just executed a legal move hence we increment our counter
        beq $v0, $t7, increment_legal_move_counter
        
        # However if we are here then that means the move is not valid
        # hence we just jump to next_execute_move_iteration to handle incrementing of counters
        j next_execute_move_iteration
        
        increment_legal_move_counter:
        # If we are here then we have to increment our move counter
        addi $s0, $s0, 1
        
        # Then we just have to follow logically to increment the counters        
        next_execute_move_iteration:
        # If we are here then we have to handle our counter to
        # move onto the next move to execute by incrementing our counters
        addi $s4, $s4, 1
        
        # Then we jump back up the loop
        j for_loop_to_execute_moves
    
    finished_loop_to_execute_moves:
    # If we are here then that means we have finished executing all the moves
    # in $s0 we have the number of valid moves that is executed
    # Now we have to check whether or not the game has won
    # The easier condition to check first is if the deck is empty first
    # Let's load size of the deck into $t0 first
    lw $t0, 0($s2)
    
    # Now we check if it is not empty, if it is not empty then
    # the game definitely did not win and we can just return -2 as our $v1 output
    bne $t0, $0, simulate_game_did_not_win
    
    # Now if we didn't take the branch that means the deck is empty
    # next we have to check if all of the columns in the board
    # are also empty, if any of them is not empty then we
    # just return -2
    
    # We will make our counter in $t0
    li $t0, 0
    
    # Our stopping condition which is 9 in $t1
    li $t1, 9
    
    # Then we can begin our for loop to search for non-empty columns
    for_loop_to_find_nonempty_columns:
        # Stopping conditions first which is whenever
        # the counter is greater than or equal to 9
        bge $t0, $t1, finished_loop_to_find_nonempty_columns
    
        # If we are here then we haven't finishing looking at all of the columns yet
        # Let's load in the effective address of the column we are looking at
        # base_address + i * 4
        li $t7, 4 # Load in 4 for mulitplication
        
        # Then we multiply our index with 4 and store into $t2
        mul $t2, $t0, $t7
        
        # Then we add the effective address with the offset into $t3
        add $t3, $s1, $t2
        
        # Finally we load in the address that is stored at the effective address into $t4
        lw $t4, 0($t3)
        
        # And we load the size from the card_list struct into $t5
        lw $t5, 0($t4)
        
        # We check if the size is not 0 then we return -2 because 
        # there is at least one nonempty column in the board
        bne $t5, $0, simulate_game_did_not_win
        
        # If the column is indeed empty then we have to still
        # check the other columns
        # We increment the counter
        addi $t0, $t0, 1
        
        # Then jump back up the loop
        j for_loop_to_find_nonempty_columns
        
    finished_loop_to_find_nonempty_columns:
    # If we made it out of the for loop that means
    # all of the columns are empty hence we can tell the user that they have won the game!
    j simulate_game_win

    
    simulate_game_did_not_win:
    # If we are here then that means we have finished execuiting all of
    # the moves that is inside moves array but the player didn't win
    # hence we just return -2 in $v1 
    move $v0, $s0 # The number of moves executed
    li $v1, -2 # We load -2 because we didn't win the game
    
    # And we are done we can just finished_simulate_game
    j finished_simulate_game
    
    simulate_game_win:
    # If we are here then that means we have finished executing all of the moves that
    # is inside the moves array and the player win with game board empty and
    # the deck is also empty! Hence they won we just return 1
    move $v0, $s0
    li $v1, 1
    
    # And jump to finish simulating_game
    j finished_simulate_game
    
    
    fail_to_load_game:
    # If we are here then that means we couldn't open the file at all hence
    # we cannot simulate the game we just have to return (-1,-1) as our output value
    li $v0, -1
    li $v1, -1
    
    
    # Then we can just follow logically to finish algorithm
    finished_simulate_game:
    # If we are here then that means we have finished simulating the game algorithm
    # we can start restoring the $s registers we have used
    lw $s0, 0($sp) # Restoring the $s0 register
    lw $s1, 4($sp) # Restoring the $s1 register
    lw $s2, 8($sp) # Restoring the $s2 register
    lw $s3, 12($sp) # Restoring the $s3 register
    lw $s4, 16($sp) # Restoring the $s4 register
    lw $s5, 20($sp) # Restoring the $s5 reigster
    
    # We also have to restore the return address
    lw $ra, 24($sp)
    
    # Then we have to deallocate the memories we have used
    addi $sp, $sp, 28 # Deallocating the 28 bytes of memories we have used
    
    # And finally we can return to the caller    
    jr $ra

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
