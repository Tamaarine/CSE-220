.data
apples1: .byte -1 -1 -1 4 4 3
apples_length1: .word 3

apples2: .byte 2 5 3 5 1 4 4 3 2 9
apples_length2: .word 5

apples3: .byte 1 12 3 -5 -1 -1 -1 -1 4 1 -4 3 -1 -1
apples_length3: .word 7

apples4: .byte 0 -1 0 -1 0 -1 4 -1 11 4 17 7 4 11
apples_length4: .word 7

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
la $a1, apples4
lw $a2, apples_length4
jal place_next_apple

# You must write your own code here to check the correctness of the function implementation.
# $v0 and $v1 contain our row and col that we put our apple, let's print it
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
