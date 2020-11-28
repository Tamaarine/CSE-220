# Append an item to a short list
.data
card_num: .word 6570809
.align 2
card_list:
.word 5  # list's size
.word node537691 # address of list's head
node299116:
.word 7689011
.word 0
node411020:
.word 6572086
.word node171407
node537691:
.word 6574898
.word node253109
node171407:
.word 7684917
.word node299116
node253109:
.word 7685168
.word node411020

.text
.globl main
main:
li $s0, 699
li $s1, 699
li $s2, 699
li $s3, 699
li $s4, 699
li $s5, 699
li $s6, 699
li $s7, 699

la $a0, card_list
jal print_card_in_card_list

la $a0, card_list
lw $a1, card_num
jal append_card

la $a0, card_list
jal print_card_in_card_list


# Write code to check the correctness of your code!
# Print the size
move $a0, $v0
li $v0,1
syscall

li $v0, 10
syscall

.include "hwk5.asm"
