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
