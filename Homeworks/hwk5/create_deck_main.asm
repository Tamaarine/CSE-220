.text
.globl main
main:
jal create_deck

# Write code to check the correctness of your code!
move $a0, $v0
li $v0, 1
syscall

jal print_card_in_card_list

li $v0, 10
syscall

.include "hwk5.asm"
