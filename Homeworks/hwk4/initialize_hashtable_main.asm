# Hashtable of Book objects
.data
.align 2
capacity: .word -3
element_size: .word 68
hashtable:
.word 1745499 # capacity
.word 92751585 # size
.word 14266421 # element_size




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

la $a0, hashtable
lw $a1, capacity
lw $a2, element_size
jal initialize_hashtable

# Write code to check the correctness of your code!
move $a0, $v0
li $v0, 1
syscall

li $a0, '\n'
li $v0, 11
syscall

# Print the capacity
la $t0, hashtable
lw $a0, 0($t0)
li $v0, 1
syscall

li $a0, ' '
li $v0, 11
syscall


# Print the size
la $t0, hashtable
lw $a0, 4($t0)
li $v0, 1
syscall

li $a0, ' '
li $v0, 11
syscall

# Print the element_size
la $t0, hashtable
lw $a0, 8($t0)
li $v0, 1
syscall

li $a0, ' '
li $v0, 11
syscall





# Exit
li $v0, 10
syscall

.include "hwk4.asm"
