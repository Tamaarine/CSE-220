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