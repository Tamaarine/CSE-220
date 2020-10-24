.data
direction: .byte 'L'
.align 2
state:
.byte 5  # num_rows
.byte 12  # num_cols
.byte 1  # head_row
.byte 5  # head_col
.byte 35  # length
# Game grid:
.asciiz "VUTSRQPO....Wa.#.1.NKJEDX..#.2.MLIFCY..#.3..#HGBZ....456789A"

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


la $a0, state
lbu $a1, direction
jal increase_snake_length
# You must write your own code here to check the correctness of the function implementation.
# Printing the return value first
move $a0, $v0
li $v0, 1
syscall

li $v0, 11
li $a0, '\n'
syscall

la $t0, state
addi $t0, $t0, 5
move $a0, $t0
li $v0, 4
syscall


li $v0, 10
syscall

.include "hwk3.asm"
