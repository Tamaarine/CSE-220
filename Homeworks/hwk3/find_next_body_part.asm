.data
row: .byte 3
col: .byte 4
target_part: .byte '.'
.align 2
state:
.byte 5  # num_rows
.byte 12  # num_cols
.byte 1  # head_row
.byte 5  # head_col
.byte 7  # length
# Game grid:
.asciiz ".............a.#.1..#......#.2..#......#.3..#........4567..."

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
lb $a1, row
lb $a2, col
lbu $a3, target_part
jal find_next_body_part


# You must write your own code here to check the correctness of the function implementation.
# $v0 and $v1 have our row and col return value
move $t0, $v0
move $t1, $v1

li $v0, 1
move $a0, $t0
syscall

li $v0, 11
li $a0, '\n'
syscall

li $v0, 1
move $a0, $t1
syscall

li $v0, 10
syscall

.include "hwk3.asm"
