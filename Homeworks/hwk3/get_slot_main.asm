.data
row: .byte 0
col: .byte 8
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
jal get_slot

# You must write your own code here to check the correctness of the function implementation.
# If we are here $v0 contain the ascii character we are suppose to get
move $a0, $v0

# We print it
li $v0, 11
syscall


li $v0, 10
syscall

.include "hwk3.asm"
