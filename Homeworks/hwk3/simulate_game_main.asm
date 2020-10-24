.data
filename: .asciiz "game03.txt"
directions: .asciiz "DDLLLLLUUUUUURRRRRDDDDDDDRRRRRRRRUUUUUUULLLLLDDDDDDDDDD"
apples_length: .word 60
num_moves_to_execute: .word 500
apples: .byte 91 0 90 0 89 0 88 0 87 0 86 0 85 0 84 0 83 0 82 0 81 0 80 0 79 0 78 0 76 0 75 0 74 0 72 0 71 0 70 0 69 0 68 0 67 0 66 0 65 0 64 0 3 5 4 5 5 5 6 5 7 5 7 6 7 8 7 9 7 10 7 11 7 12 7 13 6 13 5 13 4 13 3 13 2 13 1 13 0 13 0 12 0 11 0 10 0 9 1 9 2 9 3 9 4 9 5 9 3 4 4 4 8 1 2 3 3 0 2 0 3 2 9 4 9 2 3 3 1 0 6 3 6 3 10 0 0 3 9 1 7 3 0 3 7 2 1 0 7 1 9 1 3 2 8 1 1 3 8 1 10 0 1 3 11 1 6 4 11
.align 2
state: .byte 0x05 0x0c 0x2a 0x36 0x77
.asciiz "NwpHO6lB06DyizI7T8RouKDE8mBAkKsWuxlOalCcJtWMmpAoFeazGmXUXK2r"

.text
.globl main
main:
la $a0, state
la $a1, filename
la $a2, directions
lw $a3, num_moves_to_execute
addi $sp, $sp, -8
la $t0, apples
sw $t0, 0($sp)
lw $t0, apples_length
sw $t0, 4($sp)
li $t0, 123920  # putting garbage in $t0
jal simulate_game
addi $sp, $sp, 8

# You must write your own code here to check the correctness of the function implementation.
move $t0, $v0
move $t1, $v1

li $v0, 1
move $a0, $t0
syscall

li $v0, 11
li $a0, ' '
syscall

li $v0, 1
move $a0, $t1
syscall

li $v0, 11
li $a0, '\n'
syscall



li $v0, 10
syscall

.include "hwk3.asm"
