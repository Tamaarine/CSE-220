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

    # I must write a method to check the cards that is in each list
    lw $a0, 0($s0) # Column =0
    jal print_card_in_card_list
    
    lw $a0, 4($s0) # Column 1
    jal print_card_in_card_list
    
    lw $a0, 8($s0) # Column 2
    jal print_card_in_card_list
    
    lw $a0, 12($s0) # Column 3
    jal print_card_in_card_list
    
    lw $a0, 16($s0) # Column 4
    jal print_card_in_card_list
    
    lw $a0, 20($s0) # Column 5
    jal print_card_in_card_list
    
    lw $a0, 24($s0) # Column 6
    jal print_card_in_card_list
    
    lw $a0, 28($s0) # Column 7
    jal print_card_in_card_list
    
    lw $a0, 32($s0) # Column 8
    jal print_card_in_card_list
    
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
    
        # Now we are here then that means we have to actually print the
        # card value that is inside the currNode pointer
        # Let's get the card value and put it into $t3
        lw $t3, 0($t0)
        
        # We print it
        move $a0, $t3
        li $v0, 34
        syscall
        
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
