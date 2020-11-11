# Get the last card in the list
.data
index: .word -1
.align 2
card_list:
.word 1  # list's size
.word node930524 # address of list's head
node930524:
.word 6574898
.word 0


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
lw $a1, index
jal get_card

# Write code to check the correctness of your code!
move $t0, $v0
move $t1, $v1

# Here we print whether the card is face up or face down
move $a0, $t0
li $v0, 1
syscall

# Space
li $a0, ' '
li $v0, 11
syscall

# We print the actual card value
move $a0, $t1
li $v0, 1
syscall


li $v0, 10
syscall

.include "hwk5.asm"
