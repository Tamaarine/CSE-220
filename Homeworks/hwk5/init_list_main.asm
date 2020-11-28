.data
card_list: .word 123123121 14472030  # garbage

.text
.globl main
main:
la $a0, card_list
jal init_list


# Write code to check the correctness of your code!
la $t0, card_list # Load in the address

# We print the size
lw $a0, 0($t0)
li $v0, 1
syscall

li $a0, ' '
li $v0, 11
syscall

# Print the head's address
lw $a0, 4($t0)
li $v0, 1
syscall


li $v0, 10
syscall

.include "hwk5.asm"
