.data
direction: .byte 'D'
tail_row: .byte 1
tail_col: .byte 9
.align 2
state:
.byte 5  # num_rows
.byte 12  # num_cols
.byte 1  # head_row
.byte 5  # head_col
.byte 15 # length
# Game grid:
.asciiz ".........ED..a.#.1..#FC....#.2..#.B....#.3..#9A......45678.."

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
lb $a2, tail_row
lb $a3, tail_col
jal add_tail_segment


# You must write your own code here to check the correctness of the function implementation.
move $a0, $v0
li $v0, 1
syscall

li $a0, '\n'
li $v0, 11
syscall

la $t0, state
addi $t0, $t0, 5
move $a0, $t0
li $v0, 4
syscall

li $a0, '\n'
li $v0, 11
syscall

la $t0, state
addi $t0, $t0, 4
lb $a0, 0($t0)
li $v0, 1
syscall


li $v0, 10
syscall

.include "hwk3.asm"
