.data
direction: .byte 'Z'
apples: .byte 1 2 2 9 0 5 1 7 6 10 3 10 3 11 2 10 2 1 2 4 2 5 1 13
apples_length: .word 12
.align 2
state:
.byte 5  # num_rows
.byte 12  # num_cols
.byte 2  # head_row
.byte 4  # head_col
.byte 7  # length
# Game grid:
.asciiz ".............a.#....#......#12..#......#.3..#........4567..."


.text
.globl main
main:
la $a0, state
lbu $a1, direction
la $a2, apples
lw $a3, apples_length
jal move_snake

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

li $v0, 1
la $t0, state
addi $t0, $t0, 4
lb $a0, 0($t0)
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
