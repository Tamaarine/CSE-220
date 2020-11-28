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

jal create_deck

move $t0, $v0

# Write code to check the correctness of your code!
move $a0, $v0
li $v0, 1
syscall

li $a0, '\n'
li $v0, 11
syscall

move $a0, $t0
jal print_card_in_card_list

li $v0, 10
syscall

.include "hwk5.asm"
